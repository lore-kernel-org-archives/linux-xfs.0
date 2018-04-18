Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:43:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2g63j045721
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:43:46 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2hdrxp0k4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:43:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2hjMH012646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:43:45 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2hiwi031962
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:43:44 GMT
Subject: [PATCH 18/24] xfs: zap broken inode forks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:43:43 -0700
Message-ID: <152401942337.12079.3459370985216128826.stgit@magnolia>
In-Reply-To: <152401930978.12079.2000682561964128780.stgit@magnolia>
References: <152401930978.12079.2000682561964128780.stgit@magnolia>
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
 fs/xfs/scrub/inode_repair.c   |  393 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 433 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2135b8e..01ce59a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -889,23 +889,16 @@ xfs_attr_shortform_allfit(
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
@@ -963,6 +956,23 @@ xfs_attr_shortform_verify(
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
index 4da08af..e5b4102 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -53,6 +53,8 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
+xfs_failaddr_t xfs_attr_shortform_verify_struct(struct xfs_attr_shortform *sfp,
+		size_t size);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1dd91c8..7f079c4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6175,18 +6175,16 @@ xfs_bmap_finish_one(
 	return error;
 }
 
-/* Check that an inode's extent does not have invalid flags or bad ranges. */
+/* Check that an extent does not have invalid flags or bad ranges. */
 xfs_failaddr_t
-xfs_bmap_validate_extent(
-	struct xfs_inode	*ip,
+xfs_bmbt_validate_extent(
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
@@ -6210,3 +6208,14 @@ xfs_bmap_validate_extent(
 	}
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
+	return xfs_bmbt_validate_extent(ip->i_mount, XFS_IS_REALTIME_INODE(ip),
+			whichfork, irec);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 25dd76f..9f9989a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -278,6 +278,8 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
 	}
 }
 
+xfs_failaddr_t xfs_bmbt_validate_extent(struct xfs_mount *mp, bool isrt,
+		int whichfork, struct xfs_bmbt_irec *irec);
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 9efbdc4..6db5078 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -36,11 +36,15 @@
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
@@ -87,11 +91,387 @@ xfs_repair_inode_buf(
 	}
 }
 
+struct xfs_repair_inode_fork_counters {
+	struct xfs_scrub_context	*sc;
+	xfs_rfsblock_t			data_blocks;
+	xfs_rfsblock_t			rt_blocks;
+	xfs_rfsblock_t			attr_blocks;
+	xfs_extnum_t			data_extents;
+	xfs_extnum_t			rt_extents;
+	xfs_aextnum_t			attr_extents;
+};
+
+/* Count extents and blocks for an inode given an rmap. */
+STATIC int
+xfs_repair_inode_count_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_repair_inode_fork_counters	*rifc = priv;
+
+	/* Is this even the right fork? */
+	if (rec->rm_owner != rifc->sc->sm->sm_ino)
+		return 0;
+	if (rec->rm_flags & XFS_RMAP_ATTR_FORK) {
+		rifc->attr_blocks += rec->rm_blockcount;
+		if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+			rifc->attr_extents++;
+	} else {
+		rifc->data_blocks += rec->rm_blockcount;
+		if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+			rifc->data_extents++;
+	}
+	return 0;
+}
+
+/* Count extents and blocks for an inode from all AG rmap data. */
+STATIC int
+xfs_repair_inode_count_ag_rmaps(
+	struct xfs_repair_inode_fork_counters	*rifc,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf;
+	int				error;
+
+	error = xfs_alloc_read_agf(rifc->sc->mp, rifc->sc->tp, agno, 0, &agf);
+	if (error)
+		return error;
+
+	cur = xfs_rmapbt_init_cursor(rifc->sc->mp, rifc->sc->tp, agf, agno);
+	if (!cur) {
+		error = -ENOMEM;
+		goto out_agf;
+	}
+
+	error = xfs_rmap_query_all(cur, xfs_repair_inode_count_rmap, rifc);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+out_agf:
+	xfs_trans_brelse(rifc->sc->tp, agf);
+	return error;
+}
+
+/* Count extents and blocks for a given inode from all rmap data. */
+STATIC int
+xfs_repair_inode_count_rmaps(
+	struct xfs_repair_inode_fork_counters	*rifc)
+{
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (!xfs_sb_version_hasrmapbt(&rifc->sc->mp->m_sb) ||
+	    xfs_sb_version_hasrealtime(&rifc->sc->mp->m_sb))
+		return -EOPNOTSUPP;
+
+	/* XXX: find rt blocks too */
+
+	for (agno = 0; agno < rifc->sc->mp->m_sb.sb_agcount; agno++) {
+		error = xfs_repair_inode_count_ag_rmaps(rifc, agno);
+		if (error)
+			return error;
+	}
+
+	/* Can't have extents on both the rt and the data device. */
+	if (rifc->data_extents && rifc->rt_extents)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/* Figure out if we need to zap this extents format fork. */
+STATIC bool
+xfs_repair_inode_core_check_extents_fork(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	int				dfork_size,
+	int				whichfork)
+{
+	struct xfs_bmbt_irec		new;
+	struct xfs_bmbt_rec		*dp;
+	bool				isrt;
+	int				i;
+	int				nex;
+	int				fork_size;
+
+	nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	fork_size = nex * sizeof(struct xfs_bmbt_rec);
+	if (fork_size < 0 || fork_size > dfork_size)
+		return true;
+	dp = (struct xfs_bmbt_rec *)XFS_DFORK_PTR(dip, whichfork);
+
+	isrt = dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
+	for (i = 0; i < nex; i++, dp++) {
+		xfs_failaddr_t	fa;
+
+		xfs_bmbt_disk_get_all(dp, &new);
+		fa = xfs_bmbt_validate_extent(sc->mp, isrt, whichfork, &new);
+		if (fa)
+			return true;
+	}
+
+	return false;
+}
+
+/* Figure out if we need to zap this btree format fork. */
+STATIC bool
+xfs_repair_inode_core_check_btree_fork(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	int				dfork_size,
+	int				whichfork)
+{
+	struct xfs_bmdr_block		*dfp;
+	int				nrecs;
+	int				level;
+
+	if (XFS_DFORK_NEXTENTS(dip, whichfork) <=
+			dfork_size / sizeof(struct xfs_bmbt_irec))
+		return true;
+
+	dfp = (struct xfs_bmdr_block *)XFS_DFORK_PTR(dip, whichfork);
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
+xfs_repair_inode_core_check_data_fork(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	uint16_t			mode)
+{
+	uint64_t			size;
+	int				dfork_size;
+
+	size = be64_to_cpu(dip->di_size);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		if (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK) != XFS_DINODE_FMT_DEV)
+			return true;
+		break;
+	case S_IFREG:
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
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
+	switch (XFS_DFORK_FORMAT(dip, XFS_DATA_FORK)) {
+	case XFS_DINODE_FMT_DEV:
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		if (size > dfork_size)
+			return true;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xfs_repair_inode_core_check_extents_fork(sc, dip,
+				dfork_size, XFS_DATA_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xfs_repair_inode_core_check_btree_fork(sc, dip,
+				dfork_size, XFS_DATA_FORK))
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
+xfs_repair_inode_core_zap_data_fork(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	uint16_t			mode,
+	struct xfs_repair_inode_fork_counters	*rifc)
+{
+	char				*p;
+	const struct xfs_dir_ops	*ops;
+	struct xfs_dir2_sf_hdr		*sfp;
+	int				i8count;
+
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
+	if (rifc->data_extents || rifc->rt_extents || S_ISREG(mode)) {
+		dip->di_format = XFS_DINODE_FMT_EXTENTS;
+		dip->di_nextents = 0;
+		return;
+	}
+
+	/* Otherwise, reset the local format to the minimum. */
+	switch (mode & S_IFMT) {
+	case S_IFLNK:
+		/* Blow out symlink; now it points to root dir */
+		dip->di_format = XFS_DINODE_FMT_LOCAL;
+		dip->di_size = cpu_to_be64(1);
+		p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+		*p = '/';
+		break;
+	case S_IFDIR:
+		/*
+		 * Blow out dir, make it point to the root.  In the
+		 * future the direction repair will reconstruct this
+		 * dir for us.
+		 */
+		dip->di_format = XFS_DINODE_FMT_LOCAL;
+		i8count = sc->mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
+		ops = xfs_dir_get_ops(sc->mp, NULL);
+		sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_PTR(dip,
+				XFS_DATA_FORK);
+		sfp->count = 0;
+		sfp->i8count = i8count;
+		ops->sf_put_parent_ino(sfp, sc->mp->m_sb.sb_rootino);
+		dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
+		break;
+	}
+}
+
+/*
+ * Check the attr fork for things that will fail the ifork verifiers or the
+ * ifork formatters.
+ */
+STATIC bool
+xfs_repair_inode_core_check_attr_fork(
+	struct xfs_scrub_context	*sc,
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
+		sfp = (struct xfs_attr_shortform *)XFS_DFORK_PTR(dip,
+				XFS_ATTR_FORK);
+		return xfs_attr_shortform_verify_struct(sfp, size) != NULL;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (xfs_repair_inode_core_check_extents_fork(sc, dip, size,
+				XFS_ATTR_FORK))
+			return true;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (xfs_repair_inode_core_check_btree_fork(sc, dip, size,
+				XFS_ATTR_FORK))
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
+xfs_repair_inode_core_zap_attr_fork(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	struct xfs_repair_inode_fork_counters	*rifc)
+{
+	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
+	dip->di_anextents = 0;
+	/*
+	 * We leave a nonzero forkoff so that the bmap scrub will look for
+	 * attr rmaps.
+	 */
+	dip->di_forkoff = rifc->attr_extents ? 1 : 0;
+}
+
+/*
+ * Zap the data/attr forks if we spot anything that isn't going to pass the
+ * ifork verifiers or the ifork formatters, because we need to get the inode
+ * into good enough shape that the higher level repair functions can run.
+ */
+STATIC void
+xfs_repair_inode_core_zap_forks(
+	struct xfs_scrub_context	*sc,
+	struct xfs_dinode		*dip,
+	uint16_t			mode,
+	struct xfs_repair_inode_fork_counters	*rifc)
+{
+	bool				zap_datafork = false;
+	bool				zap_attrfork = false;
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
+		zap_datafork = xfs_repair_inode_core_check_data_fork(sc, dip,
+				mode);
+	if (!zap_attrfork)
+		zap_attrfork = xfs_repair_inode_core_check_attr_fork(sc, dip);
+
+	/* Zap whatever's bad. */
+	if (zap_attrfork)
+		xfs_repair_inode_core_zap_attr_fork(sc, dip, rifc);
+	if (zap_datafork)
+		xfs_repair_inode_core_zap_data_fork(sc, dip, mode, rifc);
+	dip->di_nblocks = 0;
+	if (!zap_attrfork)
+		be64_add_cpu(&dip->di_nblocks, rifc->attr_blocks);
+	if (!zap_datafork) {
+		be64_add_cpu(&dip->di_nblocks, rifc->data_blocks);
+		be64_add_cpu(&dip->di_nblocks, rifc->rt_blocks);
+	}
+}
+
 /* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
 STATIC int
 xfs_repair_inode_core(
 	struct xfs_scrub_context	*sc)
 {
+	struct xfs_repair_inode_fork_counters	rifc;
 	struct xfs_imap			imap;
 	struct xfs_buf			*bp;
 	struct xfs_dinode		*dip;
@@ -101,6 +481,13 @@ xfs_repair_inode_core(
 	uint16_t			mode;
 	int				error;
 
+	/* Figure out what this inode had mapped in both forks. */
+	memset(&rifc, 0, sizeof(rifc));
+	rifc.sc = sc;
+	error = xfs_repair_inode_count_rmaps(&rifc);
+	if (error)
+		return error;
+
 	/* Map & read inode. */
 	ino = sc->sm->sm_ino;
 	error = xfs_imap(sc->mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
@@ -133,6 +520,10 @@ xfs_repair_inode_core(
 	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
 	flags = be16_to_cpu(dip->di_flags);
 	flags2 = be64_to_cpu(dip->di_flags2);
+	if (rifc.rt_extents)
+		flags |= XFS_DIFLAG_REALTIME;
+	else
+		flags &= ~XFS_DIFLAG_REALTIME;
 	if (xfs_sb_version_hasreflink(&sc->mp->m_sb) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
 	else
@@ -147,6 +538,8 @@ xfs_repair_inode_core(
 	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
 		dip->di_size = cpu_to_be64((1ULL << 63) - 1);
 
+	xfs_repair_inode_core_zap_forks(sc, dip, mode, &rifc);
+
 	/* Write out the inode... */
 	xfs_dinode_calc_crc(sc->mp, dip);
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);

