Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:35:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750O3X8023851
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:41 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51ptmbam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0n0195531
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u51kktt0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x750ZdhA002546
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:39 GMT
Subject: [PATCH 08/18] xfs: zap broken inode forks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 04 Aug 2019 17:35:33 -0700
Message-ID: <156496533378.804304.1444658291965701667.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Determine if inode fork damage is responsible for the inode being unable
to pass the ifork verifiers in xfs_iget and zap the fork contents if
this is true.  Once this is done the fork will be empty but we'll be
able to construct an in-core inode, and a subsequent call to the inode
fork repair ioctl will search the rmapbt to rebuild the records that
were in the fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   32 ++-
 fs/xfs/libxfs/xfs_attr_leaf.h |    2 
 fs/xfs/libxfs/xfs_bmap.c      |   21 ++
 fs/xfs/libxfs/xfs_bmap.h      |    2 
 fs/xfs/scrub/inode_repair.c   |  401 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 439 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 70eb941d02e4..70b94fe09a53 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -890,23 +890,16 @@ xfs_attr_shortform_allfit(
 	return xfs_attr_shortform_bytesfit(dp, bytes);
 }
 
-/* Verify the consistency of an inline attribute fork. */
+/* Verify the consistency of a raw inline attribute fork. */
 xfs_failaddr_t
