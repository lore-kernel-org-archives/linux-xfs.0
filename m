Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDE5C6FA8F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 23:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbjH3X0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjH3X0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 19:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D22BC
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 16:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D5F62AAF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 23:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691FEC433C7;
        Wed, 30 Aug 2023 23:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693437986;
        bh=0nClS/a1rqeokvS1sPu6Kvh6jysAKH3saBETMEEF+ys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A5lRohtPSbqcoVImuHjb3TtW91qoA42A410HG67kIbZAzWxkNvUmjFHESERZ0tGvs
         wHQsXMxq7VHQVLq5Z18CeCyQFLeo0gjRfLPWn0wstv9ss78Vhvh/0QyLBSk9UJTLSM
         iS8Xv85rUxR0Ahdz05ovpeveGgrw9x0F6HEUAbVjPcbMsNZc1ANpY8S3JN47HW0AaJ
         LWjcmVciUV7rwK2KCpKooDtJ8yXsAuE1BQjWyWKTCCSsZU+Epf3VnfShvZOKf7/lSz
         NIxPyyC/c+ydATqMbFf6a0jcoWnrw1bMJ7dOGEkZU4jUCFChoxAp5jKXYf2habLsIV
         fm1xiFEFt0hRQ==
Date:   Wed, 30 Aug 2023 16:26:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC PATCH] fstests: test unlinked inode list repair on demand
Message-ID: <20230830232625.GM28186@frogsfrogsfrogs>
References: <20230830152659.GJ28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830152659.GJ28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a test to exercise recovery of unlinked inodes on a clean
filesystem.  This was definitely possible on old kernels that on an ro
mount would clean the log without processing the iunlink list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc          |    4 +
 tests/xfs/1872     |   89 +++++++++++++++++++++
 tests/xfs/1872.out |    3 +
 tests/xfs/1873     |  216 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1873.out |    6 +
 5 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1872
 create mode 100644 tests/xfs/1872.out
 create mode 100755 tests/xfs/1873
 create mode 100644 tests/xfs/1873.out

diff --git a/common/rc b/common/rc
index 45d488b2aa..982dd8c312 100644
--- a/common/rc
+++ b/common/rc
@@ -2674,9 +2674,11 @@ _require_xfs_io_command()
 		param_checked="$pwrite_opts $param"
 		;;
 	"scrub"|"repair")
-		testio=`$XFS_IO_PROG -x -c "$command probe" $TEST_DIR 2>&1`
+		test -z "$param" && param="probe"
+		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
+		param_checked="$param"
 		;;
 	"startupdate"|"commitupdate"|"cancelupdate")
 		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
