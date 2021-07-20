Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7483FC07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A62D6113B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381510AbhGTAbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381242AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B0361175;
        Tue, 20 Jul 2021 01:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743359;
        bh=+s9/DuENmuXRY7J2ilXWdgs3s2ehFml9rnPwk5EmVr0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KFjtLHRTtEKrUlbpVU0gJz5ACNWTpgXrJEyTICTjWWXP1XOXFjygIRibeiB6toS2E
         WNf2sP/UXnVQOpxFHJP6Vz6IGBqnzkYzH/TDAse6p9EeD0c0XgklNCZTu9GfFMcHJ8
         kg42mRLJnB7vyw+79boO0U/JsCjxJfQ1rsHJ8d3C0k7T35QAYpXegxYxnxiJd/nyV3
         1N/qXQ4UyQgBdyDmTjK+Y/F++tovFvKsTEJ417C29ya/zlWF60buuRZg8Qoo2BGF1o
         q8MnG2/ua6BXKAcupy5Y8fmPR+4IMPcq2FuoTxTzqwEXy3Hw0/6uFRwxtu0xFF+VTU
         DctykUKVxYVvA==
Subject: [PATCH 3/3] dmflakey: support external log and realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu
Date:   Mon, 19 Jul 2021 18:09:19 -0700
Message-ID: <162674335915.2651055.17005305530614106697.stgit@magnolia>
In-Reply-To: <162674334277.2651055.14927938006488444114.stgit@magnolia>
References: <162674334277.2651055.14927938006488444114.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmerror    |  186 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 3 files changed, 178 insertions(+), 12 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 7f6800c0..03f3fd97 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -4,30 +4,94 @@
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
+	local linear_target=
 
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
 {
 	_scratch_options mount
+
 	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
 		$DMERROR_DEV $SCRATCH_MNT
 }
@@ -39,11 +103,23 @@ _dmerror_unmount()
 
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
+	SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
+	unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
+
+	SCRATCH_RTDEV="$NON_ERROR_RTDEV"
+	unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
 }
 
 _dmerror_load_error_table()
@@ -59,12 +135,47 @@ _dmerror_load_error_table()
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
 	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
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
 
@@ -85,12 +196,47 @@ _dmerror_load_working_table()
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
 
@@ -157,20 +303,36 @@ __dmerror_recreate_map()
 # Update the dm error table so that the range (start, len) maps to the
 # preferred dm target, overriding anything that maps to the implied dm target.
 # This assumes that the only desired targets for this dm device are the
-# preferred and and implied targets.
+# preferred and and implied targets.  The fifth argument is the scratch device
+# that we want to change the table for.
 __dmerror_change()
 {
 	local start="$1"
 	local len="$2"
 	local preferred_tgt="$3"
 	local implied_tgt="$4"
+	local whichdev="$5"
+	test -z "$whichdev" && whichdev="$SCRATCH_DEV"
 
-	DMERROR_TABLE="$( (echo "$DMERROR_TABLE"; echo "$start $len $preferred_tgt") | \
+	case "$whichdev" in
+	"$SCRATCH_DEV")		old_table="$DMERROR_TABLE";;
+	"$NON_ERROR_LOGDEV")	old_table="$DMERROR_LOGTABLE";;
+	"$NON_ERROR_RTDEV")	old_table="$DMERROR_RTTABLE";;
+	*)			echo "$whichdev: Unknown dmerror device."; return;;
+	esac
+
+	new_table="$( (echo "$old_table"; echo "$start $len $preferred_tgt") | \
 		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
 		sort -g | \
 		__dmerror_combine_extents | \
-		__dmerror_recreate_map "$SCRATCH_DEV" "$preferred_tgt" \
+		__dmerror_recreate_map "$whichdev" "$preferred_tgt" \
 				"$implied_tgt" )"
+
+	case "$whichdev" in
+	"$SCRATCH_DEV")		DMERROR_TABLE="$new_table";;
+	"$NON_ERROR_LOGDEV")	DMERROR_LOGTABLE="$new_table";;
+	"$NON_ERROR_RTDEV")	DMERROR_RTTABLE="$new_table";;
+	esac
 }
 
 # Reset the dm error table to everything ok.  The dm device itself must be
@@ -178,6 +340,8 @@ __dmerror_change()
 _dmerror_reset_table()
 {
 	DMERROR_TABLE="$DMLINEAR_TABLE"
+	DMERROR_LOGTABLE="$DMLINEAR_LOGTABLE"
+	DMERROR_RTTABLE="$DMLINEAR_RTTABLE"
 }
 
 # Update the dm error table so that IOs to the given range will return EIO.
@@ -186,8 +350,9 @@ _dmerror_mark_range_bad()
 {
 	local start="$1"
 	local len="$2"
+	local dev="$3"
 
-	__dmerror_change "$start" "$len" error linear
+	__dmerror_change "$start" "$len" error linear "$dev"
 }
 
 # Update the dm error table so that IOs to the given range will succeed.
@@ -196,6 +361,7 @@ _dmerror_mark_range_good()
 {
 	local start="$1"
 	local len="$2"
+	local dev="$3"
 
-	__dmerror_change "$start" "$len" linear error
+	__dmerror_change "$start" "$len" linear error "$dev"
 }
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

