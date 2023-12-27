Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24D97EE;
	Mon,  1 Jan 2024 01:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBe99lT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A69C433C7;
	Mon,  1 Jan 2024 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071102;
	bh=zv8S0l/G5PKw7wGJ5ukwwq1b6jA613kbQsrFilB3qng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mBe99lT4vfgyRmxo/GtlPtSXJZENlGJe15V0BHCIytDX03tJlVWa4jOw5cmYTnB9G
	 CEykQxVmjn8HkuhedCQRgaZZvEijYsUqBZmL3UiWfTdlJ2YYEhE5cWVVpvYqwGcVxi
	 Si30WZaHL/UH0c3UnBmY91O3jL0Rms46Z85Vr9xjO5qGNbaS6wlhSvcY0MAKxer5IU
	 jS13+g1AE75+GVwnOHhX4W6NMS9ehWnwfMn3gtzihLLYNyPkDqsKGIuzOr/vYu4WQg
	 9b2zA82ozrhCSWbkPZ99CCp/OvfJqaC5mvQ72AeaLT6yYWD1zfpfdBb1nAHQkt9BwQ
	 IrVF9XWmOo6nw==
Date: Sun, 31 Dec 2023 17:05:02 +9900
Subject: [PATCH 4/5] xfs: test COWing entire rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032789.1827706.9480080283762068776.stgit@frogsfrogsfrogs>
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

For XFS filesystems with a realtime volume, an extent size larger than
1FSB, and reflink enabled, we use a "COW around" strategy that detects
file writes that are not aligned to the rt extent size and enlarges
those writes to dirty enough page cache so that the entire rt extent can
be COWed all at once.  This is a functional test to make sure that all
works properly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1926     |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1926.out |    2 +
 2 files changed, 179 insertions(+)
 create mode 100755 tests/xfs/1926
 create mode 100644 tests/xfs/1926.out


