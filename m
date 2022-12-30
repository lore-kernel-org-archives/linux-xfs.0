Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EABC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiL3W4g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3W4f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DF062DE;
        Fri, 30 Dec 2022 14:56:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2196FB81D95;
        Fri, 30 Dec 2022 22:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC1BC433EF;
        Fri, 30 Dec 2022 22:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440991;
        bh=bWwjLIwEhZ40D4Nf3HRtglU97HndELAaJWvbx7atFOo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ksO25vLFy20+DPGV/nZCMurP1ojfcdi35kbOFrtXB7l18KE78aEo1at5ftg1Wa1M3
         wqr2gKJvixoYwTkAybeJ1jEq8m9E0HpB80B2yCasYiBPuguutwlIdWPxnFRh9D1fDJ
         XfN0ujC3jzfuheDNxSNkXU5LL5wYVAGcW1BJgYU6jc7jqZYuBQaeKyaNA//o0ldrxs
         gvZ6icc87Y2YJAWknZAA3KrlTjI0CkEqJSqzmw+d9DwUcIueWHVZ4ufzC7E+bGYw1O
         4kdk+i9612tcXcTw+n2pbsY6dgObrS/dGOHuBgLw6vzm2FA9XKt5RD8q9ykWVv4GXm
         X4K1DoSuod81A==
Subject: [PATCH 09/16] fuzzy: make scrub stress loop control more robust
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:54 -0800
Message-ID: <167243837420.694541.15959759084869220605.stgit@magnolia>
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

Currently, each of the scrub stress testing background threads
open-codes logic to decide if it should exit the loop.  This decision is
based entirely on TIME_FACTOR*30 seconds having gone by, which means
that we ignore external factors, such as the user pressing ^C, which (in
theory) will invoke cleanup functions to tear everything down.

This is not a great user experience, so refactor the loop exit test into
a helper function and establish a sentinel file that must be present to
continue looping.  If the user presses ^C, the cleanup function will
remove the sentinel file and kill the background thread children, which
should be enough to stop everything more or less immediately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 8d3e30e32b..6519d5c1e2 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -338,11 +338,18 @@ __stress_scrub_filter_output() {
 		    -e '/No space left on device/d'
 }
 
+# Decide if we want to keep running stress tests.  The first argument is the
+# stop time, and second argument is the path to the sentinel file.
+__stress_scrub_running() {
+	test -e "$2" && test "$(date +%s)" -lt "$1"
+}
+
 # Run fs freeze and thaw in a tight loop.
 __stress_scrub_freeze_loop() {
 	local end="$1"
+	local runningfile="$2"
 
-	while [ "$(date +%s)" -lt $end ]; do
+	while __stress_scrub_running "$end" "$runningfile"; do
 		$XFS_IO_PROG -x -c 'freeze' -c 'thaw' $SCRATCH_MNT 2>&1 | \
 			__stress_freeze_filter_output
 	done
@@ -351,15 +358,16 @@ __stress_scrub_freeze_loop() {
 # Run individual XFS online fsck commands in a tight loop with xfs_io.
 __stress_one_scrub_loop() {
 	local end="$1"
-	local scrub_tgt="$2"
-	shift; shift
+	local runningfile="$2"
+	local scrub_tgt="$3"
+	shift; shift; shift
 
 	local xfs_io_args=()
 	for arg in "$@"; do
 		xfs_io_args+=('-c' "$arg")
 	done
 
-	while [ "$(date +%s)" -lt $end ]; do
+	while __stress_scrub_running "$end" "$runningfile"; do
 		$XFS_IO_PROG -x "${xfs_io_args[@]}" "$scrub_tgt" 2>&1 | \
 			__stress_scrub_filter_output
 	done
@@ -368,12 +376,16 @@ __stress_one_scrub_loop() {
 # Run fsstress while we're testing online fsck.
 __stress_scrub_fsstress_loop() {
 	local end="$1"
+	local runningfile="$2"
 
 	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
+	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
-	while [ "$(date +%s)" -lt $end ]; do
+	while __stress_scrub_running "$end" "$runningfile"; do
 		$FSSTRESS_PROG $args >> $seqres.full
+		echo "fsstress exits with $? at $(date)" >> $seqres.full
 	done
+	rm -f "$runningfile"
 }
 
 # Make sure we have everything we need to run stress and scrub
@@ -397,6 +409,7 @@ _require_xfs_stress_online_repair() {
 
 # Clean up after the loops in case they didn't do it themselves.
 _scratch_xfs_stress_scrub_cleanup() {
+	rm -f "$runningfile"
 	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
 
 	# Send SIGINT so that bash won't print a 'Terminated' message that
@@ -436,6 +449,10 @@ __stress_scrub_check_commands() {
 _scratch_xfs_stress_scrub() {
 	local one_scrub_args=()
 	local scrub_tgt="$SCRATCH_MNT"
+	local runningfile="$tmp.fsstress"
+
+	rm -f "$runningfile"
+	touch "$runningfile"
 
 	OPTIND=1
 	while getopts "s:t:" c; do
@@ -454,17 +471,17 @@ _scratch_xfs_stress_scrub() {
 	echo "Loop started at $(date --date="@${start}")," \
 		   "ending at $(date --date="@${end}")" >> $seqres.full
 
-	__stress_scrub_fsstress_loop $end &
-	__stress_scrub_freeze_loop $end &
+	__stress_scrub_fsstress_loop "$end" "$runningfile" &
+	__stress_scrub_freeze_loop "$end" "$runningfile" &
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
-		__stress_one_scrub_loop "$end" "$scrub_tgt" \
+		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
 				"${one_scrub_args[@]}" &
 	fi
 
-	# Wait until 2 seconds after the loops should have finished, then
-	# clean up after ourselves.
-	while [ "$(date +%s)" -lt $((end + 2)) ]; do
+	# Wait until the designated end time or fsstress dies, then kill all of
+	# our background processes.
+	while __stress_scrub_running "$end" "$runningfile"; do
 		sleep 1
 	done
 	_scratch_xfs_stress_scrub_cleanup

