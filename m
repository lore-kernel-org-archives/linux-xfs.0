Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46918 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752346AbeEQP21 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 May 2018 11:28:27 -0400
Subject: [PATCH V4] test online label ioctl
References: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f912f4ae-20b1-d19e-3b38-317b9ef46a6d@sandeen.net>
Date: Thu, 17 May 2018 10:28:26 -0500
MIME-Version: 1.0
In-Reply-To: <2a743318-585d-9eb1-5430-2b07246348ab@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

This tests the online label ioctl that btrfs has, which has been
recently proposed for XFS.

To run, it requires an updated xfs_io with the label command and a
filesystem that supports it

A slight change here to _require_xfs_io_command as well, so that tests
which simply fail with "Inappropriate ioctl" can be caught in the
common case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Now with new and improved sequential V4 versioning!

This passes on btrfs, _notruns on xfs/ext4 of yore, and passes
on xfs w/ my online label patchset (as long as xfs_io has the new
capability)

V2: Add a max label length helper
     Set the proper btrfs max label length o_O oops
     Filter trailing whitespace from blkid output

V3: lowercase local vars, simplify max label len function

V4: use/test new -s / -c options to set and clear

diff --git a/common/rc b/common/rc
index ffe53236..333cfb82 100644
--- a/common/rc
+++ b/common/rc
@@ -2144,6 +2144,9 @@ _require_xfs_io_command()
  		echo $testio | grep -q "Inappropriate ioctl" && \
  			_notrun "xfs_io $command support is missing"
  		;;
+	"label")
+		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
+		;;
  	"open")
  		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
  		# a new -C flag was introduced to execute one shot commands.
@@ -2182,7 +2185,7 @@ _require_xfs_io_command()
  	rm -f $testfile 2>&1 > /dev/null
  	echo $testio | grep -q "not found" && \
  		_notrun "xfs_io $command support is missing"
-	echo $testio | grep -q "Operation not supported" && \
+	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
  	echo $testio | grep -q "Invalid" && \
  		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
@@ -3788,6 +3791,29 @@ _require_scratch_feature()
  	esac
  }
  
+# The maximum filesystem label length, /not/ including terminating NULL
+_label_get_max()
+{
+	case $FSTYP in
+	xfs)
+		echo 12
+		;;
+	btrfs)
+		echo 255
+		;;
+	*)
+		_notrun "$FSTYP does not define maximum label length"
+		;;
+	esac
+}
+
+# Helper to check above early in a script
+_require_label_get_max()
+{
+	# Just call _label_get_max which will notrun if appropriate
+	dummy=$(_label_get_max)
+}
+
  init_rc
  
  ################################################################################
diff --git a/tests/generic/488 b/tests/generic/488
new file mode 100755
index 00000000..3616522d
--- /dev/null
+++ b/tests/generic/488
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test 488
+#
+# Test the online filesystem label set/get ioctls
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+# Author: Eric Sandeen <sandeen@redhat.com>
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "label"
+_require_label_get_max
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+# Make sure we can set & clear the label
+$XFS_IO_PROG -c "label -s label.$seq" $SCRATCH_MNT
+$XFS_IO_PROG -c "label" $SCRATCH_MNT
+
+$XFS_IO_PROG -c "label -c" $SCRATCH_MNT
+$XFS_IO_PROG -c "label" $SCRATCH_MNT
+
+# And that userspace can see it now, while mounted
+# NB: some blkid has trailing whitespace, filter it out here
+$XFS_IO_PROG -c "label -s label.$seq" $SCRATCH_MNT
+$XFS_IO_PROG -c "label" $SCRATCH_MNT
+blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
+
+# And that the it is still there when it's unmounted
+_scratch_unmount
+blkid -s LABEL $SCRATCH_DEV | _filter_scratch | sed -e "s/ $//g"
+
+# And that it persists after a remount
+_scratch_mount
+$XFS_IO_PROG -c "label" $SCRATCH_MNT
+
+# And that a too-long label is rejected, beyond the interface max:
+fs_label=$(perl -e "print 'l' x 257;")
+$XFS_IO_PROG -c "label -s $fs_label" $SCRATCH_MNT
+
+# And it succeeds right at the filesystem max:
+max_label_len=$(_label_get_max)
+fs_label=$(perl -e "print 'o' x $max_label_len;")
+$XFS_IO_PROG -c "label -s $fs_label" $SCRATCH_MNT | sed -e 's/o\+/MAXLABEL/'
+
+# And that it fails past the filesystem max:
+let toolong_label_len=max_label_len+1
+fs_label=$(perl -e "print 'o' x $toolong_label_len;")
+$XFS_IO_PROG -c "label -s $fs_label " $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/488.out b/tests/generic/488.out
new file mode 100644
index 00000000..70691af4
--- /dev/null
+++ b/tests/generic/488.out
@@ -0,0 +1,13 @@
+QA output created by 488
+label = "label.488"
+label = "label.488"
+label = ""
+label = ""
+label = "label.488"
+label = "label.488"
+SCRATCH_DEV: LABEL="label.488"
+SCRATCH_DEV: LABEL="label.488"
+label = "label.488"
+label: Invalid argument
+label = "MAXLABEL"
+label: Invalid argument
diff --git a/tests/generic/group b/tests/generic/group
index dc637c96..6266213e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -490,3 +490,4 @@
  485 auto quick insert
  486 auto quick attr
  487 auto quick
+488 auto quick




