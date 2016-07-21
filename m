Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D63B87CD5
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:01:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D0BD304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:01:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id QD8Zc4azen9AwrgA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:01:07 -0700 (PDT)
Subject: [PATCH 45/47] xfs: don't update rmapbt when fixing agfl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:01:02 -0700
Message-ID: <146907726217.25461.5754820873842021488.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Allow a caller of xfs_alloc_fix_freelist to disable rmapbt updates
when fixing the AG freelist.  xfs_repair needs this during phase 5
to be able to adjust the freelist while it's reconstructing the rmap
btree; the missing entries will be added back at the very end of
phase 5 once the AGFL contents settle down.

v2: Explicitly skip the rmap owner update since we no longer accept
owner == 0 for "don't update rmap".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   18 ++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.h |    3 +++
 2 files changed, 17 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 73ab1ea..a0dc299 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2090,9 +2090,21 @@ xfs_alloc_fix_freelist(
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
-	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
-	while (pag->pagf_flcount > need) {
+	memset(&targs, 0, sizeof(targs));
+	if (flags & XFS_ALLOC_FLAG_NORMAP)
+		xfs_rmap_skip_owner_update(&targs.oinfo);
+	else
+		xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
+	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
 		struct xfs_buf	*bp;
 
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
@@ -2106,10 +2118,8 @@ xfs_alloc_fix_freelist(
 		xfs_trans_binval(tp, bp);
 	}
 
-	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
-	xfs_rmap_ag_owner(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 360f9e4..6fe2d6b 100644
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
