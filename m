Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NEFQkL107465 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 09:15:26 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Add test 257: Check proper FITRIM argument handling
Date: Fri, 23 Sep 2011 16:15:11 +0200
Message-Id: <1316787311-23428-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

This test suppose to validate that file systems are using the fitrim
arguments right. It checks that the fstrim returns EINVAl in case that
the start of the range is beyond the end of the file system, and also
that the fstrim works without an error if the length of the range is
bigger than the file system (it should be truncated to the file system
length automatically within the fitrim implementation).

This test should also catch common problem with overflow of start+len.
Some file systems (ext4,xfs) had overflow problems in the past so there
is a specific test for it (for ext4 and xfs) as well as generic test for
other file systems, but it would be nice if other fs can add their
specific checks if this problem does apply to them as well.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: add check for fsblock to agno overflow
v3: Update comments, use bc math

 257     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 257.out |   14 +++++
 group   |    1 +
 3 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100755 257
 create mode 100644 257.out

diff --git a/257 b/257
new file mode 100755
index 0000000..4c820fd
--- /dev/null
+++ b/257
@@ -0,0 +1,183 @@
+#!/bin/bash
+# FS QA Test No. 251
+#
+# This test was created in order to verify filesystem FITRIM implementation.
+# By many concurrent copy and remove operations and checking that files
+# does not change after copied into SCRATCH_MNT test if FITRIM implementation
+# corrupts the filesystem (data/metadata).
+#
+#-----------------------------------------------------------------------
+# Copyright 2010 (C) Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+owner=lczerner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=`mktemp -d`
+status=0
+trap "exit \$status" 0 1 3
+trap "exit \$status" 2 15
+chpid=0
+mypid=$$
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+FSTRIM="$here/src/fstrim"
+"$FSTRIM" -l 10M $SCRATCH_MNT &> /dev/null || _notrun "FSTRIM is not supported"
+
+fssize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
+
+# All these tests should return EINVAL
+# since the start is beyond the end of
+# the file system
+
+echo "[+] Start beyond the end of fs (should fail)"
+"$FSTRIM" -s$(_math "$fssize*2048") $SCRATCH_MNT
+[ $? -eq 0 ] && status=1
+
+echo "[+] Start beyond the end of fs with len set (should fail)"
+"$FSTRIM" -s$(_math "$fssize*2048") -l1M $SCRATCH_MNT
+[ $? -eq 0 ] && status=1
+
+echo "[+] Start = 2^64-1 (should fail)"
+"$FSTRIM" -s18446744073709551615 $SCRATCH_MNT
+[ $? -eq 0 ] && status=1
+
+echo "[+] Start = 2^64-1 and len is set (should fail)"
+"$FSTRIM" -s18446744073709551615 -l1M $SCRATCH_MNT
+[ $? -eq 0 ] && status=1
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# All these tests should succeed
+# since the length should be truncated
+
+echo "[+] Default length (should succeed)"
+"$FSTRIM" $SCRATCH_MNT
+[ $? -ne 0 ] && status=1
+echo "[+] Default length with start set (should succeed)"
+"$FSTRIM" -s10M $SCRATCH_MNT
+[ $? -ne 0 ] && status=1
+echo "[+] Length beyond the end of fs (should succeed)"
+"$FSTRIM" -l$(_math "fssize*2048") $SCRATCH_MNT
+[ $? -ne 0 ] && status=1
+echo "[+] Length beyond the end of fs with start set (should succeed)"
+"$FSTRIM" -s10M -l$(_math "fssize*2048") $SCRATCH_MNT
+[ $? -ne 0 ] && status=1
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# This is a bit fuzzy, but since the file system is fresh
+# there should be at least (fssize/2) free space to trim.
+# This is supposed to catch wrong FITRIM argument handling
+out=$("$FSTRIM" -v -s10M $SCRATCH_MNT)
+bytes=${out%% *}
+
+if [ $bytes -gt $(_math "$fssize*1024") ]; then
+	status=1
+	echo "After the full fs discard $bytes bytes were discarded"\
+	     "however the file system is $(_math "$fssize*1024") bytes long."
+fi
+
+# Btrfs is special and this test does not apply to it
+# It is because btrfs does not have not-yet-used parts of the device
+# mapped and since we got here right after the mkfs, there is not
+# enough free extents in the root tree.
+if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
+	status=1
+	echo "After the full fs discard $bytes bytes were discarded"\
+	     "however the file system is $(_math "$fssize*1024") bytes long."
+fi
+
+# Now to catch overflows due to fsblk->allocation group number conversion
+# This is different for every file system and it also apply just to some of
+# them. In order to add check specific for file system you're interested in
+# compute the arguments as you need and make the file system with proper
+# alignment in function _check_conversion_overflow()
+
+# (2^32-1) + 2 (this is set to overflow 32bit variable by 2)
+base=$(_math "4294967295+2")
+
+case $FSTYP in
+	ext[34])
+		agsize=32768
+		bsize=4096
+		start=$(_math "$base*$agsize*$bsize")
+		len=$(_math "$base*$agsize*$bsize")
+		export MKFS_OPTIONS="-F -b $bsize -g $agsize"
+		;;
+	xfs)
+		agsize=65538
+		bsize=4096
+		start=$(_math "$base*$agsize*$bsize")
+		len=$(_math "$base*$agsize*$bsize")
+		export MKFS_OPTIONS="-f -d agsize=$(_math "$agsize*$bsize") -b size=$bsize"
+		;;
+	*)
+		# (2^32-1) * 4096 * 65536 == 32bit max size * block size * ag size
+		start="1152921504875282432"
+		len="1152921504875282432"
+		;;
+esac
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+# It should fail since $start is beyond the end of file system
+"$FSTRIM" -s$start -l$(_math "$fssize/2") $SCRATCH_MNT &> /dev/null
+if [ $? -eq 0 ]; then
+	status=1
+	echo "It seems that fs logic handling start"\
+	     "argument overflows"
+fi
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# len should be big enough to cover the whole file system, however this
+# test suppose for the overflow, so if the number of discarded bytes is
+# smaller than fssize/2 than it most likely does overflow.
+out=$("$FSTRIM" -v -l$len $SCRATCH_MNT)
+bytes=${out%% *}
+
+# Btrfs is special and this test does not apply to it
+# It is because btrfs does not have not-yet-used parts of the device
+# mapped and since we got here right after the mkfs, there is not
+# enough free extents in the root tree.
+if [ $bytes -le $(_math "$fssize*512") ] && [ $FSTYP != "btrfs" ]; then
+	status=1
+	echo "It seems that fs logic handling len argument overflows"
+fi
+
+echo "Test done"
+exit
diff --git a/257.out b/257.out
new file mode 100644
index 0000000..5dac8ac
--- /dev/null
+++ b/257.out
@@ -0,0 +1,14 @@
+QA output created by 257
+[+] Start beyond the end of fs (should fail)
+fstrim: FSTRIM: Invalid argument
+[+] Start beyond the end of fs with len set (should fail)
+fstrim: FSTRIM: Invalid argument
+[+] Start = 2^64-1 (should fail)
+fstrim: FSTRIM: Invalid argument
+[+] Start = 2^64-1 and len is set (should fail)
+fstrim: FSTRIM: Invalid argument
+[+] Default length (should succeed)
+[+] Default length with start set (should succeed)
+[+] Length beyond the end of fs (should succeed)
+[+] Length beyond the end of fs with start set (should succeed)
+Test done
diff --git a/group b/group
index 0c746c8..b742f91 100644
--- a/group
+++ b/group
@@ -370,3 +370,4 @@ deprecated
 254 auto quick
 255 auto quick prealloc
 256 auto quick
+257 auto quick trim
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
