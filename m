Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2F712CDA5;
	Tue,  3 Mar 2026 00:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498577; cv=none; b=OPpNd9XANLClMSvISsS1VB82dsAcllJ0cqc33ofD4izhBRDhmU/x2bWNHtbFmtqSHTeox656+oWOItsRgZmnsaByzggFBlKHy3fHErG+WCIIWUJQUszN0+K2ZeCBxqn6VZmHfpZkZ/L/vmmTwcLxvU+FMKIfTwpS2Db23I1SCrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498577; c=relaxed/simple;
	bh=ugcUXQHyKYLZrAXFBZnkgHoGwbTMoflSP0S+qVl750s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qh+EE9YKCkhSC6rzL9giExDJzMeQLYhvh2o2CZmbw7sD8TICFM8JloouTgBFzurZCiYbbg41BhAiuReCTqzFFot35sUbU+OSx9b5MINffBLM422Keux7udmuX7fwKE+GpTQy6SHjXI8cqAgk2ptxm5TVszSS1LN+44zFhibCa4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJEpnZbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJEpnZbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33DC19423;
	Tue,  3 Mar 2026 00:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498577;
	bh=ugcUXQHyKYLZrAXFBZnkgHoGwbTMoflSP0S+qVl750s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rJEpnZbHs71sCtZf8XTvmcuhQqycQ7QYerd8Sbq78PX6iqN9NTvShoA7Ld/LbR/i+
	 JWJaBf1CI7vE7e5nyn1t4i17xueoaZCMYtly49u+3s3M5rZ1xzDMr9G+M8eQmQ8qb5
	 oTsRv7LW22Lr3kCSQDf6vvrXnmVEB6T3FNxbunahTMnldZ59HNpwcuJXS1juwUTM3g
	 odKR3r4PKY1ebzzKbGpS9XoGA66MNbmdHPZ4MOV7gXUa6tOK5orb6x0WZkiXK+ONbh
	 PH4DFIKSHkvS9wAPmW3M34aoHHciq8qT+D2ysPduWd+gS/ICVFlT8bdUr1F6U24s2y
	 AwAi+e/UZvcOw==
Date: Mon, 02 Mar 2026 16:42:57 -0800
Subject: [PATCH 08/13] xfs: test xfs_healer can report file media errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785916.483507.15910803339377438106.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
References: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that xfs_healer can actually report media errors as found by the
kernel.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1897     |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1897.out |    7 ++
 2 files changed, 179 insertions(+)
 create mode 100755 tests/xfs/1897
 create mode 100755 tests/xfs/1897.out


diff --git a/tests/xfs/1897 b/tests/xfs/1897
new file mode 100755
index 00000000000000..4670c333a2d82c
--- /dev/null
+++ b/tests/xfs/1897
@@ -0,0 +1,172 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1897
+#
+# Check that xfs_healer can report media errors.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+. ./common/systemd
+
+_require_scratch
+_require_scrub
+_require_dm_target error
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_xfs_io_command verifymedia
+
+filter_healer() {
+	_filter_scratch | \
+		grep -E '(media failed|media error)' | \
+		sed \
+		    -e 's/datadev/DEVICE/g' \
+		    -e 's/rtdev/DEVICE/g' \
+		    -e 's/ino [0-9]*/ino NUM/g' \
+		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
+		    -e 's/pos [0-9]*/pos NUM/g' \
+		    -e 's/len [0-9]*/len NUM/g' \
+		    -e 's/0x[0-9a-f]*/NUM/g' \
+		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g'
+}
+
+filter_verify() {
+	sed -e 's/\([a-z]*dev\): verify error at offset \([0-9]*\) length \([0-9]*\)/DEVICE: verify error at offset XXX length XXX/g'
+}
+
+_scratch_mkfs >> $seqres.full
+
+# The dm-error map added by this test doesn't work on zoned devices because
+# table sizes need to be aligned to the zone size, and even for zoned on
+# conventional this test will get confused because of the internal RT device.
+#
+# That check requires a mounted file system, so do a dummy mount before setting
+# up DM.
+_scratch_mount
+_require_xfs_scratch_non_zoned
+_require_xfs_healer $SCRATCH_MNT
+_scratch_unmount
+
+_dmerror_init
+_dmerror_mount
+
+# Write a file with 4 file blocks worth of data, figure out the LBA to target
+victim=$SCRATCH_MNT/a
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
+unset errordev
+verifymediadev="-d"
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="RT"
+	verifymediadev="-r"
+fi
+bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
+echo "$errordev:$bmap_str" >> $seqres.full
+
+phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
+kernel_sectors_per_fs_block=$((fs_blksz / 512))
+
+# Did we get at least 4 fs blocks worth of extent?
+min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
+test "$len" -lt $min_len_sectors && \
+	_fail "could not format a long enough extent on an empty fs??"
+
+phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
+
+echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full
+
+# Set the dmerror table so that all IO will pass through.
+_dmerror_reset_table
+
+cat >> $seqres.full << ENDL
+dmerror before:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+# All sector numbers that we feed to the kernel must be in units of 512b, but
+# they also must be aligned to the device's logical block size.
+logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+kernel_sectors_per_device_lba=$((logical_block_size / 512))
+
+# Pretend as bad one of the device LBAs in the middle of the extent.  Target
+# the second LBA of the third block of the four-block file extent that we
+# allocated earlier, but without overflowing into the fourth file block.
+bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
+bad_len=$kernel_sectors_per_device_lba
+if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
+	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
+fi
+if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
+	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
+fi
+_dmerror_mark_range_bad $bad_sector $bad_len $errordev
+
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+echo "Simulate media error"
+_scratch_invoke_xfs_healer "$tmp.healer"
+echo "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" >> $seqres.full
+$XFS_IO_PROG -x -c "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" $SCRATCH_MNT 2>&1 | filter_verify
+
+# Now mark the bad range good so that a retest shows no media failure.
+_dmerror_mark_range_good $bad_sector $bad_len $errordev
+_dmerror_load_error_table
+
+cat >> $seqres.full << ENDL
+dmerror after marking good:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+echo "No more media error"
+echo "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" >> $seqres.full
+$XFS_IO_PROG -x -c "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" $SCRATCH_MNT >> $seqres.full
+
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer _dmerror_unmount
+
+# filesystems without rmap do not translate media errors to lost file ranges
+# so fake the output
+_xfs_has_feature "$SCRATCH_DEV" rmapbt || \
+	echo "VICTIM pos 0 len 0: media failed" >> $tmp.healer
+
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1897.out b/tests/xfs/1897.out
new file mode 100755
index 00000000000000..1bb615c3119dce
--- /dev/null
+++ b/tests/xfs/1897.out
@@ -0,0 +1,7 @@
+QA output created by 1897
+Simulate media error
+DEVICE: verify error at offset XXX length XXX: Input/output error
+No more media error
+Kill healer
+SCRATCH_MNT DEVICE daddr NUM bbcount NUM: media error
+VICTIM pos NUM len NUM: media failed

