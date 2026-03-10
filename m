Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305B3BD62F;
	Tue, 10 Mar 2026 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114640; cv=none; b=Je5CvxfeFMV23a047bvuKtvPb5FI0MYnl5/MD9Ypou60r5yK4C8SqTY4HW678yBrK6WZibj9zvVeGooHhUXUS9Tkh7Z3U/HQg30cqLmQ5yEMKoxQN4FFTVzuI/EGYOLQTsl1Ymou7AELLrvAlXdwmE4vcPLGdgxe/QO2afn4O+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114640; c=relaxed/simple;
	bh=QoMDD47NiCbFdUIIHJVFJTqqaQvN0ICYjggpcXl7cMg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTgvt7pAjoRhBklwV98IjVGb4yEZl+L647/YyagAicUImV5vKQp6907q76nr52gD/3oIFsbSI6hWkdcZ0hXIPZxcIkVpTB7EI5mQ5uybFkyfpoKIwiu202Nck3aun++AlBpMiwVUuyBHFgAhc3XnePs5SvE9cpYGsJyFpY+OMyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qZcfsgXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qZcfsgXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCB6C19425;
	Tue, 10 Mar 2026 03:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114639;
	bh=QoMDD47NiCbFdUIIHJVFJTqqaQvN0ICYjggpcXl7cMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qZcfsgXXKgc6ovdfsiT7F0BWNTqVUboUYEL/9yz6U/zB8HJBZZTN8F9uHTr3SA609
	 RM79Mk+Wbi9stIu2smLwoYkqMrX39qSJFZHn7dnWSGlD722KQB7WKUFgfeSH8SsuFM
	 PrhGCzeLIfhFN0C9EmVx7/k+pBm39c/D2u5Ovnsr4aV4VA8PqUroI48piAX7Kkap/r
	 0PJr4FFDb1wkxWdvNGOzC05V8a8oeM7H+YifOSgRyaPoRFVGR+eh64wTyh+uQ7raP9
	 mr4hXal08/3orzEoNYUieyxyuUmAXZL42d/dnGseCFQ0L+Mt3U43a2GJpdGG5sWOxV
	 WfkYnh5tfR5GA==
Date: Mon, 09 Mar 2026 20:50:39 -0700
Subject: [PATCH 02/14] xfs: test for metadata corruption error reporting via
 healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403813.1186408.6579877651738146939.stgit@frogsfrogsfrogs>
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

Check if we can detect runtime metadata corruptions via the health
monitor.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1879     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1879.out |    8 ++++
 2 files changed, 101 insertions(+)
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out


diff --git a/tests/xfs/1879 b/tests/xfs/1879
new file mode 100755
index 00000000000000..75bc8e3b5f4316
--- /dev/null
+++ b/tests/xfs/1879
@@ -0,0 +1,93 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1879
+#
+# Corrupt some metadata and try to access it with the health monitoring program
+# running.  Check that healthmon observes a metadata error.
+#
+. ./common/preamble
+_begin_fstest auto quick eio selfhealing
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $testdir
+}
+
+. ./common/filter
+
+_require_scratch_nocheck
+_require_scratch_xfs_crc # can't detect minor corruption w/o crc
+_require_xfs_io_command healthmon
+
+# Disable the scratch rt device to avoid test failures relating to the rt
+# bitmap consuming all the free space in our small data device.
+unset SCRATCH_RTDEV
+
+echo "Format and mount"
+_scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+_scratch_mount
+mkdir $SCRATCH_MNT/a/
+# Enough entries to get to a single block directory
+for ((i = 0; i < ( (isize + 255) / 256); i++)); do
+	path="$(printf "%s/a/%0255d" "$SCRATCH_MNT" "$i")"
+	touch "$path"
+done
+inum="$(stat -c %i "$SCRATCH_MNT/a")"
+_scratch_unmount
+
+# Fuzz the directory block so that the touch below will be guaranteed to trip
+# a runtime sickness report in exactly the manner we desire.
+_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" -c 'fuzz bhdr.hdr.owner add' -c print &>> $seqres.full
+
+# Try to allocate space to trigger a metadata corruption event
+echo "Runtime corruption detection"
+_scratch_mount
+$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
+sleep 1	# wait for program to start up
+touch $SCRATCH_MNT/a/farts &>> $seqres.full
+_scratch_unmount
+
+wait	# for healthmon to finish
+
+# Did we get errors?
+check_healthmon()
+{
+	cat $tmp.healthmon >> $seqres.full
+	_filter_scratch < $tmp.healthmon | \
+		grep -E '(sick|corrupt)' | \
+		sed -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT ino [0-9]* gen 0x[0-9a-f]*|VICTIM|g' | \
+		sort | \
+		uniq
+}
+check_healthmon
+
+# Run scrub to trigger a health event from there too.
+echo "Scrub corruption detection"
+_scratch_mount
+if _supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV; then
+	$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
+	sleep 1	# wait for program to start up
+	$XFS_SCRUB_PROG -n $SCRATCH_MNT &>> $seqres.full
+	_scratch_unmount
+
+	wait	# for healthmon to finish
+
+	# Did we get errors?
+	check_healthmon
+else
+	# mock the output since we don't support scrub
+	_scratch_unmount
+	cat << ENDL
+VICTIM directory: corrupt
+VICTIM directory: sick
+VICTIM parent: corrupt
+ENDL
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1879.out b/tests/xfs/1879.out
new file mode 100644
index 00000000000000..2f6acbe1c4fb22
--- /dev/null
+++ b/tests/xfs/1879.out
@@ -0,0 +1,8 @@
+QA output created by 1879
+Format and mount
+Runtime corruption detection
+VICTIM directory: sick
+Scrub corruption detection
+VICTIM directory: corrupt
+VICTIM directory: sick
+VICTIM parent: corrupt

