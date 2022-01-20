Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066BAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbiATATl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357766AbiATATg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4816AC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCE9161514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC08C004E1;
        Thu, 20 Jan 2022 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637975;
        bh=j99Fo3rYqnZw7WCg4mQ6WhRAsYAF8E5NPSBChTJ7tkk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bic5NRl+dUdlbwuv84UgZDmUiK5z1HrcWA5gFnOggq2MjgSqFR9NzDIZdtgb4JCVQ
         JXWmjzJDwCmyW+TRmgU0+WLyutVTN6skeO9nRV+xChLbijQhFwY7M4NOQhHDZuexIR
         gyO9HELPRzfTZGRek6etceZbqK0PxMfukvX8klhIhqmvJuwunuCDtRfDAFnOXaDijs
         44jfSe/LOW3eF+V910hFOwtnp9QY+wp3tf1iixtbWwPxpHg08Qy41LQZM/HfhhjQEn
         2LRUmQgDpTk3TbKOL3ybRgR4ksPsvdl4gcD2fWctPpWnJDvNKG6voIF/CqHbFtfbZ0
         wZa9mRdar6cjw==
Subject: [PATCH 24/45] xfs: reflect sb features in xfs_mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:34 -0800
Message-ID: <164263797491.860211.6954549399999924177.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: a1d86e8dec8c1325d301c9d5594bb794bc428fc3

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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c                  |    8 ++++-
 include/xfs_mount.h      |   77 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/init.c            |    1 +
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_format.h      |    2 +
 libxfs/xfs_sb.c          |   66 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_sb.h          |    1 +
 logprint/logprint.c      |    1 +
 mkfs/xfs_mkfs.c          |    2 +
 repair/phase2.c          |    5 ++-
 repair/versions.c        |    3 ++
 11 files changed, 164 insertions(+), 3 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index b4c14276..7909acae 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -720,6 +720,7 @@ version_f(
 {
 	uint16_t	version = 0;
 	uint32_t	features = 0;
+	unsigned long	old_mfeatures = 0;
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
@@ -802,7 +803,7 @@ version_f(
 			version = mp->m_sb.sb_versionnum;
 			features = mp->m_sb.sb_features2;
 		} else if (!strcasecmp(argv[1], "projid32bit")) {
-			xfs_sb_version_addprojid32bit(&mp->m_sb);
+			xfs_sb_version_addprojid32(&mp->m_sb);
 			version = mp->m_sb.sb_versionnum;
 			features = mp->m_sb.sb_features2;
 		} else {
@@ -821,6 +822,8 @@ version_f(
 				}
 			mp->m_sb.sb_versionnum = version;
 			mp->m_sb.sb_features2 = features;
+			mp->m_features &= ~XFS_FEAT_ATTR2;
+			mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 		}
 	}
 
@@ -831,6 +834,8 @@ version_f(
 		features = mp->m_sb.sb_features2;
 		mp->m_sb.sb_versionnum = strtoul(argv[1], &sp, 0);
 		mp->m_sb.sb_features2 = strtoul(argv[2], &sp, 0);
+		old_mfeatures = mp->m_features;
+		mp->m_features = libxfs_sb_version_to_features(&mp->m_sb);
 	}
 
 	dbprintf(_("versionnum [0x%x+0x%x] = %s\n"), mp->m_sb.sb_versionnum,
@@ -839,6 +844,7 @@ version_f(
 	if (argc == 3) {	/* now reset... */
 		mp->m_sb.sb_versionnum = version;
 		mp->m_sb.sb_features2 = features;
+		mp->m_features = old_mfeatures;
 		return 0;
 	}
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index cc4682e2..a995140d 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -80,6 +80,7 @@ typedef struct xfs_mount {
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
 	uint			m_flags;	/* global mount flags */
+	uint64_t		m_features;	/* active filesystem features */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
 	uint			m_attroffset;	/* inode attribute offset */
@@ -120,6 +121,82 @@ typedef struct xfs_mount {
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
 
+/*
+ * Flags for m_features.
+ *
+ * These are all the active features in the filesystem, regardless of how
+ * they are configured.
+ */
+#define XFS_FEAT_ATTR		(1ULL << 0)	/* xattrs present in fs */
+#define XFS_FEAT_NLINK		(1ULL << 1)	/* 32 bit link counts */
+#define XFS_FEAT_QUOTA		(1ULL << 2)	/* quota active */
+#define XFS_FEAT_ALIGN		(1ULL << 3)	/* inode alignment */
+#define XFS_FEAT_DALIGN		(1ULL << 4)	/* data alignment */
+#define XFS_FEAT_LOGV2		(1ULL << 5)	/* version 2 logs */
+#define XFS_FEAT_SECTOR		(1ULL << 6)	/* sector size > 512 bytes */
+#define XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
+#define XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
+#define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
+#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
+#define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */
+#define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
+#define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
+#define XFS_FEAT_V3INODES	(1ULL << 14)	/* Version 3 inodes */
+#define XFS_FEAT_PQUOTINO	(1ULL << 15)	/* non-shared proj/grp quotas */
+#define XFS_FEAT_FTYPE		(1ULL << 16)	/* inode type in dir */
+#define XFS_FEAT_FINOBT		(1ULL << 17)	/* free inode btree */
+#define XFS_FEAT_RMAPBT		(1ULL << 18)	/* reverse map btree */
+#define XFS_FEAT_REFLINK	(1ULL << 19)	/* reflinked files */
+#define XFS_FEAT_SPINODES	(1ULL << 20)	/* sparse inode chunks */
+#define XFS_FEAT_META_UUID	(1ULL << 21)	/* metadata UUID */
+#define XFS_FEAT_REALTIME	(1ULL << 22)	/* realtime device present */
+#define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
+#define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
+#define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+
+#define __XFS_HAS_FEAT(name, NAME) \
+static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+{ \
+	return mp->m_features & XFS_FEAT_ ## NAME; \
+}
+
+/* Some features can be added dynamically so they need a set wrapper, too. */
+#define __XFS_ADD_FEAT(name, NAME) \
+	__XFS_HAS_FEAT(name, NAME); \
+static inline void xfs_add_ ## name (struct xfs_mount *mp) \
+{ \
+	mp->m_features |= XFS_FEAT_ ## NAME; \
+	xfs_sb_version_add ## name(&mp->m_sb); \
+}
+
+/* Superblock features */
+__XFS_ADD_FEAT(attr, ATTR)
+__XFS_HAS_FEAT(nlink, NLINK)
+__XFS_ADD_FEAT(quota, QUOTA)
+__XFS_HAS_FEAT(align, ALIGN)
+__XFS_HAS_FEAT(dalign, DALIGN)
+__XFS_HAS_FEAT(logv2, LOGV2)
+__XFS_HAS_FEAT(sector, SECTOR)
+__XFS_HAS_FEAT(extflg, EXTFLG)
+__XFS_HAS_FEAT(asciici, ASCIICI)
+__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
+__XFS_ADD_FEAT(attr2, ATTR2)
+__XFS_HAS_FEAT(parent, PARENT)
+__XFS_ADD_FEAT(projid32, PROJID32)
+__XFS_HAS_FEAT(crc, CRC)
+__XFS_HAS_FEAT(v3inodes, V3INODES)
+__XFS_HAS_FEAT(pquotino, PQUOTINO)
+__XFS_HAS_FEAT(ftype, FTYPE)
+__XFS_HAS_FEAT(finobt, FINOBT)
+__XFS_HAS_FEAT(rmapbt, RMAPBT)
+__XFS_HAS_FEAT(reflink, REFLINK)
+__XFS_HAS_FEAT(sparseinodes, SPINODES)
+__XFS_HAS_FEAT(metauuid, META_UUID)
+__XFS_HAS_FEAT(realtime, REALTIME)
+__XFS_HAS_FEAT(inobtcounts, INOBTCNT)
+__XFS_HAS_FEAT(bigtime, BIGTIME)
+__XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
diff --git a/libxfs/init.c b/libxfs/init.c
index 9d8f2028..7d94b721 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -723,6 +723,7 @@ libxfs_mount(
 	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
 	int			error;
 
+	mp->m_features = xfs_sb_version_to_features(sb);
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b76e6380..a086fca2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -161,6 +161,7 @@
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
 #define xfs_sb_to_disk			libxfs_sb_to_disk
+#define xfs_sb_version_to_features	libxfs_sb_version_to_features
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ac739e6a..fdd35202 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -405,7 +405,7 @@ static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
 
-static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
+static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f29a59ae..100dd87d 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -28,6 +28,72 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
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
+	features |= XFS_FEAT_ALIGN | XFS_FEAT_LOGV2 | XFS_FEAT_EXTFLG |
+		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_ATTR2 | XFS_FEAT_PROJID32 |
+		    XFS_FEAT_V3INODES | XFS_FEAT_CRC | XFS_FEAT_PQUOTINO;
+
+	/* Optional V5 features */
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT)
+		features |= XFS_FEAT_FINOBT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		features |= XFS_FEAT_RMAPBT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK)
+		features |= XFS_FEAT_REFLINK;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
+		features |= XFS_FEAT_FTYPE;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
+		features |= XFS_FEAT_SPINODES;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
+		features |= XFS_FEAT_META_UUID;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME)
+		features |= XFS_FEAT_BIGTIME;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		features |= XFS_FEAT_NEEDSREPAIR;
+	return features;
+}
+
 /* Check all the superblock fields we care about when reading one in. */
 STATIC int
 xfs_validate_sb_read(
diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
index 0c1602d9..d2dd99cb 100644
--- a/libxfs/xfs_sb.h
+++ b/libxfs/xfs_sb.h
@@ -20,6 +20,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
+extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 18adf102..430961ff 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -80,6 +80,7 @@ logstat(xfs_mount_t *mp)
 		 */
 		sb = &mp->m_sb;
 		libxfs_sb_from_disk(sb, (xfs_dsb_t *)buf);
+		mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 		mp->m_blkbb_log = sb->sb_blocklog - BBSHIFT;
 
 		x.logBBsize = XFS_FSB_TO_BB(mp, sb->sb_logblocks);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b8c11ce9..2340b7b1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3425,6 +3425,7 @@ start_superblock_setup(
 	/* log reservation calculations depend on rt geometry */
 	sbp->sb_rblocks = cfg->rtblocks;
 	sbp->sb_rextsize = cfg->rtextblocks;
+	mp->m_features |= libxfs_sb_version_to_features(sbp);
 }
 
 static void
@@ -3484,6 +3485,7 @@ finish_superblock_setup(
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
+	mp->m_features |= libxfs_sb_version_to_features(sbp);
 
 }
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 32ffe18b..f13f785b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -192,8 +192,11 @@ upgrade_filesystem(
 		dirty |= set_inobtcount(mp);
 	if (add_bigtime)
 		dirty |= set_bigtime(mp);
+	if (!dirty)
+		return;
 
-        if (no_modify || !dirty)
+	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
+        if (no_modify)
                 return;
 
         bp = libxfs_getsb(mp);
diff --git a/repair/versions.c b/repair/versions.c
index 7f268f61..0b5376d7 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -82,6 +82,9 @@ update_sb_version(
 
 	if (!fs_aligned_inodes && xfs_sb_version_hasalign(&mp->m_sb))
 		mp->m_sb.sb_versionnum &= ~XFS_SB_VERSION_ALIGNBIT;
+
+	mp->m_features &= ~(XFS_FEAT_QUOTA | XFS_FEAT_ALIGN);
+	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
 }
 
 /*

