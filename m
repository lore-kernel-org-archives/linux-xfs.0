Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBAKknLj003408 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 14:46:49 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W5GvmI3wISrymEet for
	<xfs@oss.sgi.com>; Mon, 10 Dec 2012 12:49:17 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBAKnHT0008795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 15:49:17 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qBAKnFTJ032474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 15:49:17 -0500
Message-ID: <50C64ACB.2090704@redhat.com>
Date: Mon, 10 Dec 2012 14:49:15 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't zero structure members after a memset(0)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Commit 408cc4e97a3ccd172d2d676e4b585badf439271b
added memset(0, ...) to allocation args structures,
so there is no need to explicitly set any of the fields
to 0 after that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note, compile-tested only.

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 335206a..7701980 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -1871,8 +1871,6 @@ xfs_alloc_fix_freelist(
 	targs.mp = mp;
 	targs.agbp = agbp;
 	targs.agno = args->agno;
-	targs.mod = targs.minleft = targs.wasdel = targs.userdata =
-		targs.minalignslop = 0;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
 	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 83d0cf3..a876745 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3098,8 +3098,6 @@ xfs_bmap_extents_to_btree(
 		args.fsbno = *firstblock;
 	}
 	args.minlen = args.maxlen = args.prod = 1;
-	args.total = args.minleft = args.alignment = args.mod = args.isfl =
-		args.minalignslop = 0;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
 	if ((error = xfs_alloc_vextent(&args))) {
@@ -3257,8 +3255,6 @@ xfs_bmap_local_to_extents(
 			args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		}
 		args.total = total;
-		args.mod = args.minleft = args.alignment = args.wasdel =
-			args.isfl = args.minalignslop = 0;
 		args.minlen = args.maxlen = args.prod = 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			goto done;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index c5c4ef4..a2c066b 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -277,8 +277,6 @@ xfs_ialloc_ag_alloc(
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
 		args.type = XFS_ALLOCTYPE_THIS_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
 
 		/*
@@ -331,8 +329,6 @@ xfs_ialloc_ag_alloc(
 		 * Allocate a fixed-size extent of inodes.
 		 */
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.mod = args.total = args.wasdel = args.isfl =
-			args.userdata = args.minalignslop = 0;
 		args.prod = 1;
 		/*
 		 * Allow space for the inode btree to split.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
