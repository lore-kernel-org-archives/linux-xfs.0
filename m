Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1EBC282E7
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiHIVBa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiHIVBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:01:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DAC2CDEC;
        Tue,  9 Aug 2022 14:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E910860A71;
        Tue,  9 Aug 2022 21:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51394C433C1;
        Tue,  9 Aug 2022 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660078867;
        bh=Hy5N6lqUOMaw+qFEPvWmXo3WWDIpgSj+uBRUm++kWQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mmz533GSKdfBRTUZuTeYwawe4IN5dpxCM0ndvLts/qe3FAz0Z0OAmEMzj+/WrCn4k
         ztyOL7bM5OaLFP6ZlNbTWSyb4/z5piOs9joRAhVtFneDyNopcW6WF0Ju/eT9Liiu7L
         BT59VR+9/5g+maFjQgo0kAk5NBJ1Iis72cTd84RnoCXxrhkdcq+mMbhvDCzu4FuFK8
         wPuePLhtCX1R9lFIWnyxqVa37ZHIgeFISY+tAEq2HnmpNh09M6uW1iFNyTfHvOrFob
         +m1f2BZc+0MUYXaeNwM1h1mS3ndI2s5/zuccEzE2yUU1hC7SOLJnftS9RCpfo5pUFa
         VRD8x8HCTjI2w==
Subject: [PATCH 1/1] dmerror: support external log and realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 09 Aug 2022 14:01:06 -0700
Message-ID: <166007886688.3276417.391273830219043567.stgit@magnolia>
In-Reply-To: <166007886131.3276417.10030668570359997591.stgit@magnolia>
References: <166007886131.3276417.10030668570359997591.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade the dmerror code to coordinate making external scratch log and
scratch realtime devices error out along with the scratch device.  Note
that unlike SCRATCH_DEV, we save the old rt/log devices in a separate
variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper
functions continue to work properly.

This is very similar to what we did for dm-flakey a while back.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 3 files changed, 156 insertions(+), 7 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 01a4c8b5..0934d220 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -4,25 +4,88 @@
 #
 # common functions for setting up and tearing down a dmerror device
 
+_dmerror_setup_vars()
+{
+	local backing_dev="$1"
+	local tag="$2"
+	local target="$3"
+
+	test -z "$target" && target=error
+	local blk_dev_size=$(blockdev --getsz "$backing_dev")
+
+	eval export "DMLINEAR_${tag}TABLE=\"0 $blk_dev_size linear $backing_dev 0\""
+	eval export "DMERROR_${tag}TABLE=\"0 $blk_dev_size $target $backing_dev 0\""
+}
+
 _dmerror_setup()
 {
-	local dm_backing_dev=$SCRATCH_DEV
+	local rt_target=
+	local log_target=
 
-	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
+	for arg in "$@"; do
+		case "${arg}" in
+		no_rt)		rt_target=linear;;
+		no_log)		log_target=linear;;
+		*)		echo "${arg}: Unknown _dmerror_setup arg.";;
+		esac
+	done
 
+	# Scratch device
 	export DMERROR_DEV='/dev/mapper/error-test'
+	_dmerror_setup_vars $SCRATCH_DEV
 
-	export DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
+	# Realtime device.  We reassign SCRATCH_RTDEV so that all the scratch
+	# helpers continue to work unmodified.
+	if [ -n "$SCRATCH_RTDEV" ]; then
+		if [ -z "$NON_ERROR_RTDEV" ]; then
+			# Set up the device switch
+			local dm_backing_dev=$SCRATCH_RTDEV
+			export NON_ERROR_RTDEV="$SCRATCH_RTDEV"
+			SCRATCH_RTDEV='/dev/mapper/error-rttest'
+		else
+			# Already set up; recreate tables
+			local dm_backing_dev="$NON_ERROR_RTDEV"
+		fi
 