diff --git a/tests/xfs/1872 b/tests/xfs/1872
new file mode 100755
index 0000000000..0fd5fbcb70
--- /dev/null
+++ b/tests/xfs/1872
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1872
+#
+# Test using runtime code to fix unlinked inodes on a clean filesystem that
+# never got cleaned up.
+#
+. ./common/preamble
+_begin_fstest auto quick unlink
+
+# Import common functions.
+source ./common/filter
+source ./common/fuzzy
+source ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_db_command iunlink
+_require_scratch_nocheck	# we'll run repair ourselves
+
+# From the AGI definition
+XFS_AGI_UNLINKED_BUCKETS=64
+
+# Try to make each iunlink bucket have this many inodes in it.
+IUNLINK_BUCKETLEN=5
+
+# XXX Forcibly disable quota since quotacheck will break this test
+_qmount_option 'noquota'
+
+format_scratch() {
+	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
+	source "${tmp}.mkfs"
+	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
+
+	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
+	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
+}
+
+__repair_check_scratch() {
+	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
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
+echo "+ Part 0: See if runtime can recover the unlinked list" | tee -a $seqres.full
+format_scratch
+_scratch_mount
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1872.out b/tests/xfs/1872.out
new file mode 100644
index 0000000000..0aa4b5ae5c
--- /dev/null
+++ b/tests/xfs/1872.out
@@ -0,0 +1,3 @@
+QA output created by 1872
++ Part 0: See if runtime can recover the unlinked list
+Silence is golden
diff --git a/tests/xfs/1873 b/tests/xfs/1873
new file mode 100755
index 0000000000..1e2f13f2c6
--- /dev/null
+++ b/tests/xfs/1873
@@ -0,0 +1,216 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1873
+#
+# Functional test of using online repair to fix unlinked inodes on a clean
+# filesystem that never got cleaned up.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+# Import common functions.
+source ./common/filter
+source ./common/fuzzy
+source ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_db_command iunlink
+# The iunlink bucket repair code wasn't added to the AGI repair code
+# until after the directory repair code was merged
+_require_xfs_io_command repair -R directory
+_require_scratch_nocheck	# repair doesn't like single-AG fs
+
+# From the AGI definition
+XFS_AGI_UNLINKED_BUCKETS=64
+
+# Try to make each iunlink bucket have this many inodes in it.
+IUNLINK_BUCKETLEN=5
+
+# XXX Forcibly disable quota since quotacheck will break this test
+_qmount_option 'noquota'
+
+format_scratch() {
+	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
+	source "${tmp}.mkfs"
+	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
+
+	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
+	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
+}
+
+__repair_check_scratch() {
+	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
+		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
+	return "${PIPESTATUS[0]}"
+}
+
+corrupt_scratch() {
+	# How far into the iunlink bucket chain do we target inodes for corruption?
+	# 1 = target the inode pointed to by the AGI
+	# 3 = middle of bucket list
+	# 5 = last element in bucket
+	local corruption_bucket_depth="$1"
+	if ((corruption_bucket_depth < 1 || corruption_bucket_depth > IUNLINK_BUCKETLEN)); then
+		echo "${corruption_bucket_depth}: Value must be between 1 and ${IUNLINK_BUCKETLEN}."
+		return 1
+	fi
+
+	# Index of the inode numbers within BADINODES
+	local bad_ino1_idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth) * XFS_AGI_UNLINKED_BUCKETS))
+	local bad_ino2_idx=$((bad_ino1_idx + 1))
+
+	# Inode numbers to target
+	local bad_ino1="${BADINODES[bad_ino1_idx]}"
+	local bad_ino2="${BADINODES[bad_ino2_idx]}"
+	printf "bad: 0x%x 0x%x\n" "${bad_ino1}" "${bad_ino2}" | _tee_kernlog >> $seqres.full
+
+	# Bucket within AGI 0's iunlinked array.
+	local ino1_bucket="$((bad_ino1 % XFS_AGI_UNLINKED_BUCKETS))"
+	local ino2_bucket="$((bad_ino2 % XFS_AGI_UNLINKED_BUCKETS))"
+
+	# The first bad inode stays on the unlinked list but gets a nonzero
+	# nlink; the second bad inode is removed from the unlinked list but
+	# keeps its zero nlink
+	_scratch_xfs_db -x \
+		-c "inode ${bad_ino1}" -c "write -d core.nlinkv2 5555" \
+		-c "agi 0" -c "fuzz -d unlinked[${ino2_bucket}] ones" -c "print unlinked" >> $seqres.full
+
+	local iwatch=()
+	local idx
+
+	# Make a list of the adjacent iunlink bucket inodes for the first inode
+	# that we targeted.
+	if [ "${corruption_bucket_depth}" -gt 1 ]; then
+		# Previous ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx]}")
+	fi
+	iwatch+=("${bad_ino1}")
+	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
+		# Next ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx]}")
+	fi
+
+	# Make a list of the adjacent iunlink bucket inodes for the second
+	# inode that we targeted.
+	if [ "${corruption_bucket_depth}" -gt 1 ]; then
+		# Previous ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx + 1]}")
+	fi
+	iwatch+=("${bad_ino2}")
+	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
+		# Next ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx + 1]}")
+	fi
+
+	# Construct a grep string for tracepoints.
+	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} |bucket ${fuzz_bucket} "
+	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} "
+	for ino in "${iwatch[@]}"; do
+		f="$(printf "|ino 0x%x" "${ino}")"
+		GREP_STR="${GREP_STR}${f}"
+	done
+	GREP_STR="${GREP_STR})"
+	echo "grep -E \"${GREP_STR}\"" >> $seqres.full
+
+	# Dump everything we did to to the full file.
+	local db_dump=(-c 'agi 0' -c 'print unlinked')
+	db_dump+=(-c 'addr root' -c 'print')
+	test "${ino1_bucket}" -gt 0 && \
+		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino1_bucket - 1))")
+	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino1_bucket}")
+	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino2_bucket}")
+	test "${ino2_bucket}" -lt 63 && \
+		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino2_bucket + 1))")
+	db_dump+=(-c "inode $bad_ino1" -c 'print core.nlinkv2 v3.inumber next_unlinked')
+	db_dump+=(-c "inode $bad_ino2" -c 'print core.nlinkv2 v3.inumber next_unlinked')
+	_scratch_xfs_db "${db_dump[@]}" >> $seqres.full
+
+	# Test run of repair to make sure we find disconnected inodes
+	__repair_check_scratch | \
+		sed -e 's/disconnected inode \([0-9]*\)/disconnected inode XXXXXX/g' \
+		    -e 's/next_unlinked in inode \([0-9]*\)/next_unlinked in inode XXXXXX/g' \
+		    -e 's/unlinked bucket \([0-9]*\) is \([0-9]*\) in ag \([0-9]*\) .inode=\([0-9]*\)/unlinked bucket YY is XXXXXX in ag Z (inode=AAAAAA/g' | \
+		uniq -c >> $seqres.full
+	res=${PIPESTATUS[0]}
+	test "$res" -ne 0 || echo "repair returned $res after corruption?"
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
+echo "+ Part 1: See if scrub can recover the unlinked list" | tee -a $seqres.full
+format_scratch
+_kernlog "no bad inodes"
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 2: Corrupt the first inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 1
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 3: Corrupt the middle inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 3
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 4: Corrupt the last inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 5
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1873.out b/tests/xfs/1873.out
new file mode 100644
index 0000000000..0e36bd2304
--- /dev/null
+++ b/tests/xfs/1873.out
@@ -0,0 +1,6 @@
+QA output created by 1873
++ Part 1: See if scrub can recover the unlinked list
++ Part 2: Corrupt the first inode in the bucket
++ Part 3: Corrupt the middle inode in the bucket
++ Part 4: Corrupt the last inode in the bucket
+Silence is golden
