Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933690AbcIVWv2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Sep 2016 18:51:28 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fstests: make some xfs project quota tests generic
Message-ID: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
Date: Thu, 22 Sep 2016 17:51:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

This patch makes some xfs project quota tests generic,
so that there is at least some coverage on ext4 for this
(semi-)new feature.

It requires bleeding edge xfsprogs, so that xfs_quota and 
xfs_io's chproj command can operate on "foreign" filesystems,
and requires relatively new e2fsprogs to enable the project
quota feature on-disk.

The mechanism for enabling project quota on ext4 is a bit
arcane, but hopefully I've encapsulated it reasonably well here.

Changes:

* look for "project" feature in _require_prjquota
* look for accounting not enforcement (-P) in _require_prjquota
* add a _scratch_enable_pquota to turn on project quota feature
* s/pquota/quota/ in _qmount_option for ext4
* add helper to test for xfs_io chproj on foreign filesystems
* switch from block to inode quota in xfs/133 because empty
  ext4 dirs consume one block
* cosmetic/generic changes for mkfs, require tests, etc.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Eryu, would you like to do the move-to-generic/ since you'll need
to renumber them anyway? :)

Note -
This requires the previous patch I sent to the fstests list,

[PATCH 2/3 V2] modify xfs/ quota tests to work on generic filesystems

diff --git a/common/quota b/common/quota
index afc1606..556eba6 100644
--- a/common/quota
+++ b/common/quota
@@ -92,12 +92,16 @@ _require_xfs_quota_foreign()
 }
 
 #
