Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9515A25A62C;
	Tue,  4 Feb 2025 21:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704561; cv=none; b=elbIqOyxVc3ZOL0nnwJl3chmGJGGW3YJ02v3HwD61SrkY3iJPOBWeshVOLIcVmABibJW/a4/Ih29opHFWk/dy1btFY/65R2obVRZhXzft2UCqxYZl/kAofQoZq1feAMShesJW8BAFNxUGLr3C++2WngE69wjLTSvEYXdS8ZTcjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704561; c=relaxed/simple;
	bh=iK42eRqLqJ00rZzx452YmYn/xearR0tid5Ajqub3zjQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mx30W7VnQokim56/FpHOmxytGN/xtdHV7EPdJt8Uz1mfPbJKjKf3AVPjbYUEEvvLF6WVvZd9sb68NqT8CJTjpywqGZm4jFeY9JFmja7HIn6NLYv+vvX0EXnInUAvpdxfOfc+aZF7icScdXzCqHGXmlxEsDks+1moACCLlSohKK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kegMxPzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kegMxPzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618B6C4CEDF;
	Tue,  4 Feb 2025 21:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704561;
	bh=iK42eRqLqJ00rZzx452YmYn/xearR0tid5Ajqub3zjQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kegMxPzLzVQ9XLxkkBNBOiOnyMO3GDCX2dRZqwMyfqq53LRka9CYhkH1pLMR7j2Jj
	 Pfbhgy9I1X4af9quUWXqETaOUL/Oeuww53qUw1GtHJ3O0ANhnAKuiPpRQAnkTFJSEi
	 qPRuGrvh8KOJQi21ZvvQGzIUZZSyXnelz8hKLuUENrmo4ncj+2eqWaBIJ/5U1BuHXc
	 TN6N63wBXIeawFlhktRPzwad8Hh95t7ngdliY60anvBwjCdVszDySzT1e8ZzMzt4A/
	 zhZsq3adLlP3B8s3Hn+Uk0xz1PlD64dunkJ99ilTFa37nOCzIra12STtXmRJom7m1f
	 vd5t4FDou/TWA==
Date: Tue, 04 Feb 2025 13:29:20 -0800
Subject: [PATCH 27/34] fuzzy: port fsx and fsstress loop to use --duration
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406519.546134.6155766711303511656.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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
 common/fuzzy |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 8afa4d35759f62..f676614d8343f7 100644
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
@@ -1115,7 +1124,8 @@ __stress_scrub_fsstress_loop() {
 			# anything.
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
-			_run_fsstress_bg $args $rw_arg >> $seqres.full
+			duration=$(___stress_scrub_duration "$end" "$remount_period")
+			_run_fsstress_bg $duration $args $rw_arg >> $seqres.full
 			sleep $remount_period
 			_kill_fsstress
 			res=$?
@@ -1143,7 +1153,8 @@ __stress_scrub_fsstress_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		_run_fsstress $args >> $seqres.full
+		duration=$(___stress_scrub_duration "$end" "$remount_period")
+		_run_fsstress $duration $args >> $seqres.full
 		res=$?
 		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
 		[ "$res" -ne 0 ] && break;

