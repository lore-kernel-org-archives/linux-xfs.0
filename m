Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498AA8528E;
	Thu, 23 Oct 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178701; cv=none; b=G6hUCRHRXDzEdFRq+inWB4bZl38WM6NYQNaG70f1sDhgpg+1A2lCYT/5urmoPpFTGQJ5u9XmpadOwXpCmL7yiuJe7k7yIGtEIT1uRpp+hENntll8Gaay/aagNrScjsdQLvZ4BbAxg+q85Pl3bqjSYS7znPkMAaN76t3v4qLkY3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178701; c=relaxed/simple;
	bh=HkIcsqGNemiAbbEp3xOiApKBUHMKXENcyTRICwXLrhk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVLi7EUuEZJUPyUIueONOqhMePGmi2h8gP6Bw2B9W5AB4n+ZevHI/SaVCAUbXikeWkc6Yg7oS/anLq69GWpnfmXbJbtUGaeQgpdr5J3vvHD/oPsiQ2dsoUKpqdIIlHu9q/Tnibs8PqkpoiBRgx+xtK3xRkRv0Ar1czSyKCbsFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZ0liz8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZ0liz8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA649C4CEF5;
	Thu, 23 Oct 2025 00:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178700;
	bh=HkIcsqGNemiAbbEp3xOiApKBUHMKXENcyTRICwXLrhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lZ0liz8kRus4SGMo9m2QQOJx4plpCKxQ3DPoOcGUoKJpG1o2B5aOcf7J4Agat1YUy
	 yS+Vyo//3ZJXWFFKwqlR5qK1IbCuit+7CTsb8yNhu3KWWCKBW34TY1ArCogIioHcWO
	 Pw0nUXysEHKNcG8jQ1/agNur/xJ0Nx0vbdhUmr3NUrGbjyZdZj+T+pbmDHBYZxkx6i
	 MC+kWIDEYadpROfyPPoxYeEJcC0pdrJcqsa685WpHgE/CoaBTdlvhxayepxZnnb3qe
	 U10RC0D+ldWvvxnZcuZiNG2bjZSoB79zAeSXyRgo8DEpVsNpP0BzfCGDlFartKQZ9D
	 F026khWKMFcSA==
Date: Wed, 22 Oct 2025 17:18:20 -0700
Subject: [PATCH 4/4] xfs: test new xfs_healer daemon
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <176117749507.1030150.12666563455562924430.stgit@frogsfrogsfrogs>
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

Make sure the daemon in charge of self healing xfs actually does what it
says it does -- emits json blobs that can be validated against the
schema, repairs metadata, logs file IO errors, and doesn't get
overwhelmed by event floods.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config      |    6 ++
 common/rc          |    5 +
 common/systemd     |   21 +++++
 common/xfs         |   86 ++++++++++++++++++++++
 tests/xfs/1882     |   48 ++++++++++++
 tests/xfs/1882.out |    2 +
 tests/xfs/1883     |   60 +++++++++++++++
 tests/xfs/1883.out |    2 +
 tests/xfs/1884     |   90 +++++++++++++++++++++++
 tests/xfs/1884.out |    2 +
 tests/xfs/1896     |  206 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1896.out |   21 +++++
 tests/xfs/1897     |   98 +++++++++++++++++++++++++
 tests/xfs/1897.out |    4 +
 tests/xfs/1898     |   36 +++++++++
 tests/xfs/1898.out |    4 +
 tests/xfs/1899     |  109 ++++++++++++++++++++++++++++
 tests/xfs/1899.out |    3 +
 tests/xfs/1900     |  116 +++++++++++++++++++++++++++++
 tests/xfs/1900.out |    2 +
 tests/xfs/1901     |  138 +++++++++++++++++++++++++++++++++++
 tests/xfs/1901.out |    2 +
 22 files changed, 1061 insertions(+)
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out
 create mode 100755 tests/xfs/1883
 create mode 100644 tests/xfs/1883.out
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out
 create mode 100755 tests/xfs/1896
 create mode 100644 tests/xfs/1896.out
 create mode 100755 tests/xfs/1897
 create mode 100755 tests/xfs/1897.out
 create mode 100755 tests/xfs/1898
 create mode 100755 tests/xfs/1898.out
 create mode 100755 tests/xfs/1899
 create mode 100644 tests/xfs/1899.out
 create mode 100755 tests/xfs/1900
 create mode 100755 tests/xfs/1900.out
 create mode 100755 tests/xfs/1901
 create mode 100755 tests/xfs/1901.out


