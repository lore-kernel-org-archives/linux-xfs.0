Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A33C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbiL3W7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiL3W7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:59:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C11CFCC;
        Fri, 30 Dec 2022 14:59:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADBFEB81D95;
        Fri, 30 Dec 2022 22:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F4BC433EF;
        Fri, 30 Dec 2022 22:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441148;
        bh=K95jnkcTvrJojEMKFgZHu2wGgSwxryFalFcS779eKG8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YCX4niaOD6U2FW059jUfc1Yirkag7A9N1mVcfzgPmQJ/JMHA1n5w+e/ZYgKaCBpC7
         v0B/paHbrN0MLg2Quw94Pl3W415R27iENcVF68/efDI1UaG4P9Y9e3PWst8ugr0TBZ
         tri9vMUp0g/r78H+v8cCD5+pRfd12W32uaKF/BZMvWT9RS+cNY9MpHUPZwE1NilODA
         Ug2ePUl02K0unkUJtu8euRyrwgQe+SHoiEBypRQqED2mr+v0pSr1NqB7KR8XOJJ0+T
         YILW6lRNJoz2FpTSvXL0ejtlQPvtpiVEID8v57bEWrzcFnaozon00OC336idEYGPW1
         6JjGtAikg0njg==
Subject: [PATCH 3/3] xfs: race fsmap with readonly remounts to detect crash or
 livelock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:58 -0800
Message-ID: <167243837811.695156.1712702786946561753.stgit@magnolia>
In-Reply-To: <167243837772.695156.17793145241363597974.stgit@magnolia>
References: <167243837772.695156.17793145241363597974.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new test that races the GETFSMAP ioctl with ro/rw remounting to
make sure we don't livelock on the empty transaction that fsmap uses to
avoid deadlocking on rmap btree cycles.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ltp/fsstress.c    |   18 +++++++++-
 tests/xfs/732     |   38 +++++++++++++++++++++
 tests/xfs/732.out |    2 +
 4 files changed, 153 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/732
 create mode 100644 tests/xfs/732.out


