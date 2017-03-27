Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32832 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdC0Hwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 03:52:42 -0400
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Consider including ef388e2054fe ("xfs: don't allow di_size with high
 bit set") into stable releases
Message-ID: <53efcbd6-289e-3b71-3d47-73d2b06b98ba@gmail.com>
Date: Mon, 27 Mar 2017 10:43:31 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B8811F05910FFB20D8FC1EA5"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, bfoster@redhat.com

This is a multi-part message in MIME format.
--------------B8811F05910FFB20D8FC1EA5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,


The patch in the subject applies cleanly on 4.4 and I have attached the
backport for 3.12. This causes hangs in both xfs/133 and xfs/134. As is
customary - a battery of xfstests have been run to ensure no regressions
were introduced.

Regards,
Nikolay

--------------B8811F05910FFB20D8FC1EA5
Content-Type: text/x-patch;
 name="0001-xfs-don-t-allow-di_size-with-high-bit-set.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-xfs-don-t-allow-di_size-with-high-bit-set.patch"

>From a8581aae46a02f329fce5678a5932d99e1c188e0 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 5 Dec 2016 12:38:38 +1100
Subject: [PATCH] xfs: don't allow di_size with high bit set

The on-disk field di_size is used to set i_size, which is a signed
integer of loff_t.  If the high bit of di_size is set, we'll end up with
a negative i_size, which will cause all sorts of problems.  Since the
VFS won't let us create a file with such length, we should catch them
here in the verifier too.

[nborisov: Backported to 3.12]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_inode_buf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 4b1447b3a9e4..8cc193ab434a 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -301,6 +301,14 @@ xfs_dinode_verify(
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
 		return false;
 
+	/* don't allow invalid i_size */
+	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
+		return false;
+
+	/* No zero-length symlinks. */
+	if (S_ISLNK(be16_to_cpu(dip->di_mode)) && dip->di_size == 0)
+		return false;
+
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
 		return true;
-- 
2.7.4


--------------B8811F05910FFB20D8FC1EA5--
