Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 797077F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:51:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 563C7304048
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:51:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bl5ng8tTCpsdshjk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:51:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OEpCok008437
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:51:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OEN958030706
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/18] xfs: pass xfs_mount directly to
	xfs_ialloc_cluster_alignment()
Date: Thu, 24 Jul 2014 10:22:52 -0400
Message-Id: <1406211788-63206-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

xfs_ialloc_cluster_alignment() takes an args parameter but only uses the
xfs_mount pointer. Replace the args parameter with mp such that we can
use this function from additional contexts.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6e2ccb3..5448a74 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -48,12 +48,12 @@
  */
 static inline int
 xfs_ialloc_cluster_alignment(
-	xfs_alloc_arg_t	*args)
+	struct xfs_mount *mp)
 {
-	if (xfs_sb_version_hasalign(&args->mp->m_sb) &&
-	    args->mp->m_sb.sb_inoalignmt >=
-	     XFS_B_TO_FSBT(args->mp, args->mp->m_inode_cluster_size))
-		return args->mp->m_sb.sb_inoalignmt;
+	if (xfs_sb_version_hasalign(&mp->m_sb) &&
+	    mp->m_sb.sb_inoalignmt >=
+	     XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
+		return mp->m_sb.sb_inoalignmt;
 	return 1;
 }
 
@@ -407,7 +407,7 @@ xfs_ialloc_ag_alloc(
 		 * but not to use them in the actual exact allocation.
 		 */
 		args.alignment = 1;
-		args.minalignslop = xfs_ialloc_cluster_alignment(&args) - 1;
+		args.minalignslop = xfs_ialloc_cluster_alignment(args.mp) - 1;
 
 		/* Allow space for the inode btree to split. */
 		args.minleft = args.mp->m_in_maxlevels - 1;
@@ -443,7 +443,7 @@ xfs_ialloc_ag_alloc(
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
-			args.alignment = xfs_ialloc_cluster_alignment(&args);
+			args.alignment = xfs_ialloc_cluster_alignment(args.mp);
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
@@ -472,7 +472,7 @@ xfs_ialloc_ag_alloc(
 		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
-		args.alignment = xfs_ialloc_cluster_alignment(&args);
+		args.alignment = xfs_ialloc_cluster_alignment(args.mp);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
