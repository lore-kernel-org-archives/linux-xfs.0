Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33176 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdGUEkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:11 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 03/15] tests: port xfs/095 to Linux
Date: Thu, 20 Jul 2017 21:38:41 -0700
Message-Id: <20170721043853.364-4-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

This tests upgrading the XFS log to v2.  Switch from the IRIX xfs_chver
program to xfs_db.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/xfs/095     | 11 +++++------
 tests/xfs/095.out |  3 +--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/tests/xfs/095 b/tests/xfs/095
index d1373586..1f5a51f6 100755
--- a/tests/xfs/095
+++ b/tests/xfs/095
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 095
 #
-# test out xfs_chver on IRIX
+# Test upgrading the XFS log to v2
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
@@ -46,7 +46,7 @@ _cleanup()
 
 # Modify as appropriate.
 _supported_fs xfs
-_supported_os IRIX
+_supported_os Linux
 _require_scratch
 _require_v2log
 
@@ -54,14 +54,13 @@ export MOUNT_OPTIONS="-o logbsize=64k"
 
 # try and mount a v1 log with a v2 LRsize
 # expect failure
-_mkfs_log "-l version=1"
+_mkfs_log "-l version=1 -m crc=0 -d sectsize=512"
+_scratch_xfs_db -c 'version' | tr ',' '\n' | grep LOGV2
 _create_log
 
 # now make the fs a v2 fs and try to mount again
 # it should succeed this time
-xfs_chver -l 2 $SCRATCH_DEV | \
-sed -e "s#$SCRATCH_DEV#SCRATCH_DEV#g" \
-    -e 's/[0-9][0-9]* AGs/N AGs/'
+_scratch_xfs_db -x -c 'version log2' | tr ',' '\n' | grep LOGV2
 _create_log
 
 # success, all done
diff --git a/tests/xfs/095.out b/tests/xfs/095.out
index 36ffdecc..378876d8 100644
--- a/tests/xfs/095.out
+++ b/tests/xfs/095.out
@@ -2,5 +2,4 @@ QA output created by 095
 
 *** mount failed: -o logbsize=64k ***
 
-xfs_chver: SCRATCH_DEV: changing version 0x3084 to 0x3484 in N AGs
-xfs_chver: SCRATCH_DEV: changing feature2 0x0 to 0x0 in N AGs
+LOGV2
-- 
2.13.3

