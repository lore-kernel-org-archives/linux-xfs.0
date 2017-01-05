Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41989 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdAEBFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:05:00 -0500
Subject: [PATCH 3/7] ocfs2/reflink: fix file block size reporting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:04:55 -0800
Message-ID: <148357829538.7677.9027243162566485608.stgit@birch.djwong.org>
In-Reply-To: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Some of the reflink tests try to require a specific filesystem block
size so that they can test file block manipulation functions.  That's
straightforward for most filesystems but ocfs2 throws in the additional
twist that data fork block mappings are stored in units of clusters, not
blocks, which causes these reflink tests to fail.

Therefore, introduce a new helper that retrieves the file minimum block
size and adapt the reflink tests to use that instead.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: Add a leading underscore to the helper name.
---
 common/rc         |   21 +++++++++++++++++++--
 tests/generic/205 |    2 +-
 tests/generic/206 |    2 +-
 tests/generic/216 |    2 +-
 tests/generic/217 |    2 +-
 tests/generic/218 |    2 +-
 tests/generic/220 |    2 +-
 tests/generic/222 |    2 +-
 tests/generic/227 |    2 +-
 tests/generic/229 |    2 +-
 tests/generic/238 |    2 +-
 11 files changed, 29 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index 7b62a18..46bfb68 100644
--- a/common/rc
+++ b/common/rc
@@ -973,7 +973,7 @@ _scratch_mkfs_blocksized()
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
 	;;
     ocfs2)
-	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize -C $blocksize $SCRATCH_DEV
 	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
@@ -3077,13 +3077,30 @@ _sysfs_dev()
 	echo /sys/dev/block/$_maj:$_min
 }
 
+# Get the minimum block size of a file.  Usually this is the
+# minimum fs block size, but some filesystems (ocfs2) do block
+# mappings in larger units.
+_get_file_block_size()
+{
+	if [ -z $1 ] || [ ! -d $1 ]; then
+		echo "Missing mount point argument for _get_file_block_size"
+		exit 1
+	fi
+	if [ "$FSTYP" = "ocfs2" ]; then
+		stat -c '%o' $1
+	else
+		_get_block_size $1
+	fi
+}
+
+# Get the minimum block size of an fs.
 _get_block_size()
 {
 	if [ -z $1 ] || [ ! -d $1 ]; then
 		echo "Missing mount point argument for _get_block_size"
 		exit 1
 	fi
-	echo `stat -f -c %S $1`
+	stat -f -c %S $1
 }
 
 get_page_size()
diff --git a/tests/generic/205 b/tests/generic/205
index 65e345a..564afc0 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -60,7 +60,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/206 b/tests/generic/206
index 1816502..3fdbec2 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/216 b/tests/generic/216
index d85c1e6..93b0106 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/217 b/tests/generic/217
index 19d6f00..509f2c4 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/218 b/tests/generic/218
index f69c02a..92bc521 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/220 b/tests/generic/220
index 0678b5f..2bd0e99 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/222 b/tests/generic/222
index 24c54bb..eb2169c 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/227 b/tests/generic/227
index eb79bac..3fe2490 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/229 b/tests/generic/229
index 332e69c..55f875d 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/238 b/tests/generic/238
index df13c63..c60799d 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(_get_block_size $testdir)
+real_blksz=$(_get_file_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {

