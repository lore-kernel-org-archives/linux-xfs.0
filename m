Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5KLXitS137805 for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 16:33:45 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F7671493079
	for <xfs@oss.sgi.com>; Sat, 20 Jun 2009 14:42:15 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id HWJkgKfLxUKV8prm for
	<xfs@oss.sgi.com>; Sat, 20 Jun 2009 14:42:15 -0700 (PDT)
Message-ID: <4A3D55C3.6020902@sandeen.net>
Date: Sat, 20 Jun 2009 16:33:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfstests: basic fallocate boundary tests
References: <4A370C2C.6030404@sandeen.net>
	<20090620175824.GA3984@infradead.org>
In-Reply-To: <20090620175824.GA3984@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:

> On Mon, Jun 15, 2009 at 10:06:20PM -0500, Eric Sandeen wrote:
>   
>> This is just like test 072, but using fallocate instead
>> of the xfs ioctl.  Just very basic fallocate tests.
>>
>> Also adds a "prealloc" group (./check -g prealloc)
>>     
>
> Looks good to me, and does the right thing on my 32 bit test VM (notrun)
>
>   
>> +echo $testio | grep -q "not found" && \
>> +	_notrun "xfs_io fallocate support is missing"
>> +echo $testio | grep -q "Operation not supported" && \
>> +	_notrun "xfs_io fallocate command failed (old kernel? wrong fs?)"
>>     
>
> Maybe add a _require_fallocate as you need the same check in the next
> testcase?
>   
hmm this is really testing that xfs_io in particular has fallocate...
so maybe like this?

diff --git a/common.rc b/common.rc
index 39350b3..55aecd6 100644
--- a/common.rc
+++ b/common.rc
@@ -704,6 +704,18 @@ _require_user()
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 
+# check that xfs_io, glibc, kernel, and filesystem all (!) support
+# fallocate
+#
+_require_xfs_io_falloc()
+	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
+	rm -f $TEST_DIR/$tmp.io 2>&1 > /dev/null
+	echo $testio | grep -q "not found" && \
+		_notrun "xfs_io fallocate support is missing"
+	echo $testio | grep -q "Operation not supported" && \
+		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
diff --git a/213 b/213
new file mode 100755
index 0000000..3cd55f7
--- /dev/null
+++ b/213
@@ -0,0 +1,84 @@
+#! /bin/sh
+# FS QA Test No. 213
+#
+# Check some unwritten extent boundary conditions, fallocate version.
+#
+# Based on xfs-specific test 072
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2009 Red Hat, Inc. All Rights Reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+here=`pwd`
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+# generic, but xfs_io's fallocate must work
+_supported_fs generic
+# only Linux supports fallocate
+_supported_os Linux
+
+[ -n "$XFS_IO_PROG" ] || _notrun "xfs_io executable not found"
+
+rm -f $seq.full
+
+_require_xfs_io_falloc
+
+# check there's enough freespace on $TEST_DIR ... (1GiB + 1MiB)
+avail=`df -P $TEST_DIR | awk 'END {print $4}'`
+[ "$avail" -ge 1049600 ] || _notrun "Test device is too small ($avail KiB)"
+
+echo Silence is golden
+
+# reserve 1GiB, truncate at 100bytes
+$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 100' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# reserve 1GiB, truncate at 1GiB
+$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 1g' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# reserve 1GiB, truncate at 2GiB
+$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 2g' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# reserve 1GiB, 1GiB hole, reserve 1MiB, truncate at 3GiB
+$XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'falloc 2g 1m' -c 'truncate 3g' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# success, all done
+status=0
+exit
diff --git a/group b/group
index 1268ddd..578fa05 100644
--- a/group
+++ b/group
@@ -101,6 +101,10 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 # test access time
 atime
 
+# Test preallocation calls
+prealloc
+
+#
 # test-group association ... one line per test
 #
 001 rw dir udf auto quick
@@ -111,7 +115,7 @@ atime
 006 dir udf auto quick
 007 dir udf auto quick
 008 rw ioctl auto quick
-009 rw ioctl auto quick
+009 rw ioctl auto prealloc quick
 010 other udf auto
 011 dir udf auto quick
 012 rw auto quick
@@ -174,7 +178,7 @@ atime
 069 rw udf auto quick
 070 attr udf auto quick
 071 rw
-072 rw auto quick
+072 rw auto prealloc quick
 073 copy auto
 074 rw udf auto
 075 rw udf auto quick
@@ -206,7 +210,7 @@ atime
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
-104 growfs ioctl
+104 growfs ioctl prealloc
 105 acl auto quick
 106 quota
 107 quota
@@ -266,8 +270,8 @@ atime
 161 dmapi auto
 162 dmapi auto
 163 dmapi auto
-164 rw pattern auto quick
-165 rw pattern auto quick
+164 rw pattern auto prealloc quick
+165 rw pattern auto prealloc quick
 166 rw metadata auto quick
 167 rw metadata auto
 168 dmapi auto
@@ -317,3 +321,4 @@ atime
 210 auto aio quick
 211 auto aio quick
 212 auto aio quick
+213 rw auto prealloc quick



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
