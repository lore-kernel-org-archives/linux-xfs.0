Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1069CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825C3214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQ3ufwiX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJ0O4I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37592 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Umu1EgiXaWMGjNc/xlGkKxULhxinjnaCtwIQ1AP2D+w=; b=UQ3ufwiX0MwHKkqCHjwnlXfFyk
        Ps7GYKD+QmOWBqFl57mXm+DipwzRXyzasjcBEYGOKJq+HqR79lH5UgnXN3UQJHg60VoAfjQqrpOOj
        Cye7FA+Dgcd3T9Wc5NCPV/LGL/FlvF5p/YVY2MoFnrGlQUjXJEVUFwcuSWb696uRIPrCWvvk+cMN3
        n/TGGglXZPW4zTo+PAvh7c5nj/BBPiVYEH6UOoYYuw7Vyy3BJaqCImZmiAqNLV3RW7kYBfR8TGWTY
        LfgjYtpU/X//nE/sRZ+RL1w+2/dIJCkz5CcCHEQqRjEReCSP7Spqoyokx+Dgzeq4yPh7+OC4Nbxjl
        EtBu7Sww==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxf-0005NZ-5I; Sun, 27 Oct 2019 14:56:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 06/12] xfs: rename the m_writeio_* fields in struct xfs_mount
Date:   Sun, 27 Oct 2019 15:55:41 +0100
Message-Id: <20191027145547.25157-7-hch@lst.de>
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

Use the allocsize name to match the mount option and usage instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 16 ++++++++--------
 fs/xfs/xfs_iops.c  |  2 +-
 fs/xfs/xfs_mount.c |  8 ++++----
 fs/xfs/xfs_mount.h |  4 ++--
 fs/xfs/xfs_super.c |  4 ++--
 fs/xfs/xfs_trace.h |  2 +-
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4af50b101d2b..64bd30a24a71 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -29,8 +29,8 @@
 #include "xfs_reflink.h"
 
 
-#define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
-						<< mp->m_writeio_log)
+#define XFS_ALLOC_ALIGN(mp, off) \
+	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
 
 static int
 xfs_alert_fsblock_zero(
@@ -391,7 +391,7 @@ xfs_iomap_prealloc_size(
 		return 0;
 
 	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
-	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_writeio_blocks)))
+	    (XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_allocsize_blocks)))
 		return 0;
 
 	/*
@@ -402,7 +402,7 @@ xfs_iomap_prealloc_size(
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
 	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
-		return mp->m_writeio_blocks;
+		return mp->m_allocsize_blocks;
 
 	/*
 	 * Determine the initial size of the preallocation. We are beyond the
@@ -495,10 +495,10 @@ xfs_iomap_prealloc_size(
 	while (alloc_blocks && alloc_blocks >= freesp)
 		alloc_blocks >>= 4;
 check_writeio:
-	if (alloc_blocks < mp->m_writeio_blocks)
-		alloc_blocks = mp->m_writeio_blocks;
+	if (alloc_blocks < mp->m_allocsize_blocks)
+		alloc_blocks = mp->m_allocsize_blocks;
 	trace_xfs_iomap_prealloc_size(ip, alloc_blocks, shift,
-				      mp->m_writeio_blocks);
+				      mp->m_allocsize_blocks);
 	return alloc_blocks;
 }
 
@@ -962,7 +962,7 @@ xfs_buffered_write_iomap_begin(
 			xfs_off_t	end_offset;
 			xfs_fileoff_t	p_end_fsb;
 
-			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
+			end_offset = XFS_ALLOC_ALIGN(mp, offset + count - 1);
 			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
 					prealloc_blocks;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 271fcbe04d48..382d72769470 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -514,7 +514,7 @@ xfs_stat_blksize(
 		if (mp->m_swidth)
 			return mp->m_swidth << mp->m_sb.sb_blocklog;
 		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
-			return 1U << mp->m_writeio_log;
+			return 1U << mp->m_allocsize_log;
 	}
 
 	return PAGE_SIZE;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 359fcfb494d4..1853797ea938 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -440,13 +440,13 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
 	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
 		writeio_log = XFS_WRITEIO_LOG_LARGE;
 	else
-		writeio_log = mp->m_writeio_log;
+		writeio_log = mp->m_allocsize_log;
 
 	if (sbp->sb_blocklog > writeio_log)
-		mp->m_writeio_log = sbp->sb_blocklog;
+		mp->m_allocsize_log = sbp->sb_blocklog;
 	} else
-		mp->m_writeio_log = writeio_log;
-	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
+		mp->m_allocsize_log = writeio_log;
+	mp->m_allocsize_blocks = 1 << (mp->m_allocsize_log - sbp->sb_blocklog);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fba818d5c540..109081c16a07 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -98,8 +98,8 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_writeio_log;	/* min write size log bytes */
-	uint			m_writeio_blocks; /* min write size blocks */
+	uint			m_allocsize_log;/* min write size log bytes */
+	uint			m_allocsize_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
 	struct xlog		*m_log;		/* log specific stuff */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a477348ab68b..d1a0958f336d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -405,7 +405,7 @@ xfs_parseargs(
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_writeio_log = iosizelog;
+		mp->m_allocsize_log = iosizelog;
 	}
 
 	return 0;
@@ -456,7 +456,7 @@ xfs_showargs(
 
 	if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
 		seq_printf(m, ",allocsize=%dk",
-				(int)(1 << mp->m_writeio_log) >> 10);
+				(int)(1 << mp->m_allocsize_log) >> 10);
 
 	if (mp->m_logbufs > 0)
 		seq_printf(m, ",logbufs=%d", mp->m_logbufs);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 926f4d10dc02..c13bb3655e48 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -725,7 +725,7 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
 		__entry->writeio_blocks = writeio_blocks;
 	),
 	TP_printk("dev %d:%d ino 0x%llx prealloc blocks %llu shift %d "
-		  "m_writeio_blocks %u",
+		  "m_allocsize_blocks %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->ino,
 		  __entry->blocks, __entry->shift, __entry->writeio_blocks)
 )
-- 
2.20.1

