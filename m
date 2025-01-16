Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADFB1F3FD5;
	Thu, 16 Jan 2025 23:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070552; cv=none; b=om1jGV8txioDb4DGUK1DGyfv/hUnTTDKrVBFYhtTxfqAJEIb7qAwjiSsufu2dfgL8ON4laWpDKRejBIoPtKHpyLnsLYK2pKSlQlNjcCh8KFPrQTR4am1PmFNxvcRJqkJA9wNcE5ft4BWO8VwnR8sNctvdcNSs25FrFEUnZ3f0E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070552; c=relaxed/simple;
	bh=O9Bv49fnlzRJaUvFdZ+3SZB7Mb3tW+wgFkVZSKCqvaI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwRFKkr8XbD1yml9ZZpSojPRzm5+mjs5lhY6YanGL+OBRZbi54Dm9CQSWgEGkTbdx14CVaKrgdF/+Dol+1oppQ8cHpeETnYoYzazOA3Uh3lPu4fsj1yfVLEFDKAQ9z6Phxh8qws3kUE78/8DrCt8Zx6ENSdS1P9GulReSWIGJbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljpwbQnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljpwbQnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA4AC4CED6;
	Thu, 16 Jan 2025 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070552;
	bh=O9Bv49fnlzRJaUvFdZ+3SZB7Mb3tW+wgFkVZSKCqvaI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ljpwbQnNHXr4bRG8VWYIsU7LX26YRfL6CyxyPYb2EMg0U0mm1uh2xRg6s/2NHs+Ma
	 y0jEk8XJbuPTv8yl7BDzXwCMVXeegj2pERvyRdHuN49jpCJksY/ukefIbd9EmvqqYB
	 XPU7wx1Gnwi/woyNAYqJDm33FM+g1fCmAK6nT796bsHllhZYMfFbEdhEXQ1Ihrh9YO
	 aj2UO7YWqs4C2Y+i75v9Jv//bwzteEzmJeeswgXvPuptl5RgtfPgKWpFvZ4Ps+jDs3
	 ttKzHzSTcyGdsL15gqHsGMitUVRBiuiap2EgDhvJpl+09FtdS9sqLyjrEkcUzj/jdp
	 PBw18bIWksa8w==
Date: Thu, 16 Jan 2025 15:35:51 -0800
Subject: [PATCH 03/14] fuzzy: stress data and rt sections of xfs filesystems
 equally
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976109.1928798.465942861320732980.stgit@frogsfrogsfrogs>
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

If we're stress-testing scrub on a realtime filesystem, make sure that
we run fsstress on separate directory trees for data and realtime
workouts.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |   55 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 16 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 9fcaf9b6ee55a9..a7e28dda137e8a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1018,15 +1018,28 @@ __stress_scrub_fsx_loop() {
 	rm -f "$runningfile"
 }
 
+# Run fsstress and record outcome
+__run_fsstress() {
+	_run_fsstress $*
+	local res=$?
+	echo "fsstress $* exits with $res at $(date)" >> $seqres.full
+	test "$res" -ne 0 && touch "$tmp.killstress"
+}
+
 # Run fsstress while we're testing online fsck.
 __stress_scrub_fsstress_loop() {
 	local end="$1"
 	local runningfile="$2"
 	local remount_period="$3"
 	local stress_tgt="$4"
-	local focus=()
-	local res
+	local focus=(-p 4 -n 2000000)
+	local res res2
 	local duration
+	local has_rt
+	local d_args r_args
+
+	test $FSTYP = "xfs" && _xfs_has_feature "$SCRATCH_MNT" realtime && \
+		has_rt=1
 
 	case "$stress_tgt" in
 	"parent")
@@ -1118,9 +1131,21 @@ __stress_scrub_fsstress_loop() {
 
 	# As of March 2022, 2 million fsstress ops should be enough to keep
 	# any filesystem busy for a couple of hours.
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 "${focus[@]}")
-	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
+	if [ -n "$has_rt" ]; then
+		mkdir -p $SCRATCH_MNT/rt $SCRATCH_MNT/data
+		$XFS_IO_PROG -c 'chattr +rt' $SCRATCH_MNT/rt
+		$XFS_IO_PROG -c 'chattr -rt' $SCRATCH_MNT/data
 
+		r_args=$(_scale_fsstress_args -d $SCRATCH_MNT/rt "${focus[@]}")
+		d_args=$(_scale_fsstress_args -d $SCRATCH_MNT/data "${focus[@]}")
+		echo "Running $FSSTRESS_PROG $d_args" >> $seqres.full
+		echo "Running $FSSTRESS_PROG $r_args" >> $seqres.full
+	else
+		d_args=$(_scale_fsstress_args -d $SCRATCH_MNT "${focus[@]}")
+		echo "Running $FSSTRESS_PROG $d_args" >> $seqres.full
+	fi
+
+	rm -f "$tmp.killstress"
 	if [ -n "$remount_period" ]; then
 		local mode="rw"
 		local rw_arg=""
@@ -1130,12 +1155,10 @@ __stress_scrub_fsstress_loop() {
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
 			duration=$(___stress_scrub_duration "$end" "$remount_period")
-			_run_fsstress_bg $duration $args $rw_arg >> $seqres.full
-			sleep $remount_period
-			_kill_fsstress
-			res=$?
-			echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
-			[ "$res" -ne 0 ] && break;
+			__run_fsstress $duration $d_args $rw_arg &
+			test -n "$has_rt" && __run_fsstress $duration $r_args $rw_arg &
+			wait
+			test -e "$tmp.killstress" && break
 
 			if [ "$mode" = "rw" ]; then
 				mode="ro"
@@ -1151,7 +1174,7 @@ __stress_scrub_fsstress_loop() {
 				sleep 0.2
 			done
 		done
-		rm -f "$runningfile"
+		rm -f "$runningfile" "$tmp.killstress"
 		return 0
 	fi
 
@@ -1159,12 +1182,12 @@ __stress_scrub_fsstress_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		duration=$(___stress_scrub_duration "$end" "$remount_period")
-		_run_fsstress $duration $args >> $seqres.full
-		res=$?
-		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
-		[ "$res" -ne 0 ] && break;
+		__run_fsstress $duration $d_args &
+		test -n "$has_rt" && __run_fsstress $duration $r_args &
+		wait
+		test -e "$tmp.killstress" && break
 	done
-	rm -f "$runningfile"
+	rm -f "$runningfile" "$tmp.killstress"
 }
 
 # Make sure we have everything we need to run stress and scrub

