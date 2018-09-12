Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56010 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeILQIN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:08:13 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs/119: fix too small log size error
Date: Wed, 12 Sep 2018 19:04:04 +0800
Message-Id: <20180912110404.32673-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

xfs/119 fails on 4k hard sector size device if reflink (with/without
rmapbt) is enabled:

  # mkfs.xfs -f -m reflink=1,rmapbt=0 -l version=2,size=2560b,su=64k /dev/sdf
  log size 2560 blocks too small, minimum size is 2688 blocks
  # mkfs.xfs -f -m reflink=1,rmapbt=1 -l version=2,size=2560b,su=64k /dev/sdf
  log size 2560 blocks too small, minimum size is 4368 blocks

So remove log size parameter and run mkfs.xfs again if it fails.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

I saw Dave changed the log size once in commit:
  d0a3cc5a xfs/104: log size too small for 4k sector drives

But it's still not enough after we have reflink feature now. I don't
know why this case need "-l version=2,size=2560b,su=64k",
if someone learns about this case, please tell me how to change this
case properly. If the log size parameter is not necessary, I'd like
to remove it.

Thanks,
Zorro

 tests/xfs/119 | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/119 b/tests/xfs/119
index bf7f1ca8..d507aacf 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -40,7 +40,14 @@ sync
 
 export MKFS_OPTIONS="-l version=2,size=2560b,su=64k" 
 export MOUNT_OPTIONS="-o logbsize=64k"
-_scratch_mkfs_xfs >/dev/null
+_scratch_mkfs_xfs >/dev/null 2>&1
+# The specified log size maybe too small if new features (e.g: reflink
+# or/and rmapbt) is enabled. So if mkfs fails, don't specify log size
+# and try to mkfs again.
+if [ $? -ne 0 ]; then
+	export MKFS_OPTIONS="-l version=2,su=64k"
+	_scratch_mkfs_xfs >/dev/null
+fi
 
 _scratch_mount
 
-- 
2.14.4
