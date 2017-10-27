Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24913 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdJ0UXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 16:23:13 -0400
Date: Fri, 27 Oct 2017 13:23:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3 5/6] misc: add module reloading helpers
Message-ID: <20171027202308.GI5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <150899712429.18389.5159489339127196469.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899712429.18389.5159489339127196469.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Add some helper functions to require that we can reload a given module,
and add a helper to actually do that.  Refactor the existing users to
use the generics.

We need to hoist completely the behaviors of the old btrfs module helper
because we need to confirm before starting the test that we actually can
remove the module.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: be more judicious in our use of _notrun/_fail
---
 common/btrfs    |   12 -------
 common/module   |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/overlay  |    1 +
 common/rc       |   11 ------
 tests/btrfs/124 |    9 ++---
 tests/btrfs/125 |    9 ++---
 6 files changed, 108 insertions(+), 33 deletions(-)
 create mode 100644 common/module

diff --git a/common/btrfs b/common/btrfs
index fd762ef..c09206c 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -349,18 +349,6 @@ _btrfs_qgroup_units()
 	$BTRFS_UTIL_PROG qgroup show --help 2>&1 | grep -q -- --raw && echo "--raw"
 }
 
-_require_btrfs_loadable()
-{
-	modprobe -r btrfs || _notrun "btrfs unloadable"
-	modprobe btrfs || _notrun "Can't load btrfs"
-}
-
-_reload_btrfs_ko()
-{
-	modprobe -r btrfs || _fail "btrfs unload failed"
-	modprobe btrfs || _fail "btrfs load failed"
-}
-
 _btrfs_compression_algos()
 {
 	echo zlib
diff --git a/common/module b/common/module
new file mode 100644
index 0000000..7473d20
--- /dev/null
+++ b/common/module
@@ -0,0 +1,99 @@
+##/bin/bash
+
+# Routines for messing around with loadable kernel modules
+#
+#-----------------------------------------------------------------------
+#  Copyright (c) 2017 Oracle.  All Rights Reserved.
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+#  USA
+#-----------------------------------------------------------------------
+
+# Return the module name for this fs.
+_module_for_fs()
+{
+	echo "${FSTYP}"
+}
+
+# Reload a particular module.  This module MUST NOT be the module that
+# underlies the filesystem.
+_reload_module()
+{
+	module="$1"
+
+	modprobe -r "${module}" || _fail "${module} unload failed"
+	modprobe "${module}" || _fail "${module} load failed"
+}
+
+# Reload the filesystem module.
+_reload_fs_module()
+{
+	module="$1"
+
+	# Unload test fs, try to reload module, remount
+	had_testfs=""
+	had_scratchfs=""
+	_check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR && had_testfs="true"
+	_check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT && had_scratchfs="true"
+	test -n "${had_testfs}" && _test_unmount
+	test -n "${had_scratchfs}" && _scratch_unmount
+	_reload_module "${module}"
+	test -n "${had_scratchfs}" && _scratch_mount 2> /dev/null
+	test -n "${had_testfs}" && _test_mount 2> /dev/null
+}
+
+# Check that we have a module that can be loaded.  This module MUST NOT
+# be the module that underlies the filesystem.
+_require_loadable_module()
+{
+	module="$1"
+
+	modinfo "${module}" > /dev/null 2>&1 || _notrun "${module}: must be a module."
+	modprobe -r "${module}" || _notrun "${module} unload failed"
+	modprobe "${module}" || _notrun "${module} load failed"
+}
+
+# Check that the module for FSTYP can be loaded.
+_require_loadable_fs_module()
+{
+	module="$1"
+
+	modinfo "${module}" > /dev/null 2>&1 || _notrun "${module}: must be a module."
+
+	# Unload test fs, try to reload module, remount
+	had_testfs=""
+	had_scratchfs=""
+	_check_mounted_on TEST_DEV $TEST_DEV TEST_DIR $TEST_DIR && had_testfs="true"
+	_check_mounted_on SCRATCH_DEV $SCRATCH_DEV SCRATCH_MNT $SCRATCH_MNT && had_scratchfs="true"
+	test -n "${had_testfs}" && _test_unmount
+	test -n "${had_scratchfs}" && _scratch_unmount
+	unload_ok=""
+	load_ok=""
+	modprobe -r "${module}" || unload_ok=0
+	modprobe "${module}" || load_ok=0
+	test -n "${had_scratchfs}" && _scratch_mount 2> /dev/null
+	test -n "${had_testfs}" && _test_mount 2> /dev/null
+	test -z "${unload_ok}" || _notrun "${module} unload failed"
+	test -z "${load_ok}" || _notrun "${module} load failed"
+}
+
+# Print the value of a filesystem module parameter
+# at /sys/module/$FSTYP/parameters/$PARAM
+#
+# Usage example (FSTYP=overlay):
+#   _get_fs_module_param index
+_get_fs_module_param()
+{
+	cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
+}
diff --git a/common/overlay b/common/overlay
index 79097ba..1da4ab1 100644
--- a/common/overlay
+++ b/common/overlay
@@ -1,6 +1,7 @@
 #
 # overlayfs specific common functions.
 #
+. ./common/module
 
 # helper function to do the actual overlayfs mount operation
 _overlay_mount_dirs()
diff --git a/common/rc b/common/rc
index 83aaced..c708bfa 100644
--- a/common/rc
+++ b/common/rc
@@ -3554,16 +3554,6 @@ _get_fs_sysfs_attr()
 	cat /sys/fs/${FSTYP}/${dname}/${attr}
 }
 
