Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793E25A354
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185406; cv=none; b=PbWSFzn3dz/jiRpnzU39wxtUGCOBLUX1YkDM8S2dp7JtlAqBjfhtbn1tENVXs75QN/uPC4vZMQJoF4q7Re+sBLcgLUliVpPD/v6j7CNt6YMVa5zXfKDB4ob6riY1kooyxqKdjXhNTwxItiQ7TDVQv2lf07mAtyV2nOG0Ae/y+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185406; c=relaxed/simple;
	bh=B89fdV0cspH7TsJkjCzP2TxvI/U67IztO/6WRPy8L74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOKdsw6h073jka7vgsv5/JEuBWzK/CkFm16slEJJNz1u0PR1a25y/aAqDqJ5Bvj9rkHy4b5XdNTKzupGNjCjA532W9b6p9M63zmv9CcFFG4te+M3OTob0c+M/qqM7/sz6mpM3iL9/URqKBdTo3GV/WPlBhMKpZ/1OWydgF2ZSRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p8LXaMeT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p8LXaMeT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=od5EDLn/qR1MP5YwhjPhmqems20OVQ+pR17kI1O9jZk=; b=p8LXaMeT0HVMUj+NvbGFbfdnA8
	As7AcBQJFUPfM4/EMWxVgjTY0e8rwRDpfUhkzbAZjgQ4VqD3gChdtO4sAElgWYQsMjL1VNJ/ZspDa
	79EFs+JT2uW6GwgExLdSrz8n8cTW+YdRAji8j/wigT+/b0/nBt9KlbKQDW00kSGerbQa6Yn55SFiK
	hgZukPu9Oc7xr02FkHOmhuhi+RNHnPlwEPyyqx6vrmo8wU6aqTOPcgBt2i8EFJJyGtbfdZVFcTFR5
	hfvyMyjEyjy5t5anGay3u6PXhwSwmM3rIGKuFprAPCOpLVMoBoC391wxZg76jiazbPjv9nwjGlQJM
	oOL8nmFA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QId-00000006UJy-1xRl;
	Wed, 09 Apr 2025 07:56:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/45] xfs: define the zoned on-disk format
Date: Wed,  9 Apr 2025 09:55:13 +0200
Message-ID: <20250409075557.3535745-11-hch@lst.de>
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

Source kernel commit: 2167eaabe2fadde24cb8f1dafbec64da1d2ed2f5

Zone file systems reuse the basic RT group enabled XFS file system
structure to support a mode where each RT group is always written from
start to end and then reset for reuse (after moving out any remaining
data).  There are few minor but important changes, which are indicated
by a new incompat flag:

1) there are no bitmap and summary inodes, thus the
/rtgroups/{rgno}.{bitmap,summary} metadir files do not exist and the
sb_rbmblocks superblock field must be cleared to zero.

2) there is a new superblock field that specifies the start of an
internal RT section.  This allows supporting SMR HDDs that have random
writable space at the beginning which is used for the XFS data device
(which really is the metadata device for this configuration), directly
followed by a RT device on the same block device.  While something
similar could be achieved using dm-linear just having a single device
directly consumed by XFS makes handling the file systems a lot easier.

3) Another superblock field that tracks the amount of reserved space (or
overprovisioning) that is never used for user capacity, but allows GC
to run more smoothly.

