Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271F71B0425;
	Tue, 31 Dec 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689379; cv=none; b=mgCNl9C2iGaUjgiPxAxcpXiKelnZLqWTqX9kOxNqeRJLCa8wdNfl6RYR3SAeURH0yf+JDlYMcJx+fJpAcjKEoSeI14h/8+Suq1N7Ey6YrTTcDr/Mg8MeOGTaaDSIz1LoXUhckHk0D0tKRI4bOD1kr1Y48H49AuVfgEb5j4PcbhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689379; c=relaxed/simple;
	bh=MTAlFxINu7+ChUshLMY2W2vwMia6mjozjceUaUSpvDU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptDfkCfumL5jDuGb339HbJg+MrD9KH38RQYVfbzaTuMiJuZxbge7G868tiqwNc3vNofMawvXTce5GlGTn7ecOSaB7Nx3rlarb8QR88stHWu0iPn9vsQ+QNOznNOJjLdHaPGwIWcBU6J0JdXqvcIM0dmLutsuBwUqVRGwUn96RVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKypfLnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKypfLnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CEEC4CED2;
	Tue, 31 Dec 2024 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689379;
	bh=MTAlFxINu7+ChUshLMY2W2vwMia6mjozjceUaUSpvDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iKypfLnQYBtWg38i06XmCz81dD5R1+yJCm6U59x9w6802ykN6tcmzQnGz7FT7DBof
	 nGtePwLqalBoBNF+7Ji4zbUCNYJoa0iVbTitwo0oIzLv9G8VidgLxZDLIL5ZpEF1RH
	 pu8Abzg3mzGVmHgGVDk4IBTHQglmI0Rra5qxI4CEUSsepenz0t92zF51Aa+KH8t+qn
	 c0TJTlRZLn5h4CRYj5+zMwC1zo4RbxPQZcQT6zay7bXdPw2NqyhkBqXIPpS8AN3A/8
	 klxYoFRJRapURiItt/q9BLEPiM0uHsqiS8P5sr7Sxxg/W2WyoUwWLiF92LvAhn4kfy
	 FZl9gQ7GaGcnw==
Date: Tue, 31 Dec 2024 15:56:18 -0800
Subject: [PATCH 1/1] xfs: test clearing of free space
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568782420.2712030.1823307599476850196.stgit@frogsfrogsfrogs>
In-Reply-To: <173568782405.2712030.4766560864446006648.stgit@frogsfrogsfrogs>
References: <173568782405.2712030.4766560864446006648.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Simple regression test for the spaceman clearspace command, which tries
to free all the used space in some part of the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc          |    5 ++++
 tests/xfs/1400     |   52 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    2 +
 tests/xfs/1401     |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    2 +
 5 files changed, 131 insertions(+)
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out


