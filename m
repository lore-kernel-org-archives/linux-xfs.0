Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15B8C43381
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980DF64E03
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhA2CSP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231450AbhA2CSI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:18:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3E864E07;
        Fri, 29 Jan 2021 02:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886672;
        bh=Si8vMX+OQoXDakQd/gkDqMFJIdBapgrQcjGopok50C8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cghn1hHJGWaCnAIObtGkZ3u7/yWQbJbszt8YnXrUO37jvwcOwAyo6oyNy5SYweu4y
         nJc2H+sbHJxdOkmr3E0P+imEANeZ98KqD8y90LTpV36hzMwZZz47OKvvoiHI/DAY09
         rcB8trWqoivXVdpyNVOJieSP8L0HTUpEeSx3joR4MUPPgcC7k/+hTLqsHx7C9d/oVf
         hSl3SHWbK8plFYSoppKLC7Zu+484jzcqjmF4SdusXlwUziYUtFpib7yWtCtQ40TE+0
         DYIHoWsgAGTlQUCVmcLNrnuPdqiJPaMOqTQn0diIOQs7nU4065KIbUe2PJoHrdFegz
         /JffP+3WiooGA==
Subject: [PATCH 01/12] xfs: trigger all block gc scans when low on quota space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:17:52 -0800
Message-ID: <161188667210.1943978.14517115689976313523.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
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
eofb and runs both eof and cowblocks scans.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   |   15 ++++++---------
 fs/xfs/xfs_icache.c |   46 ++++++++++++++++------------------------------
 fs/xfs/xfs_icache.h |    4 ++--
 3 files changed, 24 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5d4a66c72c78..69879237533b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -713,7 +713,7 @@ xfs_file_buffered_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	int			enospc = 0;
+	bool			cleared_space = false;
 	int			iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
@@ -745,19 +745,16 @@ xfs_file_buffered_write(
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
index deb99300d171..c71eb15e3835 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1397,33 +1397,31 @@ xfs_icache_free_eofblocks(
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
 
@@ -1432,21 +1430,16 @@ __xfs_inode_free_quota_eofblocks(
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
@@ -1646,13 +1639,6 @@ xfs_icache_free_cowblocks(
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
index 3a4c8b382cd0..3f7ddbca8638 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,17 +54,17 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
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
 