diff --git a/common/fuzzy b/common/fuzzy
index 58e299d34b..ee97aa4298 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -429,6 +429,7 @@ __stress_scrub_clean_scratch() {
 __stress_scrub_fsx_loop() {
 	local end="$1"
 	local runningfile="$2"
+	local remount_period="$3"
 	local focus=(-q -X)	# quiet, validate file contents
 
 	# As of November 2022, 2 million fsx ops should be enough to keep
@@ -440,6 +441,43 @@ __stress_scrub_fsx_loop() {
 	local args="$FSX_AVOID ${focus[@]} ${SCRATCH_MNT}/fsx.$seq"
 	echo "Running $here/ltp/fsx $args" >> $seqres.full
 
+	if [ -n "$remount_period" ]; then
+		local mode="rw"
+		local rw_arg=""
+		while __stress_scrub_running "$end" "$runningfile"; do
+			# Need to recheck running conditions if we cleared
+			# anything.
+			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
+
+			timeout -s TERM "$remount_period" $here/ltp/fsx \
+					$args $rw_arg >> $seqres.full
+			res=$?
+			echo "$mode fsx exits with $res at $(date)" >> $seqres.full
+			if [ "$res" -ne 0 ] && [ "$res" -ne 124 ]; then
+				# Stop if fsstress returns error.  Mask off
+				# the magic code 124 because that is how the
+				# timeout(1) program communicates that we ran
+				# out of time.
+				break;
+			fi
+			if [ "$mode" = "rw" ]; then
+				mode="ro"
+				rw_arg="-t 0 -w 0 -FHzCIJBE0"
+			else
+				mode="rw"
+				rw_arg=""
+			fi
+
+			# Try remounting until we get the result we wanted
+			while ! _scratch_remount "$mode" &>/dev/null && \
+			      __stress_scrub_running "$end" "$runningfile"; do
+				sleep 0.2
+			done
+		done
+		rm -f "$runningfile"
+		return 0
+	fi
+
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
@@ -453,12 +491,50 @@ __stress_scrub_fsx_loop() {
 __stress_scrub_fsstress_loop() {
 	local end="$1"
 	local runningfile="$2"
+	local remount_period="$3"
 
 	# As of March 2022, 2 million fsstress ops should be enough to keep
 	# any filesystem busy for a couple of hours.
 	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 $FSSTRESS_AVOID)
 	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
+	if [ -n "$remount_period" ]; then
+		local mode="rw"
+		local rw_arg=""
+		while __stress_scrub_running "$end" "$runningfile"; do
+			# Need to recheck running conditions if we cleared
+			# anything.
+			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
+
+			timeout -s TERM "$remount_period" $FSSTRESS_PROG \
+					$args $rw_arg >> $seqres.full
+			res=$?
+			echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
+			if [ "$res" -ne 0 ] && [ "$res" -ne 124 ]; then
+				# Stop if fsstress returns error.  Mask off
+				# the magic code 124 because that is how the
+				# timeout(1) program communicates that we ran
+				# out of time.
+				break;
+			fi
+			if [ "$mode" = "rw" ]; then
+				mode="ro"
+				rw_arg="-R"
+			else
+				mode="rw"
+				rw_arg=""
+			fi
+
+			# Try remounting until we get the result we wanted
+			while ! _scratch_remount "$mode" &>/dev/null && \
+			      __stress_scrub_running "$end" "$runningfile"; do
+				sleep 0.2
+			done
+		done
+		rm -f "$runningfile"
+		return 0
+	fi
+
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
@@ -526,6 +602,13 @@ _scratch_xfs_stress_scrub_cleanup() {
 	echo "Waiting for children to exit at $(date)" >> $seqres.full
 	wait
 
+	# Ensure the scratch fs is also writable before we exit.
+	if [ -n "$__SCRUB_STRESS_REMOUNT_LOOP" ]; then
+		echo "Remounting rw at $(date)" >> $seqres.full
+		_scratch_remount rw >> $seqres.full 2>&1
+		__SCRUB_STRESS_REMOUNT_LOOP=""
+	fi
+
 	echo "Cleanup finished at $(date)" >> $seqres.full
 }
 
@@ -561,6 +644,9 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -r	Run fsstress for this amount of time, then remount the fs ro or rw.
+#	The default is to run fsstress continuously with no remount, unless
+#	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
 # -s	Pass this command to xfs_io to test scrub.  If zero -s options are
 #	specified, xfs_io will not be run.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
@@ -577,16 +663,19 @@ _scratch_xfs_stress_scrub() {
 	local scrub_delay="${XFS_SCRUB_STRESS_DELAY:--1}"
 	local exerciser="fsstress"
 	local io_args=()
+	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 
 	__SCRUB_STRESS_FREEZE_PID=""
+	__SCRUB_STRESS_REMOUNT_LOOP=""
 	rm -f "$runningfile"
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fi:s:t:w:X:" c; do
+	while getopts "fi:r:s:t:w:X:" c; do
 		case "$c" in
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
+			r) remount_period="$OPTARG";;
 			s) one_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
 			w) scrub_delay="$OPTARG";;
@@ -611,7 +700,12 @@ _scratch_xfs_stress_scrub() {
 	echo "Loop started at $(date --date="@${start}")," \
 		   "ending at $(date --date="@${end}")" >> $seqres.full
 
-	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" &
+	if [ -n "$remount_period" ]; then
+		__SCRUB_STRESS_REMOUNT_LOOP="1"
+	fi
+
+	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" \
+			"$remount_period" &
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b395bc4da2..10608fb554 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -426,6 +426,7 @@ int	symlink_path(const char *, pathname_t *);
 int	truncate64_path(pathname_t *, off64_t);
 int	unlink_path(pathname_t *);
 void	usage(void);
+void	read_freq(void);
 void	write_freq(void);
 void	zero_freq(void);
 void	non_btrfs_freq(const char *);
@@ -472,7 +473,7 @@ int main(int argc, char **argv)
 	xfs_error_injection_t	        err_inj;
 	struct sigaction action;
 	int		loops = 1;
-	const char	*allopts = "cd:e:f:i:l:m:M:n:o:p:rs:S:vVwx:X:zH";
+	const char	*allopts = "cd:e:f:i:l:m:M:n:o:p:rRs:S:vVwx:X:zH";
 
 	errrange = errtag = 0;
 	umask(0);
@@ -538,6 +539,9 @@ int main(int argc, char **argv)
 		case 'r':
 			namerand = 1;
 			break;
+		case 'R':
+			read_freq();
+			break;
 		case 's':
 			seed = strtoul(optarg, NULL, 0);
 			break;
@@ -1917,6 +1921,7 @@ usage(void)
 	printf("   -o logfile       specifies logfile name\n");
 	printf("   -p nproc         specifies the no. of processes (default 1)\n");
 	printf("   -r               specifies random name padding\n");
+	printf("   -R               zeros frequencies of write operations\n");
 	printf("   -s seed          specifies the seed for the random generator (default random)\n");
 	printf("   -v               specifies verbose mode\n");
 	printf("   -w               zeros frequencies of non-write operations\n");
@@ -1928,6 +1933,17 @@ usage(void)
 	printf("   -H               prints usage and exits\n");
 }
 
+void
+read_freq(void)
+{
+	opdesc_t	*p;
+
+	for (p = ops; p < ops_end; p++) {
+		if (p->iswrite)
+			p->freq = 0;
+	}
+}
+
 void
 write_freq(void)
 {
diff --git a/tests/xfs/732 b/tests/xfs/732
new file mode 100755
index 0000000000..ed6fb3c977
--- /dev/null
+++ b/tests/xfs/732
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 732
+#
+# Race GETFSMAP and ro remount for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest auto quick fsmap remount
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_xfs_stress_scrub_cleanup
+	rm -rf $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -r 5 -i 'fsmap -v'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/732.out b/tests/xfs/732.out
new file mode 100644
index 0000000000..451f82ce2d
--- /dev/null
+++ b/tests/xfs/732.out
@@ -0,0 +1,2 @@
+QA output created by 732
+Silence is golden