-	export DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
+		_dmerror_setup_vars $dm_backing_dev RT $rt_target
+	fi
+
+	# External log device.  We reassign SCRATCH_LOGDEV so that all the
+	# scratch helpers continue to work unmodified.
+	if [ -n "$SCRATCH_LOGDEV" ]; then
+		if [ -z "$NON_ERROR_LOGDEV" ]; then
+			# Set up the device switch
+			local dm_backing_dev=$SCRATCH_LOGDEV
+			export NON_ERROR_LOGDEV="$SCRATCH_LOGDEV"
+			SCRATCH_LOGDEV='/dev/mapper/error-logtest'
+		else
+			# Already set up; recreate tables
+			local dm_backing_dev="$NON_ERROR_LOGDEV"
+		fi
+
+		_dmerror_setup_vars $dm_backing_dev LOG $log_target
+	fi
 }
 
 _dmerror_init()
 {
-	_dmerror_setup
+	_dmerror_setup "$@"
+
 	_dmsetup_remove error-test
 	_dmsetup_create error-test --table "$DMLINEAR_TABLE" || \
 		_fatal "failed to create dm linear device"
+
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		_dmsetup_remove error-rttest
+		_dmsetup_create error-rttest --table "$DMLINEAR_RTTABLE" || \
+			_fatal "failed to create dm linear rt device"
+	fi
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		_dmsetup_remove error-logtest
+		_dmsetup_create error-logtest --table "$DMLINEAR_LOGTABLE" || \
+			_fatal "failed to create dm linear log device"
+	fi
 }
 
 _dmerror_mount()
@@ -39,11 +102,27 @@ _dmerror_unmount()
 
 _dmerror_cleanup()
 {
+	test -n "$NON_ERROR_LOGDEV" && $DMSETUP_PROG resume error-logtest &>/dev/null
+	test -n "$NON_ERROR_RTDEV" && $DMSETUP_PROG resume error-rttest &>/dev/null
 	$DMSETUP_PROG resume error-test > /dev/null 2>&1
+
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+
+	test -n "$NON_ERROR_LOGDEV" && _dmsetup_remove error-logtest
+	test -n "$NON_ERROR_RTDEV" && _dmsetup_remove error-rttest
 	_dmsetup_remove error-test
 
 	unset DMERROR_DEV DMLINEAR_TABLE DMERROR_TABLE
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
+		unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
+	fi
+
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		SCRATCH_RTDEV="$NON_ERROR_RTDEV"
+		unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
+	fi
 }
 
 _dmerror_load_error_table()
@@ -59,12 +138,47 @@ _dmerror_load_error_table()
 		suspend_opt="$*"
 	fi
 
+	# Suspend the scratch device before the log and realtime devices so
+	# that the kernel can freeze and flush the filesystem if the caller
+	# wanted a freeze.
 	$DMSETUP_PROG suspend $suspend_opt error-test
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt error-rttest
+		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
+	fi
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt error-logtest
+		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
+	fi
+
+	# Load new table
 	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
 	load_res=$?
 
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
+		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
+	fi
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
+		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
+	fi
+
+	# Resume devices in the opposite order that we suspended them.
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG resume error-logtest
+		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
+	fi
+
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG resume error-rttest
+		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
+	fi
+
 	$DMSETUP_PROG resume error-test
 	resume_res=$?
 
@@ -85,12 +199,47 @@ _dmerror_load_working_table()
 		suspend_opt="$*"
 	fi
 
+	# Suspend the scratch device before the log and realtime devices so
+	# that the kernel can freeze and flush the filesystem if the caller
+	# wanted a freeze.
 	$DMSETUP_PROG suspend $suspend_opt error-test
 	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
 
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt error-rttest
+		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
+	fi
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt error-logtest
+		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
+	fi
+
+	# Load new table
 	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
 	load_res=$?
 
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG load error-rttest --table "$DMLINEAR_RTTABLE"
+		[ $? -ne 0 ] && _fail "failed to load working table into error-rttest"
+	fi
+
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG load error-logtest --table "$DMLINEAR_LOGTABLE"
+		[ $? -ne 0 ] && _fail "failed to load working table into error-logtest"
+	fi
+
+	# Resume devices in the opposite order that we suspended them.
+	if [ -n "$NON_ERROR_LOGDEV" ]; then
+		$DMSETUP_PROG resume error-logtest
+		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
+	fi
+
+	if [ -n "$NON_ERROR_RTDEV" ]; then
+		$DMSETUP_PROG resume error-rttest
+		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
+	fi
+
 	$DMSETUP_PROG resume error-test
 	resume_res=$?
 
diff --git a/tests/generic/441 b/tests/generic/441
index 0ec751da..85f29a3a 100755
--- a/tests/generic/441
+++ b/tests/generic/441
@@ -52,7 +52,7 @@ unset SCRATCH_RTDEV
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
-_dmerror_init
+_dmerror_init no_log
 _dmerror_mount
 
 _require_fs_space $SCRATCH_MNT 65536
diff --git a/tests/generic/487 b/tests/generic/487
index fda8828d..3c9b2233 100755
--- a/tests/generic/487
+++ b/tests/generic/487
@@ -45,7 +45,7 @@ unset SCRATCH_RTDEV
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
-_dmerror_init
+_dmerror_init no_log
 _dmerror_mount
 
 datalen=65536

