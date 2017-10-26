Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49915 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdJZFwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 01:52:09 -0400
Subject: [PATCH 5/6] misc: add module reloading helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 Oct 2017 22:52:04 -0700
Message-ID: <150899712429.18389.5159489339127196469.stgit@magnolia>
In-Reply-To: <150899709935.18389.17266737014565285073.stgit@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some helper functions to require that we can reload a given module,
and add a helper to actually do that.  Refactor the existing users to
use the generics.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/btrfs    |   12 ------------
 common/rc       |   15 +++++++++++++++
 tests/btrfs/124 |    9 +++------
 tests/btrfs/125 |    9 +++------
 4 files changed, 21 insertions(+), 24 deletions(-)


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
diff --git a/common/rc b/common/rc
index 83aaced..5375f7b 100644
--- a/common/rc
+++ b/common/rc
@@ -3580,6 +3580,21 @@ _require_scratch_feature()
 	esac
 }
 
+# Check that we have a module that can be loaded.
+_require_loadable_module()
+{
+	module="$1"
+	modinfo "$module" > /dev/null 2>&1 || _notrun "${module}: must be a module."
+}
+
+# Reload a particular module.
+_reload_module()
+{
+	module="$1"
+
+	modprobe -r "${module}" || _fail "${module} unload failed"
+	modprobe "${module}" || _fail "${module} load failed"
+}
 
 init_rc
 
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index 7206094..1b6cb24 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -64,10 +64,7 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 2
-
-# the mounted test dir prevent btrfs unload, we need to unmount
-_test_unmount
-_require_btrfs_loadable
+_require_loadable_module "btrfs"
 
 _scratch_dev_pool_get 2
 
@@ -102,7 +99,7 @@ echo "clean btrfs ko" >> $seqres.full
 _scratch_unmount
 
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_module "btrfs"
 
 echo >> $seqres.full
 echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
@@ -141,7 +138,7 @@ echo
 echo "Mount degraded with the other dev"
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_module "btrfs"
 _mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
 _run_btrfs_util_prog filesystem show
 checkpoint3=`md5sum $SCRATCH_MNT/tf2`
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index 91aa8d8..dbb226c 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -63,10 +63,7 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 3
-
-# we need btrfs to unload, need test dir unmounted
-_test_unmount
-_require_btrfs_loadable
+_require_loadable_module "btrfs"
 
 _scratch_dev_pool_get 3
 
@@ -118,7 +115,7 @@ echo "unmount" >> $seqres.full
 _scratch_unmount
 echo "clean btrfs ko" >> $seqres.full
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_module "btrfs"
 _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
 dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
 					>>$seqres.full 2>&1
@@ -154,7 +151,7 @@ echo "Mount degraded but with other dev"
 
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_btrfs_ko
+_reload_module "btrfs"
 
 _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
 

