Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FA7ED;
	Mon,  1 Jan 2024 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpWmOV96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0218C433C8;
	Mon,  1 Jan 2024 01:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071086;
	bh=pEWxttbe7ZFy++6/xveUJs/muewSFpCu/5fWwGCCLFk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WpWmOV967nrn+gvaeSgs+uxl7qZL5BAVl+FKH2sFumKR6eTVlw5YBpVvpcO8ZjARg
	 2JC2vqNudi7MMotbf5EXIZttn1pjAsM+quB1Q9J8WKKIuU474jW/z5S3ch1mrfbjlz
	 cEk2SObMxCf9sRxG9Mxksq2aLsPMyYPgou0QGyUk2wAXqOT4v9FEKV+djzD9ko6Rmi
	 OlE94PD45du3weD2oV6VyefnVlcP+y1l1KzLo4U/f3Om0VjDdhxUhNvK7nFjk3avXl
	 uoFcqqELau6gW4Qx4o2Y9IkWowjJxi7+Hi3rPSFxwrVPyB9kTTBNZnLgLaw1hEVAy0
	 Aelg9RXbcZ53Q==
Date: Sun, 31 Dec 2023 17:04:46 +9900
Subject: [PATCH 3/5] misc: add more congruent oplen testing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032776.1827706.12287719690033943992.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032733.1827706.12312180709769839153.stgit@frogsfrogsfrogs>
References: <170405032733.1827706.12312180709769839153.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 tests/generic/353 |    2 +-
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
 tests/xfs/420     |    3 +++
 tests/xfs/421     |    3 +++
 tests/xfs/792     |    1 +
 19 files changed, 23 insertions(+), 1 deletion(-)


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
index c563972510..6dbb0d4c24 100755
--- a/tests/generic/353
+++ b/tests/generic/353
@@ -30,7 +30,7 @@ _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
 blocksize=$(_get_file_block_size $SCRATCH_MNT)
-
+_require_congruent_file_oplen $SCRATCH_MNT $blocksize
 file1="$SCRATCH_MNT/file1"
 file2="$SCRATCH_MNT/file2"
 extmap1="$SCRATCH_MNT/extmap1"
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
 
diff --git a/tests/xfs/792 b/tests/xfs/792
index bfbfbce4aa..bfbfd8bfbc 100755
--- a/tests/xfs/792
+++ b/tests/xfs/792
@@ -32,6 +32,7 @@ _require_xfs_io_error_injection "bmap_finish_one"
 
 _scratch_mkfs >> $seqres.full
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
 
 # Create original file
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full

