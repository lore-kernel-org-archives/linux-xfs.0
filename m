Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:37616 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725854AbfFSHjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jun 2019 03:39:45 -0400
From: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Subject: [PATCH v3] xfs/191: update mkfs.xfs input results
Date: Wed, 19 Jun 2019 15:39:23 +0800
Message-ID: <1560929963-2372-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
In-Reply-To: <20190616143956.GC15846@desktop>
References: <20190616143956.GC15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Yang Xu <xuyang2018.jy@cn.fujitsu.com>

Currently, on 5.2.0-rc4+ kernel, when I run xfs/191 with upstream
xfsprogs, I get the following errors because mkfs.xfs binary has
changed a lot.

-------------------------
pass -n size=2b /dev/sda11
pass -d agsize=8192b /dev/sda11
pass -d agsize=65536s /dev/sda11
pass -d su=0,sw=64 /dev/sda11
pass -d su=4096s,sw=64 /dev/sda11
pass -d su=4096b,sw=64 /dev/sda11
pass -l su=10b /dev/sda11
fail -n log=15 /dev/sda11
fail -r size=65536,rtdev=$fsimg /dev/sda11
fail -r rtdev=$fsimg /dev/sda11
fail -i log=10 /dev/sda11
--------------------------

"pass -d su=0,sw=64 /dev/sda11", expect fail, this behavior has been
fixed by commit 16adcb88(mkfs: more sunit/swidth sanity checking).

"fail -n log=15 /dev/sda11" "fail -i log=10 /dev/sda11", expect pass,
this option has been removed since commit 2cf637c(mkfs: remove
logarithm based CLI option).

"fail -r size=65536,rtdev=$fsimg /dev/sda11" "fail -r rtdev=$fsimg
/dev/sda11" works well if we disable reflink, fail if we enable
reflink. It fails because reflink was not supported in realtime
devices since commit bfa66ec.

"b" or "s" suffix without specifying their size has been supported 
since xfsprogs v4.15.0-rc1.

I change the expected result for compatibility with current xfsprogs
and add rtdev test with reflink.

Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
---
 tests/xfs/191-input-validation | 39 ++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
index b6658015..9f8de500 100755
--- a/tests/xfs/191-input-validation
+++ b/tests/xfs/191-input-validation
@@ -31,11 +31,10 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 _require_xfs_mkfs_validation
 
 
-
 rm -f $seqres.full
 echo silence is golden
 
@@ -112,10 +111,11 @@ do_mkfs_fail -b size=2b $SCRATCH_DEV
 do_mkfs_fail -b size=nfi $SCRATCH_DEV
 do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
 do_mkfs_fail -n size=2s $SCRATCH_DEV
-do_mkfs_fail -n size=2b $SCRATCH_DEV
 do_mkfs_fail -n size=nfi $SCRATCH_DEV
 do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
 
+do_mkfs_pass -n size=2b $SCRATCH_DEV
+
 # bad label length
 do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
 
@@ -129,6 +129,8 @@ do_mkfs_pass -d agsize=32M $SCRATCH_DEV
 do_mkfs_pass -d agsize=1g $SCRATCH_DEV
 do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
 do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
+do_mkfs_pass -d agsize=8192b $SCRATCH_DEV
+do_mkfs_pass -d agsize=65536s $SCRATCH_DEV
 do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
 do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
 do_mkfs_pass -d noalign $SCRATCH_DEV
@@ -136,7 +138,10 @@ do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
 do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
 do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
 do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
+do_mkfs_pass -d su=0,sw=64 $SCRATCH_DEV
 do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
+do_mkfs_pass -d su=4096s,sw=64 $SCRATCH_DEV
+do_mkfs_pass -d su=4096b,sw=64 $SCRATCH_DEV
 do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
 do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
 do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
@@ -147,8 +152,6 @@ do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
 do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
 do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
 do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
-do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
-do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
 do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
 do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
 do_mkfs_fail -d agcount=1k $SCRATCH_DEV
@@ -159,13 +162,10 @@ do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
 do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
 do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
 do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
-do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
 do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
 do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
 do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
 do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
-do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
-do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
 do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
 do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
 do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
