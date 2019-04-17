Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36572 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 15:05:24 -0400
Subject: [PATCH 8/8] ext4: don't allow any modifications to an immutable file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 17 Apr 2019 12:05:19 -0700
Message-ID: <155552791984.20411.6785112966155823848.stgit@magnolia>
In-Reply-To: <155552786671.20411.6442426840435740050.stgit@magnolia>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't allow any modifications to a file that's marked immutable, which
means that we have to flush all the writable pages to make the readonly
and we have to check the setattr/setflags parameters more closely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ioctl.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)


diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bab3da4f1e0d..abf3b88d5af7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -269,6 +269,29 @@ static int uuid_is_zero(__u8 u[16])
 }
 #endif
 
+/*
+ * If immutable is set and we are not clearing it, we're not allowed to change
+ * anything else in the inode.  Don't error out if we're only trying to set
+ * immutable on an immutable file.
+ */
+static int ext4_ioctl_check_immutable(struct inode *inode, __u32 new_projid,
+				      unsigned int flags)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int oldflags = ei->i_flags;
+
+	if (!(oldflags & EXT4_IMMUTABLE_FL) || !(flags & EXT4_IMMUTABLE_FL))
+		return 0;
+
+	if ((oldflags & ~EXT4_IMMUTABLE_FL) != (flags & ~EXT4_IMMUTABLE_FL))
+		return -EPERM;
+	if (ext4_has_feature_project(inode->i_sb) &&
+	    __kprojid_val(ei->i_projid) != new_projid)
+		return -EPERM;
+
+	return 0;
+}
+
 static int ext4_ioctl_setflags(struct inode *inode,
 			       unsigned int flags)
 {
@@ -322,6 +345,20 @@ static int ext4_ioctl_setflags(struct inode *inode,
 			goto flags_out;
 	}
 
+	/*
+	 * Wait for all pending directio and then flush all the dirty pages
+	 * for this file.  The flush marks all the pages readonly, so any
+	 * subsequent attempt to write to the file (particularly mmap pages)
+	 * will come through the filesystem and fail.
+	 */
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (flags & EXT4_IMMUTABLE_FL)) {
+		inode_dio_wait(inode);
+		err = filemap_write_and_wait(inode->i_mapping);
+		if (err)
+			goto flags_out;
+	}
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -751,7 +788,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return err;
 
 		inode_lock(inode);
-		err = ext4_ioctl_setflags(inode, flags);
+		err = ext4_ioctl_check_immutable(inode,
+				from_kprojid(&init_user_ns, ei->i_projid),
+				flags);
+		if (!err)
+			err = ext4_ioctl_setflags(inode, flags);
 		inode_unlock(inode);
 		mnt_drop_write_file(filp);
 		return err;
@@ -1121,6 +1162,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
 			 (flags & EXT4_FL_XFLAG_VISIBLE);
+		err = ext4_ioctl_check_immutable(inode, fa.fsx_projid, flags);
+		if (err)
+			goto out;
 		err = ext4_ioctl_setflags(inode, flags);
 		if (err)
 			goto out;
