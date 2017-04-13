Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27719 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755860AbdDMDw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 23:52:59 -0400
Date: Wed, 12 Apr 2017 20:52:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170413035250.GT8502@birch.djwong.org>
References: <20170220072945.GA17608@lst.de>
 <20170221014356.GA5844@birch.djwong.org>
 <20170412135231.GA3891@lst.de>
 <20170412230612.GS8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20170412230612.GS8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 12, 2017 at 04:06:12PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 12, 2017 at 03:52:31PM +0200, Christoph Hellwig wrote:
> > I think the problem is that t_log_res just contains the log reservation
> > when the transaction was created.  But each item processed by
> > xfs_defer_finish uses up some of it, but in some cases these might
> > be different operations and not just more refcount updates, e.g. for
> > xfs_itruncate_extents which I see the issues with we mix EFI/EFD
> > items with refcount updates.
> 
> Hmmm... I suppose you could end up with a heavy load of deferred updates
> stemming from the removal of a single extent:
> 
> 1) Start with one huge extent mapped into a file.
> 2) Reflink every other block into another file.
> 3) Delete the first file.  This results in:
>    a) Unmap the huge extent.
>    b) Schedule removal of the rmap, if applicable.
>    c) Schedule a refcount decrease for the huge extent.
>    d) Perform the deferred rmap removal.  If we push blocks off the
>       AGFL as part of removing rmapbt blocks, queue an EFI.
>    e) Perform the deferred refcount decrease:
>       For each (singly-)shared block, set the refcount=1 by deleting the
>       refcount record.  Every ~150 deletions we free a refcount block
>       and queue an EFI.  (If rmap, queue a deferred rmap update too.)
>    f) Perform the deferred rmap removals.  If we push blocks off the
>       AGFL as part of removing rmapbt blocks, queue an EFI.
>    g) Free each shared block by queueing an EFI.
>    h) For each EFI, free the extent.
> 
> So I think the problem you're seeing here is that just prior to (3g) we
> have the most deferred items (EFIs, specifically) attached to this
> transaction at any point in the whole operation.  There can be so many
> EFIs that we use up the log reservation and blow the ASSERT.
> 
> One way to fix this is to unmap a smaller range in (1) so that we don't
> blow up at (3g).  Unfortunately, it is hard to guess at (1) just how
> many EFIs we might end up queueing, but I think reducing the amount of
> file mapping we free in a given step might be the only sane solution.
> One could calculate the number of blocks we can free, given the
> remaining transaction reservation and assuming the worst case number of
> EFIs that could get filed to unmap those blocks, and only __bunmapi that
> many blocks, thereby forcing the caller to come back with a fresh
> defer_ops for another try.

Hmm... can you try out the attached RFC(RAP) xfstests testcase to see if
it can reproduce the problem you're seeing, and then apply the (equally
RFCRAP) patch to see if it fixes the problem?

--D

> 
> > I still don't have a good idea how to fix this, though.  One idea
> > would be to prevent mixing different items, but I think being able
> > to mix them was one of your goals with the defer infrastructure rewrite.
> 
> Yes, we have to be able to perform several different types of updates
> in one defer_ops so that we can execute CoW remappings atomically.
> 
> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="18-xfs-reflink-test-unlink-giant-batch-of-refcounts.patch"

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] reflink: test unlinking a huge extent with a lot of refcount adjustments

Test a regression in XFS where we blow out a transaction reservation if
we create a big file, share every other block, and delete the first
file.  There's nothing particularly fs-specific about this stress test,
so put it in generic.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
---
 tests/generic/931     |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/931.out |    6 +++
 tests/generic/group   |    1 +
 3 files changed, 101 insertions(+)
 create mode 100755 tests/generic/931
 create mode 100644 tests/generic/931.out

