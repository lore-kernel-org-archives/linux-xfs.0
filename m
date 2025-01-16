Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C7B244120;
	Thu, 16 Jan 2025 23:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070192; cv=none; b=IHjF+cEBMc6J8Chg+4nAv+dO3Fodc8dmm79G7+solEmOP3+pHj8vokCxbWrvTH5y0otKkwMyJstgqY5sKoJH0GX2VqOs9B/zgCpM2EkkDYmESvAtxp3rcV9LtTooiKyPZYWRzea0IbUW7fpuqaWZyJvLo99Ly0zgACYJo3mGdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070192; c=relaxed/simple;
	bh=j6BIMpCWn3HdOSM7wSPlEkZqVHz/YluzwmaLJh02kA8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ws1s80GbzxBA7SvWVUCd+ljY91eaiIolgWRexraNmLa/ZaR+kZx/Abhlu+O0FgbDHJaN7ZOXENX84H2UeHnKfXHwFhklZAlWLHVI3J+RQVZuz6Huxrf/0+/WZ0GqoS6/f68V1CaekLSgxf1fWc+nVkSxISr2MVRHd5cdi8WdKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2xoAPV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2xoAPV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B215C4CED6;
	Thu, 16 Jan 2025 23:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070192;
	bh=j6BIMpCWn3HdOSM7wSPlEkZqVHz/YluzwmaLJh02kA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q2xoAPV5VMc5H6W621TKIakNQZZI/nAjHoB9dvQMd44QtVX9aObygk3ePpbCMcyjE
	 hTZtM+A86sqQeNlALvJH3hgHzb/5cXnyz8GayvR5uUz+9xv6sSiuBIl+1yCTy1DFrk
	 k8E4zGj6GHikuALK0B1tIs1tRlwcb9uyi0zYAOrKC9vt3ySTCXD4WOUN55Ipwvwf0I
	 hJaOtuUiXAfGVuoiI+ejgoLT9YIfLDokVvEVLhxalnxO3KYXCcuoAMOj2VSV40l1kI
	 WRBvM1hKWnhNa3ZbB0+axqsgSaSVcjrtpIO5aYBNkNIpZ5iT1eU3xZy3mMXwXvWoLe
	 fvK+NwU8iuHRg==
Date: Thu, 16 Jan 2025 15:29:51 -0800
Subject: [PATCH 18/23] fuzzy: port fsx and fsstress loop to use --duration
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974348.1927324.11258907441789009054.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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
 common/fuzzy |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e9150173a5d723..331bf5ad7bbafa 100644
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
@@ -946,6 +962,7 @@ __stress_scrub_fsx_loop() {
 	local remount_period="$3"
 	local stress_tgt="$4"	# ignored
 	local focus=(-q -X)	# quiet, validate file contents
+	local duration
 	local res
 
 	# As of November 2022, 2 million fsx ops should be enough to keep
@@ -965,17 +982,12 @@ __stress_scrub_fsx_loop() {
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
@@ -997,7 +1009,8 @@ __stress_scrub_fsx_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		$here/ltp/fsx $args >> $seqres.full
+		duration=$(___stress_scrub_duration "$end" "$remount_period")
+		$here/ltp/fsx $duration $args >> $seqres.full
 		res=$?
 		echo "fsx exits with $res at $(date)" >> $seqres.full
 		test "$res" -ne 0 && break
@@ -1013,6 +1026,7 @@ __stress_scrub_fsstress_loop() {
 	local stress_tgt="$4"
 	local focus=()
 	local res
+	local duration
 
 	case "$stress_tgt" in
 	"parent")
@@ -1115,7 +1129,8 @@ __stress_scrub_fsstress_loop() {
 			# anything.
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
-			_run_fsstress_bg $args $rw_arg >> $seqres.full
+			duration=$(___stress_scrub_duration "$end" "$remount_period")
+			_run_fsstress_bg $duration $args $rw_arg >> $seqres.full
 			sleep $remount_period
 			_kill_fsstress
 			res=$?
@@ -1143,7 +1158,8 @@ __stress_scrub_fsstress_loop() {
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		_run_fsstress $args >> $seqres.full
+		duration=$(___stress_scrub_duration "$end" "$remount_period")
+		_run_fsstress $duration $args >> $seqres.full
 		res=$?
 		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
 		[ "$res" -ne 0 ] && break;

