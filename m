Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0877B1643B;
	Tue, 21 Jul 2026 03:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784605267; cv=none; b=bhz6lT726E8XLz+hmZ9kSw6768Iw/JEBHUSHADVMCkSQyJFE0GQxXiB2z3PTghAqNtCmZOeW166wVlQauYeZZgpbrbUzRfFOdSUaHT7xx6z6DxVHSXBW4fOz541A/+r2bq1PPhb7IHr83fa1PVhaszdG/t2huIDHeFnf3W6+hxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784605267; c=relaxed/simple;
	bh=oiLk8v52qEagfxOqpJRqonofNskAcnaoiY+PnlVwKLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gj7mHl0WXi3YEIMBw+H8JXIjrWrF+b4rqYDcBeWpLPLSmWyPytiESPxNjZV+yCtaYorDUjphjtEZTqoNm3t2a56cjZyyAV3hqiaB0Sph2CHVXVCz8Es1eSWII8FKZT1PGFe0EIJrRrdKW+v8Oj10QKJL9lb1Wz4SkwmPFVYTd5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTmmiFOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTmmiFOX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 764621F000E9;
	Tue, 21 Jul 2026 03:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784605265;
	bh=YjV2q/l+J0YHDMtZ2Hfvwz7DELIH4UgCOdTLqi0sgKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kTmmiFOXFliS2AEXUUtaIKtPSsw12HS9QNuvD14J07z7rlFKhx0dDzD11ReRpWj7u
	 TG8YBqtqXlv5KKqI0lBwEp8huqddN/52wkLuXu/zVEvnm1FI65tWEKP6DKglXmbt4Q
	 3+4/0ZT8L7Ip91m1y55rT0AA2RwecuoiYquITggOAI8Qz14gHcM/LAag+JCfKMzA08
	 3K/ZCUvoIaCZLRJ8hIW+xn6rjdIE+Xo2XDtJNjrk5B5kg3aIceX9HNvW7aFJe77Wcs
	 oOxy7vQGx2SlVBmJxEpNjsZb3USj+9h7nV3H1r55dofDIfm5PUcYbqn2EbiXT3YDIn
	 1qIY9mRs1l6wQ==
Date: Mon, 20 Jul 2026 20:41:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [RFC PATCH] xfs: test unlinked inode list checking and repair with
 loops
Message-ID: <20260721034105.GX7380@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Simple test of various weird ways we can screw up unlinked inode list
reconstruction.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1907     |  212 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1907.out |   17 ++++
 2 files changed, 229 insertions(+)
 create mode 100755 tests/xfs/1907
 create mode 100644 tests/xfs/1907.out

