Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C857350E;
	Thu, 20 Jun 2024 20:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917032; cv=none; b=QvKaq0G1AzTuaD6ynJIWOGDTojPPYVlNrJQBo2gKxhO4i9Ss/RyFHEfk6w5TxKekW8D68tIX2x4fUcwM8gU7UMoulTp4RvhKhnO2ca73ZKCr2rvvadrDfBPI0mA2RLAsyNBq4n4Ck4KAYkIphWzipXTufRASY32N0ceszu9Twto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917032; c=relaxed/simple;
	bh=lOMmhtYZTRB/eXbWRslEHla7sAp7Q33JviZdJV6SPMU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p7ri3v/itxn5/riVP3ckvx+WW6lZBH+ZU6bYYIeHIl5jUaZNgM95z6jfktRvxCVkhEZcG9RI4htFfwjYxMMV4w/ynnRvT6CIL+bYhxeVl2F7fykrDkJaR5KIFekfCuBmUSkx2MNVT1oOBasV078maG090rRw7ifB2Ef3dCidC2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZyZOdyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZyZOdyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4C6C2BD10;
	Thu, 20 Jun 2024 20:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917032;
	bh=lOMmhtYZTRB/eXbWRslEHla7sAp7Q33JviZdJV6SPMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BZyZOdyqp8vc5NcwQnVkGLw/4gO17+2f00O71Bp4c39l2Bb38qDMbCDjhOTqzZn0n
	 31gcy/Q6xBWzaAVtzQylcjLBYKVnVw8Kv7BoRe6ugGbN+DynHQSdJ8yj38a4OhWIYp
	 RTw+WlBw1wsXlTEK56yY5f5gTNR0VxHYluzzLkalrVz0n65cUgJdhVPvvm68KeCgLu
	 QsJ0dyu52U0oTgrAdT9VOXCKGxh0JdjJPeN3+LCDYLYiGJ6MlAJ1lWIx/rgs7rvQlJ
	 v5mQi3WUO2zYK+3CG9mAe3j7GAd6S6Y1QyQuoyCFtW4v52WTkhBoaTGRY1VV9iHfBa
	 uUURm+kqSLG3Q==
Date: Thu, 20 Jun 2024 13:57:11 -0700
Subject: [PATCH 01/11] generic: test recovery of extended attribute updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171891669655.3035255.11665950126252228494.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

