Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 540E07F5A
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 18:06:22 -0500 (CDT)
Date: Wed, 16 Oct 2013 18:06:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/19] xfs: convert directory vector functions to constants
Message-ID: <20131016230618.GF1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-20-git-send-email-david@fromorbit.com>
	<20131016211615.GD1935@sgi.com> <20131016222317.GM4446@dastard>
	<20131016225204.GE1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131016225204.GE1935@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 16, 2013 at 05:52:04PM -0500, Ben Myers wrote:
> On Thu, Oct 17, 2013 at 09:23:17AM +1100, Dave Chinner wrote:
> > On Wed, Oct 16, 2013 at 04:16:15PM -0500, Ben Myers wrote:
> > > On Tue, Oct 15, 2013 at 09:18:05AM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Many of the vectorised function calls now take no parameters and
> > > > return a constant value. There is no reason for these to be vectored
> > > > functions, so convert them to constants
> > > > 
> > > > Binary sizes:
> > > > 
> > > >    text    data     bss     dec     hex filename
> > > >  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
> > > >  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
> > > >  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
> > > >  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
> > > >  789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
> > > >  789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
> > > >  789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
> > > >  791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
> > > >  791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
> > > >  791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Hmmm.  This one doesn't seem to apply.  Maybe it's just me.
> > 
> > Applies without mismatch here on an 3.12-rc5 + oss-xfs/master tree
> > here. What's the reject that you get?
> 
> Like so:
> 
> $ q pu
> Applying patch xfs-convert-directory-vector-functions-to-constants.patch
> patching file fs/xfs/xfs_da_btree.c
> patching file fs/xfs/xfs_da_format.c
> Hunk #13 FAILED at 571.
> Hunk #14 FAILED at 608.
> Hunk #15 succeeded at 641 (offset -74 lines).
> Hunk #16 FAILED at 729.
> Hunk #17 succeeded at 683 (offset -82 lines).
> Hunk #18 FAILED at 779.
> Hunk #19 succeeded at 728 (offset -87 lines).
> Hunk #20 FAILED at 829.
> 5 out of 20 hunks FAILED -- rejects in file fs/xfs/xfs_da_format.c
> patching file fs/xfs/xfs_dir2.c
> patching file fs/xfs/xfs_dir2.h
> Hunk #4 FAILED at 92.
> 1 out of 4 hunks FAILED -- rejects in file fs/xfs/xfs_dir2.h
> patching file fs/xfs/xfs_dir2_block.c
> patching file fs/xfs/xfs_dir2_data.c
> patching file fs/xfs/xfs_dir2_leaf.c
> patching file fs/xfs/xfs_dir2_node.c
> Hunk #1 FAILED at 274.
> Hunk #2 succeeded at 1267 (offset -1 lines).
> Hunk #3 succeeded at 1299 (offset -1 lines).
> Hunk #4 succeeded at 1408 (offset -1 lines).
> 1 out of 4 hunks FAILED -- rejects in file fs/xfs/xfs_dir2_node.c
> patching file fs/xfs/xfs_dir2_readdir.c
> patching file fs/xfs/xfs_dir2_sf.c
> Patch xfs-convert-directory-vector-functions-to-constants.patch does not apply (enforce with -f)
> 
> That's on 74564fb48.

To be more specific, these are the rejects.  Maybe I missed a patch.

--- fs/xfs/xfs_da_format.c
+++ fs/xfs/xfs_da_format.c
@@ -571,22 +512,16 @@
  * Directory free space block operations
  */
 static int
-xfs_dir2_free_hdr_size(void)
-{
-	return sizeof(struct xfs_dir2_free_hdr);
-}
-
-static int
 xfs_dir2_free_max_bests(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir2_free_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir2_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
 static __be16 *
 xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
 {
-	return (__be16 *)((char *)free + xfs_dir2_free_hdr_size());
+	return (__be16 *)((char *)free + sizeof(struct xfs_dir2_free_hdr));
 }
 
 /*
@@ -608,22 +543,16 @@
 }
 
 static int
-xfs_dir3_free_hdr_size(void)
-{
-	return sizeof(struct xfs_dir3_free_hdr);
-}
-
-static int
 xfs_dir3_free_max_bests(struct xfs_mount *mp)
 {
-	return (mp->m_dirblksize - xfs_dir3_free_hdr_size()) /
+	return (mp->m_dirblksize - sizeof(struct xfs_dir3_free_hdr)) /
 		sizeof(xfs_dir2_data_off_t);
 }
 
 static __be16 *
 xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
 {
-	return (__be16 *)((char *)free + xfs_dir3_free_hdr_size());
+	return (__be16 *)((char *)free + sizeof(struct xfs_dir3_free_hdr));
 }
 
 /*
@@ -729,18 +661,18 @@
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
-	.free_hdr_size = xfs_dir2_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
@@ -779,18 +714,18 @@
 	.data_entry_p = xfs_dir2_data_entry_p,
 	.data_unused_p = xfs_dir2_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 
-	.free_hdr_size = xfs_dir2_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
 	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
 	.free_max_bests = xfs_dir2_free_max_bests,
@@ -829,35 +767,35 @@
 	.data_entry_p = xfs_dir3_data_entry_p,
 	.data_unused_p = xfs_dir3_data_unused_p,
 
-	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
+	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
 	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
-	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
 	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
 
-	.free_hdr_size = xfs_dir3_free_hdr_size,
+	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
 	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
 	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
-	.free_max_bests = xfs_dir2_free_max_bests,
+	.free_max_bests = xfs_dir3_free_max_bests,
 	.free_bests_p = xfs_dir3_free_bests_p,
 	.db_to_fdb = xfs_dir3_db_to_fdb,
 	.db_to_fdindex = xfs_dir3_db_to_fdindex,
 };
 
 const struct xfs_dir_ops xfs_dir2_nondir_ops = {
-	.node_hdr_size = xfs_da2_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
 	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
 	.node_tree_p = xfs_da2_node_tree_p,
 };
 
 const struct xfs_dir_ops xfs_dir3_nondir_ops = {
-	.node_hdr_size = xfs_da3_node_hdr_size,
+	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
 	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
 	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
 	.node_tree_p = xfs_da3_node_tree_p,
--- fs/xfs/xfs_dir2.h
+++ fs/xfs/xfs_dir2.h
@@ -92,7 +92,7 @@
 	struct xfs_da_node_entry *
 		(*node_tree_p)(struct xfs_da_intnode *dap);
 
-	int	(*free_hdr_size)(void);
+	int	free_hdr_size;
 	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
 				    struct xfs_dir3_icfree_hdr *from);
 	void	(*free_hdr_from_disk)(struct xfs_dir3_icfree_hdr *to,
--- fs/xfs/xfs_dir2_node.c
+++ fs/xfs/xfs_dir2_node.c
@@ -274,7 +274,7 @@
 	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 #endif
-	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size() - 1);
+	xfs_trans_log_buf(tp, bp, 0, dp->d_ops->free_hdr_size - 1);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