@@ -206,6 +206,7 @@ do_mkfs_pass -l sunit=64 $SCRATCH_DEV
 do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
 do_mkfs_pass -l sunit=8 $SCRATCH_DEV
 do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
+do_mkfs_pass -l su=10b $SCRATCH_DEV
 do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
 do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
 do_mkfs_pass -l internal $SCRATCH_DEV
@@ -228,7 +229,6 @@ do_mkfs_fail -l agnum=32 $SCRATCH_DEV
 do_mkfs_fail -l sunit=0  $SCRATCH_DEV
 do_mkfs_fail -l sunit=63 $SCRATCH_DEV
 do_mkfs_fail -l su=1 $SCRATCH_DEV
-do_mkfs_fail -l su=10b $SCRATCH_DEV
 do_mkfs_fail -l su=10s $SCRATCH_DEV
 do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
 do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
@@ -246,7 +246,6 @@ do_mkfs_fail -l version=0  $SCRATCH_DEV
 
 # naming section, should pass
 do_mkfs_pass -n size=65536 $SCRATCH_DEV
-do_mkfs_pass -n log=15 $SCRATCH_DEV
 do_mkfs_pass -n version=2 $SCRATCH_DEV
 do_mkfs_pass -n version=ci $SCRATCH_DEV
 do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
@@ -257,6 +256,7 @@ do_mkfs_fail -n version=1 $SCRATCH_DEV
 do_mkfs_fail -n version=cid $SCRATCH_DEV
 do_mkfs_fail -n ftype=4 $SCRATCH_DEV
 do_mkfs_fail -n ftype=0 $SCRATCH_DEV
+do_mkfs_fail -n log=15 $SCRATCH_DEV
 
 reset_fsimg
 
@@ -273,14 +273,24 @@ do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
 do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
 
 
+# realtime section, results depend on reflink
+_scratch_mkfs_xfs_supported -m reflink=0 >/dev/null 2>&1
+if [ $? -eq 0 ]; then
+	do_mkfs_pass -m reflink=0 -r rtdev=$fsimg $SCRATCH_DEV
+	do_mkfs_pass -m reflink=0 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
+	do_mkfs_fail -m reflink=1 -r rtdev=$fsimg $SCRATCH_DEV
+	do_mkfs_fail -m reflink=1 -r size=65536,rtdev=$fsimg $SCRATCH_DEV
+else
+	do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
+	do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
+fi
+
+
 # realtime section, should pass
-do_mkfs_pass -r rtdev=$fsimg $SCRATCH_DEV
 do_mkfs_pass -r extsize=4k $SCRATCH_DEV
 do_mkfs_pass -r extsize=1G $SCRATCH_DEV
-do_mkfs_pass -r size=65536,rtdev=$fsimg $SCRATCH_DEV
 do_mkfs_pass -r noalign $SCRATCH_DEV
 
-
 # realtime section, should fail
 do_mkfs_fail -r rtdev=$SCRATCH_DEV
 do_mkfs_fail -r extsize=256 $SCRATCH_DEV
@@ -293,7 +303,6 @@ do_mkfs_fail -r size=65536 $SCRATCH_DEV
 do_mkfs_pass -i size=256 -m crc=0 $SCRATCH_DEV
 do_mkfs_pass -i size=512 $SCRATCH_DEV
 do_mkfs_pass -i size=2048 $SCRATCH_DEV
-do_mkfs_pass -i log=10 $SCRATCH_DEV
 do_mkfs_pass -i perblock=2 $SCRATCH_DEV
 do_mkfs_pass -i maxpct=10 $SCRATCH_DEV
 do_mkfs_pass -i maxpct=100 $SCRATCH_DEV
@@ -317,6 +326,8 @@ do_mkfs_fail -i align=2 $SCRATCH_DEV
 do_mkfs_fail -i sparse -m crc=0 $SCRATCH_DEV
 do_mkfs_fail -i align=0 -m crc=1 $SCRATCH_DEV
 do_mkfs_fail -i attr=1 -m crc=1 $SCRATCH_DEV
+do_mkfs_fail -i log=10 $SCRATCH_DEV
+
 
 status=0
 exit
-- 
2.18.1
