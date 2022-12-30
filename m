Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2F4C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiL3W4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiL3W4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:56:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B806462;
        Fri, 30 Dec 2022 14:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCB54B81DA0;
        Fri, 30 Dec 2022 22:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F02C433F0;
        Fri, 30 Dec 2022 22:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440960;
        bh=0vYOWMEidKWH2xQ18ZPBL3AFF2W1dVpYtLsOLMB0KwQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O+5BsUmP+/rrY0I2zKSg277jCYvQZS/D6Z4mwPXXofouEptquCW+kDM0CWVNZ0QIh
         3KgFBkBswmt0D/2Y/vsBEYs+alTHM4nI76C5QXnYFs9+1oCaDjzwSy+DJUh5RlL2lX
         WglOAVXe0b30pxf8LBO9HeqEIHf9R5PhlpyDHaqbYb+5RVYEhMItl+J8mCyiTtLmxJ
         5SYEFLQf+jyM4iSXPwWYgJ1LuLkR8MP1WIx7doOgZ79/yjjt2xepxUWc4eoMPmOgbY
         SFW0npmZYVLJ6AWZdimlw1CAoMiSGp+clPRCVyBbZv+zwWvkjvfL5T3D9K39b/zDSl
         mncN8SSMWXqfw==
Subject: [PATCH 07/16] fuzzy: give each test local control over what scrub
 stress tests get run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837393.694541.5087918179710010888.stgit@magnolia>
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

Now that we've hoisted the scrub stress code to common/fuzzy, introduce
argument parsing so that each test can specify what they want to test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   39 +++++++++++++++++++++++++++++++++++----
 tests/xfs/422 |    2 +-
 2 files changed, 36 insertions(+), 5 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index de9e398984..88ba5fef69 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -348,12 +348,19 @@ __stress_scrub_freeze_loop() {
 	done
 }
 
-# Run xfs online fsck commands in a tight loop.
-__stress_scrub_loop() {
+# Run individual XFS online fsck commands in a tight loop with xfs_io.
+__stress_one_scrub_loop() {
 	local end="$1"
+	local scrub_tgt="$2"
+	shift; shift
+
+	local xfs_io_args=()
+	for arg in "$@"; do
+		xfs_io_args+=('-c' "$arg")
+	done
 
 	while [ "$(date +%s)" -lt $end ]; do
-		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | \
+		$XFS_IO_PROG -x "${xfs_io_args[@]}" "$scrub_tgt" 2>&1 | \
 			__stress_scrub_filter_output
 	done
 }
@@ -390,6 +397,8 @@ _require_xfs_stress_online_repair() {
 
 # Clean up after the loops in case they didn't do it themselves.
 _scratch_xfs_stress_scrub_cleanup() {
+	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
+
 	# Send SIGINT so that bash won't print a 'Terminated' message that
 	# distorts the golden output.
 	$KILLALL_PROG -INT xfs_io fsstress >> $seqres.full 2>&1
@@ -399,7 +408,25 @@ _scratch_xfs_stress_scrub_cleanup() {
 # Start scrub, freeze, and fsstress in background looping processes, and wait
 # for 30*TIME_FACTOR seconds to see if the filesystem goes down.  Callers
 # must call _scratch_xfs_stress_scrub_cleanup from their cleanup functions.
+#
+# Various options include:
+#
+# -s	Pass this command to xfs_io to test scrub.  If zero -s options are
+#	specified, xfs_io will not be run.
+# -t	Run online scrub against this file; $SCRATCH_MNT is the default.
 _scratch_xfs_stress_scrub() {
+	local one_scrub_args=()
+	local scrub_tgt="$SCRATCH_MNT"
+
+	OPTIND=1
+	while getopts "s:t:" c; do
+		case "$c" in
+			s) one_scrub_args+=("$OPTARG");;
+			t) scrub_tgt="$OPTARG";;
+			*) return 1; ;;
+		esac
+	done
+
 	local start="$(date +%s)"
 	local end="$((start + (30 * TIME_FACTOR) ))"
 
@@ -408,7 +435,11 @@ _scratch_xfs_stress_scrub() {
 
 	__stress_scrub_fsstress_loop $end &
 	__stress_scrub_freeze_loop $end &
-	__stress_scrub_loop $end &
+
+	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
+		__stress_one_scrub_loop "$end" "$scrub_tgt" \
+				"${one_scrub_args[@]}" &
+	fi
 
 	# Wait until 2 seconds after the loops should have finished, then
 	# clean up after ourselves.
diff --git a/tests/xfs/422 b/tests/xfs/422
index b3353d2202..faea5d6792 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -31,7 +31,7 @@ _require_xfs_stress_online_repair
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" rmapbt
-_scratch_xfs_stress_online_repair
+_scratch_xfs_stress_online_repair -s "repair rmapbt 0" -s "repair rmapbt 1"
 
 # success, all done
 echo Silence is golden

