Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF0BCA9EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3122B2070B
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 17:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gphz0dgN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505951AbfJYRlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 13:41:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfJYRlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BmdgWnXhg54x12ACGaLzapvo9cop4qOVKtNUAxo0cBo=; b=gphz0dgNF/+i6JeeqoJX/y1FPl
        b9WDXrD3Mf8o8TQsn08kNLwcO7D5iCQmi5T1uhNe5ZxMJnb2DegDs0xmoreU7yj0t3SoQAOAj3z6Z
        43uPJ+IDHwsJ1cF3mAHjiVIZ3gWbCybRsz164Y5Wq/NJp2/Zii4c6xPjDHTZDbWl1mJeyFAUWBi1M
        I+wa69joumSG89lb2uvbEKSrCCUlvcy2rbF+PUwbVoSf+rC7R5xYorcXL7yyoqhNzaEpuADBg848S
        rZgDNaWJWmvUUi7JQ/HwQ9oNCIDg/XlqHWNKGtkOYQuvGyJStpmgnhlfLC8EQHHTm6bgmh2m7NF3L
        IB5glk9A==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3aM-0005Yg-0j; Fri, 25 Oct 2019 17:41:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 3/7] xfs: remove the m_readio_log field from struct xfs_mount
Date:   Fri, 25 Oct 2019 19:40:22 +0200
Message-Id: <20191025174026.31878-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025174026.31878-1-hch@lst.de>
References: <20191025174026.31878-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The m_readio_log is only used for reporting the blksize (aka preferred
I/O size) in struct stat.  For all cases but a file system that does not
use stripe alignment, but which has the wsync and largeio mount option
set the value is the same as the write I/O size.

Remove the field and report a smaller preferred I/O size for that corner
case, which actually is the right thing to do for that case (except for
the fact that is probably is entirely unused).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c  |  2 +-
 fs/xfs/xfs_mount.c | 17 ++++-------------
 fs/xfs/xfs_mount.h | 15 ++++-----------
 fs/xfs/xfs_super.c |  1 -
 4 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b6dbfd8eb6a1..271fcbe04d48 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -514,7 +514,7 @@ xfs_stat_blksize(
 		if (mp->m_swidth)
 			return mp->m_swidth << mp->m_sb.sb_blocklog;
 		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-			return 1U << max(mp->m_readio_log, mp->m_writeio_log);
+			return 1U << mp->m_writeio_log;
 	}
 
 	return PAGE_SIZE;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 18af97512aec..9800401a7d6f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -435,26 +435,17 @@ STATIC void
 xfs_set_rw_sizes(xfs_mount_t *mp)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
-	int		readio_log, writeio_log;
+	int		writeio_log;
 
 	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
-		if (mp->m_flags & XFS_MOUNT_WSYNC) {
-			readio_log = XFS_WSYNC_READIO_LOG;
-			writeio_log = XFS_WSYNC_WRITEIO_LOG;
-		} else {
-			readio_log = XFS_READIO_LOG_LARGE;
+		if (mp->m_flags & XFS_MOUNT_WSYNC)
+			writeio_log = XFS_WRITEIO_LOG_WSYNC;
+		else
 			writeio_log = XFS_WRITEIO_LOG_LARGE;
-		}
 	} else {
-		readio_log = mp->m_readio_log;
 		writeio_log = mp->m_writeio_log;
 	}
 
-	if (sbp->sb_blocklog > readio_log) {
-		mp->m_readio_log = sbp->sb_blocklog;
-	} else {
-		mp->m_readio_log = readio_log;
-	}
 	if (sbp->sb_blocklog > writeio_log) {
 		mp->m_writeio_log = sbp->sb_blocklog;
 	} else {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ecde5b3828c8..fb3a36a048cc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -98,7 +98,6 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_readio_log;	/* min read size log bytes */
 	uint			m_writeio_log;	/* min write size log bytes */
 	uint			m_writeio_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
@@ -247,10 +246,11 @@ typedef struct xfs_mount {
 
 
 /*
- * Default minimum read and write sizes.
+ * Default minimum write size.  The smaller sync value is better for
+ * NFSv2 wsync file systems.
  */
-#define XFS_READIO_LOG_LARGE	16
-#define XFS_WRITEIO_LOG_LARGE	16
+#define XFS_WRITEIO_LOG_WSYNC	14	/* 16k */
+#define XFS_WRITEIO_LOG_LARGE	16	/* 64k */
 
 /*
  * Max and min values for mount-option defined I/O
@@ -259,13 +259,6 @@ typedef struct xfs_mount {
 #define XFS_MAX_IO_LOG		30	/* 1G */
 #define XFS_MIN_IO_LOG		PAGE_SHIFT
 
-/*
- * Synchronous read and write sizes.  This should be
- * better for NFSv2 wsync filesystems.
- */
-#define	XFS_WSYNC_READIO_LOG	15	/* 32k */
-#define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
-
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0a8cf6b87a21..4ededdbed5a4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -418,7 +418,6 @@ xfs_parseargs(
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
 		mp->m_writeio_log = iosizelog;
 	}
 
-- 
2.20.1

