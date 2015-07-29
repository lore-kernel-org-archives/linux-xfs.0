Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1886C29E01
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:35:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC6AA8F8033
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:35:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id A8o4G8KQ8F0ulSCH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:35:34 -0700 (PDT)
Subject: [PATCH 24/24] xfs: recognize the reflink feature bit
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:35:31 -0700
Message-ID: <20150729223531.17414.5151.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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

Add the reflink feature flag to the set of recognized feature flags.
This enables users to write to reflink filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/libxfs/xfs_sb.c     |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ec14477..c289c2e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -449,7 +449,8 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a7dcbe0..f74287e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -219,6 +219,16 @@ xfs_mount_validate_sb(
 "EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
+	if (xfs_sb_version_hasreflink(sbp)) {
+		xfs_alert(mp,
+"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
+		if (xfs_sb_version_hasrmapbt(sbp)) {
+			printk(KERN_ERR
+"EXPERIMENTAL reverse mapping btree conflicts with reflink!  Mount fails.");
+			return -EINVAL;
+		}
+	}
+
 	/*
 	 * More sanity checking.  Most of these were stolen directly from
 	 * xfs_repair.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
