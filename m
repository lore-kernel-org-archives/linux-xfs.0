Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52162 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752768AbeENRGq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 13:06:46 -0400
Subject: Re: [PATCH] test online label ioctl
References: <fd1e2651-099f-8acd-da4d-a67c1e45cd07@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a542f523-7887-67fc-2082-e4426969fee4@sandeen.net>
Date: Mon, 14 May 2018 12:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <fd1e2651-099f-8acd-da4d-a67c1e45cd07@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, fstests <fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

This tests the online label ioctl that btrfs has, which has been
recently proposed for XFS.

To run, it requires an updated xfs_io with the label command and a
filesystem that supports it

A slight change here to _require_xfs_io_command as well, so that tests
which simply fail with "Inappropriate ioctl" can be caught in the
common case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This passes on btrfs, _notruns on xfs/ext4 of yore, and passes
on xfs w/ my online label patchset (as long as xfs_io has the new
capability)

V2: Add a max label length helper
    Set the proper btrfs max label length o_O oops
    Filter trailing whitespace from blkid output


diff --git a/common/rc b/common/rc
index 9ffab7fd..88a99cff 100644
--- a/common/rc
+++ b/common/rc
@@ -2158,6 +2158,9 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"label")
+		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
+		;;
 	"open")
 		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
 		# a new -C flag was introduced to execute one shot commands.
@@ -2196,7 +2199,7 @@ _require_xfs_io_command()
 	rm -f $testfile 2>&1 > /dev/null
 	echo $testio | grep -q "not found" && \
 		_notrun "xfs_io $command support is missing"
-	echo $testio | grep -q "Operation not supported" && \
+	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
 	echo $testio | grep -q "Invalid" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
@@ -3802,6 +3805,31 @@ _require_scratch_feature()
 	esac
 }
 
+# The maximum filesystem label length, not including terminating NULL
+_label_get_max()
+{
+	case $FSTYP in
+	xfs)
+		MAXLEN=12
+		;;
+	btrfs)
+		MAXLEN=255
+		;;
+	*)
+		MAXLEN=0
+		;;
+	esac
+
+	echo $MAXLEN
+}
+
+_require_label_get_max()
+{
+	if [ $(_label_get_max) -eq 0 ]; then
+		_notrun "$FSTYP does not define maximum label length"
+	fi
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/generic/479 b/tests/generic/479
old mode 100644
new mode 100755
diff --git a/tests/generic/485 b/tests/generic/485
new file mode 100755
index 00000000..941afd3d
--- /dev/null
+++ b/tests/generic/485
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test 485
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
+$XFS_IO_PROG -c "label label.$seq" $SCRATCH_MNT
+$XFS_IO_PROG -c "label" $SCRATCH_MNT
+
+# And that userspace can see it now, while mounted
+# NB: some blkid has trailing whitespace, filter it out here
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
+LABEL=$(perl -e "print 'l' x 257;")
+$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
+
+# And it succeeds right at the filesystem max:
+MAXLEN=$(_label_get_max)
+LABEL=$(perl -e "print 'o' x $MAXLEN;")
+$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT | sed -e 's/o\+/MAXLABEL/'
+
+# And that it fails past the filesystem max:
+let TOOLONG=MAXLEN+1
+LABEL=$(perl -e "print 'o' x $TOOLONG;")
+$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/485.out b/tests/generic/485.out
new file mode 100644
index 00000000..24efca8c
--- /dev/null
+++ b/tests/generic/485.out
@@ -0,0 +1,9 @@
+QA output created by 485
+label = "label.485"
+label = "label.485"
+SCRATCH_DEV: LABEL="label.485"
+SCRATCH_DEV: LABEL="label.485"
+label = "label.485"
+label: Invalid argument
+label = "MAXLABEL"
+label: Invalid argument
diff --git a/tests/generic/group b/tests/generic/group
index 19be9267..9ac5bbd1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -487,3 +487,4 @@
 482 auto metadata replay
 483 auto quick log metadata
 484 auto quick
+485 auto quick


