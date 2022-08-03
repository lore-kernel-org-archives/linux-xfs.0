Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F463C19F2A
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiHCEWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiHCEWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8BB550A8;
        Tue,  2 Aug 2022 21:22:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFF6B82188;
        Wed,  3 Aug 2022 04:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A542DC433C1;
        Wed,  3 Aug 2022 04:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500526;
        bh=Hy5N6lqUOMaw+qFEPvWmXo3WWDIpgSj+uBRUm++kWQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uS1GEtrMDYQlsTaLJmowhwljjpnLXumWHyduPCkxwx5mw4ZaRhLUXmUt/EPKZSvQG
         NCgKCoxAT/xl++d1FlMuWCeY55qfyBC1KWBtlZ0LPvAhJ0DrZ5GnVIVp/SUWOXz+VX
         O+ojqPrCc2JMX476MjbI+Tzsut0g2EvisfBqonr5uT5Slu0MBnsVoY3mtGNSpVuhyM
         jW9g7BSjGgJQD0H8ilD61ej3MSnmjYlTUWwCfMfkwllkz+7Ey2NM2AbYRDniCWMngF
         8ptqwaTMkw7MeK3pDF6ONxnR3suV+jr9gEaFE4NAyERfrF2nOei5qt38hCdVITNE6B
         VEvmo5SEZ6AMA==
Subject: [PATCH 1/1] dmerror: support external log and realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 02 Aug 2022 21:22:06 -0700
Message-ID: <165950052625.199065.3562501811639128335.stgit@magnolia>
In-Reply-To: <165950052067.199065.15026954987755102109.stgit@magnolia>
References: <165950052067.199065.15026954987755102109.stgit@magnolia>
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

