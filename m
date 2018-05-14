Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752019AbeENRmL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 13:42:11 -0400
Subject: [PATCH 4/5] btrfs: use common label ioctl definitions
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <060d984f-6386-2b23-7fd4-66b1a9a96aef@sandeen.net>
Date: Mon, 14 May 2018 12:42:10 -0500
MIME-Version: 1.0
In-Reply-To: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Use the new common online get/set label get/set definitions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Mostly for reference; this can be sent explicitly to the btrfs list
after the common definitions are in place.  Happy to do that so btrfs
changes won't go through the xfs tree.

 fs/btrfs/ioctl.c           | 8 ++++----
 include/uapi/linux/btrfs.h | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 632e26d6f7ce..8feea790bd00 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5444,6 +5444,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_setflags(file, argp);
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
+	case FS_IOC_GETFSLABEL:
+		return btrfs_ioctl_get_fslabel(file, argp);
+	case FS_IOC_SETFSLABEL:
+		return btrfs_ioctl_set_fslabel(file, argp);
 	case FITRIM:
 		return btrfs_ioctl_fitrim(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
@@ -5555,10 +5559,6 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_quota_rescan_wait(file, argp);
 	case BTRFS_IOC_DEV_REPLACE:
 		return btrfs_ioctl_dev_replace(fs_info, argp);
-	case BTRFS_IOC_GET_FSLABEL:
-		return btrfs_ioctl_get_fslabel(file, argp);
-	case BTRFS_IOC_SET_FSLABEL:
-		return btrfs_ioctl_set_fslabel(file, argp);
 	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
 		return btrfs_ioctl_get_supported_features(argp);
 	case BTRFS_IOC_GET_FEATURES:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c8d99b9ca550..af29cc9032a2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -823,10 +823,8 @@ enum btrfs_err_code {
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
-#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
-				   char[BTRFS_LABEL_SIZE])
-#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-				   char[BTRFS_LABEL_SIZE])
+#define BTRFS_IOC_GET_FSLABEL 	FS_IOC_GETFSLABEL
+#define BTRFS_IOC_SET_FSLABEL	FS_IOC_SETFSLABEL
 #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
-- 
2.17.0


