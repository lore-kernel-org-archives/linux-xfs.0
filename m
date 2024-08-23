Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B45AD49
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372612; cv=none; b=CTIzsdChfBFzL5YzfY1jJD6KH7jvYont68lN3uhkRmYUekBBQ6CqcRhXrGtQquv1Ppnu9mQyXeKaGuMzdoRvA/MgV3D6f2Y2NosRPRZqrEo3fbDxj+Fw4Bp0ovfH7M6U4rAZvDzi9hBI6Xxqb5v2b0FNXS9Ybp1GP4QzDOEzxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372612; c=relaxed/simple;
	bh=9eW0BvXaOIhkvOUwCaANvv3gtpcstzbgT/OECVJ7/qQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJAvtylONBzLa5ddlam9C0+KHSAIgynftMUCV0wVw385tOIq4dlBNJFB8fhKmDO46w2aTE6Oj5hFoEXWXze5yM5UAEkCUZaIdpXCz31+bCZ2S+UGqdEk5D86Q0dARM/D4PbzoKcrE/dTF3JalInWHSYC7eoPFvqqKTSlyhKkKsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6deJIVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6deJIVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849BDC32782;
	Fri, 23 Aug 2024 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372611;
	bh=9eW0BvXaOIhkvOUwCaANvv3gtpcstzbgT/OECVJ7/qQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C6deJIVifyJAycfNOrRC4zI3CLPC/uORaQthvUA+/TC6kyb5AG1mYUGk5MzPGYi1b
	 4y7ya6Tw95T/fPoFGMVR6QxaqSZNv8n0XrEs05GYe16zodziyupCu1JQJa8R/VnlMp
	 a5dUxcqP5URsjdrCY+gwxkaVz/v/mKFlBQY1+wJV/Byt4PKVuHnunXTfKz5pyav/lb
	 Iat0TlQBI+9Rx3IylQVkhrxfaNnTrHwRdlQVei2pwWNyWLE5vy9JWOX1JpqZ7rCZv8
	 s1LktdJUcxUKTab3tpxq2QmhUXvaaXCYSwOY91a7RQH8HRWw9VDQXgqm+IlD84s+po
	 5UvGBggWPbWaA==
Date: Thu, 22 Aug 2024 17:23:31 -0700
Subject: [PATCH 09/26] xfs: record rt group metadata errors in the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088674.60592.9324530021081393314.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
---
 fs/xfs/libxfs/xfs_health.h   |   59 ++++++++-------
 fs/xfs/libxfs/xfs_rtbitmap.c |   37 +++++----
 fs/xfs/libxfs/xfs_rtgroup.c  |   38 ++++++++--
 fs/xfs/libxfs/xfs_rtgroup.h  |    9 ++
 fs/xfs/scrub/health.c        |   33 ++++++--
 fs/xfs/xfs_health.c          |  164 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h           |   30 +++++++-
 7 files changed, 236 insertions(+), 134 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 8abd345e23885..7e77e2df9704a 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -52,6 +52,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -63,9 +64,10 @@ struct xfs_da_args;
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
@@ -109,8 +111,9 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METADIR | \
 				 XFS_SICK_FS_METAPATH)
 
-#define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+#define XFS_SICK_RG_PRIMARY	(XFS_SICK_RG_SUPER | \
+				 XFS_SICK_RG_BITMAP | \
+				 XFS_SICK_RG_SUMMARY)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -140,26 +143,26 @@ struct xfs_da_args;
 
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
 
