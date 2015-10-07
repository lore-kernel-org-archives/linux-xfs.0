Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EA4329ECD
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:09:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F66A8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:09:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pMVKKdCuciWDWSeE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:09:17 -0700 (PDT)
Subject: [PATCH 37/51] xfs_mkfs: initialize extra fields during mkfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:09:14 -0700
Message-ID: <20151007050914.1504.70242.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b496349..573774c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2974,6 +2974,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = 0;
 			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account freespace btree root blocks */
@@ -2981,6 +2982,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(2);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account inode btree root blocks */
@@ -2989,6 +2991,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
 							XFS_IBT_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account for rmap btree root */ 
@@ -2996,6 +2999,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(1);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account for the log space */
@@ -3005,6 +3009,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						XFS_FSB_TO_AGBNO(mp, logstart));
 				rrec->rm_blockcount = cpu_to_be32(logblocks);
 				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+				rrec->rm_offset = 0;
 				be16_add_cpu(&block->bb_numrecs, 1);
 			}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
