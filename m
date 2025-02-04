Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902D425A62C;
	Tue,  4 Feb 2025 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704327; cv=none; b=BuzXda+kNIeK5LSJV814/Oic8JgzPfaQvcIdSm+z4GEzZY4XGRD31y11AfhuJATkt89jyrSoh3wLXtXkOai3KntFWr1/JvKIPQfsG2071CVa6ERhPeEPyF2KTroFyYUSgP1wTlitypcfj98oeWduvNH0Om+xkqyJlqXfbKK8yaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704327; c=relaxed/simple;
	bh=5sW3PbflipYe+Ixk+i0fHX8L/kGxpEXhz4Kk1EEq5iM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YL+EOv04JJeyuntLGBFYgy79Yg2Il9JQAI/92CzNclgT0Bec2aK8PSfxX9UGe6ZSIYWCrz/rk5FzfmUZvOVEUS5pdywVdMCQA/VuRLwB3QtAq9Uawvpuml7wdMd806aeuumEMO+FNxuFjqE+rJVyU6gTdInEthQm4Dhou1cpUdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI06jYHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI06jYHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F42C4CEE3;
	Tue,  4 Feb 2025 21:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704327;
	bh=5sW3PbflipYe+Ixk+i0fHX8L/kGxpEXhz4Kk1EEq5iM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eI06jYHqvp1MnVY2r2qNgSUo2GyGNPGR4Dc0kB4WV56v2PpAIf082JmwzpI38JuRI
	 vdDIp1YZJ6C3ywKm5hG3fKxjhDRs/3AW+5rWjQMLkg6vssLjmSzUU1n1KOfsYE9rCg
	 FLKLlOrTOWQCX3KSNjXtZAB6Mc3T17KuWzhTPURytQWEF1rMt0RjTB/IX9ZqAwY7vN
	 o53Tuk2jPiC5S9/qhVHaDf/Tk63KLuUBBhiz1m775wp7KTdmEOBBvyWtHNjxltV229
	 cubbPfEXQJnhVkDXS5iFXPEFzO4iWqwg7m3hUc5B7N1UiLMAPrT0lG1ICB0nz0rCzX
	 wVe3hdzLGIcBw==
Date: Tue, 04 Feb 2025 13:25:26 -0800
Subject: [PATCH 12/34] fuzzy: kill subprocesses with SIGPIPE, not SIGINT
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406291.546134.15020436171673463354.stgit@frogsfrogsfrogs>
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

The next patch in this series fixes various issues with the recently
added fstests process isolation scheme by running each new process in a
separate process group session.  Unfortunately, the processes in the
session are created with SIGINT ignored by default because they are not
attached to the controlling terminal.  Therefore, switch the kill signal
to SIGPIPE because that is usually fatal and not masked by default.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index 0a2d91542b561e..6d390d4efbd3da 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -891,7 +891,7 @@ __stress_xfs_scrub_loop() {
 	local runningfile="$2"
 	local scrub_startat="$3"
 	shift; shift; shift
-	local sigint_ret="$(( $(kill -l SIGINT) + 128 ))"
+	local signal_ret="$(( $(kill -l SIGPIPE) + 128 ))"
 	local scrublog="$tmp.scrub"
 
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
@@ -902,7 +902,7 @@ __stress_xfs_scrub_loop() {
 		_scratch_scrub "$@" &> $scrublog
 		res=$?
 		if [ "$res" -eq "$sigint_ret" ]; then
-			# Ignore SIGINT because the cleanup function sends
+			# Ignore SIGPIPE because the cleanup function sends
 			# that to terminate xfs_scrub
 			res=0
 		fi
@@ -1173,13 +1173,11 @@ _scratch_xfs_stress_scrub_cleanup() {
 	rm -f "$runningfile"
 	echo "Cleaning up scrub stress run at $(date)" >> $seqres.full
 
-	# Send SIGINT so that bash won't print a 'Terminated' message that
-	# distorts the golden output.
 	echo "Killing stressor processes at $(date)" >> $seqres.full
 	_kill_fsstress
-	pkill -INT --parent $$ xfs_io >> $seqres.full 2>&1
-	pkill -INT --parent $$ fsx >> $seqres.full 2>&1
-	pkill -INT --parent $$ xfs_scrub >> $seqres.full 2>&1
+	_pkill --echo -PIPE xfs_io >> $seqres.full 2>&1
+	_pkill --echo -PIPE fsx >> $seqres.full 2>&1
+	_pkill --echo -PIPE xfs_scrub >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -1209,6 +1207,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Wait for the remaining children to exit.
 	echo "Waiting for children to exit at $(date)" >> $seqres.full
 	wait
+	echo "Children exited as of $(date)" >> $seqres.full
 
 	# Ensure the scratch fs is also writable before we exit.
 	if [ -n "$__SCRUB_STRESS_REMOUNT_LOOP" ]; then

