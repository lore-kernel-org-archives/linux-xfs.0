Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDDB1BD9CE;
	Tue,  3 Mar 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498624; cv=none; b=MkLhkqgZIHLljQITTmAXqOZusAzC7vJ5NAoUb8IC9jIFc5LdHqiLFU5Yr8j/gHd5D9OLr8CsmuLJMKSxucX3fdfs9U6gKIZbPk3JQMRwJt1JMMJt0KQcku6qUy7RZFiuQBslDH9kXwUz5kaGI7FFJddbIxT6z9YARPXBgBK2o38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498624; c=relaxed/simple;
	bh=K6AyY+4MT0VtpN3wPFNFULgu8jGgs/Gyq0jsDuZqAIc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HviBuir4pR4sNpZHMmKElJ5H5yyOx4BTA7X5rooveLCp9jsk+EglOX4XQQfDdWQ0CFSUMU4gAaizmGgFdx5FzSt22gv+IFDuRpxxkd615ZotXFYRuC/NMIuw75mhjoOUoFdg8PuyuLTp/D/0J2/CiX5nyNg7qeXVSi7wftPmYps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGwGez7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGwGez7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A63C19423;
	Tue,  3 Mar 2026 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498624;
	bh=K6AyY+4MT0VtpN3wPFNFULgu8jGgs/Gyq0jsDuZqAIc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DGwGez7PZPEcDkThNKS6sbYUIfwjpIWU6k+Qq+mqNemNuRkwwv4h743fNp64KWMtK
	 D9oQf8RRnocsA3V2Qu2o89Si3mZcOAk97Q4gP9tBl0jle4o+p9OMgXFT+3a+ykDksw
	 XHkW3X8MZSJSDyrj87Jns1vMVbG5kuzqPTowq4Wy8ATt+z0O3njuiE3xUCWHkHgwi8
	 OX48Y2rCFDnVobzXdGDKMq56mhrV5qPrMBGdK33mUxJYmLWJb6Oe95D8pv4tEimmNA
	 4mA0XbSkaU8ln1kQC6JvJXYTz32rEg0Vuog1UiG7GN8TSoywUIjPUw98uGKaeHW3jn
	 KYYWpJYBjIKyA==
Date: Mon, 02 Mar 2026 16:43:43 -0800
Subject: [PATCH 11/13] xfs: test xfs_healer can follow mount moves
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785971.483507.1748073225497120416.stgit@frogsfrogsfrogs>
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

Make sure that when xfs_healer needs to reopen a filesystem to repair it,
it can still find the filesystem even if it has been mount --move'd.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1900     |  115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1900.out |    2 +
 2 files changed, 117 insertions(+)
 create mode 100755 tests/xfs/1900
 create mode 100755 tests/xfs/1900.out


diff --git a/tests/xfs/1900 b/tests/xfs/1900
new file mode 100755
index 00000000000000..9a8f9fabd124ad
--- /dev/null
+++ b/tests/xfs/1900
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1900
+#
+# Ensure that autonomous self healing fixes the filesystem correctly even if
+# the original mount has moved somewhere else.
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
+	if [ -n "$new_dir" ]; then
+		_unmount "$new_dir" &>/dev/null
+		rm -rf "$new_dir"
+	fi
+}
+
+_require_test
+_require_scrub
+_require_xfs_io_command "repair"	# online repair support
+_require_xfs_db_command "blocktrash"
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command "$XFS_PROPERTY_PROG" "xfs_property"
+_require_scratch
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
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --repair
+
+# Move the scratch filesystem to a completely different mountpoint so that
+# we can test if the healer can find it again.
+new_dir=$TEST_DIR/moocow
+mkdir -p $new_dir
+_mount --bind $SCRATCH_MNT $new_dir
+_unmount $SCRATCH_MNT
+
+df -t xfs >> $seqres.full
+
+# Access the broken directory to trigger a repair, then poll the directory
+# for 5 seconds to see if it gets fixed without us needing to intervene.
+ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
+_filter_scratch < $tmp.err | _filter_test_dir
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "try $try saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "try $try no longer saw corruption or gave up" >> $seqres.full
+_filter_scratch < $tmp.err | _filter_test_dir
+
+# List the dirents of /victimdir to see if it stops reporting corruption
+ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "retry $try still saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "retry $try no longer saw corruption or gave up" >> $seqres.full
+
+new_dir_unmount() {
+	_unmount $new_dir
+}
+
+# Unmount to kill the healer
+_scratch_kill_xfs_healer new_dir_unmount
+cat $tmp.healer >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/1900.out b/tests/xfs/1900.out
new file mode 100755
index 00000000000000..604c9eb5eb10f4
--- /dev/null
+++ b/tests/xfs/1900.out
@@ -0,0 +1,2 @@
+QA output created by 1900
+ls: reading directory 'TEST_DIR/moocow/some/victimdir': Structure needs cleaning

