Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C943C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328FC611CB
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 22:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhEaWms (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 18:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhEaWms (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEC8B60FDC;
        Mon, 31 May 2021 22:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500868;
        bh=QMk4en1hpmqqhS2kssR9HBSjeN2L50NQvMy0jDAzg9s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aOkz5q77SHBw0QTn+X6bGSObVAWowesd2dbj2qaxUQyglCZARoogRRel31SIG+dOs
         jgbEgpDQ9myxA57nsisafr3QL1GjwdxwQioMFRAreazNXDP3uw4HF0yIUj2mQZu7zo
         pvcjKrtn4MfBcz9R2DnrzitQMOzNwUuyFYs/yo8rvpOYZBtXv1X+B1Un+TQQNwa2jY
         GEmPyOu+umXM6M92fAIGkC6wxtoQRtpdC2wvvEK7OjsiYDZs2nTqOaTvYricZ2eDkn
         lrnL6xqri2RtoFQTDLhZjJ1k9AV9lJCbbW47z1b68JVI/JrRXucGOqfXXZZML3oW9q
         KKGazzshrxslA==
Subject: [PATCH 3/5] xfs: separate the dqrele_all inode grab logic from
 xfs_inode_walk_ag_grab
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:41:07 -0700
Message-ID: <162250086766.490412.9229536536315438431.stgit@locust>
In-Reply-To: <162250085103.490412.4291071116538386696.stgit@locust>
References: <162250085103.490412.4291071116538386696.stgit@locust>
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
grab function does what it does.

Since dqrele_all is the only user of XFS_ICI_NO_TAG, rename it to
something more specific for what we're doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.h |    4 ++-
 2 files changed, 62 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 34b8b5fbd60d..5501318b5db0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,8 @@
 
 #include <linux/iversion.h>
 
+static bool xfs_dqrele_inode_grab(struct xfs_inode *ip);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -765,6 +767,22 @@ xfs_inode_walk_ag_grab(
 	return false;
 }
 
+static inline bool
+xfs_grabbed_for_walk(
+	int			tag,
+	struct xfs_inode	*ip,
+	int			iter_flags)
+{
+	switch (tag) {
+	case XFS_ICI_BLOCKGC_TAG:
+		return xfs_inode_walk_ag_grab(ip, iter_flags);
+	case XFS_ICI_DQRELE_NONTAG:
+		return xfs_dqrele_inode_grab(ip);
+	default:
+		return false;
+	}
+}
+
 /*
  * For a given per-AG structure @pag, grab, @execute, and rele all incore
  * inodes with the given radix tree @tag.
@@ -796,7 +814,7 @@ xfs_inode_walk_ag(
 
 		rcu_read_lock();
 
-		if (tag == XFS_ICI_NO_TAG)
+		if (tag == XFS_ICI_DQRELE_NONTAG)
 			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
 					(void **)batch, first_index,
 					XFS_LOOKUP_BATCH);
@@ -818,7 +836,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+			if (done || !xfs_grabbed_for_walk(tag, ip, iter_flags))
 				batch[i] = NULL;
 
 			/*
@@ -881,7 +899,7 @@ xfs_inode_walk_get_perag(
 	xfs_agnumber_t		agno,
 	int			tag)
 {
-	if (tag == XFS_ICI_NO_TAG)
+	if (tag == XFS_ICI_DQRELE_NONTAG)
 		return xfs_perag_get(mp, agno);
 	return xfs_perag_get_tag(mp, agno, tag);
 }
@@ -917,6 +935,44 @@ xfs_inode_walk(
 	return last_error;
 }
 
+/* Decide if we want to grab this inode to drop its dquots. */
+static bool
+xfs_dqrele_inode_grab(
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
@@ -964,7 +1020,7 @@ xfs_dqrele_all_inodes(
 		eofb.eof_flags |= XFS_EOFB_DROP_PDQUOT;
 
 	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&eofb, XFS_ICI_NO_TAG);
+			&eofb, XFS_ICI_DQRELE_NONTAG);
 }
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 77029e92ba4c..fcfcdad7f977 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -29,8 +29,8 @@ struct xfs_eofblocks {
 /*
  * tags for inode radix tree
  */
-#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
-					   in xfs_inode_walk */
+#define XFS_ICI_DQRELE_NONTAG	(-1)	/* quotaoff dqdetach inode walk uses
+					   untagged lookups */
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1

