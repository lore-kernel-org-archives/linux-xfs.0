Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A37925A33D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185417; cv=none; b=f1bq8B9yhIxl6zOoc4UaFoiloXTDDXVU63MfEWnTY2/osRN8M/UXh7T+BO+A+EsHYoa4BzX0K9vQu+degkft4tJ0DXXKJRIfG8OrmTlGXNJ4yi0GHT1h28UChk0QQ72X6GiK99PEOS878rvphZTfxcVIj7o5WuK5IXIydi9zfpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185417; c=relaxed/simple;
	bh=4QFLkW2uzDcOSVmosYZ3XzvUEvZHwhHADY+kqjSv07c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEt/x5x2ua3l6DqkJDYFef4niUPumAf04FnQRSlhEqX1t7MwGuuHg6yGu7MyUb1kJNnz/+6Bxtg/09QhA4urFAE3Pmjk1S7wC6zMu2qFzlxIZEohRyKnBECvJ/o8irjWoZYDhksAc8dHA2DTzvrYbdAZM2ClTCqkmJNed/AhH/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I/PkuHiS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I/PkuHiS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TPQpAqA1I9CP80hCGm1rCj1czmYjHeBkdEq6VSp6lY8=; b=I/PkuHiSPbc1F9zSccYfPIsJfT
	575JI8Dw+37E4IlA4tMJSiWAt1W917PgZVd3poa/YsTAO6+zl9Ma/bIl0N8j0ZbBqMoJiN9sinNiZ
	rJtYWtXIVuGBV2s0jBj79m6PWRUJKThN+rfp72KxxprTUtCMveIhvCxID+raBqT0UHsHKz0My0pZk
	GaMkWSnvZFSkB1tp0St1cCU0PKvj2eePbsgOV/0t4DdhTXZHvlg6D76bLay/CrzKaARM/UdrVrkrZ
	q3cxfvOcwKfTUvyPcMz5jrMKXXdw57OHCSiww1bDmCZdl5ljHj6B1ThfM0ek7uTLFNe5hnaZ5rbaE
	dlCZ8R0Q==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIp-00000006UP0-09bi;
	Wed, 09 Apr 2025 07:56:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/45] FIXUP: xfs: allow internal RT devices for zoned mode
Date: Wed,  9 Apr 2025 09:55:16 +0200
Message-ID: <20250409075557.3535745-14-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h    |  6 ++++++
 include/xfs_mount.h |  7 +++++++
 libfrog/fsgeom.c    |  2 +-
 libxfs/init.c       | 13 +++++++++----
 libxfs/rdwr.c       |  2 ++
 repair/agheader.c   |  4 +++-
 6 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 82b34b9d81c3..b968a2b88da3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -293,4 +293,10 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
 }
 
+static inline bool xfs_sb_version_haszoned(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_ZONED);
+}
+
 #endif	/* __LIBXFS_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7856acfb9f8e..bf9ebc25fc79 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -53,6 +53,13 @@ struct xfs_groups {
 	 * rtgroup, so this mask must be 64-bit.
 	 */
 	uint64_t		blkmask;
+
+	/*
+	 * Start of the first group in the device.  This is used to support a
+	 * RT device following the data device on the same block device for
+	 * SMR hard drives.
+	 */
+	xfs_fsblock_t		start_fsb;
 };
 
 /*
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index b5220d2d6ffd..13df88ae43a7 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -81,7 +81,7 @@ xfs_report_geom(
 		isint ? _("internal log") : logname ? logname : _("external"),
 			geo->blocksize, geo->logblocks, logversion,
 		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
-		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
+		!geo->rtblocks ? _("none") : rtname ? rtname : _("internal"),
 		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
 			(unsigned long long)geo->rtextents,
 		"", geo->rgcount, geo->rgextents);
diff --git a/libxfs/init.c b/libxfs/init.c
index 5b45ed347276..a186369f3fd8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -560,7 +560,7 @@ libxfs_buftarg_init(
 				progname);
 			exit(1);
 		}
-		if (xi->rt.dev &&
+		if ((xi->rt.dev || xi->rt.dev == xi->data.dev) &&
 		    (mp->m_rtdev_targp->bt_bdev != xi->rt.dev ||
 		     mp->m_rtdev_targp->bt_mount != mp)) {
 			fprintf(stderr,
@@ -577,7 +577,11 @@ libxfs_buftarg_init(
 	else
 		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
 				lfail);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt, rfail);
+	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
+		mp->m_rtdev_targp = mp->m_ddev_targp;
+	else
+		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
+				rfail);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -978,7 +982,7 @@ libxfs_flush_mount(
 			error = err2;
 	}
 
-	if (mp->m_rtdev_targp) {
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
 		err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,
 				_("realtime device"));
 		if (!error)
@@ -1031,7 +1035,8 @@ libxfs_umount(
 	free(mp->m_fsname);
 	mp->m_fsname = NULL;
 
-	libxfs_buftarg_free(mp->m_rtdev_targp);
+	if (mp->m_rtdev_targp != mp->m_ddev_targp)
+		libxfs_buftarg_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
 		libxfs_buftarg_free(mp->m_logdev_targp);
 	libxfs_buftarg_free(mp->m_ddev_targp);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 35be785c435a..f06763b38bd8 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -175,6 +175,8 @@ libxfs_getrtsb(
 	if (!mp->m_rtdev_targp->bt_bdev)
 		return NULL;
 
+	ASSERT(!mp->m_sb.sb_rtstart);
+
 	error = libxfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
 			XFS_FSB_TO_BB(mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
 	if (error)
diff --git a/repair/agheader.c b/repair/agheader.c
index 327ba041671f..5bb4e47e0c5b 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -485,7 +485,9 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetadir(sb))
+	if (xfs_sb_version_haszoned(sb))
+		size = offsetofend(struct xfs_dsb, sb_rtstart);
+	else if (xfs_sb_version_hasmetadir(sb))
 		size = offsetofend(struct xfs_dsb, sb_pad);
 	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetofend(struct xfs_dsb, sb_meta_uuid);
-- 
2.47.2

