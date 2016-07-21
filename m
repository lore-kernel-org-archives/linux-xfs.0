Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3369B7D88
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:01:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D113C304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:01:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JwPQ8SHDzxhqNx2T (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:01:14 -0700 (PDT)
Subject: [PATCH 46/47] xfs: enable the rmap btree functionality
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:01:08 -0700
Message-ID: <146907726852.25461.2094606664613325490.stgit@birch.djwong.org>
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

Add the feature flag to the supported matrix so that the kernel can
mount and use rmap btree enabled filesystems

v2: Move the EXPERIMENTAL message to fill_super so it only prints once.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick.wong@oracle.com: move the experimental tag]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/xfs_super.c         |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f6a0641..f814d42 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -457,7 +457,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b8d4473..fbfe6c7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1578,6 +1578,10 @@ xfs_fs_fill_super(
 		xfs_alert(mp,
 	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
