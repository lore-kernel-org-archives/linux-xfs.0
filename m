Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UHXZFx013970 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 12:33:35 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8246C35DD1
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:34:10 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.35]) by
	cuda.sgi.com with ESMTP id CWP47bnvb4e0A695 for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:34:10 -0700 (PDT)
Received: from hpaq5.eem.corp.google.com (hpaq5.eem.corp.google.com
	[172.25.149.5]) by smtp-out.google.com with ESMTP id o7UHY8KE010522
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:34:08 -0700
Received: from gyb13 (gyb13.prod.google.com [10.243.49.77])
	by hpaq5.eem.corp.google.com with ESMTP id o7UHXaOE016174
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:34:06 -0700
Received: by gyb13 with SMTP id 13so2837363gyb.35
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 10:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C785710.9070405@sandeen.net>
References: <1282941224-5805-1-git-send-email-alal@google.com>
	<20100827233216.GJ705@dastard> <4C785254.2020708@sandeen.net>
	<20100828001703.GK705@dastard> <4C785710.9070405@sandeen.net>
From: Akshay Lal <akshaylal@google.com>
Date: Mon, 30 Aug 2010 10:33:34 -0700
Message-ID: <AANLkTi=6gw_H0GkimuLHexsfkp-pe-9k8WVXYCT9SYZ+@mail.gmail.com>
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset
	correctly.
Reply-To: alal@google.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

I reckon I've addressed all the concerns (yes even the comment mismatch)

---------------------------------------------------------------------------=
------------
Updated patch:
---------------------------------------------------------------------------=
------------
>From 6bf876f2b95e61409abbab24754c80354988bcc9 Mon Sep 17 00:00:00 2001
From: Akshay Lal <alal@google.com>
Date: Fri, 27 Aug 2010 13:14:18 -0700
Subject: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset correct=
ly.
 As found by Theodore Ts'o:
 If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
 write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
 This forces e2fsck to complain about that inode.

Bug reference:
http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
---
 243     |  177 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 243.out |   13 +++++
 group   |    1 +
 3 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 243
 create mode 100644 243.out

