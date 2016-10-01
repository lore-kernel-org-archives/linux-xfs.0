Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbcJAPtE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Oct 2016 11:49:04 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] fstests: fix failures caused by striped device
Date: Sat,  1 Oct 2016 23:48:54 +0800
Message-Id: <1475336934-19105-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

There're some failures if scratch_dev is a  striped device:
  1. generic/094 and generic/225 fiemap_tester fails.
  2. generic/347 need -f to force usage of a misaligned device
  3. xfs/010, xfs/013, xfs/042 and xfs/109 print "Warning: AG size
     is a multiple of stripe width", break the golden image
  4. xfs/029 print more "extended-header"

Only XFS can reproduce these failures, so this patch:
  1. use "-d sunit=0,swidth=0,noalign" options for generic/094,
     generic/225 and xfs/029.
  2. print the error output of mkfs.xfs to /dev/null forr xfs/010,
     xfs/013, xfs/042 and xfs/109
  3. add -f option for generic/347

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This problem has been bothering me for a long time. Everytime when I
test on a machine with striped RAID device, I'll hit these problems.
Generally I'll ignore these failures, and run xfstests again on another
machine.

I know this patch is not the best way to deal with this problem, so I
just try to throw away a poor example in order to get some great ideas:)

Thanks,
Zorro

 tests/generic/094 | 3 +++
 tests/generic/225 | 3 +++
 tests/generic/347 | 2 +-
 tests/xfs/010     | 3 ++-
 tests/xfs/013     | 2 +-
 tests/xfs/029     | 2 +-
 tests/xfs/042     | 2 +-
 tests/xfs/109     | 3 ++-
 8 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tests/generic/094 b/tests/generic/094
index 005de1d..e83b062 100755
--- a/tests/generic/094
+++ b/tests/generic/094
@@ -48,6 +48,9 @@ _require_odirect
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "falloc"
 
+if [ "$FSTYP" = "xfs" ]; then
+	MKFS_OPTIONS="$MKFS_OPTIONS -d sunit=0,swidth=0,noalign"
+fi
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount > /dev/null 2>&1
 
diff --git a/tests/generic/225 b/tests/generic/225
index 5285e68..fec1a7a 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -47,6 +47,9 @@ _require_scratch
 _require_odirect
 _require_xfs_io_command "fiemap"
 
+if [ "$FSTYP" = "xfs" ]; then
+	MKFS_OPTIONS="$MKFS_OPTIONS -d sunit=0,swidth=0,noalign"
+fi
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount > /dev/null 2>&1
 
diff --git a/tests/generic/347 b/tests/generic/347
index 3adc674..054c778 100755
--- a/tests/generic/347
+++ b/tests/generic/347
@@ -43,7 +43,7 @@ _setup_thin()
 {
 	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
 	_dmthin_set_queue
-	_mkfs_dev $DMTHIN_VOL_DEV
+	_mkfs_dev -f $DMTHIN_VOL_DEV
 	_dmthin_mount
 }
 
diff --git a/tests/xfs/010 b/tests/xfs/010
index d350d64..d49a923 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -109,7 +109,8 @@ _require_xfs_finobt
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" | _filter_mkfs 2>$seqres.full
+_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" 2>/dev/null \
+				| _filter_mkfs 2>$seqres.full
 
 # sparsely populate the fs such that we create records with free inodes
 _scratch_mount
diff --git a/tests/xfs/013 b/tests/xfs/013
index 817558f..a00ebd6 100755
--- a/tests/xfs/013
+++ b/tests/xfs/013
@@ -105,7 +105,7 @@ _require_command "$KILLALL_PROG" killall
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" | \
+_scratch_mkfs_xfs "-m crc=1,finobt=1 -d agcount=2" 2>/dev/null | \
 	_filter_mkfs 2>> $seqres.full
 _scratch_mount
 
diff --git a/tests/xfs/029 b/tests/xfs/029
index 0709fce..01f4144 100755
--- a/tests/xfs/029
+++ b/tests/xfs/029
@@ -58,7 +58,7 @@ _supported_os Linux
 _require_scratch
 
 echo
-_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs -d sunit=0,swidth=0,noalign | _filter_mkfs 2>/dev/null
 
 echo
 _scratch_xfs_logprint | _filter_logprint
diff --git a/tests/xfs/042 b/tests/xfs/042
index ba5eed3..66bcc35 100755
--- a/tests/xfs/042
+++ b/tests/xfs/042
@@ -74,7 +74,7 @@ rm -f $seqres.full
 _do_die_on_error=message_only
 
 echo -n "Make a 48 megabyte filesystem on SCRATCH_DEV and mount... "
-_scratch_mkfs_xfs -dsize=48m,agcount=3 2>&1 >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_xfs -dsize=48m,agcount=3 >/dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed" 
 
 echo "done"
diff --git a/tests/xfs/109 b/tests/xfs/109
index ac20619..dd60492 100755
--- a/tests/xfs/109
+++ b/tests/xfs/109
@@ -103,7 +103,8 @@ if [ -n "$FASTSTART" -a -f $SCRATCH_MNT/f0 ]; then
 fi
 _scratch_unmount
 
-_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs_xfs -dsize=160m,agcount=4 $faststart 2>/dev/null \
+				| _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
 
-- 
2.7.4

