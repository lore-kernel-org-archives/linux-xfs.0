Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B8DC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbiLaDTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiLaDTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:19:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0512733;
        Fri, 30 Dec 2022 19:19:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A03961D29;
        Sat, 31 Dec 2022 03:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6FEC433EF;
        Sat, 31 Dec 2022 03:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456759;
        bh=hkeQYlfGO5gzT08G7bNFShOpLOov9rlkudrD3TwM/ps=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u+OJFLDOiTjCbNdHuzM0sz+EQvZPBLjd+JYXslTv1dWKeqPk92dME7Y+h4RiXqyYH
         7ypUSuiFE7+dijDWoO43DOlqxO2LI8MpJL8zg1uEAlO0TZsXU4HMGWWMwYBLUeEtem
         FNiqeQD2g7td8ZaVHWfRVEBXZaEtI8MRG1GTye53+cvk9UpPHChXw7r01aESfIfyf6
         djrkng0BEWvCwBMWhcgrKluCfPoOx8l9xLB/QzpWDmrvwRwrd+3V1QxeOBWKnXamD7
         p513cR+T8EyJXTkYwbqrE4uUF2TFHIeQbZ8W6Kp22Uiqi+QNio4nguJ/RohrQYPGxn
         O3uV9cznlIlYw==
Subject: [PATCH 3/4] misc: add more congruent oplen testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:53 -0800
Message-ID: <167243885311.740527.16609809730427476719.stgit@magnolia>
In-Reply-To: <167243885270.740527.7129374192035439232.stgit@magnolia>
References: <167243885270.740527.7129374192035439232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Do more checking for file allocation operation op length congruency.
This prevents tests from failing with EINVAL when the realtime extent
size is something weird like 28k or 1GB.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/145 |    1 +
 tests/generic/147 |    1 +
 tests/generic/261 |    1 +
 tests/generic/262 |    1 +
 tests/generic/331 |    1 +
 tests/generic/353 |    3 ++-
 tests/generic/517 |    1 +
 tests/generic/657 |    1 +
 tests/generic/658 |    1 +
 tests/generic/659 |    1 +
 tests/generic/660 |    1 +
 tests/generic/663 |    1 +
 tests/generic/664 |    1 +
 tests/generic/665 |    1 +
 tests/generic/670 |    1 +
 tests/generic/672 |    1 +
 tests/xfs/1212    |    1 +
 tests/xfs/420     |    3 +++
 tests/xfs/421     |    3 +++
 19 files changed, 24 insertions(+), 1 deletion(-)


diff --git a/tests/generic/145 b/tests/generic/145
index f213f53be8..81fc5f6c2f 100755
--- a/tests/generic/145
+++ b/tests/generic/145
@@ -36,6 +36,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
diff --git a/tests/generic/147 b/tests/generic/147
index 113800944b..bb17bb1c0b 100755
--- a/tests/generic/147
+++ b/tests/generic/147
@@ -35,6 +35,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x62 $blksz $blksz $testdir/file1 >> $seqres.full
 _pwrite_byte 0x63 $((blksz * 2)) $blksz $testdir/file1 >> $seqres.full
diff --git a/tests/generic/261 b/tests/generic/261
index 93c1c349b1..deb360288e 100755
--- a/tests/generic/261
+++ b/tests/generic/261
@@ -29,6 +29,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=5
 filesize=$((blksz * nr))
 
diff --git a/tests/generic/262 b/tests/generic/262
index 46e88f8731..f296e37e02 100755
--- a/tests/generic/262
+++ b/tests/generic/262
@@ -29,6 +29,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=4
 filesize=$((blksz * nr))
 
diff --git a/tests/generic/331 b/tests/generic/331
index 8c665ce4fc..9b6801e16f 100755
--- a/tests/generic/331
+++ b/tests/generic/331
@@ -38,6 +38,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=640
 bufnr=128
 filesize=$((blksz * nr))
diff --git a/tests/generic/353 b/tests/generic/353
index 9a1471bd81..94c9ac2273 100755
--- a/tests/generic/353
+++ b/tests/generic/353
@@ -29,7 +29,8 @@ _require_xfs_io_command "fiemap"
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-blocksize=64k
+blocksize=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blocksize
 file1="$SCRATCH_MNT/file1"
 file2="$SCRATCH_MNT/file2"
 
diff --git a/tests/generic/517 b/tests/generic/517
index cf3031ed2d..229358d06b 100755
--- a/tests/generic/517
+++ b/tests/generic/517
@@ -21,6 +21,7 @@ _require_scratch_dedupe
 
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
 
 # The first byte with a value of 0xae starts at an offset (512Kb + 100) which is
 # not a multiple of the block size.
diff --git a/tests/generic/657 b/tests/generic/657
index e0fecd544c..9f4673dda3 100755
--- a/tests/generic/657
+++ b/tests/generic/657
@@ -30,6 +30,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
diff --git a/tests/generic/658 b/tests/generic/658
index a5cbadaaa5..e9519c25e2 100755
--- a/tests/generic/658
+++ b/tests/generic/658
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/659 b/tests/generic/659
index ccc2d7950d..05436edfab 100755
--- a/tests/generic/659
+++ b/tests/generic/659
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/660 b/tests/generic/660
index bc17dc5e59..52b0d1ea9e 100755
--- a/tests/generic/660
+++ b/tests/generic/660
@@ -31,6 +31,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/663 b/tests/generic/663
index 658a5b7004..692c77b745 100755
--- a/tests/generic/663
+++ b/tests/generic/663
@@ -32,6 +32,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/664 b/tests/generic/664
index 3009101fdc..40fb8c6d92 100755
--- a/tests/generic/664
+++ b/tests/generic/664
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/665 b/tests/generic/665
index 86ba578720..ee511755e6 100755
--- a/tests/generic/665
+++ b/tests/generic/665
@@ -34,6 +34,7 @@ mkdir $testdir
 
 echo "Create the original files"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 _sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/generic/670 b/tests/generic/670
index 67de167405..80f9fe6d4f 100755
--- a/tests/generic/670
+++ b/tests/generic/670
@@ -31,6 +31,7 @@ mkdir $testdir
 loops=512
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/generic/672 b/tests/generic/672
index 9e3a97ec5e..0710a04294 100755
--- a/tests/generic/672
+++ b/tests/generic/672
@@ -30,6 +30,7 @@ mkdir $testdir
 loops=1024
 nr_loops=$((loops - 1))
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Initialize files"
 echo >> $seqres.full
diff --git a/tests/xfs/1212 b/tests/xfs/1212
index d2292d65a2..655cd14021 100755
--- a/tests/xfs/1212
+++ b/tests/xfs/1212
@@ -32,6 +32,7 @@ _require_xfs_io_error_injection "bmap_finish_one"
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
 
 # Create original file
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
diff --git a/tests/xfs/420 b/tests/xfs/420
index d38772c9d9..51f87bc304 100755
--- a/tests/xfs/420
+++ b/tests/xfs/420
@@ -69,6 +69,9 @@ exercise_lseek() {
 }
 
 blksz=65536
+# Golden output encodes SEEK_HOLE/DATA output, which depends on COW only
+# happening on $blksz granularity
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=8
 filesize=$((blksz * nr))
 
diff --git a/tests/xfs/421 b/tests/xfs/421
index 027ae47c21..429333e349 100755
--- a/tests/xfs/421
+++ b/tests/xfs/421
@@ -51,6 +51,9 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+# Golden output encodes SEEK_HOLE/DATA output, which depends on COW only
+# happening on $blksz granularity
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=8
 filesize=$((blksz * nr))
 

