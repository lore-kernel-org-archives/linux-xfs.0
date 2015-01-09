Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82AAD7F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 03:35:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 502DC304051
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 01:35:00 -0800 (PST)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id VAR6Fzr8R4Ly1kgn for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 01:34:58 -0800 (PST)
From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: support fs shutdown
Date: Fri,  9 Jan 2015 01:34:36 -0800
Message-Id: <1420796076-82847-2-git-send-email-jaegeuk@kernel.org>
In-Reply-To: <1420796076-82847-1-git-send-email-jaegeuk@kernel.org>
References: <1420796076-82847-1-git-send-email-jaegeuk@kernel.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Jaegeuk Kim <jaegeuk@kernel.org>

This patch add an ioctl to shutdown f2fs, which stops all the further block
writes after this point.

The ioctl, FS_IOC_SHUTDOWN, provides the following three options.

1. FS_GOING_DOWN_FULLSYNC
 : this will flush all the data and dentry blocks, and do checkpoint before
 shutdown.

2. FS_GOING_DOWN_METASYNC
 : this will do checkpoint before shutdown.

3. FS_GOING_DOWN_NOSYNC
 : this will trigger shutdown as is.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5df3367..a7114858 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1020,6 +1020,41 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	return ret;
 }
 
+static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct super_block *sb = sbi->sb;
+	__u32 in;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (get_user(in, (__u32 __user *)arg))
+		return -EFAULT;
+
+	switch (in) {
+	case FS_GOING_DOWN_FULLSYNC:
+		sb = freeze_bdev(sb->s_bdev);
+		if (sb && !IS_ERR(sb)) {
+			f2fs_stop_checkpoint(sbi);
+			thaw_bdev(sb->s_bdev, sb);
+		}
+		break;
+	case FS_GOING_DOWN_METASYNC:
+		/* do checkpoint only */
+		f2fs_sync_fs(sb, 1);
+		f2fs_stop_checkpoint(sbi);
+		break;
+	case FS_GOING_DOWN_NOSYNC:
+		f2fs_stop_checkpoint(sbi);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1067,6 +1102,8 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_release_volatile_write(filp);
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 		return f2fs_ioc_abort_volatile_write(filp);
+	case FS_IOC_SHUTDOWN:
+		return f2fs_ioc_shutdown(filp, arg);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
-- 
2.1.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
