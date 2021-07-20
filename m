Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC2DC636C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBD6611EF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240837AbhGTAbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381214AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7959561165;
        Tue, 20 Jul 2021 01:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743348;
        bh=HUiFOFRxHQEtwyrRshbFEsq3l4r5GCytFoaaC9NXMgI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U93NDz3E+QuRfjInFp75h5MSaEWVOJOeeCxKEDCTeM+4fWNpfugs2hcQt3QC4h1Qr
         Qms02eQ6NemmZMFEBmaVDU05b4WDfiA4aycPjQn8ZB8TK0N9tGDLEk/kW42VT7wseK
         3uLYs+PyMOPQYS6McQMhoLscBOOWuyV7DH34O+1My52Lh+MJx3mN5qcf7nsmScVQ/f
         KOHVSA3CsTJflJ4ECescexb+hriDCcGAJRqLdSlaLrmciwWAkGcrupWKSLS9k+2EZc
         jihpL12h42EsltfAgFOa3EjxGNSHHTuyVdKzO5peF23y0odpJQDcaiMh82kDWIe2y4
         r2NvErTJMugQA==
Subject: [PATCH 1/3] dmflakey: support external log and realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu
Date:   Mon, 19 Jul 2021 18:09:08 -0700
Message-ID: <162674334822.2651055.756804899535330518.stgit@magnolia>
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

Upgrade the dmflakey code to coordinate making external scratch log and
scratch realtime devices flakey along with the scratch device.  Note
that unlike SCRATCH_DEV, we save the old rt/log devices as separate
variables and replace SCRATCH_{RT,LOG}DEV so that helper functions
continue to work without modification.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/dmflakey |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 3 deletions(-)


diff --git a/common/dmflakey b/common/dmflakey
index b4e11ae9..af4371a3 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -10,6 +10,7 @@ FLAKEY_ERROR_WRITES=2
 
 _init_flakey()
 {
+	# Scratch device
 	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 	FLAKEY_DEV=/dev/mapper/flakey-test
 	FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
@@ -17,11 +18,50 @@ _init_flakey()
 	FLAKEY_TABLE_ERROR="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 error_writes"
 	_dmsetup_create flakey-test --table "$FLAKEY_TABLE" || \
 		_fatal "failed to create flakey device"
+
+	# Realtime device
+	if [ -n "$SCRATCH_RTDEV" ]; then
+		if [ -z "$NON_FLAKEY_RTDEV" ]; then
+			# Set up the device switch
+			local backing_dev="$SCRATCH_RTDEV"
+			export NON_FLAKEY_RTDEV="$SCRATCH_RTDEV"
+			SCRATCH_RTDEV=/dev/mapper/flakey-rttest
+		else
+			# Already set up; recreate tables
+			local backing_dev="$NON_FLAKEY_RTDEV"
+		fi
+		local BLK_DEV_SIZE=`blockdev --getsz $backing_dev`
+		FLAKEY_RTTABLE="0 $BLK_DEV_SIZE flakey $backing_dev 0 180 0"
+		FLAKEY_RTTABLE_DROP="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 drop_writes"
+		FLAKEY_RTTABLE_ERROR="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 error_writes"
+		_dmsetup_create flakey-rttest --table "$FLAKEY_RTTABLE" || \
+			_fatal "failed to create flakey rt device"
+	fi
+
+	# External log device
+	if [ -n "$SCRATCH_LOGDEV" ]; then
+		if [ -z "$NON_FLAKEY_LOGDEV" ]; then
+			# Set up the device switch
+			local backing_dev="$SCRATCH_LOGDEV"
+			export NON_FLAKEY_LOGDEV="$SCRATCH_LOGDEV"
+			SCRATCH_LOGDEV=/dev/mapper/flakey-logtest
+		else
+			# Already set up; recreate tables
+			local backing_dev="$NON_FLAKEY_LOGDEV"
+		fi
+		local BLK_DEV_SIZE=`blockdev --getsz $backing_dev`
+		FLAKEY_LOGTABLE="0 $BLK_DEV_SIZE flakey $backing_dev 0 180 0"
+		FLAKEY_LOGTABLE_DROP="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 drop_writes"
+		FLAKEY_LOGTABLE_ERROR="0 $BLK_DEV_SIZE flakey $backing_dev 0 0 180 1 error_writes"
+		_dmsetup_create flakey-logtest --table "$FLAKEY_LOGTABLE" || \
+			_fatal "failed to create flakey log device"
+	fi
 }
 
 _mount_flakey()
 {
 	_scratch_options mount
+
 	mount -t $FSTYP $SCRATCH_OPTIONS $MOUNT_OPTIONS $FLAKEY_DEV $SCRATCH_MNT
 }
 
