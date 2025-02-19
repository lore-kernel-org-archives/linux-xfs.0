Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A5C3F9D5;
	Wed, 19 Feb 2025 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926721; cv=none; b=npHFW3AofPbimMXyrgk4p6UjXrD4iP/vLV5X3pStolom0V6ACYAqCS4pXbzfqBnWQgAboAAs0W3k0vLwlI3o73YbiulO1Nj8NA26wjefJ2ZYSiBdIyWR4P/kpjIWZA3G4GpFxH77gacVTG6v6UrqwbmrQfyRpbF2ZB/Bq9CLFP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926721; c=relaxed/simple;
	bh=56Iuf6Y4DdIz5SsfapY9i66r/jNm7mXYmbj5M+hTGrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imNwsj0DL4X2H6Y3qgyX6uV5dSWCFZv4JpQZ1LGxqfIGry6dQ9MVaPfP6wc3pdrp33/hbBYmDip2PbsOieeB5m0jFDSdt6T2zqbh5W9q7aNM2uVE9w69mUREnRhAPc2kxlCp4Piv0YQqrrhEfVmJOVKduEbe3xdkqJlJf3jXBaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IovLG2Ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IovLG2Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A86C4CEE2;
	Wed, 19 Feb 2025 00:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926720;
	bh=56Iuf6Y4DdIz5SsfapY9i66r/jNm7mXYmbj5M+hTGrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IovLG2DsXgO688vA2/3wvkvdcGWqbx5oMBXEmmXOKd34kl/xeArsD4hcRUwTsHMpn
	 F51lFFArsw2LPTnKp+TvaIJqgVu7+bkxQhqba2IE4BsouFzhIGKAzsulUVGS05WPHI
	 BEO2y/sYRUlyMovcXKurPhGww3FsYiIldoswTg379qAYAnr0AUHtQYsZpGWeUGs4b8
	 RBoN1rzqhr4UhHESO8lnGmTZZzptWRPUV0nux5Ky7vJ5Bd1LJ+cNPVcaf3AfZLbxbJ
	 iPgYlF6EnKBVsW+i/j4j3ql36akASfnXP0TBiRN578b5IBQFxGr5j3dQaWjDfW6TN4
	 4s/t49nPXQulg==
Date: Tue, 18 Feb 2025 16:58:40 -0800
Subject: [PATCH 04/15] fuzzy: run fsx on data and rt sections of xfs
 filesystems equally
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589254.4079457.10498287265932477514.stgit@frogsfrogsfrogs>
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

If we're stress-testing scrub on a realtime filesystem, make sure that
we run fsx on separate files for data and realtime workouts.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |   53 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 39efdb22c71627..1548f372fac58a 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -955,6 +955,14 @@ ___stress_scrub_duration()
 	echo "--duration=$delta"
 }
 
+# Run fsx and record outcome
+___scrub_run_fsx() {
+	$FSX_PROG "$@" >> $seqres.full
+	local res=$?
+	echo "fsx $* exits with $res at $(date)" >> $seqres.full
+	test "$res" -ne 0 && touch "$tmp.killfsx"
+}
+
 # Run fsx while we're testing online fsck.
 __stress_scrub_fsx_loop() {
 	local end="$1"
@@ -963,14 +971,33 @@ __stress_scrub_fsx_loop() {
 	local stress_tgt="$4"	# ignored
 	local focus=(-q -X)	# quiet, validate file contents
 	local duration
-	local res
+	local has_rt
+	local d_args r_args
+
+	test $FSTYP = "xfs" && _xfs_has_feature "$SCRATCH_MNT" realtime && \
+		has_rt=1
 
 	focus+=(-o $((128000 * LOAD_FACTOR)) )
 	focus+=(-l $((600000 * LOAD_FACTOR)) )
 
-	local args="$FSX_AVOID ${focus[@]} ${SCRATCH_MNT}/fsx.$seq"
-	echo "Running $FSX_PROG $args" >> $seqres.full
+	if [ -n "$has_rt" ]; then
+		local rdir="$SCRATCH_MNT/rt"
+		local ddir="$SCRATCH_MNT/data"
 
+		mkdir -p "$rdir" "$ddir"
+		$XFS_IO_PROG -c 'chattr +rt' "$rdir"
+		$XFS_IO_PROG -c 'chattr -rt' "$ddir"
+
+		r_args="$FSX_AVOID ${focus[*]} $rdir/fsx"
+		d_args="$FSX_AVOID ${focus[*]} $ddir/fsx"
+		echo "Running $FSX_PROG $d_args" >> $seqres.full
+		echo "Running $FSX_PROG $r_args" >> $seqres.full
+	else
+		d_args="$FSX_AVOID ${focus[*]} $SCRATCH_MNT/fsx"
+		echo "Running $FSX_PROG $d_args" >> $seqres.full
+	fi
+
+	rm -f "$tmp.killfsx"
 	if [ -n "$remount_period" ]; then
 		local mode="rw"
 		local rw_arg=""
@@ -980,10 +1007,10 @@ __stress_scrub_fsx_loop() {
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
 			duration=$(___stress_scrub_duration "$end" "$remount_period")
-			$FSX_PROG $duration $args $rw_arg >> $seqres.full
-			res=$?
-			echo "$mode fsx exits with $res at $(date)" >> $seqres.full
-			test "$res" -ne 0 && break
+			___scrub_run_fsx $duration $d_args $rw_arg &
+			test -n "$has_rt" && ___scrub_run_fsx $duration $r_args $rw_arg &
+			wait
+			test -e "$tmp.killfsx" && break
 
 			if [ "$mode" = "rw" ]; then
 				mode="ro"
@@ -999,7 +1026,7 @@ __stress_scrub_fsx_loop() {
 				sleep 0.2
 			done
 		done
-		rm -f "$runningfile"
+		rm -f "$runningfile" "$tmp.killfsx"
 		return 0
 	fi
 
@@ -1007,12 +1034,12 @@ __stress_scrub_fsx_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		duration=$(___stress_scrub_duration "$end" "$remount_period")
-		$FSX_PROG $duration $args >> $seqres.full
-		res=$?
-		echo "fsx exits with $res at $(date)" >> $seqres.full
-		test "$res" -ne 0 && break
+		___scrub_run_fsx $duration $d_args &
+		test -n "$has_rt" && ___scrub_run_fsx $duration $r_args &
+		wait
+		test -e "$tmp.killfsx" && break
 	done
-	rm -f "$runningfile"
+	rm -f "$runningfile" "$tmp.killfsx"
 }
 
 # Run fsstress and record outcome

