Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F183DDD3;
	Wed, 19 Feb 2025 00:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926705; cv=none; b=nMv9SVvNk7yQaT7gXXNcJQt4KM6jwEfBH5vou4Ri5v1qv59muUOfwndrWHijsVtgo9KZ4VdR5DaWiV0XAInVNxNrOgG28x6/yAXK7lqx7rLGMFOhOAMhvij45bIZUwwyg54o5X+XBZ3tm3xXzCCygUIdYEJsd5YEKKhgeqtJLG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926705; c=relaxed/simple;
	bh=yw01JJVhph53oetXG5itZyW4BHx7L0yOGTwNLg7grRQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7ereotZjgzSTaOE//FwDHndidsDH/yCSL60znI8DQxeUg3dZ/kfYWeNRlaUenAIEQyBKmModvooX4LWbI/JVChhfX0ktpYTwyPl4rP1cQ9tJx2nxuOoPRnnD4f0ra12XhrDA9oTMSJcn8zJc7JqS9MpDvRxah0UiX9ZL/LjNYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9VkWzQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9VkWzQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59D8C4CEE2;
	Wed, 19 Feb 2025 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926704;
	bh=yw01JJVhph53oetXG5itZyW4BHx7L0yOGTwNLg7grRQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q9VkWzQtnE0fMKCGb+VQ7UpRigRV3dsyMifCFP+Xcnro706fJxxyViOX0kbZs8KnL
	 9gG0k3iuH3agcgvgbWTaKoE9O8NzOxFo4if7mUhIA6jIcKCWdI5Rc3bKxilcBD5NkM
	 K+tbuenARg+7Pkj7xvi+hnF8YdHQbLxPFGtGxWiiZapMCeuygkP5Yzi0j/BUaIPjHH
	 8l1C5gmM/6tVTYzF/BtoqThrW/TeLUyGyFBsWeg05xDPKbh+/DHeJtFDhQU+oumpLl
	 JtCbrFwhUPFQ0azYxthoqPl/7/hl5J+JYfdf7OkiK9Mkio/tOwjGB/Ixm1j5GK1qPg
	 MUS7bY4+KEunQ==
Date: Tue, 18 Feb 2025 16:58:24 -0800
Subject: [PATCH 03/15] fuzzy: stress data and rt sections of xfs filesystems
 equally
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589235.4079457.2842406217553234453.stgit@frogsfrogsfrogs>
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
we run fsstress on separate directory trees for data and realtime
workouts.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |   56 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 14 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index ee9fe75609e603..39efdb22c71627 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1015,15 +1015,28 @@ __stress_scrub_fsx_loop() {
 	rm -f "$runningfile"
 }
 
+# Run fsstress and record outcome
+___scrub_run_fsstress() {
+	_run_fsstress "$@"
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
+	local focus=(-p 4)
+	local res res2
 	local duration
+	local has_rt
+	local d_args r_args
+
+	test $FSTYP = "xfs" && _xfs_has_feature "$SCRATCH_MNT" realtime && \
+		has_rt=1
 
 	case "$stress_tgt" in
 	"parent")
@@ -1113,9 +1126,24 @@ __stress_scrub_fsstress_loop() {
 		;;
 	esac
 
-	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT "${focus[@]}")
-	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
+	if [ -n "$has_rt" ]; then
+		local rdir="$SCRATCH_MNT/rt"
+		local ddir="$SCRATCH_MNT/data"
 
+		mkdir -p "$rdir" "$ddir"
+		$XFS_IO_PROG -c 'chattr +rt' "$rdir"
+		$XFS_IO_PROG -c 'chattr -rt' "$ddir"
+
+		r_args=$(_scale_fsstress_args -d "$rdir" "${focus[@]}")
+		d_args=$(_scale_fsstress_args -d "$ddir" "${focus[@]}")
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
@@ -1125,10 +1153,10 @@ __stress_scrub_fsstress_loop() {
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
 			duration=$(___stress_scrub_duration "$end" "$remount_period")
-			_run_fsstress $duration $args $rw_arg >> $seqres.full
-			res=$?
-			echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
-			[ "$res" -ne 0 ] && break;
+			___scrub_run_fsstress $duration $d_args $rw_arg &
+			test -n "$has_rt" && ___scrub_run_fsstress $duration $r_args $rw_arg &
+			wait
+			test -e "$tmp.killstress" && break
 
 			if [ "$mode" = "rw" ]; then
 				mode="ro"
@@ -1144,7 +1172,7 @@ __stress_scrub_fsstress_loop() {
 				sleep 0.2
 			done
 		done
-		rm -f "$runningfile"
+		rm -f "$runningfile" "$tmp.killstress"
 		return 0
 	fi
 
@@ -1152,12 +1180,12 @@ __stress_scrub_fsstress_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		duration=$(___stress_scrub_duration "$end" "$remount_period")
-		_run_fsstress $duration $args >> $seqres.full
-		res=$?
-		echo "$mode fsstress exits with $res at $(date)" >> $seqres.full
-		[ "$res" -ne 0 ] && break;
+		___scrub_run_fsstress $duration $d_args &
+		test -n "$has_rt" && ___scrub_run_fsstress $duration $r_args &
+		wait
+		test -e "$tmp.killstress" && break
 	done
-	rm -f "$runningfile"
+	rm -f "$runningfile" "$tmp.killstress"
 }
 
 # Make sure we have everything we need to run stress and scrub

