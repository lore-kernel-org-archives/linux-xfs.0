Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2C01DF755;
	Tue, 10 Mar 2026 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114764; cv=none; b=g93o5Ww6+DLmeG/rSKQBZZml0i2d4j0Im3mD/30frQWYzfO+Y3RdJUnFkahsp4H/5kvnhCYdmnCApP+VFBAhTDFNn/NJI1cjbj886ZXwBegHbntmFTp6ikxPM4gs3pF/Ve5SgVepNBSvBCnXR2itAe1WSxQpYU4K/M7ZzLdPWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114764; c=relaxed/simple;
	bh=QwRaMvylnRmjLiJrCnZeifdmaouk2SboCx0Bm1nlagU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFBexXczgRUKIlLIoe9QyopKm+uzsecvyPQe7lJGKgYlFmG8RzWdetNkFafxqjRxVljLPGMVt7Iqpi6qpTcvLo6etxFqjj51/H++c+nVgNxoJV5d1KlRDdyd1e8hn29Gi2JeqTGl9AxQ+rH4cWd3tWIF0yPGGyiJBHXm/t1V1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isgDTdWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isgDTdWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74EDC19423;
	Tue, 10 Mar 2026 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114764;
	bh=QwRaMvylnRmjLiJrCnZeifdmaouk2SboCx0Bm1nlagU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=isgDTdWxJ5Y55vTXbGQKKoI+95BddJRdakoBijRjYpGppbg5FuA40vcuOUGi3cNSE
	 JfQMONCZxIGzMGS2ezyo/qzoJ8uFDM/bW6OETFMxN8sSFV9d2kqZX2nV+IFE01br+e
	 +iDC6dUIduvpU3gYTsrJiYATvaqmsFAt8ngJof85QFNAhf0+n7eSyerTBlqyCp6qwn
	 KDalW4xeFs/LQaETTkyUA+8KpmPKR4hTFk0js8cncsOCk6qveK8XmrLbNwwh6FDxUu
	 WeK+jidfXPVNIHHpfa8IvVBU7eO5UgiOEAj7DpbGNIeyBdUvfeDXT/3uRygTMZf/PY
	 EApiYKfGwrsAQ==
Date: Mon, 09 Mar 2026 20:52:44 -0700
Subject: [PATCH 10/14] xfs: test xfs_healer can initiate full filesystem
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311403959.1186408.14105703850831556113.stgit@frogsfrogsfrogs>
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

