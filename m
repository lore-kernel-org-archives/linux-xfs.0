Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0654148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529363; cv=none; b=IdxFeztdVW750UNhmZpBUjMYJy1KSx7+ruMcok55sfIwxja8a7oXAq6gDJUcII2IWNF8NDSv7aRNn2k6GuKump2HJP+Yv4wC0JU6/3e93PxUAKOUa4cWMZI7GzluC628diUsDPfXA+3vs925vvz0MgvTC/curG5pNEl7m0WSs4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529363; c=relaxed/simple;
	bh=WETWCJap8hE5Y50v8b4cs49qvI7/jIwMRikqdvVIsuM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCK7vzVW4SLZKoGe5ZthLngmok6j9kyb04zYQILhVligQXibgYqyJEMPjiWU1FW5F4Ao3u5bVrgJGSk9UB4dK5H+sHgauaF9wh5yBlkg9iD4TNWdaFbjr9HmBBKKjqQUOe1pI1CXPNWL5QoH9cmAic/kSrLblbKmudcWnsRt5FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vs6XCgHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vs6XCgHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5582C4CED1;
	Fri,  6 Dec 2024 23:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529363;
	bh=WETWCJap8hE5Y50v8b4cs49qvI7/jIwMRikqdvVIsuM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vs6XCgHG5uRLWr4e7dnK5G2r7atlHl+UW7aq+PUBkilnAxVJLgeOzSUOgIFnXUwlS
	 nOwIpgbe7Si+lfzBEUs+LV2I8xbFmp6g7oGAk7r2CggDNTWbHAsNQg4MjNsvZjPwzW
	 ZF7Zob7MWLuSouxQs+1dYh6zaec+JwrnOOjQqLzDaCwBKsPnmApN1ONk7NaM6f65f9
	 xW85QYpKzF5msKOk3+CmXcN2+RZMPdp0bKs7By87dOOh+8ydOx78rC5QcpLadOvkyj
	 FMFAYq1wBh8VlTqEQafYHdB/piR1pvJxBIJB9Tzw1C67qlkIFB+k/FUD2t4HXTAcQO
	 tTmeXU8qJsOFQ==
Date: Fri, 06 Dec 2024 15:56:03 -0800
Subject: [PATCH 18/46] xfs: record rt group metadata errors in the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750270.124560.14227801078237099766.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ab7bd650e17a392a205ec6b6c72b97cae18d43b4

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c         |    1 -
 libxfs/xfs_health.h   |   40 +++++++++++++++++++++++-----------------
 libxfs/xfs_rtbitmap.c |   37 +++++++++++++++++++------------------
 libxfs/xfs_rtgroup.c  |   38 +++++++++++++++++++++++++++++++++-----
 libxfs/xfs_rtgroup.h  |    1 +
 5 files changed, 76 insertions(+), 41 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 8c2ecff5855775..83f2f048bbe9f2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -507,7 +507,6 @@ void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_da_mark_sick(struct xfs_da_args *args) { }
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
-void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 
 #ifdef HAVE_GETRANDOM_NONBLOCK
 uint32_t
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index a23df94319e5fb..3d93b57cf57143 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -54,6 +54,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -65,9 +66,10 @@ struct xfs_da_args;
 #define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
 #define XFS_SICK_FS_METAPATH	(1 << 7)  /* metadata directory tree path */
 
-/* Observable health issues for realtime volume metadata. */
-#define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
-#define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+/* Observable health issues for realtime group metadata. */
+#define XFS_SICK_RG_SUPER	(1 << 0)  /* rt group superblock */
+#define XFS_SICK_RG_BITMAP	(1 << 1)  /* rt group bitmap */
+#define XFS_SICK_RG_SUMMARY	(1 << 2)  /* rt groups summary */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -111,8 +113,9 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METADIR | \
 				 XFS_SICK_FS_METAPATH)
 
-#define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+#define XFS_SICK_RG_PRIMARY	(XFS_SICK_RG_SUPER | \
+				 XFS_SICK_RG_BITMAP | \
+				 XFS_SICK_RG_SUMMARY)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -142,26 +145,26 @@ struct xfs_da_args;
 
 /* Secondary state related to (but not primary evidence of) health problems. */
 #define XFS_SICK_FS_SECONDARY	(0)
-#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_RG_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
 #define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
-#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_RG_INDIRECT	(0)
 #define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
-#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+#define XFS_SICK_FS_ALL		(XFS_SICK_FS_PRIMARY | \
 				 XFS_SICK_FS_SECONDARY | \
 				 XFS_SICK_FS_INDIRECT)
 
-#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
-				 XFS_SICK_RT_SECONDARY | \
-				 XFS_SICK_RT_INDIRECT)
+#define XFS_SICK_RG_ALL		(XFS_SICK_RG_PRIMARY | \
+				 XFS_SICK_RG_SECONDARY | \
+				 XFS_SICK_RG_INDIRECT)
 
-#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+#define XFS_SICK_AG_ALL		(XFS_SICK_AG_PRIMARY | \
 				 XFS_SICK_AG_SECONDARY | \
 				 XFS_SICK_AG_INDIRECT)
 
@@ -195,11 +198,8 @@ void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
-void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_mark_corrupt(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
-		unsigned int *checked);
+void xfs_rgno_mark_sick(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		unsigned int mask);
 
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
@@ -244,11 +244,17 @@ xfs_group_has_sickness(
 	xfs_group_measure_sickness(xg, &sick, &checked);
 	return sick & mask;
 }
+
 #define xfs_ag_has_sickness(pag, mask) \
 	xfs_group_has_sickness(pag_group(pag), (mask))
 #define xfs_ag_is_healthy(pag) \
 	(!xfs_ag_has_sickness((pag), UINT_MAX))
 
