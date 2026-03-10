Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3B19EED3;
	Tue, 10 Mar 2026 03:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114796; cv=none; b=Y64k9ZqzG7IqJa/wsPPxJBJll1+uSS2Ke/bNFl1ZtpPPQklEhhtvcdAC4HPYAe1+CtyAHfN3+KAplejusygVWetYbTlGhrs0AKbYP/39WGZNEe1BNF2HwEcu6EM9JA1nYxachvd985qeQKhBwJl2CguJ7JKCcLnHD6nAm3cu1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114796; c=relaxed/simple;
	bh=WoA9MByLXXTdJaYz0wopM/uFJ4qOCw/FDVqEKwoQfNM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3kGKevNZjsixrgMY891wvEEm44V9XPk9Ekmky37RwgWhXvWZb+7bAv21w6GQoPlgSBDDiDqBFFrJmQDFsJhkvxIYvhqHBIAIuSzFKPggibnQtGdCP+WHlTBENTnD92CWmKJsSrG7Z3Ipgdrj01KpYf4L+LsvJLLBbe+7DsRwEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qsx5n0SG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qsx5n0SG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38BEC19423;
	Tue, 10 Mar 2026 03:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114796;
	bh=WoA9MByLXXTdJaYz0wopM/uFJ4qOCw/FDVqEKwoQfNM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qsx5n0SGE3KMDfTeXX6SSS7vxWsQ3GkAkm36mYfmi58cQjdQxeVYTBHHCG8KzAtrA
	 t7R/chB/c4T87N64OYSIdCHG85u6zxRAU2yHoP3SweObegAMwLggu+gdacEOig+e3p
	 PZu1mUhtVzfCM0feYU9V4wyTiVZ+bLJMy0R0c3/adiFBj3VBlzsPtDF/bHUfbGwmZF
	 1ymS9RURtmY8ykUaj944sUaL9VaKLIFuC4wg588iKAn3tWx4QV8mtnrK0lgNHrcfHM
	 xy8STwAMRn4d6deLgFwaGAoYpuaEMniNYcdirXbdDxTAtFfpwM0DeVN4K0FNcSw71P
	 xKuKd6UEFUYOA==
Date: Mon, 09 Mar 2026 20:53:15 -0700
Subject: [PATCH 12/14] xfs: test xfs_healer wont repair the wrong filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403996.1186408.2147128379746061809.stgit@frogsfrogsfrogs>
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

Make sure that when xfs_healer needs to reopen a filesystem to repair it, it
won't latch on to another xfs filesystem that has been mounted atop the same
mountpoint.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1901     |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1901.out |    2 +
 2 files changed, 139 insertions(+)
 create mode 100755 tests/xfs/1901
 create mode 100755 tests/xfs/1901.out