4) an overlay of the cowextsize field for the rtrmap inode so that we
can persistently track the total amount of rtblocks currently used in
a RT group.  There is no data structure other than the rmap that
tracks used space in an RT group, and this counter is used to decide
when a RT group has been entirely emptied, and to select one that
is relatively empty if garbage collection needs to be performed.
While this counter could be tracked entirely in memory and rebuilt
from the rmap at mount time, that would lead to very long mount times
with the large number of RT groups implied by the number of hardware
zones especially on SMR hard drives with 256MB zone sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h     | 15 ++++++++--
 libxfs/xfs_inode_buf.c  | 21 ++++++++++----
 libxfs/xfs_inode_util.c |  1 +
 libxfs/xfs_log_format.h |  7 ++++-
 libxfs/xfs_ondisk.h     |  6 ++--
 libxfs/xfs_rtbitmap.c   | 11 +++++++
 libxfs/xfs_rtgroup.c    | 37 ++++++++++++++----------
 libxfs/xfs_sb.c         | 64 +++++++++++++++++++++++++++++++++++++++--
 8 files changed, 133 insertions(+), 29 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b1007fb661ba..f67380a25805 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -178,9 +178,10 @@ typedef struct xfs_sb {
 
 	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
 	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
-
 	uint8_t		sb_rgblklog;    /* rt group number shift */
 	uint8_t		sb_pad[7];	/* zeroes */
+	xfs_rfsblock_t	sb_rtstart;	/* start of internal RT section (FSB) */
+	xfs_filblks_t	sb_rtreserved;	/* reserved (zoned) RT blocks */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -270,9 +271,10 @@ struct xfs_dsb {
 	__be64		sb_metadirino;	/* metadata directory tree root */
 	__be32		sb_rgcount;	/* # of realtime groups */
 	__be32		sb_rgextents;	/* size of rtgroup in rtx */
-
 	__u8		sb_rgblklog;    /* rt group number shift */
 	__u8		sb_pad[7];	/* zeroes */
+	__be64		sb_rtstart;	/* start of internal RT section (FSB) */
+	__be64		sb_rtreserved;	/* reserved (zoned) RT blocks */
 
 	/*
 	 * The size of this structure must be padded to 64 bit alignment.
@@ -395,6 +397,8 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
+#define XFS_SB_FEAT_INCOMPAT_ZONED	(1 << 9)  /* zoned RT allocator */
+
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
 		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
@@ -952,7 +956,12 @@ struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__be32		di_cowextsize;	/* basic cow extent size for file */
+	union {
+		/* basic cow extent size for (regular) file */
+		__be32		di_cowextsize;
+		/* used blocks in RTG for (zoned) rtrmap inode */
+		__be32		di_used_blocks;
+	};
 	__u8		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5ca857ca2dc1..5ca753465b96 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -249,7 +249,10 @@ xfs_inode_from_disk(
 					   be64_to_cpu(from->di_changecount));
 		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
 		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
+		/* also covers the di_used_blocks union arm: */
 		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
+		BUILD_BUG_ON(sizeof(from->di_cowextsize) !=
+			     sizeof(from->di_used_blocks));
 	}
 
 	error = xfs_iformat_data_fork(ip, from);
@@ -346,6 +349,7 @@ xfs_inode_to_disk(
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
+		/* also covers the di_used_blocks union arm: */
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
@@ -749,11 +753,18 @@ xfs_dinode_verify(
 	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
-	/* COW extent size hint validation */
-	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
-			mode, flags, flags2);
-	if (fa)
-		return fa;
+	if (xfs_has_zoned(mp) &&
+	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)) {
+		if (be32_to_cpu(dip->di_used_blocks) > mp->m_sb.sb_rgextents)
+			return __this_address;
+	} else {
+		/* COW extent size hint validation */
+		fa = xfs_inode_validate_cowextsize(mp,
+				be32_to_cpu(dip->di_cowextsize),
+				mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
 
 	/* bigtime iflag can only happen on bigtime filesystems */
 	if (xfs_dinode_has_bigtime(dip) &&
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index edc985eb9a4e..2a7988d774b8 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -319,6 +319,7 @@ xfs_inode_init(
 
 	if (xfs_has_v3inodes(mp)) {
 		inode_set_iversion(inode, 1);
+		/* also covers the di_used_blocks union arm: */
 		ip->i_cowextsize = 0;
 		times |= XFS_ICHGTIME_CREATE;
 	}
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index a472ac2e45d0..0d637c276db0 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -475,7 +475,12 @@ struct xfs_log_dinode {
 	xfs_lsn_t	di_lsn;
 
 	uint64_t	di_flags2;	/* more random flags */
-	uint32_t	di_cowextsize;	/* basic cow extent size for file */
+	union {
+		/* basic cow extent size for (regular) file */
+		uint32_t		di_cowextsize;
+		/* used blocks in RTG for (zoned) rtrmap inode */
+		uint32_t		di_used_blocks;
+	};
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index a85ecddaa48e..5ed44fdf7491 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -233,8 +233,8 @@ xfs_check_ondisk_structs(void)
 			16299260424LL);
 
 	/* superblock field checks we got from xfs/122 */
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		288);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		288);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		304);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		304);
 	XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
 	XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
 	XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
@@ -295,6 +295,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
 	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
 	XFS_CHECK_SB_OFFSET(sb_pad,			281);
+	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
+	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 689d5844b8bd..34425a933650 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1118,6 +1118,7 @@ xfs_rtfree_blocks(
 	xfs_extlen_t		mod;
 	int			error;
 
+	ASSERT(!xfs_has_zoned(mp));
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
 	mod = xfs_blen_to_rtxoff(mp, rtlen);
@@ -1169,6 +1170,9 @@ xfs_rtalloc_query_range(
 
 	end = min(end, rtg->rtg_extents - 1);
 
+	if (xfs_has_zoned(mp))
+		return -EINVAL;
+
 	/* Iterate the bitmap, looking for discrepancies. */
 	while (start <= end) {
 		struct xfs_rtalloc_rec	rec;
@@ -1263,6 +1267,8 @@ xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
+	if (xfs_has_zoned(mp))
+		return 0;
 	return howmany_64(rtextents, xfs_rtbitmap_rtx_per_rbmblock(mp));
 }
 
@@ -1303,6 +1309,11 @@ xfs_rtsummary_blockcount(
 	xfs_rtbxlen_t		rextents = xfs_rtbitmap_bitcount(mp);
 	unsigned long long	rsumwords;
 
+	if (xfs_has_zoned(mp)) {
+		*rsumlevels = 0;
+		return 0;
+	}
+
 	*rsumlevels = xfs_compute_rextslog(rextents) + 1;
 	rsumwords = xfs_rtbitmap_blockcount_len(mp, rextents) * (*rsumlevels);
 	return howmany_64(rsumwords, mp->m_blockwsize);
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 6f65ecc3015d..e58968286f32 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -191,15 +191,17 @@ xfs_rtgroup_lock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		/*
-		 * Lock both realtime free space metadata inodes for a freespace
-		 * update.
-		 */
-		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
-		xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
-	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
+	if (!xfs_has_zoned(rtg_mount(rtg))) {
+		if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+			/*
+			 * Lock both realtime free space metadata inodes for a
+			 * freespace update.
+			 */
+			xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+			xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
+		} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
+			xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
+		}
 	}
 
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
@@ -225,11 +227,13 @@ xfs_rtgroup_unlock(
 	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
 		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
-		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
-	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
+	if (!xfs_has_zoned(rtg_mount(rtg))) {
+		if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+			xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
+			xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+		} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
+			xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
+		}
 	}
 }
 