diff --git a/tests/xfs/1926 b/tests/xfs/1926
new file mode 100755
index 0000000000..91b611f59d
--- /dev/null
+++ b/tests/xfs/1926
@@ -0,0 +1,177 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1926
+#
+# Functional testing for COWing around realtime extents.
+#
+. ./common/preamble
+_begin_fstest auto clone realtime rw
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $testdir
+}
+
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test
+_require_test_reflink
+_require_cp_reflink
+
+alloc_unit=$(_get_file_block_size $TEST_DIR)
+blksz=$(_get_block_size $TEST_DIR)
+
+testdir="$TEST_DIR/test-$seq"
+mkdir "$testdir"
+
+filesize="$(( (alloc_unit * 5 / 2) + 512))"
+origfile="$testdir/a"
+testfile0="$testdir/a0"
+testfile1="$testdir/a1"
+testfile2="$testdir/a2"
+testfile3="$testdir/a3"
+testfile4="$testdir/a4"
+testfile5="$testdir/a5"
+testfile6="$testdir/a6"
+testfile7="$testdir/a7"
+testfile8="$testdir/a8"
+testfile9="$testdir/a9"
+testfileA="$testdir/aA"
+testfileB="$testdir/aB"
+
+goldfile0="$testdir/g0"
+goldfile1="$testdir/g1"
+goldfile2="$testdir/g2"
+goldfile3="$testdir/g3"
+goldfile4="$testdir/g4"
+goldfile5="$testdir/g5"
+
+orig_cmd="pwrite -S 0x58 -b 1m 0 $filesize"
+$XFS_IO_PROG -f -c "$orig_cmd" -c fsync "$origfile" >> $seqres.full
+
+_cp_reflink "$origfile" "$testfile0"
+_cp_reflink "$origfile" "$testfile1"
+_cp_reflink "$origfile" "$testfile2"
+_cp_reflink "$origfile" "$testfile3"
+_cp_reflink "$origfile" "$testfile4"
+_cp_reflink "$origfile" "$testfile5"
+_cp_reflink "$origfile" "$testfile6"
+_cp_reflink "$origfile" "$testfile7"
+_cp_reflink "$origfile" "$testfile8"
+_cp_reflink "$origfile" "$testfile9"
+_cp_reflink "$origfile" "$testfileA"
+_cp_reflink "$origfile" "$testfileB"
+
+# First we try a partial ovewrite below EOF
+cmd="pwrite -S 0x59 -b 1m -W 512 512"
+_kernlog "********** buffered write below eof goldfile0"
+$XFS_IO_PROG -c "$cmd" "$testfile0" >> $seqres.full
+_kernlog "********** direct write below eof goldfile0"
+$XFS_IO_PROG -d -c "$cmd" "$testfile1" >> $seqres.full
+_kernlog "********** goldfile0"
+$XFS_IO_PROG -f -c "$orig_cmd" -c "$cmd" -c fsync "$goldfile0" >> $seqres.full
+
+# Next we try an appending write at EOF
+_kernlog "********** appending buffered write goldfile1"
+cmd="pwrite -S 0x5a -b 1m -W $filesize 512"
+$XFS_IO_PROG -c "$cmd" "$testfile2" >> $seqres.full
+_kernlog "********** appending direct write goldfile1"
+$XFS_IO_PROG -d -c "$cmd" "$testfile3" >> $seqres.full
+_kernlog "********** goldfile1"
+$XFS_IO_PROG -f -c "$orig_cmd" -c "$cmd" -c fsync "$goldfile1" >> $seqres.full
+
+# Third we try a pure overwrite of the second block
+_kernlog "********** buffered overwrite second block goldfile2"
+cmd="pwrite -S 0x5b -b 1m -W $alloc_unit $alloc_unit"
+$XFS_IO_PROG -c "$cmd" "$testfile4" >> $seqres.full
+_kernlog "********** direct overwrite second block goldfile2"
+$XFS_IO_PROG -d -c "$cmd" "$testfile5" >> $seqres.full
+_kernlog "********** goldfile2"
+$XFS_IO_PROG -f -c "$orig_cmd" -c "$cmd" -c fsync "$goldfile2" >> $seqres.full
+
+# Fourth we try a small write well beyond EOF
+_kernlog "********** buffered write beyond eof block goldfile3"
+cmd="pwrite -S 0x5c -b 1m -W $(( (filesize * 2) + 512)) 512"
+$XFS_IO_PROG -c "$cmd" "$testfile6" >> $seqres.full
+_kernlog "********** direct write beyond eof block goldfile3"
+$XFS_IO_PROG -d -c "$cmd" "$testfile7" >> $seqres.full
+_kernlog "********** goldfile3"
+$XFS_IO_PROG -f -c "$orig_cmd"  -c "$cmd" -c fsync "$goldfile3" >> $seqres.full
+
+# Fifth we try a large write well beyond EOF
+_kernlog "********** buffered write beyond eof block goldfile4"
+cmd="pwrite -S 0x5d -b 1m -W $(( ((filesize * 2) + 512) & ~(alloc_unit - 1) )) $alloc_unit"
+$XFS_IO_PROG -c "$cmd" "$testfile8" >> $seqres.full
+_kernlog "********** direct write beyond eof block goldfile4"
+$XFS_IO_PROG -d -c "$cmd" "$testfile9" >> $seqres.full
+_kernlog "********** goldfile3"
+$XFS_IO_PROG -f -c "$orig_cmd" -c "$cmd" -c fsync "$goldfile4" >> $seqres.full
+
+# Sixth we try a pure overwrite of the second fsblock
+_kernlog "********** buffered overwrite second fsblock goldfile5"
+cmd="pwrite -S 0x5b -b 1m -W $blksz $alloc_unit"
+$XFS_IO_PROG -c "$cmd" "$testfileA" >> $seqres.full
+_kernlog "********** direct overwrite second fsblock goldfile5"
+$XFS_IO_PROG -d -c "$cmd" "$testfileB" >> $seqres.full
+_kernlog "********** goldfile5"
+$XFS_IO_PROG -f -c "$orig_cmd" -c "$cmd" -c fsync "$goldfile5" >> $seqres.full
+
+_kernlog "********** done"
+
+corruption_noted=
+
+note_corruption() {
+	local fname="$1"
+
+	echo "$fname is bad"
+
+	if [ -z "$corruption_noted" ]; then
+		corruption_noted=1
+		echo "origfile" >> $seqres.full
+		od -tx1 -Ad -c "$origfile" >> $seqres.full
+	fi
+
+	echo "$fname" >> $seqres.full
+	od -tx1 -Ad -c "$testfile1" >> $seqres.full
+}
+
+echo "before remount" >> $seqres.full
+cmp -s "$goldfile0" "$testfile0" || note_corruption "$testfile0"
+cmp -s "$goldfile0" "$testfile1" || note_corruption "$testfile1"
+cmp -s "$goldfile1" "$testfile2" || note_corruption "$testfile2"
+cmp -s "$goldfile1" "$testfile3" || note_corruption "$testfile3"
+cmp -s "$goldfile2" "$testfile4" || note_corruption "$testfile4"
+cmp -s "$goldfile2" "$testfile5" || note_corruption "$testfile5"
+cmp -s "$goldfile3" "$testfile6" || note_corruption "$testfile6"
+cmp -s "$goldfile3" "$testfile7" || note_corruption "$testfile7"
+cmp -s "$goldfile4" "$testfile8" || note_corruption "$testfile8"
+cmp -s "$goldfile4" "$testfile9" || note_corruption "$testfile9"
+cmp -s "$goldfile5" "$testfileA" || note_corruption "$testfileA"
+cmp -s "$goldfile5" "$testfileB" || note_corruption "$testfileB"
+
+_test_cycle_mount
+
+echo "after remount" >> $seqres.full
+cmp -s "$goldfile0" "$testfile0" || note_corruption "$testfile0"
+cmp -s "$goldfile0" "$testfile1" || note_corruption "$testfile1"
+cmp -s "$goldfile1" "$testfile2" || note_corruption "$testfile2"
+cmp -s "$goldfile1" "$testfile3" || note_corruption "$testfile3"
+cmp -s "$goldfile2" "$testfile4" || note_corruption "$testfile4"
+cmp -s "$goldfile2" "$testfile5" || note_corruption "$testfile5"
+cmp -s "$goldfile3" "$testfile6" || note_corruption "$testfile6"
+cmp -s "$goldfile3" "$testfile7" || note_corruption "$testfile7"
+cmp -s "$goldfile4" "$testfile8" || note_corruption "$testfile8"
+cmp -s "$goldfile4" "$testfile9" || note_corruption "$testfile9"
+cmp -s "$goldfile5" "$testfileA" || note_corruption "$testfileA"
+cmp -s "$goldfile5" "$testfileB" || note_corruption "$testfileB"
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1926.out b/tests/xfs/1926.out
new file mode 100644
index 0000000000..a56601b969
--- /dev/null
+++ b/tests/xfs/1926.out
@@ -0,0 +1,2 @@
+QA output created by 1926
+Silence is golden

