Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:8788 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751252AbdKYXWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 18:22:48 -0500
Date: Sun, 26 Nov 2017 10:20:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: tr_ifree transaction log reservation calculation
Message-ID: <20171125232010.GW5858@dastard>
References: <20171121150557.GA5014@bfoster.bfoster>
 <0a9b47ba-a41e-3b96-981f-f04f9e2ab11c@hpe.com>
 <20171121173557.GB6004@bfoster.bfoster>
 <20171122022645.GR5858@dastard>
 <20171122122100.GA9984@bfoster.bfoster>
 <20171122204126.GA19041@bfoster.bfoster>
 <20171123002401.GT5858@dastard>
 <20171123143652.GA22032@bfoster.bfoster>
 <20171123215457.GU5858@dastard>
 <20171124145121.GA26516@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171124145121.GA26516@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Mark Tinguely <mark.tinguely@hpe.com>, linux-xfs@vger.kernel.org

On Fri, Nov 24, 2017 at 09:51:22AM -0500, Brian Foster wrote:
> On Fri, Nov 24, 2017 at 08:54:57AM +1100, Dave Chinner wrote:
> > On Thu, Nov 23, 2017 at 09:36:53AM -0500, Brian Foster wrote:
> > > On Thu, Nov 23, 2017 at 11:24:02AM +1100, Dave Chinner wrote:
> > > That sounds reasonable, but at the same time I'm a bit concerned that I
> > > think the ifree transaction should technically be refactored into a max
> > > of the pre/post tx roll reservations similar to the write reservation
> > > mentioned above. For example:
> > > 
> > > 	MAX(inode + inobt + finobt + agi + inode chunk + etc.,
> > > 	    allocfree for inode chunk + (allocfree * nr inobts));
> > 
> > Yeah, I think you're right in that we need to we need to look at
> > redefining the reservations at a higher level.
> > 
> > For this specific example, though, we have to take into account that
> > a finobt modification to mark an inode free can insert a new record
> > into the btree. Hence we have scope for a finobt block allocation
> > and tree split, so we need to have allocfree reservations in the
> > primary transaction.
> > 
> > Also, the inode btree modifications (and refcountbt, too) call
> > xfs_free_extent() directly - they don't use deferops free list that
> > is processed as an EFI/EFD op after the primary transaction has been
> > rolled.  i.e:
> > 
> > xfs_btree_delrec
> >   xfs_btree_free_block
> >     xfs_inobt_free_block
> >       xfs_free_extent
> > 
> > Hence the primary transaction reservation has to take into account
> > that operations that remove a record from the tree can cause and
> > extent to be freed. As such, the removal of an inode chunk - which
> > removes the record from both the inobt and finobt - can trigger
> > freespace tree modification directly.
> > 
> 
> Ah, because the inobt doesn't use the agfl. It looks like we try to do
> this in xfs_calc_finobt_res(), but it doesn't appear to be fully correct
> because the allocfree res is only accounted for transactions that "do
> not already account for free space btree modifications," according to
> the comment. I don't recall the exact reasoning there off the top of my
> head, but if I had to guess, this was probably just another instance of
> "bolt something on to the transaction that appears to follow the pattern
> of other transactions and doesn't explode."
> 
> Given that, it seems like the appropriate thing to do is in fact for the
> transaction to include an independent allocfree res for the inode chunk,
> the inobt and finobt. That justifies the existence of the current
> allocfree in the pre-roll part of the transaction and would increase the
> transaction size by one more allocfree in the finobt case (the inode
> chunk should technically be part of the post-roll calculation).
> 
> Actually, with addition of some proper documentation that may also
> obviate the need to do the whole pre/post tx roll thing because the
> first part of the transaction will obviously be larger than a single
> allocfree res for the second part (amazing how a little documentation to
> establish/assess intent can save us time from trying to work backwards
> from the transaction :P).
> 
> Ok, I think that gives me enough to go on to try and refactor at least
> the inobt tx res bits. I'll take a closer look next week, thanks for all
> of the feedback.

Actually, I wrote a patch as I was working all this out :p

Not complete, or anything like that, but I've attached it below
so you've got some idea of what I was thinking....

