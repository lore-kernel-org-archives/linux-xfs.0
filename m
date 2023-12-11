Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fkA8u7ER"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F2995
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7bxRRfD4JcVm+J5ZoL4OQ4+Xls2DJosTu0mHhuXo0eQ=; b=fkA8u7ERL77EMTJ4c96rFlJgLT
	ZB3t0d9C4KMxtLfKwgJ5F9KaeDAemAM6JtHldGkck3wwl7yhZM8Z4OusArBuQgV1TSCF2LpNeCYc0
	Bs7FRY3eZlXeiXx9oTin1EbBI+qJm1etgh6E10JJvVtRRgQIQjVfd+JHsFC7LO5ceu2Vhdrfy2km5
	pG+A4M1xEDZrZIjgXwc5bsiQNrvjIWKBY/OK/ZDtUfqckowm2qF40AP6YlCYhpQofe0C0z++no/UV
	U5wYn4lGtj6sVaPtvoqZnP+qiEX9mwAL92XUmz4zo6JEH0FSatNH64eAZksYyQeXLH5P7O9U6HyTH
	yHgO48/w==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIQ-005t88-1s;
	Mon, 11 Dec 2023 16:38:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 11/23] libxfs: pass a struct libxfs_init to libxfs_mount
Date: Mon, 11 Dec 2023 17:37:30 +0100
Message-Id: <20231211163742.837427-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass a libxfs_init structure to libxfs_mount instead of three separate
dev_t values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c     | 2 +-
 db/init.c           | 3 +--
 include/xfs_mount.h | 3 ++-
 libxfs/init.c       | 8 +++-----
 mkfs/xfs_mkfs.c     | 5 +++--
 repair/xfs_repair.c | 2 +-
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 12ad81eb1..fbccd32a1 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -755,7 +755,7 @@ main(int argc, char **argv)
 	}
 	libxfs_buf_relse(sbp);
 
-	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
+	mp = libxfs_mount(&mbuf, sb, &xargs, 0);
 	if (mp == NULL) {
 		do_log(_("%s: %s filesystem failed to initialize\n"
 			"%s: Aborting.\n"), progname, source_name, progname);
diff --git a/db/init.c b/db/init.c
index 36e2bb89d..74c63e218 100644
--- a/db/init.c
+++ b/db/init.c
@@ -130,8 +130,7 @@ init(
 	}
 
 	agcount = sbp->sb_agcount;
-	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
-			  LIBXFS_MOUNT_DEBUGGER);
+	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
 		fprintf(stderr,
 			_("%s: device %s unusable (not an XFS filesystem?)\n"),
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 99d1d9ab1..9adc1f898 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -10,6 +10,7 @@
 struct xfs_inode;
 struct xfs_buftarg;
 struct xfs_da_geometry;
+struct libxfs_init;
 
 typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
 
@@ -272,7 +273,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 
 void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
 struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
-		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
+		struct libxfs_init *xi, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
diff --git a/libxfs/init.c b/libxfs/init.c
index cafd40b11..1b7397819 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -744,9 +744,7 @@ struct xfs_mount *
 libxfs_mount(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sb,
-	dev_t			dev,
-	dev_t			logdev,
-	dev_t			rtdev,
+	struct libxfs_init	*xi,
 	unsigned int		flags)
 {
 	struct xfs_buf		*bp;
@@ -759,7 +757,7 @@ libxfs_mount(
 		xfs_set_debugger(mp);
 	if (flags & LIBXFS_MOUNT_REPORT_CORRUPTION)
 		xfs_set_reporting_corruption(mp);
-	libxfs_buftarg_init(mp, dev, logdev, rtdev);
+	libxfs_buftarg_init(mp, xi->ddev, xi->logdev, xi->rtdev);
 
 	mp->m_finobt_nores = true;
 	xfs_set_inode32(mp);
@@ -825,7 +823,7 @@ libxfs_mount(
 	/* Initialize the precomputed transaction reservations values */
 	xfs_trans_init(mp);
 
-	if (dev == 0)	/* maxtrres, we have no device so leave now */
+	if (xi->ddev == 0)	/* maxtrres, we have no device so leave now */
 		return mp;
 
 	/* device size checks must pass unless we're a debugger. */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 346516e13..5aadf0f94 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3483,11 +3483,12 @@ calculate_log_size(
 	int			min_logblocks;	/* absolute minimum */
 	int			max_logblocks;	/* absolute max for this AG */
 	struct xfs_mount	mount;
+	struct libxfs_init	dummy_init = { };
 
 	/* we need a temporary mount to calculate the minimum log size. */
 	memset(&mount, 0, sizeof(mount));
 	mount.m_sb = *sbp;
-	libxfs_mount(&mount, &mp->m_sb, 0, 0, 0, 0);
+	libxfs_mount(&mount, &mp->m_sb, &dummy_init, 0);
 	min_logblocks = libxfs_log_calc_minimum_size(&mount);
 	libxfs_umount(&mount);
 
@@ -4320,7 +4321,7 @@ main(
 	 * mount.
 	 */
 	prepare_devices(&cfg, &xi, mp, sbp, force_overwrite);
-	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
+	mp = libxfs_mount(mp, sbp, &xi, 0);
 	if (mp == NULL) {
 		fprintf(stderr, _("%s: filesystem failed to initialize\n"),
 			progname);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ff29bea97..8a6cf31b4 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1034,7 +1034,7 @@ main(int argc, char **argv)
 	 * initialized in phase 2.
 	 */
 	memset(&xfs_m, 0, sizeof(xfs_mount_t));
-	mp = libxfs_mount(&xfs_m, &psb, x.ddev, x.logdev, x.rtdev, 0);
+	mp = libxfs_mount(&xfs_m, &psb, &x, 0);
 
 	if (!mp)  {
 		fprintf(stderr,
-- 
2.39.2

