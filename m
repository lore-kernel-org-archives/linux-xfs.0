Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A370C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiL3W5h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiL3W5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:57:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F21CB3F;
        Fri, 30 Dec 2022 14:57:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18C5161C16;
        Fri, 30 Dec 2022 22:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7214FC433D2;
        Fri, 30 Dec 2022 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441054;
        bh=4tKDUK0K0HxPCY3EkqtsA2OGOFvXBLo51hAlhJealJ4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EIeIRkCdP/18NRR+Sj8iYI9VQ87m9zJg/WgOciXoW/X0o8Zqh8jQjyzipAjzotnMX
         6YiqFpftcnCB0ixSRTQlKqzBD0AF28k/Tm1OOBvt8Nyq5bAok+l9xGK7q0buIIJpN3
         dZuBeu3YhedxsLPSgRpMz6Eck5QCFKES2MrwckDo8/h9q8QH7klh4HVI6+X9xEFyAc
         umjZeOonYX7wpdm+w44H3dT/8t6MOjYiv8r4cBBe00OwMj5tHRPk0xme+7HZG9XC/m
         fdzHbwYtZfvUPZANGdNSz2Zhf+LAOSDxPTVWiClf61/HwHFiOnf1jvUjroZ0S8w++Q
         +DD+IgRvQEEQQ==
Subject: [PATCH 13/16] fuzzy: clean up frozen fses after scrub stress testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837474.694541.10883151107803003382.stgit@magnolia>
In-Reply-To: <167243837296.694541.13203497631389630964.stgit@magnolia>
References: <167243837296.694541.13203497631389630964.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some of our scrub stress tests involve racing scrub, fsstress, and a
program that repeatedly freeze and thaws the scratch filesystem.  The
current cleanup code suffers from the deficiency that it doesn't
actually wait for the child processes to exit.  First, change it to do
that.

However, that exposes a second problem: there's a race condition with a
freezer process that leads to the stress test exiting with a frozen fs.
If the freezer process is blocked trying to acquire the unmount or
sb_write locks, the receipt of a signal (even a fatal one) doesn't cause
it to abort the freeze.  This causes further problems with fstests,
since ./check doesn't expect to regain control with the scratch fs
frozen.

Fix both problems by making the cleanup function smarter.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 3e23edc9e4..0f6fc91b80 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -439,8 +439,39 @@ _scratch_xfs_stress_scrub_cleanup() {
 
 	# Send SIGINT so that bash won't print a 'Terminated' message that
 	# distorts the golden output.
+	echo "Killing stressor processes at $(date)" >> $seqres.full
 	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
-	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
+
+	# Tests are not allowed to exit with the scratch fs frozen.  If we
+	# started a fs freeze/thaw background loop, wait for that loop to exit
+	# and then thaw the filesystem.  Cleanup for the freeze loop must be
+	# performed prior to waiting for the other children to avoid triggering
+	# a race condition that can hang fstests.
+	#
+	# If the xfs_io -c freeze process is asleep waiting for a write lock on
+	# s_umount or sb_write when the killall signal is delivered, it will
+	# not check for pending signals until after it has frozen the fs.  If
+	# even one thread of the stress test processes (xfs_io, fsstress, etc.)
+	# is waiting for read locks on sb_write when the killall signals are
+	# delivered, they will block in the kernel until someone thaws the fs,
+	# and the `wait' below will wait forever.
+	#
+	# Hence we issue the killall, wait for the freezer loop to exit, thaw
+	# the filesystem, and wait for the rest of the children.
+	if [ -n "$__SCRUB_STRESS_FREEZE_PID" ]; then
+		echo "Waiting for fs freezer $__SCRUB_STRESS_FREEZE_PID to exit at $(date)" >> $seqres.full
+		wait "$__SCRUB_STRESS_FREEZE_PID"
+
+		echo "Thawing filesystem at $(date)" >> $seqres.full
+		$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
+		__SCRUB_STRESS_FREEZE_PID=""
+	fi
+
+	# Wait for the remaining children to exit.
+	echo "Waiting for children to exit at $(date)" >> $seqres.full
+	wait
+
+	echo "Cleanup finished at $(date)" >> $seqres.full
 }
 
 # Make sure the provided scrub/repair commands actually work on the scratch
@@ -476,6 +507,7 @@ _scratch_xfs_stress_scrub() {
 	local scrub_tgt="$SCRATCH_MNT"
 	local runningfile="$tmp.fsstress"
 
+	__SCRUB_STRESS_FREEZE_PID=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
@@ -498,6 +530,7 @@ _scratch_xfs_stress_scrub() {
 
 	__stress_scrub_fsstress_loop "$end" "$runningfile" &
 	__stress_scrub_freeze_loop "$end" "$runningfile" &
+	__SCRUB_STRESS_FREEZE_PID="$!"
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \

