Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03BC17CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:38:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72631AC004
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:38:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qkSOkpu3grjoJPed for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:38:41 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5F0504A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:38:41 -0500 (CDT)
Subject: [PATCH 1/4] fs: hoist [GS]ET_FSLABEL to vfs
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d5394e49-dd3c-6725-2f93-a6b1acd7c36f@sandeen.net>
Date: Thu, 9 Jun 2016 11:38:40 -0500
MIME-Version: 1.0
In-Reply-To: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
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
To: xfs@oss.sgi.com

Move the btrfs label ioctls up to the vfs for general use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 053e677..b23be4e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5431,6 +5431,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_setflags(file, argp);
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
+	case FS_IOC_GET_FSLABEL:
+		return btrfs_ioctl_get_fslabel(file, argp);
+	case FS_IOC_SET_FSLABEL:
+		return btrfs_ioctl_set_fslabel(file, argp);
 	case FITRIM:
 		return btrfs_ioctl_fitrim(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
@@ -5538,10 +5542,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_quota_rescan_wait(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(root, argp);
-	case BTRFS_IOC_GET_FSLABEL:
-		return btrfs_ioctl_get_fslabel(file, argp);
-	case BTRFS_IOC_SET_FSLABEL:
-		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a079d50..fca64f2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -234,6 +234,8 @@ struct fsxattr {
 #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
 #define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
 
+#define FSLABEL_MAX 256	/* Max chars for the interface; each fs may differ */
+
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
@@ -243,8 +245,10 @@ struct fsxattr {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
-#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
-#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_GET_FSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
+#define FS_IOC_SET_FSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
 /*
  * File system encryption support

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
