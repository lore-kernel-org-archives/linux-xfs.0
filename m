Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KIL5Lm121041 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 13:21:05 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD7C6304062
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 11:22:15 -0700 (PDT)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	q8KIM9At013398
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 13:22:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5/Submit) id
	q8KIM9gq013397
	for xfs@oss.sgi.com; Thu, 20 Sep 2012 13:22:09 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120920181650.041917183@sgi.com>
Date: Thu, 20 Sep 2012 13:16:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 3/3 v2] xfs: zero allocation_args on the kernel stack
References: <20120919163133.097340199@sgi.com>
	<20120919163145.587098223@sgi.com>
Content-Disposition: inline; filename=3-3-v2_xfs-zero_allocation_args.patch
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

Zero the kernel stack space that makes up the xfs_alloc_arg structures.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>

---
 fs/xfs/xfs_alloc.c  |    1 +
 fs/xfs/xfs_bmap.c   |    3 +++
 fs/xfs/xfs_ialloc.c |    1 +
 3 files changed, 5 insertions(+)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1866,6 +1866,7 @@ xfs_alloc_fix_freelist(
 	/*
 	 * Initialize the args structure.
 	 */
+	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
 	targs.agbp = agbp;
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2437,6 +2437,7 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
+	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
@@ -3082,6 +3083,7 @@ xfs_bmap_extents_to_btree(
 	 * Convert to a btree with two levels, one record in root.
 	 */
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
 	args.firstblock = *firstblock;
@@ -3237,6 +3239,7 @@ xfs_bmap_local_to_extents(
 		xfs_buf_t	*bp;	/* buffer for extent block */
 		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
 
+		memset(&args, 0, sizeof(args));
 		args.tp = tp;
 		args.mp = ip->i_mount;
 		args.firstblock = *firstblock;
Index: b/fs/xfs/xfs_ialloc.c
===================================================================
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -250,6 +250,7 @@ xfs_ialloc_ag_alloc(
 					/* boundary */
 	struct xfs_perag *pag;
 
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
