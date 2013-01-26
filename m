Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95DDC7F50
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EC18304077
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:37 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s6V2Y8kbtJ2G19DH for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
Date: Sat, 26 Jan 2013 16:40:26 -0600
Message-Id: <1359240032-11576-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

This is a merge-to-userspace of kernel commit a0041684
xfs: zero allocation_args on the kernel stack

When calling xfs_alloc_vextent args.userdata was uninitialized,
and if we had args.type==XFS_ALLOCTYPE_START_BNO, this uninit
structure member got tested, leading to some random allocator
behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/xfs_alloc.c  |    1 +
 libxfs/xfs_bmap.c   |    3 +++
 libxfs/xfs_ialloc.c |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index a76512d..831040a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1788,6 +1788,7 @@ xfs_alloc_fix_freelist(
 	/*
 	 * Initialize the args structure.
 	 */
+	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
 	targs.agbp = agbp;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5a626b0..883035e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2411,6 +2411,7 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
+	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->rval;
@@ -3044,6 +3045,7 @@ xfs_bmap_extents_to_btree(
 	 * Convert to a btree with two levels, one record in root.
 	 */
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
 	args.firstblock = *firstblock;
@@ -3205,6 +3207,7 @@ xfs_bmap_local_to_extents(
 		xfs_buf_t	*bp;	/* buffer for extent block */
 		xfs_bmbt_rec_host_t *ep;/* extent record pointer */
 
+		memset(&args, 0, sizeof(args));
 		args.tp = tp;
 		args.mp = ip->i_mount;
 		args.firstblock = *firstblock;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 1fcafb6..f97dc4d 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -232,6 +232,7 @@ xfs_ialloc_ag_alloc(
 					/* boundary */
 	struct xfs_perag *pag;
 
+	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
