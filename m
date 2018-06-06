Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40268 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752435AbeFFBVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 21:21:09 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQN8M-0003Eo-IZ
        for linux-xfs@vger.kernel.org; Wed, 06 Jun 2018 11:21:06 +1000
Date: Wed, 6 Jun 2018 11:21:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6 v3] xfs: validate btree records on retreival
Message-ID: <20180606012106.GM10363@dastard>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-5-david@fromorbit.com>
 <20180605064043.GH10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605064043.GH10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So we don't check the validity of records as we walk the btree. When
there are corrupt records in the free space btree (e.g. zero
startblock/length or beyond EOAG) we just blindly use it and things
go bad from there. That leads to assert failures on debug kernels
like this:

XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_alloc.c, line: 450
....
Call Trace:
 xfs_alloc_fixup_trees+0x368/0x5c0
 xfs_alloc_ag_vextent_near+0x79a/0xe20
 xfs_alloc_ag_vextent+0x1d3/0x330
 xfs_alloc_vextent+0x5e9/0x870

Or crashes like this:

XFS (loop0): xfs_buf_find: daddr 0x7fb28 out of range, EOFS 0x8000
.....
BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
....
Call Trace:
 xfs_bmap_add_extent_hole_real+0x67d/0x930
 xfs_bmapi_write+0x934/0xc90
 xfs_da_grow_inode_int+0x27e/0x2f0
 xfs_dir2_grow_inode+0x55/0x130
 xfs_dir2_sf_to_block+0x94/0x5d0
 xfs_dir2_sf_addname+0xd0/0x590
 xfs_dir_createname+0x168/0x1a0
 xfs_rename+0x658/0x9b0

By checking that free space records pulled from the trees are 
within the valid range, we catch many of these corruptions before
they can do damage.

This is a generic btree record checking deficiency. We need to
validate the records we fetch from all the different btrees before
we use them to catch corruptions like this.

