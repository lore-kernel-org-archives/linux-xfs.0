Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1193D19EED3;
	Tue, 10 Mar 2026 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114718; cv=none; b=Zv3vcSpFpiKx35nUdeBVM0oBnXyh07jLJVCUKYBQDUi8q7DUhTNKc7AsvkR7/4YEOktTxVjunwQSXAj3qlXTkG0A/vTOyBL52xFAzMldZCLh12KXVKvs4FB6NQc6W+EhNB1Okqbx37kvqcPHLNjAQjCEiiwKvnRIsaMNdZ2jmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114718; c=relaxed/simple;
	bh=zB+DK74/0oi8w5wfItnGtTNScrWUUshVoxGQyb02V3I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YofR2H01kHrBaywYLo7Z+4ru+udFBUeBElbgPuqvqLYUXlsC2wLlF23IizaKfudbhlsjG7k9nP9sGc4RXf97t/4hViNiAGrtW9bWbhZF64U4+BEckMLK9pJTVlo+o8sm/Q04AGVQqbxyi92ffMWy/cyh7+wx8C/79a3tFdh2Vsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMIni0qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMIni0qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC28C19423;
	Tue, 10 Mar 2026 03:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114717;
	bh=zB+DK74/0oi8w5wfItnGtTNScrWUUshVoxGQyb02V3I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QMIni0qz5WAIXIz+NN61qXKk3tzeqBIeR5eeilTdejj1xprJCig7OtpE3MZvMvHbk
	 9ixHvK2F9/sYHGn55QICPYeKYVCsJcmi5hoZewY7iKJjFzTV9zIxKysT2qKNHxETAm
	 EEpHF50r0uWx+In5E94lJGjX7TA+gHLK3F+NRt7jFpPLo/D/V6tHgjklJcMGq7QmAE
	 S8cJwYuudjQh7kUGDO/6whxUGMeSKCxP1ukFmXkGclOyuY8eyhGS7s6la5MZbzpI9J
	 7wNMS8KmyNEiwgCRn9XjvwG9IpvPF6YE2xX9qYa30wIxfclL7Not9+UrJ/iMGcRCoo
	 JuEBsLMVxKUZw==
Date: Mon, 09 Mar 2026 20:51:57 -0700
Subject: [PATCH 07/14] xfs: test xfs_healer can report file I/O errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403904.1186408.2255205098441030776.stgit@frogsfrogsfrogs>
In-Reply-To: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that xfs_healer can actually report file I/O errors.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1896     |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1896.out |   21 +++++
 2 files changed, 231 insertions(+)
 create mode 100755 tests/xfs/1896
 create mode 100644 tests/xfs/1896.out


diff --git a/tests/xfs/1896 b/tests/xfs/1896
new file mode 100755
index 00000000000000..911e1d5ee8a576
--- /dev/null
+++ b/tests/xfs/1896
@@ -0,0 +1,210 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1896
+#
+# Check that xfs_healer can report file IO errors.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+. ./common/systemd
+
+_require_scratch
+_require_scrub
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_dm_target error
+_require_no_xfs_always_cow	# no out of place writes
+
+# Ignore everything from the healer except for the four IO error log messages.
+# Strip out file handle and range information because the blocksize can vary.
+# Writeback and readahead can trigger multiple error messages due to retries,
+# hence the uniq.
+filter_healer_errors() {
+	_filter_scratch | \
+		grep -E '(buffered|directio)' | \
+		sed \
+		    -e 's/ino [0-9]*/ino NUM/g' \
+		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
+		    -e 's/pos [0-9]*/pos NUM/g' \
+		    -e 's/len [0-9]*/len NUM/g' \
+		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g' | \
+		sort | \
+		uniq
+}
+
+_scratch_mkfs >> $seqres.full
+
+#
+# The dm-error map added by this test doesn't work on zoned devices because
+# table sizes need to be aligned to the zone size, and even for zoned on
+# conventional this test will get confused because of the internal RT device.
+#
+# That check requires a mounted file system, so do a dummy mount before setting
+# up DM.
+#
+_scratch_mount
+_require_xfs_scratch_non_zoned
+_require_xfs_healer $SCRATCH_MNT
+_scratch_unmount
+
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+# Write a file with 4 file blocks worth of data, figure out the LBA to target
+victim=$SCRATCH_MNT/a
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
+unset errordev
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="RT"
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
+# Mark as bad one of the device LBAs in the middle of the extent.  Target the
+# second LBA of the third block of the four-block file extent that we allocated
+# earlier, but without overflowing into the fourth file block.
+bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
+bad_len=$kernel_sectors_per_device_lba
+if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
+	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
+fi
+if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
+	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
+fi
+
+# Remount to flush the page cache, start the healer, and make the LBA bad
+_dmerror_unmount
+_dmerror_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer"
+
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
+# See if buffered reads pick it up
+echo "Try buffered read"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Now mark the bad range good so that unmount won't fail due to IO errors.
+echo "Fix device"
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
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer _dmerror_unmount
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer_errors
+
+# Start the healer again so that can verify that the errors don't persist after
+# we flip back to the good dm table.
+echo "Remount and restart healer"
+_dmerror_mount
+_scratch_invoke_xfs_healer "$tmp.healer"
+
+# See if buffered reads pick it up
+echo "Try buffered read again"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read again"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write again"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write again"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Unmount fs to kill healer, then wait for it to finish
+echo "Kill healer again"
+_scratch_kill_xfs_healer _dmerror_unmount
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer_errors
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1896.out b/tests/xfs/1896.out
new file mode 100644
index 00000000000000..1378d4fad44522
--- /dev/null
+++ b/tests/xfs/1896.out
@@ -0,0 +1,21 @@
+QA output created by 1896
+Try buffered read
+pread: Input/output error
+Try directio read
+pread: Input/output error
+Try directio write
+pwrite: Input/output error
+Try buffered write
+fsync: Input/output error
+Fix device
+Kill healer
+VICTIM pos NUM len NUM: buffered_read: Input/output error
+VICTIM pos NUM len NUM: buffered_write: Input/output error
+VICTIM pos NUM len NUM: directio_read: Input/output error
+VICTIM pos NUM len NUM: directio_write: Input/output error
+Remount and restart healer
+Try buffered read again
+Try directio read again
+Try directio write again
+Try buffered write again
+Kill healer again

