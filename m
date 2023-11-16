Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601B7C197A0
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjKPRas (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjKPRas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:30:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8108F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:30:44 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3BC433C7;
        Thu, 16 Nov 2023 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700155843;
        bh=c6h3F1+iBq6UxC0pzPEjyyv+a1kRHJyMRAdK5BpWepI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JCYGpbaArC8e4mUcu4h42ZJNALsZ2X9fW+6qLRdkVxEDXCVLxr7ggbEZmBGpnVoEY
         kmNVADazd3e4WEYybh8Cchr51dOLqOTfR2Qq6fNCgMCCQ/R4KFgWRru6KJQikpawAJ
         3pNxwFIZvK8iDXAd8QV8Xsl37FdESaeCNXhdnwpAzv9Cp57vL2NBqwEmbVaaPvz6HO
         0xZXg3P44u5xVjhxBApb7lKODFpfF809Xl/O05Spf1Of3QEZKkBFMhdPfr9On+iIFA
         xUMWGFbfVQyG6o/34veVnA9oJO+ClOxthVn0Tf8GJAeqJ9JM4tvPg0TDSFVjJe2rCm
         mSmjYUuFHsa2Q==
Subject: [PATCH 2/2] misc: update xfs_io swapext usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        guan@eryu.me, linux-xfs@vger.kernel.org
Date:   Thu, 16 Nov 2023 09:30:43 -0800
Message-ID: <170015584315.3369423.5341890034455709088.stgit@frogsfrogsfrogs>
In-Reply-To: <170015583180.3369423.8659956273233504193.stgit@frogsfrogsfrogs>
References: <170015583180.3369423.8659956273233504193.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since the new 'exchange range' functionality is no longer a VFS level
concept, the xfs_io swapext -v options have changed.  Update fstests to
reflect this new reality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs        |    2 +-
 tests/generic/709 |    2 +-
 tests/generic/710 |    2 +-
 tests/generic/711 |    2 +-
 tests/generic/712 |    2 +-
 tests/generic/713 |    4 ++--
 tests/generic/714 |    4 ++--
 tests/generic/715 |    4 ++--
 tests/generic/716 |    2 +-
 tests/generic/717 |    2 +-
 tests/generic/718 |    2 +-
 tests/generic/719 |    2 +-
 tests/generic/720 |    2 +-
 tests/generic/722 |    4 ++--
 tests/generic/723 |    6 +++---
 tests/generic/724 |    4 ++--
 tests/generic/725 |    2 +-
 tests/generic/726 |    2 +-
 tests/generic/727 |    2 +-
 tests/xfs/789     |    2 +-
 tests/xfs/790     |    2 +-
 tests/xfs/791     |    4 ++--
 tests/xfs/792     |    2 +-
 23 files changed, 31 insertions(+), 31 deletions(-)


diff --git a/common/xfs b/common/xfs
index c7671f8f9d..f53b33fc54 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1802,7 +1802,7 @@ _require_xfs_scratch_atomicswap()
 {
 	_require_xfs_mkfs_atomicswap
 	_require_scratch
-	_require_xfs_io_command swapext '-v vfs -a'
+	_require_xfs_io_command swapext '-v exchrange -a'
 	_scratch_mkfs -m reflink=1 > /dev/null
 	_try_scratch_mount || \
 		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
diff --git a/tests/generic/709 b/tests/generic/709
index 3dbce2c287..4bd591b873 100755
--- a/tests/generic/709
+++ b/tests/generic/709
@@ -14,7 +14,7 @@ _begin_fstest auto quick fiexchange swapext quota
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_user
 _require_nobody
 _require_quota
diff --git a/tests/generic/710 b/tests/generic/710
index dc4a999a1d..c7fca05d4c 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -14,7 +14,7 @@ _begin_fstest auto quick fiexchange swapext quota
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_user
 _require_nobody
 _require_quota
diff --git a/tests/generic/711 b/tests/generic/711
index a24fe22665..f1318b30dd 100755
--- a/tests/generic/711
+++ b/tests/generic/711
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/712 b/tests/generic/712
index 13008c5bc2..d4a705478e 100755
--- a/tests/generic/712
+++ b/tests/generic/712
@@ -21,7 +21,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program punch-alternating
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/713 b/tests/generic/713
index bf37cd99cf..9b742ee0cb 100755
--- a/tests/generic/713
+++ b/tests/generic/713
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs -s 64k -l 64k'
+_require_xfs_io_command swapext '-v exchrange -s 64k -l 64k'
 _require_xfs_io_command "falloc"
 _require_test
 
@@ -36,7 +36,7 @@ filesnap() {
 
 test_swapext_once() {
 	filesnap "$1: before swapext" $dir/$3 $dir/$4
-	$XFS_IO_PROG -c "swapext -v vfs $2 $dir/$3" $dir/$4
+	$XFS_IO_PROG -c "swapext -v exchrange $2 $dir/$3" $dir/$4
 	filesnap "$1: after swapext" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
diff --git a/tests/generic/714 b/tests/generic/714
index 190b6f2b2c..b48a4b7d31 100755
--- a/tests/generic/714
+++ b/tests/generic/714
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_xfs_io_command "falloc"
 _require_test_reflink
 
@@ -37,7 +37,7 @@ filesnap() {
 
 test_swapext_once() {
 	filesnap "$1: before swapext" $dir/$3 $dir/$4
-	$XFS_IO_PROG -c "swapext -v vfs $2 $dir/$3" $dir/$4
+	$XFS_IO_PROG -c "swapext -v exchrange $2 $dir/$3" $dir/$4
 	filesnap "$1: after swapext" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
diff --git a/tests/generic/715 b/tests/generic/715
index 6005fb2d4e..595953dfcf 100755
--- a/tests/generic/715
+++ b/tests/generic/715
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs -s 64k -l 64k'
+_require_xfs_io_command swapext '-v exchrange -s 64k -l 64k'
 _require_test
 
 filesnap() {
@@ -51,7 +51,7 @@ test_swapext_once() {
 	_pwrite_byte 0x59 0 $((blksz * b_len)) $dir/b >> $seqres.full
 	filesnap "$tag: before swapext" $dir/a $dir/b
 
-	cmd="swapext -v vfs -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
+	cmd="swapext -v exchrange -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
 	echo "$cmd" >> $seqres.full
 	$XFS_IO_PROG -c "$cmd" $dir/b
 	filesnap "$tag: after swapext" $dir/a $dir/b
diff --git a/tests/generic/716 b/tests/generic/716
index 514a8b8365..25976ab898 100755
--- a/tests/generic/716
+++ b/tests/generic/716
@@ -24,7 +24,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_xfs_io_command startupdate
 _require_test_reflink
 _require_test
diff --git a/tests/generic/717 b/tests/generic/717
index d1bd499e89..2c45e715f4 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_xfs_io_command startupdate
 _require_test
 _require_scratch
diff --git a/tests/generic/718 b/tests/generic/718
index dc99347fd7..f53d1840d0 100755
--- a/tests/generic/718
+++ b/tests/generic/718
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/719 b/tests/generic/719
index aeb42fb7e4..fe0b9d082e 100755
--- a/tests/generic/719
+++ b/tests/generic/719
@@ -23,7 +23,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_xfs_io_command startupdate '-e'
 _require_test
 
diff --git a/tests/generic/720 b/tests/generic/720
index a5bcc55c38..4db69c6921 100755
--- a/tests/generic/720
+++ b/tests/generic/720
@@ -20,7 +20,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_test_program punch-alternating
 _require_test
 
diff --git a/tests/generic/722 b/tests/generic/722
index 75dc0260e1..40eab9bbb3 100755
--- a/tests/generic/722
+++ b/tests/generic/722
@@ -23,7 +23,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program "punch-alternating"
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_scratch
 _require_scratch_shutdown
 
@@ -43,7 +43,7 @@ od -tx1 -Ad -c $SCRATCH_MNT/a > /tmp/a0
 od -tx1 -Ad -c $SCRATCH_MNT/b > /tmp/b0
 
 echo swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v vfs -a -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "swapext -v exchrange -a -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_shutdown
 _scratch_cycle_mount
 
diff --git a/tests/generic/723 b/tests/generic/723
index 5390f44269..b452de0208 100755
--- a/tests/generic/723
+++ b/tests/generic/723
@@ -22,7 +22,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program "punch-alternating"
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_scratch
 
 _scratch_mkfs >> $seqres.full
@@ -41,7 +41,7 @@ echo "md5 a: $old_a md5 b: $old_b" >> $seqres.full
 # Test swapext with the -n option, which will do all the input parameter
 # checking and return 0 without changing anything.
 echo dry run swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v vfs -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "swapext -v exchrange -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
@@ -54,7 +54,7 @@ test $old_b = $new_b || echo "scratch file B should not have swapped"
 # Do it again, but without the -n option, to prove that we can actually
 # swap the file contents.
 echo actual swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v vfs -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "swapext -v exchrange -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
diff --git a/tests/generic/724 b/tests/generic/724
index 67e0dba446..12324fb156 100755
--- a/tests/generic/724
+++ b/tests/generic/724
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_scratch
 
 _scratch_mkfs >> $seqres.full
@@ -42,7 +42,7 @@ md5sum $SCRATCH_MNT/b | _filter_scratch
 
 # Test swapext.  -h means skip holes in /b, and -e means operate to EOF
 echo swap | tee -a $seqres.full
-$XFS_IO_PROG -c "swapext -v vfs -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+$XFS_IO_PROG -c "swapext -v exchrange -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/generic/725 b/tests/generic/725
index 9b68871486..bf60127b39 100755
--- a/tests/generic/725
+++ b/tests/generic/725
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_xfs_io_command startupdate '-e'
 _require_scratch
 
diff --git a/tests/generic/726 b/tests/generic/726
index f0d8df2e0d..4cf18bd0e5 100755
--- a/tests/generic/726
+++ b/tests/generic/726
@@ -25,7 +25,7 @@ _begin_fstest auto fiexchange swapext quick
 # Modify as appropriate.
 _supported_fs generic
 _require_user
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_xfs_io_command startupdate
 _require_scratch
 
diff --git a/tests/generic/727 b/tests/generic/727
index 2cda49eada..af9612c967 100755
--- a/tests/generic/727
+++ b/tests/generic/727
@@ -28,7 +28,7 @@ _supported_fs generic
 _require_user
 _require_command "$GETCAP_PROG" getcap
 _require_command "$SETCAP_PROG" setcap
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_xfs_io_command startupdate
 _require_scratch
 _require_attrs security
diff --git a/tests/xfs/789 b/tests/xfs/789
index 9df91ac32f..b966c65119 100755
--- a/tests/xfs/789
+++ b/tests/xfs/789
@@ -21,7 +21,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command swapext '-v exchrange'
 _require_test
 
 # We can't do any reasonable swapping if the files we're going to create are
diff --git a/tests/xfs/790 b/tests/xfs/790
index 2362d66dfc..db6ce741d7 100755
--- a/tests/xfs/790
+++ b/tests/xfs/790
@@ -24,7 +24,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_test_program "punch-alternating"
 _require_xfs_io_command startupdate
 _require_xfs_io_error_injection "bmap_finish_one"
diff --git a/tests/xfs/791 b/tests/xfs/791
index 4944c1517c..84e3bee9b9 100755
--- a/tests/xfs/791
+++ b/tests/xfs/791
@@ -25,7 +25,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_xfs_scratch_atomicswap
 _require_xfs_io_error_injection "bmap_finish_one"
 
@@ -48,7 +48,7 @@ md5sum $SCRATCH_MNT/b | _filter_scratch
 # Test swapext.  -h means skip holes in /b, and -e means operate to EOF
 echo swap | tee -a $seqres.full
 $XFS_IO_PROG -x -c 'inject bmap_finish_one' \
-	-c "swapext -v vfs -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+	-c "swapext -v exchrange -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/xfs/792 b/tests/xfs/792
index 4af084bf66..bfbfbce4aa 100755
--- a/tests/xfs/792
+++ b/tests/xfs/792
@@ -25,7 +25,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command swapext '-v exchrange -a'
 _require_xfs_io_command startupdate '-e'
 _require_xfs_scratch_atomicswap
 _require_xfs_io_error_injection "bmap_finish_one"

