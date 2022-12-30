Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E40AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiLaDGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiLaDGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:06:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FB2E61;
        Fri, 30 Dec 2022 19:06:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE4FB81EA7;
        Sat, 31 Dec 2022 03:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2BDC433EF;
        Sat, 31 Dec 2022 03:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455966;
        bh=X4p/spT0xasn6hyBgY6CTZzJgtz75k34XFTSC5rloxQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UWdl10EeCWfkIHiP81Ou7PANfp7p5hq+Agod4dVbXDLxt5jNCeCikVsT4ePKF11hy
         d7+FRI6dqwRueC+no2jCNa/CWAvjMd5zNCuMmMgHeTtFswo+Le8irKJE3P0fufBrgG
         3uRrSq8QHJvmrOOZl1csU11pE+WcIBZbgPalCLeQNvtxrkemXK8sXtfSHWCWX4PW6O
         w3RujFlsb5/huCJLbcK8aHI389ZoVdCZXLumHEaMx5/mFTekuFdVFD1K4D6AeYUNyE
         lInWJbdOl/pmMxGevGapDgThTAR9uy+DE/OCuVuJJFiR2D5BKGoAx54D7xZxpDY6LI
         IYLoRe49eQfcQ==
Subject: [PATCH 1/1] xfs: test upgrading old features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:29 -0800
Message-ID: <167243882961.736459.4302174338740527578.stgit@magnolia>
In-Reply-To: <167243882949.736459.9627363155663418213.stgit@magnolia>
References: <167243882949.736459.9627363155663418213.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test the ability to add older v5 features.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/769     |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/769.out |    2 
 2 files changed, 250 insertions(+)
 create mode 100755 tests/xfs/769
 create mode 100644 tests/xfs/769.out


