Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:32998 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbcKRAIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2016 19:08:01 -0500
Received: by mail-pf0-f178.google.com with SMTP id d2so51369633pfd.0
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 16:08:01 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 1/2] Btrfs: refactor btrfs_extent_same() slightly
Date: Thu, 17 Nov 2016 16:07:49 -0800
Message-Id: <35c668f0a23e0424569f812523c76a1828219f76.1479427384.git.osandov@fb.com>
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

This just makes the following patch cleaner.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2c..e23f945 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3124,26 +3124,27 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	int ret;
 	u64 len = olen;
 	struct cmp_pages cmp;
-	int same_inode = 0;
+	bool same_inode = (src == dst);
 	u64 same_lock_start = 0;
 	u64 same_lock_len = 0;
 
-	if (src == dst)
-		same_inode = 1;
-
 	if (len == 0)
 		return 0;
 
-	if (same_inode) {
+	if (same_inode)
 		inode_lock(src);
+	else
+		btrfs_double_inode_lock(src, dst);
 
-		ret = extent_same_check_offsets(src, loff, &len, olen);
-		if (ret)
-			goto out_unlock;
-		ret = extent_same_check_offsets(src, dst_loff, &len, olen);
-		if (ret)
-			goto out_unlock;
+	ret = extent_same_check_offsets(src, loff, &len, olen);
+	if (ret)
+		goto out_unlock;
 
+	ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
+	if (ret)
+		goto out_unlock;
+
+	if (same_inode) {
 		/*
 		 * Single inode case wants the same checks, except we
 		 * don't want our length pushed out past i_size as
@@ -3171,16 +3172,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 
 		same_lock_start = min_t(u64, loff, dst_loff);
 		same_lock_len = max_t(u64, loff, dst_loff) + len - same_lock_start;
-	} else {
-		btrfs_double_inode_lock(src, dst);
-
-		ret = extent_same_check_offsets(src, loff, &len, olen);
-		if (ret)
-			goto out_unlock;
-
-		ret = extent_same_check_offsets(dst, dst_loff, &len, olen);
-		if (ret)
-			goto out_unlock;
 	}
 
 	/* don't make the dst file partly checksummed */
-- 
2.10.2

