Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1L8SlhZ136819 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 02:28:47 -0600
Received: from mail-ww0-f41.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C9102EDD5E
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 00:31:29 -0800 (PST)
Received: from mail-ww0-f41.google.com (mail-ww0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id VRdW1qFhrS4FeSuu
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 00:31:29 -0800 (PST)
Received: by wwi18 with SMTP id 18so2744746wwi.2
	for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 00:31:29 -0800 (PST)
Message-ID: <4D6221B8.9040303@gmail.com>
Date: Mon, 21 Feb 2011 09:26:32 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] Check for immutable flag in fallocate path
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: cluster-devel@redhat.com, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

From: Marco Stornelli <marco.stornelli@gmail.com>

All fs must check for the immutable flag in their fallocate callback.
It's possible to have a race condition in this scenario: an application
open a file in read/write and it does something, meanwhile root set the
immutable flag on the file, the application at that point can call
fallocate with success. Only Ocfs2 check for the immutable flag at the
moment.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
Patch is against 2.6.38-rc5

--- linux-2.6.38-rc5-orig/fs/ext4/extents.c	2011-02-16 04:23:45.000000000 +0100
+++ linux-2.6.38-rc5/fs/ext4/extents.c	2011-02-21 08:43:37.000000000 +0100
@@ -3670,6 +3670,12 @@ long ext4_fallocate(struct file *file, i
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
 	mutex_lock(&inode->i_mutex);
+
+	if (IS_IMMUTABLE(inode)) {
+		mutex_unlock(&inode->i_mutex);
+		return -EPERM;
+	}
+
 	ret = inode_newsize_ok(inode, (len + offset));
 	if (ret) {
 		mutex_unlock(&inode->i_mutex);
--- linux-2.6.38-rc5-orig/fs/btrfs/file.c	2011-02-16 04:23:45.000000000 +0100
+++ linux-2.6.38-rc5/fs/btrfs/file.c	2011-02-21 08:55:58.000000000 +0100
@@ -1289,6 +1289,12 @@ static long btrfs_fallocate(struct file
 	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
 
 	mutex_lock(&inode->i_mutex);
+
+	if (IS_IMMUTABLE(inode)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	ret = inode_newsize_ok(inode, alloc_end);
 	if (ret)
 		goto out;
--- linux-2.6.38-rc5-orig/fs/xfs/linux-2.6/xfs_file.c	2011-02-16 04:23:45.000000000 +0100
+++ linux-2.6.38-rc5/fs/xfs/linux-2.6/xfs_file.c	2011-02-21 09:07:46.000000000 +0100
@@ -909,6 +909,11 @@ xfs_file_fallocate(
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		cmd = XFS_IOC_UNRESVSP;
 
+	if (IS_IMMUTABLE(inode)) {
+		error = -EPERM;
+		goto out_unlock;
+	}
+
 	/* check the new inode size is valid before allocating */
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode)) {
--- linux-2.6.38-rc5-orig/fs/gfs2/file.c	2011-02-16 04:23:45.000000000 +0100
+++ linux-2.6.38-rc5/fs/gfs2/file.c	2011-02-21 09:09:17.000000000 +0100
@@ -797,6 +797,11 @@ static long gfs2_fallocate(struct file *
 	if (unlikely(error))
 		goto out_uninit;
 
+	if (IS_IMMUTABLE(inode)) {
+		error = -EPERM;
+		goto out_unlock;
+	}
+
 	if (!gfs2_write_alloc_required(ip, offset, len))
 		goto out_unlock;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
