Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D87C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiLaAkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiLaAku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:40:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7B111156;
        Fri, 30 Dec 2022 16:40:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AEE8B81E34;
        Sat, 31 Dec 2022 00:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4CAC433EF;
        Sat, 31 Dec 2022 00:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447245;
        bh=CB5ucChwvWshYFzRqTks/DoETHUTGwmSKltLDIU7U3I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uvWzpckasaiRGBmGW38P9nx4MvDNBZd7/ZmiePV4z4aPtsn0eOfKi25kOp/gWGcm8
         V4ftwbAp3HvpMg+i1xd6NzOTq0Ar7GSYT/7cCfeWYUspHIxYCmJGOv2nYey6bbQoaH
         V/xF7HjQKKh+sHe/nV65EjFBnFpof8ziLNVj2TALpxYuLOMIbq+4ICwDn8sAHtYkTp
         szpCi0AdI0YCNLUqntozcUYVk2rq/EK8zx6qAbjr5raApsJ6GOjDm40911bHWyML0V
         t/XJ9S17zEafdGE8SeKSRJRGFHxS13kx2hVw/GWfmg0oQ3CvrNcE/rV2607ZrKbccO
         5bRFupDzQrxPA==
Subject: [PATCH 2/2] xfs: stress test ag repair functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:12 -0800
Message-ID: <167243875266.723308.11201936891324372601.stgit@magnolia>
In-Reply-To: <167243875241.723308.1395808663517469875.stgit@magnolia>
References: <167243875241.723308.1395808663517469875.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Race fsstress and various AG repair functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   38 ++++++++++++++++++++++++++------------
 tests/xfs/725     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/725.out |    2 ++
 tests/xfs/726     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/726.out |    2 ++
 tests/xfs/727     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/727.out |    2 ++
 tests/xfs/728     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/728.out |    2 ++
 tests/xfs/729     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/729.out |    2 ++
 tests/xfs/730     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/730.out |    2 ++
 tests/xfs/731     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/731.out |    2 ++
 15 files changed, 300 insertions(+), 12 deletions(-)
 create mode 100755 tests/xfs/725
 create mode 100644 tests/xfs/725.out
 create mode 100755 tests/xfs/726
 create mode 100644 tests/xfs/726.out
 create mode 100755 tests/xfs/727
 create mode 100644 tests/xfs/727.out
 create mode 100755 tests/xfs/728
 create mode 100644 tests/xfs/728.out
 create mode 100755 tests/xfs/729
 create mode 100644 tests/xfs/729.out
 create mode 100755 tests/xfs/730
 create mode 100644 tests/xfs/730.out
 create mode 100755 tests/xfs/731
 create mode 100644 tests/xfs/731.out


diff --git a/common/fuzzy b/common/fuzzy
index d8de55250d..d4177c3136 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -393,7 +393,8 @@ __stress_one_scrub_loop() {
 	local runningfile="$2"
 	local scrub_tgt="$3"
 	local scrub_startat="$4"
-	shift; shift; shift; shift
+	local start_agno="$5"
+	shift; shift; shift; shift; shift
 	local agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 
 	local xfs_io_args=()
@@ -403,7 +404,7 @@ __stress_one_scrub_loop() {
 		fi
 		if echo "$arg" | grep -q -w '%agno%'; then
 			# Substitute the AG number
-			for ((agno = 0; agno < agcount; agno++)); do
+			for ((agno = start_agno; agno < agcount; agno++)); do
 				local ag_arg="$(echo "$arg" | sed -e "s|%agno%|$agno|g")"
 				xfs_io_args+=('-c' "$ag_arg")
 			done
@@ -413,28 +414,34 @@ __stress_one_scrub_loop() {
 	done
 
 	local extra_filters=()
-	local target_cmd=(echo "$scrub_tgt")
 	case "$scrub_tgt" in
 	"%file%"|"%datafile%"|"%attrfile%")
 		extra_filters+=('No such file or directory' 'No such device or address')
-		target_cmd=(find "$SCRATCH_MNT" -print)
 		;;
 	"%dir%")
 		extra_filters+=('No such file or directory' 'Not a directory')
-		target_cmd=(find "$SCRATCH_MNT" -type d -print)
 		;;
 	"%regfile%"|"%cowfile%")
 		extra_filters+=('No such file or directory')
-		target_cmd=(find "$SCRATCH_MNT" -type f -print)
 		;;
 	esac
 
+	local target_cmd=(echo "$scrub_tgt")
+	case "$scrub_tgt" in
+	"%file%")	target_cmd=($here/src/xfsfind -q  "$SCRATCH_MNT");;
+	"%attrfile%")	target_cmd=($here/src/xfsfind -qa "$SCRATCH_MNT");;
+	"%datafile%")	target_cmd=($here/src/xfsfind -qb "$SCRATCH_MNT");;
+	"%dir%")	target_cmd=($here/src/xfsfind -qd "$SCRATCH_MNT");;
+	"%regfile%")	target_cmd=($here/src/xfsfind -qr "$SCRATCH_MNT");;
+	"%cowfile%")	target_cmd=($here/src/xfsfind -qs "$SCRATCH_MNT");;
+	esac
+
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
 		sleep 1
 	done
 
 	while __stress_scrub_running "$end" "$runningfile"; do
-		readarray -t fnames < <("${target_cmd[@]}" 2>/dev/null)
+		readarray -t fnames < <("${target_cmd[@]}" 2>> $seqres.full)
 		for fname in "${fnames[@]}"; do
 			$XFS_IO_PROG -x "${xfs_io_args[@]}" "$fname" 2>&1 | \
 				__stress_scrub_filter_output "${extra_filters[@]}"
