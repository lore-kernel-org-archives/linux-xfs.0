Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BB329415;
	Tue, 31 Dec 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689504; cv=none; b=mu/r9BWCgG+HbvBTytT+YSxCe4obT19qb8Vd1PbzdVtNy6kRa5NAVDfRKHJ4Xhhh/uHEj6T4UwqIDLqdI3/G0VlF1pFpoGa5TVtnnluMO0W/gGha7ccF2aWLo88TH3t/3ZSCP4E7gIM110hdv0J1nMKbhuSBMzs+N6ewyi62w4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689504; c=relaxed/simple;
	bh=sDeXo4/stGIkz46J/FoXqa9rG5NFHNxsYjFomLoNP4Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYzu4KnLPXlJz5ZG6dQJ4UTFkQZ6MQ0TdA27frqIfmqb3fBVJQV7up4gLDkXYCWTackYZhHV6r8TuP4HE08UcI+u9t8U4NuYzakjF9DJE4lk4oKuYbQc9nWkYvDpdfrtKlUMyJ2qIWxI2k9G7TGG059RNOGoDhThn02bPf2If28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUcIeMtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUcIeMtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679F2C4CED2;
	Tue, 31 Dec 2024 23:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689504;
	bh=sDeXo4/stGIkz46J/FoXqa9rG5NFHNxsYjFomLoNP4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hUcIeMtuELvKWULcg2eMc77SfOYHbalp2x1ZqcLpQNFxs96Muh6wlxSo1SpzVd0yt
	 LBpsUkIngvVC4cf/XfzL5SRh+qlMPqQpEX43V8DU1ivBqvgl9nN6az7qvo0G3laaih
	 4/5+y5d6Ar4TTuSmWiJ/Syv7A3s0hXsLzLOZjpEyfF+Tg6xpWy6eKWotqLVYY5A6HV
	 rsa6aYoDjGgPaZJy6ygqXyJiLkbZZoGNYcXheoy/IQpMiJQYPiv2nBFHwrfIbFQY4P
	 p+kNbUiV9kHxnELUyt/rnB5z8MwzLO0l7VYQwd6fPOboHd/AtuhmfQi+S3SIA9uRtS
	 B+IySsvJ0vVZg==
Date: Tue, 31 Dec 2024 15:58:23 -0800
Subject: [PATCH 6/6] xfs: test new xfs_scrubbed daemon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783225.2712254.17928449454201283.stgit@frogsfrogsfrogs>
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

Make sure the daemon in charge of self healing xfs actually does what it
says it does.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config      |    6 ++++
 common/systemd     |    9 +++++
 common/xfs         |   16 ++++++++++
 tests/xfs/1882     |   64 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1882.out |    2 +
 tests/xfs/1883     |   75 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1883.out |    2 +
 tests/xfs/1884     |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1884.out |    2 +
 9 files changed, 263 insertions(+)
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out
 create mode 100755 tests/xfs/1883
 create mode 100644 tests/xfs/1883.out
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out


diff --git a/common/config b/common/config
index fcff0660b05a97..2b3f946f3d308d 100644
--- a/common/config
+++ b/common/config
@@ -166,6 +166,12 @@ export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
 export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
+XFS_SCRUBBED_PROG="$(type -P xfs_scrubbed)"
+# Normally the scrubbed daemon is installed in libexec
+if [ -n "$XFS_SCRUBBED_PROG" ] && [ -e /usr/libexec/xfs_scrubbed ]; then
+	XFS_SCRUBBED_PROG=/usr/libexec/xfs_scrubbed
+fi
+export XFS_SCRUBBED_PROG
 export XFS_PARALLEL_REPAIR_PROG="$(type -P xfs_prepair)"
 export XFS_PARALLEL_REPAIR64_PROG="$(type -P xfs_prepair64)"
 export __XFSDUMP_PROG="$(type -P xfsdump)"
