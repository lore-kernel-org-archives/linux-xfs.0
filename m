Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35108 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753225AbcKRAID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 19:08:03 -0500
Received: by mail-pg0-f44.google.com with SMTP id p66so96412249pga.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 16:08:02 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 2/2] Btrfs: make a source length of 0 imply EOF for dedupe
Date: Thu, 17 Nov 2016 16:07:50 -0800
Message-Id: <42687716155fb892c55b56f22a995b39e543f906.1479427384.git.osandov@fb.com>
In-Reply-To: <cover.1479427384.git.osandov@fb.com>
References: <cover.1479427384.git.osandov@fb.com>
In-Reply-To: <cover.1479427384.git.osandov@fb.com>
References: <cover.1479427384.git.osandov@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>, kernel-team@fb.com

From: Omar Sandoval <osandov@fb.com>

This makes us consistent with both reflink and the XFS implementation of
dedupe.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e23f945..320fb35 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3121,21 +3121,25 @@ static int extent_same_check_offsets(struct inode *inode, u64 off, u64 *plen,
 static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
-	int ret;
-	u64 len = olen;
+	int ret = 0;
+	u64 len;
 	struct cmp_pages cmp;
 	bool same_inode = (src == dst);
 	u64 same_lock_start = 0;
 	u64 same_lock_len = 0;
 
-	if (len == 0)
-		return 0;
-
 	if (same_inode)
 		inode_lock(src);
 	else
 		btrfs_double_inode_lock(src, dst);
 
+	if (olen == 0) {
+		olen = i_size_read(src) - loff;
+		if (olen == 0)
+			goto out_unlock;
+	}
+	len = olen;
+
 	ret = extent_same_check_offsets(src, loff, &len, olen);
 	if (ret)
 		goto out_unlock;
-- 
2.10.2

