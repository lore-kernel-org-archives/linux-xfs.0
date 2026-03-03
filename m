Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FB191F84;
	Tue,  3 Mar 2026 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498608; cv=none; b=qX/8JMshI6iHa68h8NOqf5MmM3deJWHwkbPLQhv+MobTNfvtKnpdMnwREcJrIPI59rMw/TwZ/+jy1EdFJWhAIJ3PSvnGvVJNU3ZtqLzRxcPkzWoOBKrAv3EgPC3+Yy5z8bX0vJtMXRHflnV5fLTP/aHkW4Yf1x0B3fRT2ZZfJGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498608; c=relaxed/simple;
	bh=QwRaMvylnRmjLiJrCnZeifdmaouk2SboCx0Bm1nlagU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eomDi/j/jENAZfuVl9+ea53G10M5HXR0B/Fo4vo9tInGXBl3P9HbXXe0kWwOCvPyyfH/7WohQFVQBFBlnjApXS1JM6PO+1/SxcXmuR9S3DD/WK4XWcnjbTfXM6B8x8pUPQEIbvJe1IdqkdSXNDDjI/5OxaaI5DPXj3ZrWxSqtSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahH19d0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahH19d0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D94C19423;
	Tue,  3 Mar 2026 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498608;
	bh=QwRaMvylnRmjLiJrCnZeifdmaouk2SboCx0Bm1nlagU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ahH19d0aT5PZEOAo6kUaJOXB3yCfY+fEG9MFpCA8JT3lYM9DZASZL6giGB8qc6jXH
	 yVfLE/dc+BWQkRuefqunuDsEem4XvoyvkkeKfyB3VhkE3o2n+8c5icW/rFlQaBGA+W
	 9pErFmGP+tc1B9mjE6BRWt8phyW/DG+WBYHgafiSn9+kQDapHaIBiema6o6A19GXVh
	 Qlwc0q0mL6q9HALhaz0l1VyqwW+v8VmJldvTvZCLKOg9Y+/yP87elOIM3En9Qdyi+I
	 Ta2/Qo7JJRCXoPjU7jSbL+mzGupv4fIecRv3J1R2IU9kVj6uNN826n4eDA5upOUgOM
	 mEJlYKukXoyog==
Date: Mon, 02 Mar 2026 16:43:28 -0800
Subject: [PATCH 10/13] xfs: test xfs_healer can initiate full filesystem
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785953.483507.761841651905847407.stgit@frogsfrogsfrogs>
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

Make sure that when xfs_healer can't perform a spot repair, it will actually
start up xfs_scrub to perform a full scan and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1899     |  108 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1899.out |    3 +
 2 files changed, 111 insertions(+)
 create mode 100755 tests/xfs/1899
 create mode 100644 tests/xfs/1899.out


diff --git a/tests/xfs/1899 b/tests/xfs/1899
new file mode 100755
index 00000000000000..5d35ca8265645f
--- /dev/null
+++ b/tests/xfs/1899
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1899
+#
+# Ensure that autonomous self healing works fixes the filesystem correctly
+# even if the spot repair doesn't work and it falls back to a full fsck.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+
+_require_scrub
+_require_xfs_io_command "repair"	# online repair support
+_require_xfs_db_command "blocktrash"
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
+_require_scratch
+_require_systemd_unit_defined "xfs_scrub@.service"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_xfs_has_feature $SCRATCH_MNT rmapbt || \
+	_notrun "reverse mapping required to test directory auto-repair"
+_xfs_has_feature $SCRATCH_MNT parent || \
+	_notrun "parent pointers required to test directory auto-repair"
+_require_xfs_healer $SCRATCH_MNT --repair
+
+filter_healer() {
+	_filter_scratch | \
+		grep 'Full repairs in progress' | \
+		uniq
+}
+
+# Configure the filesystem for automatic repair of the filesystem.
+$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=repair >> $seqres.full
+
+# Create a largeish directory
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
+echo testdata > $SCRATCH_MNT/a
+mkdir -p "$SCRATCH_MNT/some/victimdir"
+for ((i = 0; i < (dblksz / 255); i++)); do
+	fname="$(printf "%0255d" "$i")"
+	ln $SCRATCH_MNT/a $SCRATCH_MNT/some/victimdir/$fname
+done
+
+# Did we get at least two dir blocks?
+dirsize=$(stat -c '%s' $SCRATCH_MNT/some/victimdir)
+test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
+
+# Break the directory, remount filesystem
+_scratch_unmount
+_scratch_xfs_db -x \
+	-c 'path /some/victimdir' \
+	-c 'bmap' \
+	-c 'dblock 1' \
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' \
+	-c 'path /a' \
+	-c 'bmap -a' \
+	-c 'ablock 1' \
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' \
+	>> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --repair
+
+# Access the broken directory to trigger a repair, then poll the directory
+# for 5 seconds to see if it gets fixed without us needing to intervene.
+ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+_filter_scratch < $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "try $try saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "try $try no longer saw corruption or gave up" >> $seqres.full
+_filter_scratch < $tmp.err
+
+# Wait for the background fixer to finish
+svc="$(_xfs_scrub_svcname "$SCRATCH_MNT")"
+_systemd_unit_wait "$svc"
+
+# List the dirents of /victimdir and parent pointers of /a to see if they both
+# stop reporting corruption
+(ls $SCRATCH_MNT/some/victimdir ; $XFS_IO_PROG -c 'parent') > /dev/null 2> $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "retry $try still saw corruption" >> $seqres.full
+	sleep 0.1
+	(ls $SCRATCH_MNT/some/victimdir ; $XFS_IO_PROG -c 'parent') > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "retry $try no longer saw corruption or gave up" >> $seqres.full
+
+# Unmount to kill the healer
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer
+
+status=0
+exit
diff --git a/tests/xfs/1899.out b/tests/xfs/1899.out
new file mode 100644
index 00000000000000..5345fd400f3627
--- /dev/null
+++ b/tests/xfs/1899.out
@@ -0,0 +1,3 @@
+QA output created by 1899
+ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning
+SCRATCH_MNT: Full repairs in progress.

