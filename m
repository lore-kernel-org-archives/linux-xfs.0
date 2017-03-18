Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57665 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751185AbdCRDFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 23:05:30 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2I1NePq002889
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 18:24:50 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 298seyr8j3-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 18:24:50 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)     by
 mx-out.facebook.com (10.103.99.97) with ESMTP  id
 ad750c5e0b7911e7b58b0002c9931860-df9f89a0 for <linux-xfs@vger.kernel.org>;
        Fri, 17 Mar 2017 18:24:48 -0700
From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of files
Date: Fri, 17 Mar 2017 18:24:48 -0700
Message-ID: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org

Commit 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes") replaced
xfs_zero_remaining_bytes() with calls to iomap helpers.

Unfortunately the new iomap helpers don't enforce that [pos,count) lies
strictly on [0,i_size). This causes fallocate(mode=PUNCH_HOLE|KEEP_SIZE)
calls touching [i_size & ~PAGE_MASK, OFF_T_MAX] to round i_size up to
the nearest multiple of PAGE_SIZE:

  calvinow@vm-disks/generic-xfs-1 ~$ dd if=/dev/urandom of=test bs=2048 count=1
  calvinow@vm-disks/generic-xfs-1 ~$ stat test
    Size: 2048            Blocks: 8          IO Block: 4096   regular file
  calvinow@vm-disks/generic-xfs-1 ~$ fallocate -n -l 2048 -o 2048 -p test
  calvinow@vm-disks/generic-xfs-1 ~$ stat test
    Size: 4096            Blocks: 8          IO Block: 4096   regular file

Fix this by reintroducing the checks xfs_zero_remaining_bytes() did
against i_size into xfs_zero_range().

Reported-by: Aaron Gao <gzh@fb.com>
Fixes: 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes")
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # 4.8+
Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 fs/xfs/xfs_file.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 35703a8..da7cd27 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -58,6 +58,17 @@ xfs_zero_range(
 	xfs_off_t		count,
 	bool			*did_zero)
 {
+	/*
+	 * Avoid doing I/O beyond eof - it's not necessary
+	 * since nothing can read beyond eof.  The space will
+	 * be zeroed when the file is extended anyway.
+	 */
+	if (pos >= XFS_ISIZE(ip))
+		return 0;
+
+	if ((pos + count) >= XFS_ISIZE(ip))
+		count = XFS_ISIZE(ip) - pos - 1;
+
 	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
 }
 
-- 
2.9.3

