Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Neide067744 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:44 -0600
Message-Id: <20121203144312.044410710@sgi.com>
Date: Mon, 03 Dec 2012 17:42:43 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 35/36] xfs: zero allocation_args on the kernel stack
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=xfs-zero-allocation-args-on-stack.patch
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Mark Tinguely <tinguely@sgi.com>

Upstream commit: a00416844b8f4b0106344bdfd90fe45a854b1d05

    xfs: zero allocation_args on the kernel stack
    
    Zero the kernel stack space that makes up the xfs_alloc_arg structures.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

---
 fs/xfs/xfs_alloc.c  |    1 +
 fs/xfs/xfs_bmap.c   |    3 +++
 fs/xfs/xfs_ialloc.c |    1 +
 3 files changed, 5 insertions(+)

Index: b/fs/xfs/xfs_alloc.c
===================================================================
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1872,6 +1872,7 @@ xfs_alloc_fix_freelist(
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
@@ -2561,6 +2561,7 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
+	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->rval;
@@ -3194,6 +3195,7 @@ xfs_bmap_extents_to_btree(
 	 * Convert to a btree with two levels, one record in root.
 	 */
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
 	args.firstblock = *firstblock;
@@ -3355,6 +3357,7 @@ xfs_bmap_local_to_extents(
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
@@ -251,6 +251,7 @@ xfs_ialloc_ag_alloc(
 					/* boundary */
 	struct xfs_perag *pag;
 
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
