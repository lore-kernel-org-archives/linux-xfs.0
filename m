Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 682FA7F82
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47BBA304064
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	43CeRHmR3qxObEi5 for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:20:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001jS-Dz
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006xO-Cw
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 18/18] xfs: add xfs_da_geometry to inode forks
Date: Thu,  8 May 2014 18:19:48 +1000
Message-Id: <1399537188-26509-19-git-send-email-david@fromorbit.com>
In-Reply-To: <1399537188-26509-1-git-send-email-david@fromorbit.com>
References: <1399537188-26509-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Right now the geometry source for directory and attributes is the
struct xfs_mount - it's global. There's nothing stopping use from
having per-inode directory geometry or (in future) attribute
geometry.

To move the dependency on the struct xfs_mount out from the da_args
setup code, add a geometry pointer to the struct xfs_inode_fork.
This can be set up for directories when the inode is instantiated,
either from the xfs_mount or from the on-disk inode configuration
(think extent size hints for directories).

While this might seem wasteful to burn a pointer in the data fork
for all files, consider that the geometry information
for data allocation can be abstracted from the xfs_mount in exactly
the same way as has been done for the directory geometry.
Effectively it's a hook to carry allocation policy around in....

So, add the geometry pointer to the inode fork, and initialise is
appropriately and use it for all the directory and attribute
operation setup instead ofthe xfs_mount version.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c         |  6 +++---
 fs/xfs/xfs_attr_leaf.c    |  2 +-
 fs/xfs/xfs_attr_list.c    |  2 +-
 fs/xfs/xfs_bmap.c         |  2 +-
 fs/xfs/xfs_da_btree.c     |  4 ++--
 fs/xfs/xfs_dir2.c         | 12 ++++++------
 fs/xfs/xfs_dir2_block.c   |  4 ++--
 fs/xfs/xfs_dir2_data.c    |  4 ++--
 fs/xfs/xfs_dir2_leaf.c    |  5 ++++-
 fs/xfs/xfs_dir2_node.c    |  2 +-
 fs/xfs/xfs_dir2_readdir.c |  2 +-
 fs/xfs/xfs_dir2_sf.c      |  2 +-
 fs/xfs/xfs_inode_fork.c   |  1 +
 fs/xfs/xfs_inode_fork.h   |  2 ++
 fs/xfs/xfs_iops.c         |  1 +
 15 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 86d75ad..086225a 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -124,7 +124,7 @@ xfs_attr_get_int(
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.geo = ip->i_mount->m_attr_geo;
+	args.geo = ip->i_afp->if_geo;
 	args.name = name->name;
 	args.namelen = name->len;
 	args.value = value;
@@ -258,7 +258,7 @@ xfs_attr_set_int(
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.geo = dp->i_mount->m_attr_geo;
+	args.geo = dp->i_afp->if_geo;
 	args.name = name->name;
 	args.namelen = name->len;
 	args.value = value;
@@ -474,7 +474,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.geo = dp->i_mount->m_attr_geo;
+	args.geo = dp->i_afp->if_geo;
 	args.name = name->name;
 	args.namelen = name->len;
 	args.flags = flags;
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 78f47af..d3ef7a8 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -839,7 +839,7 @@ xfs_attr3_leaf_to_shortform(
 	 * Copy the attributes
 	 */
 	memset((char *)&nargs, 0, sizeof(nargs));
-	nargs.geo = dp->i_mount->m_attr_geo;
+	nargs.geo = dp->i_afp->if_geo;
 	nargs.dp = dp;
 	nargs.firstblock = args->firstblock;
 	nargs.flist = args->flist;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 90e2eeb..62366f9 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -444,7 +444,7 @@ xfs_attr3_leaf_list_int(
 				xfs_da_args_t args;
 
 				memset((char *)&args, 0, sizeof(args));
-				args.geo = context->dp->i_mount->m_attr_geo;
+				args.geo = context->dp->i_afp->if_geo;
 				args.dp = context->dp;
 				args.whichfork = XFS_ATTR_FORK;
 				args.valuelen = valuelen;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 96175df..f87fc63 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1098,7 +1098,7 @@ xfs_bmap_add_attrfork_local(
 
 	if (S_ISDIR(ip->i_d.di_mode)) {
 		memset(&dargs, 0, sizeof(dargs));
-		dargs.geo = ip->i_mount->m_dir_geo;
+		dargs.geo = ip->i_df.if_geo;
 		dargs.dp = ip;
 		dargs.firstblock = firstblock;
 		dargs.flist = flist;
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index f935370..408ad73 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -2469,9 +2469,9 @@ xfs_dabuf_map(
 	ASSERT(*nmaps == 1);
 
 	if (whichfork == XFS_DATA_FORK)
-		nfsb = mp->m_dir_geo->fsbcount;
+		nfsb = dp->i_df.if_geo->fsbcount;
 	else
-		nfsb = mp->m_attr_geo->fsbcount;
+		nfsb = dp->i_afp->if_geo->fsbcount;
 
 	/*
 	 * Caller doesn't have a mapping.  -2 means don't complain
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 5a45681..7b678e7 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -219,7 +219,7 @@ xfs_dir_init(
 	if (!args)
 		return ENOMEM;
 
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->dp = dp;
 	args->trans = tp;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
@@ -254,7 +254,7 @@ xfs_dir_createname(
 	if (!args)
 		return ENOMEM;
 
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
@@ -349,7 +349,7 @@ xfs_dir_lookup(
 	 * annotations into the reclaim path for the ilock.
 	 */
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
@@ -421,7 +421,7 @@ xfs_dir_removename(
 	if (!args)
 		return ENOMEM;
 
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
@@ -486,7 +486,7 @@ xfs_dir_replace(
 	if (!args)
 		return ENOMEM;
 
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
@@ -548,7 +548,7 @@ xfs_dir_canenter(
 	if (!args)
 		return ENOMEM;
 
-	args->geo = dp->i_mount->m_dir_geo;
+	args->geo = dp->i_df.if_geo;
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index c7cd315..d13e1cc 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -133,10 +133,9 @@ xfs_dir3_block_read(
 	struct xfs_inode	*dp,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_mount	*mp = dp->i_mount;
 	int			err;
 
-	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
+	err = xfs_da_read_buf(tp, dp, dp->i_df.if_geo->datablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
 	if (!err && tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
@@ -580,6 +579,7 @@ xfs_dir2_block_log_leaf(
 	xfs_dir2_leaf_entry_t	*blp;
 	xfs_dir2_block_tail_t	*btp;
 
+	/* XXX pass args for geo! */
 	btp = xfs_dir2_block_tail_p(tp->t_mountp->m_dir_geo, hdr);
 	blp = xfs_dir2_block_leaf_p(btp);
 	xfs_trans_log_buf(tp, bp, (uint)((char *)&blp[first] - (char *)hdr),
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 8c2f642..2b35929 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -66,7 +66,7 @@ __xfs_dir3_data_check(
 	struct xfs_da_geometry	*geo;
 
 	mp = bp->b_target->bt_mount;
-	geo = mp->m_dir_geo;
+	geo = dp->i_df.if_geo;
 
 	/*
 	 * We can be passed a null dp here from a verifier, so we need to go the
@@ -511,7 +511,7 @@ xfs_dir2_data_freescan(
 	struct xfs_dir2_data_free *bf;
 	char			*endp;		/* end of block's data */
 	char			*p;		/* current entry pointer */
-	struct xfs_da_geometry	*geo = dp->i_mount->m_dir_geo;
+	struct xfs_da_geometry	*geo = dp->i_df.if_geo;	/* XXX: pass args! */
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index fb0aad4..dd3f268 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -93,7 +93,7 @@ xfs_dir3_leaf_check_int(
 	int			i;
 	const struct xfs_dir_ops *ops;
 	struct xfs_dir3_icleaf_hdr leafhdr;
-	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_da_geometry	*geo = dp->i_df.if_geo;
 
 	/*
 	 * we can be passed a null dp here from a verifier, so we need to go the
@@ -289,6 +289,8 @@ xfs_dir3_leafn_read(
 
 /*
  * Initialize a new leaf block, leaf1 or leafn magic accepted.
+ *
+ * XXX: pass args for geo!
  */
 static void
 xfs_dir3_leaf_init(
@@ -325,6 +327,7 @@ xfs_dir3_leaf_init(
 	if (type == XFS_DIR2_LEAF1_MAGIC) {
 		struct xfs_dir2_leaf_tail *ltp;
 
+		/* XXX: pass args for geo! */
 		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
 		ltp->bestcount = 0;
 		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 65df8cb..52d7027 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -472,7 +472,7 @@ xfs_dir2_free_hdr_check(
 	dp->d_ops->free_hdr_from_disk(&hdr, bp->b_addr);
 
 	ASSERT((hdr.firstdb %
-		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
+		dp->d_ops->free_max_bests(dp->i_df.if_geo)) == 0);
 	ASSERT(hdr.firstdb <= db);
 	ASSERT(db < hdr.firstdb + hdr.nvalid);
 }
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 6a120ca..e444b4c 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -681,7 +681,7 @@ xfs_readdir(
 	XFS_STATS_INC(xs_dir_getdents);
 
 	args.dp = dp;
-	args.geo = dp->i_mount->m_dir_geo;
+	args.geo = dp->i_df.if_geo;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 53c3be6..2574d20 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -85,7 +85,7 @@ xfs_dir2_block_sfsize(
 	struct xfs_da_geometry	*geo;
 
 	mp = dp->i_mount;
-	geo = mp->m_dir_geo;
+	geo = dp->i_df.if_geo;
 
 	/*
 	 * if there is a filetype field, add the extra byte to the namelen
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index b031e8d..ea28c52 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -197,6 +197,7 @@ xfs_iformat_fork(
 
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP | KM_NOFS);
+	ip->i_afp->if_geo = ip->i_mount->m_attr_geo;
 
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/xfs_inode_fork.h b/fs/xfs/xfs_inode_fork.h
index 7d3b1ed..ecfd756 100644
--- a/fs/xfs/xfs_inode_fork.h
+++ b/fs/xfs/xfs_inode_fork.h
@@ -20,6 +20,7 @@
 
 struct xfs_inode_log_item;
 struct xfs_dinode;
+struct xfs_da_geometry;
 
 /*
  * The following xfs_ext_irec_t struct introduces a second (top) level
@@ -59,6 +60,7 @@ typedef struct xfs_ifork {
 	struct xfs_btree_block	*if_broot;	/* file's incore btree root */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
+	struct xfs_da_geometry	*if_geo;	/* allocation geometry */
 	union {
 		xfs_bmbt_rec_host_t *if_extents;/* linear map file exts */
 		xfs_ext_irec_t	*if_ext_irec;	/* irec map file exts */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 699d5a1..ec63b3c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1263,6 +1263,7 @@ xfs_setup_inode(
 			inode->i_op = &xfs_dir_inode_operations;
 		inode->i_fop = &xfs_dir_file_operations;
 		ip->d_ops = ip->i_mount->m_dir_inode_ops;
+		ip->i_df.if_geo = ip->i_mount->m_dir_geo;
 		break;
 	case S_IFLNK:
 		inode->i_op = &xfs_symlink_inode_operations;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
