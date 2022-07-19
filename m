Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F5FCCA47F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiGSVhf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiGSVhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA5E5FAE0;
        Tue, 19 Jul 2022 14:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 830C9B81C77;
        Tue, 19 Jul 2022 21:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C55CC341C6;
        Tue, 19 Jul 2022 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266648;
        bh=DLqejfe7LPNYaqvIprKLq6mtoyhcXfXRnQoT7t038t4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A5JmVu4icJ9XKk5I8wVLbtppyuSJE7NjCmm511LIjkhfXeLb6+3ToBNXyYQZ+lJmx
         IZME1sFYZ3hQ17ICeS1XexOTEKM3O5jQ983SLZoT+eJ9Pur+2I1+DqD51htWUo5un4
         V1tS/MIuNrJrXiBUDEG57sSXkIQn4qhuEZLBgmFPupU0pP6G50mtg/01qlrxSktPoc
         mH2uVvsKZusehtNIQVVVN7JHJMsYCHTZXNRof/Qi8vbCR1EPsB1lpeZTsCxa334OvA
         OBMheZsAw9oDsrl+mTyJtbmfIuRbcMoQSEehhQdORjnHzSfyU1W65PR3X6Uzm2prv/
         qTQ/1Pbpx/7oA==
Subject: [PATCH 2/8] misc: skip remap/fallocate tests when op length not
 congruent with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:27 -0700
Message-ID: <165826664773.3249494.16967291077436004395.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nearly all of the reflink and fpunch/fcollapse/finsert tests that I have
written assumed that it was ok to use 64k as the fundamental unit of
allocation.  This works fine for testing the XFS data device, since the
file allocation unit is always a power of two, and never larger than
64k.  Making this assumption allows those tests to encode md5sums in the
golden output for easy file data integrity checking.

Unfortunately, this isn't necessarily the case when we're testing
reflink and fallocate on the XFS realtime device.  For those
configurations, the file allocation unit is a realtime extent, which can
be any integer multiple of the block size.  If the request length isn't
an exact multiple of the allocation unit size, reflink and fallocate
will fail due to alignment issues, so there's no point in running these
tests.

Assuming this edgecase configuration of an edgecase feature is
vanishingly rare, let's just _notrun the tests instead of rewriting a
ton of tests to do their integrity checking by hand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |   26 ++++++++++++++++++++++++++
 tests/generic/031 |    1 +
 tests/generic/116 |    1 +
 tests/generic/118 |    1 +
 tests/generic/119 |    1 +
 tests/generic/121 |    1 +
 tests/generic/122 |    1 +
 tests/generic/134 |    1 +
 tests/generic/136 |    1 +
 tests/generic/137 |    1 +
 tests/generic/144 |    1 +
 tests/generic/149 |    1 +
 tests/generic/162 |    1 +
 tests/generic/163 |    1 +
 tests/generic/164 |    1 +
 tests/generic/165 |    1 +
 tests/generic/168 |    1 +
 tests/generic/170 |    1 +
 tests/generic/181 |    1 +
 tests/generic/183 |    1 +
 tests/generic/185 |    1 +
 tests/generic/186 |    1 +
 tests/generic/187 |    1 +
 tests/generic/188 |    1 +
 tests/generic/189 |    1 +
 tests/generic/190 |    1 +
 tests/generic/191 |    1 +
 tests/generic/194 |    1 +
 tests/generic/195 |    1 +
 tests/generic/196 |    1 +
 tests/generic/197 |    1 +
 tests/generic/199 |    1 +
 tests/generic/200 |    1 +
 tests/generic/201 |    1 +
 tests/generic/284 |    1 +
 tests/generic/287 |    1 +
 tests/generic/289 |    1 +
 tests/generic/290 |    1 +
 tests/generic/291 |    1 +
 tests/generic/292 |    1 +
 tests/generic/293 |    1 +
 tests/generic/295 |    1 +
 tests/generic/352 |    1 +
 tests/generic/358 |    1 +
 tests/generic/359 |    1 +
 tests/generic/372 |    1 +
 tests/generic/414 |    1 +
 tests/generic/501 |    1 +
 tests/generic/515 |    1 +
 tests/generic/516 |    1 +
 tests/generic/540 |    1 +
 tests/generic/541 |    1 +
 tests/generic/542 |    1 +
 tests/generic/543 |    1 +
 tests/generic/544 |    1 +
 tests/generic/546 |    1 +
 tests/generic/578 |    1 +
 tests/generic/588 |    2 ++
 tests/generic/673 |    1 +
 tests/generic/674 |    1 +
 tests/generic/675 |    1 +
 tests/generic/683 |    1 +
 tests/generic/684 |    1 +
 tests/generic/685 |    1 +
 tests/generic/686 |    1 +
 tests/generic/687 |    1 +
 tests/generic/688 |    1 +
 tests/xfs/114     |    2 ++
 tests/xfs/208     |    1 +
 tests/xfs/210     |    1 +
 tests/xfs/212     |    1 +
 tests/xfs/215     |    1 +
 tests/xfs/218     |    1 +
 tests/xfs/219     |    1 +
 tests/xfs/221     |    1 +
 tests/xfs/223     |    1 +
 tests/xfs/224     |    1 +
 tests/xfs/225     |    1 +
 tests/xfs/226     |    1 +
 tests/xfs/228     |    1 +
 tests/xfs/230     |    1 +
 tests/xfs/248     |    1 +
 tests/xfs/249     |    1 +
 tests/xfs/251     |    1 +
 tests/xfs/254     |    1 +
 tests/xfs/255     |    1 +
 tests/xfs/256     |    1 +
 tests/xfs/257     |    1 +
 tests/xfs/258     |    1 +
 tests/xfs/280     |    1 +
 tests/xfs/312     |    1 +
 tests/xfs/315     |    1 +
 tests/xfs/322     |    1 +
 tests/xfs/329     |    1 +
 tests/xfs/436     |    1 +
 95 files changed, 122 insertions(+)


diff --git a/common/rc b/common/rc
index 5bac0355..f4469464 100644
--- a/common/rc
+++ b/common/rc
@@ -4557,6 +4557,32 @@ _get_file_block_size()
 	esac
 }
 
+# Given a file path and a byte length of a file operation under test, ensure
+# that the length is an integer multiple of the file's allocation unit size.
+# In other words, skip the test unless (oplen ≡ alloc_unit mod 0).  This is
+# intended for file remapping operations.
+_require_congruent_file_oplen()
+{
+	local file="$1"
+	local alloc_unit=$(_get_file_block_size "$file")
+	local oplen="$2"
+
+	case $FSTYP in
+	nfs*|cifs|9p|virtiofs|ceph|glusterfs|overlay|pvfs2)
+		# Network filesystems don't know about (or tell the client
+		# about) the underlying file allocation unit and they generally
+		# pass the file IO request to the underlying filesystem, so we
+		# don't have anything to check here.
+		return
+		;;
+	esac
+
+	test $alloc_unit -gt $oplen && \
+		_notrun "$1: file alloc unit $alloc_unit larger than op length $oplen"
+	test $((oplen % alloc_unit)) -eq 0 || \
+		_notrun "$1: file alloc unit $alloc_unit not congruent with op length $oplen"
+}
+
 # Get the minimum block size of an fs.
 _get_block_size()
 {
diff --git a/tests/generic/031 b/tests/generic/031
index cbb2fc34..0d2e8268 100755
--- a/tests/generic/031
+++ b/tests/generic/031
@@ -25,6 +25,7 @@ testfile=$SCRATCH_MNT/testfile
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 4096
 
 $XFS_IO_PROG -f \
 	-c "pwrite 185332 55756" \
diff --git a/tests/generic/116 b/tests/generic/116
index b8816e31..88b64f4c 100755
--- a/tests/generic/116
+++ b/tests/generic/116
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_cycle_mount
diff --git a/tests/generic/118 b/tests/generic/118
index 4fa2e1e3..35d933ff 100755
--- a/tests/generic/118
+++ b/tests/generic/118
@@ -32,6 +32,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_cycle_mount
diff --git a/tests/generic/119 b/tests/generic/119
index fd4c3661..481d12d2 100755
--- a/tests/generic/119
+++ b/tests/generic/119
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $((blksz * 8)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz * 8)) $testdir/file2 >> $seqres.full
 _pwrite_byte 0x63 0 $((blksz * 8)) $testdir/file3 >> $seqres.full