-# checks that the XFS project quota support in the kernel is enabled.
+# checks that the project quota support in the kernel is enabled.
 #
 _require_prjquota()
 {
     [ -n "$1" ] && _dev="$1" || _dev="$TEST_DEV"
-    src/feature -p $_dev
+    if [ "$FSTYP" == "ext4" ]; then
+	dumpe2fs -h $_dev 2>&1 | grep -qw project || \
+		_notrun "Project quota not available on this ext4"
+    fi
+    src/feature -P $_dev
     [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
     if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
 	_notrun "Project quotas not supported on realtime filesystem"
@@ -105,6 +109,16 @@ _require_prjquota()
 }
 
 #
+# ext4 (for now) is unique in that we must enable the project quota feature
+# prior to mount.  This is a relatively new feature ...
+_scratch_enable_pquota()
+{
+	[ "$FSTYP" != "ext4" ] && return
+
+	tune2fs -O quota,project $SCRATCH_DEV >>$seqres.full 2>&1
+}
+
+#
 # checks for user nobody in /etc/passwd and /etc/group.
 #
 _require_nobody()
@@ -197,6 +211,8 @@ _qmount()
 #
 _qmount_option()
 {
+	OPTS=$1
+
 	# Replace any user defined quota options
 	# with the quota option that we want.
 	# Simplest to do this rather than delete existing ones first because
@@ -210,16 +226,23 @@ _qmount_option()
 		-e 's/gquota/QUOTA/g'      \
 		-e 's/grpquota/QUOTA/g'    \
 		-e 's/pquota/QUOTA/g'      \
-		-e 's/prjquota/QUOTA/g'      \
+		-e 's/prjquota/QUOTA/g'    \
 		-e 's/quota/QUOTA/g'       \
 		-e 's/uqnoenforce/QUOTA/g' \
 		-e 's/gqnoenforce/QUOTA/g' \
 		-e 's/pqnoenforce/QUOTA/g' \
 		-e 's/qnoenforce/QUOTA/g'  \
-		-e "s/QUOTA/$1/g"`
+		-e "s/QUOTA/$OPTS/g"`
 
+	# ext4 doesn't _do_ "-o pquota/prjquota" because reasons
+	# Switch it to "quota" to enable mkfs-time pquota
+	if [ "$FSTYP" == "ext4" ]; then
+		OPTS=`echo $OPTS \
+		| sed	-e 's/pquota/quota/g'	\
+			-e 's/prjquota/quota/g'`
+	fi
 	# Ensure we have the given quota option - duplicates are fine
-	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $1"
+	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $OPTS"
 	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
 }
 
diff --git a/common/rc b/common/rc
index 13afc6a..649cd6b 100644
--- a/common/rc
+++ b/common/rc
@@ -2031,6 +2031,9 @@ _require_xfs_io_command()
 
 	testfile=$TEST_DIR/$$.xfs_io
 	case $command in
+	"chproj")
+		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
+		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $testfile 2>&1`
 		;;
@@ -2063,6 +2066,8 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+	echo $testio | grep -q "foreign file active" && \
+		_notrun "xfs_io $command not supported on $FSTYP"
 
 	test -z "$param" && return
 	$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
diff --git a/tests/xfs/133 b/tests/xfs/133
index f77bc79..be5b19b 100755
--- a/tests/xfs/133
+++ b/tests/xfs/133
@@ -46,12 +46,14 @@ _cleanup()
 rm -f $seqres.full
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 _require_scratch
-_require_xfs_quota
+_require_quota
+_require_xfs_quota_foreign
 
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1
+_scratch_enable_pquota
 
 do_project_test()
 {
@@ -72,20 +74,22 @@ EOF
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
 		-c "project -s $qa_project" $SCRATCH_MNT > /dev/null
 
+	# We set & test inodes, because xfs vs ext4 consume differing
+	# amounts of space for an empty dir, but an inode is an inode...
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-		-c "limit -p bsoft=100m bhard=200m $qa_project" $SCRATCH_MNT
+		-c "limit -p isoft=100 ihard=200 $qa_project" $SCRATCH_MNT
 
 	echo "=== quota command output ==="
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid \
-		-c "quota -p -v -b $qa_project" $SCRATCH_MNT | _filter_quota
+		-c "quota -p -v -i $qa_project" $SCRATCH_MNT | _filter_quota
 
 	echo "=== report command output ==="
 	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
-		-c "report -p -N -b" $SCRATCH_MNT | _filter_project_quota
+		-c "report -p -N -i" $SCRATCH_MNT | _filter_project_quota
 }
 
 # Test project
-_qmount_option "uquota,pquota"
+_qmount_option "usrquota,prjquota"
 _qmount
 _require_prjquota $SCRATCH_DEV
 do_project_test
diff --git a/tests/xfs/133.out b/tests/xfs/133.out
index 21cfd0d..3accee6 100644
--- a/tests/xfs/133.out
+++ b/tests/xfs/133.out
@@ -1,8 +1,8 @@
 QA output created by 133
 === quota command output ===
 Disk quotas for Project 123456-project (10)
-Filesystem Blocks Quota Limit Warn/Time Mounted on
-SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1 100 200 00 [--------] SCRATCH_MNT
 === report command output ===
-123456-project 0 102400 204800 00 [--------]
+123456-project 1 100 200 00 [--------]
 
diff --git a/tests/xfs/134 b/tests/xfs/134
index 21fe1ed..58acc3b 100755
--- a/tests/xfs/134
+++ b/tests/xfs/134
@@ -45,11 +45,14 @@ _cleanup()
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_test
-_require_xfs_quota
+_require_quota
+_require_xfs_quota_foreign
+_require_xfs_io_command "chproj"
+
 # we can't run with group quotas
 _exclude_scratch_mount_option "gquota" "grpquota"
 
@@ -68,21 +71,12 @@ cp /dev/null $seqres.full
 chmod a+rwx $seqres.full	# arbitrary users will write here
 
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
-
-#if pquota's already in mount options then we dont need to enable
-
-EXTRA_MOUNT_OPTIONS="-o pquota"
-
-if ! _scratch_mount "$EXTRA_MOUNT_OPTIONS" >$tmp.out 2>&1
-then
-    cat $tmp.out
-    echo "!!! mount failed"
-    exit
-fi
+_scratch_mkfs >/dev/null 2>&1
+_scratch_enable_pquota
 
-src/feature -p $SCRATCH_DEV
-[ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
+_qmount_option "prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
 
 report_quota()
 {
diff --git a/tests/xfs/196 b/tests/xfs/196
index 3bff8f6..f185c81 100755
--- a/tests/xfs/196
+++ b/tests/xfs/196
@@ -46,11 +46,12 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/quota
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_require_xfs_quota
+_require_quota
+_require_xfs_quota_foreign
 
 #
 # Setup temporary replacements for /etc/projects and /etc/projid
@@ -66,11 +67,13 @@ EOF
 #
 # And make sure we always use our replacements
 #
-quota_cmd="xfs_quota -D $tmp.projects -P $tmp.projid"
+quota_cmd="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
 
-_scratch_mkfs_xfs >/dev/null 2>&1
-_qmount_option "pquota"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_enable_pquota
+_qmount_option "prjquota"
 _qmount
+_require_prjquota $SCRATCH_DEV
 
 #
 # Create the project root
diff --git a/tests/xfs/262 b/tests/xfs/262
index 9d8b838..3c2c34e 100755
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -63,10 +63,11 @@ echo "Silence is golden."
 proj_dir="$SCRATCH_MNT/test"
 
 # Modify as appropriate.
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _require_quota
+_require_xfs_quota_foreign
 _require_scratch
 
 # Make sure the hard limits reported are what was set.
@@ -115,7 +116,7 @@ _filter_quota_rpt() {
 }
 
 _quota_cmd() {
-	xfs_quota -P "$my_projid" -D "$my_projects" -x \
+	$XFS_QUOTA_PROG -P "$my_projid" -D "$my_projects" -x \
 		-c "$@" "$SCRATCH_MNT"
 }
 
@@ -124,10 +125,13 @@ _quota_cmd() {
 echo $proj_name:$proj_num > "$my_projid"
 echo $proj_num:$proj_dir > "$my_projects"
 
-_scratch_mkfs						>> "$seqres.full" 2>&1
+_scratch_mkfs					>> "$seqres.full" 2>&1
+_scratch_enable_pquota
 
-export MOUNT_OPTIONS="-opquota"
+_qmount_option "prjquota"
 _qmount
+_require_prjquota $SCRATCH_DEV
+
 mkdir -p "${proj_dir}"
 
 # Setup the project quota directory

