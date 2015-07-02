Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAA537FB5
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 18:06:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96224304039
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 16:06:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	79PnAZJPfX51oN9w for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2015 16:06:41 -0700 (PDT)
Date: Fri, 3 Jul 2015 09:05:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/17] xfsprogs: use common code for multi-disk detection
Message-ID: <20150702230520.GA22807@dastard>
References: <1434711726-13092-1-git-send-email-jtulak@redhat.com>
	<1434711726-13092-2-git-send-email-jtulak@redhat.com>
	<20150625193748.GE36162@bfoster.bfoster>
	<413545489.22844725.1435841273912.JavaMail.zimbra@redhat.com>
	<20150702141403.GA61817@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150702141403.GA61817@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Jan Tulak <jtulak@redhat.com>

On Thu, Jul 02, 2015 at 10:14:04AM -0400, Brian Foster wrote:
> On Thu, Jul 02, 2015 at 08:47:53AM -0400, Jan Tulak wrote:

[snip ~250 lines]

[ add note about mailing list etiquette w.r.t. trimming the quoted
context to just what is being discussed so that readers don't have to
scroll through several screens of irrelevant text just to find the
discussion. ]

> If you're still not convinced, create an exact sized 512GB file, mkfs it
> (with the su/sw options set for multidisk) with and without this change
> and observe agcount. :)

At one point during development of this patch set I started writing
an xfstest to validate that mkfs did all the right input validation
things and set parameters appropriately so that we didn't
inadvertently change behaviour. I never really finished it off (like
the patch set), but I've attached it below to give an idea of where
I was going with it. It was based on validating the input and CLI
parameters for the new code, so is guaranteed to fail on an existing
mkfs binary.

It's probably a good idea to also validate that things like agcount
scale as we expect them to...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: add new xfs.mkfs input validation test

From: Dave Chinner <dchinner@redhat.com>

mkfs.xfs does not do a very good job of input validation. This test
is designed to exercise the input validation and test good/bad
combinations of options being set. It will not pass on a current
mkfs.xfs binary - it is designed to be the test case for a input
validation cleanup.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/401     | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/401.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 197 insertions(+)

diff --git a/tests/xfs/401 b/tests/xfs/401
new file mode 100644
index 0000000..48de395
--- /dev/null
+++ b/tests/xfs/401
@@ -0,0 +1,194 @@
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
+echo "QA output created by $res"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit $status" 0 1 2 3 15
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
+	echo >> $seqres.full
+	echo "pass expected $*" >> $seqres.full
+	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
+	[ $? -ne 0 ] && echo "fail $*"
+}
+
+do_mkfs_fail()
+{
+	echo >> $seqres.full
+	echo "fail expected $*" >> $seqres.full
+	$MKFS_XFS_PROG -f -N $* >> $seqres.full 2>&1
+	[ $? -eq 0 ] && echo "pass $*"
+}
+
+do_mkfs_pass $SCRATCH_DEV
+
+# basic "should fail" options
+# logarithm based options are no longer valid
+do_mkfs_fail -s log=9 $SCRATCH_DEV
+do_mkfs_fail -b log=9 $SCRATCH_DEV
+do_mkfs_fail -n log=9 $SCRATCH_DEV
+do_mkfs_fail -i log=9 $SCRATCH_DEV
+do_mkfs_fail -d sectlog=9 $SCRATCH_DEV
+do_mkfs_fail -l sectlog=9 $SCRATCH_DEV
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
+rm -f $fsimg
+$XFS_IO_PROG -f -c "truncate $fssize" $fsimg
+do_mkfs_pass -d file $fsimg
+do_mkfs_pass -d file,name=$fsimg
+rm -f $fsimg
+do_mkfs_pass -d size=$fssize,file $fsimg
+rm -f $fsimg
+do_mkfs_pass -d size=$fssize,file,name=$fsimg
+do_mkfs_pass -d file,name=$fsimg
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
+# naming section tests
+do_mkfs_pass -n size=65536 $SCRATCH_DEV
+
+status=0
+exit
diff --git a/tests/xfs/401.out b/tests/xfs/401.out
new file mode 100644
index 0000000..aaf601b
--- /dev/null
+++ b/tests/xfs/401.out
@@ -0,0 +1,2 @@
+QA output created by 401
+silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index ba34650..cfee785 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -189,3 +189,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+401 mkfs auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