diff --git a/common/config b/common/config
index 1420e35ddfee42..f7b9993284a4ca 100644
--- a/common/config
+++ b/common/config
@@ -161,6 +161,12 @@ export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
 export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
+XFS_HEALER_PROG="$(type -P xfs_healer)"
+# If the healer daemon isn't in the PATH, try the one installed in libexec
+if [ -z "$XFS_HEALER_PROG" ] && [ -e /usr/libexec/xfs_healer ]; then
+	XFS_HEALER_PROG=/usr/libexec/xfs_healer
+fi
+export XFS_HEALER_PROG
 export XFS_PARALLEL_REPAIR_PROG="$(type -P xfs_prepair)"
 export XFS_PARALLEL_REPAIR64_PROG="$(type -P xfs_prepair64)"
 export __XFSDUMP_PROG="$(type -P xfsdump)"
diff --git a/common/rc b/common/rc
index 9d9b2f441871e2..01b6f1d50c856f 100644
--- a/common/rc
+++ b/common/rc
@@ -3050,6 +3050,11 @@ _require_xfs_io_command()
 	"label")
 		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
 		;;
+	"mediaerror")
+		testio=`$XFS_IO_PROG -x -c "mediaerror $* 0 0" 2>&1`
+		echo $testio | grep -q "invalid option" && \
+			_notrun "xfs_io $command support is missing"
+		;;
 	"open")
 		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
 		# a new -C flag was introduced to execute one shot commands.
diff --git a/common/systemd b/common/systemd
index b2e24f267b2d93..ce752bf02e503e 100644
--- a/common/systemd
+++ b/common/systemd
@@ -44,6 +44,18 @@ _systemd_unit_active() {
 	test "$(systemctl is-active "$1")" = "active"
 }
 
