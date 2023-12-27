Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F06C7ED;
	Mon,  1 Jan 2024 01:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuzddTKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3467FC433C8;
	Mon,  1 Jan 2024 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071071;
	bh=bGka8KkS5/SmPkedarS/6RMqBg6Hubd2jVw+iOePdAs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MuzddTKt67Zg/jk8DykfFdHMzzMxxHnsB8dA4ThhR8dhFre7/eOUWuYbveFm9w9eb
	 xNdgMBn6GJCeZ71CqEBixIuv7+pIcLKlUQTuSVI4ObWCIP2khpwFCSkROmHTIgb9de
	 qIMbZGHxd866uzUI3hPZ45xcrEgA8b6MYQMOZW2/PA61j993eQy0vz6s8MXof7vU3a
	 eS238+Sq14o6KaH3MgMJgFSyNUpJW6AehdU74LV4DsDpKwFoiJs8k65YGBxLR+jg5V
	 WcFqETHaOQsq3VeRbtZZYGiXN7TM4fK8sLs7WBNCQZqOF2iAk+xMqPD8yz+q3dd4nK
	 CqesamKCIIQ/g==
Date: Sun, 31 Dec 2023 17:04:30 +9900
Subject: [PATCH 2/5] xfs: skip cowextsize hint fragmentation tests on realtime
 volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032762.1827706.12824926807769911075.stgit@frogsfrogsfrogs>
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

The XFS CoW extent size hint is ignored on realtime filesystems when the
rt extent size set to a unit larger than a single filesystem block
because it is assumed that the larger allocation unit is the
administrator's sole and mandatory anti-fragmentation strategy.  As
such, we can skip these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/reflink |   27 +++++++++++++++++++++++++++
 tests/xfs/180  |    1 +
 tests/xfs/182  |    1 +
 tests/xfs/184  |    1 +
 tests/xfs/192  |    1 +
 tests/xfs/200  |    1 +
 tests/xfs/204  |    1 +
 tests/xfs/208  |    1 +
 tests/xfs/315  |    1 +
 tests/xfs/326  |    6 ++++++
 10 files changed, 41 insertions(+)


diff --git a/common/reflink b/common/reflink
index 22adc4449b..1082642e4e 100644
--- a/common/reflink
+++ b/common/reflink
@@ -521,3 +521,30 @@ _sweave_reflink_rainbow_delalloc() {
 		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
 	done
 }
+
+# Require that the COW extent size hint can actually be used to combat
+# fragmentation on the scratch filesystem.  This is (so far) true for any
+# filesystem except for the ones where the realtime extent size is larger
+# than one fs block, for it is assumed that setting a rt extent size is the
+# preferred fragmentation avoidance strategy.
+_require_scratch_cowextsize_useful() {
+	local testfile=$SCRATCH_MNT/hascowextsize
+	local param="${1:-1m}"
+
+	rm -f $testfile
+	touch $testfile
+	local before="$($XFS_IO_PROG -c 'cowextsize' $testfile)"
+
+	$XFS_IO_PROG -c "cowextsize $param" $testfile
+	local after="$($XFS_IO_PROG -c 'cowextsize' $testfile)"
+	rm -f $testfile
+
+	test "$before" != "$after" || \
+		_notrun "setting cowextsize to $param had no effect"
+
+	local fileblocksize=$(_get_file_block_size $SCRATCH_MNT)
+	local fsblocksize=$(_get_block_size $SCRATCH_MNT)
+
+	test $fsblocksize -eq $fileblocksize || \
+		_notrun "XFS does not support cowextsize when rt extsize ($fileblocksize) > 1FSB ($fsblocksize)"
+}
diff --git a/tests/xfs/180 b/tests/xfs/180
index d2fac03a9e..e8e04062a8 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -38,6 +38,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/182 b/tests/xfs/182
index 511aca6f2d..7c0713b248 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -39,6 +39,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/184 b/tests/xfs/184
index 97f529f666..b2b4da6024 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -40,6 +40,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/192 b/tests/xfs/192
index ef7da55be5..0017597280 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -42,6 +42,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/200 b/tests/xfs/200
index a9d6ce1bb6..500564d9a8 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -42,6 +42,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/204 b/tests/xfs/204
index 7dacfa2de7..8cbdd6513f 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -44,6 +44,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_block_size $testdir)
diff --git a/tests/xfs/208 b/tests/xfs/208
index 1e7734b822..0d2401b908 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -41,6 +41,7 @@ nr=128
 filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
+_require_scratch_cowextsize_useful $bufsize
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 real_blksz=$(_get_file_block_size $testdir)
diff --git a/tests/xfs/315 b/tests/xfs/315
index 9f6b39c8cc..3a618a3680 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -38,6 +38,7 @@ echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
+_require_scratch_cowextsize_useful $sz
 
 $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 
diff --git a/tests/xfs/326 b/tests/xfs/326
index ac620fc433..a3fed8b6ac 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -55,6 +55,12 @@ $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 # staging extent for an unshared extent and trips over the injected error.
 _require_no_xfs_always_cow
 
+# This test uses a very large cowextszhint to manipulate the COW fork to
+# contain a large unwritten extent before injecting the error.  XFS ignores
+# cowextsize when the realtime extent size is greater than 1FSB, so this test
+# cannot set up the preconditions for the test.
+_require_scratch_cowextsize_useful $sz
+
 echo "Create files"
 _pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
 _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2

