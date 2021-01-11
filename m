Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26029C43217
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2AA622DFA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403822AbhALAZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404049AbhAKXX1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6118422D08;
        Mon, 11 Jan 2021 23:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407366;
        bh=d3m+kqbInfCDqFDLeOn+bAGaNYfEDlp+cTagcRZ+gKM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OgxgYSLj5+PsBvA0/7idp5lJ6W2iQw8Zi7Q+UBe9/0D6j7CtNMCWGJEI1/pLLl6PN
         KWuTppIVFJhfSCe/Jtcif3W5td90P7uD6xEtybx/bMqCxtv+J8k9Y3Y7uX2M3cFEqc
         VQG79jYB1LzrtG3uKPM4XINoeuvgJo2gtEm31NbUelit4uOhg5TxDhj+8vGOTC4I3d
         +c7YpT15s9llCzU9Y1aEynh6Xe23IlIU/G5596SATbY9MjOXZyPTFh0intSPKoLmHn
         hD0/O8yetA234emIVouwhDOutz7aq2nlUJNJ0f9texSSEKhgfTN8KHr0PO4m+JuHSe
         ey3WqHWN2Kf1g==
Subject: [PATCH 2/6] xfs: refactor messy xfs_inode_free_quota_* functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:22:46 -0800
Message-ID: <161040736645.1582114.5611056362119068032.stgit@magnolia>
In-Reply-To: <161040735389.1582114.15084485390769234805.stgit@magnolia>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The functions to run an eof/cowblocks scan to try to reduce quota usage
are kind of a mess -- the logic repeatedly initializes an eofb structure
and there are logic bugs in the code that result in the cowblocks scan
never actually happening.

Replace all three functions with a single function that fills out an
eofb if we're low on quota and runs both eof and cowblocks scans.

Fixes: 83104d449e8c4 ("xfs: garbage collect old cowextsz reservations")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |   15 ++++++---------
 fs/xfs/xfs_icache.c |   46 ++++++++++++++++------------------------------
 fs/xfs/xfs_icache.h |    4 ++--
 3 files changed, 24 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..5d5cf25668b5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -652,7 +652,7 @@ xfs_file_buffered_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	int			enospc = 0;
+	bool			cleared_space = false;
 	int			iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
@@ -684,19 +684,16 @@ xfs_file_buffered_aio_write(
 	 * also behaves as a filter to prevent too many eofblocks scans from
 	 * running at the same time.
 	 */
-	if (ret == -EDQUOT && !enospc) {
+	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		enospc = xfs_inode_free_quota_eofblocks(ip);
-		if (enospc)
-			goto write_retry;
-		enospc = xfs_inode_free_quota_cowblocks(ip);
-		if (enospc)
+		cleared_space = xfs_inode_free_quota_blocks(ip);
+		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
-	} else if (ret == -ENOSPC && !enospc) {
+	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_eofblocks eofb = {0};
 
-		enospc = 1;
+		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e6d704a30b29..66af84c578b5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1416,33 +1416,31 @@ xfs_icache_free_eofblocks(
 }
 
 /*
- * Run eofblocks scans on the quotas applicable to the inode. For inodes with
- * multiple quotas, we don't know exactly which quota caused an allocation
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-static int
-__xfs_inode_free_quota_eofblocks(
-	struct xfs_inode	*ip,
-	int			(*execute)(struct xfs_mount *mp,
-					   struct xfs_eofblocks	*eofb))
+bool
+xfs_inode_free_quota_blocks(
+	struct xfs_inode	*ip)
 {
-	int scan = 0;
-	struct xfs_eofblocks eofb = {0};
-	struct xfs_dquot *dq;
+	struct xfs_eofblocks	eofb = {0};
+	struct xfs_dquot	*dq;
+	bool			do_work = false;
 
 	/*
 	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_uid = VFS_I(ip)->i_uid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
@@ -1451,21 +1449,16 @@ __xfs_inode_free_quota_eofblocks(
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_gid = VFS_I(ip)->i_gid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
-	if (scan)
-		execute(ip->i_mount, &eofb);
+	if (!do_work)
+		return false;
 
-	return scan;
-}
-
-int
-xfs_inode_free_quota_eofblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
+	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return true;
 }
 
 static inline unsigned long
@@ -1665,13 +1658,6 @@ xfs_icache_free_cowblocks(
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
-int
-xfs_inode_free_quota_cowblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
-}
-
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 0d9f1b5d112c..b94a94e9a7a6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -49,17 +49,17 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 

