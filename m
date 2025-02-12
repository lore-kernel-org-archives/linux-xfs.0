Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86F7E110;
	Wed, 12 Feb 2025 03:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331229; cv=none; b=h++12iH43to00GcHyWaBkwWWjnKEKYeKPSnNcmgJXy3fdTHGPdw946xbOfdl+SXlhTZbS0xMZoVtw503d9Dm3isJeGhWSik2nPODtK6im3F+tDmCc7KcwCsEyFxImVp4jTrx06nh2J9tFrqaxO2qd8wzVmdbw3J8MvNJyH0LvNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331229; c=relaxed/simple;
	bh=W9moJyOSthIqTIzScajKcTkM1UAQKE86/OXPg8I1Au8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHHd2lWOhfLzKSH578iWDbbt5qSiOyZyU0s9marzprnx9+9Y2M5M5+H94URcDq6rHQFbd69DePnWroEjTJnE7HvpPdQdqR89lSoP2tj2JV9hdrUQVJkOszUw34fZQkeQGuR87eoOGaYCSgiNqAms6kr0HQT2fkQ5BJ1+lrr3fJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfC4ggr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfC4ggr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD9DC4CEDF;
	Wed, 12 Feb 2025 03:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331229;
	bh=W9moJyOSthIqTIzScajKcTkM1UAQKE86/OXPg8I1Au8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cfC4ggr+t/cSTtKIDFIFm/O7WO+NOvTFMuBHsHSPKbe24uspn4RhPLVFc0V8od5LW
	 RqQwZZnwQdPzIkkDJAqMsisBHCbftj94rJmWIQ43exNu0/GQNRMj9+4ok6b2TYLQhS
	 vG4ETSLTtGGUrwr89w5EIHhMd9/Sh/u5PhxCbmSNcpy1gPmMNxTgjFpU1aCa6yuD/K
	 1hOh8SPow8SUYmWsP3IyFYtDqb0kj388Mm5tODHoB0pKuLlD9rpL5bQ5D168CWb13j
	 +cWu1kBIoVa1vYarS+iO7fpqQBo3++zWssFK0+ewmON0Z9ZuiCkHJbNZkegbF5OGrR
	 ny5u+WJQQmdBA==
Date: Tue, 11 Feb 2025 19:33:48 -0800
Subject: [PATCH 12/34] fuzzy: kill subprocesses with SIGPIPE, not SIGINT
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094538.1758477.11313063681546904819.stgit@frogsfrogsfrogs>
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
index 0a2d91542b561e..e9df956e721949 100644
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
+	pkill -PIPE --parent $$ xfs_io >> $seqres.full 2>&1
+	pkill -PIPE --parent $$ fsx >> $seqres.full 2>&1
+	pkill -PIPE --parent $$ xfs_scrub >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
@@ -1209,6 +1207,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Wait for the remaining children to exit.
 	echo "Waiting for children to exit at $(date)" >> $seqres.full
 	wait
+	echo "Children exited as of $(date)" >> $seqres.full
 
 	# Ensure the scratch fs is also writable before we exit.
 	if [ -n "$__SCRUB_STRESS_REMOUNT_LOOP" ]; then

