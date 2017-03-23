Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34554 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbdCWPUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2017 11:20:06 -0400
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Request 5c6863019e45 ("cancel the setfilesize transation when io
 error happen") for 3.12 stable inclusion
Message-ID: <48c85015-5520-bd42-dca7-cfb9634dcc39@gmail.com>
Date: Thu, 23 Mar 2017 17:19:56 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CD73CEE576983282630AE0B7"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, bfoster@redhat.com, david@fromorbit.com

This is a multi-part message in MIME format.
--------------CD73CEE576983282630AE0B7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,


I'd like to request the above patch be included into the 3.12 stable
tree. I've attached a backport and have run xfstest and no regressions
were observed. This fixes hang in generic/361 test.


Regards,
Nikolay

--------------CD73CEE576983282630AE0B7
Content-Type: text/x-patch;
 name="0001-cancel-the-setfilesize-transation-when-io-error-happ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-cancel-the-setfilesize-transation-when-io-error-happ.pa";
 filename*1="tch"

>From 5c6863019e453bee3ac6dbdf1fbf0d9125942c3b Mon Sep 17 00:00:00 2001
From: Zhaohongjiang <zhaohongjiang@huawei.com>
Date: Mon, 12 Oct 2015 15:28:39 +1100
Subject: [PATCH] cancel the setfilesize transation when io error happen

When I ran xfstest/073 case, the remount process was blocked to wait
transactions to be zero. I found there was a io error happened, and
the setfilesize transaction was not released properly. We should add
the changes to cancel the io error in this case.

Reproduction steps:
1. dd if=/dev/zero of=xfs1.img bs=1M count=2048
2. mkfs.xfs xfs1.img
3. losetup -f ./xfs1.img /dev/loop0
4. mount -t xfs /dev/loop0 /home/test_dir/
5. mkdir /home/test_dir/test
6. mkfs.xfs -dfile,name=image,size=2g
7. mount -t xfs -o loop image /home/test_dir/test
8. cp a file bigger than 2g to /home/test_dir/test
9. mount -t xfs -o remount,ro /home/test_dir/test

[ dchinner: moved io error detection to xfs_setfilesize_ioend() after
  transaction context restoration. ]

[ nborisov: Adjusted context for 3.12 ]

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_aops.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ab28ad576b16..6394e3f51553 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -150,6 +150,12 @@ xfs_setfilesize(
 	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
 			   0, 1, _THIS_IP_);
 
+	/* we abort the update if there was an IO error */
+	if (ioend->io_error) {
+		xfs_trans_cancel(tp, 0);
+		return ioend->io_error;
+	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
 	if (!isize) {
@@ -205,14 +211,17 @@ xfs_end_io(
 		ioend->io_error = -EIO;
 		goto done;
 	}
-	if (ioend->io_error)
-		goto done;
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
+	 * Detecting and handling completion IO errors is done individually
+	 * for each case as different cleanup operations need to be performed
+	 * on error.
 	 */
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
+		if (ioend->io_error)
+			goto done;
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						  ioend->io_size);
 	} else if (ioend->io_isdirect && xfs_ioend_is_append(ioend)) {
-- 
2.7.4


--------------CD73CEE576983282630AE0B7--
