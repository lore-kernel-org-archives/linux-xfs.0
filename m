Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0FB22CF2C;
	Thu, 16 Jan 2025 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070833; cv=none; b=nov2AU5WzZC1pUsxlrddfjyoSSOtuCAU9NL6WgTbzp2njQ43da1n+23G/rY9FbCn5vnq8K5/Yx0iRKnfkuN1qfHodEK8MDk7xXikA4Nh8+31cjwU3kMlamuYxdbr287AmB897py+fJvZVKb+AZkNCZz6lEVG8r6vMNrYUUBK6Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070833; c=relaxed/simple;
	bh=uErrAG9YIoMvsGeHi2UWF27s4exnGBV0NWDkvNEcxGE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M23CjaBTh7MivO3a9VWgydZKmh3u8uL9FQ1v6YO7IbKe+LnNDO8fHPHuJix7cTlNqsz8/mZ3k1BZ8J5JVYpZHUJ9ahmvE4qgcFs4SYM/wA0dxSDJ09PuETGdMsabnMelXaOsIsfHpkW8CTpvmSAb+ZlTMj0o6XvWq0lC7e52cKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ab6TR752; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ab6TR752"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC28C4CED6;
	Thu, 16 Jan 2025 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070833;
	bh=uErrAG9YIoMvsGeHi2UWF27s4exnGBV0NWDkvNEcxGE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ab6TR752bf8ZPR3vqkn5ZrjLs6rrwC6hKuOSxCFR/i5VDSboSNRmpn24bU+ju/ApS
	 LgjHeVdSiT1dhuyQG5oAVFga4qKPFetDlYPTzOw0C/MfD+B0ko1t84N9c9nilyKQ4u
	 YF0fLxSsFYJkRV/EB1SvgHpq6Tr8WJOhd1lIaNSD5Exi7XnTyzUuI5v5+8qKzphu2D
	 typaVDLe8tCDviIL4ktoKRuo34pk3xKgkRwoB+WPb7TzyKAfPgbxNUOd7/4ssz56F+
	 WWhyP33h8NFLK4peDWlxz4EymMh9WvL3tkbQj2EVeZSZW6rK8ND69YRHBLLRgjGAyL
	 5glnYQKaUl+1Q==
Date: Thu, 16 Jan 2025 15:40:32 -0800
Subject: [PATCH 3/3] xfs: regression testing of quota on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706977106.1931302.6039966897834501224.stgit@frogsfrogsfrogs>
In-Reply-To: <173706977056.1931302.2974286403286751639.stgit@frogsfrogsfrogs>
References: <173706977056.1931302.2974286403286751639.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that quota accounting and enforcement work correctly for
realtime volumes on XFS.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1858     |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1858.out |   47 ++++++++++++++
 2 files changed, 221 insertions(+)
 create mode 100755 tests/xfs/1858
 create mode 100644 tests/xfs/1858.out


