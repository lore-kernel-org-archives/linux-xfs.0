Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q91M8KRg202623 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 17:08:20 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EC14304051
	for <xfs@oss.sgi.com>; Mon,  1 Oct 2012 15:09:41 -0700 (PDT)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	q91M9b0X003569
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 17:09:37 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121001221028.766035076@sgi.com>
Date: Mon, 01 Oct 2012 17:10:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
	<20120925005632.GB23520@dastard> <5061CA48.3040202@sgi.com>
	<20120928030847.GC25626@dastard>
In-Reply-To: <20120928030847.GC25626@dastard>
Content-Disposition: inline; filename=xfs-move_allocate_worker.patch
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

 v2 remove the architecture conditional.

The AGF hang is caused when the process that holds the AGF buffer
lock cannot get a worker. The allocation worker pool are blocked
waiting to take the AGF buffer lock.

Move the allocation worker call so that multiple calls to
xfs_alloc_vextent() for a particular transaction are contained
within a single worker.
			---
With the xfs_alloc_arg structure zeroed, the AGF hang occurs in 
xfs_bmap_btalloc() due to a secondary call to xfs_alloc_vextent().
These calls to xfs_alloc_vextent() try different strategies to
allocate the extent if the previous allocation attempt failed.

I still prefer this patch's approach. It also limits the number
worker context switches when xfs_alloc_ventent() is called multiple
times within a transaction. The intent of the patch is to move the
allocation worker as reasonably close to the xfs_trans_alloc() -
xfs_trans_commit / xfs_trans_cancel() calls as possible.

I have ported this patch to Linux 3.0.x. Linux 2.6.x will be the same
as the Linux 3.0 port.

This patch allows an easy addition of an architecture limit on the
allocation worker for those that choose to do so.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_alloc.c |   42 -------------------------------------
 fs/xfs/xfs_alloc.h |    3 --
 fs/xfs/xfs_bmap.c  |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_bmap.h  |   16 ++++++++++++++
 4 files changed, 75 insertions(+), 46 deletions(-)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2211,7 +2211,7 @@ xfs_alloc_read_agf(
  * group or loop over the allocation groups to find the result.
  */
 int				/* error */
-__xfs_alloc_vextent(
+xfs_alloc_vextent(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
 	xfs_agblock_t	agsize;	/* allocation group size */
@@ -2421,46 +2421,6 @@ error0:
 	return error;
 }
 
-static void
-xfs_alloc_vextent_worker(
-	struct work_struct	*work)
-{
-	struct xfs_alloc_arg	*args = container_of(work,
-						struct xfs_alloc_arg, work);
-	unsigned long		pflags;
-
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
-
-	args->result = __xfs_alloc_vextent(args);
-	complete(args->done);
-
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
-}
-
-/*
- * Data allocation requests often come in with little stack to work on. Push
- * them off to a worker thread so there is lots of stack to use. Metadata
- * requests, OTOH, are generally from low stack usage paths, so avoid the
- * context switch overhead here.
- */
-int
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)
-{
-	DECLARE_COMPLETION_ONSTACK(done);
-
-	if (!args->userdata)
-		return __xfs_alloc_vextent(args);
-
-
-	args->done = &done;
-	INIT_WORK_ONSTACK(&args->work, xfs_alloc_vextent_worker);
-	queue_work(xfs_alloc_wq, &args->work);
-	wait_for_completion(&done);
-	return args->result;
-}
-
 /*
  * Free an extent.
  * Just break up the extent address and hand off to xfs_free_ag_extent
Index: b/fs/xfs/xfs_alloc.h
===================================================================
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -120,9 +120,6 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
-	struct completion *done;
-	struct work_struct work;
-	int		result;
 } xfs_alloc_arg_t;
 
 /*
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -48,7 +48,6 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
-
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
 /*
@@ -4820,7 +4819,7 @@ xfs_bmapi_convert_unwritten(
  * blocks then the call will fail (return NULLFSBLOCK in "firstblock").
  */
 int
-xfs_bmapi_write(
+__xfs_bmapi_write(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
 	xfs_fileoff_t		bno,		/* starting file offs. mapped */
@@ -5044,6 +5043,63 @@ error0:
 	return error;
 }
 
+static void
+xfs_bmapi_write_worker(
+	struct work_struct      *work)
+{
+	struct xfs_bmw_wkr	*bw = container_of(work,
+						     struct xfs_bmw_wkr, work);
+	unsigned long		pflags;
+
+	/* we are in a transaction context here */
+	current_set_flags_nested(&pflags, PF_FSTRANS);
+
+	bw->result = __xfs_bmapi_write(bw->tp, bw->ip, bw->bno, bw->len,
+					 bw->flags, bw->firstblock, bw->total,
+					 bw->mval, bw->nmap, bw->flist);
+	complete(bw->done);
+
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
+}
+
+int
+xfs_bmapi_write(
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode */
+	xfs_fileoff_t		bno,		/* starting file offs. mapped */
+	xfs_filblks_t		len,		/* length to map in file */
+	int			flags,		/* XFS_BMAPI_... */
+	xfs_fsblock_t		*firstblock,	/* first allocated block
+						   controls a.g. for allocs */
+	xfs_extlen_t		total,		/* total blocks needed */
+	struct xfs_bmbt_irec	*mval,		/* output: map values */
+	int			*nmap,		/* i/o: mval size/count */
+	struct xfs_bmap_free	*flist)		/* i/o: list extents to free */
+{
+	struct xfs_bmw_wkr	bw;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (flags & XFS_BMAPI_METADATA)
+		return __xfs_bmapi_write(tp, ip, bno, len, flags, firstblock,
+					 total, mval, nmap, flist);
+	/* initialize the worker argument list structure */
+	bw.tp = tp;
+	bw.ip = ip;
+	bw.bno = bno;
+	bw.len = len;
+	bw.flags = flags;
+	bw.firstblock = firstblock;
+	bw.total = total;
+	bw.mval = mval;
+	bw.nmap = nmap;
+	bw.flist = flist;
+	bw.done = &done;
+	INIT_WORK_ONSTACK(&bw.work, xfs_bmapi_write_worker);
+	queue_work(xfs_alloc_wq, &bw.work);
+	wait_for_completion(&done);
+	return bw.result;
+}
+
 /*
  * Unmap (remove) blocks from a file.
  * If nexts is nonzero then the number of extents to remove is limited to
Index: b/fs/xfs/xfs_bmap.h
===================================================================
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -135,6 +135,22 @@ typedef struct xfs_bmalloca {
 	char			conv;	/* overwriting unwritten extents */
 } xfs_bmalloca_t;
 
+struct xfs_bmw_wkr {
+	struct xfs_trans	*tp;		/* transaction pointer */
+	struct xfs_inode	*ip;		/* incore inode */
+	xfs_fileoff_t		bno;		/* starting file offs. mapped */
+	xfs_filblks_t		len;		/* length to map in file */
+	int			flags;		/* XFS_BMAPI_... */
+	xfs_fsblock_t		*firstblock;	/* first allocblock controls */
+	xfs_extlen_t		total;		/* total blocks needed */
+	struct xfs_bmbt_irec	*mval;		/* output: map values */
+	int			*nmap;		/* i/o: mval size/count */
+	struct xfs_bmap_free	*flist;		/* bmap freelist */
+	struct completion	*done;		/* worker completion ptr */
+	struct work_struct	work;		/* worker */
+	int			result;		/* worker function result */
+} ;
+
 /*
  * Flags for xfs_bmap_add_extent*.
  */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