@@ -193,10 +196,12 @@ void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
-void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_mark_corrupt(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
-void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
+void xfs_rgno_mark_sick(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		unsigned int mask);
+void xfs_rtgroup_mark_sick(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_corrupt(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_healthy(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_measure_sickness(struct xfs_rtgroup *rtg, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -230,15 +235,6 @@ xfs_fs_has_sickness(struct xfs_mount *mp, unsigned int mask)
 	return sick & mask;
 }
 
-static inline bool
-xfs_rt_has_sickness(struct xfs_mount *mp, unsigned int mask)
-{
-	unsigned int	sick, checked;
-
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	return sick & mask;
-}
-
 static inline bool
 xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
 {
@@ -248,6 +244,15 @@ xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
 	return sick & mask;
 }
 
+static inline bool
+xfs_rtgroup_has_sickness(struct xfs_rtgroup *rtg, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	return sick & mask;
+}
+
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
 {
@@ -264,9 +269,9 @@ xfs_fs_is_healthy(struct xfs_mount *mp)
 }
 
 static inline bool
-xfs_rt_is_healthy(struct xfs_mount *mp)
+xfs_rtgroup_is_healthy(struct xfs_rtgroup *rtg)
 {
-	return !xfs_rt_has_sickness(mp, -1U);
+	return !xfs_rtgroup_has_sickness(rtg, -1U);
 }
 
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 330acf1ab39f8..44e3c027c0537 100644
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
index 89194a66267e2..3cb08f5cfc260 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -316,6 +316,8 @@ struct xfs_rtginode_ops {
 
 	enum xfs_metafile_type	metafile_type;
 
+	unsigned int		sick;	/* rtgroup sickness flag */
+
 	/* Does the fs have this feature? */
 	bool			(*enabled)(struct xfs_mount *mp);
 
@@ -330,11 +332,13 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
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
@@ -368,6 +372,17 @@ xfs_rtginode_enabled(
 	return ops->enabled(rtg->rtg_mount);
 }
 
+/* Mark an rtgroup inode sick */
+void
+xfs_rtginode_mark_sick(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
+{
+	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
+
+	xfs_rtgroup_mark_sick(rtg, ops->sick);
+}
+
 /* Load and existing rtgroup inode into the rtgroup structure. */
 int
 xfs_rtginode_load(
@@ -403,8 +418,10 @@ xfs_rtginode_load(
 	} else {
 		const char	*path;
 
-		if (!mp->m_rtdirip)
+		if (!mp->m_rtdirip) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 			return -EFSCORRUPTED;
+		}
 
 		path = xfs_rtginode_path(rtg->rtg_rgno, type);
 		if (!path)
@@ -414,17 +431,22 @@ xfs_rtginode_load(
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
 
 	if (XFS_IS_CORRUPT(mp, ip->i_projid != rtg->rtg_rgno)) {
 		xfs_irele(ip);
+		xfs_rtginode_mark_sick(rtg, type);
 		return -EFSCORRUPTED;
 	}
 
@@ -461,8 +483,10 @@ xfs_rtginode_create(
 	if (!xfs_rtginode_enabled(rtg, type))
 		return 0;
 
-	if (!mp->m_rtdirip)
+	if (!mp->m_rtdirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
 		return -EFSCORRUPTED;
+	}
 
 	upd.path = xfs_rtginode_path(rtg->rtg_rgno, type);
 	if (!upd.path)
@@ -509,8 +533,10 @@ int
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
@@ -522,8 +548,10 @@ xfs_rtginode_load_parent(
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
index a18ea0aca3db1..f51f1a7592775 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -36,6 +36,14 @@ struct xfs_rtgroup {
 	/* Number of blocks in this group */
 	xfs_rtxnum_t		rtg_extents;
 
+	/*
+	 * Bitsets of per-rtgroup metadata that have been checked and/or are
+	 * sick.  Callers should hold rtg_state_lock before accessing this
+	 * field.
+	 */
+	uint16_t		rtg_checked;
+	uint16_t		rtg_sick;
+
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that rtg_rsum_cache[bbno] > the maximum i for which
@@ -247,6 +255,7 @@ int xfs_rtginode_load_parent(struct xfs_trans *tp);
 const char *xfs_rtginode_name(enum xfs_rtg_inodes type);
 enum xfs_metafile_type xfs_rtginode_metafile_type(enum xfs_rtg_inodes type);
 bool xfs_rtginode_enabled(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
+void xfs_rtginode_mark_sick(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type);
 int xfs_rtginode_load(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
 		struct xfs_trans *tp);
 int xfs_rtginode_create(struct xfs_rtgroup *rtg, enum xfs_rtg_inodes type,
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index e202d84ec5140..a0a721ae5763d 100644
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
@@ -162,12 +163,15 @@ xchk_mark_all_healthy(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 
 	xfs_fs_mark_healthy(mp, XFS_SICK_FS_INDIRECT);
-	xfs_rt_mark_healthy(mp, XFS_SICK_RT_INDIRECT);
 	for_each_perag(mp, agno, pag)
 		xfs_ag_mark_healthy(pag, XFS_SICK_AG_INDIRECT);
+	for_each_rtgroup(mp, rgno, rtg)
+		xfs_rtgroup_mark_healthy(rtg, XFS_SICK_RG_INDIRECT);
 }
 
 /*
@@ -185,6 +189,7 @@ xchk_update_health(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	bool			bad;
 
 	/*
@@ -237,11 +242,13 @@ xchk_update_health(
 		else
 			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
 		break;
-	case XHG_RT:
+	case XHG_RTGROUP:
+		rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
 		if (bad)
-			xfs_rt_mark_corrupt(sc->mp, sc->sick_mask);
+			xfs_rtgroup_mark_corrupt(rtg, sc->sick_mask);
 		else
-			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
+			xfs_rtgroup_mark_healthy(rtg, sc->sick_mask);
+		xfs_rtgroup_put(rtg);
 		break;
 	default:
 		ASSERT(0);
@@ -296,7 +303,9 @@ xchk_health_record(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 
 	unsigned int		sick;
 	unsigned int		checked;
@@ -305,15 +314,17 @@ xchk_health_record(
 	if (sick & XFS_SICK_FS_PRIMARY)
 		xchk_set_corrupt(sc);
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	if (sick & XFS_SICK_RT_PRIMARY)
-		xchk_set_corrupt(sc);
-
 	for_each_perag(mp, agno, pag) {
 		xfs_ag_measure_sickness(pag, &sick, &checked);
 		if (sick & XFS_SICK_AG_PRIMARY)
 			xchk_set_corrupt(sc);
 	}
 
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+		if (sick & XFS_SICK_RG_PRIMARY)
+			xchk_set_corrupt(sc);
+	}
+
 	return 0;
 }
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index cb43bd11dcac5..e94a5ede103d4 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -18,6 +18,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -29,7 +30,9 @@ xfs_health_unmount(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
+	struct xfs_rtgroup	*rtg;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	unsigned int		sick = 0;
 	unsigned int		checked = 0;
 	bool			warn = false;
@@ -46,11 +49,13 @@ xfs_health_unmount(
 		}
 	}
 
-	/* Measure realtime volume corruption levels. */
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	if (sick) {
-		trace_xfs_rt_unfixed_corruption(mp, sick);
-		warn = true;
+	/* Measure realtime group corruption levels. */
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+		if (sick) {
+			trace_xfs_rtgroup_unfixed_corruption(rtg, sick);
+			warn = true;
+		}
 	}
 
 	/*
@@ -150,65 +155,6 @@ xfs_fs_measure_sickness(
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
@@ -285,6 +231,82 @@ xfs_ag_measure_sickness(
 	spin_unlock(&pag->pag_state_lock);
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
+	xfs_rtgroup_mark_sick(rtg, mask);
+	xfs_rtgroup_put(rtg);
+}
+
+/* Mark unhealthy per-rtgroup metadata. */
+void
+xfs_rtgroup_mark_sick(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
+	trace_xfs_rtgroup_mark_sick(rtg, mask);
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_sick |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Mark rtgroup metadata as having been checked and found unhealthy by fsck. */
+void
+xfs_rtgroup_mark_corrupt(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
+	trace_xfs_rtgroup_mark_corrupt(rtg, mask);
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_sick |= mask;
+	rtg->rtg_checked |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Mark per-rtgroup metadata ok. */
+void
+xfs_rtgroup_mark_healthy(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
+	trace_xfs_rtgroup_mark_healthy(rtg, mask);
+
+	spin_lock(&rtg->rtg_state_lock);
+	rtg->rtg_sick &= ~mask;
+	if (!(rtg->rtg_sick & XFS_SICK_RG_PRIMARY))
+		rtg->rtg_sick &= ~XFS_SICK_RG_SECONDARY;
+	rtg->rtg_checked |= mask;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
+/* Sample which per-rtgroup metadata are unhealthy. */
+void
+xfs_rtgroup_measure_sickness(
+	struct xfs_rtgroup	*rtg,
+	unsigned int		*sick,
+	unsigned int		*checked)
+{
+	spin_lock(&rtg->rtg_state_lock);
+	*sick = rtg->rtg_sick;
+	*checked = rtg->rtg_checked;
+	spin_unlock(&rtg->rtg_state_lock);
+}
+
 /* Mark the unhealthy parts of an inode. */
 void
 xfs_inode_mark_sick(
@@ -384,8 +406,8 @@ static const struct ioctl_sick_map fs_map[] = {
 };
 
 static const struct ioctl_sick_map rt_map[] = {
-	{ XFS_SICK_RT_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
-	{ XFS_SICK_RT_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
+	{ XFS_SICK_RG_BITMAP,	XFS_FSOP_GEOM_SICK_RT_BITMAP },
+	{ XFS_SICK_RG_SUMMARY,	XFS_FSOP_GEOM_SICK_RT_SUMMARY },
 };
 
 static inline void
@@ -410,6 +432,8 @@ xfs_fsop_geom_health(
 	const struct ioctl_sick_map	*m;
 	unsigned int			sick;
 	unsigned int			checked;
+	struct xfs_rtgroup		*rtg;
+	xfs_rgnumber_t			rgno;
 
 	geo->sick = 0;
 	geo->checked = 0;
@@ -418,9 +442,11 @@ xfs_fsop_geom_health(
 	for_each_sick_map(fs_map, m)
 		xfgeo_health_tick(geo, sick, checked, m);
 
-	xfs_rt_measure_sickness(mp, &sick, &checked);
-	for_each_sick_map(rt_map, m)
-		xfgeo_health_tick(geo, sick, checked, m);
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+		for_each_sick_map(rt_map, m)
+			xfgeo_health_tick(geo, sick, checked, m);
+	}
 }
 
 static const struct ioctl_sick_map ag_map[] = {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4401a7c6230df..43bfa0d51c7d6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4224,10 +4224,6 @@ DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_corrupt);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
 DEFINE_FS_CORRUPT_EVENT(xfs_fs_unfixed_corruption);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_corrupt);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
-DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
 
 DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
@@ -4256,6 +4252,32 @@ DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_corrupt);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_unfixed_corruption);
 
+DECLARE_EVENT_CLASS(xfs_rtgroup_corrupt_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int flags),
+	TP_ARGS(rtg, flags),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->flags = flags;
+	),
+	TP_printk("dev %d:%d rgno 0x%x flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno, __entry->flags)
+);
+#define DEFINE_RTGROUP_CORRUPT_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_corrupt_class, name,	\
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned int flags), \
+	TP_ARGS(rtg, flags))
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_mark_sick);
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_mark_corrupt);
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_mark_healthy);
+DEFINE_RTGROUP_CORRUPT_EVENT(xfs_rtgroup_unfixed_corruption);
+
 DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
 	TP_ARGS(ip, flags),

