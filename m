Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977EEDDA0;
	Tue, 18 Jun 2024 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671778; cv=none; b=Z/RxDQ3Qu4mS7wdWaF9V0pKagea2YlJ0Bmm/tfej1KwOMnfC4KJxfyv2bTjsAWF34LrLVJ6mAx8hzPJhdk/Rp+l2bv5OeC8DViYHY/KTmAhKOkyqaHrtPs51pW7sVjlT72w0C8esH+BO/8hxfSUtx1wIgToJ5JUXn+xdN5s+vr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671778; c=relaxed/simple;
	bh=X95Qm/QsJBP36b9nNqujW0N3W4dXS1JuC3F9/ArxC+c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/f3isVBJPWLmFdT8omM6s7qnl4T+nFUg88TFT5rsllE/86iRX4k4ujiOmtoaZKhUA4Hpb8naLB9A55MI/z4SLxK9Pz2No5RRdFMgWw2MENFV2JXQqFMh8RgrtSP6Pi9fSkhimMmNM1omGfpUXECH1YjynZR3DzNEfTsmz9RkaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kd0xhNbt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kd0xhNbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F066C2BD10;
	Tue, 18 Jun 2024 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671778;
	bh=X95Qm/QsJBP36b9nNqujW0N3W4dXS1JuC3F9/ArxC+c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kd0xhNbtSGBsXvbAnNzw3CzDlpwn5hn6UnfWqpQP3xe26hM9SQy1K2m8z11MlAkF5
	 CukUuYyVEXegftgfd90Ikl659XO/qZm5HcGk3pRQj+IQI8mrdnFnpJJsaX8LexARbi
	 6RqZIWpFk1sH1g/0IQ/Ml6LE+A4kzCRdH9qwu6Sl+yW+P/xMh5vSF+EYAcLhVqqMgo
	 es3j6GD+P9GOHS2Hv2eCHwAzvCtTcI2uQUiMs4NU1BiVXOpRFyn6jHX/Dse/Ae323T
	 G849ywYGtvPLXjz2gEMoe3MDMXVeAm3Q4L/YfIbj8WWet4uzZwY1g0RoMzOHBPjO6j
	 +D6Nq6z64nGvw==
Date: Mon, 17 Jun 2024 17:49:37 -0700
Subject: [PATCH 01/11] generic: test recovery of extended attribute updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <171867145822.793846.1215087567830350611.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fork generic/475 to test recovery of extended attribute modifications
and log recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1834     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1834.out |    2 +
 2 files changed, 95 insertions(+)
 create mode 100755 tests/generic/1834
 create mode 100644 tests/generic/1834.out


diff --git a/tests/generic/1834 b/tests/generic/1834
new file mode 100755
index 0000000000..7910a40545
--- /dev/null
+++ b/tests/generic/1834
@@ -0,0 +1,93 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1834
+#
+# Test log recovery with repeated (simulated) disk failures.  We kick
+# off fsstress on the scratch fs to exercise extended attribute operations,
+# then switch out the underlying device with dm-error to see what happens when
+# the disk goes down.  Having taken down the fs in this manner, remount it and
+# repeat.
+#
+. ./common/preamble
+_begin_fstest shutdown auto log metadata eio recoveryloop attr
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/dmerror
+
+# Modify as appropriate.
+_supported_fs generic
+
+_require_scratch
+_require_dm_target error
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+args=('-z' '-S' 'c')
+
+# Do some directory tree modifications, but the bulk of this is geared towards
+# exercising the xattr code, especially attr_set which can do up to 10k values.
+for verb in unlink rmdir; do
+	args+=('-f' "${verb}=50")
+done
+for verb in creat mkdir; do
+	args+=('-f' "${verb}=2")
+done
+for verb in getfattr listfattr; do
+	args+=('-f' "${verb}=3")
+done
+for verb in attr_remove removefattr; do
+	args+=('-f' "${verb}=4")
+done
+args+=('-f' "setfattr=20")
+args+=('-f' "attr_set=60")	# sets larger xattrs
+
+while _soak_loop_running $((50 * TIME_FACTOR)); do
+	($FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4)) >> $seqres.full &) \
+		> /dev/null 2>&1
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % 3))
+
+	# This test aims to simulate sudden disk failure, which means that we
+	# do not want to quiesce the filesystem or otherwise give it a chance
+	# to flush its logs.  Therefore we want to call dmsetup with the
+	# --nolockfs parameter; to make this happen we must call the load
+	# error table helper *without* 'lockfs'.
+	_dmerror_load_error_table
+
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+
+	# Mount again to replay log after loading working table, so we have a
+	# consistent XFS after test.
+	_dmerror_unmount || _fail "unmount failed"
+	_dmerror_load_working_table
+	_dmerror_mount || _fail "mount failed"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1834.out b/tests/generic/1834.out
new file mode 100644
index 0000000000..5efe2033b5
--- /dev/null
+++ b/tests/generic/1834.out
@@ -0,0 +1,2 @@
+QA output created by 1834
+Silence is golden.

