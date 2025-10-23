Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B725F2F85B;
	Thu, 23 Oct 2025 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178669; cv=none; b=SZIU0SkoCI/e6iU2CljonjBDsJrphp/l+KmshZficYls+awro775UtE8zq8x6Ih99R+Bm79/7IHeE8bM2Ccq2riRB3aq45MrTDleFZf6gT1cEqF/oRgwTvWTgzFQBS4cIL/iN6p3cUE6Azj0bCGcXthuHdaTTgtbSY73rrgPtsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178669; c=relaxed/simple;
	bh=/LDPBsacVvccqBhVk2IVHGG5y0vV8s43gJVkLgy1kIk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ithllqni8BguAPulBiWJmR9aGyk150RRdqB3etczy7wLzbBHL3Fw7I0FTp6mZk0+qcuo1eGJ0dLK5W+93Cr9IHuPVGFyCU5csHLiuOvUYTYf/nOyVf+EDH2RRpJwTpiXdTirHBNhXCBv7umB4QltKW8mEBhK4K/ibKdi8BrCLg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bw6+WLg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bw6+WLg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E957C4CEE7;
	Thu, 23 Oct 2025 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178669;
	bh=/LDPBsacVvccqBhVk2IVHGG5y0vV8s43gJVkLgy1kIk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bw6+WLg4zLgyCQJkMTG2IfKGtORwkMCJHNrzNU7rGz78VCcky/1jA/hf2oK5LgCUx
	 OgoksfYukpz+LXmXU5Od/cGkeRiDKai3Kmn0Bt6f4yd/SBlKMhVtnmqywYlKgbhh1z
	 uoDIQCBQwJ+ruI6J4cFeG+KBLNMYG4qX2gFoBqqq0Gcpj+RqhLBcsikp4BjYszvv/D
	 FugL/WKhnmpNze+yTTQoU0wJIG43nfB61Wp+ecdCjOozDsJroZNxTMVDoD0YSXvo23
	 xwimrXj9vr5S9/ScKslT1v2k7O+ztIl541qGQuYslmYOJcrMBDIDRgLaJTXDCAre18
	 trlGCC0/wwX5Q==
Date: Wed, 22 Oct 2025 17:17:48 -0700
Subject: [PATCH 2/4] xfs: test for metadata corruption error reporting via
 healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176117749469.1030150.1515293824383613678.stgit@frogsfrogsfrogs>
In-Reply-To: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
References: <176117749414.1030150.3638956559465976455.stgit@frogsfrogsfrogs>
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
 common/rc          |   10 ++++++
 tests/xfs/1879     |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1879.out |   12 +++++++
 3 files changed, 111 insertions(+)
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out


diff --git a/common/rc b/common/rc
index aca4e30f9858d1..9d9b2f441871e2 100644
--- a/common/rc
+++ b/common/rc
@@ -3037,6 +3037,16 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"healthmon")
+		testio=`$XFS_IO_PROG -c "$command -p $param" $TEST_DIR 2>&1`
+		echo $testio | grep -q "bad argument count" && \
+			_notrun "xfs_io $command $param support is missing"
+		echo $testio | grep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command $param ioctl support is missing"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "xfs_io $command $param kernel support is missing"
+		param_checked="$param"
+		;;
 	"label")
 		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
 		;;
diff --git a/tests/xfs/1879 b/tests/xfs/1879
new file mode 100755
index 00000000000000..b5741c286d5835
--- /dev/null
+++ b/tests/xfs/1879
@@ -0,0 +1,89 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
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
+sleep 1	# wait for python program to start up
+touch $SCRATCH_MNT/a/farts &>> $seqres.full
+_scratch_unmount
+
+wait	# for healthmon to finish
+
+# Did we get errors?
+filter_healthmon()
+{
+	cat $tmp.healthmon >> $seqres.full
+	grep -B1 -A1 -E '(sick|corrupt)' $tmp.healthmon | grep -v -- '--' | sort | uniq
+}
+filter_healthmon
+
+# Run scrub to trigger a health event from there too.
+echo "Scrub corruption detection"
+_scratch_mount
+if _supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV; then
+	$XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT > $tmp.healthmon &
+	sleep 1	# wait for python program to start up
+	$XFS_SCRUB_PROG -n $SCRATCH_MNT &>> $seqres.full
+	_scratch_unmount
+
+	wait	# for healthmon to finish
+
+	# Did we get errors?
+	filter_healthmon
+else
+	# mock the output since we don't support scrub
+	_scratch_unmount
+	cat << ENDL
+  "domain":     "inode",
+  "structures":  ["directory"],
+  "structures":  ["parent"],
+  "type":       "corrupt",
+  "type":       "sick",
+ENDL
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1879.out b/tests/xfs/1879.out
new file mode 100644
index 00000000000000..f02eefbf58ad6c
--- /dev/null
+++ b/tests/xfs/1879.out
@@ -0,0 +1,12 @@
+QA output created by 1879
+Format and mount
+Runtime corruption detection
+  "domain":     "inode",
+  "structures":  ["directory"],
+  "type":       "sick",
+Scrub corruption detection
+  "domain":     "inode",
+  "structures":  ["directory"],
+  "structures":  ["parent"],
+  "type":       "corrupt",
+  "type":       "sick",