diff --git a/tests/generic/121 b/tests/generic/121
index 43137469..e9038240 100755
--- a/tests/generic/121
+++ b/tests/generic/121
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_cycle_mount
diff --git a/tests/generic/122 b/tests/generic/122
index fbf3f1f2..89309c22 100755
--- a/tests/generic/122
+++ b/tests/generic/122
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _test_cycle_mount
diff --git a/tests/generic/134 b/tests/generic/134
index ab76f046..58b81872 100755
--- a/tests/generic/134
+++ b/tests/generic/134
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file2 >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file3 >> $seqres.full
diff --git a/tests/generic/136 b/tests/generic/136
index 98ebb0da..c5b80074 100755
--- a/tests/generic/136
+++ b/tests/generic/136
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x61 0 $((blksz + 37)) $testdir/file2 >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz + 37)) $testdir/file3 >> $seqres.full
diff --git a/tests/generic/137 b/tests/generic/137
index fb0071b1..8ee705fd 100755
--- a/tests/generic/137
+++ b/tests/generic/137
@@ -37,6 +37,7 @@ mkdir $testdir
 
 echo "Create the original file blocks"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $blksz $((blksz * 2)) $testdir/file1 >> $seqres.full
 
diff --git a/tests/generic/144 b/tests/generic/144
index 842d51f3..21c49577 100755
--- a/tests/generic/144
+++ b/tests/generic/144
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $((blksz * 5 + 37)) $testdir/file1 >> $seqres.full
 
 _reflink_range $testdir/file1 $blksz $testdir/file2 $blksz \
diff --git a/tests/generic/149 b/tests/generic/149
index 5343a139..108f1368 100755
--- a/tests/generic/149
+++ b/tests/generic/149
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
diff --git a/tests/generic/162 b/tests/generic/162
index 0dc17f75..7b625e86 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -38,6 +38,7 @@ mkdir $testdir
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/163 b/tests/generic/163
index 4a6c341e..91da69d3 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -38,6 +38,7 @@ mkdir $testdir
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/164 b/tests/generic/164
index 8e0b630b..56c05e37 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -40,6 +40,7 @@ mkdir $testdir
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/165 b/tests/generic/165
index d9e6a6e9..bc24bcab 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -41,6 +41,7 @@ mkdir $testdir
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/168 b/tests/generic/168
index 575ff08c..bdc8f7a0 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -39,6 +39,7 @@ mkdir $testdir
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/170 b/tests/generic/170
index d323ab8f..593cfbb7 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -40,6 +40,7 @@ mkdir $testdir
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/181 b/tests/generic/181
index 2b4617be..5e5883df 100755
--- a/tests/generic/181
+++ b/tests/generic/181
@@ -33,6 +33,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $((blksz * 256)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz * 256)) $testdir/file2 >> $seqres.full
 _pwrite_byte 0x62 0 $((blksz * 2)) $testdir/file2.chk >> $seqres.full