@@ -246,7 +250,8 @@ xfs_rtgroup_trans_join(
 	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+	if (!xfs_has_zoned(rtg_mount(rtg)) &&
+	    (rtglock_flags & XFS_RTGLOCK_BITMAP)) {
 		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
 	}
@@ -351,6 +356,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.sick		= XFS_SICK_RG_BITMAP,
 		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
 				  (1U << XFS_DINODE_FMT_BTREE),
+		.enabled	= xfs_has_nonzoned,
 		.create		= xfs_rtbitmap_create,
 	},
 	[XFS_RTGI_SUMMARY] = {
@@ -359,6 +365,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.sick		= XFS_SICK_RG_SUMMARY,
 		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
 				  (1U << XFS_DINODE_FMT_BTREE),
+		.enabled	= xfs_has_nonzoned,
 		.create		= xfs_rtsummary_create,
 	},
 	[XFS_RTGI_RMAP] = {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 1781ca36b2cc..bc84792c565c 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -27,6 +27,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -182,6 +183,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_PARENT;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
 		features |= XFS_FEAT_METADIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)
+		features |= XFS_FEAT_ZONED;
 
 	return features;
 }
@@ -263,6 +266,9 @@ static uint64_t
 xfs_expected_rbmblocks(
 	struct xfs_sb		*sbp)
 {
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED))
+		return 0;
 	return howmany_64(xfs_extents_per_rbm(sbp),
 			  NBBY * xfs_rtbmblock_size(sbp));
 }
@@ -272,9 +278,15 @@ bool
 xfs_validate_rt_geometry(
 	struct xfs_sb		*sbp)
 {
-	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
-	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)
-		return false;
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		if (sbp->sb_rextsize != 1)
+			return false;
+	} else {
+		if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
+		    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)
+			return false;
+	}
 
 	if (sbp->sb_rblocks == 0) {
 		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
@@ -432,6 +444,34 @@ xfs_validate_sb_rtgroups(
 	return 0;
 }
 
+static int
+xfs_validate_sb_zoned(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp)
+{
+	if (sbp->sb_frextents != 0) {
+		xfs_warn(mp,
+"sb_frextents must be zero for zoned file systems.");
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rtstart && sbp->sb_rtstart < sbp->sb_dblocks) {
+		xfs_warn(mp,
+"sb_rtstart (%lld) overlaps sb_dblocks (%lld).",
+			sbp->sb_rtstart, sbp->sb_dblocks);
+		return -EINVAL;
+	}
+
+	if (sbp->sb_rtreserved && sbp->sb_rtreserved >= sbp->sb_rblocks) {
+		xfs_warn(mp,
+"sb_rtreserved (%lld) larger than sb_rblocks (%lld).",
+			sbp->sb_rtreserved, sbp->sb_rblocks);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Check the validity of the SB. */
 STATIC int
 xfs_validate_sb_common(
@@ -520,6 +560,11 @@ xfs_validate_sb_common(
 			if (error)
 				return error;
 		}
+		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
+			error = xfs_validate_sb_zoned(mp, sbp);
+			if (error)
+				return error;
+		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
@@ -832,6 +877,14 @@ __xfs_sb_from_disk(
 		to->sb_rgcount = 1;
 		to->sb_rgextents = 0;
 	}
+
+	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
+		to->sb_rtstart = be64_to_cpu(from->sb_rtstart);
+		to->sb_rtreserved = be64_to_cpu(from->sb_rtreserved);
+	} else {
+		to->sb_rtstart = 0;
+		to->sb_rtreserved = 0;
+	}
 }
 
 void
@@ -998,6 +1051,11 @@ xfs_sb_to_disk(
 		to->sb_rbmino = cpu_to_be64(0);
 		to->sb_rsumino = cpu_to_be64(0);
 	}
+
+	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
+		to->sb_rtstart = cpu_to_be64(from->sb_rtstart);
+		to->sb_rtreserved = cpu_to_be64(from->sb_rtreserved);
+	}
 }
 
 /*
-- 
2.47.2

