Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E9E12CDA5;
	Tue,  3 Mar 2026 00:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498515; cv=none; b=fbhbK1slLhb0lcG3JG5zXE0Vj+NqIl/v6VzXFL9vX8Z+xPhBqCNJrISQjgPFdIC/Q0oa2nTwWp4//VUf/+cgFO35maEhykN0o0zVZooZaCADdzdWaQy5i9s7Qrcmu+fCnP6dyihGQSjnYBzkjff9RfU84Vw2+1MI3NzzuWaR03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498515; c=relaxed/simple;
	bh=y5UKO+/Jj5BwxKbCKmRQJJA3b9wPo/Ia91iyt1LBTyM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIbO8dJMrGDs8Yvv13d4x35jYVCB/gdS+XKbxHgxIgAv2P2PkaWUq6L7tq1GR82sySUtaLUD4Enrd1Pj6qcr1/I0ikOrtN7v1avhq7lXy8T1wJjMza6yilGKgZkakSuCzHrpUHcEt9aANy/av63LTF7XBS0MwqioQQJkgNHD8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cy49dAvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cy49dAvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05049C19423;
	Tue,  3 Mar 2026 00:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498515;
	bh=y5UKO+/Jj5BwxKbCKmRQJJA3b9wPo/Ia91iyt1LBTyM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cy49dAvGFR5+RHweuBXXQP71b9D9UoKxqthL3s5SJaRJbgD55Oo+vUpyRPvK4EXf4
	 2QuqDUDZp7HOzYzNKVuTOdWg1zHb9mKDv595bA+CMsW8HBH28/9OzSas9f5Bxqbx6u
	 WyjWEprEqU6HVg38NoJHfuB4yJHrQSmBHnuFwJxpheSzsqg3Z1Ajyhij1GbO2oZpIO
	 cdo3L1mhY/Z/n+GV1EDuS2GGTd6APFDK2wf4BNQgLZO3T7d5OqZC7wDtAKlQaeGjoM
	 W9MOuPa1NKPuu4zvnYF/X/r4txplUE/XjEFpEtippsCArD37rLOtsRINj2EfvUISRh
	 9uryY3utx/Khw==
Date: Mon, 02 Mar 2026 16:41:54 -0800
Subject: [PATCH 04/13] xfs: set up common code for testing xfs_healer
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177249785842.483507.7215346431953617710.stgit@frogsfrogsfrogs>
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

Add a bunch of common code so that we can test the xfs_healer daemon.
Most of the changes here are to make it easier to manage the systemd
service units for xfs_healer and xfs_scrub.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/config  |   14 +++++++
 common/rc      |    5 ++
 common/systemd |   32 ++++++++++++++++
 common/xfs     |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/802  |    4 +-
 5 files changed, 167 insertions(+), 2 deletions(-)


diff --git a/common/config b/common/config
index 1420e35ddfee42..8468a60081f50c 100644
--- a/common/config
+++ b/common/config
@@ -161,6 +161,20 @@ export XFS_ADMIN_PROG="$(type -P xfs_admin)"
 export XFS_GROWFS_PROG=$(type -P xfs_growfs)
 export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
 export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
+
+XFS_HEALER_PROG="$(type -P xfs_healer)"
+XFS_HEALER_START_PROG="$(type -P xfs_healer_start)"
+
+# If not found, try the ones installed in libexec
+if [ ! -x "$XFS_HEALER_PROG" ] && [ -e /usr/libexec/xfsprogs/xfs_healer ]; then
+	XFS_HEALER_PROG=/usr/libexec/xfsprogs/xfs_healer
+fi
+if [ ! -x "$XFS_HEALER_START_PROG" ] && [ -e /usr/libexec/xfsprogs/xfs_healer_start ]; then
+	XFS_HEALER_START_PROG=/usr/libexec/xfsprogs/xfs_healer_start
+fi
+export XFS_HEALER_PROG
+export XFS_HEALER_START_PROG
+
 export XFS_PARALLEL_REPAIR_PROG="$(type -P xfs_prepair)"
 export XFS_PARALLEL_REPAIR64_PROG="$(type -P xfs_prepair64)"
 export __XFSDUMP_PROG="$(type -P xfsdump)"