diff --git a/tests/generic/183 b/tests/generic/183
index 77bfcfcb..c8614514 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -39,6 +39,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/185 b/tests/generic/185
index 09469924..75dbc6b8 100755
--- a/tests/generic/185
+++ b/tests/generic/185
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/186 b/tests/generic/186
index 37d88440..c5a1e13a 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -81,6 +81,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=1024
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/187 b/tests/generic/187
index 152e3cc2..be7a635a 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -82,6 +82,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=1024
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/188 b/tests/generic/188
index eab77b39..52a7f2d2 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -39,6 +39,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/189 b/tests/generic/189
index 75cca42a..63faac6e 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/190 b/tests/generic/190
index 9e220740..b336f12b 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -39,6 +39,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/191 b/tests/generic/191
index 78b9a3f0..1b12d9ac 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/194 b/tests/generic/194
index ff76438d..aa80560b 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -41,6 +41,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/195 b/tests/generic/195
index e087b99c..4f21201e 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -40,6 +40,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/196 b/tests/generic/196
index e2ae0410..366d0cad 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -39,6 +39,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/197 b/tests/generic/197
index c5f80207..ac314186 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/199 b/tests/generic/199
index 2a8cafcc..2246fdd1 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -46,6 +46,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/200 b/tests/generic/200
index a1a78ef4..eeefeb50 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -46,6 +46,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/201 b/tests/generic/201
index 2598b44a..0a5a1d4a 100755
--- a/tests/generic/201
+++ b/tests/generic/201
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/284 b/tests/generic/284
index 729da77a..f9eefff3 100755
--- a/tests/generic/284
+++ b/tests/generic/284
@@ -32,6 +32,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/287 b/tests/generic/287
index 76ea26ba..61301368 100755
--- a/tests/generic/287
+++ b/tests/generic/287
@@ -33,6 +33,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/289 b/tests/generic/289
index ed4f3268..52d03c35 100755
--- a/tests/generic/289
+++ b/tests/generic/289
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/290 b/tests/generic/290
index 534fb24f..5352b9ba 100755
--- a/tests/generic/290
+++ b/tests/generic/290
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/291 b/tests/generic/291
index 50119c03..1c589cf6 100755
--- a/tests/generic/291
+++ b/tests/generic/291
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/292 b/tests/generic/292
index 24cdab53..725fe057 100755
--- a/tests/generic/292
+++ b/tests/generic/292
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/293 b/tests/generic/293
index 0f1d8416..05997501 100755
--- a/tests/generic/293
+++ b/tests/generic/293
@@ -36,6 +36,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/295 b/tests/generic/295
index f66c1805..9ccf823f 100755
--- a/tests/generic/295
+++ b/tests/generic/295
@@ -37,6 +37,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/352 b/tests/generic/352
index 3f504a29..608c6c81 100755
--- a/tests/generic/352
+++ b/tests/generic/352
@@ -29,6 +29,7 @@ _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
 blocksize=$((128 * 1024))
+_require_congruent_file_oplen $SCRATCH_MNT $blocksize
 file="$SCRATCH_MNT/tmp"
 
 # Golden output is for $LOAD_FACTOR == 1 case
diff --git a/tests/generic/358 b/tests/generic/358
index 8c73ba36..91fe5e2b 100755
--- a/tests/generic/358
+++ b/tests/generic/358
@@ -39,6 +39,7 @@ mkdir $testdir
 
 blocks=64
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize file"
 _pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file >> $seqres.full
diff --git a/tests/generic/359 b/tests/generic/359
index 25692058..8ef4f846 100755
--- a/tests/generic/359
+++ b/tests/generic/359
@@ -41,6 +41,7 @@ mkdir $testdir
 
 blocks=64
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=4
 halfway=$((blocks / 2 * blksz))
 quarter=$((blocks / 4 * blksz))
diff --git a/tests/generic/372 b/tests/generic/372
index b83aa598..b649f590 100755
--- a/tests/generic/372
+++ b/tests/generic/372
@@ -39,6 +39,7 @@ mkdir $testdir
 
 blocks=5
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 sz=$((blocks * blksz))
 
 echo "Create the original files"
diff --git a/tests/generic/414 b/tests/generic/414
index 01b9da8e..6416216d 100755
--- a/tests/generic/414
+++ b/tests/generic/414
@@ -39,6 +39,7 @@ mkdir $testdir
 
 blocks=32
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 sz=$((blocks * blksz))
 
 echo "Create the original files"
