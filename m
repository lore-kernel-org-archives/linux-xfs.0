Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2103BD64F;
	Tue, 10 Mar 2026 03:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114811; cv=none; b=rLNVOMMGQS7lvtz+GpPwHUSE4UriIx/VwKYTBzoLmLTOfCBz4KJ/Gjdm2WpxA6s+CysOAmZHUMx9ERGRVV8k1w/M0zWF5fb0mYBp6xPKg6PsPLvKjixpeuM1s9Z5nIm/BW/7pDLS98k5w1uRCN2VvfhTPW6ZyJ9AmrvKb6tFvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114811; c=relaxed/simple;
	bh=3l0aOUJvgBwdDIq/xul9G1qpmkU0Fw9Ll+OUzC+Nek8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7o1dkbmAvLOdel+DmSPARm8fRaPSJMgqXa0cdFiSheq/z1RfvypN89IskIq4AhoDITzXAuPg2blIAqZNAGfbFu4peoF6vlFHK6vCtrwd7q3iHdviXiB3D2dTfWVS6YEqqSUxoMpRPXmPW/eP2D9OBaaQhEqn5JLXkIeUGlUMEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5rHSNnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5rHSNnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E580C2BCB0;
	Tue, 10 Mar 2026 03:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114811;
	bh=3l0aOUJvgBwdDIq/xul9G1qpmkU0Fw9Ll+OUzC+Nek8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G5rHSNnLHriWgfkasJzHYc5kE2suMoSJNN9UNuUXkZmARb9XDIWaV/4ud28ifI/xN
	 PA0pyBlrSLslrDl57qpCpW3tdCovf5MMpqKISP83cqA5zq7qUGPkJLc4s/KJIQs+NP
	 DjszwLmecwOhAVI5e7c4lkqE+ybM6RoD6BKXu968TLvknS13YM9/oBcm7wdfXY8QqD
	 FXheuTyEXyyQLEQ8PIfGwTUF68l6oWIASGXwWiCgALHB++rgBvwHbyw6tJmdgtFzqa
	 lSFGk+wG44lOdDvkCIYlNFKNKVxjzyBrIGovJD4xSYxs23zUFHf1hvI6niG8dgqrBO
	 tPQMQw1eYm65g==
Date: Mon, 09 Mar 2026 20:53:31 -0700
Subject: [PATCH 13/14] xfs: test xfs_healer background service
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177311404015.1186408.8347077076824913709.stgit@frogsfrogsfrogs>
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

Make sure that when xfs_healer can monitor and repair filesystems when it's
running as a systemd service, which is the intended usage model.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1902     |  152 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1902.out |    2 +
 2 files changed, 154 insertions(+)
 create mode 100755 tests/xfs/1902
 create mode 100755 tests/xfs/1902.out


diff --git a/tests/xfs/1902 b/tests/xfs/1902
new file mode 100755
index 00000000000000..6de2d602d52cdb
--- /dev/null
+++ b/tests/xfs/1902
@@ -0,0 +1,152 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1902
+#
+# Ensure that autonomous self healing fixes the filesystem correctly when
+# running in a systemd service
+#
+# unreliable_in_parallel: this test runs the xfs_healer systemd service, which
+# cannot be isolated to a specific testcase with the way check-parallel is
+# implemented.
+#
+. ./common/preamble
+_begin_fstest auto selfhealing unreliable_in_parallel
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
+. ./common/fuzzy
+. ./common/systemd
+
+_require_systemd_is_running
+_require_systemd_unit_defined xfs_healer@.service
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
+# Break the directory
+_scratch_unmount
+_scratch_xfs_db -x \
+	-c 'path /some/victimdir' \
+	-c 'bmap' \
+	-c 'dblock 1' \
+	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
+
+# Find the existing xfs_healer@ service definition, figure out where we're
+# going to land our test-specific override
+orig_svcfile="$(_systemd_unit_path "xfs_healer@-.service")"
+test -f "$orig_svcfile" || \
+	_notrun "cannot find xfs_healer@ service file"
+
+new_svcdir="$(_systemd_runtime_dir)"
+test -d "$new_svcdir" || \
+	_notrun "cannot find runtime systemd service dir"
+
+# We need to make some local mods to the xfs_healer@ service definition
+# so we fork it and create a new service just for this test.
+new_healer_template="xfs_healer_fstest@.service"
+new_healer_svc="$(_systemd_service_unit_path "$new_healer_template" "$SCRATCH_MNT")"
+_systemd_unit_status "$new_healer_svc" 2>&1 | \
+	grep -E -q '(could not be found|Loaded: not-found)' || \
+	_notrun "systemd service \"$new_healer_svc\" found, will not mess with this"
+
+new_svcfile="$new_svcdir/$new_healer_template"
+cp "$orig_svcfile" "$new_svcfile"
+
+# Pick up all the CLI args except for --repair and --no-autofsck because we're
+# going to force it to --autofsck below
+execargs="$(grep '^ExecStart=' $new_svcfile | \
+	    sed -e 's/^ExecStart=\S*//g' \
+	        -e 's/--no-autofsck//g' \
+		-e 's/--repair//g')"
+sed -e '/ExecStart=/d' -e '/BindPaths=/d' -e '/ExecCondition=/d' -i $new_svcfile
+cat >> "$new_svcfile" << ENDL
+
+[Service]
+ExecCondition=$XFS_HEALER_PROG --supported %f
+ExecStart=$XFS_HEALER_PROG $execargs
+ENDL
+_systemd_reload
+
+# Emit the results of our editing to the full log.
+systemctl cat "$new_healer_svc" >> $seqres.full
+
+# Remount, with service activation
+_scratch_mount
+
+old_healer_svc="$(_xfs_healer_svcname "$SCRATCH_MNT")"
+_systemd_unit_stop "$old_healer_svc" &>> $seqres.full
+_systemd_unit_start "$new_healer_svc" &>> $seqres.full
+
+_systemd_unit_status "$new_healer_svc" 2>&1 | grep -q 'Active: active' || \
+	echo "systemd service \"$new_healer_svc\" not running??"
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
+journalctl -u "$new_healer_svc" >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/1902.out b/tests/xfs/1902.out
new file mode 100755
index 00000000000000..84f9b9e50e1e02
--- /dev/null
+++ b/tests/xfs/1902.out
@@ -0,0 +1,2 @@
+QA output created by 1902
+ls: reading directory 'SCRATCH_MNT/some/victimdir': Structure needs cleaning