diff --git a/common/rc b/common/rc
index 38d4b500b3b51f..91db0fb09da891 100644
--- a/common/rc
+++ b/common/rc
@@ -3026,6 +3026,11 @@ _require_xfs_io_command()
 	"label")
 		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
 		;;
+	"verifymedia")
+		testio=`$XFS_IO_PROG -x -c "verifymedia $* 0 0" 2>&1`
+		echo $testio | grep -q "invalid option" && \
+			_notrun "xfs_io $command support is missing"
+		;;
 	"open")
 		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
 		# a new -C flag was introduced to execute one shot commands.
diff --git a/common/systemd b/common/systemd
index b2e24f267b2d93..b4c77c78a8da44 100644
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
@@ -71,3 +83,23 @@ _systemd_unit_status() {
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
+
+# Mask or unmask a running systemd unit
+_systemd_unit_mask() {
+	systemctl mask "$1"
+}
+_systemd_unit_unmask() {
+	systemctl unmask "$1"
+}
+_systemd_unit_masked() {
+	systemctl status "$1" 2>/dev/null | grep -q 'Loaded: masked'
+}
diff --git a/common/xfs b/common/xfs
index 7fa0db2e26b4c9..a4a538fde3f173 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2301,3 +2301,117 @@ _filter_bmap_gno()
 		if ($ag =~ /\d+/) {print "$ag "} ;
         '
 }
+
+# Compute the systemd service instance name for a background service and path
+_xfs_systemd_svcname()
+{
+	local arg
+	local template
+	local out
+	local svc="$1"
+	shift
+
+	case "$svc" in
+	--scrub)	arg="-s"; template="xfs_scrub@.service";;
+	--healer)	arg="-h"; template="xfs_healer@.service";;
+	*)		arg="-t $svc"; template="$svc";;
+	esac
+
+	# xfs_io should be able to do all the magic to make this work...
+	out="$($XFS_IO_PROG -c "svcname ${arg} $*" / 2>/dev/null)"
+	if [ -n "$out" ]; then
+		echo "$out"
+		return
+	fi
+
+	# ...but if not, we can fall back to brute force systemd invocations.
+	systemd-escape --template "$template" --path "$*"
+}
+
+# Compute the xfs_healer systemd service instance name for a given path
+_xfs_healer_svcname()
+{
+	_xfs_systemd_svcname --healer "$@"
+}
+
+# Compute the xfs_scrub systemd service instance name for a given path
+_xfs_scrub_svcname()
+{
+	_xfs_systemd_svcname --scrub "$@"
+}
+
+# Run the xfs_healer program on some filesystem
+_xfs_healer() {
+	$XFS_HEALER_PROG "$@"
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
+		local svc="$(_xfs_healer_svcname "$mount")"
+		_systemd_unit_stop "$svc" &>> $seqres.full
+	fi
+
+	$XFS_HEALER_PROG "$mount" "$@" &> "$logfile" &
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
+
+# Does this mounted filesystem support xfs_healer?
+_require_xfs_healer()
+{
+	_xfs_healer --supported "$@" &>/dev/null || \
+		_notrun "health monitoring not supported on this kernel"
+}
diff --git a/tests/xfs/802 b/tests/xfs/802
index fc4767acb66a55..18312b15b645bd 100755
--- a/tests/xfs/802
+++ b/tests/xfs/802
@@ -105,8 +105,8 @@ run_scrub_service() {
 }
 
 echo "Scrub Scratch FS"
-scratch_path=$(systemd-escape --path "$SCRATCH_MNT")
-run_scrub_service xfs_scrub@$scratch_path
+svc="$(_xfs_scrub_svcname "$SCRATCH_MNT")"
+run_scrub_service "$svc"
 find_scrub_trace "$SCRATCH_MNT"
 
 # Remove the xfs_scrub_all media scan stamp directory (if specified) because we