diff --git a/tests/generic/501 b/tests/generic/501
index 8c3f627b..cb158ba5 100755
--- a/tests/generic/501
+++ b/tests/generic/501
@@ -34,6 +34,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
+_require_congruent_file_oplen $SCRATCH_MNT 2097152
 
 # Use file sizes and offsets/lengths for the clone operation that are multiples
 # of 64Kb, so that the test works on machine with any page size.
diff --git a/tests/generic/515 b/tests/generic/515
index 2f3bd400..758bd639 100755
--- a/tests/generic/515
+++ b/tests/generic/515
@@ -30,6 +30,7 @@ _scratch_mount
 DONOR1=$SCRATCH_MNT/a
 TARGET=$SCRATCH_MNT/b
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 $XFS_IO_PROG -f -c "pwrite -S 0x72 0 $blksz" $DONOR1 >> $seqres.full
 
diff --git a/tests/generic/516 b/tests/generic/516
index 790ad532..e846ee24 100755
--- a/tests/generic/516
+++ b/tests/generic/516
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
 _pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
 _pwrite_byte 0x62 $(((blksz * 6) - 33)) 1 $testdir/file2 >> $seqres.full
diff --git a/tests/generic/540 b/tests/generic/540
index 38e00f97..da36939a 100755
--- a/tests/generic/540
+++ b/tests/generic/540
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
diff --git a/tests/generic/541 b/tests/generic/541
index 89b2adad..a0f6cae3 100755
--- a/tests/generic/541
+++ b/tests/generic/541
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
diff --git a/tests/generic/542 b/tests/generic/542
index e7682f59..530fb8e0 100755
--- a/tests/generic/542
+++ b/tests/generic/542
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
diff --git a/tests/generic/543 b/tests/generic/543
index 624cfc41..1dad37fb 100755
--- a/tests/generic/543
+++ b/tests/generic/543
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
diff --git a/tests/generic/544 b/tests/generic/544
index 4dbaea4d..a4f654af 100755
--- a/tests/generic/544
+++ b/tests/generic/544
@@ -27,6 +27,7 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=2
 filesize=$((blksz * nr))
 testdir=$SCRATCH_MNT/test-$seq
diff --git a/tests/generic/546 b/tests/generic/546
index 7723b980..9dc507be 100755
--- a/tests/generic/546
+++ b/tests/generic/546
@@ -39,6 +39,7 @@ _scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
 _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
+_require_congruent_file_oplen $SCRATCH_MNT 4096
 
 # Create preallocated extent where we can write into
 $XFS_IO_PROG -f -c 'falloc 8k 64m' "$SCRATCH_MNT/foobar" >> $seqres.full
diff --git a/tests/generic/578 b/tests/generic/578
index 01929a28..d04cacb4 100755
--- a/tests/generic/578
+++ b/tests/generic/578
@@ -41,6 +41,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 filesz=$((blksz * 4))
 _pwrite_byte 0x61 0 $filesz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
diff --git a/tests/generic/588 b/tests/generic/588
index 563ff65e..a915a73e 100755
--- a/tests/generic/588
+++ b/tests/generic/588
@@ -35,6 +35,8 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
 # Create our test file with two 256Kb extents, one at file offset 0 and the
 # other at file offset 256Kb.
 $XFS_IO_PROG -f -c "pwrite -S 0xa3 0 256K" \
