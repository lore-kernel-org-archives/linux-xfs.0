Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o438TdTk143035 for <xfs@oss.sgi.com>; Mon, 3 May 2010 03:29:39 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FB29307474
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 01:31:46 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id 5JY3DT6atIZPhN1l for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 01:31:46 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o438G5hu008620
	for <xfs@oss.sgi.com>; Mon, 3 May 2010 04:16:05 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	o438Vitj2056410 for <xfs@oss.sgi.com>; Mon, 3 May 2010 04:31:44 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id
	o438ViA6023257 for <xfs@oss.sgi.com>; Mon, 3 May 2010 05:31:44 -0300
Date: Mon, 3 May 2010 14:01:35 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH] New testcase to check if fallocate respects RLIMIT_FSIZE
	or not
Message-ID: <20100503083135.GC13756@amitarora.in.ibm.com>
References: <201004281854.49730.knikanth@suse.de> <4BD85F1F.7030100@suse.de>
	<201004291014.07194.knikanth@suse.de>
	<20100430143319.d51d6d77.akpm@linux-foundation.org>
	<20100501070426.GA9562@amitarora.in.ibm.com>
	<20100501101846.GA3769@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100501101846.GA3769@infradead.org>
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
Cc: Nick Piggin <npiggin@suse.de>, Andreas Dilger <adilger@sun.com>, Eelis <opensuse.org@contacts.eelis.net>, Theodore Ts'o <tytso@mit.edu>, Nikanth Karthikesan <knikanth@suse.de>, coly.li@suse.de, Amit Arora <aarora@in.ibm.com>, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

On Sat, May 01, 2010 at 06:18:46AM -0400, Christoph Hellwig wrote:
> On Sat, May 01, 2010 at 12:34:26PM +0530, Amit K. Arora wrote:
> > Agreed. How about doing this check in the filesystem specific fallocate
> > inode routines instead ? For example, in ext4 we could do :
> 
> That looks okay - in fact XFS should already have this check because
> it re-uses the setattr implementation to set the size.
> 
> Can you submit an xfstests testcase to verify this behaviour on all
> filesystems?

Here is the new testcase.

I have run this test on a x86_64 box on XFS and ext4 on 2.6.34-rc6. It
passes on XFS, but fails on ext4. Below is the snapshot of results
followed by the testcase itself.

--
Regards,
Amit Arora

Test results:
------------
# ./check 228
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 elm9m93 2.6.34-rc6

228 0s ...
Ran: 228
Passed all 1 tests
#
# umount /mnt
# mkfs.ext4 /dev/sda4 >/dev/null
mke2fs 1.41.10 (10-Feb-2009)
# ./check 228
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 elm9m93 2.6.34-rc6

228 0s ... - output mismatch (see 228.out.bad)
--- 228.out	2010-05-03 02:51:24.000000000 -0400
+++ 228.out.bad	2010-05-03 04:27:33.000000000 -0400
@@ -1,2 +1 @@
 QA output created by 228
-File size limit exceeded (core dumped)
Ran: 228
Failures: 228
Failed 1 of 1 tests
#


Here is the test:
----------------
Add a new testcase to the xfstests suite to check if fallocate respects
the limit imposed by RLIMIT_FSIZE (can be set by "ulimit -f XXX") or
not, on a particular filesystem.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

diff -Nuarp xfstests-dev.org/228 xfstests-dev/228
--- xfstests-dev.org/228	1969-12-31 19:00:00.000000000 -0500
+++ xfstests-dev/228	2010-05-03 02:45:10.000000000 -0400
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 228
+#
+# Check if fallocate respects RLIMIT_FSIZE 
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 IBM Corporation. All Rights Reserved.
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
+owner=aarora@in.ibm.com
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
+trap "_cleanup; exit \$status" 0 1 2 3 15 25
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
+# Sanity check to see if fallocate works
+_require_xfs_io_falloc
+
+# Check if we have good enough space available
+avail=`df -P $TEST_DIR | awk 'END {print $4}'`
+[ "$avail" -ge 104000 ] || _notrun "Test device is too small ($avail KiB)"
+
+# Set the FSIZE ulimit to 100MB and check
+ulimit -f 102400
+flim=`ulimit -f`
+[ "$flim" != "unlimited" ] || _notrun "Unable to set FSIZE ulimit"
+[ "$flim" -eq 102400 ] || _notrun "FSIZE ulimit is not correct (100 MB)"
+
+# FSIZE limit is now set to 100 MB.
+# Lets try to preallocate 101 MB. This should fail.
+$XFS_IO_PROG -F -f -c 'falloc 0 101m' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# Lets now try to preallocate 50 MB. This should succeed.
+$XFS_IO_PROG -F -f -c 'falloc 0 50m' $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
+# success, all done
+status=0
+exit
diff -Nuarp xfstests-dev.org/group xfstests-dev/group
--- xfstests-dev.org/group	2010-05-03 02:35:09.000000000 -0400
+++ xfstests-dev/group	2010-05-03 02:45:21.000000000 -0400
@@ -341,3 +341,4 @@ deprecated
 225 auto quick
 226 auto enospc
 227 auto fsr
+228 rw auto prealloc quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
