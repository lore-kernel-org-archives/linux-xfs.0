Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdK1PtY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 10:49:24 -0500
Date: Tue, 28 Nov 2017 10:49:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 4/4] xfs: include an allocfree res for inobt
 modifications
Message-ID: <20171128154922.GE45759@bfoster.bfoster>
References: <20171127202434.43125-1-bfoster@redhat.com>
 <20171127202434.43125-5-bfoster@redhat.com>
 <20171127232719.GC5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127232719.GC5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 10:27:19AM +1100, Dave Chinner wrote:
> On Mon, Nov 27, 2017 at 03:24:34PM -0500, Brian Foster wrote:
> > Analysis of recent reports of log reservation overruns and code
> > inspection has uncovered that the reservations associated with inode
> > operations may not cover the worst case scenarios. In particular,
> > many cases only include one allocfree res. for a particular
> > operation even though said operations may also entail AGFL fixups
> > and inode btree block allocations in addition to the actual inode
> > chunk allocation. This can easily turn into two or three block
> > allocations (or frees) per operation.
> > 
> > In theory, the only way to define the worst case reservation is to
> > include an allocfree res for each individual allocation in a
> > transaction. Since that is impractical (we can perform multiple agfl
> > fixups per tx and not every allocation is going to result in a full
> > tree operation), implement a reasonable compromise that addresses
> > the deficiency in practice without blowing out the size of the
> > transactions.
> > 
> > Refactor the inode transaction reservation code to include one
> > allocfree res. per inode btree modification to cover allocations
> > required by the tree itself. This essentially separates the
> > reservation required to allocate the physical inode chunk from
> > additional reservation required to perform inobt record
> > insertion/removal.
> 
> I think you missed the most important reason the inobt/finobt
> modifications need there own allocfree reservation - btree
> modifications that cause btree blocks to be freed do not use defered
> ops and so the freeing of blocks occurs directly within the primary
> transaction. Hence the primary transaction reservation must take
> this into account ....
> 
> > Apply the same logic to the finobt reservation.
> > This results in killing off the finobt modify condition because we
> > no longer assume that the broader transaction reservation will cover
> > finobt block allocations.
> > 
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Code looks fine. Comments below are for another follow-on patch.
> 

Actually, what do you think of the following variant (compile tested
only)? This facilites another cleanup patch I just wrote to kill off
about half of the (now effectively duplicate) xfs_calc_create_*()
helpers because the finobt and inode chunk res. helpers only include the
associated reservation based on the associated feature bits.

Brian

--- 8< ---

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index c27c57e65e15..045781f2cf00 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -172,6 +172,41 @@ xfs_calc_finobt_res(
 }
 
 /*
+ * Calculate the reservation required to allocate or free an inode chunk. This
+ * includes:
+ *
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
+ * the inode chunk: m_ialloc_blks * N
+ *
+ * The size N of the inode chunk reservation depends on whether it is for
+ * allocation or free and which type of create transaction is in use. An inode
+ * chunk free always invalidates the buffers and only requires reservation for
+ * headers (N == 0). An inode chunk allocation requires a chunk sized
+ * reservation on v4 and older superblocks to initialize the chunk. No chunk
+ * reservation is required for allocation on v5 supers, which use ordered
+ * buffers to initialize.
+ */
+STATIC uint
+xfs_calc_inode_chunk_res(
+	struct xfs_mount	*mp,
+	bool			alloc)
+{
+	uint			res, size = 0;
+
+	res = xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+			       XFS_FSB_TO_B(mp, 1));
+	if (alloc) {
+		/* icreate tx uses ordered buffers */
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			return res;
+		size = XFS_FSB_TO_B(mp, 1);
+	}
+
+	res += xfs_calc_buf_res(mp->m_ialloc_blks, size);
+	return res;
+}
+
+/*
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
@@ -386,8 +421,7 @@ xfs_calc_create_resv_modify(
  * For create we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the inode chunk (allocation/init)
  *    the inode btree (record insertion)
  */
 STATIC uint
@@ -396,9 +430,7 @@ xfs_calc_create_resv_alloc(
 {
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_inode_chunk_res(mp, true) +
 		xfs_calc_inobt_res(mp);
 }
 
@@ -415,7 +447,7 @@ __xfs_calc_create_reservation(
  * For icreate we can allocate some inodes giving:
  *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
  *    the superblock for the nlink flag: sector size
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the inode chunk (allocation, no init)
  *    the inobt (record insertion)
  *    the finobt (record insertion)
  */
@@ -425,8 +457,7 @@ xfs_calc_icreate_resv_alloc(
 {
 	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_inode_chunk_res(mp, true) +
 		xfs_calc_inobt_res(mp) +
 		xfs_calc_finobt_res(mp);
 }
@@ -492,15 +523,15 @@ xfs_calc_symlink_reservation(
  *    the inode being freed: inode size
  *    the super block free inode counter, AGF and AGFL: sector size
  *    the on disk inode (agi unlinked list removal)
- *    the inode chunk is marked stale (headers only)
+ *    the inode chunk (invalidated, headers only)
  *    the inode btree
  *    the finobt (record insertion, removal or modification)
  *
- * Note that the allocfree res. for the inode chunk itself is not included
- * because the extent free occurs after a transaction roll. We could take the
- * maximum of the pre/post roll operations, but the pre-roll reservation already
- * includes at least one allocfree res. for the inobt and is thus guaranteed to
- * be larger.
+ * Note that the inode chunk res. includes an allocfree res. for freeing of the
+ * inode chunk. This is technically extraneous because the inode chunk free is
+ * deferred (it occurs after a transaction roll). Include the extra reservation
+ * anyways since we've had reports of ifree transaction overruns due to too many
+ * agfl fixups during inode chunk frees.
  */
 STATIC uint
 xfs_calc_ifree_reservation(
@@ -511,7 +542,7 @@ xfs_calc_ifree_reservation(
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
 		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
+		xfs_calc_inode_chunk_res(mp, false) +
 		xfs_calc_inobt_res(mp) +
 		xfs_calc_finobt_res(mp);
 }