diff --git a/tests/xfs/1858 b/tests/xfs/1858
new file mode 100755
index 00000000000000..64c536024f6ec0
--- /dev/null
+++ b/tests/xfs/1858
@@ -0,0 +1,174 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1858
+#
+# Functional testing for realtime quotas.
+
+. ./common/preamble
+_begin_fstest auto quick quota realtime
+
+. ./common/quota
+. ./common/filter
+
+_require_test_program "punch-alternating"
+_require_scratch
+_require_user
+
+echo "Format filesystem" | tee -a $seqres.full
+_scratch_mkfs > $seqres.full
+_try_scratch_mount -o usrquota || \
+	_notrun "Can't mount with realtime quota enabled"
+
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_scratch_supports_rtquota || _notrun "Requires realtime quota"
+
+# Make sure all our files are on the rt device
+_xfs_force_bdev realtime $SCRATCH_MNT
+chmod a+rwx $SCRATCH_MNT
+
+# Record rt geometry
+bmbt_blksz=$(_get_block_size $SCRATCH_MNT)
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+rextsize=$((file_blksz / bmbt_blksz))
+echo "bmbt_blksz $bmbt_blksz" >> $seqres.full
+echo "file_blksz $file_blksz" >> $seqres.full
+echo "rextsize $rextsize" >> $seqres.full
+
+note() {
+	echo -e "\n$*" | tee -a $seqres.full
+}
+
+# Report on the user's block and rt block usage, soft limit, hard limit, and
+# warning count for rt volumes
+report_rtusage() {
+	local user="$1"
+	local timeout_arg="$2"
+	local print_timeout=0
+
+	test -z "$user" && user=$qa_user
+	test -n "$timeout_arg" && print_timeout=1
+
+	$XFS_QUOTA_PROG -c "quota -u -r -n -N $user" $SCRATCH_MNT | \
+		sed -e 's/ days/_days/g' >> $seqres.full
+
+	$XFS_QUOTA_PROG -c "quota -u -r -n -N $user" $SCRATCH_MNT | \
+		sed -e 's/ days/_days/g' | \
+		awk -v user=$user -v print_timeout=$print_timeout -v file_blksz=$file_blksz \
+			'{printf("%s[real] %d %d %d %d %s\n", user, $2 * 1024 / file_blksz, $3 * 1024 / file_blksz, $4 * 1024 / file_blksz, $5, print_timeout ? $6 : "---");}'
+}
+
+note "Write 128rx to root"
+$XFS_IO_PROG -f -c "pwrite 0 $((128 * file_blksz))" $SCRATCH_MNT/file1 > /dev/null
+chmod a+r $SCRATCH_MNT/file1
+_scratch_sync
+report_rtusage 0
+
+note "Write 64rx to root, 4444, and 5555."
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3.5555 > /dev/null
+chown 5555 $SCRATCH_MNT/file3.5555
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3.4444 > /dev/null
+chown 4444 $SCRATCH_MNT/file3.4444
+$XFS_IO_PROG -f -c "pwrite 0 $((64 * file_blksz))" $SCRATCH_MNT/file3 > /dev/null
+_scratch_sync
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Move 64rx from root to 5555"
+chown 5555 $SCRATCH_MNT/file3
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Move 64rx from 5555 to 4444"
+chown 4444 $SCRATCH_MNT/file3
+report_rtusage 0
+report_rtusage 4444
+report_rtusage 5555
+
+note "Set hard limit of 1024rx and check enforcement"
+$XFS_QUOTA_PROG -x -c "limit -u rtbhard=$((1024 * file_blksz)) $qa_user" $SCRATCH_MNT
+# fsync (-w) after pwrite because enforcement only begins when space usage is
+# committed.  If delalloc is enabled, this doesn't happen until writeback.
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w 0 $((2048 * file_blksz))' $SCRATCH_MNT/file2"
+report_rtusage
+
+note "Set soft limit of 512rx and check timelimit enforcement"
+rm -f $SCRATCH_MNT/file2 $SCRATCH_MNT/file2.1
+period=6	# seconds
+$XFS_QUOTA_PROG -x \
+	-c "limit -u rtbsoft=$((512 * file_blksz)) rtbhard=0 $qa_user" \
+	-c "timer -u -r -d $period" \
+	-c 'state -u' $SCRATCH_MNT >> $seqres.full
+
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w 0 $((512 * file_blksz))' $SCRATCH_MNT/file2" > /dev/null
+report_rtusage
+
+overflow=$(date +%s)
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w -b $file_blksz 0 $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+sleep $((period / 2))
+note "Try again after $((period / 2))s"
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w -b $file_blksz $file_blksz $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+sleep $period
+note "Try again after another ${period}s"
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w -b $file_blksz $((2 * file_blksz)) $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage
+
+note "Extend time limits and warnings"
+rm -f $SCRATCH_MNT/file2 $SCRATCH_MNT/file2.1
+$XFS_QUOTA_PROG -x \
+	-c "limit -u rtbsoft=$((512 * file_blksz)) rtbhard=0 $qa_user" \
+	-c "timer -u -r -d 49h" $SCRATCH_MNT \
+	-c 'state -u' $SCRATCH_MNT >> $seqres.full
+
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w 0 $((512 * file_blksz))' $SCRATCH_MNT/file2" > /dev/null
+report_rtusage $qa_user want_timeout
+
+note "Try to trip a 2 day grace period"
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w -b $file_blksz 0 $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage $qa_user want_timeout
+
+$XFS_QUOTA_PROG -x -c "timer -u -r 73h $qa_user" $SCRATCH_MNT
+
+note "Try to trip a 3 day grace period"
+_su $qa_user -c "$XFS_IO_PROG -f -c 'pwrite -w -b $file_blksz $file_blksz $file_blksz' $SCRATCH_MNT/file2.1" > /dev/null
+report_rtusage $qa_user want_timeout
+
+note "Test quota applied to bmbt"
+
+# Testing quota enforcement for bmbt shape changes is tricky.  The block
+# reservation will be for enough blocks to handle the maximal btree split.
+# This is (approximately) 9 blocks no matter the size of the existing extent
+# map structure, so we set the hard limit to one more than this quantity.
+#
+# However, that means that we need to make a file of at least twice that size
+# to ensure that we create enough extent records even in the rextsize==1 case
+# where punching doesn't just create unwritten records.
+#
+# Unfortunately, it's very difficult to predict when exactly the EDQUOT will
+# come down, so we just look for the error message.
+extent_records=$(( (25 * bmbt_blksz) / 16))
+echo "extent_records $extent_records" >> $seqres.full
+
+rm -f $SCRATCH_MNT/file2
+$XFS_QUOTA_PROG -x \
+	-c "limit -u rtbsoft=0 rtbhard=0 $qa_user" \
+	-c "limit -u bhard=$((bmbt_blksz * 10)) bsoft=0 $qa_user" \
+	-c 'state -u' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 -b 64m 0 $((extent_records * file_blksz))" $SCRATCH_MNT/file2 > /dev/null
+_scratch_sync
+chown $qa_user $SCRATCH_MNT/file2
+$here/src/punch-alternating $SCRATCH_MNT/file2 2>&1 | _filter_scratch
+
+$XFS_QUOTA_PROG -c "quota -u -r -n -N $qa_user" -c "quota -u -b -n -N $qa_user" $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c "bmap -e -l -p -v" $SCRATCH_MNT/file2 >> $seqres.full
+
+# success, all done
+$XFS_QUOTA_PROG -x -c 'report -a -u' -c 'report -a -u -r' $SCRATCH_MNT >> $seqres.full
+ls -latr $SCRATCH_MNT >> $seqres.full
+status=0
+exit
diff --git a/tests/xfs/1858.out b/tests/xfs/1858.out
new file mode 100644
index 00000000000000..85298618d26e0f
--- /dev/null
+++ b/tests/xfs/1858.out
@@ -0,0 +1,47 @@
+QA output created by 1858
+Format filesystem
+
+Write 128rx to root
+0[real] 128 0 0 0 ---
+
+Write 64rx to root, 4444, and 5555.
+0[real] 192 0 0 0 ---
+4444[real] 64 0 0 0 ---
+5555[real] 64 0 0 0 ---
+
+Move 64rx from root to 5555
+0[real] 128 0 0 0 ---
+4444[real] 64 0 0 0 ---
+5555[real] 128 0 0 0 ---
+
+Move 64rx from 5555 to 4444
+0[real] 128 0 0 0 ---
+4444[real] 128 0 0 0 ---
+5555[real] 64 0 0 0 ---
+
+Set hard limit of 1024rx and check enforcement
+pwrite: Disk quota exceeded
+fsgqa[real] 1024 0 1024 0 ---
+
+Set soft limit of 512rx and check timelimit enforcement
+fsgqa[real] 512 512 0 0 ---
+fsgqa[real] 513 512 0 0 ---
+
+Try again after 3s
+fsgqa[real] 514 512 0 0 ---
+
+Try again after another 6s
+pwrite: Disk quota exceeded
+fsgqa[real] 514 512 0 0 ---
+
+Extend time limits and warnings
+fsgqa[real] 512 512 0 0 [--------]
+
+Try to trip a 2 day grace period
+fsgqa[real] 513 512 0 0 [2_days]
+
+Try to trip a 3 day grace period
+fsgqa[real] 514 512 0 0 [3_days]
+
+Test quota applied to bmbt
+SCRATCH_MNT/file2: Disk quota exceeded

