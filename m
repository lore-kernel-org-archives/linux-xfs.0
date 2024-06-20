Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11A58AA7;
	Thu, 20 Jun 2024 20:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916907; cv=none; b=WkhzT+UBxfsWl1TdZo7uXytU3J+sm/vZ6vchMiUqB5X+dMh9660QXfbgVN5lMuOWyirXXWv3TodAYq1Bvqy+Z05Dg5Bd1wAwpqIt+iTsHBqLgtQA3pUopVVuQuhBLGBl5ZcWXtQKuPoDgEXHjZPK+Ta7oveW3i+8zHvdoHhnySM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916907; c=relaxed/simple;
	bh=zCUhaelCLCGQ1F7h3QSl9KJRvFCbOHs819Yt7XN3zFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5QayIueuGPElItXk+QcTNyLkEPalzlzld4zkne1N/e7j27DxKAAN02XomN0C6zIrzpxvItez58K8SiURJ9jrXxrHzBZagl97siGmZqXKbKNFguIPiabybYS9J+mLXTiDHtpLtd74s3gmsjman7BSSSFuob1OwXhuHTDzrk3WUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7lJYz1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7lJYz1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0EAC2BD10;
	Thu, 20 Jun 2024 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916906;
	bh=zCUhaelCLCGQ1F7h3QSl9KJRvFCbOHs819Yt7XN3zFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h7lJYz1dGA/uKU9hdL+8Bab6lFL/2vnLdehGkDeF1pEpM6imiIos4qw35yWhkd3Tl
	 o3XlcrX3wjoOayIhCzTrHo1F7J3NJTfe0xGgGcvMB9Dk2FnGyJ9WwYHF6R1Fx339qO
	 +JAv2S2YyotkGmKjBlNl2V8c1jffG8GJ+0A2rgQR6qJ8O5ep1DUH/3A+UeIa6Gr47m
	 VzvTmWk6h/iAUxyss2AEq4HNdBdxg3c2/+0+ejJgbg9e3nkosV5HKXnrRHdUvCiMSm
	 PlQOgiug3+DiC49rKaHK8M2GGsCTxWvVfUMA5zYceU5Xx8pMoRR82TlOmAFuW2Fm5h
	 hHajXMIlJdAgw==
Date: Thu, 20 Jun 2024 13:55:06 -0700
Subject: [PATCH 04/11] generic/711,xfs/537: actually fork these tests for
 exchange-range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <171891669174.3034840.5584811354339983628.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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

Fork these tests to check the same things with exchange-range as they do
for swapext, since the code porting swapext to commit-range has been
dropped.

I was going to fork xfs/789 as well, but it turns out that generic/714
covers this sufficiently so for that one, we just strike fiexchange from
the group tag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1221     |   45 ++++++++++++++++++++++++
 tests/generic/1221.out |    2 +
 tests/generic/711      |    2 +
 tests/xfs/1215         |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1215.out     |   13 +++++++
 tests/xfs/789          |    2 +
 6 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/1221
 create mode 100644 tests/generic/1221.out
 create mode 100755 tests/xfs/1215
 create mode 100644 tests/xfs/1215.out


diff --git a/tests/generic/1221 b/tests/generic/1221
new file mode 100755
index 0000000000..5569f59734
--- /dev/null
+++ b/tests/generic/1221
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1221
+#
+# Make sure that exchangerange won't touch a swap file.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	test -e "$dir/a" && swapoff $dir/a
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_require_xfs_io_command exchangerange
+_require_test
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+
+# Set up a fragmented swapfile and a dummy donor file.
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
+$here/src/punch-alternating $dir/a
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
+$MKSWAP_PROG $dir/a >> $seqres.full
+
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 32m -b 1m' $dir/b >> $seqres.full
+
+swapon $dir/a || _notrun 'failed to swapon'
+
+# Now try to exchangerange.
+$XFS_IO_PROG -c "exchangerange $dir/b" $dir/a
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1221.out b/tests/generic/1221.out
new file mode 100644
index 0000000000..698ac87303
--- /dev/null
+++ b/tests/generic/1221.out
@@ -0,0 +1,2 @@
+QA output created by 1221
+exchangerange: Text file busy
diff --git a/tests/generic/711 b/tests/generic/711
index b107f976ef..792136306c 100755
--- a/tests/generic/711
+++ b/tests/generic/711
@@ -7,7 +7,7 @@
 # Make sure that swapext won't touch a swap file.
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick swapext
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/1215 b/tests/xfs/1215
new file mode 100755
index 0000000000..5e7633c5ea
--- /dev/null
+++ b/tests/xfs/1215
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1215
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# exchanging ranges between files
+. ./common/preamble
+_begin_fstest auto quick collapse fiexchange
+
+# Import common functions.
+. ./common/filter
+. ./common/inject
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "exchangerange"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Exchange extent forks"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+donorfile=${SCRATCH_MNT}/donorfile
+
+echo "Create \$donorfile having an extent of length 67 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 10); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+
+echo "Create \$srcfile having an extent of length 18 blocks"
+$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
+for i in $(seq 1 7); do
+	start_offset=$((i * bsize))
+	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
+done
+
+echo "Collect \$donorfile's extent count"
+donor_nr_exts=$(_xfs_get_fsxattr nextents $donorfile)
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$(_xfs_get_fsxattr nextents $srcfile)
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Exchange \$srcfile's and \$donorfile's extent forks"
+$XFS_IO_PROG -f -c "exchangerange $donorfile" $srcfile >> $seqres.full 2>&1
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$(_xfs_get_fsxattr nextents $donorfile)
+
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$(_xfs_get_fsxattr nextents $srcfile)
+
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1215.out b/tests/xfs/1215.out
new file mode 100644
index 0000000000..48edd56376
--- /dev/null
+++ b/tests/xfs/1215.out
@@ -0,0 +1,13 @@
+QA output created by 1215
+* Exchange extent forks
+Format and mount fs
+Create $donorfile having an extent of length 67 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 18 blocks
+Fragment $srcfile
+Collect $donorfile's extent count
+Collect $srcfile's extent count
+Inject reduce_max_iextents error tag
+Exchange $srcfile's and $donorfile's extent forks
+Check for $donorfile's extent count overflow
+Check for $srcfile's extent count overflow
diff --git a/tests/xfs/789 b/tests/xfs/789
index 00b98020f2..e3a332d7cf 100755
--- a/tests/xfs/789
+++ b/tests/xfs/789
@@ -7,7 +7,7 @@
 # Simple tests of the old xfs swapext ioctl
 
 . ./common/preamble
-_begin_fstest auto quick fiexchange swapext
+_begin_fstest auto quick swapext
 
 # Override the default cleanup function.
 _cleanup()

