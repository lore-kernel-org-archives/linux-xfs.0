Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E84BC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E63613DE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhFBW1O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFBW1O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7B8613AC;
        Wed,  2 Jun 2021 22:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672730;
        bh=dhZ40m7VtQM8m0Fp4FbiJKN3GAoem9X0cRUPeIU9Guk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LpLIw7ckI+SfMlUN+dcvnTClFrs8Hl9nIqFYwrn9i66Ev0uLPsjlhqeoofapMNLUp
         4CqYCrq3pRl3xU6itUkj3Nr5pwlFj2gpjMDTaXcegsgcaud45a7PtqWexCkveCJNpG
         aYKp+WZJEEBtCD7/VeH7VFz/k+mxvSLKRVqEtiZxStFWMEXSAKxeuZ8jhpbwgrwiey
         BpAYmdkc1klx30H5mNB5fNTHmnOJQ+nsGJiY0FVvNY6Xx7lYqW9O6p+h3TtPhAwcVs
         frNFKWYL4BhvSyp0qQLwQRhToJ2Ms9q1cNDvs3UuVD1qt3IpELN1owMp+/Q2Nose3T
         hdWvWwT1oK90g==
Subject: [PATCH 06/15] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:30 -0700
Message-ID: <162267273023.2375284.13883230665214658106.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Disentangle the dqrele_all inode grab code from the "generic" inode walk
grabbing code, and and use the opportunity to document why the dqrele
grab function does what it does.  Since xfs_inode_walk_ag_grab is now
only used for blockgc, rename it to reflect that.

Ultimately, there will be four reasons to perform a walk of incore
inodes: quotaoff dquote releasing (dqrele), garbage collection of
speculative preallocations (blockgc), reclamation of incore inodes
(reclaim), and deferred inactivation (inodegc).  Each of these four have
their own slightly different criteria for deciding if they want to
handle an inode, so it makes more sense to have four cohesive igrab
functions than one confusing parameteric grab function like we do now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c6d956406033..45979791313f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -774,6 +774,44 @@ xfs_icache_inode_is_allocated(
 #define XFS_LOOKUP_BATCH	32
 
 #ifdef CONFIG_XFS_QUOTA
+/* Decide if we want to grab this inode to drop its dquots. */
+static bool
+xfs_dqrele_igrab(
+	struct xfs_inode	*ip)
+{
+	bool			ret = false;
+
+	ASSERT(rcu_read_lock_held());
+
+	/* Check for stale RCU freed inode */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock;
+
+	/*
+	 * Skip inodes that are anywhere in the reclaim machinery because we
+	 * drop dquots before tagging an inode for reclamation.
+	 */
+	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
+		goto out_unlock;
+
+	/*
+	 * The inode looks alive; try to grab a VFS reference so that it won't
+	 * get destroyed.  If we got the reference, return true to say that
+	 * we grabbed the inode.
+	 *
+	 * If we can't get the reference, then we know the inode had its VFS
+	 * state torn down and hasn't yet entered the reclaim machinery.  Since
+	 * we also know that dquots are detached from an inode before it enters
+	 * reclaim, we can skip the inode.
+	 */
+	ret = igrab(VFS_I(ip)) != NULL;
+
+out_unlock:
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
+
 /* Drop this inode's dquots. */
 static int
 xfs_dqrele_inode(
@@ -821,6 +859,8 @@ xfs_dqrele_all_inodes(
 	return xfs_icwalk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
 			&eofb, XFS_ICWALK_DQRELE);
 }
+#else
+# define xfs_dqrele_igrab(ip)		(false)
 #endif /* CONFIG_XFS_QUOTA */
 
 /*
@@ -1493,12 +1533,12 @@ xfs_blockgc_start(
 }
 
 /*
- * Decide if the given @ip is eligible to be a part of the inode walk, and
- * grab it if so.  Returns true if it's ready to go or false if we should just
- * ignore it.
+ * Decide if the given @ip is eligible for garbage collection of speculative
+ * preallocations, and grab it if so.  Returns true if it's ready to go or
+ * false if we should just ignore it.
  */
 static bool
-xfs_inode_walk_ag_grab(
+xfs_blockgc_igrab(
 	struct xfs_inode	*ip,
 	int			flags)
 {
@@ -1657,6 +1697,27 @@ xfs_blockgc_free_quota(
 
 /* XFS Inode Cache Walking Code */
 
+/*
+ * Decide if we want to grab this inode in anticipation of doing work towards
+ * the goal.  If selected, the VFS must hold a reference to this inode, which
+ * will be released after processing.
+ */
+static inline bool
+xfs_icwalk_igrab(
+	enum xfs_icwalk_goal	goal,
+	struct xfs_inode	*ip,
+	int			iter_flags)
+{
+	switch (goal) {
+	case XFS_ICWALK_DQRELE:
+		return xfs_dqrele_igrab(ip);
+	case XFS_ICWALK_BLOCKGC:
+		return xfs_blockgc_igrab(ip, iter_flags);
+	default:
+		return false;
+	}
+}
+
 /*
  * For a given per-AG structure @pag, grab, @execute, and rele all incore
  * inodes with the given radix tree @tag.
@@ -1711,7 +1772,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+			if (done || !xfs_icwalk_igrab(goal, ip, iter_flags))
 				batch[i] = NULL;
 
 			/*

