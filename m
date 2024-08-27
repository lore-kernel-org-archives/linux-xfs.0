Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8379145024;
	Tue, 27 Aug 2024 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784384; cv=none; b=TbodpmodYBdWaOomt4zXGK6H7xj1YR5+5eHBjkRO1ZKvUdGrKD572Pz2fx/dUh+3vuTYduGHijjHVTfIwx87mdqMVwNOSp/E11mayEn0ihebsxkFUn88cWlio/4M6bCkpA5P7bV33NtMG59HQhde7oW7d95eMTT0ofxv+XyCGCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784384; c=relaxed/simple;
	bh=F7SdUFhBVUxz0OsPExbnI1+BHOZs2fx+NPFHFUCGgZg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K86rLpLOdwYXMnj8K72vkxwlsyl8sd8W+sNtruBeeqAnygm1cvhtvokZhA2Xpn+7M77o/gk60lM7ulUAlFoIofBBhQP1VQHH3f/pNLRLPFaYrIXXGGxOPaRzcWAl3k7/87ejS5p5NPSNV7g5IsQuT3V9Plbpp+9tIUws6fc4ynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfaMJe+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfaMJe+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA36C4FEA1;
	Tue, 27 Aug 2024 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784384;
	bh=F7SdUFhBVUxz0OsPExbnI1+BHOZs2fx+NPFHFUCGgZg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kfaMJe+kP4yhIUc6QbjU8B4bC+SWWatwhXB1e60iWx3GA+Onp0R3zcqnSz705Wcca
	 pYpg1qz0txFTyAhSN2O2Kn4mvhoQyocbwuYqcCVm+rVmR5ABI4wD+A20ENMVJNC1KM
	 NLttr1jZWx84kxqgeSbDGfYShDDrnc7UekcEqLcU0YEX3BGbr1HgjC2ydbgoRIb/Ef
	 1bUsGbzAxjVJzShhrlcdO6htkyVBCCtpFunWvi0WaOnxaECDMVVXFFhSXLlyjojP2x
	 1aGNArvQVwHIhQ57cq41spOkR2bu+FDoUh8wXsoeLYyCOyrGDz5HJA+QzR8F2AXRX/
	 nbAYS/csVGQAQ==
Date: Tue, 27 Aug 2024 11:46:23 -0700
Subject: [PATCH 1/1] xfs: test xfs_scrub services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478422655.2039472.662383375138981747.stgit@frogsfrogsfrogs>
In-Reply-To: <172478422640.2039472.46168148654222028.stgit@frogsfrogsfrogs>
References: <172478422640.2039472.46168148654222028.stgit@frogsfrogsfrogs>
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

Create a pair of new tests that check that xfs_scrub and xfs_scrub_all
will find and test mounted filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc          |   14 +++++
 common/systemd     |   73 +++++++++++++++++++++++++++
 tests/xfs/1863     |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1863.out |    5 ++
 4 files changed, 232 insertions(+)
 create mode 100644 common/systemd
 create mode 100755 tests/xfs/1863
 create mode 100644 tests/xfs/1863.out


diff --git a/common/rc b/common/rc
index 9da9fe1882..5a26669925 100644
--- a/common/rc
+++ b/common/rc
@@ -5480,6 +5480,20 @@ _require_duplicate_fsid()
 	esac
 }
 
+# Can we find a program in the $PATH?
+_have_program() {
+	command -v "$1" &>/dev/null
+}
+
+# Require that a program can be found via the $PATH, or complain otherwise
+_require_program() {
+	local cmd="$1"
+	local tag="$2"
+
+	test -z "$tag" && tag="$(basename "$cmd")"
+	_have_program "$1" || _notrun "$tag required"
+}
+
 init_rc
 
 ################################################################################