This patch results in a corrupt record emitting an error message and
returning -EFSCORRUPTED, and the higher layers catch that and abort:

 XFS (loop0): Size Freespace BTree record corruption in AG 0 detected!
 XFS (loop0): start block 0x0 block count 0x0
 XFS (loop0): Internal error xfs_trans_cancel at line 1012 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x42a/0x670
 .....
 Call Trace:
  dump_stack+0x85/0xcb
  xfs_trans_cancel+0x19f/0x1c0
  xfs_create+0x42a/0x670
  xfs_generic_create+0x1f6/0x2c0
  vfs_create+0xf9/0x180
  do_mknodat+0x1f9/0x210
  do_syscall_64+0x5a/0x180
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
.....
 XFS (loop0): xfs_do_force_shutdown(0x8) called from line 1013 of file fs/xfs/xfs_trans.c.  Return address = ffffffff81500868
 XFS (loop0): Corruption of in-memory data detected.  Shutting down filesystem

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
V3:
- add refcount range check for non-COW extents
- fixed rmap owner range check
- fixed rmap error message format "Reverse Mapping BTree..."

 fs/xfs/libxfs/xfs_alloc.c    | 22 +++++++++++++++++++--
 fs/xfs/libxfs/xfs_ialloc.c   | 31 ++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_refcount.c | 47 +++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_rmap.c     | 41 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a52ffb835b16..1db50cfc0212 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -215,6 +215,8 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat)	/* output: success/failure */
 {
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_agnumber_t		agno = cur->bc_private.a.agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -222,12 +224,28 @@ xfs_alloc_get_rec(
 	if (error || !(*stat))
 		return error;
 	if (rec->alloc.ar_blockcount == 0)
-		return -EFSCORRUPTED;
+		goto out_bad_rec;
 
 	*bno = be32_to_cpu(rec->alloc.ar_startblock);
 	*len = be32_to_cpu(rec->alloc.ar_blockcount);
 
-	return error;
+	/* check for valid extent range, including overflow */
+	if (!xfs_verify_agbno(mp, agno, *bno))
+		goto out_bad_rec;
+	if (*bno > *bno + *len)
+		goto out_bad_rec;
+	if (!xfs_verify_agbno(mp, agno, *bno + *len - 1))
+		goto out_bad_rec;
+
+	return 0;
+
+out_bad_rec:
+	xfs_warn(mp,
+		"%s Freespace BTree record corruption in AG %d detected!",
+		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size", agno);
+	xfs_warn(mp,
+		"start block 0x%x block count 0x%x", *bno, *len);
+	return -EFSCORRUPTED;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ec5ea02b5553..3f551eb29157 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -121,16 +121,45 @@ xfs_inobt_get_rec(
 	struct xfs_inobt_rec_incore	*irec,
 	int				*stat)
 {
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_agnumber_t			agno = cur->bc_private.a.agno;
 	union xfs_btree_rec		*rec;
 	int				error;
+	uint64_t			realfree;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || *stat == 0)
 		return error;
 
-	xfs_inobt_btrec_to_irec(cur->bc_mp, rec, irec);
+	xfs_inobt_btrec_to_irec(mp, rec, irec);
+
+	if (!xfs_verify_agino(mp, agno, irec->ir_startino))
+		goto out_bad_rec;
+	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
+	    irec->ir_count > XFS_INODES_PER_CHUNK)
+		goto out_bad_rec;
+	if (irec->ir_freecount > XFS_INODES_PER_CHUNK)
+		goto out_bad_rec;
+
+	/* if there are no holes, return the first available offset */
+	if (!xfs_inobt_issparse(irec->ir_holemask))
+		realfree = irec->ir_free;
+	else
+		realfree = irec->ir_free & xfs_inobt_irec_to_allocmask(irec);
+	if (hweight64(realfree) != irec->ir_freecount)
+		goto out_bad_rec;
 
 	return 0;
+
+out_bad_rec:
+	xfs_warn(mp,
+		"%s Inode BTree record corruption in AG %d detected!",
+		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free", agno);
+	xfs_warn(mp,
+"start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
+		irec->ir_startino, irec->ir_count, irec->ir_freecount,
+		irec->ir_free, irec->ir_holemask);
+	return -EFSCORRUPTED;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ed5704c7dcf5..9dda6fd0bb13 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -111,16 +111,53 @@ xfs_refcount_get_rec(
 	struct xfs_refcount_irec	*irec,
 	int				*stat)
 {
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_agnumber_t			agno = cur->bc_private.a.agno;
 	union xfs_btree_rec		*rec;
 	int				error;
+	xfs_agblock_t			realstart;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (!error && *stat == 1) {
-		xfs_refcount_btrec_to_irec(rec, irec);
-		trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno,
-				irec);
+	if (error || !*stat)
+		return error;
+
+	xfs_refcount_btrec_to_irec(rec, irec);
+
+	agno = cur->bc_private.a.agno;
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+		goto out_bad_rec;
+
+	/* handle special COW-staging state */
+	realstart = irec->rc_startblock;
+	if (realstart & XFS_REFC_COW_START) {
+		if (irec->rc_refcount != 1)
+			goto out_bad_rec;
+		realstart &= ~XFS_REFC_COW_START;
+	} else if (irec->rc_refcount < 2) {
+		goto out_bad_rec;
 	}
-	return error;
+
+	/* check for valid extent range, including overflow */
+	if (!xfs_verify_agbno(mp, agno, realstart))
+		goto out_bad_rec;
+	if (realstart > realstart + irec->rc_blockcount)
+		goto out_bad_rec;
+	if (!xfs_verify_agbno(mp, agno, realstart + irec->rc_blockcount - 1))
+		goto out_bad_rec;
+
+	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+		goto out_bad_rec;
+
+	trace_xfs_refcount_get(cur->bc_mp, cur->bc_private.a.agno, irec);
+	return 0;
+
+out_bad_rec:
+	xfs_warn(mp,
+		"Refcount BTree record corruption in AG %d detected!", agno);
+	xfs_warn(mp,
+		"Start block 0x%x, block count 0x%x, references 0x%x",
+		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	return -EFSCORRUPTED;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 87711f9af625..d4460b0d2d81 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -27,6 +27,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_ialloc.h"
 
 /*
  * Lookup the first record less than or equal to [bno, len, owner, offset]
@@ -191,6 +192,8 @@ xfs_rmap_get_rec(
 	struct xfs_rmap_irec	*irec,
 	int			*stat)
 {
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_agnumber_t		agno = cur->bc_private.a.agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
@@ -198,7 +201,43 @@ xfs_rmap_get_rec(
 	if (error || !*stat)
 		return error;
 
-	return xfs_rmap_btrec_to_irec(rec, irec);
+	if (xfs_rmap_btrec_to_irec(rec, irec))
+		goto out_bad_rec;
+
+	if (irec->rm_blockcount == 0)
+		goto out_bad_rec;
+	if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
+		if (irec->rm_owner != XFS_RMAP_OWN_FS)
+			goto out_bad_rec;
+		if (irec->rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
+			goto out_bad_rec;
+	} else {
+		/* check for valid extent range, including overflow */
+		if (!xfs_verify_agbno(mp, agno, irec->rm_startblock))
+			goto out_bad_rec;
+		if (irec->rm_startblock >
+				irec->rm_startblock + irec->rm_blockcount)
+			goto out_bad_rec;
+		if (!xfs_verify_agbno(mp, agno,
+				irec->rm_startblock + irec->rm_blockcount - 1))
+			goto out_bad_rec;
+	}
+
+	if (!(xfs_verify_ino(mp, irec->rm_owner) ||
+	      (irec->rm_owner <= XFS_RMAP_OWN_FS &&
+	       irec->rm_owner >= XFS_RMAP_OWN_MIN)))
+		goto out_bad_rec;
+
+	return 0;
+out_bad_rec:
+	xfs_warn(mp,
+		"Reverse Mapping BTree record corruption in AG %d detected!",
+		agno);
+	xfs_warn(mp,
+		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
+		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
+		irec->rm_blockcount);
+	return -EFSCORRUPTED;
 }
 
 struct xfs_find_left_neighbor_info {
-- 
Dave Chinner
david@fromorbit.com