diff --git a/tests/generic/673 b/tests/generic/673
index e40e672a..4d8dc07e 100755
--- a/tests/generic/673
+++ b/tests/generic/673
@@ -22,6 +22,7 @@ _require_scratch_reflink
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
 chmod a+rw $SCRATCH_MNT/
 
 setup_testfile() {
diff --git a/tests/generic/674 b/tests/generic/674
index 920ed5f2..a3130249 100755
--- a/tests/generic/674
+++ b/tests/generic/674
@@ -23,6 +23,7 @@ _require_xfs_io_command dedupe
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
 chmod a+rw $SCRATCH_MNT/
 
 setup_testfile() {
diff --git a/tests/generic/675 b/tests/generic/675
index 23b7e545..189251f2 100755
--- a/tests/generic/675
+++ b/tests/generic/675
@@ -24,6 +24,7 @@ _require_scratch_reflink
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
 chmod a+rw $SCRATCH_MNT/
 
 setup_testfile() {
diff --git a/tests/generic/683 b/tests/generic/683
index 746ead86..4c93346d 100755
--- a/tests/generic/683
+++ b/tests/generic/683
@@ -28,6 +28,7 @@ _require_user
 _require_test
 verb=falloc
 _require_xfs_io_command $verb
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/generic/684 b/tests/generic/684
index 4bebeff0..03481e69 100755
--- a/tests/generic/684
+++ b/tests/generic/684
@@ -28,6 +28,7 @@ _require_user
 _require_test
 verb=fpunch
 _require_xfs_io_command $verb
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/generic/685 b/tests/generic/685
index 03447e00..6a108842 100755
--- a/tests/generic/685
+++ b/tests/generic/685
@@ -28,6 +28,7 @@ _require_user
 _require_test
 verb=fzero
 _require_xfs_io_command $verb
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/generic/686 b/tests/generic/686
index eae3cbda..4279f76b 100755
--- a/tests/generic/686
+++ b/tests/generic/686
@@ -28,6 +28,7 @@ _require_user
 _require_test
 verb=finsert
 _require_xfs_io_command $verb
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/generic/687 b/tests/generic/687
index 0bd421e5..78cb6202 100755
--- a/tests/generic/687
+++ b/tests/generic/687
@@ -28,6 +28,7 @@ _require_user
 _require_test
 verb=fcollapse
 _require_xfs_io_command $verb
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/generic/688 b/tests/generic/688
index 905c46ac..426286b6 100755
--- a/tests/generic/688
+++ b/tests/generic/688
@@ -28,6 +28,7 @@ _require_command "$GETCAP_PROG" getcap
 _require_command "$SETCAP_PROG" setcap
 _require_xfs_io_command falloc
 _require_test
+_require_congruent_file_oplen $TEST_DIR 65536
 
 junk_dir=$TEST_DIR/$seq
 junk_file=$junk_dir/a
diff --git a/tests/xfs/114 b/tests/xfs/114
index a0ea1d13..3aec814a 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -35,6 +35,8 @@ len1=$((blocks1 * blksz))
 len2=$((blocks2 * blksz))
 file_blksz=$(_get_file_block_size $SCRATCH_MNT)
 
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
+
 echo "Create some files"
 $XFS_IO_PROG -f \
 	-c "falloc 0 $len1" \
diff --git a/tests/xfs/208 b/tests/xfs/208
index 66c3eda1..0fbb99c8 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -35,6 +35,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/210 b/tests/xfs/210
index 6edc5606..2439967b 100755
--- a/tests/xfs/210
+++ b/tests/xfs/210
@@ -27,6 +27,7 @@ _require_xfs_io_command "cowextsize"
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_require_congruent_file_oplen $SCRATCH_MNT 65536
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
diff --git a/tests/xfs/212 b/tests/xfs/212
index b133e09b..805a72af 100755
--- a/tests/xfs/212
+++ b/tests/xfs/212
@@ -30,6 +30,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=16
 filesize=$((blksz * nr))
 bufnr=2
diff --git a/tests/xfs/215 b/tests/xfs/215
index 20217187..c07cdd1a 100755
--- a/tests/xfs/215
+++ b/tests/xfs/215
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/218 b/tests/xfs/218
index b834bbeb..cc3e1552 100755
--- a/tests/xfs/218
+++ b/tests/xfs/218
@@ -33,6 +33,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/219 b/tests/xfs/219
index b0eeb784..bd2c47bf 100755
--- a/tests/xfs/219
+++ b/tests/xfs/219
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/221 b/tests/xfs/221
index 09b2067d..cda99b5c 100755
--- a/tests/xfs/221
+++ b/tests/xfs/221
@@ -33,6 +33,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/223 b/tests/xfs/223
index 11dbad14..e22c1ba9 100755
--- a/tests/xfs/223
+++ b/tests/xfs/223
@@ -36,6 +36,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/224 b/tests/xfs/224
index f8bab07e..7e984a8a 100755
--- a/tests/xfs/224
+++ b/tests/xfs/224
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/225 b/tests/xfs/225
index 52a37d64..a07ef3f0 100755
--- a/tests/xfs/225
+++ b/tests/xfs/225
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/226 b/tests/xfs/226
index 826bd08d..1e566e2e 100755
--- a/tests/xfs/226
+++ b/tests/xfs/226
@@ -33,6 +33,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/228 b/tests/xfs/228
index f2f2f6a9..85a4abc5 100755
--- a/tests/xfs/228
+++ b/tests/xfs/228
@@ -41,6 +41,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/230 b/tests/xfs/230
index 15f6b684..2347a307 100755
--- a/tests/xfs/230
+++ b/tests/xfs/230
@@ -41,6 +41,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/248 b/tests/xfs/248
index 32902cb7..cdb1da02 100755
--- a/tests/xfs/248
+++ b/tests/xfs/248
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/249 b/tests/xfs/249
index 774d3bf2..0c4b0335 100755
--- a/tests/xfs/249
+++ b/tests/xfs/249
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/251 b/tests/xfs/251
index 0b090180..1efa331d 100755
--- a/tests/xfs/251
+++ b/tests/xfs/251
@@ -36,6 +36,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/254 b/tests/xfs/254
index 40d176fc..d08ccc52 100755
--- a/tests/xfs/254
+++ b/tests/xfs/254
@@ -37,6 +37,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/255 b/tests/xfs/255
index 255f3b2f..8ec6f0be 100755
--- a/tests/xfs/255
+++ b/tests/xfs/255
@@ -36,6 +36,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/256 b/tests/xfs/256
index 1c703242..7157d532 100755
--- a/tests/xfs/256
+++ b/tests/xfs/256
@@ -37,6 +37,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/257 b/tests/xfs/257
index 6a58f0ac..c3100d60 100755
--- a/tests/xfs/257
+++ b/tests/xfs/257
@@ -38,6 +38,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/258 b/tests/xfs/258
index 2865cdf9..a3a130ea 100755
--- a/tests/xfs/258
+++ b/tests/xfs/258
@@ -39,6 +39,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
diff --git a/tests/xfs/280 b/tests/xfs/280
index bc26e629..0d9a7958 100755
--- a/tests/xfs/280
+++ b/tests/xfs/280
@@ -30,6 +30,7 @@ mkdir $testdir
 
 blocks=5
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 sz=$((blocks * blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/312 b/tests/xfs/312
index 94f868fe..e4884787 100755
--- a/tests/xfs/312
+++ b/tests/xfs/312
@@ -36,6 +36,7 @@ sz=$((blksz * blks))
 echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Create files"
 _pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
diff --git a/tests/xfs/315 b/tests/xfs/315
index 105515ab..9f6b39c8 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -37,6 +37,7 @@ sz=$((blksz * blks))
 echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 
diff --git a/tests/xfs/322 b/tests/xfs/322
index 89a2f741..a2c3720e 100755
--- a/tests/xfs/322
+++ b/tests/xfs/322
@@ -36,6 +36,7 @@ sz=$((blksz * blks))
 echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Create files"
 _pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
diff --git a/tests/xfs/329 b/tests/xfs/329
index e9a30d05..4cad686c 100755
--- a/tests/xfs/329
+++ b/tests/xfs/329
@@ -31,6 +31,7 @@ _scratch_mount >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 
diff --git a/tests/xfs/436 b/tests/xfs/436
index d99183cf..9e6ec937 100755
--- a/tests/xfs/436
+++ b/tests/xfs/436
@@ -42,6 +42,7 @@ _scratch_mount -o noquota >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 

