Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F441A08B5;
	Wed, 19 Feb 2025 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926877; cv=none; b=mdhx6Ixa6DFwRZDwD95BIOiNh75aR0+f8uUKuWCn77c3rWeHFh+17b0p8volTsgGzX25uCKQWPampctC4dgGhgd5fi08u96EGk9JZ6bcWnvDXOX58OKikl74yj92NluP+/nYBrmGmQ2IjW5+mFTWqUSLonrUQRfBcdXN2IP+HEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926877; c=relaxed/simple;
	bh=l6CPkU+TjVuSPLV2FkIlrDWhPxfVeHjcB8mc9NPhdcw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4jXsQ3NguUwG+5ZJ2zip4Y5gLhJYJUbdxmki8c+0FCoBwPLaEdZSqiH9Cj/79unfSAEcbs9lG0TMJ26FeL16WVj8uTJIK3oYvNj3EqDFq8RDnLF06gSaTeSacXLJROxOVMPNK6Hkavau7uf4FeFr7OxIO0KPCJeF8XjCoQiCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZepLSwAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZepLSwAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3322CC4CEE2;
	Wed, 19 Feb 2025 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926877;
	bh=l6CPkU+TjVuSPLV2FkIlrDWhPxfVeHjcB8mc9NPhdcw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZepLSwAgL8179/52+emZ53cnB7WFtDCdz37FAoM1vZGP54bJqARM7x+4R/h5IX48g
	 ffMSBsBiq2p+KKgKIJqrBJ9pguMHyUbdshgxESVUr9JuagDHbLSuwOMZCj2BHz2oci
	 wdgl4umgWsWvvxN9JLMLo6fVXLQqvv5VPWO3RaG2RQmGmJHYw9cbyPx8bsFyAYe1rz
	 gvRh1jp70Y8qLru/dFpecz6FDnFRi02O4IB1ErHMuatwoQs6GC99XTryS4ATfFHaDf
	 4Y5wdE4jG+tJVi+PLPPazh2DPsOXIM+Y6Xhthv1YW/crj2eZxuCsx4m+13RAeUElFY
	 L3hWP77pglDoA==
Date: Tue, 18 Feb 2025 17:01:16 -0800
Subject: [PATCH 14/15] common/fuzzy: adapt the scrub stress tests to support
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589437.4079457.14723541149706284576.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
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
index 1548f372fac58a..a57b076ef9670a 100644
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
@@ -1298,7 +1306,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	local start_agno="$2"
-	shift; shift
+	local start_rgno="$3"
+	shift; shift; shift
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -1328,6 +1338,10 @@ __stress_scrub_check_commands() {
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
@@ -1353,6 +1367,7 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -R	For %rgno% substitution, start with this rtgroup instead of rtgroup 0.
 # -r	Run fsstress for this amount of time, then remount the fs ro or rw.
 #	The default is to run fsstress continuously with no remount, unless
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
@@ -1399,6 +1414,7 @@ _scratch_xfs_stress_scrub() {
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 	local start_agno=0
+	local start_rgno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -1406,12 +1422,13 @@ _scratch_xfs_stress_scrub() {
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
@@ -1422,7 +1439,7 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" "$start_rgno" \
 			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
@@ -1483,7 +1500,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "$start_agno" \
+				"$scrub_startat" "$start_agno" "$start_rgno" \
 				"${one_scrub_args[@]}" &
 	fi
 
diff --git a/common/xfs b/common/xfs
index a94b9de032f932..1e415a4eb3ed68 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1490,6 +1490,15 @@ _xfs_mount_agcount()
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

