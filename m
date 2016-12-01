Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbcLAKUs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 05:20:48 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA9096A6D0
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2016 10:20:38 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs: use xfs_vn_setattr_size to check on new size
Date: Thu,  1 Dec 2016 18:18:00 +0800
Message-Id: <20161201101800.11419-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

Commit 6552321831dc ("xfs: remove i_iolock and use i_rwsem in the
VFS inode instead") introduced a regression that truncate(2) doesn't
check on new size, so it succeeds even if the new size exceeds the
current resource limit. Because xfs_setattr_size() was used instead
of xfs_vn_setattr_size(), and the latter calls xfs_vn_change_ok()
first to do sanity check on permission and new size.

This is found by truncate03 test from ltp, and the following is a
simplified reproducer:

  #!/bin/bash
  dev=/dev/sda5
  mnt=/mnt/xfs

  mkfs -t xfs -f $dev
  mount $dev $mnt

  # set max file size to 16k
  ulimit -f 16
  truncate -s $((16 * 1024 + 1)) /mnt/xfs/testfile
  [ $? -eq 0 ] && echo "FAIL: truncate exceeded max file size"
  ulimit -f unlimited
  umount $mnt

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c962999..b930be0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -988,7 +988,7 @@ xfs_vn_setattr(
 			return error;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-		error = xfs_setattr_size(ip, iattr);
+		error = xfs_vn_setattr_size(dentry, iattr);
 		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	} else {
 		error = xfs_vn_setattr_nonsize(dentry, iattr);
-- 
2.9.3

