Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C8B6FB0;
	Fri, 11 Oct 2024 01:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611094; cv=none; b=enMRD0UBv8PhuAexFfer9BW2nFaV2cTB0158dR8Z5VnUBLeKJNed79h3A/tJm3xvS/cVmJIxukJNl0E7iQXY9W3au3/17BUgk6TWc+5iInmZVmw3TKKxL9xKvZLBCx4GrEp3c2tjMBu1VjcN7+3MSnerSDOFJ+6916zR+rA9t7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611094; c=relaxed/simple;
	bh=dlH51RDCozgy+wEhuFiLoSXp9KwpgMcYz9vy18UOnVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQyp9fGuLV0yBPBuTgfLlNJZD70Dx7VUxzAtIA1p1Q3XiT23C6cFQFpnBHPqXe053oMigWZXoU+DEW9XvihDe3KSFTik0IEb6EfGt4fP7AXm5FK0YshL3XFejSD/hwDegzUHlGSsQIFR03dUN8wxrCaP1VwjJezlyUBEXXRf/AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPJQl6sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPJQl6sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1461C4CEC5;
	Fri, 11 Oct 2024 01:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611093;
	bh=dlH51RDCozgy+wEhuFiLoSXp9KwpgMcYz9vy18UOnVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SPJQl6sVBCRZnqsL8C9JYNt2aXa9qY2iOoxQ1u2u7sQuiUcRQUA62f2nRIQBDVwYl
	 1hX8+Dp2u5ri+91OdRJeplvBf2ONou3gcs8L8x5lORZSdeI7UAnCcFj36hwxMBzky9
	 KIyTjOHyIqO6/Ueta1TZN6up2K5i4DU1Nsk9UKs8AQeaFa7xHYHwOs5HQhVxtX85+U
	 TJlR0UVELgJRLo4cznONumjPBBdd9kY+RHOzSBmM2i2AJhpA3s0o1uoo4qDfUxln3r
	 XLSgZQRPvrFWuZSvR7HJSvMA92rX1bs/Vk9b/JnAVD9wAvJFzvmGbVALadm2KJEk93
	 KkU046EgXnCEA==
Date: Thu, 10 Oct 2024 18:44:53 -0700
Subject: [PATCH 15/16] common/fuzzy: adapt the scrub stress tests to support
 rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658749.4188964.7775010185798386769.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy  |   27 ++++++++++++++++++++++-----
 common/xfs    |    9 +++++++++
 tests/xfs/581 |    2 +-
 tests/xfs/720 |    2 +-
 tests/xfs/795 |    2 +-
 5 files changed, 34 insertions(+), 8 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index ceb547669b51cd..254426be6c8cf9 100644
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
@@ -1259,7 +1267,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	local start_agno="$2"
-	shift; shift
+	local start_rgno="$3"
+	shift; shift; shift
+	local rgcount="$(_xfs_mount_rgcount $SCRATCH_MNT)"
 
 	local cooked_tgt="$scrub_tgt"
 	case "$scrub_tgt" in
@@ -1289,6 +1299,10 @@ __stress_scrub_check_commands() {
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
@@ -1314,6 +1328,7 @@ __stress_scrub_check_commands() {
 #	in a separate loop.  If zero -i options are specified, do not run.
 #	Callers must check each of these commands (via _require_xfs_io_command)
 #	before calling here.
+# -R	For %rgno% substitution, start with this rtgroup instead of rtgroup 0.
 # -r	Run fsstress for this amount of time, then remount the fs ro or rw.
 #	The default is to run fsstress continuously with no remount, unless
 #	XFS_SCRUB_STRESS_REMOUNT_PERIOD is set.
@@ -1360,6 +1375,7 @@ _scratch_xfs_stress_scrub() {
 	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
 	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
 	local start_agno=0
+	local start_rgno=0
 
 	__SCRUB_STRESS_FREEZE_PID=""
 	__SCRUB_STRESS_REMOUNT_LOOP=""
@@ -1367,12 +1383,13 @@ _scratch_xfs_stress_scrub() {
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
@@ -1383,7 +1400,7 @@ _scratch_xfs_stress_scrub() {
 		esac
 	done
 
-	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" \
+	__stress_scrub_check_commands "$scrub_tgt" "$start_agno" "$start_rgno" \
 			"${one_scrub_args[@]}"
 
 	if ! command -v "__stress_scrub_${exerciser}_loop" &>/dev/null; then
@@ -1439,7 +1456,7 @@ _scratch_xfs_stress_scrub() {
 
 	if [ "${#one_scrub_args[@]}" -gt 0 ]; then
 		__stress_one_scrub_loop "$end" "$runningfile" "$scrub_tgt" \
-				"$scrub_startat" "$start_agno" \
+				"$scrub_startat" "$start_agno" "$start_rgno" \
 				"${one_scrub_args[@]}" &
 	fi
 
diff --git a/common/xfs b/common/xfs
index 09ce830ffdefbe..9036fdb363904e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1475,6 +1475,15 @@ _xfs_mount_agcount()
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
index 73b51f994a3f00..3af9ef8a19c0bb 100755
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
index f928cc43d3bc54..e4af2a8d5470d2 100755
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
index 5a67f02ec92eca..cd1d288add212f 100755
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

