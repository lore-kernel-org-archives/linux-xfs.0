Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E4271839;
	Wed, 12 Feb 2025 03:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331463; cv=none; b=ZQYg27BsDDHtuzXC8gtL+YaZfudu0h9XBWrev8uZbfxWNrsQqyrKN2Wi2ze/D9b8JcSpUSi828+ErneVrPv687DRRSlwm28xojEj4e/pSGl3HfoVtk9LJCD0gNuG2tRcqPXPOAri/IcAGUWSi6w7I0GQ26BdBfgYb0V4qJvlz3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331463; c=relaxed/simple;
	bh=UQfLvU9S/5W2B3X9OXYoHXmW5DHFFkvU1gTWBa2+Uos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c+KmZZxUELhExNUq6X0B8NbDlPVKeQXyxRAUGXYpM0735PveGRKJO0NuyaakOZpMGkDBjyhzDHGOrBK5PkCGu4c0lVJptawuDCGplDOtigyLIFe04T/C/k24vp/dxT7i1KhRbmXB8qiwF0VASDLSyWHxTcpbDfYUDa7VO4tKIY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p2hKL1M0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p2hKL1M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E30C4CEDF;
	Wed, 12 Feb 2025 03:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331463;
	bh=UQfLvU9S/5W2B3X9OXYoHXmW5DHFFkvU1gTWBa2+Uos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p2hKL1M0brncRokgxY9tpWMOtVSyTlaHxYXFDLbbRhRqHd89DWrskEtcMiNvaCRVZ
	 j+eGRI4BQJbJ5iZbv7o3Cp1Nyo4fK1u+l41rIWoDvcsvBF9iTVqZKOY1QcjMXXE5IN
	 OoZv7JLsbOReojU8IH+zA2vqsaX2u2zNIt/WLkZRE29LKpm44OefWgkKjJ7YiCztqG
	 nne6/chmcXPPJU2/Dg5yj13pwoT6N8wf4ILpyDwlbCL9UAMFUyTKmvNsRcIBNzt0A8
	 NUkxdan6NgYHwc0enoR3WQwWga4Vadq2ssCozO7erLKdEUwtj1vMyXoNa/4LOVRPI6
	 UfZL2jSGfxMGA==
Date: Tue, 11 Feb 2025 19:37:43 -0800
Subject: [PATCH 27/34] fuzzy: port fsx and fsstress loop to use --duration
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094766.1758477.9477390850462245159.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Quite a while ago, I added --duration= arguments to fsx and fsstress,
and apparently I forgot to update the scrub stress loops to use them.
Replace the usage of timeout(1) for the remount_period versions of the
loop to clean up that code; and convert the non-remount loop so that
they don't run over time.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 8afa4d35759f62..b82884ff7d6d1d 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -939,6 +939,22 @@ __stress_scrub_clean_scratch() {
 	return 0
 }
 
+# Compute a --duration= interval for fsx and fsstress
+___stress_scrub_duration()
+{
+	local end="$1"
+	local remount_period="$2"
+	local now="$(date +%s)"
+	local delta="$((end - now))"
+
+	test "$delta" -lt 0 && delta=0
+
+	test -n "$remount_period" && test "$remount_period" -lt "$delta" && \
+		delta="$remount_period"
+
+	echo "--duration=$delta"
+}
+
 # Run fsx while we're testing online fsck.
 __stress_scrub_fsx_loop() {
 	local end="$1"
@@ -946,11 +962,9 @@ __stress_scrub_fsx_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"	# ignored
 	local focus=(-q -X)	# quiet, validate file contents
+	local duration
 	local res
 
-	# As of November 2022, 2 million fsx ops should be enough to keep
-	# any filesystem busy for a couple of hours.
-	focus+=(-N 2000000)
 	focus+=(-o $((128000 * LOAD_FACTOR)) )
 	focus+=(-l $((600000 * LOAD_FACTOR)) )
 
@@ -965,17 +979,12 @@ __stress_scrub_fsx_loop() {
 			# anything.
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
-			timeout -s TERM "$remount_period" $here/ltp/fsx \
-					$args $rw_arg >> $seqres.full
+			duration=$(___stress_scrub_duration "$end" "$remount_period")
+			$here/ltp/fsx $duration $args $rw_arg >> $seqres.full
 			res=$?
 			echo "$mode fsx exits with $res at $(date)" >> $seqres.full
-			if [ "$res" -ne 0 ] && [ "$res" -ne 124 ]; then
-				# Stop if fsx returns error.  Mask off
-				# the magic code 124 because that is how the
-				# timeout(1) program communicates that we ran
-				# out of time.
-				break;
-			fi
+			test "$res" -ne 0 && break
+
 			if [ "$mode" = "rw" ]; then
 				mode="ro"
 				rw_arg="-t 0 -w 0 -FHzCIJBE0"
@@ -997,7 +1006,8 @@ __stress_scrub_fsx_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		$here/ltp/fsx $args >> $seqres.full
+		duration=$(___stress_scrub_duration "$end" "$remount_period")
+		$here/ltp/fsx $duration $args >> $seqres.full
 		res=$?
 		echo "fsx exits with $res at $(date)" >> $seqres.full
 		test "$res" -ne 0 && break
@@ -1013,6 +1023,7 @@ __stress_scrub_fsstress_loop() {
 	local stress_tgt="$4"
 	local focus=()
 	local res
+	local duration
 
 	case "$stress_tgt" in
 	"parent")
@@ -1102,9 +1113,7 @@ __stress_scrub_fsstress_loop() {
 		;;
 	esac
 
-	# As of March 2022, 2 million fsstress ops should be enough to keep
-	# any filesystem busy for a couple of hours.
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 "${focus[@]}")
+	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT "${focus[@]}")
 	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
 
 	if [ -n "$remount_period" ]; then
@@ -1115,9 +1124,8 @@ __stress_scrub_fsstress_loop() {
 			# anything.
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
-			_run_fsstress_bg $args $rw_arg >> $seqres.full
-			sleep $remount_period
-			_kill_fsstress
+			duration=$(___stress_scrub_duration "$end" "$remount_period")
+			_run_fsstress $duration $args $rw_arg >> $seqres.full
 			res=$?
 			echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
 			[ "$res" -ne 0 ] && break;
@@ -1143,7 +1151,8 @@ __stress_scrub_fsstress_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		_run_fsstress $args >> $seqres.full
+		duration=$(___stress_scrub_duration "$end" "$remount_period")
+		_run_fsstress $duration $args >> $seqres.full
 		res=$?
 		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
 		[ "$res" -ne 0 ] && break;