diff --git a/common/rc b/common/rc
index c45a226849ce0f..d7dfb55bbbd7e1 100644
--- a/common/rc
+++ b/common/rc
@@ -2786,6 +2786,11 @@ _require_xfs_io_command()
 			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
 			$testfile 2>&1`
 		;;
+	"fmapfree")
+		local blocksize=$(_get_file_block_size $TEST_DIR)
+		testio=`$XFS_IO_PROG -F -f -c "$command $blocksize $((2 * $blocksize))" \
+			$testfile 2>&1`
+		;;
 	"fiemap")
 		# If 'ranged' is passed as argument then we check to see if fiemap supports
 		# ranged query params
diff --git a/tests/xfs/1400 b/tests/xfs/1400
new file mode 100755
index 00000000000000..ec3f7aec2a318a
--- /dev/null
+++ b/tests/xfs/1400
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1400
+#
+# Basic functionality testing for FALLOC_FL_MAP_FREE
+#
+. ./common/preamble
+_begin_fstest auto prealloc
+
+. ./common/filter
+
+_require_scratch
+_require_xfs_io_command "fmapfree"
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs > /dev/null
+_scratch_mount >> $seqres.full
+. $tmp.mkfs
+
+testfile="$SCRATCH_MNT/$seq.txt"
+touch $testfile
+if $XFS_IO_PROG -c 'stat -v' $testfile | grep -q 'realtime'; then
+	# realtime
+	increment=$((dbsize * rtblocks / 100))
+	length=$((dbsize * rtblocks))
+else
+	# data
+	increment=$((dbsize * dblocks / 100))
+	length=$((dbsize * dblocks))
+fi
+
+free_bytes=$(stat -f -c '%f * %S' $testfile | bc)
+
+echo "free space: $free_bytes; increment: $increment; length: $length" >> $seqres.full
+
+# Map all the free space on that device, 10% at a time
+for ((start = 0; start < length; start += increment)); do
+	$XFS_IO_PROG -f -c "fmapfree $start $increment" $testfile
+done
+
+space_used=$(stat -c '%b * %B' $testfile | bc)
+
+echo "space captured: $space_used" >> $seqres.full
+$FILEFRAG_PROG -v $testfile >> $seqres.full
+
+# Did we get within 10% of the free space?
+_within_tolerance "mapfree space used" $space_used $free_bytes 10% -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1400.out b/tests/xfs/1400.out
new file mode 100644
index 00000000000000..601404d7a46856
--- /dev/null
+++ b/tests/xfs/1400.out
@@ -0,0 +1,2 @@
+QA output created by 1400
+mapfree space used is in range
diff --git a/tests/xfs/1401 b/tests/xfs/1401
new file mode 100755
index 00000000000000..14675abd8ff985
--- /dev/null
+++ b/tests/xfs/1401
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1401
+#
+# Basic functionality testing for the free space defragmenter.
+#
+. ./common/preamble
+_begin_fstest auto defrag shrinkfs
+
+. ./common/filter
+
+_notrun "XXX test is not ready yet; you need to deal with eof blocks"
+_notrun "XXX clearfree cannot move unwritten extents; does fiexchange work for this?"
+_notrun "XXX csp_buffercopy never returns if we hit eof"
+
+_require_scratch
+_require_xfs_spaceman_command "clearfree"
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs > /dev/null
+cat $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+_scratch_mount >> $seqres.full
+
+cpus=$(( $(src/feature -o) * 4))
+
+# Use fsstress to create a directory tree with some variability
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 4000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+
+$XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT >> $seqres.full
+
+if $XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT | grep -q 'rt-inherit'; then
+	# realtime
+	increment=$((dbsize * rtblocks / agcount))
+	length=$((dbsize * rtblocks))
+	fsmap_devarg="-r"
+else
+	# data
+	increment=$((dbsize * agsize))
+	length=$((dbsize * dblocks))
+	fsmap_devarg="-d"
+fi
+
+echo "start: $start; increment: $increment; length: $length" >> $seqres.full
+$DF_PROG $SCRATCH_MNT >> $seqres.full
+
+TRACE_PROG="strace -s99 -e fallocate,ioctl,openat -o $tmp.strace"
+
+for ((start = 0; start < length; start += increment)); do
+	echo "---------------------------" >> $seqres.full
+	echo "start: $start end: $((start + increment))" >> $seqres.full
+	echo "---------------------------" >> $seqres.full
+
+	fsmap_args="-vvvv $fsmap_devarg $((start / 512)) $((increment / 512))"
+	clearfree_args="-v all $start $increment"
+
+	$XFS_IO_PROG -c "fsmap $fsmap_args" $SCRATCH_MNT > $tmp.before
+	$TRACE_PROG $XFS_SPACEMAN_PROG -c "clearfree $clearfree_args" $SCRATCH_MNT &>> $seqres.full || break
+	cat $tmp.strace >> $seqres.full
+	$XFS_IO_PROG -c "fsmap $fsmap_args" $SCRATCH_MNT > $tmp.after
+	cat $tmp.before >> $seqres.full
+	cat $tmp.after >> $seqres.full
+done
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1401.out b/tests/xfs/1401.out
new file mode 100644
index 00000000000000..504999381ea9a8
--- /dev/null
+++ b/tests/xfs/1401.out
@@ -0,0 +1,2 @@
+QA output created by 1401
+Silence is golden