diff --git a/tests/xfs/1907 b/tests/xfs/1907
new file mode 100755
index 00000000000000..3b8634f3f16b3c
--- /dev/null
+++ b/tests/xfs/1907
@@ -0,0 +1,212 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1907
+#
+# Test using online fsck code to fix unlinked inodes on a clean filesystem that
+# never got cleaned up.
+#
+. ./common/preamble
+_begin_fstest auto quick unlink
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/quota
+
+_require_command "$TIMEOUT_PROG" timeout
+_require_xfs_db_command iunlink
+_require_scratch_nocheck	# we'll run repair ourselves
+
+_scratch_mount
+$XFS_IO_PROG -x -c 'repair -R agi 0' $SCRATCH_MNT 2>&1 | \
+	grep -q 'Operation not supported' && \
+	_notrun "cannot repair agi"
+_scratch_unmount
+
+# From the AGI definition
+XFS_AGI_UNLINKED_BUCKETS=64
+NULLAGINO="0xffffffff"
+
+# Try to make each iunlink bucket have this many inodes in it.
+IUNLINK_BUCKETLEN=5
+
+# Disable quota since quotacheck will break this test
+orig_mount_options="$MOUNT_OPTIONS"
+_qmount_option 'noquota'
+
+format_scratch() {
+	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
+	source "${tmp}.mkfs"
+	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
+
+	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
+	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
+
+	ROOTINO="$(_scratch_xfs_db -c 'sb' -c 'print rootino' | cut -d ' ' -f 3)"
+
+	BUCKET_23=()
+	BUCKET_24=()
+	for badinode in "${BADINODES[@]}"; do
+		(( (badinode % 64) == 23 )) && BUCKET_23+=("${badinode}")
+		(( (badinode % 64) == 24 )) && BUCKET_24+=("${badinode}")
+	done
+	test "${#BUCKET_23[@]}" -ge "$IUNLINK_BUCKETLEN" || \
+		echo "bucket 23 should have at least $IUNLINK_BUCKETLEN inodes, has ${#BUCKET_23[@]}"
+	test "${#BUCKET_24[@]}" -ge "$IUNLINK_BUCKETLEN" || \
+		echo "bucket 24 should have at least $IUNLINK_BUCKETLEN inodes, has ${#BUCKET_23[@]}"
+
+	# Log what we think the bucket 23 unlinked list will look like
+	printf "ROOTINO 0x%x\n" "$ROOTINO" >> $seqres.full
+	for badinode in "${BUCKET_23[@]}"; do
+		printf "0x%x <- " "${badinode}" >> $seqres.full
+	done
+	echo " AGI.iunlinked[23]" >> $seqres.full
+	for badinode in "${BUCKET_24[@]}"; do
+		printf "0x%x <- " "${badinode}" >> $seqres.full
+	done
+	echo " AGI.iunlinked[24]" >> $seqres.full
+
+	# Log what the actual bucket 23 unlinked list ended up looking like
+	local subcommands=()
+	for badinode in "${BUCKET_23[@]}"; do
+		subcommands+=(-c "inode ${badinode}" -c "print next_unlinked")
+	done
+	_scratch_xfs_db -x "${subcommands[@]}" >> $seqres.full
+}
+
+__repair_check_scratch() {
+	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
+		tee -a $seqres.full | \
+		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
+	return "${PIPESTATUS[0]}"
+}
+
+exercise_scratch() {
+	# Create a bunch of files...
+	declare -A inums
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		touch "${SCRATCH_MNT}/${i}" || break
+		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
+	done
+
+	# ...then delete them to exercise the unlinked buckets
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		if ! rm -f "${SCRATCH_MNT}/${i}"; then
+			echo "rm failed on inum ${inums[$i]}"
+			break
+		fi
+	done
+}
+
+test_body() {
+	_scratch_mount
+	timeout 30s $XFS_IO_PROG -x -c 'scrub agi 0' -c 'repair agi 0' $SCRATCH_MNT
+	$XFS_IO_PROG -x -c 'repair fscounters' $SCRATCH_MNT >> $seqres.full
+	exercise_scratch
+	_scratch_unmount
+	final_check_scratch
+}
+
+# Offline repair should not find anything
+final_check_scratch() {
+	__repair_check_scratch
+	res=$?
+	if [ $res -eq 2 ]; then
+		echo "scratch fs went offline?"
+		_scratch_mount
+		_scratch_unmount
+		__repair_check_scratch
+	fi
+	test "$res" -ne 0 && echo "repair returned $res?"
+}
+
+echo "+ Part 1: Fix a correct unlinked list" | tee -a $seqres.full
+_kernlog "part 1"
+format_scratch
+test_body
+
+echo "+ Part 2: Fix a loop between 1 and 3" | tee -a $seqres.full
+_kernlog "part 2"
+format_scratch
+# BUCKET_23 is in reverse order of the ondisk list, so we make
+# inode 1 point back to inode 3.
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[1]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${BUCKET_23[3]}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 3: Fix a truncated bucket" | tee -a $seqres.full
+_kernlog "part 3"
+format_scratch
+_scratch_xfs_db -x \
+	-c "agi 0" \
+	-c "print" \
+	-c "write -d unlinked[23] ${NULLAGINO}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 4: Fix a loop at the end" | tee -a $seqres.full
+_kernlog "part 4"
+format_scratch
+# BUCKET_23 is in reverse order of the ondisk list, so we make
+# inode 0 point back to inode 0.
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[0]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${BUCKET_23[0]}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 5: Fix an inode in the wrong bucket" | tee -a $seqres.full
+_kernlog "part 5"
+format_scratch
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[0]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${BUCKET_24[1]}" \
+	-c "inode ${BUCKET_24[2]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${NULLAGINO}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 6: Fix an inode that isn't free and truncates list" | tee -a $seqres.full
+_kernlog "part 6"
+format_scratch
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[2]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${ROOTINO}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 7: Fix an inode that isn't free" | tee -a $seqres.full
+_kernlog "part 7"
+format_scratch
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[2]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${ROOTINO}" \
+	-c "inode ${ROOTINO}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked ${BUCKET_23[1]}" \
+	>> $seqres.full
+test_body
+
+echo "+ Part 8: Fix an totally unallocated inode" | tee -a $seqres.full
+_kernlog "part 8"
+format_scratch
+target=$(( BADINODES[-1] + 256 ))
+_scratch_xfs_db -x \
+	-c "inode ${BUCKET_23[2]}" \
+	-c "print next_unlinked" \
+	-c "write -d next_unlinked $target" \
+	>> $seqres.full
+test_body
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1907.out b/tests/xfs/1907.out
new file mode 100644
index 00000000000000..83746ad602b21d
--- /dev/null
+++ b/tests/xfs/1907.out
@@ -0,0 +1,17 @@
+QA output created by 1907
++ Part 1: Fix a correct unlinked list
+Corruption detected.
++ Part 2: Fix a loop between 1 and 3
+Corruption detected.
++ Part 3: Fix a truncated bucket
+Corruption detected.
++ Part 4: Fix a loop at the end
+Corruption detected.
++ Part 5: Fix an inode in the wrong bucket
+Corruption detected.
++ Part 6: Fix an inode that isn't free and truncates list
+Corruption detected.
++ Part 7: Fix an inode that isn't free
+Corruption detected.
++ Part 8: Fix an totally unallocated inode
+Corruption detected.