diff --git a/common/systemd b/common/systemd
index b2e24f267b2d93..8366d4cba39d85 100644
--- a/common/systemd
+++ b/common/systemd
@@ -71,3 +71,12 @@ _systemd_unit_status() {
 	_systemd_installed || return 1
 	systemctl status "$1"
 }
+
+# Start a running systemd unit
+_systemd_unit_start() {
+	systemctl start "$1"
+}
+# Stop a running systemd unit
+_systemd_unit_stop() {
+	systemctl stop "$1"
+}
diff --git a/common/xfs b/common/xfs
index b9e897e0e8839a..b4f69403e7396e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2224,3 +2224,19 @@ _scratch_find_rt_metadir_entry() {
 
 	return 1
 }
+
+# Run the xfs_scrubbed self healing daemon
+_scratch_xfs_scrubbed() {
+	local scrubbed_args=()
+	local daemon_dir
+	daemon_dir=$(dirname "$XFS_SCRUBBED_PROG")
+
+	# If we're being run from a development branch, we might need to find
+	# the schema file on our own.
+	local maybe_schema="$daemon_dir/../libxfs/xfs_healthmon.schema.json"
+	if [ -f "$maybe_schema" ]; then
+		scrubbed_args+=(--event-schema "$maybe_schema")
+	fi
+
+	$XFS_SCRUBBED_PROG "${scrubbed_args[@]}" "$@" $SCRATCH_MNT
+}
diff --git a/tests/xfs/1882 b/tests/xfs/1882
new file mode 100755
index 00000000000000..b6a8bd545dbcf5
--- /dev/null
+++ b/tests/xfs/1882
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1882
+#
+# Make sure that xfs_scrubbed correctly handles all the reports that it gets
+# from the kernel.  We simulate this by using the --everything mode so we get
+# all the events, not just the sickness reports.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+. ./common/populate
+
+_require_scrub
+_require_xfs_io_command "scrub"		# online check support
+_require_command "$XFS_SCRUBBED_PROG" "xfs_scrubbed"
+_require_scratch
+
+# Does this fs support health monitoring?
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_scratch_xfs_scrubbed --check || \
+	_notrun "health monitoring not supported on this kernel"
+_scratch_xfs_scrubbed --require-validation --check && \
+	_notrun "skipping this test in favor of the one that does json validation"
+_scratch_unmount
+
+# Create a sample fs with all the goodies
+_scratch_populate_cached nofill &>> $seqres.full
+_scratch_mount
+
+# If the system xfsprogs has self healing enabled, we need to shut down the
+# daemon before we try to capture things.
+if _systemd_is_running; then
+	scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
+	_systemd_unit_stop "xfs_scrubbed@${scratch_path}" &>> $seqres.full
+fi
+
+# Start the health monitor, have it log everything
+_scratch_xfs_scrubbed --everything --log > $tmp.scrubbed &
+scrubbed_pid=$!
+sleep 1
+
+# Run scrub to make some noise
+_scratch_scrub -b -n >> $seqres.full
+
+# Unmount fs to kill scrubbed, then wait for it to finish
+while ! _scratch_unmount &>/dev/null; do
+	sleep 0.5
+done
+kill $scrubbed_pid
+wait
+
+cat $tmp.scrubbed >> $seqres.full
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1882.out b/tests/xfs/1882.out
new file mode 100644
index 00000000000000..9b31ccb735cabd
--- /dev/null
+++ b/tests/xfs/1882.out
@@ -0,0 +1,2 @@
+QA output created by 1882
+Silence is golden
diff --git a/tests/xfs/1883 b/tests/xfs/1883
new file mode 100755
index 00000000000000..9bba989386b37e
--- /dev/null
+++ b/tests/xfs/1883
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1883
+#
+# Make sure that xfs_scrubbed correctly validates the json events that it gets
+# from the kernel.  We simulate this by using the --everything mode so we get
+# all the events, not just the sickness reports.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/systemd
+. ./common/populate
+
+_require_scrub
+_require_xfs_io_command "scrub"		# online check support
+_require_command "$XFS_SCRUBBED_PROG" "xfs_scrubbed"
+_require_scratch
+
+# Does this fs support health monitoring?
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_scratch_xfs_scrubbed --require-validation --check || \
+	_notrun "health monitoring with validation not supported on this kernel"
+_scratch_unmount
+
+# Create a sample fs with all the goodies
+_scratch_populate_cached nofill &>> $seqres.full
+_scratch_mount
+
+# If the system xfsprogs has self healing enabled, we need to shut down the
+# daemon before we try to capture things.
+if _systemd_is_running; then
+	scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
+	_systemd_unit_stop "xfs_scrubbed@${scratch_path}" &>> $seqres.full
+fi
+
+# Start the health monitor, have it validate everything
+_scratch_xfs_scrubbed --require-validation --everything --debug-fast --log &> $tmp.scrubbed &
+scrubbed_pid=$!
+sleep 1
+
+# Run scrub to make some noise
+_scratch_scrub -b -n >> $seqres.full
+
+# Wait for up to 60 seconds for the log file to stop growing
+old_logsz=
+new_logsz=$(stat -c '%s' $tmp.scrubbed)
+for ((i = 0; i < 60; i++)); do
+	test "$old_logsz" = "$new_logsz" && break
+	old_logsz="$new_logsz"
+	sleep 1
+	new_logsz=$(stat -c '%s' $tmp.scrubbed)
+done
+
+# Unmount fs to kill scrubbed, then wait for it to finish
+while ! _scratch_unmount &>/dev/null; do
+	sleep 0.5
+done
+kill $scrubbed_pid
+wait
+
+# Look for schema validation errors
+grep -q 'not valid under any of the given schemas' $tmp.scrubbed && \
+	echo "Should not have found schema validation errors"
+cat $tmp.scrubbed >> $seqres.full
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1883.out b/tests/xfs/1883.out
new file mode 100644
index 00000000000000..bc9c390c778b6e
--- /dev/null
+++ b/tests/xfs/1883.out
@@ -0,0 +1,2 @@
+QA output created by 1883
+Silence is golden
diff --git a/tests/xfs/1884 b/tests/xfs/1884
new file mode 100755
index 00000000000000..fc6e0a48372fda
--- /dev/null
+++ b/tests/xfs/1884
@@ -0,0 +1,87 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1884
+#
+# Ensure that autonomous self healing works fixes the filesystem correctly.
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
+_require_command "$XFS_SCRUBBED_PROG" "xfs_scrubbed"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_xfs_has_feature $SCRATCH_MNT parent || \
+	_notrun "parent pointers required to test directory auto-repair"
+_scratch_xfs_scrubbed --repair --check || \
+	_notrun "health monitoring with repair not supported on this kernel"
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
+# If the system xfsprogs has self healing enabled, we need to shut down the
+# daemon before we try to capture things.
+if _systemd_is_running; then
+	svcname="xfs_scrubbed@$(systemd-escape --path "$SCRATCH_MNT")"
+	echo "$svcname: $(systemctl is-active "$svcname")" >> $seqres.full
+	_systemd_unit_stop "$svcname" &>> $seqres.full
+fi
+
+# Start the health monitor, have it repair everything reported corrupt
+_scratch_xfs_scrubbed --repair --log > $tmp.scrubbed &
+scrubbed_pid=$!
+sleep 1
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
+_filter_scratch < $tmp.err
+
+# Unmount fs to kill scrubbed, then wait for it to finish.
+while ! _scratch_unmount &>/dev/null; do
+	sleep 0.5
+done
+kill $scrubbed_pid
+wait
+cat $tmp.scrubbed >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/1884.out b/tests/xfs/1884.out
new file mode 100644
index 00000000000000..929e33da01f92c
--- /dev/null
+++ b/tests/xfs/1884.out
@@ -0,0 +1,2 @@
+QA output created by 1884
+ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning

