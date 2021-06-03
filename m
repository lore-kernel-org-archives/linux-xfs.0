Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3322C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA33B613E9
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhFCDOg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD33361360;
        Thu,  3 Jun 2021 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689972;
        bh=MZCMSzrWuVJnAZStmaDiVU5iIZg/5Xv3dWJkNNyUlxM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mPGIeZ6VJMFGLu1YkOiz/kXmGOf7cFBSs787r2YXGPMjZ95wxfOHpB9i1Y9PTW1ZH
         Zw5T8hC+ErKan71ccURR/pHsPHxHpuf2CFpWMdVneVF9o/ah/MGBPDGqm7KIzktlxf
         fhNbquUt73oVuZreTsd5ppcVqd04Ce/KF8FLObWKRXiB+CDDw62EMhGNqJyR9BqQvG
         S55D/z0eBsWqQrn0v1bRSVG0ExccCLuhK6tkcQ06OQyQy7AB0JvrbFJ/MXGfIvWvGc
         PEiaHhwy+A1CQBZu5bY9scX1jO+JwvXzrnNkgCLsu4WCZk3bOjO7ftzE8FVm9jkUnd
         WJivOCiPJyvxg==
Subject: [PATCH 3/3] xfs: don't let background reclaim forget sick inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 02 Jun 2021 20:12:52 -0700
Message-ID: <162268997239.2724138.6026093150916734925.stgit@locust>
In-Reply-To: <162268995567.2724138.15163777746481739089.stgit@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's important that the filesystem retain its memory of sick inodes for
a little while after problems are found so that reports can be collected
about what was wrong.  Don't let background inode reclamation free sick
inodes unless we're under memory pressure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0e2b6c05e604..54285d1ad574 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -911,7 +911,8 @@ xfs_dqrele_all_inodes(
  */
 static bool
 xfs_reclaim_igrab(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -922,6 +923,17 @@ xfs_reclaim_igrab(
 		spin_unlock(&ip->i_flags_lock);
 		return false;
 	}
+
+	/*
+	 * Don't reclaim a sick inode unless we're under memory pressure or the
+	 * filesystem is unmounting.
+	 */
+	if (ip->i_sick && eofb == NULL &&
+	    !(ip->i_mount->m_flags & XFS_MOUNT_UNMOUNTING)) {
+		spin_unlock(&ip->i_flags_lock);
+		return false;
+	}
+
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	return true;
@@ -1606,7 +1618,8 @@ xfs_blockgc_free_quota(
 static inline bool
 xfs_icwalk_igrab(
 	enum xfs_icwalk_goal	goal,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
 {
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
@@ -1614,7 +1627,7 @@ xfs_icwalk_igrab(
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
-		return xfs_reclaim_igrab(ip);
+		return xfs_reclaim_igrab(ip, eofb);
 	default:
 		return false;
 	}
@@ -1703,7 +1716,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip))
+			if (done || !xfs_icwalk_igrab(goal, ip, eofb))
 				batch[i] = NULL;
 
 			/*

