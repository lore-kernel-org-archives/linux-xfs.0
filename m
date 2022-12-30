Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBF3C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiL3W63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiL3W6Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11821B9E2;
        Fri, 30 Dec 2022 14:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85E19B81DA0;
        Fri, 30 Dec 2022 22:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE6EC433D2;
        Fri, 30 Dec 2022 22:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441101;
        bh=qJOgOtApFt1FimPSiqKSnn6aglt4aNYat6b7oUOZ3GM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=inYLKP5G0/nDr/CJK1kirxnuma2UNJBxxeeRUJZNu1UR1RYX5DixJks5WHxy6+H6V
         1SIl1QltY5SpBJVWvChX3CmPIvVScKQcI3tPvIIQbGDhcZxo31Mb9FCFfBOwVYk5cf
         VcvizWv3lFS1GkOh7KYmZLGfJprgfWBDvdygOxOtou0M0VqgIqRLR/PwP9k+PjJ3op
         Kw4uuAvoIXo/dmsc5mCrzSKXKCNmj1IDttzY7LjWcC0PzVc6pcMAw5C+z2kMZrpMCg
         Wbs8LWZGOxxP9HjINWV3LTGEFAk+9qwKQfW/5n3rXHOs2BufDiS3jKAtrhzDSpfbet
         w3CJQdvCglF0w==
Subject: [PATCH 16/16] fuzzy: delay the start of the scrub loop when
 stress-testing scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:55 -0800
Message-ID: <167243837514.694541.17252818873640821069.stgit@magnolia>
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

By default, online fsck stress testing kicks off the loops for fsstress
and online fsck at the same time.  However, in certain debugging
scenarios it can help if we let fsstress get a head-start in filling up
the filesystem.  Plumb in a means to delay the start of the scrub loop.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e42e2ccec1..1df51a6dd8 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -367,7 +367,8 @@ __stress_one_scrub_loop() {
 	local end="$1"
 	local runningfile="$2"
 	local scrub_tgt="$3"
-	shift; shift; shift
+	local scrub_startat="$4"
+	shift; shift; shift; shift
 	local agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 
 	local xfs_io_args=()
@@ -383,6 +384,10 @@ __stress_one_scrub_loop() {
 		fi
 	done
 
+	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
+		sleep 1
+	done
+
 	while __stress_scrub_running "$end" "$runningfile"; do
 		$XFS_IO_PROG -x "${xfs_io_args[@]}" "$scrub_tgt" 2>&1 | \
 			__stress_scrub_filter_output
@@ -514,22 +519,27 @@ __stress_scrub_check_commands() {
 # -s	Pass this command to xfs_io to test scrub.  If zero -s options are
 #	specified, xfs_io will not be run.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
+# -w	Delay the start of the scrub/repair loop by this number of seconds.
+#	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
+#	will be clamped to ten seconds before the end time.
 _scratch_xfs_stress_scrub() {
 	local one_scrub_args=()
 	local scrub_tgt="$SCRATCH_MNT"
 	local runningfile="$tmp.fsstress"
 	local freeze="${XFS_SCRUB_STRESS_FREEZE}"
+	local scrub_delay="${XFS_SCRUB_STRESS_DELAY:--1}"
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fs:t:" c; do
+	while getopts "fs:t:w:" c; do
 		case "$c" in
 			f) freeze=yes;;
 			s) one_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
+			w) scrub_delay="$OPTARG";;
 			*) return 1; ;;
 		esac
 	done
@@ -538,6 +548,9 @@ _scratch_xfs_stress_scrub() {
 
 	local start="$(date +%s)"
 	local end="$((start + (30 * TIME_FACTOR) ))"
+	local scrub_startat="$((start + scrub_delay))"
+	test "$scrub_startat" -gt "$((end - 10))" &&
+		scrub_startat="$((end - 10))"
 
 	echo "Loop started at $(date --date="@${start}")," \
 		   "ending at $(date --date="@${end}")" >> $seqres.full
@@ -551,7 +564,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"${one_scrub_args[@]}" &
+				"$scrub_startat" "${one_scrub_args[@]}" &
 	fi
 
 	# Wait until the designated end time or fsstress dies, then kill all of

