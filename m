Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6599199B8;
	Fri, 11 Oct 2024 01:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610906; cv=none; b=ss6I8/0m/7Vw0QVN01pn5hwTGqt/dfLAs9UtTVkRHIu8w3S/ZF/28YoDRImMLlMSOhZGULdakq6odH1yHnQSu1+aRJ2vcR1Dl7Iy7z/RNC6sixG2XnW/LngeWagK5eTtazfpO+KwDBTGxFW9hAuIqLOnpfgpePCWv7BcAA6vcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610906; c=relaxed/simple;
	bh=+r4LqBto/0xMpdKNkGCuL/DXEBje+RHsp8f1N5TT1hk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIyy+vgO9PIx/NgJZx7cO5kJPeRsB2JBjAFAbQfmqXGXFMqnirRsYrm0W5S/MJIvQ5f/70YiowVgKwL0vRt/frktfQo/WV9SQDnRuLprNAusjPB5BezR7gJy3TbU1Rcomiz9heBkcRPSKNwOwReYyXr1/KVgXgw7kPDr7brzMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tg6EspGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tg6EspGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E35AC4CEC5;
	Fri, 11 Oct 2024 01:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610906;
	bh=+r4LqBto/0xMpdKNkGCuL/DXEBje+RHsp8f1N5TT1hk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tg6EspGiCo3M4P68GP69KutcdpDaXD3GowNEvVOmM+Q1gLFOGi8io/uK4g9SnAoka
	 EXemyxjqHEyX3KDA1eBoip8X4+zT2Bl6m82fz1ATyzMV8mRKLOnsSXv74ATVQUF50Y
	 wzyTDYCL/PbK7aqrgw4hQc8zqn6ouc1RddS/5VsCcDy+LRkK1pwS3ivYFo5iaS2EjG
	 Fmy/4dNnVWvgakIGO22v6x7M2/PhrnYY58qgFNeOIP57S3++ifWyNqoZ0gIzBvz66V
	 OorWyRpRRFOl7TyKBXSgUAKowjNr8e2+sXfOC5yq4hMTRoxMIctV6tWi65k8+mrKRx
	 hnkJdMhBZTFLw==
Date: Thu, 10 Oct 2024 18:41:45 -0700
Subject: [PATCH 03/16] fuzzy: stress data and rt sections of xfs filesystems
 equally
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658567.4188964.9908770902502864561.stgit@frogsfrogsfrogs>
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

If we're stress-testing scrub on a realtime filesystem, make sure that
we run fsstress on separate directory trees for data and realtime
workouts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |   66 +++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 17 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 73e5cd2a544455..ceb547669b51cd 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -998,13 +998,37 @@ __stress_scrub_fsx_loop() {
 	rm -f "$runningfile"
 }
 
+# Run fsstress with a timeout, and touch $tmp.killstress if dead
+__run_timed_fsstress() {
+	timeout -s TERM "$remount_period" $FSSTRESS_PROG $* >> $seqres.full
+	res=$?
+	echo "$mode fsstress $* exits with $res at $(date)" >> $seqres.full
+	if [ "$res" -ne 0 ] && [ "$res" -ne 124 ]; then
+		# Stop if fsstress returns error.  Mask off the magic code 124
+		# because that is how the timeout(1) program communicates that
+		# we ran out of time.
+		touch "$tmp.killstress"
+	fi
+}
+
+# Run fsstress and record outcome
+__run_fsstress() {
+	$FSSTRESS_PROG $* >> $seqres.full
+	echo "fsstress $* exits with $? at $(date)" >> $seqres.full
+}
+
 # Run fsstress while we're testing online fsck.
 __stress_scrub_fsstress_loop() {
 	local end="$1"
 	local runningfile="$2"
 	local remount_period="$3"
 	local stress_tgt="$4"
-	local focus=()
+	local focus=(-p 4 -n 2000000)
+	local scale_args=()
+	local has_rt
+
+	test $FSTYP = "xfs" && _xfs_has_feature "$SCRATCH_MNT" realtime && \
+		has_rt=1
 
 	case "$stress_tgt" in
 	"parent")
@@ -1096,28 +1120,35 @@ __stress_scrub_fsstress_loop() {
 
 	# As of March 2022, 2 million fsstress ops should be enough to keep
 	# any filesystem busy for a couple of hours.
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 "${focus[@]}" $FSSTRESS_AVOID)
-	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
+	local args
+	if [ -n "$has_rt" ]; then
+		mkdir -p $SCRATCH_MNT/rt $SCRATCH_MNT/data
+		$XFS_IO_PROG -c 'chattr +rt' $SCRATCH_MNT/rt
+		$XFS_IO_PROG -c 'chattr -rt' $SCRATCH_MNT/data
+
+		rt_args=$(_scale_fsstress_args -d $SCRATCH_MNT/rt "${focus[@]}" $FSSTRESS_AVOID)
+		args=$(_scale_fsstress_args -d $SCRATCH_MNT/data "${focus[@]}" $FSSTRESS_AVOID)
+		echo "Running $FSSTRESS_PROG $args" >> $seqres.full
+		echo "Running $FSSTRESS_PROG $rt_args" >> $seqres.full
+	else
+		args=$(_scale_fsstress_args -d $SCRATCH_MNT "${focus[@]}" $FSSTRESS_AVOID)
+		echo "Running $FSSTRESS_PROG $args" >> $seqres.full
+	fi
 
 	if [ -n "$remount_period" ]; then
 		local mode="rw"
 		local rw_arg=""
+
+		rm -f "$tmp.killstress"
 		while __stress_scrub_running "$end" "$runningfile"; do
 			# Need to recheck running conditions if we cleared
 			# anything.
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
-			timeout -s TERM "$remount_period" $FSSTRESS_PROG \
-					$args $rw_arg >> $seqres.full
-			res=$?
-			echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
-			if [ "$res" -ne 0 ] && [ "$res" -ne 124 ]; then
-				# Stop if fsstress returns error.  Mask off
-				# the magic code 124 because that is how the
-				# timeout(1) program communicates that we ran
-				# out of time.
-				break;
-			fi
+			__run_timed_fsstress $args $rw_arg &
+			test -n "$has_rt" && __run_timed_fsstress $rt_args $rw_arg &
+			wait
+			test -e "$tmp.killstress" && break
 			if [ "$mode" = "rw" ]; then
 				mode="ro"
 				rw_arg="-R"
@@ -1132,15 +1163,16 @@ __stress_scrub_fsstress_loop() {
 				sleep 0.2
 			done
 		done
-		rm -f "$runningfile"
+		rm -f "$runningfile" "$tmp.killstress"
 		return 0
 	fi
 
 	while __stress_scrub_running "$end" "$runningfile"; do
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
-		$FSSTRESS_PROG $args >> $seqres.full
-		echo "fsstress exits with $? at $(date)" >> $seqres.full
+		__run_fsstress $args &
+		test -n "$has_rt" && __run_fsstress $rt_args &
+		wait
 	done
 	rm -f "$runningfile"
 }

