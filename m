Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726606AbeG2Pvh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 29 Jul 2018 11:51:37 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs/288: use -d option of xfs_db write command for v5 XFS
Date: Sun, 29 Jul 2018 22:20:53 +0800
Message-Id: <20180729142053.4240-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The commit b3cf8b72334fd35ef961869506e5a72ab398bc82 update xfs/288
to support v5 filesystem testing. That commit thought xfs_db write
command can work well with -d option on V5 XFS. But the truth is
the case doesn't use that option.

So turn to use _scratch_xfs_set_metadata_field, it will help to use
proper options for xfs_db write command.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

Missing '-d' option is a case issue. But from this issue, we found another
bug of xfsprogs. On current upstream, this case will test pass on v5 XFS,
even there's not '-d' option for write command.

That's a bug, we'll fix it later. For now, I'd like to fix this case
issue at first.

Thanks,
Zorro

 tests/xfs/288 | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/288 b/tests/xfs/288
index bccdb6fc..f4165b6c 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -56,9 +56,8 @@ $SETFATTR_PROG -n "user.testattr${seq}" \
 
 _scratch_unmount
 # manually corrupt the XFS, by set the header count of attr to 0
-_scratch_xfs_db -x -c "inode $inum" \
-		   -c "ablock 0" \
-		   -c "write hdr.count 0" >> $seqres.full
+_scratch_xfs_set_metadata_field "hdr.count" "0" \
+				"inode $inum" "ablock 0" >> $seqres.full
 
 # make sure xfs_repair can find above corruption. If it can't, that
 # means we need to fix this bug on current xfs_repair
-- 
2.14.4

