Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 22:19:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K5Jg81025541
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 22:19:45 -0700
Date: Thu, 20 Mar 2008 16:20:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 1/2] Factor repeated code in xfs_ialloc_ag_alloc
Message-ID: <20080320052000.GZ95344431@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Factor repeated code that determines the cluster alignment of
an inode extent.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_ialloc.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_ialloc.c	2008-03-14 09:25:16.432921552 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_ialloc.c	2008-03-14 09:38:00.263435189 +1100
@@ -107,6 +107,16 @@ xfs_ialloc_log_di(
 /*
  * Allocation group level functions.
  */
+static inline int
+xfs_ialloc_cluster_alignment(
+	xfs_alloc_arg_t	*args)
+{
+	if (xfs_sb_version_hasalign(&args->mp->m_sb) &&
+	    args->mp->m_sb.sb_inoalignmt >=
+	     XFS_B_TO_FSBT(args->mp, XFS_INODE_CLUSTER_SIZE(args->mp)))
+		return args->mp->m_sb.sb_inoalignmt;
+	return 1;
+}
 
 /*
  * Allocate new inodes in the allocation group specified by agbp.
@@ -191,13 +201,8 @@ xfs_ialloc_ag_alloc(
 			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
-		} else if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
-			   args.mp->m_sb.sb_inoalignmt >=
-			   XFS_B_TO_FSBT(args.mp,
-			  	XFS_INODE_CLUSTER_SIZE(args.mp)))
-				args.alignment = args.mp->m_sb.sb_inoalignmt;
-		else
-			args.alignment = 1;
+		} else
+			args.alignment = xfs_ialloc_cluster_alignment(&args);
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
@@ -230,12 +235,7 @@ xfs_ialloc_ag_alloc(
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp,
 				be32_to_cpu(agi->agi_seqno), args.agbno);
-		if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
-			args.mp->m_sb.sb_inoalignmt >=
-			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
-				args.alignment = args.mp->m_sb.sb_inoalignmt;
-		else
-			args.alignment = 1;
+		args.alignment = xfs_ialloc_cluster_alignment(&args);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
