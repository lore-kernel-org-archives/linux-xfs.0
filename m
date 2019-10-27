Return-Path: <SRS0=AY68=YU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EC6CA9EAF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24CE1214AF
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Oct 2019 14:56:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RsVQ8sVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJ0O4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:56:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfJ0O4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Oct 2019 10:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RIZvPfpLWa3A9fP2km7mJgHDj/09kjJNc4FeGKF8cCs=; b=RsVQ8sVibdTCvInVLK78mg37+/
        kj+9AA5xq47nlJE6Yhqe1jSNIzoUOIY68yULFbai1i72p3mSkBDcUkgljKCY49qopu9NkLXWcV5th
        kCPD+kWjNIeT8grfxmvU4YEANwMq19xK1bFK50YSzGhUCXOoSuslSizxtG6VjS23yVhaX+0qEPHx2
        wHj1Ed8E9yiClq252Fft3VcjWJqbF/uW0mkpyDazTj8D5SlD06MSleGzzP0LdgcTGJ3abniSES/GI
        OmvVTJTEySLeCvvVZQA4cifM5EZUUEH/uTNjiLsi6//CednpiAl5ERHEaVdeIL+gPeEXjTGpbizeO
        9VMsDL6g==;
Received: from [2001:4bb8:184:47ee:760d:fb4d:483e:6b79] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOjxi-0005Nu-0y; Sun, 27 Oct 2019 14:56:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 07/12] xfs: simplify parsing of allocsize mount option
Date:   Sun, 27 Oct 2019 15:55:42 +0100
Message-Id: <20191027145547.25157-8-hch@lst.de>
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

Rework xfs_parseargs to fill out the default value and then parse the
option directly into the mount structure, similar to what we do for
other updates, and open code the now trivial updates based on on the
on-disk superblock directly into xfs_mountfs.

Note that this change rejects the allocsize=0 mount option that has been
documented as invalid for a long time instead of just ignoring it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 31 +++++--------------------------
 fs/xfs/xfs_mount.h |  6 ------
 fs/xfs/xfs_super.c | 26 +++++++++++---------------
 3 files changed, 16 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1853797ea938..3e8eedf01eb2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -425,30 +425,6 @@ xfs_update_alignment(xfs_mount_t *mp)
 	return 0;
 }
 
-/*
- * Set the default minimum read and write sizes unless
- * already specified in a mount option.
- * We use smaller I/O sizes when the file system
- * is being used for NFS service (wsync mount option).
- */
-STATIC void
-xfs_set_rw_sizes(xfs_mount_t *mp)
-{
-	xfs_sb_t	*sbp = &(mp->m_sb);
-	int		readio_log, writeio_log;
-
-	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE))
-		writeio_log = XFS_WRITEIO_LOG_LARGE;
-	else
-		writeio_log = mp->m_allocsize_log;
-
-	if (sbp->sb_blocklog > writeio_log)
-		mp->m_allocsize_log = sbp->sb_blocklog;
-	} else
-		mp->m_allocsize_log = writeio_log;
-	mp->m_allocsize_blocks = 1 << (mp->m_allocsize_log - sbp->sb_blocklog);
-}
-
 /*
  * precalculate the low space thresholds for dynamic speculative preallocation.
  */
@@ -713,9 +689,12 @@ xfs_mountfs(
 		goto out_remove_errortag;
 
 	/*
-	 * Set the minimum read and write sizes
+	 * Update the preferred write size based on the information from the
+	 * on-disk superblock.
 	 */
-	xfs_set_rw_sizes(mp);
+	mp->m_allocsize_log =
+		max_t(uint32_t, sbp->sb_blocklog, mp->m_allocsize_log);
+	mp->m_allocsize_blocks = 1U << (mp->m_allocsize_log - sbp->sb_blocklog);
 
 	/* set the low space thresholds for dynamic preallocation */
 	xfs_set_low_space_thresholds(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 109081c16a07..712dbb2039cd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -244,12 +244,6 @@ typedef struct xfs_mount {
 
 #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
-
-/*
- * Default write size.
- */
-#define XFS_WRITEIO_LOG_LARGE	16
-
 /*
  * Max and min values for mount-option defined I/O
  * preallocation sizes.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d1a0958f336d..3e5002d2a79e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -159,8 +159,7 @@ xfs_parseargs(
 	const struct super_block *sb = mp->m_super;
 	char			*p;
 	substring_t		args[MAX_OPT_ARGS];
-	int			iosize = 0;
-	uint8_t			iosizelog = 0;
+	int			size = 0;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -192,6 +191,7 @@ xfs_parseargs(
 	 */
 	mp->m_logbufs = -1;
 	mp->m_logbsize = -1;
+	mp->m_allocsize_log = 16; /* 64k */
 
 	if (!options)
 		goto done;
@@ -225,9 +225,10 @@ xfs_parseargs(
 				return -ENOMEM;
 			break;
 		case Opt_allocsize:
-			if (suffix_kstrtoint(args, 10, &iosize))
+			if (suffix_kstrtoint(args, 10, &size))
 				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
+			mp->m_allocsize_log = ffs(size) - 1;
+			mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
 			break;
 		case Opt_grpid:
 		case Opt_bsdgroups:
@@ -395,17 +396,12 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
-			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
-			return -EINVAL;
-		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_allocsize_log = iosizelog;
+	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) &&
+	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
+	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
+		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
+			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
+		return -EINVAL;
 	}
 
 	return 0;
-- 
2.20.1

