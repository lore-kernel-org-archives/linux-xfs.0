Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40488 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751869AbdH2XvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cr-Qe
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005W7-PB
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/42] mkfs: factor out device preparation
Date: Wed, 30 Aug 2017 09:50:26 +1000
Message-Id: <20170829235052.21050-17-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prior to formating the device(s), we have to take several steps to
prepare them and check that they are appropriate for the formatting
that is about to take place. Pull all this into a single function
that is run before mounting the libxfs infrastructure.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 167 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 96 insertions(+), 71 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0e115bf3cf4d..2438e50d3f33 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1993,6 +1993,97 @@ setup_superblock(
 	}
 }
 
+/*
+ * Sanitise the data and log devices and prepare them so libxfs can mount the
+ * device successfully. Also check we can access the rt device if configured.
+ */
+static void
+prepare_devices(
+	struct mkfs_params	*cfg,
+	struct libxfs_xinit	*xi,
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp,
+	bool			clear_stale)
+{
+	struct xfs_buf		*buf;
+	int			whack_blks = BTOBB(WHACK_SIZE);
+
+	/*
+	 * If there's an old XFS filesystem on the device with enough intact
+	 * information that we can parse the superblock, there's enough
+	 * information on disk to confuse a future xfs_repair call. To avoid
+	 * this, whack all the old secondary superblocks that we can find.
+	 */
+	if (clear_stale)
+		zero_old_xfs_structures(xi, sbp);
+
+	/*
+	 * If the data device is a file, grow out the file to its final size if
+	 * needed so that the reads for the end of the device in the mount code
+	 * will succeed.
+	 */
+	if (xi->disfile &&
+	    xi->dsize * xi->dbsize < cfg->dblocks * cfg->blocksize) {
+		if (ftruncate(xi->dfd, cfg->dblocks * cfg->blocksize) < 0) {
+			fprintf(stderr,
+				_("%s: Growing the data section failed\n"),
+				progname);
+			exit(1);
+		}
+
+		/* update size to be able to whack blocks correctly */
+		xi->dsize = BTOBB(cfg->dblocks * cfg->blocksize);
+	}
+
+	/*
+	 * Zero out the end to obliterate any old MD RAID (or other) metadata at
+	 * the end of the device.  (MD sb is ~64k from the end, take out a wider
+	 * swath to be sure)
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp, (xi->dsize - whack_blks),
+			    whack_blks);
+	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_purgebuf(buf);
+
+	/*
+	 * Now zero out the beginning of the device, to obliterate any old
+	 * filesystem signatures out there.  This should take care of
+	 * swap (somewhere around the page size), jfs (32k),
+	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
+	 */
+	buf = libxfs_getbuf(mp->m_ddev_targp, 0, whack_blks);
+	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_purgebuf(buf);
+
+	/* OK, now write the superblock... */
+	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
+	buf->b_ops = &xfs_sb_buf_ops;
+	memset(XFS_BUF_PTR(buf), 0, cfg->sectorsize);
+	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
+	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_purgebuf(buf);
+
+	/* ...and zero the log.... */
+	libxfs_log_clear(mp->m_logdev_targp, NULL,
+			 XFS_FSB_TO_DADDR(mp, cfg->logstart),
+			 (xfs_extlen_t)XFS_FSB_TO_BB(mp, cfg->logblocks),
+			 &sbp->sb_uuid, cfg->sb_feat.log_version,
+			 sbp->sb_logsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
+
+	/* finally, check we can write the last block in the realtime area */
+	if (mp->m_rtdev_targp->dev && cfg->rtblocks > 0) {
+		buf = libxfs_getbuf(mp->m_rtdev_targp,
+				    XFS_FSB_TO_BB(mp, cfg->rtblocks - 1LL),
+				    BTOBB(cfg->blocksize));
+		memset(XFS_BUF_PTR(buf), 0, cfg->blocksize);
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_purgebuf(buf);
+	}
+
+}
+
 int
 main(
 	int			argc,
@@ -3174,65 +3265,17 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	 */
 	setup_superblock(&cfg, mp, sbp);
 
-	if (force_overwrite)
-		zero_old_xfs_structures(&xi, sbp);
-
 	/*
-	 * Zero out the beginning of the device, to obliterate any old
-	 * filesystem signatures out there.  This should take care of
-	 * swap (somewhere around the page size), jfs (32k),
-	 * ext[2,3] and reiserfs (64k) - and hopefully all else.
+	 * we need the libxfs buffer cache from here on in.
 	 */
 	libxfs_buftarg_init(mp, xi.ddev, xi.logdev, xi.rtdev);
-	buf = libxfs_getbuf(mp->m_ddev_targp, 0, BTOBB(WHACK_SIZE));
-	memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	libxfs_purgebuf(buf);
-
-	/* OK, now write the superblock */
-	buf = libxfs_getbuf(mp->m_ddev_targp, XFS_SB_DADDR, XFS_FSS_TO_BB(mp, 1));
-	buf->b_ops = &xfs_sb_buf_ops;
-	memset(XFS_BUF_PTR(buf), 0, sectorsize);
-	libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	libxfs_purgebuf(buf);
-
-	/*
-	 * If the data area is a file, then grow it out to its final size
-	 * if needed so that the reads for the end of the device in the mount
-	 * code will succeed.
-	 */
-	if (xi.disfile && xi.dsize * xi.dbsize < dblocks * blocksize) {
-		if (ftruncate(xi.dfd, dblocks * blocksize) < 0) {
-			fprintf(stderr,
-				_("%s: Growing the data section failed\n"),
-				progname);
-			exit(1);
-		}
-	}
-
-	/*
-	 * Zero out the end of the device, to obliterate any
-	 * old MD RAID (or other) metadata at the end of the device.
-	 * (MD sb is ~64k from the end, take out a wider swath to be sure)
-	 */
-	if (!xi.disfile) {
-		buf = libxfs_getbuf(mp->m_ddev_targp,
-				    (xi.dsize - BTOBB(WHACK_SIZE)),
-				    BTOBB(WHACK_SIZE));
-		memset(XFS_BUF_PTR(buf), 0, WHACK_SIZE);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-		libxfs_purgebuf(buf);
-	}
 
 	/*
-	 * Zero the log....
+	 * Before we mount the filesystem we need to make sure the devices have
+	 * enough of the filesystem structure on them that allows libxfs to
+	 * mount.
 	 */
-	libxfs_log_clear(mp->m_logdev_targp, NULL,
-		XFS_FSB_TO_DADDR(mp, logstart),
-		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
-		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
-
+	prepare_devices(&cfg, &xi, mp, sbp, force_overwrite);
 	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
 	if (mp == NULL) {
 		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
@@ -3576,24 +3619,6 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	}
 
 	/*
-	 * Touch last block, make fs the right size if it's a file.
-	 */
-	buf = libxfs_getbuf(mp->m_ddev_targp,
-		(xfs_daddr_t)XFS_FSB_TO_BB(mp, dblocks - 1LL), bsize);
-	memset(XFS_BUF_PTR(buf), 0, blocksize);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-
-	/*
-	 * Make sure we can write the last block in the realtime area.
-	 */
-	if (mp->m_rtdev_targp->dev && rtblocks > 0) {
-		buf = libxfs_getbuf(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, rtblocks - 1LL), bsize);
-		memset(XFS_BUF_PTR(buf), 0, blocksize);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
-	}
-
-	/*
 	 * BNO, CNT free block list
 	 */
 	for (agno = 0; agno < agcount; agno++) {
-- 
2.13.3

