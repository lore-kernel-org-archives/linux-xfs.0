Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47641 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751027AbdCTE5c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2017 00:57:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2K4oIMc006278
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2017 21:54:56 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 299tbx1nf5-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2017 21:54:56 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)     by
 mx-out.facebook.com (10.223.100.99) with ESMTP id
 5b0cda9e0d2911e7a0eb24be05956610-bb3fc9a0 for <linux-xfs@vger.kernel.org>;
        Sun, 19 Mar 2017 21:54:53 -0700
From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH v2] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends of files
Date: Sun, 19 Mar 2017 21:54:51 -0700
Message-ID: <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com>
In-Reply-To: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org, calvinowens@fb.com

When punching past EOF on XFS, fallocate(mode=PUNCH_HOLE|KEEP_SIZE) will
round the file size up to the nearest multiple of PAGE_SIZE:

  calvinow@vm-disks/generic-xfs-1 ~$ dd if=/dev/urandom of=test bs=2048 count=1
  calvinow@vm-disks/generic-xfs-1 ~$ stat test
    Size: 2048            Blocks: 8          IO Block: 4096   regular file
  calvinow@vm-disks/generic-xfs-1 ~$ fallocate -n -l 2048 -o 2048 -p test
  calvinow@vm-disks/generic-xfs-1 ~$ stat test
    Size: 4096            Blocks: 8          IO Block: 4096   regular file

Commit 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes") replaced
xfs_zero_remaining_bytes() with calls to iomap helpers. The new helpers
don't enforce that [pos,offset) lies strictly on [0,i_size) when being
called from xfs_free_file_space(), so by "leaking" these ranges into
xfs_zero_range() we get this buggy behavior.

Fix this by reintroducing the checks xfs_zero_remaining_bytes() did
against i_size at the bottom of xfs_free_file_space().

Reported-by: Aaron Gao <gzh@fb.com>
Fixes: 3c2bdc912a1cc050 ("xfs: kill xfs_zero_remaining_bytes")
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org> # 4.8+
Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 fs/xfs/xfs_bmap_util.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8b75dce..0796ebc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1309,6 +1309,17 @@ xfs_free_file_space(
 	}
 
 	/*
+	 * Avoid doing I/O beyond eof - it's not necessary
+	 * since nothing can read beyond eof.  The space will
+	 * be zeroed when the file is extended anyway.
+	 */
+	if (offset >= XFS_ISIZE(ip))
+		return 0;
+
+	if ((offset + len) >= XFS_ISIZE(ip))
+		len = XFS_ISIZE(ip) - offset - 1;
+
+	/*
 	 * Now that we've unmap all full blocks we'll have to zero out any
 	 * partial block at the beginning and/or end.  xfs_zero_range is
 	 * smart enough to skip any holes, including those we just created.
-- 
2.9.3

