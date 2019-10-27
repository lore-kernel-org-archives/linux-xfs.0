Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 191D4CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E085B21726
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jxp4jN7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfJ0O4N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W0aE0/kYStdAore5JQ7IHLI7PfZWVFuP3C7X8M9JlW0=; b=Jxp4jN7EclKpRLuwmDKGbTNBla
        GbxQ28Fk5AcZ0ADry2lrz0IrrR+BuiIDKgHlpNKAfl6oZs2Ome9sfq0YghVtX2V/Wtyitje9pJRl+
        xAMQtOwyoSXxGUtCulaK4lz6ZtaLq48Cbbf886ohCYxaypzgnDRpZT5oZQEDIJxCdxlkbCR5IttpH
        F24Yht4IQeOrFgDvEzE1voAdXvKLf+W5JkVxVggDV53IhhRe0Lw/br9Lio/ipIrUarp5bT+AEYg6h
        iWaMThsTNahMaS4pDnHac53cvkLoPO+Mx8Qh1I93u5u8mPqj1Wsi1H5AcdiT0+q9vUtebNgo+3crQ
        4/vnNi/A==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxk-0005OM-PG; Sun, 27 Oct 2019 14:56:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 08/12] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to XFS_MOUNT_ALLOCISZE
Date:   Sun, 27 Oct 2019 15:55:43 +0100
Message-Id: <20191027145547.25157-9-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027145547.25157-1-hch@lst.de>
References: <20191027145547.25157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make the flag match the mount option and usage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 fs/xfs/xfs_iops.c  | 2 +-
 fs/xfs/xfs_mount.h | 2 +-
 fs/xfs/xfs_super.c | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 64bd30a24a71..3c2098f1ded0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -390,7 +390,7 @@ xfs_iomap_prealloc_size(
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
 
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
+	if (!(mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
 	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
 		return 0;
 
@@ -398,7 +398,7 @@ xfs_iomap_prealloc_size(
 	 * If an explicit allocsize is set, the file is small, or we
 	 * are writing behind a hole, then use the minimum prealloc:
 	 */
-	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
+	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
 	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 382d72769470..9e1f89cdcc82 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -513,7 +513,7 @@ xfs_stat_blksize(
 	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
 		if (mp->m_swidth)
 			return mp->m_swidth << mp->m_sb.sb_blocklog;
-		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
 			return 1U << mp->m_allocsize_log;
 	}
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 712dbb2039cd..e5c364f1605e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -227,7 +227,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
 #define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
-#define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
+#define XFS_MOUNT_ALLOCSIZE	(1ULL << 12)	/* specified allocation size */
 #define XFS_MOUNT_SMALL_INUMS	(1ULL << 14)	/* user wants 32bit inodes */
 #define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
 #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3e5002d2a79e..a7d89b87ed22 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -228,7 +228,7 @@ xfs_parseargs(
 			if (suffix_kstrtoint(args, 10, &size))
 				return -EINVAL;
 			mp->m_allocsize_log = ffs(size) - 1;
-			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
+			mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
 			break;
 		case Opt_grpid:
 		case Opt_bsdgroups:
@@ -396,7 +396,7 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
+	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
 	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
 	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
 		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
@@ -450,7 +450,7 @@ xfs_showargs(
 			seq_puts(m, xfs_infop->str);
 	}
 
-	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+	if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
 		seq_printf(m, ",allocsize=%dk",
 				(int)(1 << mp->m_allocsize_log) >> 10);
 
-- 
2.20.1

