Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9C1C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiLaDMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:12:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9408E59;
        Fri, 30 Dec 2022 19:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE722CE19E1;
        Sat, 31 Dec 2022 03:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB9FC433EF;
        Sat, 31 Dec 2022 03:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456355;
        bh=yIOVrk9FdagjHi6nbuoTErS4wGnNXWfvoJ3gGIixoqE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QwLMMnNQBdy5c247TaRbmPQbLh8o2VbqyRHRs7oU3hF6zAMQ25JXgU3616nd8AjwZ
         bi+Ha4CkWh3b0a3DpBOgYOWUfdp9BiM/G3TjIthN3dCPY8Y18h1rq4E8P+4yiA4/vN
         ky0MFOdgZA9T42hebNbmOECxxsyLZ45th1fczvRcEEj3U4JSklPlojh/a74XPJFj8Y
         Ih6b45ZLyk6KP/+Hhow4H/O/HtlJ7TuxhtuyKmObALktjTvRVoH5Ybb0srM8mRf37c
         s0evuTzxmaCr+UVZcev5Mx/2CKUJVHYuQrtBolDip0pOlhnJpL91D9pyMEYdCy4Jpz
         ZmBG5UllxQ+Hg==
Subject: [PATCH 12/12] common/fuzzy: adapt the scrub stress tests to support
 rtgroups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:41 -0800
Message-ID: <167243884102.739029.3905413777900442709.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adapt the scrub stress testing framework to support checking realtime
group metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   27 ++++++++++++++++++++++-----
 common/xfs    |    9 +++++++++
 tests/xfs/800 |    2 +-
 tests/xfs/840 |    2 +-
 tests/xfs/841 |    2 +-
 5 files changed, 34 insertions(+), 8 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 7f96384402..baba05de0a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -817,8 +817,10 @@ __stress_one_scrub_loop() {
 	local scrub_tgt="$3"
 	local scrub_startat="$4"
 	local start_agno="$5"
-	shift; shift; shift; shift; shift
+	local start_rgno="$6"
+	shift; shift; shift; shift; shift; shift
 	local agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local xfs_io_args=()
 	for arg in "$@"; do
@@ -831,6 +833,12 @@ __stress_one_scrub_loop() {
 				local ag_arg="$(echo "$arg" | sed -e "s|%agno%|$agno|g")"
 				xfs_io_args+=('-c' "$ag_arg")
 			done
+		elif echo "$arg" | grep -q -w '%rgno%'; then
+			# Substitute the rtgroup number
+			for ((rgno = start_rgno; rgno < rgcount; rgno++)); do
+				local rg_arg="$(echo "$arg" | sed -e "s|%rgno%|$rgno|g")"
+				xfs_io_args+=('-c' "$rg_arg")
+			done
 		else
 			xfs_io_args+=('-c' "$arg")
 		fi
@@ -1201,7 +1209,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	local start_agno="$2"
-	shift; shift
+	local start_rgno="$3"
+	shift; shift; shift
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -1231,6 +1241,10 @@ __stress_scrub_check_commands() {
 			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
 		fi
 		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/$start_agno/g")"
+		if echo "$cooked_arg" | grep -q -w '%rgno%'; then
+			test "$rgcount" -eq 0 && continue
+			cooked_arg="$(echo "$cooked_arg" | sed -e "s/%rgno%/$start_rgno/g")"
+		fi
 		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
@@ -1256,6 +1270,7 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -R	For %rgno% substitution, start with this rtgroup instead of rtgroup 0.
 # -r	Run fsstress for this amount of time, then remount the fs ro or rw.
 #	The default is to run fsstress continuously with no remount, unless
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
@@ -1301,6 +1316,7 @@ _scratch_xfs_stress_scrub() {
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 	local start_agno=0
+	local start_rgno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -1308,12 +1324,13 @@ _scratch_xfs_stress_scrub() {
 	touch "$runningfile"
 
 	OPTIND=1
-	while getopts "a:fi:r:s:S:t:w:x:X:" c; do
+	while getopts "a:fi:r:R:s:S:t:w:x:X:" c; do
 		case "$c" in
 			a) start_agno="$OPTARG";;
 			f) freeze=yes;;
 			i) io_args+=("$OPTARG");;
 			r) remount_period="$OPTARG";;
+			R) start_rgno="$OPTARG";;
 			s) one_scrub_args+=("$OPTARG");;
 			S) xfs_scrub_args+=("$OPTARG");;
 			t) scrub_tgt="$OPTARG";;
@@ -1324,7 +1341,7 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" "$start_rgno" \
 			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
@@ -1372,7 +1389,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "$start_agno" \
+				"$scrub_startat" "$start_agno" "$start_rgno" \
 				"${one_scrub_args[@]}" &
 	fi
 
diff --git a/common/xfs b/common/xfs
index a37284068f..f451dfb8ae 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1524,6 +1524,15 @@ _xfs_mount_agcount()
 	$XFS_INFO_PROG "$1" | sed -n "s/^.*agcount=\([[:digit:]]*\).*/\1/p"
 }
 
+# Find rtgroup count of mounted filesystem
+_xfs_mount_rgcount()
+{
+	local rtgroups="$($XFS_INFO_PROG "$1" | grep rgcount= | sed -e 's/^.*rgcount=\([0-9]*\).*$/\1/g')"
+
+	test -z "$rtgroups" && rtgroups=0
+	echo "$rtgroups"
+}
+
 # Wipe the superblock of each XFS AGs
 _try_wipe_scratch_xfs()
 {
diff --git a/tests/xfs/800 b/tests/xfs/800
index cbcfb5f5a6..a2542be5ec 100755
--- a/tests/xfs/800
+++ b/tests/xfs/800
@@ -32,7 +32,7 @@ _require_xfs_stress_scrub
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
-_scratch_xfs_stress_scrub -s "scrub rtbitmap"
+_scratch_xfs_stress_scrub -s "scrub rtbitmap"  -s "scrub rgbitmap %rgno%"
 
 # success, all done
 echo Silence is golden
diff --git a/tests/xfs/840 b/tests/xfs/840
index fff41c5b8a..b9ed0a55b3 100755
--- a/tests/xfs/840
+++ b/tests/xfs/840
@@ -39,7 +39,7 @@ alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
 scratchfile=$SCRATCH_MNT/file
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchfile" "" 'repair bmapbtd'
+__stress_scrub_check_commands "$scratchfile" "" "" 'repair bmapbtd'
 
 # Compute the number of extent records needed to guarantee btree format,
 # assuming 16 bytes for each ondisk extent record
diff --git a/tests/xfs/841 b/tests/xfs/841
index f743454971..5831961f5f 100755
--- a/tests/xfs/841
+++ b/tests/xfs/841
@@ -39,7 +39,7 @@ scratchfile=$SCRATCH_MNT/file
 mkdir $scratchdir
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchdir" "" 'repair directory'
+__stress_scrub_check_commands "$scratchdir" "" "" 'repair directory'
 
 # Create a 2-dirblock directory
 total_size=$((alloc_unit * 2))

