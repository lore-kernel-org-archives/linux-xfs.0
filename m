Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B233909AE;
	Tue,  3 Mar 2026 00:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498861; cv=none; b=SXCDS/kmAaABb4bdFs1PGgTimxL+z2oAJqVq0FbQNA+MVuIM7x0AwuLbCDSFfLuyDCnS+nP+j7AXnsMLbQWaXe3pu9f8jgxyGTXQ29QgQYEFxpxHoWme6xIY8wzQZimMOGFf3JXt92PBwswgHbfbcwanOoVK3VvoiSh7ir5k49k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498861; c=relaxed/simple;
	bh=YFqBgaJuK1OlwbhS42ODQa19TFnjE6y8hxDLopekmpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PYT3lYBai7Mo+i1hVCQihQwbSFgdfJXCrnqN4v/vucGBt6MNzqFU5+oaNC4dhpXh3kjOz9gC5ctzbT0fT4044G4zUpUq/r/v17JplFASKbAZX/RPyn5KGxHigSF+UiJ1B08znCymqvgaZNHdX26LRJ9jNM70Et70Z+MM1AOj3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2J3Dix7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2J3Dix7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E4DC19423;
	Tue,  3 Mar 2026 00:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498860;
	bh=YFqBgaJuK1OlwbhS42ODQa19TFnjE6y8hxDLopekmpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l2J3Dix7QstK58DvFUkWhcoUsl4p8fRt90muSvHdcBnOxdi0LvQFW9w8nUPHArtFu
	 toDnHcnaavjVD8nxRXu1dCqM0uGeg7fl5dNaOhmS6oOVIDpsVzja2/K9Y1zFbTiW9L
	 telAWSl1f1cJftH3sUQJQjiklYMP+sEyDk3zNK+ZEluN8DVRn65EXNmbJ8j6ZuYxCQ
	 iThjueMryqiHwvyJSQjx12Xvwxp3Ky8TMjjGxMA7bbPBY1/O+cfnFbk7h4oPeENn2O
	 EvSQsU9DIhurfUT2iv3oYr0VZVVB4FKDArQZKqES1uTyEO+rfbv/duh9jGL7iDdIpw
	 50YNF2n/jhedg==
Date: Mon, 2 Mar 2026 16:47:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 14/13] xfs: test xfs_healer startup service
Message-ID: <20260303004739.GD13843@frogsfrogsfrogs>
References: <20260303002508.GB57948@frogsfrogsfrogs>
 <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249785709.483507.8373602184765043420.stgit@frogsfrogsfrogs>

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