-xfs_attr_shortform_verify(
-	struct xfs_inode		*ip)
+xfs_attr_shortform_verify_struct(
+	struct xfs_attr_shortform	*sfp,
+	size_t				size)
 {
-	struct xfs_attr_shortform	*sfp;
 	struct xfs_attr_sf_entry	*sfep;
 	struct xfs_attr_sf_entry	*next_sfep;
 	char				*endp;
-	struct xfs_ifork		*ifp;
 	int				i;
-	int				size;
-
-	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
-	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
-	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
 
 	/*
 	 * Give up if the attribute is way too short.
@@ -964,6 +957,23 @@ xfs_attr_shortform_verify(
 	return NULL;
 }
 
+/* Verify the consistency of an inline attribute fork. */
+xfs_failaddr_t
+xfs_attr_shortform_verify(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr_shortform	*sfp;
+	struct xfs_ifork		*ifp;
+	int				size;
+
+	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
+	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
+	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
+	size = ifp->if_bytes;
+
+	return xfs_attr_shortform_verify_struct(sfp, size);
+}
+
 /*
  * Convert a leaf attribute list to shortform attribute list
  */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 7b74e18becff..728af25a1738 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -41,6 +41,8 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
+xfs_failaddr_t xfs_attr_shortform_verify_struct(struct xfs_attr_shortform *sfp,
+		size_t size);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2a1bfca79938..39dbc93374dc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6187,18 +6187,16 @@ xfs_bmap_finish_one(
 	return error;
 }
 
-/* Check that an inode's extent does not have invalid flags or bad ranges. */
+/* Check that an extent does not have invalid flags or bad ranges. */
 xfs_failaddr_t
-xfs_bmap_validate_extent(
-	struct xfs_inode	*ip,
+xfs_bmap_validate_extent_raw(
+	struct xfs_mount	*mp,
+	bool			isrt,
 	int			whichfork,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsblock_t		endfsb;
-	bool			isrt;
 
-	isrt = XFS_IS_REALTIME_INODE(ip);
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt) {
 		if (!xfs_verify_rtbno(mp, irec->br_startblock))
@@ -6218,3 +6216,14 @@ xfs_bmap_validate_extent(
 		return __this_address;
 	return NULL;
 }
+
+/* Check that an inode's extent does not have invalid flags or bad ranges. */
+xfs_failaddr_t
+xfs_bmap_validate_extent(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_bmbt_irec	*irec)
+{
+	return xfs_bmap_validate_extent_raw(ip->i_mount,
+			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 8f597f9abdbe..b857762fac55 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -271,6 +271,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
 	}
 }
 
+xfs_failaddr_t xfs_bmap_validate_extent_raw(struct xfs_mount *mp, bool isrt,
+		int whichfork, struct xfs_bmbt_irec *irec);
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index fd6353a907d8..dddcb69a0601 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -22,11 +22,15 @@
 #include "xfs_ialloc.h"
 #include "xfs_da_format.h"
 #include "xfs_reflink.h"
+#include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_quota_defs.h"
+#include "xfs_attr_leaf.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -139,7 +143,8 @@ xrep_dinode_mode(
 STATIC void
 xrep_dinode_flags(
 	struct xfs_scrub	*sc,
-	struct xfs_dinode	*dip)
+	struct xfs_dinode	*dip,
+	bool			is_rt_file)
 {
 	struct xfs_mount	*mp = sc->mp;
 	uint64_t		flags2;
@@ -150,6 +155,11 @@ xrep_dinode_flags(
 	flags = be16_to_cpu(dip->di_flags);
 	flags2 = be64_to_cpu(dip->di_flags2);
 
+	if (is_rt_file)
+		flags |= XFS_DIFLAG_REALTIME;
+	else
+		flags &= ~XFS_DIFLAG_REALTIME;
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
 	else
@@ -288,11 +298,392 @@ xrep_dinode_extsize_hints(
 	}
 }
 
+/* Blocks and extents associated with an inode, according to rmap records. */
+struct xrep_dinode_stats {
+	struct xfs_scrub	*sc;
+
+	/* Blocks in use on the data device by data extents or bmbt blocks. */
+	xfs_rfsblock_t		data_blocks;
+
+	/* Blocks in use on the rt device. */
+	xfs_rfsblock_t		rt_blocks;
+
+	/* Blocks in use by the attr fork. */
+	xfs_rfsblock_t		attr_blocks;
+
+	/* Number of data device extents for the data fork. */
+	xfs_extnum_t		data_extents;
+
+	/*
+	 * Number of realtime device extents for the data fork.  If
+	 * data_extents and rt_extents indicate that the data fork has extents
+	 * on both devices, we'll just back away slowly.
+	 */
+	xfs_extnum_t		rt_extents;
+
+	/* Number of (data device) extents for the attr fork. */
+	xfs_aextnum_t		attr_extents;
+};
+
+/* Count extents and blocks for an inode given an rmap. */
+STATIC int
+xrep_dinode_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xrep_dinode_stats	*dis = priv;
+
+	/* Is this even the right fork? */
+	if (rec->rm_owner != dis->sc->sm->sm_ino)
+		return 0;
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK) {
+		dis->attr_blocks += rec->rm_blockcount;
+		if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+			dis->attr_extents++;
+	} else {
+		dis->data_blocks += rec->rm_blockcount;
+		if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+			dis->data_extents++;
+	}
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all AG rmap data. */
+STATIC int
+xrep_dinode_count_ag_rmaps(
+	struct xrep_dinode_stats	*dis,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf;
+	int				error;
+
+	error = xfs_alloc_read_agf(dis->sc->mp, dis->sc->tp, agno, 0, &agf);
+	if (error)
+		return error;
+
+	cur = xfs_rmapbt_init_cursor(dis->sc->mp, dis->sc->tp, agf, agno);
+	if (!cur) {
+		error = -ENOMEM;
+		goto out_agf;
+	}
+
+	error = xfs_rmap_query_all(cur, xrep_dinode_walk_rmap, dis);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, error);
+out_agf:
+	xfs_trans_brelse(dis->sc->tp, agf);
+	return error;
+}
+
+/* Count extents and blocks for a given inode from all rmap data. */
+STATIC int
+xrep_dinode_count_rmaps(
+	struct xrep_dinode_stats	*dis)
+{
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (!xfs_sb_version_hasrmapbt(&dis->sc->mp->m_sb) ||
+	    xfs_sb_version_hasrealtime(&dis->sc->mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* XXX: find rt blocks too */
+	if (dis->rt_extents != 0) {
+		ASSERT(0);
+		return -EOPNOTSUPP;
+	}
+
+	for (agno = 0; agno < dis->sc->mp->m_sb.sb_agcount; agno++) {
+		error = xrep_dinode_count_ag_rmaps(dis, agno);
+		if (error)
+			return error;
+	}
+
+	/* Can't have extents on both the rt and the data device. */
+	if (dis->data_extents && dis->rt_extents)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Return true if this extents-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_extents_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	int			dfork_size,
+	int			whichfork)
+{
+	struct xfs_bmbt_irec	new;
+	struct xfs_bmbt_rec	*dp;
+	bool			isrt;
+	int			i;
+	int			nex;
+	int			fork_size;
+
+	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	fork_size = nex * sizeof(struct xfs_bmbt_rec);
+	if (fork_size < 0 || fork_size > dfork_size)
+		return true;
+	if (whichfork == XFS_ATTR_FORK && nex > ((uint16_t)-1U))
+		return true;
+	dp = XFS_DFORK_PTR(dip, whichfork);
+
+	isrt = dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+	for (i = 0; i < nex; i++, dp++) {
+		xfs_failaddr_t	fa;
+
+		xfs_bmbt_disk_get_all(dp, &new);
+		fa = xfs_bmap_validate_extent_raw(sc->mp, isrt, whichfork,
+				&new);
+		if (fa)
+			return true;
+	}
+
+	return false;
+}
+
+/* Return true if this btree-format ifork looks like garbage. */
+STATIC bool
+xrep_dinode_bad_btree_fork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	int			dfork_size,
+	int			whichfork)
+{
+	struct xfs_bmdr_block	*dfp;
+	int			nrecs;
+	int			level;
+
+	if (XFS_DFORK_NEXTENTS(dip, whichfork) <=
+			dfork_size / sizeof(struct xfs_bmbt_rec))
+		return true;
+
+	dfp = XFS_DFORK_PTR(dip, whichfork);
+	nrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (nrecs == 0 || XFS_BMDR_SPACE_CALC(nrecs) > dfork_size)
+		return true;
+	if (level == 0 || level > XFS_BTREE_MAXLEVELS)
+		return true;
+	return false;
+}
+
+/*
+ * Check the data fork for things that will fail the ifork verifiers or the
+ * ifork formatters.
+ */
+STATIC bool
+xrep_dinode_check_dfork(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip,
+	uint16_t		mode)
+{
+	uint64_t		size;
+	unsigned int		fmt;
+	int			dfork_size;
+
+	fmt = XFS_DFORK_FORMAT(dip, XFS_DATA_FORK);
+	size = be64_to_cpu(dip->di_size);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		if (fmt != XFS_DINODE_FMT_DEV)
+			return true;
+		break;
+	case S_IFREG:
+		if (fmt == XFS_DINODE_FMT_LOCAL)
+			return true;
+		/* fall through */
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (fmt) {
+		case XFS_DINODE_FMT_LOCAL:
+		case XFS_DINODE_FMT_EXTENTS:
+		case XFS_DINODE_FMT_BTREE:
+			break;
+		default:
+			return true;
+		}
+		break;
+	default:
+		return true;
+	}
+	dfork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_DATA_FORK);
+	switch (fmt) {
+	case XFS_DINODE_FMT_DEV:
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		if (size > dfork_size)
+			return true;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xrep_dinode_bad_extents_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xrep_dinode_bad_btree_fork(sc, dip, dfork_size,
+				XFS_DATA_FORK))
+			return true;
+		break;
+	default:
+		return true;
+	}
+
+	return false;
+}
+
+/* Reset the data fork to something sane. */
+STATIC void
+xrep_dinode_zap_dfork(
+	struct xfs_scrub		*sc,
+	struct xfs_dinode		*dip,
+	uint16_t			mode,
+	struct xrep_dinode_stats	*dis)
+{
+	/* Special files always get reset to DEV */
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		dip->di_format = XFS_DINODE_FMT_DEV;
+		dip->di_size = 0;
+		return;
+	}
+
+	/*
+	 * If we have data extents, reset to an empty map and hope the user
+	 * will run the bmapbtd checker next.
+	 */
+	if (dis->data_extents || dis->rt_extents || S_ISREG(mode)) {
+		dip->di_format = XFS_DINODE_FMT_EXTENTS;
+		dip->di_nextents = 0;
+		return;
+	}
+
+	/* Otherwise, reset the local format to the minimum. */
+	switch (mode & S_IFMT) {
+	case S_IFLNK:
+		xrep_dinode_zap_symlink(dip);
+		break;
+	case S_IFDIR:
+		xrep_dinode_zap_dir(sc->mp, dip);
+		break;
+	}
+}
+
+/*
+ * Check the attr fork for things that will fail the ifork verifiers or the
+ * ifork formatters.
+ */
+STATIC bool
+xrep_dinode_check_afork(
+	struct xfs_scrub		*sc,
+	struct xfs_dinode		*dip)
+{
+	struct xfs_attr_shortform	*sfp;
+	int				size;
+
+	if (XFS_DFORK_BOFF(dip) == 0)
+		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
+		       dip->di_anextents != 0;
+
+	size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
+	switch (XFS_DFORK_FORMAT(dip, XFS_ATTR_FORK)) {
+	case XFS_DINODE_FMT_LOCAL:
+		sfp = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);
+		return xfs_attr_shortform_verify_struct(sfp, size) != NULL;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xrep_dinode_bad_extents_fork(sc, dip, size, XFS_ATTR_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xrep_dinode_bad_btree_fork(sc, dip, size, XFS_ATTR_FORK))
+			return true;
+		break;
+	default:
+		return true;
+	}
+
+	return false;
+}
+
+/* Reset the attr fork to something sane. */
+STATIC void
+xrep_dinode_zap_afork(
+	struct xfs_scrub		*sc,
+	struct xfs_dinode		*dip,
+	struct xrep_dinode_stats	*dis)
+{
+	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
+	dip->di_anextents = 0;
+	/*
+	 * We leave a nonzero forkoff so that the bmap scrub will look for
+	 * attr rmaps.
+	 */
+	dip->di_forkoff = dis->attr_extents ? 1 : 0;
+}
+
+/*
+ * Zap the data/attr forks if we spot anything that isn't going to pass the
+ * ifork verifiers or the ifork formatters, because we need to get the inode
+ * into good enough shape that the higher level repair functions can run.
+ */
+STATIC void
+xrep_dinode_zap_forks(
+	struct xfs_scrub		*sc,
+	struct xfs_dinode		*dip,
+	struct xrep_dinode_stats	*dis)
+{
+	uint16_t			mode;
+	bool				zap_datafork = false;
+	bool				zap_attrfork = false;
+
+	mode = be16_to_cpu(dip->di_mode);
+
+	/* Inode counters don't make sense? */
+	if (be32_to_cpu(dip->di_nextents) > be64_to_cpu(dip->di_nblocks))
+		zap_datafork = true;
+	if (be16_to_cpu(dip->di_anextents) > be64_to_cpu(dip->di_nblocks))
+		zap_attrfork = true;
+	if (be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
+			be64_to_cpu(dip->di_nblocks))
+		zap_datafork = zap_attrfork = true;
+
+	if (!zap_datafork)
+		zap_datafork = xrep_dinode_check_dfork(sc, dip, mode);
+	if (!zap_attrfork)
+		zap_attrfork = xrep_dinode_check_afork(sc, dip);
+
+	/* Zap whatever's bad. */
+	if (zap_attrfork)
+		xrep_dinode_zap_afork(sc, dip, dis);
+	if (zap_datafork)
+		xrep_dinode_zap_dfork(sc, dip, mode, dis);
+	dip->di_nblocks = 0;
+	if (!zap_attrfork)
+		be64_add_cpu(&dip->di_nblocks, dis->attr_blocks);
+	if (!zap_datafork) {
+		be64_add_cpu(&dip->di_nblocks, dis->data_blocks);
+		be64_add_cpu(&dip->di_nblocks, dis->rt_blocks);
+	}
+}
+
 /* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
 STATIC int
 xrep_dinode_core(
 	struct xfs_scrub	*sc)
 {
+	struct xrep_dinode_stats	dis = { .sc = sc };
 	struct xfs_imap		imap;
 	struct xfs_buf		*bp;
 	struct xfs_dinode	*dip;
@@ -300,6 +691,11 @@ xrep_dinode_core(
 	bool			inuse;
 	int			error;
 
+	/* Figure out what this inode had mapped in both forks. */
+	error = xrep_dinode_count_rmaps(&dis);
+	if (error)
+		return error;
+
 	/* Map & read inode. */
 	ino = sc->sm->sm_ino;
 	error = xfs_imap(sc->mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
@@ -326,9 +722,10 @@ xrep_dinode_core(
 	dip = xfs_buf_offset(bp, imap.im_boffset);
 	xrep_dinode_header(sc, dip);
 	xrep_dinode_mode(dip);
-	xrep_dinode_flags(sc, dip);
+	xrep_dinode_flags(sc, dip, dis.rt_extents > 0);
 	xrep_dinode_size(sc->mp, dip);
 	xrep_dinode_extsize_hints(sc, dip);
+	xrep_dinode_zap_forks(sc, dip, &dis);
 
 	/* Write out the inode... */
 	xfs_dinode_calc_crc(sc->mp, dip);
