Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:41012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXP4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:56:17 -0400
Date: Wed, 24 Jul 2019 08:56:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/3] various: disable quotas before running test
Message-ID: <20190724155610.GF7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For all the tests which require that quotas be disabled, remove the
quota mount options before mounting the scratch filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/384 |    4 ++--
 tests/xfs/030     |    2 ++
 tests/xfs/033     |    2 ++
 tests/xfs/065     |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/generic/384 b/tests/generic/384
index b7c940d7..33098a38 100755
--- a/tests/generic/384
+++ b/tests/generic/384
@@ -37,8 +37,8 @@ _require_quota
 _require_xfs_quota_foreign
 _require_xfs_io_command "chproj"
 
-# we can't run with group quotas
-_exclude_scratch_mount_option "gquota" "grpquota"
+# we can't run with group quotas (on v4 xfs); the mount options for group
+# quotas will be filtered out by _qmount_option below.
 
 dir=$SCRATCH_MNT/project
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index 5ed99628..10854c8a 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -28,6 +28,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/repair
+. ./common/quota
 
 # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
 #
@@ -65,6 +66,7 @@ if [ $? -ne 0 ]		# probably don't have a big enough scratch
 then
 	_notrun "SCRATCH_DEV too small, results would be non-deterministic"
 else
+	_qmount_option noquota
 	_scratch_mount
 	src/feature -U $SCRATCH_DEV && \
 		_notrun "UQuota are enabled, test needs controlled sb recovery"
diff --git a/tests/xfs/033 b/tests/xfs/033
index 5af0aefc..75b44f38 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -28,6 +28,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/repair
+. ./common/quota
 
 # nuke the root, rt bitmap, and rt summary inodes
 # 
@@ -80,6 +81,7 @@ _link_out_file_named $seqfull.out "$FEATURES"
 	sed -e 's/ //g' -e 's/^/export /'`
 
 # check we won't get any quota inodes setup on mount
+_qmount_option noquota
 _scratch_mount
 src/feature -U $SCRATCH_DEV && \
 	_notrun "UQuota are enabled, test needs controlled sb recovery"
diff --git a/tests/xfs/065 b/tests/xfs/065
index f09bd947..b1533666 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -29,6 +29,7 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/dump
+. ./common/quota
 
 #
 # list recursively the directory
@@ -57,6 +58,7 @@ _require_scratch
 # so don't run it
 #
 _scratch_mkfs_xfs >> $seqres.full
+_qmount_option noquota
 _scratch_mount
 $here/src/feature -U $SCRATCH_DEV && \
 	_notrun "UQuota enabled, test needs controlled xfsdump output"
