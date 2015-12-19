Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B38698157
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4FF1304062
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:27 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3klxFjtK6Gy359hI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:26 -0800 (PST)
Subject: [PATCH 72/76] xfs: recognize the reflink feature bit
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:23 -0800
Message-ID: <20151219090423.12713.20575.stgit@birch.djwong.org>
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

Add the reflink feature flag to the set of recognized feature flags.
This enables users to write to reflink filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 fs/xfs/libxfs/xfs_sb.c     |    5 +++++
 fs/xfs/xfs_super.c         |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7482531..ab0341f 100644
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index c195ea7..a99eb01 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -230,6 +230,11 @@ xfs_mount_validate_sb(
 "EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 	}
 
+	if (xfs_sb_version_hasreflink(sbp)) {
+		xfs_alert(mp,
+"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
+	}
+
 	/*
 	 * More sanity checking.  Most of these were stolen directly from
 	 * xfs_repair.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 36df40b..ede714b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1536,6 +1536,9 @@ xfs_fs_fill_super(
 		"Block device does not support DAX Turning DAX off.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
+		if (xfs_sb_version_hasreflink(&mp->m_sb))
+			xfs_alert(mp,
+		"DAX and reflink have not been tested together!");
 	}
 
 	if (xfs_sb_version_hassparseinodes(&mp->m_sb))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
