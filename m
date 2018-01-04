Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbeADFqe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 00:46:34 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/015: enlarge the initial fs size
Date: Thu,  4 Jan 2018 13:46:26 +0800
Message-Id: <20180104054626.14458-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Kernel commit f59cf5c29919 ("xfs: remove "no-allocation"
reservations for file creations") is known to cause earlier ENOSPC
conditions, and xfs/015 is affected in the way that no new file/dir
can be created in a newly created 16M XFS with both reflink and
rmapbt enabled, thus xfs/015 fails due to the missing test dirs.

So enlarge the initial fs size to 32M that we're able to create new
dir/file before growing the filesystem size.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/015 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/015 b/tests/xfs/015
index 2c57f7882308..4939bb92f6fc 100755
--- a/tests/xfs/015
+++ b/tests/xfs/015
@@ -66,15 +66,15 @@ _supported_os Linux
 
 _require_scratch
 
-# need 64M space, don't make any assumption
+# need 128M space, don't make any assumption
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
-_require_fs_space $SCRATCH_MNT 65536
+_require_fs_space $SCRATCH_MNT 131072
 _scratch_unmount
 
 rm -f $seqres.full
 
-_scratch_mkfs_sized $((16 * 1024 * 1024)) > $tmp.mkfs.raw
+_scratch_mkfs_sized $((32 * 1024 * 1024)) > $tmp.mkfs.raw
 cat $tmp.mkfs.raw | _filter_mkfs >$seqres.full 2>$tmp.mkfs
 # get original data blocks number and agcount
 . $tmp.mkfs
-- 
2.14.3

