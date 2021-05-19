Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,MONEY_NOHTML,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200D1C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7F23611BD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhESX6I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESX6H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA7F600CC;
        Wed, 19 May 2021 23:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468607;
        bh=dDXU+ropiBVVQdNWsOUKAj7y/QA1F1r4t5Me4FlrA8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQBdmL4kGlJ26tVY25OYlqmbHfm3+L95Jz0wdcw9GVVLqeRNs5d6xnYuxvD8S0S+2
         /yxaja4eqK0tgtVwHzBmsUTtyaRWgNu3lKDFSsfPHCInwNqDX26WHnncxe1eShO55H
         yDBXzmwpuiE9QvPd2IGGvGsOgAai/XfCArCfPGDThe6C0V8lCIdvdODcSfhmJBFnWN
         b/uKe73P2PDywfiM12QVmkLM+lei5LvtMP0EOYUDlnYHszAO4ewu8PXDYKre+Skp/y
         XrKsiiMsHHbopkzMP1wJzE0P1XIWWAMHDpEq0APdfNzKuRaAFfAIPIM0vql3vY6Ai/
         KfkGU8lsvzQFQ==
Subject: [PATCH 1/6] common/xfs: refactor commands to select a particular xfs
 backing device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:56:46 -0700
Message-ID: <162146860674.2500122.8733670522999610459.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor all the places where we try to force new file data allocations
to a specific xfs backing device so that we don't end up open-coding the
same xfs_io command lines over and over.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate   |    2 +-
 common/xfs        |   25 +++++++++++++++++++++++++
 tests/generic/223 |    3 ++-
 tests/generic/449 |    2 +-
 tests/xfs/004     |    2 +-
 tests/xfs/146     |    2 +-
 tests/xfs/147     |    2 +-
 tests/xfs/272     |    2 +-
 tests/xfs/318     |    2 +-
 tests/xfs/431     |    4 ++--
 tests/xfs/521     |    2 +-
 tests/xfs/528     |    2 +-
 tests/xfs/532     |    2 +-
 tests/xfs/533     |    2 +-
 tests/xfs/538     |    2 +-
 15 files changed, 41 insertions(+), 15 deletions(-)


diff --git a/common/populate b/common/populate
index d484866a..867776cd 100644
--- a/common/populate
+++ b/common/populate
@@ -162,7 +162,7 @@ _scratch_xfs_populate() {
 	# Clear the rtinherit flag on the root directory so that files are
 	# always created on the data volume regardless of MKFS_OPTIONS.  We can
 	# set the realtime flag when needed.
-	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+	_xfs_force_bdev data $SCRATCH_MNT
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
diff --git a/common/xfs b/common/xfs
index 725819bd..d7f2a005 100644
--- a/common/xfs
+++ b/common/xfs
@@ -194,6 +194,31 @@ _xfs_get_file_block_size()
 	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
 }
 
+# Set or clear the realtime status of every supplied path.  The first argument
+# is either 'data' or 'realtime'.  All other arguments should be paths to
+# existing directories or empty regular files.
+#
+# For each directory, each file subsequently created will target the given
+# device for file data allocations.  For each empty regular file, each
+# subsequent file data allocation will be on the given device.
+_xfs_force_bdev()
+{
+	local device="$1"
+	shift
+	local chattr_arg=""
+
+	case "$device" in
+	"data")		chattr_arg="-t";;
+	"realtime")	chattr_arg="+t";;
+	*)
+		echo "${device}: Don't know what device this is?"
+		return 1
+		;;
+	esac
+
+	$XFS_IO_PROG -c "chattr $chattr_arg" "$@"
+}
+
 _xfs_get_fsxattr()
 {
 	local field="$1"
diff --git a/tests/generic/223 b/tests/generic/223
index f6393293..078fd725 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -46,7 +46,8 @@ for SUNIT_K in 8 16 32 64 128; do
 	# This test checks for stripe alignments of space allocations on the
 	# filesystem.  Make sure all files get created on the main device,
 	# which for XFS means no rt files.
-	test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+	test "$FSTYP" = "xfs" && \
+		_xfs_force_bdev data $SCRATCH_MNT
 
 	for SIZE_MULT in 1 2 8 64 256; do
 		let SIZE=$SIZE_MULT*$SUNIT_BYTES
diff --git a/tests/generic/449 b/tests/generic/449
index 5fd15367..2a5065f6 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -46,7 +46,7 @@ _scratch_mount || _fail "mount failed"
 # This is a test of xattr behavior when we run out of disk space for xattrs,
 # so make sure the pwrite goes to the data device and not the rt volume.
 test "$FSTYP" = "xfs" && \
-	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+	_xfs_force_bdev data $SCRATCH_MNT
 
 TFILE=$SCRATCH_MNT/testfile.$seq
 
diff --git a/tests/xfs/004 b/tests/xfs/004
index 7633071c..d3fb9c95 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -31,7 +31,7 @@ _populate_scratch()
 	# This test looks at specific behaviors of the xfs_db freesp command,
 	# which reports on the contents of the free space btrees for the data
 	# device.  Don't let anything get created on the realtime volume.
-	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+	_xfs_force_bdev data $SCRATCH_MNT
 	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
 	dd if=/dev/zero of=$SCRATCH_MNT/goo count=400 bs=4096 >/dev/null 2>&1 &
 	dd if=/dev/zero of=$SCRATCH_MNT/moo count=800 bs=4096 >/dev/null 2>&1 &
diff --git a/tests/xfs/146 b/tests/xfs/146
index 8f85024d..49020e01 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -78,7 +78,7 @@ _scratch_mkfs -r size=$rtsize >> $seqres.full
 _scratch_mount >> $seqres.full
 
 # Make sure the root directory has rtinherit set so our test file will too
-$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+_xfs_force_bdev realtime $SCRATCH_MNT
 
 # Allocate some stuff at the start, to force the first falloc of the ouch file
 # to happen somewhere in the middle of the rt volume
diff --git a/tests/xfs/147 b/tests/xfs/147
index da962f96..5cc363aa 100755
--- a/tests/xfs/147
+++ b/tests/xfs/147
@@ -50,7 +50,7 @@ rextblks=$((rextsize / blksz))
 echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
 
 # Make sure the root directory has rtinherit set so our test file will too
-$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+_xfs_force_bdev realtime $SCRATCH_MNT
 
 sz=$((rextsize * 100))
 range="$((blksz * 3)) $blksz"
diff --git a/tests/xfs/272 b/tests/xfs/272
index 6c0fede5..6a1372b8 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -38,7 +38,7 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
 # Make sure everything is on the data device
-$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+_xfs_force_bdev data $SCRATCH_MNT
 
 _pwrite_byte 0x80 0 737373 $SCRATCH_MNT/urk >> $seqres.full
 sync
diff --git a/tests/xfs/318 b/tests/xfs/318
index 07375b1f..07b4f7f1 100755
--- a/tests/xfs/318
+++ b/tests/xfs/318
@@ -44,7 +44,7 @@ _scratch_mount >> $seqres.full
 
 # This test depends on specific behaviors of the data device, so create all
 # files on it.
-$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "Create files"
 touch $SCRATCH_MNT/file1
diff --git a/tests/xfs/431 b/tests/xfs/431
index e67906dc..797b8fcd 100755
--- a/tests/xfs/431
+++ b/tests/xfs/431
@@ -47,7 +47,7 @@ _scratch_mount
 
 # Set realtime inherit flag on scratch mount, suppress output
 # as this may simply error out on future kernels
-$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
+_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
 
 # Check if 't' is actually set, as xfs_io returns 0 even when it fails to set
 # an attribute. And erroring out here is fine, this would be desired behavior
@@ -60,7 +60,7 @@ if $XFS_IO_PROG -c 'lsattr' $SCRATCH_MNT | grep -q 't'; then
 	# Remove the testfile and rt inherit flag after we are done or
 	# xfs_repair will fail.
 	rm -f $SCRATCH_MNT/testfile
-	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
+	_xfs_force_bdev data $SCRATCH_MNT | tee -a $seqres.full 2>&1
 fi
 
 # success, all done
diff --git a/tests/xfs/521 b/tests/xfs/521
index b8026d45..99408a06 100755
--- a/tests/xfs/521
+++ b/tests/xfs/521
@@ -55,7 +55,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Check rt volume stats"
-$XFS_IO_PROG -c 'chattr +t' $testdir
+_xfs_force_bdev realtime $testdir
 $XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
 before=$(stat -f -c '%b' $testdir)
 
diff --git a/tests/xfs/528 b/tests/xfs/528
index 7f98c5b8..d483ae82 100755
--- a/tests/xfs/528
+++ b/tests/xfs/528
@@ -77,7 +77,7 @@ test_ops() {
 		_notrun "Could not mount rextsize=$rextsize with synthetic rt volume"
 
 	# Force all files to be realtime files
-	$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+	_xfs_force_bdev realtime $SCRATCH_MNT
 
 	log "Test regular write, rextsize=$rextsize"
 	mk_file $SCRATCH_MNT/write $rextsize
diff --git a/tests/xfs/532 b/tests/xfs/532
index 560af586..f421070a 100755
--- a/tests/xfs/532
+++ b/tests/xfs/532
@@ -47,7 +47,7 @@ _scratch_mount >> $seqres.full
 
 # Disable realtime inherit flag (if any) on root directory so that space on data
 # device gets fragmented rather than realtime device.
-$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+_xfs_force_bdev data $SCRATCH_MNT
 
 bsize=$(_get_block_size $SCRATCH_MNT)
 
diff --git a/tests/xfs/533 b/tests/xfs/533
index dd4cb4c4..1c8cc925 100755
--- a/tests/xfs/533
+++ b/tests/xfs/533
@@ -58,7 +58,7 @@ _scratch_mount >> $seqres.full
 
 # Disable realtime inherit flag (if any) on root directory so that space on data
 # device gets fragmented rather than realtime device.
-$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
diff --git a/tests/xfs/538 b/tests/xfs/538
index 97273b88..dc0e5f28 100755
--- a/tests/xfs/538
+++ b/tests/xfs/538
@@ -44,7 +44,7 @@ _scratch_mount >> $seqres.full
 
 # Disable realtime inherit flag (if any) on root directory so that space on data
 # device gets fragmented rather than realtime device.
-$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+_xfs_force_bdev data $SCRATCH_MNT
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 

