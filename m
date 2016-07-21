Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04D6B7D72
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BCCA58F8037
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8iqVnAlpOYS8aXja (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:48 -0700 (PDT)
Subject: [PATCH 42/47] xfs: add rmap btree geometry feature flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:00:42 -0700
Message-ID: <146907724255.25461.10542274459423853644.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

So xfs_info and other userspace utilities know the filesystem is
using this feature.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/xfs_fsops.c     |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f5ec9c5..7945505 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -206,6 +206,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_FTYPE	0x10000	/* inode directory types */
 #define XFS_FSOP_GEOM_FLAGS_FINOBT	0x20000	/* free inode btree */
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	0x40000	/* sparse inode chunks	*/
+#define XFS_FSOP_GEOM_FLAGS_RMAPBT	0x80000	/* Reverse mapping btree */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 83304d5..0f96847 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -106,7 +106,9 @@ xfs_fs_geometry(
 			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
 			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
-				XFS_FSOP_GEOM_FLAGS_SPINODES : 0);
+				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
+			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