> > IOWs, the primary ifree transaction needs alloc/free reservations
> > for the modifications of both the inobt and the finobt, regardless
> > of anything else that goes on, so.....
> > 
> > > But that would end up making the transaction smaller than adding it all
> > > together. Of course, that may be fine with the agfl fixup below..
> > 
> > .... I doubt it will shrink if we take into account the multiple
> > direct alloc/free operations in the primary transaction properly. :/
> > 
> > Hmmmm - I'm wondering if we need to limit the max extents in a
> > defer-ops EFI/EFD item to 2 so we don't try to free all the defered
> > extent frees in a single EFI/EFD transaction pair. i.e. force it
> > to roll the transaction and get a new log reservation every two
> > extents being freed so we can limit the reservation size defered
> > extent freeing requires....
> 
> This sounds similar in principle to the other option I was thinking
> about with regard to dealing with the agfl fixup problem (rolling the
> tx). The difference is the driving logic: putting a hard limit on the
> number of per-tx operations vs. rolling in a particular agfl corner
> case.

Rolling the transaction at the AGFL level is problematic. The
transaction scope is defined way further up the call stack and we
can't roll transactions while we hold random logged objects locked
that need to stay locked across the entire allocation process.

Hence I don't think we can roll the transaction at the point where
we are modifying the AGFL simply because we don't have the context
available to ensure it can be done in a transactionally atomic and
deadlock free manner.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: inode transaciton reservations are whacky

From: Dave Chinner <dchinner@redhat.com>

Start hacking cleanups into the code, see if we can untangle the
mess.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 128 +++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 6bd916bd35e2..60d25d353fc0 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -131,6 +131,40 @@ xfs_calc_inode_res(
 		 2 * XFS_BMBT_BLOCK_LEN(mp));
 }
 
+/*
+ * Allocation/freeing of a [f]inobt record requires:
+ *
+ * the inode btree: max depth * block size
+ * the allocation btrees: 2 trees * (max depth - 1) * block size
+ *
+ * This assumes that AGI/AGF/SB modifications are accounted for by the caller.
+ * Modification is assumed as the first block in the tree depth reservation.
+ */
+static uint
+xfs_calc_inobt_alloc_res(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
+				XFS_FSB_TO_B(mp, 1));
+}
+
+/*
+ * Modification of a [f]inobt record requires:
+ *
+ * the inode btree: max depth * block size
+ * the inode btree entry: block size
+ *
+ * This assumes that AGI/AGF/SB modifications are accounted for by the caller.
+ */
+static uint
+xfs_calc_inobt_modify_res(
+	struct xfs_mount	*mp)
+{
+	return xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
+	       (uint)XFS_FSB_TO_B(mp, 1);
+}
+
 /*
  * The free inode btree is a conditional feature and the log reservation
  * requirements differ slightly from that of the traditional inode allocation
@@ -146,30 +180,19 @@ xfs_calc_inode_res(
  * 'alloc' param indicates to include the reservation for free space btree
  * modifications on behalf of finobt modifications. This is required only for
  * transactions that do not already account for free space btree modifications.
- *
- * the free inode btree: max depth * block size
- * the allocation btrees: 2 trees * (max depth - 1) * block size
- * the free inode btree entry: block size
  */
 STATIC uint
 xfs_calc_finobt_res(
 	struct xfs_mount	*mp,
-	int			alloc,
-	int			modify)
+	bool			alloc)
 {
-	uint res;
-
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return 0;
 
-	res = xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1));
+	/* alloc implies modification */
 	if (alloc)
