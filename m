Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038B3C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiLaAjs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:39:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302421E3FE;
        Fri, 30 Dec 2022 16:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD91FB81E49;
        Sat, 31 Dec 2022 00:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE41C433EF;
        Sat, 31 Dec 2022 00:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447183;
        bh=pQq4B40v4RhHW7cz7BJ0dBjlQZsjXNE87BVyendgV24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ADHXVMBq+odZH7IhRl2pBlYNt25PAfU8854sb4YVqmp5rO2MXCpeqjSlWHmj144Qc
         m5tRPOp5HFPNKdWT1jw3dx4elvb0/Uk4fuw9n3qr4C+Z4LYFbpa/C3++XoShJBOewj
         /lGJBgcHEIe1J1FgxwT3BcbbR5LTZHs8IY9C2ALnhbsgSWAgEOoWLOxFzAGkq8JWkv
         YXOCQ02aQC9NIvNKdPpB+qrleu0TvuXghWTJb2sNhysdWLWubFvXFCfO400X5EgOtc
         MFzZpm8HZgdYP8KU47w6NKqKea3fMGxqVMdvdrszYGjeD3EXhIWDDWrwbw1ruk451Q
         a+HgkR2Irzmsw==
Subject: [PATCH 4/5] fuzzy: allow xfs scrub stress tests to pick preconfigured
 fsstress configs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:06 -0800
Message-ID: <167243874662.722028.15090629914232187990.stgit@magnolia>
In-Reply-To: <167243874614.722028.11987534226186856347.stgit@magnolia>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that xfs_scrub stress tests can select what kind of fsstress
operations they want to run.  This will make it easier for, say,
directory scrubbers to configure fsstress to exercise directory tree
changes while skipping file data updates, because those are irrelevant.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 3 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e39f787e78..c4a5bc9261 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -466,6 +466,7 @@ __stress_scrub_fsx_loop() {
 	local end="$1"
 	local runningfile="$2"
 	local remount_period="$3"
+	local stress_tgt="$4"	# ignored
 	local focus=(-q -X)	# quiet, validate file contents
 
 	# As of November 2022, 2 million fsx ops should be enough to keep
@@ -528,10 +529,70 @@ __stress_scrub_fsstress_loop() {
 	local end="$1"
 	local runningfile="$2"
 	local remount_period="$3"
+	local stress_tgt="$4"
+	local focus=()
+
+	case "$stress_tgt" in
+	"dir")
+		focus+=('-z')
+
+		# Create a directory tree rapidly
+		for op in creat link mkdir mknod symlink; do
+			focus+=('-f' "${op}=8")
+		done
+		focus+=('-f' 'rmdir=2' '-f' 'unlink=8')
+
+		# Rename half as often
+		for op in rename rnoreplace rexchange; do
+			focus+=('-f' "${op}=4")
+		done
+
+		# Read and sync occasionally
+		for op in getdents stat fsync; do
+			focus+=('-f' "${op}=1")
+		done
+		;;
+	"xattr")
+		focus+=('-z')
+
+		# Create a directory tree slowly
+		for op in creat ; do
+			focus+=('-f' "${op}=2")
+		done
+		for op in unlink rmdir; do
+			focus+=('-f' "${op}=1")
+		done
+
+		# Create xattrs rapidly
+		for op in attr_set setfattr; do
+			focus+=('-f' "${op}=80")
+		done
+
+		# Remove xattrs 1/4 as quickly
+		for op in attr_remove removefattr; do
+			focus+=('-f' "${op}=20")
+		done
+
+		# Read and sync occasionally
+		for op in listfattr getfattr fsync; do
+			focus+=('-f' "${op}=10")
+		done
+		;;
+	"writeonly")
+		# Only do things that cause filesystem writes
+		focus+=('-w')
+		;;
+	"default")
+		# No new arguments
+		;;
+	*)
+		echo "$stress_tgt: Unrecognized stress target, using defaults."
+		;;
+	esac
 
 	# As of March 2022, 2 million fsstress ops should be enough to keep
 	# any filesystem busy for a couple of hours.
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 $FSSTRESS_AVOID)
+	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 "${focus[@]}" $FSSTRESS_AVOID)
 	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
 	if [ -n "$remount_period" ]; then
@@ -691,6 +752,14 @@ __stress_scrub_check_commands() {
 # -w	Delay the start of the scrub/repair loop by this number of seconds.
 #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
 #	will be clamped to ten seconds before the end time.
+# -x	Focus on this type of fsstress operation.  Possible values:
+#
+#       'dir': Grow the directory trees as much as possible.
+#       'xattr': Grow extended attributes in a small tree.
+#       'default': Run fsstress with default arguments.
+#       'writeonly': Only perform fs updates, no reads.
+#
+#       The default is 'default' unless XFS_SCRUB_STRESS_TARGET is set.
 # -X	Run this program to exercise the filesystem.  Currently supported
 #       options are 'fsx' and 'fsstress'.  The default is 'fsstress'.
 _scratch_xfs_stress_scrub() {
@@ -703,6 +772,7 @@ _scratch_xfs_stress_scrub() {
 	local exerciser="fsstress"
 	local io_args=()
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
+	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -710,7 +780,7 @@ _scratch_xfs_stress_scrub() {
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fi:r:s:S:t:w:X:" c; do
+	while getopts "fi:r:s:S:t:w:x:X:" c; do
 		case "$c" in
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
@@ -719,6 +789,7 @@ _scratch_xfs_stress_scrub() {
 			S) xfs_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			w) scrub_delay="$OPTARG";;
+			x) stress_tgt="$OPTARG";;
 			X) exerciser="$OPTARG";;
 			*) return 1; ;;
 		esac
@@ -757,7 +828,7 @@ _scratch_xfs_stress_scrub() {
 	fi
 
 	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" \
-			"$remount_period" &
+			"$remount_period" "$stress_tgt" &
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &

