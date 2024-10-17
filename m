Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6479F1E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191926; cv=none; b=dP9v54v1xmzMShV5uRCYUU6AmF0BMFe8x6Gypaiv0WFjl5oIUudXvbCPUcPp3Z6zgVlHXJZw/nw4e+6MzitjgNCr6cPMVjk5A8Ts+7nO3sJbnNMaE4yQCzj/8plCmRJ8npTXqZXToc1hti8IenD8lTYLCxHZzP3lr520PukqjME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191926; c=relaxed/simple;
	bh=1w766CjaGHxOrJtq+n4hseE/F1DBzdJrMPO7p4A8npo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uR5hgx5QkZUdo0eUU0JKCPZQTukEbVa1HTBJAlF/SL5Eu9k7scw1frfXrVy+LiAwimq6l/e4c0PqXK+2KIBhcIX5pslEE9UQvCLLAppyoxbj3cZTc0/noFisioKKQR8HVAU/BBgO/ap96KYDlJtmUQeDzRQOzma0dICfwyCUQJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGHexQhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGHexQhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1D2C4CEC3;
	Thu, 17 Oct 2024 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191926;
	bh=1w766CjaGHxOrJtq+n4hseE/F1DBzdJrMPO7p4A8npo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IGHexQhKw9ysrvDqC/en9Eyp6qDIdfRSFcbgj5XKGtCi86X4ittTvV6GUPdaSing9
	 wNnsi3T1fnv61CE4Sf/id2apC7x/S67Ra/wqa1VPW1Kq/SofLjNSYpmrZnfA1T1DvF
	 hh7qXq/9c8HTTPROZEIr+b2aBVNW6lwpoBGpZ5Bw6GUE+mu5+/j+gzpxds3G8I7fu+
	 AfMR//0ZHScpsRCNIat1pGqSsLqvO7Adqc7W4pWBFkqHvrWiPytltCqx/45myBt4hn
	 tJpeb0oFHKhKO9nDSSK6LvcXBBaFPqr4TOsJTJ2aSA+rGzpJ74Pzq9hrteCTaRmdfp
	 QmwtQbfW90UyQ==
Date: Thu, 17 Oct 2024 12:05:25 -0700
Subject: [PATCH 09/34] xfs: record rt group metadata errors in the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071821.3453179.18387264040007267965.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_health.h   |   40 +++++++-----
 fs/xfs/libxfs/xfs_rtbitmap.c |   37 ++++++-----
 fs/xfs/libxfs/xfs_rtgroup.c  |   38 ++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.h  |    1 
 fs/xfs/scrub/health.c        |   31 ++++++---
 fs/xfs/xfs_health.c          |  142 ++++++++++++++++++------------------------
 fs/xfs/xfs_trace.h           |    4 -
 7 files changed, 157 insertions(+), 136 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index a23df94319e5fb..3d93b57cf57143 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 416bbcd92af2ad..e201064764d489 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -76,28 +76,31 @@ static int
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
@@ -120,8 +123,7 @@ xfs_rtbuf_get(
 		return error;
 
 	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
-		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
-					     XFS_SICK_RT_BITMAP);
+		xfs_rtginode_mark_sick(args->rtg, type);
 		return -EFSCORRUPTED;
 	}
 
@@ -130,12 +132,11 @@ xfs_rtbuf_get(
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
@@ -149,11 +150,11 @@ xfs_rtbitmap_read_buf(
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
@@ -164,10 +165,10 @@ xfs_rtsummary_read_buf(
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 470260c911c8d1..790a0b8c137fc8 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -271,6 +271,8 @@ struct xfs_rtginode_ops {
 
 	enum xfs_metafile_type	metafile_type;
 
+	unsigned int		sick;	/* rtgroup sickness flag */
+
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
 
@@ -285,11 +287,13 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
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
@@ -323,6 +327,17 @@ xfs_rtginode_enabled(
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
@@ -358,8 +373,10 @@ xfs_rtginode_load(
 	} else {
 		const char	*path;
 
-		if (!mp->m_rtdirip)
+		if (!mp->m_rtdirip) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 			return -EFSCORRUPTED;
+		}
 
 		path = xfs_rtginode_path(rtg_rgno(rtg), type);
 		if (!path)
@@ -369,17 +386,22 @@ xfs_rtginode_load(
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
 
@@ -416,8 +438,10 @@ xfs_rtginode_create(
 	if (!xfs_rtginode_enabled(rtg, type))
 		return 0;
 
-	if (!mp->m_rtdirip)
+	if (!mp->m_rtdirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	upd.path = xfs_rtginode_path(rtg_rgno(rtg), type);
 	if (!upd.path)
@@ -464,8 +488,10 @@ int
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
@@ -477,8 +503,10 @@ xfs_rtginode_load_parent(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	if (!mp->m_metadirip)
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	return xfs_metadir_load(tp, mp->m_metadirip, "rtgroups",
 			XFS_METAFILE_DIR, &mp->m_rtdirip);
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index e7679fafff8ce7..fba62b26912a89 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -240,6 +240,7 @@ int xfs_rtginode_load_parent(struct xfs_trans *tp);
 const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
 enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
 bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
+void xfs_rtginode_mark_sick(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
 int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
 int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index b8b92ff3a573a1..7547fb5bcd7272 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -12,6 +12,7 @@
 #include "xfs_btree.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/health.h"
 #include "scrub/common.h"
@@ -71,9 +72,9 @@
 
 enum xchk_health_group {
 	XHG_FS = 1,
-	XHG_RT,
 	XHG_AG,
 	XHG_INO,
+	XHG_RTGROUP,
 };
 
 struct xchk_health_map {
@@ -100,8 +101,8 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_XATTR]		= { XHG_INO, XFS_SICK_INO_XATTR },
 	[XFS_SCRUB_TYPE_SYMLINK]	= { XHG_INO, XFS_SICK_INO_SYMLINK },
 	[XFS_SCRUB_TYPE_PARENT]		= { XHG_INO, XFS_SICK_INO_PARENT },
-	[XFS_SCRUB_TYPE_RTBITMAP]	= { XHG_RT,  XFS_SICK_RT_BITMAP },
-	[XFS_SCRUB_TYPE_RTSUM]		= { XHG_RT,  XFS_SICK_RT_SUMMARY },
+	[XFS_SCRUB_TYPE_RTBITMAP]	= { XHG_RTGROUP, XFS_SICK_RG_BITMAP },
+	[XFS_SCRUB_TYPE_RTSUM]		= { XHG_RTGROUP, XFS_SICK_RG_SUMMARY },
 	[XFS_SCRUB_TYPE_UQUOTA]		= { XHG_FS,  XFS_SICK_FS_UQUOTA },
 	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
@@ -162,11 +163,13 @@ xchk_mark_all_healthy(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 
 	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
-	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
 	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_group_mark_healthy(pag_group(pag), XFS_SICK_AG_INDIRECT);
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		xfs_group_mark_healthy(rtg_group(rtg), XFS_SICK_RG_INDIRECT);
 }
 
 /*
@@ -184,6 +187,7 @@ xchk_update_health(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	bool			bad;
 
 	/*
@@ -236,11 +240,13 @@ xchk_update_health(
 		else
 			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
 		break;
-	case XHG_RT:
+	case XHG_RTGROUP:
+		rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
 		if (bad)
-			xfs_rt_mark_corrupt(sc->mp, sc->sick_mask);
+			xfs_group_mark_corrupt(rtg_group(rtg), sc->sick_mask);
 		else
-			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
+			xfs_group_mark_healthy(rtg_group(rtg), sc->sick_mask);
+		xfs_rtgroup_put(rtg);
 		break;
 	default:
 		ASSERT(0);
@@ -295,6 +301,7 @@ xchk_health_record(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	unsigned int		sick;
 	unsigned int		checked;
 
@@ -302,15 +309,17 @@ xchk_health_record(
 	if (sick & XFS_SICK_FS_PRIMARY)
 		xchk_set_corrupt(sc);
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	if (sick & XFS_SICK_RT_PRIMARY)
-		xchk_set_corrupt(sc);
-
 	while ((pag = xfs_perag_next(mp, pag))) {
 		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
 		if (sick & XFS_SICK_AG_PRIMARY)
 			xchk_set_corrupt(sc);
 	}
 
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
+		if (sick & XFS_SICK_RG_PRIMARY)
+			xchk_set_corrupt(sc);
+	}
+
 	return 0;
 }
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b0d0c6bd9fa29c..9d8ee01cd163ef 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -18,6 +18,22 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rtgroup.h"
+
+static void
+xfs_health_unmount_group(
+	struct xfs_group	*xg,
+	bool			*warn)
+{
+	unsigned int		sick = 0;
+	unsigned int		checked = 0;
+
+	xfs_group_measure_sickness(xg, &sick, &checked);
+	if (sick) {
+		trace_xfs_group_unfixed_corruption(xg, sick);
+		*warn = true;
+	}
+}
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -29,6 +45,7 @@ xfs_health_unmount(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 	unsigned int		sick = 0;
 	unsigned int		checked = 0;
 	bool			warn = false;
@@ -37,21 +54,12 @@ xfs_health_unmount(
 		return;
 
 	/* Measure AG corruption levels. */
-	while ((pag = xfs_perag_next(mp, pag))) {
-		xfs_group_measure_sickness(pag_group(pag), &sick, &checked);
-		if (sick) {
-			trace_xfs_group_unfixed_corruption(pag_group(pag),
-					sick);
-			warn = true;
-		}
-	}
+	while ((pag = xfs_perag_next(mp, pag)))
+		xfs_health_unmount_group(pag_group(pag), &warn);
 
-	/* Measure realtime volume corruption levels. */
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	if (sick) {
-		trace_xfs_rt_unfixed_corruption(mp, sick);
-		warn = true;
-	}
+	/* Measure realtime group corruption levels. */
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		xfs_health_unmount_group(rtg_group(rtg), &warn);
 
 	/*
 	 * Measure fs corruption and keep the sample around for the warning.
@@ -150,65 +158,6 @@ xfs_fs_measure_sickness(
 	spin_unlock(&mp->m_sb_lock);
 }
 
-/* Mark unhealthy realtime metadata. */
-void
-xfs_rt_mark_sick(
-	struct xfs_mount	*mp,
-	unsigned int		mask)
-{
-	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
-	trace_xfs_rt_mark_sick(mp, mask);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_rt_sick |= mask;
-	spin_unlock(&mp->m_sb_lock);
-}
-
-/* Mark realtime metadata as having been checked and found unhealthy by fsck. */
-void
-xfs_rt_mark_corrupt(
-	struct xfs_mount	*mp,
-	unsigned int		mask)
-{
-	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
-	trace_xfs_rt_mark_corrupt(mp, mask);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_rt_sick |= mask;
-	mp->m_rt_checked |= mask;
-	spin_unlock(&mp->m_sb_lock);
-}
-
-/* Mark a realtime metadata healed. */
-void
-xfs_rt_mark_healthy(
-	struct xfs_mount	*mp,
-	unsigned int		mask)
-{
-	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
-	trace_xfs_rt_mark_healthy(mp, mask);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_rt_sick &= ~mask;
-	if (!(mp->m_rt_sick & XFS_SICK_RT_PRIMARY))
-		mp->m_rt_sick &= ~XFS_SICK_RT_SECONDARY;
-	mp->m_rt_checked |= mask;
-	spin_unlock(&mp->m_sb_lock);
-}
-
-/* Sample which realtime metadata are unhealthy. */
-void
-xfs_rt_measure_sickness(
-	struct xfs_mount	*mp,
-	unsigned int		*sick,
-	unsigned int		*checked)
-{
-	spin_lock(&mp->m_sb_lock);
-	*sick = mp->m_rt_sick;
-	*checked = mp->m_rt_checked;
-	spin_unlock(&mp->m_sb_lock);
-}
-
 /* Mark unhealthy per-ag metadata given a raw AG number. */
 void
 xfs_agno_mark_sick(
@@ -226,13 +175,24 @@ xfs_agno_mark_sick(
 	xfs_perag_put(pag);
 }
 
+static inline void
+xfs_group_check_mask(
+	struct xfs_group	*xg,
+	unsigned int		mask)
+{
+	if (xg->xg_type == XG_TYPE_AG)
+		ASSERT(!(mask & ~XFS_SICK_AG_ALL));
+	else
+		ASSERT(!(mask & ~XFS_SICK_RG_ALL));
+}
+
 /* Mark unhealthy per-ag metadata. */
 void
 xfs_group_mark_sick(
 	struct xfs_group	*xg,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
+	xfs_group_check_mask(xg, mask);
 	trace_xfs_group_mark_sick(xg, mask);
 
 	spin_lock(&xg->xg_state_lock);
@@ -248,7 +208,7 @@ xfs_group_mark_corrupt(
 	struct xfs_group	*xg,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
+	xfs_group_check_mask(xg, mask);
 	trace_xfs_group_mark_corrupt(xg, mask);
 
 	spin_lock(&xg->xg_state_lock);
@@ -265,7 +225,7 @@ xfs_group_mark_healthy(
 	struct xfs_group	*xg,
 	unsigned int		mask)
 {
-	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
+	xfs_group_check_mask(xg, mask);
 	trace_xfs_group_mark_healthy(xg, mask);
 
 	spin_lock(&xg->xg_state_lock);
@@ -289,6 +249,23 @@ xfs_group_measure_sickness(
 	spin_unlock(&xg->xg_state_lock);
 }
 
+/* Mark unhealthy per-rtgroup metadata given a raw rt group number. */
+void
+xfs_rgno_mark_sick(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	unsigned int		mask)
+{
+	struct xfs_rtgroup	*rtg = xfs_rtgroup_get(mp, rgno);
+
+	/* per-rtgroup structure not set up yet? */
+	if (!rtg)
+		return;
+
+	xfs_group_mark_sick(rtg_group(rtg), mask);
+	xfs_rtgroup_put(rtg);
+}
+
 /* Mark the unhealthy parts of an inode. */
 void
 xfs_inode_mark_sick(
@@ -388,8 +365,8 @@ static const struct ioctl_sick_map fs_map[] = {
 };
 
 static const struct ioctl_sick_map rt_map[] = {
-	{ XFS_SICK_RT_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
-	{ XFS_SICK_RT_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
+	{ XFS_SICK_RG_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
+	{ XFS_SICK_RG_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
 };
 
 static inline void
@@ -411,6 +388,7 @@ xfs_fsop_geom_health(
 	struct xfs_mount		*mp,
 	struct xfs_fsop_geom		*geo)
 {
+	struct xfs_rtgroup		*rtg = NULL;
 	const struct ioctl_sick_map	*m;
 	unsigned int			sick;
 	unsigned int			checked;
@@ -422,9 +400,11 @@ xfs_fsop_geom_health(
 	for_each_sick_map(fs_map, m)
 		xfgeo_health_tick(geo, sick, checked, m);
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	for_each_sick_map(rt_map, m)
-		xfgeo_health_tick(geo, sick, checked, m);
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
+		for_each_sick_map(rt_map, m)
+			xfgeo_health_tick(geo, sick, checked, m);
+	}
 }
 
 static const struct ioctl_sick_map ag_map[] = {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 818e9992ce5692..33b1dda6e7cefd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4260,10 +4260,6 @@ DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_corrupt);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_unfixed_corruption);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_corrupt);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
 
 DECLARE_EVENT_CLASS(xfs_group_corrupt_class,
 	TP_PROTO(const struct xfs_group *xg, unsigned int flags),

