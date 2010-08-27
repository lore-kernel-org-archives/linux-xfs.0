Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7RNA5i3116301 for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 18:10:06 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5F821782931
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:10:40 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.35]) by
	cuda.sgi.com with ESMTP id iB3noD38E6LB2NCp for
	<xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:10:40 -0700 (PDT)
Received: from kpbe15.cbf.corp.google.com (kpbe15.cbf.corp.google.com
	[172.25.105.79]) by smtp-out.google.com with ESMTP id o7RNAdQQ021472
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:10:39 -0700
Received: from gxk2 (gxk2.prod.google.com [10.202.11.2])
	by kpbe15.cbf.corp.google.com with ESMTP id o7RNAbUB001055
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:10:37 -0700
Received: by gxk2 with SMTP id 2so1396968gxk.6
	for <xfs@oss.sgi.com>; Fri, 27 Aug 2010 16:10:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C783305.5060506@sandeen.net>
References: <1282941224-5805-1-git-send-email-alal@google.com>
	<4C783305.5060506@sandeen.net>
From: Akshay Lal <akshaylal@google.com>
Date: Fri, 27 Aug 2010 16:10:07 -0700
Message-ID: <AANLkTi=gRE8=oK2EW6u1LGGUnCEfcrSK7hnWc+mzA1dq@mail.gmail.com>
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

>> +# Test specific macros.
>> +BIT_NOT_SET=3D0 =A0 # inode flag - 0x40000 bit is set.
>> +BIT_SET=3D1 =A0 =A0 =A0 # inode flag - 0x400000 bit is not set.
>
> I'm thinking one of the values in the comment is not right :)
Duh. Thats silly of me.
Done.

>> +# Checks the state of the sample file in the filesystem and returns whe=
ther
>> +# the inode flag 0x400000 is set or not.
>
> I guess a little more comment here about why we do this only for ext4 mig=
ht
> be good.
>
> Just to make it more obvious in the main test could you maybe call
> it something like _check_ext4_eof_flag() ? =A0If we ever need to do
> testing on other filesystems we can adjust it.
Done.


>> + =A0 =A0 =A0 =A0if ((${iflags} & 0x400000)); then
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0echo "EOFBLOCK_FL bit is set."
>
> This will cause the test to fail on anything but ext4 because
> it's expected in the output but only happens for ext4...
>
> You could redirect it into $seq.full, just to have it for analysis
> if the test ever fails.
I've added an else condition to exit the test with the error message
that the test is only
supported on ext4 filesystems.
I've also redirected all echo messages to $seq.full


>> + =A0 =A0 =A0 =A0# Run fsck on the fs. fsck -t ${FSTYP} -fn ${TEST_DEV}.
>> + =A0 =A0 =A0 =A0_check_test_fs
>
> Ah now I see why you didn't call it _check_ext4_eof_flag() ;)
>
> This may not be necessary, the harness runs fsck after each
> test anyway. =A0On a large filesystem this could take a pretty
> long time if you run fsck 6 times. =A0I'd just drop
> this and let the post-test-fsck catch any problems.
Removed.

---------------------------------------------------------------------------=
------------
Updated patch:
---------------------------------------------------------------------------=
------------

>From f1e8df788e4b93ae33e01c48a859f2b21c425357 Mon Sep 17 00:00:00 2001
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
 243     |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 243.out |   13 +++++
 group   |    1 +
 3 files changed, 171 insertions(+), 0 deletions(-)
 create mode 100644 243
 create mode 100644 243.out

diff --git a/243 b/243
new file mode 100644
index 0000000..804513f
--- /dev/null
+++ b/243
@@ -0,0 +1,157 @@
+#! /bin/bash
+# FS QA Test No. 243
+#
+# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
+#
+# As found by Theodore Ts'o:
+# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
+# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
+# This forces e2fsck to complain about that inode.
+#
+# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
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
+BIT_NOT_SET=3D0   # inode flag - 0x40000 bit is not set.
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
+                exit ${status}
+        fi
+
+        # Mount the ${TEST_DEV}
+        mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
+   else
+     echo "Only EXT4 filesystems supported." >> $seq.full
+     status=3D1
+     exit ${status}
+  fi
+}
+
+# Get standard environment, filters and checks.
+. ./common.rc
+. ./common.filter
+
+# Prerequisites for the test run.
+_supported_fs generic
+_supported_os Linux
+_require_xfs_io_falloc
+
+# Real QA test starts here.
+rm -f $seq.full
+
+# Begin test cases.
+
+# Using FALLOC_FL_KEEP_SIZE
+# Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).
+echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 4096'                    \
+  ${TEST_DIR}/test_1 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_1 ${BIT_SET}
+
+# Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io).
+echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 4096'                    \
+  ${TEST_DIR}/test_2 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_2 ${BIT_SET}
+
+# Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io).
+echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 40960'                   \
+  ${TEST_DIR}/test_3 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
+
+# Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io).
+echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 40960'                \
+  -c 'pwrite 0 40960'                   \
+  ${TEST_DIR}/test_4 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
+
+# Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io).
+echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)."=
 \
+    >> $seq.full
+${XFS_IO_PROG} -F -f                    \
+  -c 'falloc -k 0 128k'                 \
+  -c 'pwrite 256k 4k'                   \
+  ${TEST_DIR}/test_5 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
+
+# Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io).
+echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io=
)." \
+    >> $seq.full
+${XFS_IO_PROG} -F -f -d                 \
+  -c 'falloc -k 0 128k'                 \
+  -c 'pwrite 256k 4k'                   \
+  ${TEST_DIR}/test_6 | _filter_xfs_io_unique
+_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
+
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
