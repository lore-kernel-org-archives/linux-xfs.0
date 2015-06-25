Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D182E7F8C
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:40:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C162A304039
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:40:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id avGvEd5Cj2gURoGX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:40:44 -0700 (PDT)
Subject: [PATCH 13/14] xfs: add reflink btree root when expanding the
	filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:40:37 -0700
Message-ID: <20150625234037.4992.7413.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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

Create the root of the reflink btree whenever we add an AG to the
filesystem.  Plumb in the bits that enable growfs to ask the kernel
whether or not the fs supports reflink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_shared.h |    1 +
 fs/xfs/xfs_fsops.c         |   30 +++++++++++++++++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6b1b71c..d7541f7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -242,6 +242,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* Reverse mapping btree */
+#define XFS_FSOP_GEOM_FLAGS_REFLINK	0x100000	/* reflink */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index d1de74e..807c0e3 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -53,6 +53,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_reflinkbt_buf_ops;
 
 /*
  * Transaction types.  Used to distinguish types of buffers. These never reach
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9aabefb..d68a3b5 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -106,7 +106,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
 			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0);
+				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
+			(xfs_sb_version_hasreflink(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
@@ -260,6 +262,10 @@ xfs_growfs_data_private(
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			agf->agf_reflink_root = cpu_to_be32(XFS_RL_BLOCK(mp));
+			agf->agf_reflink_level = cpu_to_be32(1);
+		}
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
@@ -503,6 +509,28 @@ xfs_growfs_data_private(
 				goto error0;
 		}
 
+		/*
+		 * reflink btree root block
+		 */
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_RL_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_reflinkbt_buf_ops);
+			if (!bp) {
+				error = -ENOMEM;
+				goto error0;
+			}
+
+			xfs_btree_init_block(mp, bp, XFS_RLBT_CRC_MAGIC,
+					     0, 0, agno,
+					     XFS_BTREE_CRC_BLOCKS);
+
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+			if (error)
+				goto error0;
+		}
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
