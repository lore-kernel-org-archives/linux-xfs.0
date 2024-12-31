Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562D81B0425;
	Tue, 31 Dec 2024 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689473; cv=none; b=G+rwhdC+Nyigm8fkTpTmNErc8JReCsaBNQ7SQ88Z/Zus103tY2kH1otVXxBDHI9IWmSiKjGPRLFYwRtOMfsgk3ucf92Rx2uEL6367nNCPGjzGEygw2mehUPJ1FEhLGzWSPBMl1nV0hgub+O6Is6EjiYyxdrGi45S2JdJC4mLjrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689473; c=relaxed/simple;
	bh=Fm2ZyfI5CsPY+mw73mTtddYLLnWCZlFz7d4LoDPIRdY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyfFDpzxVN8+vl3xE5NXSpf7GpdkP9LKA6XVAWcVJ+Yn2RGrt3uBEoRDJK/J2dUYu/eAQiy13DHf/focQdHjGpF3WOyiOizeKQcNdTxlrVbfJotBU/yBJprHBV2CdknSg5I9knuvqX3g2q+8YqEuz0ttIs6aAI1HEFviyh02P+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTEiS29x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTEiS29x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3DBC4CED2;
	Tue, 31 Dec 2024 23:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689473;
	bh=Fm2ZyfI5CsPY+mw73mTtddYLLnWCZlFz7d4LoDPIRdY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JTEiS29xbOHZR1h0ly0tywpZsG5fC4aXJGXYLXswaJACTwuBPp9T3bADP5Z7TrbXN
	 Fpv0yTkU+V769vyCwdIU8U2QVnVUyH94Y+cx1RewyjyPt/AXFKGk7mAqnWaA8m5V+a
	 ePfvMV7dl8LoENOGrscSUFL/fqg/bIJblo16X/DnQPbm+VFdF2E56Rqy6BHlx4iIN/
	 ZcI4k5UXDjmpSE2nOPnhpo0o6SpNENYEVxGP2pguLhgo16Xz7qgVJsSlev7QXJCqmp
	 UM3qLFfvZSwmott6IOTLpNsnup73XgVslPXlAXR4yxfFxsNBI7Qsqg3sdTy+HeN345
	 ZgTYtJP6iB1RQ==
Date: Tue, 31 Dec 2024 15:57:52 -0800
Subject: [PATCH 4/6] xfs: test for metadata corruption error reporting via
 healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783194.2712254.12897660148850244346.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
References: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
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
index 0d5c785cecc017..dd6857461e14dd 100644
--- a/common/rc
+++ b/common/rc
@@ -2850,6 +2850,16 @@ _require_xfs_io_command()
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
index 00000000000000..aab7bf9fa1f6e4
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
+_begin_fstest auto quick eio
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
+	grep -A2 -E '(sick|corrupt)' $tmp.healthmon | grep -v -- '--' | sort | uniq
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