-# Print the value of a filesystem module parameter
-# at /sys/module/$FSTYP/parameters/$PARAM
-#
-# Usage example (FSTYP=overlay):
-#   _get_fs_module_param index
-_get_fs_module_param()
-{
-	cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
-}
-
 # Generic test for specific filesystem feature.
 # Currently only implemented to test overlayfs features.
 _require_scratch_feature()
@@ -3580,7 +3570,6 @@ _require_scratch_feature()
 	esac
 }
 
-
 init_rc
 
 ################################################################################
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index 7206094..a648627 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -55,6 +55,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/module
 
 # remove previous $seqres.full before test
 rm -f $seqres.full
@@ -64,10 +65,8 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 2
-
-# the mounted test dir prevent btrfs unload, we need to unmount
 _test_unmount
-_require_btrfs_loadable
+_require_loadable_fs_module "btrfs"
 
 _scratch_dev_pool_get 2
 
@@ -102,7 +101,7 @@ echo "clean btrfs ko" >> $seqres.full
 _scratch_unmount
 
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_fs_module "btrfs"
 
 echo >> $seqres.full
 echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
@@ -141,7 +140,7 @@ echo
 echo "Mount degraded with the other dev"
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_fs_module "btrfs"
 _mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
 _run_btrfs_util_prog filesystem show
 checkpoint3=`md5sum $SCRATCH_MNT/tf2`
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index 91aa8d8..19961a1 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -54,6 +54,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/module
 
 # remove previous $seqres.full before test
 rm -f $seqres.full
@@ -63,10 +64,8 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 3
-
-# we need btrfs to unload, need test dir unmounted
 _test_unmount
-_require_btrfs_loadable
+_require_loadable_fs_module "btrfs"
 
 _scratch_dev_pool_get 3
 
@@ -118,7 +117,7 @@ echo "unmount" >> $seqres.full
 _scratch_unmount
 echo "clean btrfs ko" >> $seqres.full
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_fs_module "btrfs"
 _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
 dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
 					>>$seqres.full 2>&1
@@ -154,7 +153,7 @@ echo "Mount degraded but with other dev"
 
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_fs_module "btrfs"
 
 _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
 
