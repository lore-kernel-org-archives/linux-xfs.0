Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6F1C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F982063A
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 12:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qPs56qiR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDCMz0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 08:55:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCMzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 08:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=uQtHPGcLK8G/i9QFhaX7eMgaanZTM+avGS/SdTNWqbw=; b=qPs56qiRIw99372wsPz5mbCvln
        6PvK12Xiu/3DManmm5lVM6tUQlfjrqcl1wEa1KDfwwe19m1JSJGoeRmReGu0h8tHHGI+CeBYTnUq6
        qtTM9Z37kmeGdqr5bLUs4ly4XLPTKFM+9vHdtbRnGapS3ddZVve9LW+rwaQXVIIHbta/DpF4XNSfb
        rxGPh4PJZaBPpNsxBhlsrol+40WRTyGa3rDzJ0VyrnW1pTKGPVR0SPd4CY6Rv6ECT6r6qrEXphKdy
        Tx19P8Xg8ZuQtBQK5VeoCnb252pTZtPW3r0qp8kExBnuNREFOh2pxMv+bJGLA4lMLVIhgFLIs1XDt
        00rAcx8A==;
Received: from 089144198148.atnat0007.highway.a1.net ([89.144.198.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jKLr3-0002rA-8T
        for linux-xfs@vger.kernel.org; Fri, 03 Apr 2020 12:55:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: factor out a new xfs_log_force_inode helper
Date:   Fri,  3 Apr 2020 14:55:21 +0200
Message-Id: <20200403125522.450299-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create a new helper to force the log up to the last LSN touching an
inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_export.c | 14 +-------------
 fs/xfs/xfs_file.c   | 12 +-----------
 fs/xfs/xfs_inode.c  | 19 +++++++++++++++++++
 fs/xfs/xfs_inode.h  |  1 +
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f1372f9046e3..5a4b0119143a 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -15,7 +15,6 @@
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
-#include "xfs_log.h"
 #include "xfs_pnfs.h"
 
 /*
@@ -221,18 +220,7 @@ STATIC int
 xfs_fs_nfs_commit_metadata(
 	struct inode		*inode)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(XFS_I(inode));
 }
 
 const struct export_operations xfs_export_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8a4a3f29b36..68e1cbb3cfcc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,19 +80,9 @@ xfs_dir_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_dir_fsync(ip);
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(ip);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..e48fc835cb85 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3951,3 +3951,22 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Ensure all commited transactions touching the inode are written to the log.
+ */
+int
+xfs_log_force_inode(
+	struct xfs_inode	*ip)
+{
+	xfs_lsn_t		lsn = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!lsn)
+		return 0;
+	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..c6a63f6764a6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -426,6 +426,7 @@ int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
+int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-- 
2.25.1

