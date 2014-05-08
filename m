Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 732BB7F5D
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:20:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 507BB304064
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:20:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Zl8umhyEqy0B3TI9 for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:19:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiJYV-0001jI-Cq
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiJYV-0006x9-Bc
	for xfs@oss.sgi.com; Thu, 08 May 2014 18:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/18] xfs: use xfs_da_geometry for block size in attr code
Date: Thu,  8 May 2014 18:19:45 +1000
Message-Id: <1399537188-26509-16-git-send-email-david@fromorbit.com>
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

Rather than using the superblock value obtained through the
xfs_mount.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr.c       | 24 +++++++++++-------------
 fs/xfs/xfs_attr_leaf.c  |  6 +++---
 fs/xfs/xfs_log_rlimit.c |  2 +-
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 28b6bb3..ab2679a 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -187,12 +187,10 @@ xfs_attr_get(
  */
 STATIC int
 xfs_attr_calc_size(
-	struct xfs_inode 	*ip,
-	int			namelen,
-	int			valuelen,
+	struct xfs_da_args	*args,
 	int			*local)
 {
-	struct xfs_mount 	*mp = ip->i_mount;
+	struct xfs_mount	*mp = args->dp->i_mount;
 	int			size;
 	int			nblks;
 
@@ -200,12 +198,12 @@ xfs_attr_calc_size(
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(namelen, valuelen,
-					mp->m_sb.sb_blocksize, local);
+	size = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
+					args->geo->blksize, local);
 
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (*local) {
-		if (size > (mp->m_sb.sb_blocksize >> 1)) {
+		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
 			nblks *= 2;
 		}
@@ -214,7 +212,7 @@ xfs_attr_calc_size(
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		uint	dblocks = xfs_attr3_rmt_blocks(mp, valuelen);
+		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 		nblks += dblocks;
 		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
 	}
@@ -276,7 +274,7 @@ xfs_attr_set_int(
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
 
 	/* Size is now blocks for attribute data */
-	args.total = xfs_attr_calc_size(dp, name->len, valuelen, &local);
+	args.total = xfs_attr_calc_size(&args, &local);
 
 	/*
 	 * Start our first transaction of the day.
@@ -994,7 +992,7 @@ restart:
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = mp;
-	state->blocksize = state->mp->m_sb.sb_blocksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = args->geo->node_ents;
 
 	/*
@@ -1173,7 +1171,7 @@ restart:
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
-		state->blocksize = state->mp->m_sb.sb_blocksize;
+		state->blocksize = args->geo->blksize;
 		state->node_ents = args->geo->node_ents;
 		state->inleaf = 0;
 		error = xfs_da3_node_lookup_int(state, &retval);
@@ -1265,7 +1263,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = dp->i_mount;
-	state->blocksize = state->mp->m_sb.sb_blocksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = args->geo->node_ents;
 
 	/*
@@ -1528,7 +1526,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
-	state->blocksize = state->mp->m_sb.sb_blocksize;
+	state->blocksize = args->geo->blksize;
 	state->node_ents = args->geo->node_ents;
 
 	/*
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index d1e800d..ab652e9 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1076,7 +1076,7 @@ xfs_attr3_leaf_add(
 	xfs_attr3_leaf_hdr_from_disk(&ichdr, leaf);
 	ASSERT(args->index >= 0 && args->index <= ichdr.count);
 	entsize = xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
-			   args->trans->t_mountp->m_sb.sb_blocksize, NULL);
+			   args->geo->blksize, NULL);
 
 	/*
 	 * Search through freemap for first-fit on new name length.
@@ -1179,13 +1179,13 @@ xfs_attr3_leaf_add_work(
 	ASSERT((ichdr->freemap[mapindex].base & 0x3) == 0);
 	ASSERT(ichdr->freemap[mapindex].size >=
 		xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
-					 mp->m_sb.sb_blocksize, NULL));
+					 args->geo->blksize, NULL));
 	ASSERT(ichdr->freemap[mapindex].size < XFS_LBSIZE(mp));
 	ASSERT((ichdr->freemap[mapindex].size & 0x3) == 0);
 
 	ichdr->freemap[mapindex].size -=
 			xfs_attr_leaf_newentsize(args->namelen, args->valuelen,
-						 mp->m_sb.sb_blocksize, &tmp);
+						 args->geo->blksize, &tmp);
 
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index 2af1a0a..ee7e0e8 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -42,7 +42,7 @@ xfs_log_calc_max_attrsetm_res(
 	int			size;
 	int			nblks;
 
-	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
+	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
