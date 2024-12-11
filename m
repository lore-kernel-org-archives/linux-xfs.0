Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5551E9B2A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907499; cv=none; b=eEZJm9Xsb/O7FHbu+f7OsVot5cvx5Rod8K310JxT/qQyn6is9IDL1KAMIFCfYBDRDNLPyz182ML2g5+yodSs/cELM1zxuc92peADY0xAIhjmu6TxlsP/PWkPl8DaV8MIqr90nhc9nzPoKyBDCtjFh1ttxWFHiNnuV2yYTDdIDdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907499; c=relaxed/simple;
	bh=ZkEpX5h8++d2gBq3NM+5H84lun7YWMR8vrH33zZpa8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu9om6r8t41GnRG0VgWUjYeoKXFHGE0SyX+iJNtRwHDMbfWJQEUkz/sCuXkF8jUb7PMB3CC6kkzj94M/78UZoorsk4QuNrSYCgGfZsbhKPP5MrkVg32o9O9vJMGU8oY/KDtuFWB+K05UKrw5Jr0/Bhye/uKZ6grrttbM2zIDhQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l4rf75Af; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l4rf75Af"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KShRVf/arT9RONGG3g/D1/+kucxBWF6BTO/mEA7sJpc=; b=l4rf75Afw+FglLuJV8NvtrI1TV
	IyhIKhehBTraa+/t4qIrHXfx25PqFS4XBDDbdWWTH4S2CpSjXzcz5vJg2Lmk21aCfp+4Dpz3qBY2u
	zdK19+Czufmy4HbrWUZiGclg9R719uUQXNEkoCkbHYn5mbJ0TLYQy92arHBOW3vOUVVkHAYZdr6Mx
	SwJc0VIl3t2oXDwS8o0eFtTfjNJgoD8V4j++sblYTNT9F2q9HFORHXy7hHwAomlx4M0eA/l/jIWGe
	I1Q39vRQ0qiiVE0Txa+ee28V1tevvmulp3AL+3rzK2uBMeiz3JDCtAgXsRQHZ2ukK/J/6kJrX3T8u
	4sTafPDQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXx-0000000EJSv-3VcI;
	Wed, 11 Dec 2024 08:58:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 35/43] xfs: enable fsmap reporting for internal RT devices
Date: Wed, 11 Dec 2024 09:55:00 +0100
Message-ID: <20241211085636.1380516-36-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File system with internal RT devices are a bit odd in that we need
to report AGs and RGs.  To make this happen use separate synthetic
fmr_device values for the different sections instead of the dev_t
mapping used by other XFS configurations.

The data device is reported as file system metadata before the
start of the RGs for the synthetic RT fmr_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |  9 +++++
 fs/xfs/xfs_fsmap.c     | 80 +++++++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5e66fb2b2cc7..12463ba766da 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1082,6 +1082,15 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/*
+ * Devices supported by a single XFS file system.  Reported in fsmaps fmr_device
+ * when using internal RT devices.
+ */
+enum xfs_device {
+	XFS_DEV_DATA	= 1,
+	XFS_DEV_LOG	= 2,
+	XFS_DEV_RT	= 3,
+};
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 917d4d0e51b3..a4bc1642fe56 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -879,17 +879,39 @@ xfs_getfsmap_rtdev_rmapbt(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rtgroup		*rtg = NULL;
 	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_daddr_t			rtstart_daddr;
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
 	xfs_rgnumber_t			start_rg, end_rg;
 	uint64_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	start_rtb = xfs_daddr_to_rtb(mp, keys[0].fmr_physical);
-	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	rtstart_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
+	if (keys[0].fmr_physical < rtstart_daddr) {
+		struct xfs_fsmap_irec		frec = {
+			.owner			= XFS_RMAP_OWN_FS,
+			.len_daddr		= rtstart_daddr,
+		};
+
+		/* Adjust the low key if we are continuing from where we left off. */
+		if (keys[0].fmr_length > 0) {
+			info->low_daddr = keys[0].fmr_physical + keys[0].fmr_length;
+			return 0;
+		}
+
+		/* Fabricate an rmap entry for space occupied by the data dev */
+		error = xfs_getfsmap_helper(tp, info, &frec);
+		if (error)
+			return error;
+	}
+
+	start_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr + keys[0].fmr_physical);
+	end_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr +
+			min(eofs - 1, keys[1].fmr_physical));
 
 	info->missing_owner = XFS_FMR_OWN_FREE;
 
@@ -1004,22 +1026,40 @@ xfs_getfsmap_rtdev_rmapbt(
 }
 #endif /* CONFIG_XFS_RT */
 
+static uint32_t
+xfs_getfsmap_device(
+	struct xfs_mount	*mp,
+	enum xfs_device		dev)
+{
+	if (mp->m_sb.sb_rtstart)
+		return dev;
+
+	switch (dev) {
+	case XFS_DEV_DATA:
+		return new_encode_dev(mp->m_ddev_targp->bt_dev);
+	case XFS_DEV_LOG:
+		return new_encode_dev(mp->m_logdev_targp->bt_dev);
+	case XFS_DEV_RT:
+		if (!mp->m_rtdev_targp)
+			break;
+		return new_encode_dev(mp->m_rtdev_targp->bt_dev);
+	}
+
+	return -1;
+}
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(
 	struct xfs_mount	*mp,
 	struct xfs_fsmap	*fm)
 {
-	if (fm->fmr_device == 0 || fm->fmr_device == UINT_MAX ||
-	    fm->fmr_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
-		return true;
-	if (mp->m_logdev_targp &&
-	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
-		return true;
-	if (mp->m_rtdev_targp &&
-	    fm->fmr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
-		return true;
-	return false;
+	return fm->fmr_device == 0 ||
+		fm->fmr_device == UINT_MAX ||
+		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_DATA) ||
+		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_LOG) ||
+		(mp->m_rtdev_targp &&
+		 fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_RT));
 }
 
 /* Ensure that the low key is less than the high key. */
@@ -1126,7 +1166,7 @@ xfs_getfsmap(
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
 	handlers[0].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
-	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	handlers[0].dev = xfs_getfsmap_device(mp, XFS_DEV_DATA);
 	if (use_rmap)
 		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
 	else
@@ -1134,7 +1174,7 @@ xfs_getfsmap(
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		handlers[1].nr_sectors = XFS_FSB_TO_BB(mp,
 						       mp->m_sb.sb_logblocks);
-		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
+		handlers[1].dev = xfs_getfsmap_device(mp, XFS_DEV_LOG);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
 #ifdef CONFIG_XFS_RT
@@ -1144,7 +1184,7 @@ xfs_getfsmap(
 	 */
 	if (mp->m_rtdev_targp && (use_rmap || !xfs_has_zoned(mp))) {
 		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		handlers[2].dev = xfs_getfsmap_device(mp, XFS_DEV_RT);
 		if (use_rmap)
 			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
 		else
@@ -1234,7 +1274,13 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
-	head->fmh_oflags = FMH_OF_DEV_T;
+
+	/*
+	 * For internal RT device we need to report different synthetic devices
+	 * for a single physical device, and thus can't report the actual dev_t.
+	 */
+	if (!mp->m_sb.sb_rtstart)
+		head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
 
-- 
2.45.2