diff --git a/243 b/243
new file mode 100644
index 0000000..1a6c4a5
--- /dev/null
+++ b/243
@@ -0,0 +1,177 @@
+#! /bin/bash
+# FS QA Test No. 243
+#
+# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
+#
+# As found by Theodore Ts'o:
+# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
+# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
+# This is bad since it forces e2fsck to complain about that inode.
+# If you have a large number of inodes that are written with fallocate
+# using KEEP_SIZE, and then fill them up to their expected size,
+# e2fsck will potentially complain about a _huge_ number of inodes.
+# This would also cause a huge increase in the time taken by e2fsck
+# to complete its check.
+#
+# Test scenarios covered:
+# 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
+# 2. Fallocating X bytes and writing Y (Y=3DX) (buffered and direct io)
+# 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
+#
+# These test cases exercise the normal and edge case conditions using
+# falloc (and KEEP_SIZE).
+#
+# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Google, Inc.  All Rights Reserved.
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
+#
+# creator
+owner=3Dalal@google.com
+
+seq=3D`basename $0`
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# Test specific macros.
+BIT_NOT_SET=3D0   # inode flag - 0x400000 bit is not set.
+BIT_SET=3D1       # inode flag - 0x400000 bit is set.
+
+# Generic test cleanup function.
+_cleanup()
+{
+   cd /
+   rm -f $tmp.*
+}
+
+# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
+# enabled. The only time this bit should be set is when extending the allo=
cated
+# blocks further than what the i_size represents. In the situations wherei=
n the
+# i_size covers all allocated blocks, this bit should be cleared.
+
+# Checks the state of the sample file in the filesystem and returns whether
+# the inode flag 0x400000 is set or not.
+_check_ext4_eof_flag()
+{
+   bit_set=3D1
+
+   # Check whether EOFBLOCK_FL is set.
+   # For ext4 filesystems: use debugfs to check if EOFBLOCKS_FL is set.
+   # Other filesystems: do nothing. The default fsck at the end of the test
+   # should catch any potential errors.
+   if [ "${FSTYP}" =3D=3D "ext4" ]; then
+        # Unmount the ${TEST_DEV}
+        umount ${TEST_DEV}
+
+        # Run debugfs to gather file_parameters - specifically iflags.
+        file_params=3D`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -e F=
lags:`
+        iflags=3D${file_params#*Flags: }
+
+        # Ensure that the iflags value was parsed correctly.
+        if [ -z ${iflags} ]; then
+                echo "iFlags value was not parsed successfully." >> $seq.f=
ull
+                status=3D1
+                exit ${status}
+        fi
+
+        # Check if EOFBLOCKS_FL is set.
+        if ((${iflags} & 0x400000)); then
+                echo "EOFBLOCK_FL bit is set." >> $seq.full
+                bit_set=3D1
+        else
+                echo "EOFBLOCK_FL bit is not set." >> $seq.full
+                bit_set=3D0
+        fi
+
+        # Check current bit state to expected value.
+        if [ ${bit_set} -ne ${2} ]; then
+                echo "Error: Current bit state incorrect." >> $seq.full
+                status=3D1
+                exit ${status}
+        fi
+
+        # Mount the ${TEST_DEV}
+        mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
+}
+
+# Get standard environment, filters and checks.
+. ./common.rc
+. ./common.filter
+
+# Prerequisites for the test run.
+_supported_fs ext4 xfs btrfs gfs2
+_supported_os Linux
+_require_xfs_io_falloc
+
+# Real QA test starts here.
+rm -f $seq.full
+
+# Begin test cases.
+echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 4096'                    \
+  ${TEST_DIR}/test_1 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_1 ${BIT_SET}
+
+echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 4096'                    \
+  ${TEST_DIR}/test_2 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_2 ${BIT_SET}
+
+echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 40960'                   \
+  ${TEST_DIR}/test_3 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
+
+echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 40960'                   \
+  ${TEST_DIR}/test_4 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
+
+echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)."=
 \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 128k'                 \
+  -c 'pwrite 256k 4k'                   \
+  ${TEST_DIR}/test_5 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
+
+echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io=
)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 128k'                 \
+  -c 'pwrite 256k 4k'                   \
+  ${TEST_DIR}/test_6 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
+
+status=3D0
+exit ${status}
diff --git a/243.out b/243.out
new file mode 100644
index 0000000..290a005
--- /dev/null
+++ b/243.out
@@ -0,0 +1,13 @@
+QA output created by 243
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 40960/40960 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 40960/40960 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 4096/4096 bytes at offset 262144
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/group b/group
index ff16bb3..e6dab13 100644
--- a/group
+++ b/group
@@ -356,3 +356,4 @@ deprecated
 240 auto aio quick rw
 241 auto
 242 auto quick prealloc
+243 auto quick prealloc
-- =

1.7.1



---
Cheers!
Akshay Lal



On Fri, Aug 27, 2010 at 5:23 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Dave Chinner wrote:
>> On Fri, Aug 27, 2010 at 07:03:32PM -0500, Eric Sandeen wrote:
>>> Dave Chinner wrote:
>>>
>>>> I'm not sure this really is a generic test - it's testing an ext4
>>>> specific bug. We've got other generic tests that exercise fallocate,
>>>> and some filesystems (like XFS) don't have special bits to say there
>>>> are extents beyond EOF and checking a filesystem repeated won't
>>>> report any problems. =A0So perhaps if should be '_supported_fs ext4'
>>>
>>> Oops we're giving conflicting advice :) =A0I thought a test that
>>> exercises blocks-past-eof-filling at various boundaries made
>>> sense in general, even if the specific regression test is ext4-specific.
>>>
>>> Seems like at least ocfs2/btrfs might benefit from the basic exercise,
>>> so I was recommending that it be generic.
>>
>> Ok, that seems reasonable. If the bug results in filesystem
>> corruption, then maybe just relying on the check at the end of the
>> test to fail it would be appropriate?
>
> That's fine by me, if e2fsck will squawk, that's enough.
>
> -Eric
>
>> Cheers,
>>
>> Dave.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