diff --git a/tests/xfs/769 b/tests/xfs/769
new file mode 100755
index 0000000000..7613048f52
--- /dev/null
+++ b/tests/xfs/769
@@ -0,0 +1,248 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 769
+#
+# Test upgrading filesystems with new features.
+#
+. ./common/preamble
+_begin_fstest auto mkfs repair
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+
+test -w /dev/ttyprintk || _notrun "test requires writable /dev/ttyprintk"
+_require_check_dmesg
+_require_scratch_nocheck
+_require_scratch_xfs_crc
+
+# Does repair know how to add a particular feature to a filesystem?
+check_repair_upgrade()
+{
+	$XFS_REPAIR_PROG -c "$1=narf" 2>&1 | \
+		grep -q 'unknown option' && return 1
+	return 0
+}
+
+# Are we configured for realtime?
+rt_configured()
+{
+	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
+}
+
+# Compute the MKFS_OPTIONS string for a particular feature upgrade test
+compute_mkfs_options()
+{
+	local m_opts=""
+	local caller_options="$MKFS_OPTIONS"
+
+	for feat in "${FEATURES[@]}"; do
+		local feat_state="${FEATURE_STATE["${feat}"]}"
+
+		if echo "$caller_options" | grep -E -w -q "${feat}=[0-9]*"; then
+			# Change the caller's options
+			caller_options="$(echo "$caller_options" | \
+				sed -e "s/\([^[:alnum:]]\)${feat}=[0-9]*/\1${feat}=${feat_state}/g")"
+		else
+			# Add it to our list of new mkfs flags
+			m_opts="${feat}=${feat_state},${m_opts}"
+		fi
+	done
+
+	test -n "$m_opts" && m_opts=" -m $m_opts"
+
+	echo "$caller_options$m_opts"
+}
+
+# Log the start of an upgrade.
+function upgrade_start_message()
+{
+	local feat="$1"
+
+	echo "Add $feat to filesystem"
+}
+
+# Find dmesg log messages since we started a particular upgrade test
+function dmesg_since_feature_upgrade_start()
+{
+	local feat_logmsg="$(upgrade_start_message "$1")"
+
+	# search the dmesg log of last run of $seqnum for possible failures
+	# use sed \cregexpc address type, since $seqnum contains "/"
+	dmesg | \
+		tac | \
+		sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
+		sed -ne "0,\#${feat_logmsg}#p" | \
+		tac
+}
+
+# Did the mount fail because this feature is not supported?
+function feature_unsupported()
+{
+	local feat="$1"
+
+	dmesg_since_feature_upgrade_start "$feat" | \
+		grep -q 'has unknown.*features'
+}
+
+# Exercise the scratch fs
+function scratch_fsstress()
+{
+	echo moo > $SCRATCH_MNT/sample.txt
+	$FSSTRESS_PROG -n $((TIME_FACTOR * 1000)) -p $((LOAD_FACTOR * 4)) \
+		-d $SCRATCH_MNT/data >> $seqres.full
+}
+
+# Exercise the filesystem a little bit and emit a manifest.
+function pre_exercise()
+{
+	local feat="$1"
+
+	_try_scratch_mount &> $tmp.mount
+	res=$?
+	# If the kernel doesn't support the filesystem even after a
+	# fresh format, skip the rest of the upgrade test quietly.
+	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
+		echo "mount failed due to unsupported feature $feat" >> $seqres.full
+		return 1
+	fi
+	if [ $res -ne 0 ]; then
+		cat $tmp.mount
+		echo "mount failed with $res before upgrading to $feat" | \
+			tee -a $seqres.full
+		return 1
+	fi
+
+	scratch_fsstress
+	find $SCRATCH_MNT -type f -print0 | xargs -r -0 md5sum > $tmp.manifest
+	_scratch_unmount
+	return 0
+}
+
+# Check the manifest and exercise the filesystem more
+function post_exercise()
+{
+	local feat="$1"
+
+	_try_scratch_mount &> $tmp.mount
+	res=$?
+	# If the kernel doesn't support the filesystem even after a
+	# fresh format, skip the rest of the upgrade test quietly.
+	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
+		echo "mount failed due to unsupported feature $feat" >> $seqres.full
+		return 1
+	fi
+	if [ $res -ne 0 ]; then
+		cat $tmp.mount
+		echo "mount failed with $res after upgrading to $feat" | \
+			tee -a $seqres.full
+		return 1
+	fi
+
+	md5sum --quiet -c $tmp.manifest || \
+		echo "fs contents ^^^ changed after adding $feat"
+
+	iam="check" _check_scratch_fs || \
+		echo "scratch fs check failed after adding $feat"
+
+	# Try to mount the fs in case the check unmounted it
+	_try_scratch_mount &>> $seqres.full
+
+	scratch_fsstress
+
+	iam="check" _check_scratch_fs || \
+		echo "scratch fs check failed after exercising $feat"
+
+	# Try to unmount the fs in case the check didn't
+	_scratch_unmount &>> $seqres.full
+	return 0
+}
+
+# Create a list of fs features in the order that support for them was added
+# to the kernel driver.  For each feature upgrade test, we enable all the
+# features that came before it and none of the ones after, which means we're
+# testing incremental migrations.  We start each run with a clean fs so that
+# errors and unsatisfied requirements (log size, root ino position, etc) in one
+# upgrade don't spread failure to the rest of the tests.
+FEATURES=()
+if rt_configured; then
+	check_repair_upgrade finobt && FEATURES+=("finobt")
+	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
+	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+else
+	check_repair_upgrade finobt && FEATURES+=("finobt")
+	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
+	check_repair_upgrade reflink && FEATURES+=("reflink")
+	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
+	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+fi
+
+test "${#FEATURES[@]}" -eq 0 && \
+	_notrun "xfs_repair does not know how to add V5 features"
+
+declare -A FEATURE_STATE
+for f in "${FEATURES[@]}"; do
+	FEATURE_STATE["$f"]=0
+done
+
+for feat in "${FEATURES[@]}"; do
+	echo "-----------------------" >> $seqres.full
+
+	upgrade_start_message "$feat" | tee -a $seqres.full /dev/ttyprintk > /dev/null
+
+	opts="$(compute_mkfs_options)"
+	echo "mkfs.xfs $opts" >> $seqres.full
+
+	# Format filesystem
+	MKFS_OPTIONS="$opts" _scratch_mkfs &>> $seqres.full
+	res=$?
+	outcome="mkfs returns $res for $feat upgrade test"
+	echo "$outcome" >> $seqres.full
+	if [ $res -ne 0 ]; then
+		echo "$outcome"
+		continue
+	fi
+
+	# Create some files to make things interesting.
+	pre_exercise "$feat" || break
+
+	# Upgrade the fs
+	_scratch_xfs_repair -c "${feat}=1" &> $tmp.upgrade
+	res=$?
+	cat $tmp.upgrade >> $seqres.full
+	grep -q "^Adding" $tmp.upgrade || \
+		echo "xfs_repair ignored command to add $feat"
+
+	outcome="xfs_repair returns $res while adding $feat"
+	echo "$outcome" >> $seqres.full
+	if [ $res -ne 0 ]; then
+		# Couldn't upgrade filesystem, move on to the next feature.
+		FEATURE_STATE["$feat"]=1
+		continue
+	fi
+
+	# Make sure repair runs cleanly afterwards
+	_scratch_xfs_repair -n &>> $seqres.full
+	res=$?
+	outcome="xfs_repair -n returns $res after adding $feat"
+	echo "$outcome" >> $seqres.full
+	if [ $res -ne 0 ]; then
+		echo "$outcome"
+	fi
+
+	# Make sure we can still exercise the filesystem.
+	post_exercise "$feat" || break
+
+	# Update feature state for next run
+	FEATURE_STATE["$feat"]=1
+done
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/769.out b/tests/xfs/769.out
new file mode 100644
index 0000000000..332432db97
--- /dev/null
+++ b/tests/xfs/769.out
@@ -0,0 +1,2 @@
+QA output created by 769
+Silence is golden.