@@ -692,6 +699,7 @@ __stress_scrub_fsstress_loop() {
 # Make sure we have everything we need to run stress and scrub
 _require_xfs_stress_scrub() {
 	_require_xfs_io_command "scrub"
+	_require_test_program "xfsfind"
 	_require_command "$KILLALL_PROG" killall
 	_require_freeze
 	command -v _filter_scratch &>/dev/null || \
@@ -769,7 +777,8 @@ _scratch_xfs_stress_scrub_cleanup() {
 # filesystem before we start running them in a loop.
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
-	shift
+	local start_agno="$2"
+	shift; shift
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -798,7 +807,7 @@ __stress_scrub_check_commands() {
 		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
 			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
 		fi
-		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/0/g")"
+		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/$start_agno/g")"
 		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
@@ -817,6 +826,7 @@ __stress_scrub_check_commands() {
 #
 # Various options include:
 #
+# -a	For %agno% substitution, start with this AG instead of AG 0.
 # -f	Run a freeze/thaw loop while we're doing other things.  Defaults to
 #	disabled, unless XFS_SCRUB_STRESS_FREEZE is set.
 # -i	Pass this command to xfs_io to exercise something that is not scrub
@@ -867,6 +877,7 @@ _scratch_xfs_stress_scrub() {
 	local io_args=()
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
+	local start_agno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -874,8 +885,9 @@ _scratch_xfs_stress_scrub() {
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "fi:r:s:S:t:w:x:X:" c; do
+	while getopts "a:fi:r:s:S:t:w:x:X:" c; do
 		case "$c" in
+			a) start_agno="$OPTARG";;
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
 			r) remount_period="$OPTARG";;
@@ -889,7 +901,8 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "${one_scrub_args[@]}"
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
 		echo "${exerciser}: Unknown fs exercise program."
@@ -936,7 +949,8 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "${one_scrub_args[@]}" &
+				"$scrub_startat" "$start_agno" \
+				"${one_scrub_args[@]}" &
 	fi
 
 	if [ "${#xfs_scrub_args[@]}" -gt 0 ]; then
diff --git a/tests/xfs/725 b/tests/xfs/725
new file mode 100755
index 0000000000..8466b4a77f
--- /dev/null
+++ b/tests/xfs/725
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 725
+#
+# Race fsstress and bnobt repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair bnobt %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/725.out b/tests/xfs/725.out
new file mode 100644
index 0000000000..128709eb38
--- /dev/null
+++ b/tests/xfs/725.out
@@ -0,0 +1,2 @@
+QA output created by 725
+Silence is golden
diff --git a/tests/xfs/726 b/tests/xfs/726
new file mode 100755
index 0000000000..4f34c69ba4
--- /dev/null
+++ b/tests/xfs/726
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 725
+#
+# Race fsstress and inobt repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair inobt %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/726.out b/tests/xfs/726.out
new file mode 100644
index 0000000000..40767062d2
--- /dev/null
+++ b/tests/xfs/726.out
@@ -0,0 +1,2 @@
+QA output created by 726
+Silence is golden
diff --git a/tests/xfs/727 b/tests/xfs/727
new file mode 100755
index 0000000000..d16bb3ece2
--- /dev/null
+++ b/tests/xfs/727
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 725
+#
+# Race fsstress and refcountbt repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_scratch_xfs_stress_online_repair -s "repair refcountbt %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/727.out b/tests/xfs/727.out
new file mode 100644
index 0000000000..2de2b4b2ce
--- /dev/null
+++ b/tests/xfs/727.out
@@ -0,0 +1,2 @@
+QA output created by 727
+Silence is golden
diff --git a/tests/xfs/728 b/tests/xfs/728
new file mode 100755
index 0000000000..f0dd536d49
--- /dev/null
+++ b/tests/xfs/728
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 728
+#
+# Race fsstress and superblock repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -a 1 -s "repair sb %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/728.out b/tests/xfs/728.out
new file mode 100644
index 0000000000..ab39f45fe5
--- /dev/null
+++ b/tests/xfs/728.out
@@ -0,0 +1,2 @@
+QA output created by 728
+Silence is golden
diff --git a/tests/xfs/729 b/tests/xfs/729
new file mode 100755
index 0000000000..85d53b5f0b
--- /dev/null
+++ b/tests/xfs/729
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 729
+#
+# Race fsstress and agf repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair agf %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/729.out b/tests/xfs/729.out
new file mode 100644
index 0000000000..0f175ae2f9
--- /dev/null
+++ b/tests/xfs/729.out
@@ -0,0 +1,2 @@
+QA output created by 729
+Silence is golden
diff --git a/tests/xfs/730 b/tests/xfs/730
new file mode 100755
index 0000000000..a452016bb1
--- /dev/null
+++ b/tests/xfs/730
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 730
+#
+# Race fsstress and agfl repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair agfl %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/730.out b/tests/xfs/730.out
new file mode 100644
index 0000000000..50c3c832f0
--- /dev/null
+++ b/tests/xfs/730.out
@@ -0,0 +1,2 @@
+QA output created by 730
+Silence is golden
diff --git a/tests/xfs/731 b/tests/xfs/731
new file mode 100755
index 0000000000..7d0492a10d
--- /dev/null
+++ b/tests/xfs/731
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 731
+#
+# Race fsstress and agi repair for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -s "repair agi %agno%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/731.out b/tests/xfs/731.out
new file mode 100644
index 0000000000..93b1b2692d
--- /dev/null
+++ b/tests/xfs/731.out
@@ -0,0 +1,2 @@
+QA output created by 731
+Silence is golden

