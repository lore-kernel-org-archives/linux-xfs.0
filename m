Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8B1F91DB;
	Thu, 16 Jan 2025 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070708; cv=none; b=GG+2UF0BWdf4WtTv/GDYRWUg7Mg8ouLVqJvwU7zXubJ5CinmlDObYKDiLY9J7BwEWNrxTCr5HDHhCV/1OReX2Q7IgCaXrZIwM4eSVAnsC4v98qtAhaRU8UTq+vC30lnLAW27mYzy5LJYmr6IiGH1l43n0VDjHlP8bwtcyJc1q9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070708; c=relaxed/simple;
	bh=/ZBsD2Xwg5ru18V7PNt7LuHytPGayJg1zYiqDPCF4kI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYSwHtoP8mfd/LbpdnMSzYk53G60sz0AD2nPOZKaKyqG+2+ObOwstgBz9+6Yt3EIq9wtJNaXXdIhKsXx3OEjX0bnuS3E4qZOgKgw//1TsfLJBXe1A/RqeZKnMe+mGRXAubf2+bPORwtnTfMWvO0bxNUg6AQbBAVzWwBEumsCoxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFwcC32l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFwcC32l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74565C4CED6;
	Thu, 16 Jan 2025 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070708;
	bh=/ZBsD2Xwg5ru18V7PNt7LuHytPGayJg1zYiqDPCF4kI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oFwcC32lhI+XvOOy6SLKx0DrQTg88/LJ+/595JTMsMEQFAAmP6MfLOJ0DQjn68zk1
	 AMXYSsKE9+Sty9gDdVpopFErWTIoAU7um5+ururKQLpAJN9SYTg15m5jyxYKNxT/09
	 VFs6LnhTsCgf1TXxF2MnFArsv+NEd3HW9tQ7K0TQYawDcEVOvV/udUBYNukkI1bnXe
	 bFzs/dDDsk0q6ptEccIq6rnXQqLvN7GrlRfRYx6WsRkjzm43LiJ4Cd9aNMscrwS53Q
	 u9ewuc4ugPgBTGMojCL9h2yF/jDnyTz8ztL1k26cboYIto+MhfcQWDCoQgdBHKTSjQ
	 CJNRJWO2k1Nkg==
Date: Thu, 16 Jan 2025 15:38:27 -0800
Subject: [PATCH 13/14] common/fuzzy: adapt the scrub stress tests to support
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976263.1928798.8062426953705413541.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adapt the scrub stress testing framework to support checking realtime
group metadata.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy  |   27 ++++++++++++++++++++++-----
 common/xfs    |    9 +++++++++
 tests/xfs/581 |    2 +-
 tests/xfs/720 |    2 +-
 tests/xfs/795 |    2 +-
 5 files changed, 34 insertions(+), 8 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index a7e28dda137e8a..ad28ba9275a09f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -829,8 +829,10 @@ __stress_one_scrub_loop() {
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
@@ -843,6 +845,12 @@ __stress_one_scrub_loop() {
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
@@ -1273,7 +1281,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	local start_agno="$2"
-	shift; shift
+	local start_rgno="$3"
+	shift; shift; shift
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -1303,6 +1313,10 @@ __stress_scrub_check_commands() {
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
@@ -1328,6 +1342,7 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -R	For %rgno% substitution, start with this rtgroup instead of rtgroup 0.
 # -r	Run fsstress for this amount of time, then remount the fs ro or rw.
 #	The default is to run fsstress continuously with no remount, unless
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
@@ -1374,6 +1389,7 @@ _scratch_xfs_stress_scrub() {
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 	local start_agno=0
+	local start_rgno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -1381,12 +1397,13 @@ _scratch_xfs_stress_scrub() {
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
@@ -1397,7 +1414,7 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" "$start_rgno" \
 			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
@@ -1458,7 +1475,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "$start_agno" \
+				"$scrub_startat" "$start_agno" "$start_rgno" \
 				"${one_scrub_args[@]}" &
 	fi
 
diff --git a/common/xfs b/common/xfs
index 81b080b7d8088f..49fb2ea7e7894e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1496,6 +1496,15 @@ _xfs_mount_agcount()
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
diff --git a/tests/xfs/581 b/tests/xfs/581
index 39eb42da4b10c5..6aa360b37b90c5 100755
--- a/tests/xfs/581
+++ b/tests/xfs/581
@@ -30,7 +30,7 @@ _require_xfs_stress_scrub
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" realtime
-_scratch_xfs_stress_scrub -s "scrub rtbitmap"
+_scratch_xfs_stress_scrub -s "scrub rtbitmap"  -s "scrub rgbitmap %rgno%"
 
 # success, all done
 echo Silence is golden
diff --git a/tests/xfs/720 b/tests/xfs/720
index 68a6c7f6e2d584..97b3d2579cbd7f 100755
--- a/tests/xfs/720
+++ b/tests/xfs/720
@@ -37,7 +37,7 @@ alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
 scratchfile=$SCRATCH_MNT/file
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchfile" "" 'repair bmapbtd'
+__stress_scrub_check_commands "$scratchfile" "" "" 'repair bmapbtd'
 
 # Compute the number of extent records needed to guarantee btree format,
 # assuming 16 bytes for each ondisk extent record
diff --git a/tests/xfs/795 b/tests/xfs/795
index 217f96092a4c42..e7004705b526a5 100755
--- a/tests/xfs/795
+++ b/tests/xfs/795
@@ -37,7 +37,7 @@ scratchfile=$SCRATCH_MNT/file
 mkdir $scratchdir
 touch $scratchfile
 $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
-__stress_scrub_check_commands "$scratchdir" "" 'repair directory'
+__stress_scrub_check_commands "$scratchdir" "" "" 'repair directory'
 
 # Create a 2-dirblock directory
 total_size=$((alloc_unit * 2))

