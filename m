Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45517 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbeHTIDI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006Rx-2O
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000Q7-1I
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/10] xfs: reflect sb features in xfs_mount
Date: Mon, 20 Aug 2018 14:48:42 +1000
Message-Id: <20180820044851.414-2-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently on-disk feature checks require decoding the superblock
fileds and so can be non-trivial. We have almost 400 hundred
individual feature checks in the XFS code, so this is a significant
amount of code. To reduce runtime check overhead, pre-process all
the version flags into a features field in the xfs_mount at mount
time so we can convert all the feature checks to a simple flag
check.

There is also a need to convert the dynamic feature flags to update
the m_features field. This is required for attr, attr2 and quota
features. New xfs_mount based wrappers are added for this.

Before:

$ size -t fs/xfs/built-in.a
   text	   data	    bss	    dec	    hex	filename
....
1294873	 182766	   1036	1478675	 169013	(TOTALS

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  2 +-
 fs/xfs/libxfs/xfs_sb.c     | 61 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h     |  1 +
 fs/xfs/xfs_log_recover.c   |  1 +
 fs/xfs/xfs_mount.c         |  1 +
 fs/xfs/xfs_mount.h         | 79 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 059bc44c27e8..c7b5a43af910 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -416,7 +416,7 @@ static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
 
-static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
+static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 081f46e30556..f9c8e1e9d8e3 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -96,6 +96,67 @@ xfs_perag_put(
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
+uint64_t
+xfs_sb_version_to_features(
+	struct xfs_sb	*sbp)
+{
+	uint64_t	features = 0;
+
+	/* optional V4 features */
+	if (sbp->sb_rblocks > 0)
+		features |= XFS_FEAT_REALTIME;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
+		features |= XFS_FEAT_ATTR;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
+		features |= XFS_FEAT_QUOTA;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT)
+		features |= XFS_FEAT_ALIGN;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT)
+		features |= XFS_FEAT_LOGV2;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT)
+		features |= XFS_FEAT_DALIGN;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT)
+		features |= XFS_FEAT_EXTFLG;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT)
+		features |= XFS_FEAT_SECTOR;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT)
+		features |= XFS_FEAT_ASCIICI;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) {
+		if (sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT)
+			features |= XFS_FEAT_LAZYSBCOUNT;
+		if (sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
+			features |= XFS_FEAT_ATTR2;
+		if (sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT)
+			features |= XFS_FEAT_PROJID32;
+		if (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE)
+			features |= XFS_FEAT_FTYPE;
+	}
+
+	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+		return features;
+
+	/* Always on V5 features */
+	features |= XFS_FEAT_ALIGN | XFS_FEAT_LOGV2 |
+		    XFS_FEAT_EXTFLG | XFS_FEAT_LAZYSBCOUNT |
+		    XFS_FEAT_ATTR2 | XFS_FEAT_PROJID32 |
+		    XFS_FEAT_CRC | XFS_FEAT_PQUOTINO;
+
+	/* Optional V5 features */
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT)
+		features |= XFS_FEAT_FINOBT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		features |= XFS_FEAT_RMAPBT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK)
+		features |= XFS_FEAT_REFLINK;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
+		features |= XFS_FEAT_FTYPE;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
+		features |= XFS_FEAT_SPINODES;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
+		features |= XFS_FEAT_META_UUID;
+	return features;
+}
+
 /* Check all the superblock fields we care about when reading one in. */
 STATIC int
 xfs_validate_sb_read(
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 13564d69800a..640a438402aa 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -29,6 +29,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
+extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a21dc61ec09e..5d0438ec07dd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5723,6 +5723,7 @@ xlog_do_recover(
 	xfs_buf_relse(bp);
 
 	/* re-initialise in-core superblock and geometry structures */
+	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
 	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
 	if (error) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02d15098dbee..fc567ca8b9d3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -342,6 +342,7 @@ xfs_readsb(
 		goto reread;
 	}
 
+	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
 
 	/* no need to be quiet anymore, so reset the buf ops */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7964513c3128..92d947f17c69 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -127,6 +127,7 @@ typedef struct xfs_mount {
 	struct mutex		m_growlock;	/* growfs mutex */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint64_t		m_flags;	/* global mount flags */
+	uint64_t		m_features;	/* active filesystem features */
 	bool			m_inotbt_nores; /* no per-AG finobt resv. */
 	int			m_ialloc_inos;	/* inodes in inode allocation */
 	int			m_ialloc_blks;	/* blocks in inode allocation */
@@ -195,6 +196,84 @@ typedef struct xfs_mount {
 #endif
 } xfs_mount_t;
 
+/*
+ * Flags for m_features.
+ *
+ * These are all the active features in the filesystem, regardless of how
+ * they are configured.
+ */
+#define	XFS_FEAT_ATTR		(1ULL << 0)	/* xattrs present in fs */
+#define	XFS_FEAT_NLINK		(1ULL << 1)	/* 32 bit link counts */
+#define	XFS_FEAT_QUOTA		(1ULL << 2)	/* quota active */
+#define	XFS_FEAT_ALIGN		(1ULL << 3)	/* inode alignment */
+#define	XFS_FEAT_DALIGN		(1ULL << 4)	/* data alignment */
+#define XFS_FEAT_LOGV2		(1ULL << 5)	/* version 2 logs */
+#define XFS_FEAT_SECTOR		(1ULL << 6)	/* sector size > 512 bytes */
+#define	XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
+#define	XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
+#define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
+#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
+#define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */
+#define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
+#define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
+#define XFS_FEAT_PQUOTINO	(1ULL << 14)	/* non-shared proj/grp quotas */
+#define XFS_FEAT_FTYPE		(1ULL << 15)	/* inode type in dir */
+#define XFS_FEAT_FINOBT		(1ULL << 16)	/* free inode btree */
+#define XFS_FEAT_RMAPBT		(1ULL << 17)	/* reverse map btree */
+#define XFS_FEAT_REFLINK	(1ULL << 18)	/* reflinked files */
+#define XFS_FEAT_SPINODES	(1ULL << 19)	/* sparse inode chunks */
+#define XFS_FEAT_META_UUID	(1ULL << 20)	/* metadata UUID */
+#define XFS_FEAT_REALTIME	(1ULL << 21)	/* realtime device present */
+
+#define __XFS_HAS_FEAT(name, NAME) \
+static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+{ \
+	return mp->m_features & XFS_FEAT_ ## NAME; \
+}
+
+/* Some features can be added dynamically so they need a set wrapper, too. */
+#define __XFS_HAS_ADDFEAT(name, NAME) \
+	__XFS_HAS_FEAT(name, NAME); \
+static inline void xfs_feat_add_ ## name (struct xfs_mount *mp) \
+{ \
+	mp->m_features |= XFS_FEAT_ ## NAME; \
+	xfs_sb_version_add ## name(&mp->m_sb); \
+}
+
+/* Some features can be cleared dynamically so they need a clear wrapper */
+#define __XFS_HAS_REMOVEFEAT(name, NAME) \
+	__XFS_HAS_ADDFEAT(name, NAME); \
+static inline void xfs_feat_remove_ ## name (struct xfs_mount *mp) \
+{ \
+	mp->m_features &= ~XFS_FEAT_ ## NAME; \
+	xfs_sb_version_remove ## name(&mp->m_sb); \
+}
+
+
+__XFS_HAS_ADDFEAT(attr, ATTR)
+__XFS_HAS_FEAT(nlink, NLINK)
+__XFS_HAS_ADDFEAT(quota, QUOTA)
+__XFS_HAS_FEAT(align, ALIGN)
+__XFS_HAS_FEAT(dalign, DALIGN)
+__XFS_HAS_FEAT(logv2, LOGV2)
+__XFS_HAS_FEAT(sector, SECTOR)
+__XFS_HAS_FEAT(extflg, EXTFLG)
+__XFS_HAS_FEAT(asciici, ASCIICI)
+__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
+__XFS_HAS_REMOVEFEAT(attr2, ATTR2)
+__XFS_HAS_FEAT(parent, PARENT)
+__XFS_HAS_ADDFEAT(projid32, PROJID32)
+__XFS_HAS_FEAT(crc, CRC)
+__XFS_HAS_FEAT(pquotino, PQUOTINO)
+__XFS_HAS_FEAT(ftype, FTYPE)
+__XFS_HAS_FEAT(finobt, FINOBT)
+__XFS_HAS_FEAT(rmapbt, RMAPBT)
+__XFS_HAS_FEAT(reflink, REFLINK)
+__XFS_HAS_FEAT(sparseinodes, SPINODES)
+__XFS_HAS_FEAT(metauuid, META_UUID)
+__XFS_HAS_FEAT(realtime, REALTIME)
+
+
 /*
  * Flags for m_flags.
  */
-- 
2.17.0