@@ -34,9 +74,21 @@ _cleanup_flakey()
 {
 	# If dmsetup load fails then we need to make sure to do resume here
 	# otherwise the umount will hang
+	test -n "$NON_FLAKEY_LOGDEV" && $DMSETUP_PROG resume flakey-logtest &> /dev/null
+	test -n "$NON_FLAKEY_RTDEV" && $DMSETUP_PROG resume flakey-rttest &> /dev/null
 	$DMSETUP_PROG resume flakey-test > /dev/null 2>&1
+
 	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+
 	_dmsetup_remove flakey-test
+	test -n "$NON_FLAKEY_LOGDEV" && _dmsetup_remove flakey-logtest
+	test -n "$NON_FLAKEY_RTDEV" && _dmsetup_remove flakey-rttest
+
+	SCRATCH_LOGDEV="$NON_FLAKEY_LOGDEV"
+	unset NON_FLAKEY_LOGDEV
+
+	SCRATCH_RTDEV="$NON_FLAKEY_RTDEV"
+	unset NON_FLAKEY_RTDEV
 }
 
 # _load_flakey_table <table> [lockfs]
@@ -45,22 +97,70 @@ _cleanup_flakey()
 # table, so it simulates power failure.
 _load_flakey_table()
 {
-	table="$FLAKEY_TABLE"
-	[ $1 -eq $FLAKEY_DROP_WRITES ] && table="$FLAKEY_TABLE_DROP"
-	[ $1 -eq $FLAKEY_ERROR_WRITES ] && table="$FLAKEY_TABLE_ERROR"
+	case "$1" in
+	"$FLAKEY_DROP_WRITES")
+		table="$FLAKEY_TABLE_DROP"
+		logtable="$FLAKEY_LOGTABLE_DROP"
+		rttable="$FLAKEY_RTTABLE_DROP"
+		;;
+	"$FLAKEY_ERROR_WRITES")
+		table="$FLAKEY_TABLE_ERROR"
+		logtable="$FLAKEY_LOGTABLE_ERROR"
+		rttable="$FLAKEY_RTTABLE_ERROR"
+		;;
+	*)
+		table="$FLAKEY_TABLE"
+		logtable="$FLAKEY_LOGTABLE"
+		rttable="$FLAKEY_RTTABLE"
+		;;
+	esac
 
 	suspend_opt="--nolockfs"
 	[ $# -gt 1 ] && [ $2 -eq 1 ] && suspend_opt=""
 
+	# Suspend the scratch device before the log and realtime devices so
+	# that the kernel can freeze and flush the filesystem if the caller
+	# wanted a freeze.
 	$DMSETUP_PROG suspend $suspend_opt flakey-test
 	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"
 
+	if [ -n "$NON_FLAKEY_RTDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt flakey-rttest
+		[ $? -ne 0 ] && _fatal "failed to suspend flakey-rttest"
+	fi
+
+	if [ -n "$NON_FLAKEY_LOGDEV" ]; then
+		$DMSETUP_PROG suspend $suspend_opt flakey-logtest
+		[ $? -ne 0 ] && _fatal "failed to suspend flakey-logtest"
+	fi
+
 	# There may be multiple dm targets in the table, and these dm targets
 	# will be joined by the newline ("\n"). Option --table can not cope with
 	# the multiple-targets case, so get them by reading from standard input.
 	echo -e "$table" | $DMSETUP_PROG load flakey-test
 	[ $? -ne 0 ] && _fatal "failed to load table into flakey-test"
 
+	if [ -n "$NON_FLAKEY_RTDEV" ]; then
+		echo -e "$rttable" | $DMSETUP_PROG load flakey-rttest
+		[ $? -ne 0 ] && _fatal "failed to load table into flakey-rttest"
+	fi
+
+	if [ -n "$NON_FLAKEY_LOGDEV" ]; then
+		echo -e "$logtable" | $DMSETUP_PROG load flakey-logtest
+		[ $? -ne 0 ] && _fatal "failed to load table into flakey-logtest"
+	fi
+
+	# Resume devices in the opposite order that we suspended them.
+	if [ -n "$NON_FLAKEY_LOGDEV" ]; then
+		$DMSETUP_PROG resume flakey-logtest
+		[ $? -ne 0 ] && _fatal  "failed to resume flakey-logtest"
+	fi
+
+	if [ -n "$NON_FLAKEY_RTDEV" ]; then
+		$DMSETUP_PROG resume flakey-rttest
+		[ $? -ne 0 ] && _fatal  "failed to resume flakey-rttest"
+	fi
+
 	$DMSETUP_PROG resume flakey-test
 	[ $? -ne 0 ] && _fatal  "failed to resume flakey-test"
 }

