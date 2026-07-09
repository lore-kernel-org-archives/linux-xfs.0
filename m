Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6A3F0A8E;
	Thu,  9 Jul 2026 08:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783585863; cv=none; b=h3UaYUSaSXKH/W+q4DieMykYBeRmsVHdNT2O6NITSddYeb1nlxWoEMh6R7+cxQkURZRSR3ETRhQXwL+0eXAA+mx9HnBB9iBxg30sB9wa5Seab4n/QlhjA35yYz1Mz0Q8/gc8rsoFKgfowQkViSNuRUQApTJY8ONgyeg5xGehzVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783585863; c=relaxed/simple;
	bh=1+hRgLLjQvyLp/zQZuJ7ZawrldyCYqciCPHN/qyOS2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hDV2CzbmugssY+SggJkM1/yYbQ0c3tA76JeTPRh3GqE5D1H0bFv0owKs3/84W19KlYbGehJusHRZ1Yf/YP2pgvlPA/InHeAVmpIkdsUSLnJPEAzPjTXRpKR07WhpgTF3Y36j0nmVUeIM6SlDDTyyO0ThU06pHtvByepzXUEDORg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gwp805kj8zMlGJ;
	Thu, 09 Jul 2026 10:30:56 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: zlang@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de,
	pankaj.raghav@linux.dev,
	fstests@vger.kernel.org,
	djwong@kernel.org,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	yi.zhang@huawei.com,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2] generic/795: add unaligned boundary test cases for WRITE_ZEROES
Date: Thu,  9 Jul 2026 10:30:48 +0200
Message-ID: <20260709083048.3849610-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4gwp805kj8zMlGJ

During the review of WRITE_ZEROES support to XFS, Zhang Yi pointed out
some important semantics for the boundary blocks when WRITE_ZEROES
command is used.[1]

The test cases check the boundary blocks when they are in different
states and WRITE_ZEROES are issued that straddle the boundary. Along with that,
test cases have been added when a EoF straddles an allocation unit.

[1] https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
CHanges since v1:
- Use filefrag instead of FIEMAP as the latter uses FIEMAP_FLAG_SYNC by
  default when used via xfs_io (Zhang yi)
- Add an extra testcase for dirty-unwritten edges (Zhang Yi)

 common/rc             |   2 +-
 tests/generic/795     | 187 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/795.out |  19 +++++
 3 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/795
 create mode 100644 tests/generic/795.out

diff --git a/common/rc b/common/rc
index 79189e7e..5e59968f 100644
--- a/common/rc
+++ b/common/rc
@@ -3008,7 +3008,7 @@ _require_xfs_io_command()
 		testio=`$XFS_IO_PROG -F -f -c "$command $param 0 1m" $testfile 2>&1`
 		param_checked="$param"
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare" | "fwzero")
 		local blocksize=$(_get_file_block_size $TEST_DIR)
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 $((5 * $blocksize))" \
 			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
