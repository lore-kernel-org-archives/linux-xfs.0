Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3694806C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:00:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9728B8F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:26 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UIhZpaaCLbZp7zA0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:25 -0800 (PST)
Subject: [PATCH 36/76] xfs: don't update rmapbt when fixing agfl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:00:21 -0800
Message-ID: <20151219090021.12713.2792.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Allow a caller of xfs_alloc_fix_freelist to disable rmapbt updates
when fixing the AG freelist.  xfs_repair needs this during phase 5
to be able to adjust the freelist while it's reconstructing the rmap
btree; the missing entries will be added back at the very end of
phase 5 once the AGFL contents settle down.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   40 ++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc.h |    5 ++++-
 2 files changed, 30 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aa3cc24..cc23a30 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2101,26 +2101,38 @@ xfs_alloc_fix_freelist(
 	 * anything other than extra overhead when we need to put more blocks
 	 * back on the free list? Maybe we should only do this when space is
 	 * getting low or the AGFL is more than half full?
+	 *
+	 * The NOSHRINK flag prevents the AGFL from being shrunk if it's too
+	 * big; the NORMAP flag prevents AGFL expand/shrink operations from
+	 * updating the rmapbt.  Both flags are used in xfs_repair while we're
+	 * rebuilding the rmapbt, and neither are used by the kernel.  They're
+	 * both required to ensure that rmaps are correctly recorded for the
+	 * regenerated AGFL, bnobt, and cntbt.  See repair/phase5.c and
+	 * repair/rmap.c in xfsprogs for details.
 	 */
-	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
-	while (pag->pagf_flcount > need) {
-		struct xfs_buf	*bp;
+	memset(&targs, 0, sizeof(targs));
+	if (!(flags & XFS_ALLOC_FLAG_NOSHRINK)) {
+		if (!(flags & XFS_ALLOC_FLAG_NORMAP))
+			XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
+		while (pag->pagf_flcount > need) {
+			struct xfs_buf	*bp;
 
-		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
-		if (error)
-			goto out_agbp_relse;
-		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
-					   &targs.oinfo, 1);
-		if (error)
-			goto out_agbp_relse;
-		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
-		xfs_trans_binval(tp, bp);
+			error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
+			if (error)
+				goto out_agbp_relse;
+			error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
+						   &targs.oinfo, 1);
+			if (error)
+				goto out_agbp_relse;
+			bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
+			xfs_trans_binval(tp, bp);
+		}
 	}
 
-	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
-	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
+	if (!(flags & XFS_ALLOC_FLAG_NORMAP))
+		XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index ea2868d..f21ec2b 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -54,6 +54,9 @@ typedef unsigned int xfs_alloctype_t;
  */
 #define	XFS_ALLOC_FLAG_TRYLOCK	0x00000001  /* use trylock for buffer locking */
 #define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
+#define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
+#define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
+
 
 /*
  * Argument structure for xfs_alloc routines.
@@ -87,7 +90,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
-	struct xfs_owner_info	oinfo;		/* owner of blocks being allocated */
+	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
