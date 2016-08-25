Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBF247EAA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:39:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 84CD88F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PevkhkZs1xPFGUYL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:39:25 -0700 (PDT)
Subject: [PATCH 68/71] xfs: recognize the reflink feature bit
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:39:19 -0700
Message-ID: <147216835974.867.6260866903649232833.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Add the reflink feature flag to the set of recognized feature flags.
This enables users to write to reflink filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/xfs_super.c         |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4f2a354..bf40fa8 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -459,7 +459,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6ef6244..2d249a5 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1596,6 +1596,9 @@ xfs_fs_fill_super(
 			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			xfs_alert(mp,
+		"DAX and reflink have not been tested together!");
 	}
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
@@ -1609,6 +1612,10 @@ xfs_fs_fill_super(
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