+# Wait for up to a certain number of seconds for a service to reach inactive
+# state.
+_systemd_unit_wait() {
+	local svcname="$1"
+	local timeout="${2:-30}"
+
+	for ((i = 0; i < (timeout * 2); i++)); do
+		test "$(systemctl is-active "$svcname")" = "inactive" && break
+		sleep 0.5
+	done
+}
+
 _require_systemd_unit_active() {
 	_require_systemd_unit_defined "$1"
 	_systemd_unit_active "$1" || \
@@ -71,3 +83,12 @@ _systemd_unit_status() {
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
index ffdb82e6c970ba..ac330f63bd783d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2298,3 +2298,89 @@ _filter_bmap_gno()
 		if ($ag =~ /\d+/) {print "$ag "} ;
         '
 }
+
+# Construct CLI arguments for xfs_healer
+_xfs_healer_args() {
+	local healer_args=()
+	local daemon_dir
+	daemon_dir=$(dirname "$XFS_HEALER_PROG")
+
+	# If we're being run from a development branch, we might need to find
+	# the schema file on our own.
+	local maybe_schema="$daemon_dir/../libxfs/xfs_healthmon.schema.json"
+	if [ -f "$maybe_schema" ]; then
+		local path="$(readlink -m "$maybe_schema")"
+		healer_args+=(--event-schema "$path")
+	fi
+
+	echo "${healer_args[@]}"
+}
+
+# Run the xfs_healer program on some filesystem
+_xfs_healer() {
+	$XFS_HEALER_PROG $(_xfs_healer_args) "$@"
+}
+
+# Run the xfs_healer program on the scratch fs
+_scratch_xfs_healer() {
+	_xfs_healer "$@" "$SCRATCH_MNT"
+}
+
+# Turn off the background xfs_healer service if any so that it doesn't fix
+# injected metadata errors; then start a background copy of xfs_healer to
+# capture that.
+_invoke_xfs_healer() {
+	local mount="$1"
+	local logfile="$2"
+	shift; shift
+
+	if _systemd_is_running; then
+		local scratch_path=$(systemd-escape --path "$mount")
+		_systemd_unit_stop "xfs_healer@${scratch_path}" &>> $seqres.full
+	fi
+
+	$XFS_HEALER_PROG $(_xfs_healer_args) --log "$mount" "$@" &> "$logfile" &
+	XFS_HEALER_PID=$!
+
+	# Wait 30s for the healer program to really start up
+	for ((i = 0; i < 60; i++)); do
+		test -e "$logfile" && \
+			grep -q 'monitoring started' "$logfile" && \
+			break
+		sleep 0.5
+	done
+}
+
+# Run our own copy of xfs_healer against the scratch device.  Note that
+# unmounting the scratch fs causes the healer daemon to exit, so we don't need
+# to kill it explicitly from _cleanup.
+_scratch_invoke_xfs_healer() {
+	_invoke_xfs_healer "$SCRATCH_MNT" "$@"
+}
+
+# Unmount the filesystem to kill the xfs_healer instance started by
+# _invoke_xfs_healer, and wait up to a certain amount of time for it to exit.
+_kill_xfs_healer() {
+	local unmount="$1"
+	local timeout="${2:-30}"
+	local i
+
+	# Unmount fs to kill healer, then wait for it to finish
+	for ((i = 0; i < (timeout * 2); i++)); do
+		$unmount &>> $seqres.full && break
+		sleep 0.5
+	done
+
+	test -n "$XFS_HEALER_PID" && \
+		kill $XFS_HEALER_PID &>> $seqres.full
+	wait
+	unset XFS_HEALER_PID
+}
+
+# Unmount the scratch fs to kill a _scratch_invoke_xfs_healer instance.
+_scratch_kill_xfs_healer() {
+	local unmount="${1:-_scratch_unmount}"
+	shift
+
+	_kill_xfs_healer "$unmount" "$@"
+}
diff --git a/tests/xfs/1882 b/tests/xfs/1882
new file mode 100755
index 00000000000000..a40a43e3da7fc6
--- /dev/null
+++ b/tests/xfs/1882
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1882
+#
+# Make sure that xfs_healer correctly handles all the reports that it gets
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
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_scratch
+
+# Does this fs support health monitoring?
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_scratch_xfs_healer --check &>/dev/null || \
+	_notrun "health monitoring not supported on this kernel"
+_scratch_xfs_healer --require-validation --check &>/dev/null && \
+	_notrun "skipping this test in favor of the one that does json validation"
+_scratch_unmount
+
+# Create a sample fs with all the goodies
+_scratch_populate_cached nofill &>> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --everything
+
+# Run scrub to make some noise
+_scratch_scrub -b -n >> $seqres.full
+
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
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
index 00000000000000..fe797b654ca6ad
--- /dev/null
+++ b/tests/xfs/1883
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1883
+#
+# Make sure that xfs_healer correctly validates the json events that it gets
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
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_scratch
+
+# Does this fs support health monitoring?
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_scratch_xfs_healer --require-validation --check 2> /dev/null || \
+	_notrun "health monitoring with validation not supported on this system"
+_scratch_unmount
+
+# Create a sample fs with all the goodies
+_scratch_populate_cached nofill &>> $seqres.full
+_scratch_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer" --require-validation --everything --debug-fast
+
+# Run scrub to make some noise
+_scratch_scrub -b -n >> $seqres.full
+
+# Wait for up to 60 seconds for the log file to stop growing
+old_logsz=
+new_logsz=$(stat -c '%s' $tmp.healer)
+for ((i = 0; i < 60; i++)); do
+	test "$old_logsz" = "$new_logsz" && break
+	old_logsz="$new_logsz"
+	sleep 1
+	new_logsz=$(stat -c '%s' $tmp.healer)
+done
+
+_scratch_kill_xfs_healer
+
+# Look for schema validation errors
+grep -q 'not valid under any of the given schemas' $tmp.healer && \
+	echo "Should not have found schema validation errors"
+cat $tmp.healer >> $seqres.full
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
index 00000000000000..bef185c8d74f95
--- /dev/null
+++ b/tests/xfs/1884
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1884
+#
+# Ensure that autonomous self healing fixes the filesystem correctly.
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
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_xfs_has_feature $SCRATCH_MNT rmapbt || \
+	_notrun "reverse mapping required to test directory auto-repair"
+_xfs_has_feature $SCRATCH_MNT parent || \
+	_notrun "parent pointers required to test directory auto-repair"
+_scratch_xfs_healer --repair --check || \
+	_notrun "health monitoring with repair not supported on this kernel"
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
+# List the dirents of /victimdir to see if it stops reporting corruption
+ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+try=0
+while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
+	echo "retry $try still saw corruption" >> $seqres.full
+	sleep 0.1
+	ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
+	try=$((try + 1))
+done
+echo "retry $try no longer saw corruption or gave up" >> $seqres.full
+
+# Unmount to kill the healer
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
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
diff --git a/tests/xfs/1896 b/tests/xfs/1896
new file mode 100755
index 00000000000000..6533f949c01ebc
--- /dev/null
+++ b/tests/xfs/1896
@@ -0,0 +1,206 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1896
+#
+# Check that xfs_healer can report file IO errors.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/fuzzy
+. ./common/filter
+. ./common/dmerror
+. ./common/systemd
+
+_require_scratch
+_require_scrub
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_dm_target error
+_require_no_xfs_always_cow	# no out of place writes
+
+# Ignore everything from the healer except for the four IO error log messages.
+# Strip out file handle and range information because the blocksize can vary.
+# Writeback and readahead can trigger multiple error messages due to retries,
+# hence the uniq.
+filter_healer_errors() {
+	_filter_scratch | \
+		grep -E '(readahead|directio|writeback)' | \
+		sed -e 's/\s*pos .*$//g' \
+		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
+		    -e 's|SCRATCH_MNT: ino [0-9]* gen 0x[0-9a-f]*|VICTIM:|g' | \
+		uniq
+}
+
+_scratch_mkfs >> $seqres.full
+
+#
+# The dm-error map added by this test doesn't work on zoned devices because
+# table sizes need to be aligned to the zone size, and even for zoned on
+# conventional this test will get confused because of the internal RT device.
+#
+# That check requires a mounted file system, so do a dummy mount before setting
+# up DM.
+#
+_scratch_mount
+_require_xfs_scratch_non_zoned
+_scratch_xfs_healer --check &>/dev/null || \
+	_notrun "health monitoring not supported on this kernel"
+_scratch_unmount
+
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+# Write a file with 4 file blocks worth of data, figure out the LBA to target
+victim=$SCRATCH_MNT/a
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
+unset errordev
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="RT"
+fi
+bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
+echo "$errordev:$bmap_str" >> $seqres.full
+
+phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
+kernel_sectors_per_fs_block=$((fs_blksz / 512))
+
+# Did we get at least 4 fs blocks worth of extent?
+min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
+test "$len" -lt $min_len_sectors && \
+	_fail "could not format a long enough extent on an empty fs??"
+
+phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
+
+echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full
+
+# Set the dmerror table so that all IO will pass through.
+_dmerror_reset_table
+
+cat >> $seqres.full << ENDL
+dmerror before:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+# All sector numbers that we feed to the kernel must be in units of 512b, but
+# they also must be aligned to the device's logical block size.
+logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+kernel_sectors_per_device_lba=$((logical_block_size / 512))
+
+# Mark as bad one of the device LBAs in the middle of the extent.  Target the
+# second LBA of the third block of the four-block file extent that we allocated
+# earlier, but without overflowing into the fourth file block.
+bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
+bad_len=$kernel_sectors_per_device_lba
+if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
+	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
+fi
+if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
+	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
+fi
+
+# Remount to flush the page cache, start the healer, and make the LBA bad
+_dmerror_unmount
+_dmerror_mount
+
+_scratch_invoke_xfs_healer "$tmp.healer"
+
+_dmerror_mark_range_bad $bad_sector $bad_len $errordev
+
+cat >> $seqres.full << ENDL
+dmerror after marking bad:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+_dmerror_load_error_table
+
+# See if buffered reads pick it up
+echo "Try buffered read"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Now mark the bad range good so that unmount won't fail due to IO errors.
+echo "Fix device"
+_dmerror_mark_range_good $bad_sector $bad_len $errordev
+_dmerror_load_error_table
+
+cat >> $seqres.full << ENDL
+dmerror after marking good:
+$DMERROR_TABLE
+$DMERROR_RTTABLE
+<end table>
+ENDL
+
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer _dmerror_unmount
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer_errors
+
+# Start the healer again so that can verify that the errors don't persist after
+# we flip back to the good dm table.
+echo "Remount and restart healer"
+_dmerror_mount
+_scratch_invoke_xfs_healer "$tmp.healer"
+
+# See if buffered reads pick it up
+echo "Try buffered read again"
+$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio reads pick it up
+echo "Try directio read again"
+$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
+
+# See if directio writes pick it up
+echo "Try directio write again"
+$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# See if buffered writes pick it up
+echo "Try buffered write again"
+$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
+
+# Unmount fs to kill healer, then wait for it to finish
+echo "Kill healer again"
+_scratch_kill_xfs_healer _dmerror_unmount
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer_errors
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1896.out b/tests/xfs/1896.out
new file mode 100644
index 00000000000000..33fd0ce3fc29f0
--- /dev/null
+++ b/tests/xfs/1896.out
@@ -0,0 +1,21 @@
+QA output created by 1896
+Try buffered read
+pread: Input/output error
+Try directio read
+pread: Input/output error
+Try directio write
+pwrite: Input/output error
+Try buffered write
+fsync: Input/output error
+Fix device
+Kill healer
+VICTIM: readahead
+VICTIM: directio_read
+VICTIM: directio_write
+VICTIM: writeback
+Remount and restart healer
+Try buffered read again
+Try directio read again
+Try directio write again
+Try buffered write again
+Kill healer again
diff --git a/tests/xfs/1897 b/tests/xfs/1897
new file mode 100755
index 00000000000000..12f9c284406ce8
--- /dev/null
+++ b/tests/xfs/1897
@@ -0,0 +1,98 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1897
+#
+# Check that xfs_healer can report media errors.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+. ./common/fuzzy
+. ./common/filter
+. ./common/systemd
+
+_require_scratch
+_require_scrub
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_xfs_io_command mediaerror
+
+filter_healer() {
+	_filter_scratch | \
+		grep 'media error' | \
+		sed -e 's/0x[0-9a-f]*/NUM/g' \
+		    -e 's/datadev/DEVICE/g' \
+		    -e 's/rtdev/DEVICE/g'
+}
+
+_scratch_mkfs >> $seqres.full
+
+_scratch_mount
+_scratch_xfs_healer --check &>/dev/null || \
+	_notrun "health monitoring not supported on this kernel"
+
+# Write a file with 4 file blocks worth of data, figure out the LBA to target
+victim=$SCRATCH_MNT/a
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
+unset errordev
+
+awk_len_prog='{print $6}'
+if _xfs_is_realtime_file $victim; then
+	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
+		awk_len_prog='{print $4}'
+	fi
+	errordev="-r"
+fi
+bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
+echo "$errordev:$bmap_str" >> $seqres.full
+
+phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
+len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
+
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
+kernel_sectors_per_fs_block=$((fs_blksz / 512))
+
+# Did we get at least 4 fs blocks worth of extent?
+min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
+test "$len" -lt $min_len_sectors && \
+	_fail "could not format a long enough extent on an empty fs??"
+
+phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
+
+echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
+echo "victim file:" >> $seqres.full
+od -tx1 -Ad -c $victim >> $seqres.full
+
+# All sector numbers that we feed to the kernel must be in units of 512b, but
+# they also must be aligned to the device's logical block size.
+logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
+kernel_sectors_per_device_lba=$((logical_block_size / 512))
+
+# Mark as bad one of the device LBAs in the middle of the extent.  Target the
+# second LBA of the third block of the four-block file extent that we allocated
+# earlier, but without overflowing into the fourth file block.
+bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
+bad_len=$kernel_sectors_per_device_lba
+if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
+	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
+fi
+if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
+	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
+fi
+
+echo "Simulate media error"
+_scratch_invoke_xfs_healer "$tmp.healer"
+$XFS_IO_PROG -x -c "mediaerror $errordev $bad_sector $bad_len" $SCRATCH_MNT
+
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | filter_healer
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1897.out b/tests/xfs/1897.out
new file mode 100755
index 00000000000000..8bdb4d69b7b84f
--- /dev/null
+++ b/tests/xfs/1897.out
@@ -0,0 +1,4 @@
+QA output created by 1897
+Simulate media error
+Kill healer
+SCRATCH_MNT: media error on DEVICE daddr NUM bbcount NUM
diff --git a/tests/xfs/1898 b/tests/xfs/1898
new file mode 100755
index 00000000000000..590ed1461513eb
--- /dev/null
+++ b/tests/xfs/1898
@@ -0,0 +1,36 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1898
+#
+# Check that xfs_healer can report filesystem shutdowns.
+
+. ./common/preamble
+_begin_fstest auto quick scrub eio selfhealing
+
+. ./common/fuzzy
+. ./common/filter
+. ./common/systemd
+
+_require_scratch_nocheck
+_require_scrub
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 500k" -c "fsync" $victim >> $seqres.full
+
+echo "Start healer and shut down"
+_scratch_invoke_xfs_healer "$tmp.healer"
+_scratch_shutdown -f
+
+# Unmount filesystem to start fresh
+echo "Kill healer"
+_scratch_kill_xfs_healer
+cat $tmp.healer >> $seqres.full
+cat $tmp.healer | _filter_scratch | grep 'shut down'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1898.out b/tests/xfs/1898.out
new file mode 100755
index 00000000000000..f71f848da810ce
--- /dev/null
+++ b/tests/xfs/1898.out
@@ -0,0 +1,4 @@
+QA output created by 1898
+Start healer and shut down
+Kill healer
+SCRATCH_MNT: filesystem shut down due to forced unmount
diff --git a/tests/xfs/1899 b/tests/xfs/1899
new file mode 100755
index 00000000000000..866c821f4bbb0e
--- /dev/null
+++ b/tests/xfs/1899
@@ -0,0 +1,109 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
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
+_scratch_xfs_healer --repair --check || \
+	_notrun "health monitoring with repair not supported on this kernel"
+
+filter_healer() {
+	_filter_scratch | \
+		grep 'Full repair:' | \
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
+svcname="$(systemd-escape --template 'xfs_scrub@.service' --path "$SCRATCH_MNT")"
+_systemd_unit_wait "$svcname"
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
index 00000000000000..48fd6078388371
--- /dev/null
+++ b/tests/xfs/1899.out
@@ -0,0 +1,3 @@
+QA output created by 1899
+ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning
+SCRATCH_MNT: Full repair: Repairs in progress.
diff --git a/tests/xfs/1900 b/tests/xfs/1900
new file mode 100755
index 00000000000000..d6699c82cb8d0e
--- /dev/null
+++ b/tests/xfs/1900
@@ -0,0 +1,116 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
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
+_scratch_xfs_healer --repair --check || \
+	_notrun "health monitoring with repair not supported on this kernel"
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
diff --git a/tests/xfs/1901 b/tests/xfs/1901
new file mode 100755
index 00000000000000..163a4e8162d4c7
--- /dev/null
+++ b/tests/xfs/1901
@@ -0,0 +1,138 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
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
+_xfs_healer "$mntpt" --repair --check || \
+	_notrun "health monitoring with repair not supported on this kernel"
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

