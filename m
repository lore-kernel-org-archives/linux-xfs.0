Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CDEC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjKHVpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjKHVpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:45:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B1C2588
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:45:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D0C433CA;
        Wed,  8 Nov 2023 21:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699479932;
        bh=F33F//RdyEZyHL7K95n55lewCyaFIckTwZQHlTIGNrM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=obxszBknjAnCYPhdYf/YeaW7hbxbX6Mca52FrYc7c3kPso/92dQvrti6xKuDUcoaH
         taHqY4ad4olr707PgDGF3tCCBUgNLLOUBae9K5GwpjlrHScZwWDdFgziP7XpmaiIBH
         cJZEa5i+37xTuRqd7vVQ1LFj43/UdRNv6ddnMc8/oHN8DAMniyinsqxfI82+bdzz/F
         9zhFB9lyoc1cxWs0GI33u7/qLCiZuAeqE5E+dtbl14AgE4/oWWNUJRUaS9LkRYcV8v
         8U+jCTxLhZHhIItRsPiUKvo5h6wxQfYPkQ8w8UhLJbUiW+a4aQcIGJ4z0pKyO/09ZY
         VgZidhZDCVu+Q==
Subject: [PATCH 2/2] misc: update xfs_io swapext usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guan@eryu.me
Date:   Wed, 08 Nov 2023 13:45:32 -0800
Message-ID: <169947993229.220003.3606426023762574699.stgit@frogsfrogsfrogs>
In-Reply-To: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
References: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
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