diff --git a/tests/xfs/1901 b/tests/xfs/1901
new file mode 100755
index 00000000000000..c92dcf9a3b3d48
--- /dev/null
+++ b/tests/xfs/1901
@@ -0,0 +1,137 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1901
+#
+# Ensure that autonomous self healing won't fix the wrong filesystem if a
+# snapshot of the original filesystem is now mounted on the same directory as
+# the original.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+
+_cleanup()
+{
+	command -v _kill_fsstress &>/dev/null && _kill_fsstress
+	cd /
+	rm -r -f $tmp.*
+	test -e "$mntpt" && _unmount "$mntpt" &>/dev/null
+	test -e "$mntpt" && _unmount "$mntpt" &>/dev/null
+	test -e "$loop1" && _destroy_loop_device "$loop1"
+	test -e "$loop2" && _destroy_loop_device "$loop2"
+	test -e "$testdir" && rm -r -f "$testdir"
+}
+
+_require_test
+_require_scrub
+_require_xfs_io_command "repair"	# online repair support
+_require_xfs_db_command "blocktrash"
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
+
+testdir=$TEST_DIR/$seq
+mntpt=$testdir/mount
+disk1=$testdir/disk1
+disk2=$testdir/disk2
+
+mkdir -p "$mntpt"
+$XFS_IO_PROG -f -c "truncate 300m" $disk1
+$XFS_IO_PROG -f -c "truncate 300m" $disk2
+loop1="$(_create_loop_device "$disk1")"
+
+filter_mntpt() {
+	sed -e "s|$mntpt|MNTPT|g"
+}
+
+_mkfs_dev "$loop1" >> $seqres.full
+_mount "$loop1" "$mntpt" || _notrun "cannot mount victim filesystem"
+
+_xfs_has_feature $mntpt rmapbt || \
+	_notrun "reverse mapping required to test directory auto-repair"
+_xfs_has_feature $mntpt parent || \
+	_notrun "parent pointers required to test directory auto-repair"
+_require_xfs_healer $mntpt --repair
+
+# Configure the filesystem for automatic repair of the filesystem.
+$XFS_PROPERTY_PROG $mntpt set autofsck=repair >> $seqres.full
+
+# Create a largeish directory
+dblksz=$(_xfs_get_dir_blocksize "$mntpt")
+echo testdata > $mntpt/a
+mkdir -p "$mntpt/some/victimdir"
+for ((i = 0; i < (dblksz / 255); i++)); do
+	fname="$(printf "%0255d" "$i")"
+	ln $mntpt/a $mntpt/some/victimdir/$fname
+done
+
+# Did we get at least two dir blocks?
+dirsize=$(stat -c '%s' $mntpt/some/victimdir)
+test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
+
+# Clone the fs, break the directory, remount filesystem
+_unmount "$mntpt"
+
+cp --sparse=always "$disk1" "$disk2" || _fail "cannot copy disk1"
+loop2="$(_create_loop_device_like_bdev "$disk2" "$loop1")"
+
+$XFS_DB_PROG "$loop1" -x \
+	-c 'path /some/victimdir' \
+	-c 'bmap' \
+	-c 'dblock 1' \
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
+_mount "$loop1" "$mntpt" || _fail "cannot mount broken fs"
+
+_invoke_xfs_healer "$mntpt" "$tmp.healer" --repair
+
+# Stop the healer process so that it can't read error events while we do some
+# shenanigans.
+test -n "$XFS_HEALER_PID" || _fail "nobody set XFS_HEALER_PID?"
+kill -STOP $XFS_HEALER_PID
+
+
+echo "LOG $XFS_HEALER_PID SO FAR:" >> $seqres.full
+cat $tmp.healer >> $seqres.full
+
+# Access the broken directory to trigger a repair event, which will not yet be
+# processed.
+ls $mntpt/some/victimdir > /dev/null 2> $tmp.err
+filter_mntpt < $tmp.err
+
+ps auxfww | grep xfs_healer >> $seqres.full
+
+echo "LOG AFTER TRYING TO POKE:" >> $seqres.full
+cat $tmp.healer >> $seqres.full
+
+# Mount the clone filesystem to the same mountpoint so that the healer cannot
+# actually reopen it to perform repairs.
+_mount "$loop2" "$mntpt" -o nouuid || _fail "cannot mount decoy fs"
+
+grep -w xfs /proc/mounts >> $seqres.full
+
+# Continue the healer process so it can handle events now.  Wait a few seconds
+# while it fails to reopen disk1's mount point to repair things.
+kill -CONT $XFS_HEALER_PID
+sleep 2
+
+new_dir_unmount() {
+	_unmount "$mntpt"
+	_unmount "$mntpt"
+}
+
+# Unmount to kill the healer
+_kill_xfs_healer new_dir_unmount
+echo "LOG AFTER FAILURE" >> $seqres.full
+cat $tmp.healer >> $seqres.full
+
+# Did the healer log complaints about not being able to reopen the mountpoint
+# to enact repairs?
+grep -q 'Stale file handle' $tmp.healer || \
+	echo "Should have seen stale file handle complaints"
+
+status=0
+exit
diff --git a/tests/xfs/1901.out b/tests/xfs/1901.out
new file mode 100755
index 00000000000000..ff83e03725307a
--- /dev/null
+++ b/tests/xfs/1901.out
@@ -0,0 +1,2 @@
+QA output created by 1901
+ls: reading directory 'MNTPT/some/victimdir': Structure needs cleaning

