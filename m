Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58FD3BE17B;
	Tue, 10 Mar 2026 03:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114827; cv=none; b=lDczjh8pux3Ot3sy73ASRszX3ia+B4i0oPrGEFn+11y5EbXtmUo+lAFccILwvnDsh62ZuNCtFibHSbhjEpBwLvOxC+l+OQhB5VwC2M+qjz0fDNvtZE9cIrEiBeMzCtnxE6uKvs32Z1kuuPCaXIMD0P8nqijyjYbVJTiqYCtj08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114827; c=relaxed/simple;
	bh=VgvLqXWOK2hMB0AyKeyEm22V/ejAmYD+xVD0zNjSZo4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i33VCP1OH99ACdgEHwsbs8p0/jGdEUiwWuc3S2nwdTwA8ptgAEOKIhZiSkrjeo1YDtolzD3tBRmmnEcZO+0dOAJduP7MCi+Dbm70/uJ+9Ea2zXfemrlToc2tESCYF0O7jcfoYhMcaGsbDGde+QSSjxybj4cjuLiaT7bWQRvhaRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYtp1yH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYtp1yH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5615CC19423;
	Tue, 10 Mar 2026 03:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114827;
	bh=VgvLqXWOK2hMB0AyKeyEm22V/ejAmYD+xVD0zNjSZo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gYtp1yH+Hh0q31eiwRhdcB5aFObseSeIgn2eiTtbBfUz9PMJh/G+9qYDBzVC7o8QK
	 R+By+McN4fScfGlPdtThUWyZBr29TbnMusxTWALgR1p2KQfUtiWCkklT7xJmGbHIPE
	 bTEqf8bLPdF+mWpZFGml8MkNLi9qPs7Q59VpwsGU826e5ImdHV8LHYsBMRl5AGR2Kv
	 2hucvGUewoLsM74NYAwGpScCbHJ5fNl6cgTDM0m6TpwxpUt4InY31t775fV0DN7lv1
	 ZC5Rf8S8J/XTUYYHjAGr8cZKA8k2MwVl4EWTcp0tMpfDSged6iQvYfDRE2HDiVIPD5
	 kWW+O/5aaBHfQ==
Date: Mon, 09 Mar 2026 20:53:46 -0700
Subject: [PATCH 14/14] xfs: test xfs_healer startup service
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311404033.1186408.15997052827273603644.stgit@frogsfrogsfrogs>
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

Make sure that xfs_healer_start can actually start up xfs_healer service
instances when a filesystem is mounted.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1903     |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1903.out |    6 +++
 2 files changed, 130 insertions(+)
 create mode 100755 tests/xfs/1903
 create mode 100644 tests/xfs/1903.out


diff --git a/tests/xfs/1903 b/tests/xfs/1903
new file mode 100755
index 00000000000000..d71d75a6af3f9d
--- /dev/null
+++ b/tests/xfs/1903
@@ -0,0 +1,124 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1903
+#
+# Check that the xfs_healer startup service starts the per-mount xfs_healer
+# service for the scratch filesystem.  IOWs, this is basic testing for the
+# xfs_healer systemd background services.
+#
+
+# unreliable_in_parallel: this appears to try to run healer services on all
+# mounted filesystems - that's a problem when there are a hundred other test
+# filesystems mounted running other tests...
+
+. ./common/preamble
+_begin_fstest auto selfhealing unreliable_in_parallel
+
+_cleanup()
+{
+	cd /
+	test -n "$new_healerstart_svc" &&
+		_systemd_unit_stop "$new_healerstart_svc"
+	test -n "$was_masked" && \
+		_systemd_unit_mask "$healer_svc" &>> $seqres.full
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
+_require_systemd_unit_defined xfs_healer@.service
+_require_systemd_unit_defined xfs_healer_start.service
+_require_scratch
+_require_scrub
+_require_xfs_io_command "scrub"
+_require_xfs_spaceman_command "health"
+_require_populate_commands
+_require_command "$XFS_HEALER_PROG" "xfs_healer"
+_require_command $ATTR_PROG "attr"
+
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
+
+orig_svcfile="$(_systemd_unit_path "xfs_healer_start.service")"
+test -f "$orig_svcfile" || \
+	_notrun "cannot find xfs_healer_start service file"
+
+new_svcdir="$(_systemd_runtime_dir)"
+test -d "$new_svcdir" || \
+	_notrun "cannot find runtime systemd service dir"
+
+# We need to make some local mods to the xfs_healer_start service definition
+# so we fork it and create a new service just for this test.
+new_healerstart_svc="xfs_healer_start_fstest.service"
+_systemd_unit_status "$new_healerstart_svc" 2>&1 | \
+	grep -E -q '(could not be found|Loaded: not-found)' || \
+	_notrun "systemd service \"$new_healerstart_svc\" found, will not mess with this"
+
+find_healer_trace() {
+	local path="$1"
+
+	sleep 2		# wait for delays in startup
+	$XFS_HEALER_PROG --supported "$path" 2>&1 | grep -q 'already running' || \
+		echo "cannot find evidence that xfs_healer is running for $path"
+}
+
+echo "Format and populate"
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_xfs_healer $SCRATCH_MNT
+
+# Configure the filesystem for background checks of the filesystem.
+$ATTR_PROG -R -s xfs:autofsck -V check $SCRATCH_MNT >> $seqres.full
+
+was_masked=
+healer_svc="$(_xfs_healer_svcname "$SCRATCH_MNT")"
+
+# Preserve the xfs_healer@ mask state -- we don't want this permanently
+# changing global state.
+if _systemd_unit_masked "$healer_svc"; then
+	_systemd_unit_unmask "$healer_svc" &>> $seqres.full
+	was_masked=1
+fi
+
+echo "Start healer on scratch FS"
+_systemd_unit_start "$healer_svc"
+find_healer_trace "$SCRATCH_MNT"
+_systemd_unit_stop "$healer_svc"
+
+new_svcfile="$new_svcdir/$new_healerstart_svc"
+cp "$orig_svcfile" "$new_svcfile"
+
+sed -e '/ExecStart=/d' -e '/BindPaths=/d' -e '/ExecCondition=/d' -i $new_svcfile
+cat >> "$new_svcfile" << ENDL
+[Service]
+ExecCondition=$XFS_HEALER_START_PROG --supported
+ExecStart=$XFS_HEALER_START_PROG
+ENDL
+_systemd_reload
+
+# Emit the results of our editing to the full log.
+systemctl cat "$new_healerstart_svc" >> $seqres.full
+
+echo "Start healer for everything"
+_systemd_unit_start "$new_healerstart_svc"
+find_healer_trace "$SCRATCH_MNT"
+
+echo "Restart healer for scratch FS"
+_scratch_cycle_mount
+find_healer_trace "$SCRATCH_MNT"
+
+echo "Healer testing done" | tee -a $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1903.out b/tests/xfs/1903.out
new file mode 100644
index 00000000000000..07810f60ca10c6
--- /dev/null
+++ b/tests/xfs/1903.out
@@ -0,0 +1,6 @@
+QA output created by 1903
+Format and populate
+Start healer on scratch FS
+Start healer for everything
+Restart healer for scratch FS
+Healer testing done

