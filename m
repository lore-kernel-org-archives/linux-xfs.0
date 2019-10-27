Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2E4CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FEA2214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E4hMkVTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJ0Oz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:55:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37566 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0Oz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EObejU4YOGTgRZ2EklTnk7knwQb4Clt8KLIwQrKQzd8=; b=E4hMkVTri4my3Gi6MXroNr2voX
        peqbpFt19ykn2+M8q0xfU7tbczR0lqEFcEI5/xf4Pn0ACxS/8YPJHCxRxaTSjAA26e7KFYSFyfYDG
        SivdVfFtipFUsQsdcsLrR0w23S4T0mwfiV+ftvYpY7NG7ktHuvCouTXyGNkO6DYY+F5KOM9/VG0Mv
        rr4FztiCbWGVhM9Dn/Aocz9Q3e0ioml5ss5WAUwQamW0mF6sNMYcY49ZIrVM88CinDyLKjLJcP7Y/
        1z1VP274V59wSe93or0YjNXCZVxfKkVtOFGQle0zR8YCQ3S0oLGa17JnToRngczEXitDYSctJMGB9
        385/imEA==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxW-0005MH-EO; Sun, 27 Oct 2019 14:55:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/12] xfs: cleanup calculating the stat optimal I/O size
Date:   Sun, 27 Oct 2019 15:55:38 +0100
Message-Id: <20191027145547.25157-4-hch@lst.de>
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

Move xfs_preferred_iosize to xfs_iops.c, unobsfucate it and also handle
the realtime special case in the helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_iops.c  | 47 ++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_mount.h | 24 -----------------------
 2 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 404f2dd58698..b6dbfd8eb6a1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -484,6 +484,42 @@ xfs_vn_get_link_inline(
 	return link;
 }
 
+static uint32_t
+xfs_stat_blksize(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	/*
+	 * If the file blocks are being allocated from a realtime volume, then
+	 * always return the realtime extent size.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip))
+		return xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
+
+	/*
+	 * Allow large block sizes to be reported to userspace programs if the
+	 * "largeio" mount option is used.
+	 *
+	 * If compatibility mode is specified, simply return the basic unit of
+	 * caching so that we don't get inefficient read/modify/write I/O from
+	 * user apps. Otherwise....
+	 *
+	 * If the underlying volume is a stripe, then return the stripe width in
+	 * bytes as the recommended I/O size. It is not a stripe and we've set a
+	 * default buffered I/O size, return that, otherwise return the compat
+	 * default.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)) {
+		if (mp->m_swidth)
+			return mp->m_swidth << mp->m_sb.sb_blocklog;
+		if (mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)
+			return 1U << max(mp->m_readio_log, mp->m_writeio_log);
+	}
+
+	return PAGE_SIZE;
+}
+
 STATIC int
 xfs_vn_getattr(
 	const struct path	*path,
@@ -543,16 +579,7 @@ xfs_vn_getattr(
 		stat->rdev = inode->i_rdev;
 		break;
 	default:
-		if (XFS_IS_REALTIME_INODE(ip)) {
-			/*
-			 * If the file blocks are being allocated from a
-			 * realtime volume, then return the inode's realtime
-			 * extent size or the realtime volume's extent size.
-			 */
-			stat->blksize =
-				xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
-		} else
-			stat->blksize = xfs_preferred_iosize(mp);
+		stat->blksize = xfs_stat_blksize(ip);
 		stat->rdev = 0;
 		break;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fdb60e09a9c5..f69e370db341 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -267,30 +267,6 @@ typedef struct xfs_mount {
 #define	XFS_WSYNC_READIO_LOG	15	/* 32k */
 #define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
 
-/*
- * Allow large block sizes to be reported to userspace programs if the
- * "largeio" mount option is used.
- *
- * If compatibility mode is specified, simply return the basic unit of caching
- * so that we don't get inefficient read/modify/write I/O from user apps.
- * Otherwise....
- *
- * If the underlying volume is a stripe, then return the stripe width in bytes
- * as the recommended I/O size. It is not a stripe and we've set a default
- * buffered I/O size, return that, otherwise return the compat default.
- */
-static inline unsigned long
-xfs_preferred_iosize(xfs_mount_t *mp)
-{
-	if (mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE)
-		return PAGE_SIZE;
-	return (mp->m_swidth ?
-		(mp->m_swidth << mp->m_sb.sb_blocklog) :
-		((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ?
-			(1 << (int)max(mp->m_readio_log, mp->m_writeio_log)) :
-			PAGE_SIZE));
-}
-
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
-- 
2.20.1