diff --git a/tests/generic/931 b/tests/generic/931
new file mode 100755
index 0000000..cc093bf
--- /dev/null
+++ b/tests/generic/931
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 931
+#
+# See how well we handle deleting a file with a million refcount extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* $testdir/file1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+mkdir "$testdir"
+
+# Setup for one million blocks, but we'll accept stress testing down to
+# 2^17 blocks... that should be plenty for anyone.
+fnr=20
+free_blocks=$(stat -f -c '%a' "$testdir")
+blksz=$(_get_block_size "$testdir")
+space_avail=$((free_blocks * blksz))
+calc_space() {
+	blocks_needed=$(( 2 ** (fnr + 1) ))
+	space_needed=$((blocks_needed * blksz * 5 / 4))
+}
+calc_space
+while test $space_needed -gt $space_avail; do
+	fnr=$((fnr - 1))
+	calc_space
+done
+test $fnr -lt 17 && _notrun "Insufficient space for stress test; would only create $blocks_needed extents."
+
+echo "Create a many-block file"
+echo "creating $blocks_needed blocks..." >> "$seqres.full"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 0 $((2 ** (fnr + 1) * blksz))" "$testdir/file1" >> "$seqres.full"
+
+echo "Reflinking file"
+_cp_reflink $testdir/file1 $testdir/file2
+
+echo "Punch file2"
+echo "Punching file2..." >> "$seqres.full"
+"$here/src/punch-alternating" "$testdir/file2" >> "$seqres.full"
+echo "...done" >> "$seqres.full"
+_scratch_cycle_mount
+
+echo "Delete file1"
+rm -rf $testdir/file1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/931.out b/tests/generic/931.out
new file mode 100644
index 0000000..c7b724e
--- /dev/null
+++ b/tests/generic/931.out
@@ -0,0 +1,6 @@
+QA output created by 931
+Format and mount
+Create a many-block file
+Reflinking file
+Punch file2
+Delete file1
diff --git a/tests/generic/group b/tests/generic/group
index 173f6f3..455e5fb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -432,3 +432,4 @@
 819 auto quick copy
 820 auto quick copy
 821 auto quick punch
+931 auto quick clone

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="90-xfs-reflink-constrain-bunmapi.patch"

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs: try to avoid blowing out the transaction reservation when bunmaping a shared extent

In a pathological scenario where we are trying to bunmapi a single
extent in which every other block is shared, it's possible that trying
to unmap the entire large extent in a single transaction can generate so
many EFIs that we overflow the transaction reservation.

Therefore, use a heuristic to guess at the number of blocks we can
safely unmap from a reflink file's data fork in an single transaction.
This should prevent problems such as the log head slamming into the tail
and ASSERTs that trigger because we've exceeded the transaction
reservation.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 179b483..87da58d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5417,6 +5417,28 @@ xfs_bmap_del_extent(
 }
 
 /*
+ * Guesstimate how many blocks we can unmap without running the risk of
+ * blowing out the transaction with EFIs.
+ */
+static xfs_fileoff_t
+xfs_bunmapi_can_unmap(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fileoff_t		len)
+{
+	unsigned int		limit;
+
+	if (!xfs_is_reflink_inode(ip) || whichfork != XFS_DATA_FORK)
+		return len;
+
+	limit = (tp->t_log_res * 3 / 4) / 32;
+	if (len <= limit)
+		return len;
+	return limit;
+}
+
+/*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
  * that value.  If not all extents in the block range can be removed then
@@ -5451,6 +5473,7 @@ __xfs_bunmapi(
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
+	xfs_fileoff_t		can_unmap;
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5472,6 +5495,12 @@ __xfs_bunmapi(
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
+	/*
+	 * If this is potentially reflinked data blocks, don't blow out
+	 * the reservation.
+	 */
+	can_unmap = xfs_bunmapi_can_unmap(tp, ip, whichfork, len);
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
 	    (error = xfs_iread_extents(tp, ip, whichfork)))
 		return error;
@@ -5516,7 +5545,7 @@ __xfs_bunmapi(
 
 	extno = 0;
 	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
-	       (nexts == 0 || extno < nexts)) {
+	       (nexts == 0 || extno < nexts) && can_unmap > 0) {
 		/*
 		 * Is the found extent after a hole in which bno lives?
 		 * Just back up to the previous extent, if so.
@@ -5548,6 +5577,16 @@ __xfs_bunmapi(
 		}
 		if (del.br_startoff + del.br_blockcount > bno + 1)
 			del.br_blockcount = bno + 1 - del.br_startoff;
+
+		/* How much can we safely unmap? */
+		if (can_unmap < del.br_blockcount) {
+printk(KERN_ERR "%s: ino %lld pblk %d:%llu lblk %llu len %llu can_unmap %llu got=%llu:%llu:%llu\n", __func__, ip->i_ino, wasdel, del.br_startblock, del.br_startoff, del.br_blockcount, can_unmap, got.br_startblock, got.br_startoff, got.br_blockcount);
+			del.br_startoff += del.br_blockcount - can_unmap;
+			if (!wasdel)
+				del.br_startblock += del.br_blockcount - can_unmap;
+			del.br_blockcount = can_unmap;
+		}
+
 		sum = del.br_startblock + del.br_blockcount;
 		if (isrt &&
 		    (mod = do_mod(sum, mp->m_sb.sb_rextsize))) {
@@ -5724,6 +5763,7 @@ __xfs_bunmapi(
 		if (!isrt && wasdel)
 			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
 
+		can_unmap -= del.br_blockcount;
 		bno = del.br_startoff - 1;
 nodelete:
 		/*

--6c2NcOVqGQ03X4Wi--
