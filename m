Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:36433 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfAXIdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Jan 2019 03:33:20 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] common/dump: do not override test cleanup trap
Date: Thu, 24 Jan 2019 10:33:09 +0200
Message-Id: <20190124083310.25928-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Currently this doesn't matter for the two dump tests xfs/022 and xfs/068
because they do not have a _cleanup() routine and the override dump
_cleanup() routine does the generic cleanup as well.

Instead, call the _dump_cleanup explicitly from the trap in those tests.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dump   | 5 +----
 tests/xfs/022 | 2 +-
 tests/xfs/068 | 2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/common/dump b/common/dump
index 4d1a1607..47d14601 100644
--- a/common/dump
+++ b/common/dump
@@ -45,9 +45,6 @@ session_label="stress_$seq"
 nobody=4 # define this uid/gid as a number
 do_quota_check=true # do quota check if quotas enabled
 
-# install our cleaner
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
 # start inventory from a known base - move it aside for test
 for dir in /var/xfsdump/inventory /var/lib/xfsdump/inventory; do
     if [ -d $dir ]; then
@@ -227,7 +224,7 @@ _wipe_fs()
 # Cleanup created dirs and files
 # Called by trap
 #
-_cleanup()
+_dump_cleanup()
 {
     # Some tests include this before checking _supported_fs xfs
     # and the sleeps & checks here get annoying
diff --git a/tests/xfs/022 b/tests/xfs/022
index e1162798..f091b7c5 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -17,7 +17,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
+trap "_dump_cleanup; exit \$status" 0 1 2 3 15
 
 . ./common/rc
 . ./common/dump
diff --git a/tests/xfs/068 b/tests/xfs/068
index c755bc3e..95a8cd12 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -18,7 +18,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
+trap "_dump_cleanup; exit \$status" 0 1 2 3 15
 
 . ./common/rc
 . ./common/dump
-- 
2.17.1
