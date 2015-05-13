Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92F357F72
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 09:48:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CA9FAC003
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 07:48:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yc75WHo2SLSBbsF9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 07:48:50 -0700 (PDT)
Message-ID: <5553652F.3090900@oracle.com>
Date: Wed, 13 May 2015 17:52:31 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: log record crc mismatch test
References: <553E5505.4070804@oracle.com> <553E6723.8090909@sandeen.net>
In-Reply-To: <553E6723.8090909@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

Hi Eric,

On 04/27/2015 07:43 PM, Eric Sandeen wrote:
> On 4/27/15 10:25 AM, Alexander Tsvetkov wrote:
>> Added new test case for simulation of V5 filesystem
>> log crc record corruption using of external log.
>>
>> Signed-off-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
>> ---
>>   tests/xfs/005     | 28 ++++++++++++++++++++++++++--
>>   tests/xfs/005.out |  3 +++
>>   2 files changed, 29 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/xfs/005 b/tests/xfs/005
>> index fade4bb..ba0dcbb 100755
>> --- a/tests/xfs/005
>> +++ b/tests/xfs/005
>> @@ -1,7 +1,7 @@
>>   #! /bin/bash
>>   # FS QA Test No. 005
>>   #
>> -# Test that a bad crc on a primary V5 superblock will fail the mount
>> +# Test that a bad crc on a V5 filesystem will fail the mount
> bad crc on what?
>
>>   #
>>   # 10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
>>   # inadvertently caused primary SB CRC failures to not error out, this
>> @@ -55,10 +55,12 @@ _supported_os Linux
>>
>>   _require_scratch_nocheck
>>   _require_xfs_mkfs_crc
>> +_require_logdev
>> +logsize=2560
> No, this means that xfs/05 will no longer work without an external logdev,
> right?  So you've stopped testing the internal case, and we've lost that
> coverage.
>
> And, we generally don't want to add new testcases to old tests because then
> it gets harder to investigate regressions.  It'd probably be best to
> create a new test which specifically tests log crc corruption, and make
> it handle both internal and external logs automatically.
I've prepared the test with both cases, see at the bottom of this mail


> Thanks,
> -Eric
>
>>   rm -f $seqres.full
>>
>> -_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
>> +_scratch_mkfs_xfs -m crc=1 -lsize=${logsize}b >> $seqres.full 2>&1 || _fail "mkfs failed"
>>
>>   # Zap the crc.  xfs_db updates the CRC post-write, so poke it directly
>>   $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
>> @@ -66,6 +68,28 @@ $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
>>   # should FAIL, the crc is bad; golden output contains mount failure
>>   _scratch_mount 2>&1 | filter_mount
>>
>> +_scratch_unmount &> /dev/null
>> +_scratch_mkfs_xfs -m crc=1 -lsize=${logsize}b  >> $seqres.full 2>&1 || _fail "mkfs failed"
>> +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
>> +
>> +# Run filesytem exercising for some time
>> +_param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
>> +$FSSTRESS_PROG $_param -s 1 $FSSTRESS_AVOID -n 1000 -d $SCRATCH_MNT &> /dev/null
>> +sleep 3
>> +
>> +# Shutdown filesystem and unmount
>> +src/godown -v $SCRATCH_MNT >> $seqres.full
>> +killall -q fsstress
>> +wait
>> +sleep 3
>> +_scratch_unmount
>> +
>> +# Zap log record crc.
>> +$XFS_IO_PROG -c "pwrite 5000 5" $SCRATCH_LOGDEV | _filter_xfs_io
>> +
>> +# should FAIL, log record crc is bad; golden output contains mount failure
>> +_scratch_mount 2>&1 | filter_mount
>> +
>>   # success, all done
>>   status=0
>>   exit
>> diff --git a/tests/xfs/005.out b/tests/xfs/005.out
>> index 13d0125..8907301 100644
>> --- a/tests/xfs/005.out
>> +++ b/tests/xfs/005.out
>> @@ -2,3 +2,6 @@ QA output created by 005
>>   wrote 4/4 bytes at offset 224
>>   XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>   mount: Structure needs cleaning
>> +wrote 5/5 bytes at offset 5000
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +mount: Structure needs cleaning
Added new test for simulation of V5 filesystem
log crc record corruption in internal and external logs

Signed-off-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
---
  tests/xfs/306     | 110 
++++++++++++++++++++++++++++++++++++++++++++++++++++++
  tests/xfs/306.out |   7 ++++
  tests/xfs/group   |   1 +
  3 files changed, 118 insertions(+)
  create mode 100755 tests/xfs/306
  create mode 100644 tests/xfs/306.out

diff --git a/tests/xfs/306 b/tests/xfs/306
new file mode 100755
index 0000000..6e025fe
--- /dev/null
+++ b/tests/xfs/306
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 306
+#
+# Test that bad crc on a V5 log record will fail the mount
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+filter_mount()
+{
+    sed -e "s/mount .* failed: //"
+}
+
+filter_io()
+{
+    sed -e "s/at offset .*/at offset XXX/"
+}
+
+# $1 - log start offset
+# $2 - log device
+do_test()
+{
+    off=$1
+    dev=$2
+
+    _scratch_unmount >/dev/null 2>&1
+    _scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
+
+    # Run filesytem exercising for some time
+    param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
+    $FSSTRESS_PROG $param -s 1 $FSSTRESS_AVOID -n 1000 -d $SCRATCH_MNT 
&> /dev/null
+    sleep 3
+
+    # Shutdown filesystem and unmount
+    src/godown -v $SCRATCH_MNT >> $seqres.full
+    killall -q fsstress
+    wait
+    sleep 3
+    _scratch_unmount
+
+    # Zap log record crc
+    off=$((off + 5000))
+    $XFS_IO_PROG -c "pwrite $off 5" $dev | _filter_xfs_io | filter_io
+
+    # should FAIL, log record crc is bad; golden output contains mount 
failure
+    _scratch_mount 2>&1 | filter_mount
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch_nocheck
+_require_xfs_mkfs_crc
+_require_logdev
+
+rm -f $seqres.full
+fssize=$((32 * 1024 * 1024))
+MKFS_OPTIONS="-m crc=1 $MKFS_OPTIONS"
+_scratch_mkfs_sized $fssize 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > 
/dev/null
+. $tmp.mkfs
+
+# internal log corruption
+unset USE_EXTERNAL
+_scratch_mkfs_sized $fssize >> $seqres.full 2>&1 || _fail "mkfs failed"
+logstart=$($XFS_DB_PROG -c "sb 0" -c "print" $SCRATCH_DEV | grep 
logstart | cut -f3 -d' ')
+offset=$((logstart * lbsize))
+do_test $offset $SCRATCH_DEV
+
+# external log corruption
+USE_EXTERNAL="yes"
+_scratch_mkfs_sized $fssize >> $seqres.full 2>&1 || _fail "mkfs failed"
+do_test 0 $SCRATCH_LOGDEV
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/306.out b/tests/xfs/306.out
new file mode 100644
index 0000000..aef98f2
--- /dev/null
+++ b/tests/xfs/306.out
@@ -0,0 +1,7 @@
+QA output created by 306
+wrote 5/5 bytes at offset XXX
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+mount: Structure needs cleaning
+wrote 5/5 bytes at offset XXX
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+mount: Structure needs cleaning
diff --git a/tests/xfs/group b/tests/xfs/group
index 58144d2..f108377 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -191,3 +191,4 @@
  303 auto quick quota
  304 auto quick quota
  305 auto quota
+306 auto quick
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