+#define xfs_rtgroup_has_sickness(rtg, mask) \
+	xfs_group_has_sickness(rtg_group(rtg), (mask))
+#define xfs_rtgroup_is_healthy(rtg) \
+	(!xfs_rtgroup_has_sickness((rtg), UINT_MAX))
+
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
 {
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 84ca5447ca770f..5e63340668a03d 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -74,28 +74,31 @@ static int
 xfs_rtbuf_get(
 	struct xfs_rtalloc_args	*args,
 	xfs_fileoff_t		block,	/* block number in bitmap or summary */
-	int			issum)	/* is summary not bitmap */
+	enum xfs_rtg_inodes	type)
 {
+	struct xfs_inode	*ip = args->rtg->rtg_inodes[type];
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_buf		**cbpp;	/* cached block buffer */
 	xfs_fileoff_t		*coffp;	/* cached block number */
 	struct xfs_buf		*bp;	/* block buffer, result */
-	struct xfs_inode	*ip;	/* bitmap or summary inode */
 	struct xfs_bmbt_irec	map;
-	enum xfs_blft		type;
+	enum xfs_blft		buf_type;
 	int			nmap = 1;
 	int			error;
 
-	if (issum) {
+	switch (type) {
+	case XFS_RTGI_SUMMARY:
 		cbpp = &args->sumbp;
 		coffp = &args->sumoff;
-		ip = args->rtg->rtg_inodes[XFS_RTGI_SUMMARY];
-		type = XFS_BLFT_RTSUMMARY_BUF;
-	} else {
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+		break;
+	case XFS_RTGI_BITMAP:
 		cbpp = &args->rbmbp;
 		coffp = &args->rbmoff;
-		ip = args->rtg->rtg_inodes[XFS_RTGI_BITMAP];
-		type = XFS_BLFT_RTBITMAP_BUF;
+		buf_type = XFS_BLFT_RTBITMAP_BUF;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	/*
@@ -118,8 +121,7 @@ xfs_rtbuf_get(
 		return error;
 
 	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
-		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
-					     XFS_SICK_RT_BITMAP);
+		xfs_rtginode_mark_sick(args->rtg, type);
 		return -EFSCORRUPTED;
 	}
 
@@ -128,12 +130,11 @@ xfs_rtbuf_get(
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
 	if (xfs_metadata_is_sick(error))
-		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
-					     XFS_SICK_RT_BITMAP);
+		xfs_rtginode_mark_sick(args->rtg, type);
 	if (error)
 		return error;
 
-	xfs_trans_buf_set_type(args->tp, bp, type);
+	xfs_trans_buf_set_type(args->tp, bp, buf_type);
 	*cbpp = bp;
 	*coffp = block;
 	return 0;
@@ -147,11 +148,11 @@ xfs_rtbitmap_read_buf(
 	struct xfs_mount		*mp = args->mp;
 
 	if (XFS_IS_CORRUPT(mp, block >= mp->m_sb.sb_rbmblocks)) {
-		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
+		xfs_rtginode_mark_sick(args->rtg, XFS_RTGI_BITMAP);
 		return -EFSCORRUPTED;
 	}
 
-	return xfs_rtbuf_get(args, block, 0);
+	return xfs_rtbuf_get(args, block, XFS_RTGI_BITMAP);
 }
 
 int
@@ -162,10 +163,10 @@ xfs_rtsummary_read_buf(
 	struct xfs_mount		*mp = args->mp;
 
 	if (XFS_IS_CORRUPT(mp, block >= mp->m_rsumblocks)) {
-		xfs_rt_mark_sick(args->mp, XFS_SICK_RT_SUMMARY);
+		xfs_rtginode_mark_sick(args->rtg, XFS_RTGI_SUMMARY);
 		return -EFSCORRUPTED;
 	}
-	return xfs_rtbuf_get(args, block, 1);
+	return xfs_rtbuf_get(args, block, XFS_RTGI_SUMMARY);
 }
 
 /*
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 6eabc66099dc50..f753ed5fc05588 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -268,6 +268,8 @@ struct xfs_rtginode_ops {
 
 	enum xfs_metafile_type	metafile_type;
 
+	unsigned int		sick;	/* rtgroup sickness flag */
+
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
 
@@ -282,11 +284,13 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_BITMAP] = {
 		.name		= "bitmap",
 		.metafile_type	= XFS_METAFILE_RTBITMAP,
+		.sick		= XFS_SICK_RG_BITMAP,
 		.create		= xfs_rtbitmap_create,
 	},
 	[XFS_RTGI_SUMMARY] = {
 		.name		= "summary",
 		.metafile_type	= XFS_METAFILE_RTSUMMARY,
+		.sick		= XFS_SICK_RG_SUMMARY,
 		.create		= xfs_rtsummary_create,
 	},
 };
@@ -320,6 +324,17 @@ xfs_rtginode_enabled(
 	return ops->enabled(rtg_mount(rtg));
 }
 
+/* Mark an rtgroup inode sick */
+void
+xfs_rtginode_mark_sick(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
+
+	xfs_group_mark_sick(rtg_group(rtg), ops->sick);
+}
+
 /* Load and existing rtgroup inode into the rtgroup structure. */
 int
 xfs_rtginode_load(
@@ -355,8 +370,10 @@ xfs_rtginode_load(
 	} else {
 		const char	*path;
 
-		if (!mp->m_rtdirip)
+		if (!mp->m_rtdirip) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 			return -EFSCORRUPTED;
+		}
 
 		path = xfs_rtginode_path(rtg_rgno(rtg), type);
 		if (!path)
@@ -366,17 +383,22 @@ xfs_rtginode_load(
 		kfree(path);
 	}
 
-	if (error)
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_rtginode_mark_sick(rtg, type);
 		return error;
+	}
 
 	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
 			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
 		xfs_irele(ip);
+		xfs_rtginode_mark_sick(rtg, type);
 		return -EFSCORRUPTED;
 	}
 
 	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg_rgno(rtg))) {
 		xfs_irele(ip);
+		xfs_rtginode_mark_sick(rtg, type);
 		return -EFSCORRUPTED;
 	}
 
@@ -413,8 +435,10 @@ xfs_rtginode_create(
 	if (!xfs_rtginode_enabled(rtg, type))
 		return 0;
 
-	if (!mp->m_rtdirip)
+	if (!mp->m_rtdirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	upd.path = xfs_rtginode_path(rtg_rgno(rtg), type);
 	if (!upd.path)
@@ -461,8 +485,10 @@ int
 xfs_rtginode_mkdir_parent(
 	struct xfs_mount	*mp)
 {
-	if (!mp->m_metadirip)
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_metadir_mkdir(mp->m_metadirip, "rtgroups", &mp->m_rtdirip);
 }
@@ -474,8 +500,10 @@ xfs_rtginode_load_parent(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	if (!mp->m_metadirip)
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_metadir_load(tp, mp->m_metadirip, "rtgroups",
 			XFS_METAFILE_DIR, &mp->m_rtdirip);
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index e7679fafff8ce7..fba62b26912a89 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -240,6 +240,7 @@ int xfs_rtginode_load_parent(struct xfs_trans *tp);
 const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
 enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
 bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
+void xfs_rtginode_mark_sick(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
 int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
 int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,