-		res += xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-					XFS_FSB_TO_B(mp, 1));
-	if (modify)
-		res += (uint)XFS_FSB_TO_B(mp, 1);
-
-	return res;
+		return xfs_calc_inobt_alloc_res(mp);
+	return xfs_calc_inobt_modify_res(mp);
 }
 
 /*
@@ -232,8 +255,6 @@ xfs_calc_write_reservation(
  *    the super block to reflect the freed blocks: sector size
  *    worst case split in allocation btrees per extent assuming 4 extents:
  *		4 exts * 2 trees * (2 * max depth - 1) * block size
- *    the inode btree: max depth * blocksize
- *    the allocation btrees: 2 trees * (max depth - 1) * block size
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
@@ -245,12 +266,7 @@ xfs_calc_itruncate_reservation(
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
 		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
-				      XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(5, 0) +
-		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				     XFS_FSB_TO_B(mp, 1)) +
-		    xfs_calc_buf_res(2 + mp->m_ialloc_blks +
-				     mp->m_in_maxlevels, 0)));
+				      XFS_FSB_TO_B(mp, 1))));
 }
 
 /*
@@ -320,13 +336,13 @@ xfs_calc_link_reservation(
 /*
  * For adding an inode to unlinked list we can modify:
  *    the agi hash list: sector size
- *    the unlinked inode: inode size
+ *    the on-disk unlinked inode: inode cluster size
  */
 STATIC uint
 xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 {
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_inode_res(mp, 1);
+	       max_t(uint, XFS_FSB_TO_B(mp, 1), mp->m_inode_cluster_size);
 }
 
 /*
@@ -367,24 +383,26 @@ xfs_calc_remove_reservation(
  *    the new inode: inode size
  *    the inode btree entry: block size
  *    the superblock for the nlink flag: sector size
+ *    the AGI for inode counters: sector size
  *    the directory btree: (max depth + v2) * dir block size
  *    the directory inode's bmap btree: (max depth + v2) * block size
- *    the finobt (record modification and allocation btrees)
+ *    the finobt (record modification/removal and allocation btrees)
+ *    the AGF, AGFL for finobt allocation: 2 * sector size
  */
 STATIC uint
 xfs_calc_create_resv_modify(
 	struct xfs_mount	*mp)
 {
 	return xfs_calc_inode_res(mp, 2) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		(uint)XFS_FSB_TO_B(mp, 1) +
+		xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 1, 1);
+		xfs_calc_inobt_modify_res(mp) +
+		xfs_calc_finobt_res(mp, true);
 }
 
 /*
  * For create we can allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the agi, agf, agfl of the ag getting the new inodes: 3 * sectorsize
  *    the superblock for the nlink flag: sector size
  *    the inode blocks allocated: mp->m_ialloc_blks * blocksize
  *    the inode btree: max depth * blocksize
@@ -394,12 +412,9 @@ STATIC uint
 xfs_calc_create_resv_alloc(
 	struct xfs_mount	*mp)
 {
-	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		mp->m_sb.sb_sectsize +
+	return xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(mp->m_ialloc_blks, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1));
+		xfs_calc_inobt_alloc_res(mp);
 }
 
 STATIC uint
@@ -413,7 +428,7 @@ __xfs_calc_create_reservation(
 
 /*
  * For icreate we can allocate some inodes giving:
- *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
+ *    the agi, agf, agfl of the ag getting the new inodes: 3 * sectorsize
  *    the superblock for the nlink flag: sector size
  *    the inode btree: max depth * blocksize
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
@@ -423,12 +438,9 @@ STATIC uint
 xfs_calc_icreate_resv_alloc(
 	struct xfs_mount	*mp)
 {
-	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
-		mp->m_sb.sb_sectsize +
-		xfs_calc_buf_res(mp->m_in_maxlevels, XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 0, 0);
+	return xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+		xfs_calc_inobt_alloc_res(mp) +
+		xfs_calc_finobt_res(mp, false);
 }
 
 STATIC uint
@@ -493,26 +505,40 @@ xfs_calc_symlink_reservation(
  *    the super block free inode counter: sector size
  *    the agi hash list and counters: sector size
  *    the inode btree entry: block size
+ *    the on disk inode to null di_next_unlinked: inode cluster size
  *    the on disk inode before ours in the agi hash list: inode cluster size
+ *
+ * If we also have to free an inode chunk or recrod
  *    the inode btree: max depth * blocksize
+ *	Note: this also includes inode btree entry block!
+ *    the AGF and AGFL: 2 sectors
+ *    the allocation btrees: 2 trees * (max depth - 1) * block size
+ *    the log headers to record the inode chunk buffers as freed
+ *
+ * If we also have to modify the finbot - record may need allocation:
+ *    the finobt: max depth * block size
  *    the allocation btrees: 2 trees * (max depth - 1) * block size
- *    the finobt (record insertion, removal or modification)
+ *
  */
 STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
 	return XFS_DQUOT_LOGRES(mp) +
+		/* inode being freed */
 		xfs_calc_inode_res(mp, 1) +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
+		/* sb, AGF, AGFL */
+		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+		/* AGI + inode cluster */
 		xfs_calc_iunlink_remove_reservation(mp) +
-		xfs_calc_buf_res(1, 0) +
-		xfs_calc_buf_res(2 + mp->m_ialloc_blks +
-				 mp->m_in_maxlevels, 0) +
-		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
-				 XFS_FSB_TO_B(mp, 1)) +
-		xfs_calc_finobt_res(mp, 0, 1);
+		/* inode cluster on disk before ours */
+		xfs_calc_iunlink_remove_reservation(mp) +
+		/* inode btree record freeing */
+		xfs_calc_inobt_alloc_res(mp) +
+		/* stale inode chunk buffers (blf & log hdrs only) */
+		xfs_calc_buf_res(mp->m_ialloc_blks, 0) +
+		/* free inode btree */
+		xfs_calc_finobt_res(mp, true);
 }
 
 /*