diff --git a/common/systemd b/common/systemd
new file mode 100644
index 0000000000..b2e24f267b
--- /dev/null
+++ b/common/systemd
@@ -0,0 +1,73 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# Routines for managing systemd units
+
+# Is systemd installed?
+_systemd_installed() {
+	_have_program systemctl
+}
+
+_require_systemd_installed() {
+	_require_program systemctl systemd
+}
+
+# Is systemd running on this system?
+_systemd_is_running() {
+	_systemd_installed || return 1
+	systemctl show-environment &>/dev/null
+}
+
+_require_systemd_is_running() {
+	_systemd_is_running || \
+		_notrun "systemd is not active"
+}
+
+# Is this unit defined, as according to systemd?
+_systemd_unit_defined() {
+	_systemd_installed || return 1
+	systemctl cat "$1" >/dev/null
+}
+
+_require_systemd_unit_defined() {
+	_require_systemd_installed
+	_systemd_unit_defined "$1" || \
+		_notrun "systemd unit \"$1\" not found"
+}
+
+# Is this unit active, as according to systemd?
+_systemd_unit_active() {
+	_systemd_installed || return 1
+	_systemd_unit_defined "$1" || return 1
+
+	test "$(systemctl is-active "$1")" = "active"
+}
+
+_require_systemd_unit_active() {
+	_require_systemd_unit_defined "$1"
+	_systemd_unit_active "$1" || \
+		_notrun "systemd unit \"$1\" not active"
+}
+
+# Find the path to a systemd unit
+_systemd_unit_path() {
+	systemctl show "$1" | grep FragmentPath= | cut -d '=' -f 2
+}
+
+# Make systemd reload itself after changing unit files or generator sources
+# such as /etc/fstab
+_systemd_reload() {
+	systemctl daemon-reload
+}
+
+# Where is the systemd runtime directory?
+_systemd_runtime_dir() {
+	echo "/run/systemd/system/"
+}
+
+# What is the status of this systemd unit?
+_systemd_unit_status() {
+	_systemd_installed || return 1
+	systemctl status "$1"
+}
diff --git a/tests/xfs/1863 b/tests/xfs/1863
new file mode 100755
index 0000000000..7d41092e2e
--- /dev/null
+++ b/tests/xfs/1863
@@ -0,0 +1,140 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1863
+#
+# Check that the online fsck systemd services find and check the scratch
+# filesystem, and that we can read the health reports after the fact.  IOWs,
+# this is basic testing for the systemd background services.
+#
+. ./common/preamble
+_begin_fstest auto scrub
+
+_cleanup()
+{
+	cd /
+	if [ -n "$new_svcfile" ]; then
+		rm -f "$new_svcfile"
+		systemctl daemon-reload
+	fi
+	rm -r -f $tmp.*
+}
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+. ./common/systemd
+
+_require_systemd_is_running
+_require_systemd_unit_defined xfs_scrub@.service
+_require_systemd_unit_defined xfs_scrub_all.service
+_require_scratch
+_require_scrub
+_require_xfs_io_command "scrub"
+_require_xfs_spaceman_command "health"
+_require_populate_commands
+
+# xfs_scrub_all requires the python3-dbus library, which is a separate package
+_require_command $PYTHON3_PROG python3
+$PYTHON3_PROG -c 'import dbus' &>/dev/null || \
+	_notrun "test requires python3-dbus"
+
+_require_command $ATTR_PROG "attr"
+
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
+
+# Back when xfs_scrub was really experimental, the systemd service definitions
+# contained various bugs that resulted in weird problems such as logging
+# messages sometimes dropping slashes from paths, and the xfs_scrub@ service
+# being logged as completing long after the process actually stopped.  These
+# problems were all fixed by the time the --auto-media-scan-stamp option was
+# added to xfs_scrub_all, so turn off this test for such old codebases.
+scruball_exe="$(systemctl cat xfs_scrub_all | grep '^ExecStart=' | \
+	sed -e 's/ExecStart=//g' -e 's/ .*$//g')"
+grep -q -- '--auto-media-scan-stamp' "$scruball_exe" || \
+	_notrun "xfs_scrub service too old, skipping test"
+
+orig_svcfile="$(_systemd_unit_path "xfs_scrub_all.service")"
+test -f "$orig_svcfile" || \
+	_notrun "cannot find xfs_scrub_all service file"
+
+new_svcdir="$(_systemd_runtime_dir)"
+test -d "$new_svcdir" || \
+	_notrun "cannot find runtime systemd service dir"
+
+# We need to make some local mods to the xfs_scrub_all service definition
+# so we fork it and create a new service just for this test.
+new_scruball_svc="xfs_scrub_all_fstest.service"
+_systemd_unit_status "$new_scruball_svc" 2>&1 | \
+	grep -E -q '(could not be found|Loaded: not-found)' || \
+	_notrun "systemd service \"$new_scruball_svc\" found, will not mess with this"
+
+find_scrub_trace() {
+	local path="$1"
+
+	$XFS_SPACEMAN_PROG -c "health" "$path" | grep -q ": ok$" || \
+		echo "cannot find evidence that $path was scrubbed"
+}
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+_scratch_mount
+
+# Configure the filesystem for background checks of the filesystem.
+$ATTR_PROG -R -s xfs:autofsck -V check $SCRATCH_MNT >> $seqres.full
+
+run_scrub_service() {
+	systemctl start --wait "$1"
+
+	# Sometimes systemctl start --wait returns early due to some external
+	# event, such as somebody else reloading the daemon, which closes the
+	# socket.  The CLI has no way to resume waiting for the service once
+	# the connection breaks, so we'll pgrep for up to 30 seconds until
+	# there are no xfs_scrub processes running on the system.
+	for ((i = 0; i < 30; i++)); do
+		pgrep -f 'xfs_scrub*' > /dev/null 2>&1 || break
+		sleep 1
+	done
+}
+
+echo "Scrub Scratch FS"
+scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
+run_scrub_service xfs_scrub@$scratch_path
+find_scrub_trace "$SCRATCH_MNT"
+
+# Remove the xfs_scrub_all media scan stamp directory (if specified) because we
+# want to leave the regular system's stamp file alone.
+mkdir -p $tmp/stamp
+
+new_svcfile="$new_svcdir/$new_scruball_svc"
+cp "$orig_svcfile" "$new_svcfile"
+
+execstart="$(grep '^ExecStart=' $new_svcfile | \
+	sed -e 's/--auto-media-scan-interval[[:space:]]*[0-9]*[a-z]*//g')"
+sed -e '/ExecStart=/d' -e '/BindPaths=/d' -i $new_svcfile
+cat >> "$new_svcfile" << ENDL
+[Service]
+$execstart
+ENDL
+_systemd_reload
+
+# Emit the results of our editing to the full log.
+systemctl cat "$new_scruball_svc" >> $seqres.full
+
+# Cycle mounts to clear all the incore CHECKED bits.
+_scratch_cycle_mount
+
+echo "Scrub Everything"
+run_scrub_service "$new_scruball_svc"
+
+sleep 2 # give systemd a chance to tear down the service container mount tree
+
+find_scrub_trace "$SCRATCH_MNT"
+
+echo "Scrub Done" | tee -a $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1863.out b/tests/xfs/1863.out
new file mode 100644
index 0000000000..27c2d79a63
--- /dev/null
+++ b/tests/xfs/1863.out
@@ -0,0 +1,5 @@
+QA output created by 1863
+Format and populate
+Scrub Scratch FS
+Scrub Everything
+Scrub Done

