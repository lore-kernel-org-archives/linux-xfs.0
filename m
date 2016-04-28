Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC5297D21
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 03:29:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 543418F8037
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2016 01:29:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qf7P8nMt1ZFSGaO0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2016 01:29:12 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [RFC PATCH] xfstests: Add mkfs input validation tests
Date: Thu, 28 Apr 2016 10:29:09 +0200
Message-Id: <1461832149-18276-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

Test inputs for my mkfs-cleaning patchset. This test will fail with the old sphageti code mkfs, among others because the old code accepts incorrect values.



Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Tulak <jtulak@redhat.com>
---

Hi guys,

I'm sending this patch although the mentioned patchset is not yet merged.
It might help you a bit with checking if there are any issues with
the patchset, as here it is clear, what options works and what not.

But because this test fails with how mkfs currently validates values
(and some other things), maybe the merging of this patch should wait
for the patchset.

Cheers,
Jan

 tests/xfs/400-input-validation     | 226 +++++++++++++++++++++++++++++++++++++
 tests/xfs/400-input-validation.out |   2 +
 tests/xfs/group                    |   1 +
 3 files changed, 229 insertions(+)
 create mode 100755 tests/xfs/400-input-validation
 create mode 100644 tests/xfs/400-input-validation.out

diff --git a/tests/xfs/400-input-validation b/tests/xfs/400-input-validation
new file mode 100755
index 0000000..4ded2ef
--- /dev/null
+++ b/tests/xfs/400-input-validation
@@ -0,0 +1,226 @@
+#! /bin/bash
+# FS QA Test No. xfs/401
+#
+# mkfs.xfs input validation test. Designed to break mkfs.xfs if it doesn't
+# filter garbage input or invalid option combinations correctly.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+echo silence is golden
+
+# clear out any options to mkfs first. We want to test realtime and external log
+# devices if we can, but we also want to control them ourselves.
+logdev=$SCRATCH_LOGDEV
+rtdev=$SCRATCH_RTDEV
+
+MKFS_OPTIONS=
+SCRATCH_LOGDEV=
+SCRATCH_RTDEV=
+
+# limit the image size of the filesystem being created to something small
+fssize=$((4 * 1024 * 1024 * 1024))
+fsimg=$TEST_DIR/$seq.img
+
+do_mkfs_pass()
+{
+        echo >> $seqres.full
+        echo "pass expected $*" >> $seqres.full
+        $MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
+        [ $? -ne 0 ] && echo "fail $*"
+}
+
+do_mkfs_fail()
+{
+        echo >> $seqres.full
+        echo "fail expected $*" >> $seqres.full
+        $MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
+        [ $? -eq 0 ] && echo "pass $*"
+}
+
+do_mkfs_pass $SCRATCH_DEV
+
+# basic "should fail" options
+# logarithm based options are no longer valid
+# NOTE: umm, when it got invalid? It seems to be still supported...
+#do_mkfs_fail -s log=10 $SCRATCH_DEV
+#do_mkfs_fail -b log=10 $SCRATCH_DEV
+#do_mkfs_fail -n log=10 $SCRATCH_DEV
+#do_mkfs_fail -i log=10 $SCRATCH_DEV
+#do_mkfs_fail -d sectlog=10 $SCRATCH_DEV
+#do_mkfs_fail -l sectlog=10 $SCRATCH_DEV
+
+# specifying sector sizes in sectors or blocks or garbage
+do_mkfs_fail -s size=2s $SCRATCH_DEV
+do_mkfs_fail -d sectsize=2s $SCRATCH_DEV
+do_mkfs_fail -l sectsize=2s $SCRATCH_DEV
+do_mkfs_fail -s size=2b $SCRATCH_DEV
+do_mkfs_fail -d sectsize=2b $SCRATCH_DEV
+do_mkfs_fail -l sectsize=2b $SCRATCH_DEV
+
+do_mkfs_fail -s size=grot $SCRATCH_DEV
+do_mkfs_fail -s size=2yerk $SCRATCH_DEV
+do_mkfs_fail -d sectsize=blah $SCRATCH_DEV
+do_mkfs_fail -d sectsize=2foo $SCRATCH_DEV
+do_mkfs_fail -l sectsize=nggh $SCRATCH_DEV
+do_mkfs_fail -l sectsize=2nggh $SCRATCH_DEV
+
+# conflicting sector/block sizes
+do_mkfs_fail -s size=512 -d sectsize=1024 $SCRATCH_DEV
+do_mkfs_fail -s size=512 -l sectsize=1024 $SCRATCH_DEV
+do_mkfs_fail -d sectsize=2048 -l sectsize=1024 $SCRATCH_DEV
+
+do_mkfs_fail -b size=512 -s size=1024 $SCRATCH_DEV
+do_mkfs_fail -b size=512 -d sectsize=1024 $SCRATCH_DEV
+do_mkfs_fail -b size=512 -l sectsize=1024 $SCRATCH_DEV
+
+# specifying block sizes in sectors without specifying sector size
+# or in blocks or garbage
+do_mkfs_fail -b size=2s $SCRATCH_DEV
+do_mkfs_fail -b size=2b $SCRATCH_DEV
+do_mkfs_fail -b size=nfi $SCRATCH_DEV
+do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
+do_mkfs_fail -n size=2s $SCRATCH_DEV
+do_mkfs_fail -n size=2b $SCRATCH_DEV
+do_mkfs_fail -n size=nfi $SCRATCH_DEV
+do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
+
+# bad label length
+do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
+
+# basic "should pass" data section tests
+do_mkfs_pass $SCRATCH_DEV
+do_mkfs_pass -d name=$SCRATCH_DEV
+do_mkfs_pass -d size=$fssize $SCRATCH_DEV
+do_mkfs_pass -d agcount=32 $SCRATCH_DEV
+do_mkfs_pass -d agsize=32m $SCRATCH_DEV
+do_mkfs_pass -d agsize=32M $SCRATCH_DEV
+do_mkfs_pass -d agsize=1g $SCRATCH_DEV
+do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
+do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
+do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
+do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
+do_mkfs_pass -d noalign $SCRATCH_DEV
+do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
+do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
+do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
+do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
+do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
+do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
+do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
+do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
+do_mkfs_pass -d sectsize=512,su=8s,sw=8 $SCRATCH_DEV
+do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
+
+# invalid data section tests
+do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
+do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
+do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
+do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
+do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
+do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
+do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
+do_mkfs_fail -d agcount=1k $SCRATCH_DEV
+do_mkfs_fail -d agcount=6b $SCRATCH_DEV
+do_mkfs_fail -d agcount=32,agsize=32m $SCRATCH_DEV
+do_mkfs_fail -d sunit=0,swidth=64 $SCRATCH_DEV
+do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
+do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
+do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
+do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
+do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
+do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
+do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
+do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
+do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
+do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
+do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
+do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
+
+# file section, should pass
+rm -f $fsimg
+$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
+do_mkfs_pass -d size=$fssize,file,name=$fsimg
+do_mkfs_pass -d size=$fssize,file $fsimg
+do_mkfs_pass $fsimg
+do_mkfs_pass -d size=$((fssize)) $fsimg
+do_mkfs_pass -d size=$((fssize)),name=$fsimg
+do_mkfs_pass -d size=$((fssize/2)) $fsimg
+# again this one, to check that we didn't truncated the file
+do_mkfs_pass -d size=$((fssize)) $fsimg
+
+# invalid file section tests
+rm -f $fsimg
+$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
+do_mkfs_fail -d file $fsimg
+do_mkfs_fail -d file,name=$fsimg
+
+# naming section tests
+do_mkfs_pass -n size=65536 $SCRATCH_DEV
+
+# boolean options
+$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
+do_mkfs_pass -d file=1,size=$fssize $fsimg
+do_mkfs_pass -d file=0 $SCRATCH_DEV
+do_mkfs_fail -d file=1 $SCRATCH_DEV
+
+# Specific flag combinations where some bug appeared during development,
+# to catch the same issue if it re-appears. If there are multiple similar
+# checks, move them to a standalone block.
+
+
+do_mkfs_pass -m crc=1,finobt=1 $SCRATCH_DEV
+
+do_mkfs_pass -m crc=1 -n ftype=1 $SCRATCH_DEV
+do_mkfs_pass -m crc=0 -n ftype=1 $SCRATCH_DEV
+do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
+do_mkfs_pass -m crc=0 -n ftype=0 $SCRATCH_DEV
+do_mkfs_pass -n ftype=1 -m crc=0 $SCRATCH_DEV
+
+
+# if user states crc=0,finobt=1, fail instead of warning
+do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/xfs/400-input-validation.out b/tests/xfs/400-input-validation.out
new file mode 100644
index 0000000..7080553
--- /dev/null
+++ b/tests/xfs/400-input-validation.out
@@ -0,0 +1,2 @@
+QA output created by 400-input-validation
+silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index f4c6816..b51ef2e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -285,3 +285,4 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+400-input-validation auto quick mkfs
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