diff --git a/tests/generic/795 b/tests/generic/795
new file mode 100755
index 00000000..b1e05666
--- /dev/null
+++ b/tests/generic/795
@@ -0,0 +1,187 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Samsung Electronics.  All Rights Reserved.
+#
+# FS QA Test 795
+#
+# Verify FALLOC_FL_WRITE_ZEROES (xfs_io "fwzero") on an unaligned range,
+# exercising every state the two boundary allocation units can be in.
+#
+# WRITE_ZEROES must leave the whole requested range backed by *written*
+# (zeroed) extents while preserving the out-of-range bytes of the partial
+# boundary units. The scenarios are: written_edges, hole_edges,
+# clean_unwritten_edges, delalloc_edges and dirty_unwritten_edges.
+#
+# It then covers the EOF cases: a WRITE_ZEROES that *extends* the file to a
+# non-unit-aligned size, followed by a further extension. WRITE_ZEROES must
+# never leave written blocks beyond EOF.
+
+. ./common/preamble
+_begin_fstest auto quick prealloc fiemap
+
+testfile=$TEST_DIR/$seq.testfile
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	rm -f $testfile
+}
+
+. ./common/filter
+
+_require_test
+_require_xfs_io_command "fwzero"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "truncate"
+_require_command "$FILEFRAG_PROG" filefrag
+
+# The allocation unit: rt extent size on an rt config, otherwise the block
+# size. Deriving the range from this makes the head/tail units straddle rt
+# extents when rextsize > 1.
+u=$(_get_file_block_size $TEST_DIR)
+
+# The fs block size. On rt with rextsize > 1 the allocation unit u is the rt
+# extent (u > b). A WRITE_ZEROES that extends EOF must only write out to the
+# block-rounded EOF and leave the rest of the straddling rt extent unwritten,
+# rather than written past EOF.
+b=$(_get_block_size $TEST_DIR)
+
+# Unaligned range within EOF: start 1.5 units in, span 4 units, so both the
+# head unit [u, 2u) and the tail unit [5u, 6u) are only partially covered,
+# with fully covered units in between and data on both sides.
+off=$((u + u / 2))
+len=$((4 * u))
+filesz=$((8 * u))
+pattern=0xab
+
+# Expected images. For the written/delalloc/dirty-unwritten cases the pattern
+# surrounds the zeroed range; for the hole/clean-unwritten cases the file reads
+# back all zeroes.
+$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" $tmp.pattern >> $seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite -S 0 $off $len" $tmp.pattern >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c "truncate $filesz" $tmp.zero >> $seqres.full 2>&1
+
+# _filter_filefrag emits "phys#len#logical#flags" in bytes. filefrag has no
+# range option, so clip the extents to the byte window [s, e) with awk before
+# grepping - an extent [$3, $3+$2) overlaps the window iff $3 < e && $3+$2 > s.
+_filefrag_window()
+{
+	local file=$1 start=$2 end=$3
+
+	$FILEFRAG_PROG -v "$file" | _filter_filefrag | \
+		$AWK_PROG -F'#' -v s=$start -v e=$end '$3 < e && $3 + $2 > s'
+}
+
+# Assert the whole requested range is backed by written extents immediately
+# after fwzero (before any sync/remount): no unwritten, no delalloc.
+# The extent state is queried with filefrag: xfs_io's fiemap always sets
+# FIEMAP_FLAG_SYNC, which would flush and convert delalloc to written before
+# reporting.
+_check_range_written()
+{
+	local file=$1
+	local bad
+
+	$FILEFRAG_PROG -v "$file" >> $seqres.full 2>&1
+	bad=$(_filefrag_window "$file" $off $((off + len)) | \
+		grep -E -c 'unwritten|delalloc|unknown')
+	if [ "$bad" -eq 0 ]; then
+		echo "extents: range fully written"
+	else
+		echo "extents: FAIL - $bad unwritten/delalloc extent(s) in range"
+	fi
+}
+
+_check_data()
+{
+	local file=$1
+	local want=$2
+
+	if cmp -s "$file" "$want"; then
+		echo "data: matches expected image"
+	else
+		echo "data: FAIL - mismatch against expected image"
+		cmp "$file" "$want" | head
+	fi
+}
+
+# Assert the tail past the block-rounded EOF holds no *written* extents: it must
+# be unwritten or a hole.
+_check_eof_tail()
+{
+	local file=$1 start=$2 len=$3
+	local bad
+
+	if [ "$len" -le 0 ]; then
+		echo "extents: eof tail unwritten"
+		return
+	fi
+	$FILEFRAG_PROG -v "$file" >> $seqres.full 2>&1
+	bad=$(_filefrag_window "$file" $start $((start + len)) | \
+		grep -E -v -c 'unwritten|delalloc|unknown')
+	if [ "$bad" -eq 0 ]; then
+		echo "extents: eof tail unwritten"
+	else
+		echo "extents: FAIL - $bad written extent(s) past block-rounded EOF"
+	fi
+}
+
+_run_case()
+{
+	local name=$1
+	local want=$2
+
+	echo "=== $name ==="
+
+	$XFS_IO_PROG -c "fwzero $off $len" $testfile >> $seqres.full 2>&1
+
+	echo "== $name filefrag after fwzero ==" >> $seqres.full
+	_check_range_written $testfile
+	_test_cycle_mount
+	_check_data $testfile $want
+
+	rm -f $testfile
+}
+
+# 1) Boundary units already written, within i_size.
+$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" -c fsync $testfile \
+	>> $seqres.full 2>&1
+_run_case "written_edges" $tmp.pattern
+
+# 2) Boundary units are holes (sparse file).
+$XFS_IO_PROG -f -c "truncate $filesz" $testfile >> $seqres.full 2>&1
+_run_case "hole_edges" $tmp.zero
+
+# 3) Boundary units are clean unwritten preallocation: read back as zeroes.
+$XFS_IO_PROG -f -c "falloc 0 $filesz" $testfile >> $seqres.full 2>&1
+_run_case "clean_unwritten_edges" $tmp.zero
+
+# 4) Boundary units are dirty/delalloc.
+$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" $testfile >> $seqres.full 2>&1
+_run_case "delalloc_edges" $tmp.pattern
+
+# 5) Boundary units are dirty unwritten.
+$XFS_IO_PROG -f -c "falloc 0 $filesz" -c "pwrite -S $pattern 0 $filesz" \
+	$testfile >> $seqres.full 2>&1
+_run_case "dirty_unwritten_edges" $tmp.pattern
+
+# 6) EOF cases. A WRITE_ZEROES that extends the file to a non-unit-aligned
+#    size, followed by a further extend.
+eof=$((3 * u + 1))
+
+echo "=== eof_then_truncate ==="
+$XFS_IO_PROG -f -c "fwzero 0 $eof" $testfile >> $seqres.full 2>&1
+# The write must stop at the block-rounded EOF; the rest of the rt extent that
+# straddles EOF must be unwritten, not written past EOF.
+eof_ru=$(( (eof + b - 1) & ~(b - 1) ))
+_check_eof_tail $testfile $eof_ru $((4 * u - eof_ru))
+
+$XFS_IO_PROG -c "truncate $filesz" $testfile >> $seqres.full 2>&1
+_test_cycle_mount
+_check_data $testfile $tmp.zero
+rm -f $testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/795.out b/tests/generic/795.out
new file mode 100644
index 00000000..dca6e571
--- /dev/null
+++ b/tests/generic/795.out
@@ -0,0 +1,19 @@
+QA output created by 795
+=== written_edges ===
+extents: range fully written
+data: matches expected image
+=== hole_edges ===
+extents: range fully written
+data: matches expected image
+=== clean_unwritten_edges ===
+extents: range fully written
+data: matches expected image
+=== delalloc_edges ===
+extents: range fully written
+data: matches expected image
+=== dirty_unwritten_edges ===
+extents: range fully written
+data: matches expected image
+=== eof_then_truncate ===
+extents: eof tail unwritten
+data: matches expected image

base-commit: ffc8bad17e5b2f56e48dbac43f7c5ae8ac368fe5
-- 
2.51.2

