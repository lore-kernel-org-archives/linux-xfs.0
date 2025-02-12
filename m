Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652911CA9;
	Wed, 12 Feb 2025 06:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739340609; cv=none; b=JXpo+/7aoY7zdt+eX8HurRBtu0JE/F0RzH2xyd1ffXc/o3sov3MxU1xWBlinJRk55BKwO7XnJI2isX4gcqtT8hek908riDTcWMesfRCwxHswlzT9j3e4ganDCEKCRg7Qs0McL3P0tj8FLxWKhHDvLtEo3W6ok6VopAOnE/ODU8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739340609; c=relaxed/simple;
	bh=U/Jkuw9VTuLREYECa5kxeeeM9SLbSx9IMyyyftd//T4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeFpLXCfDz8gKjRTpqyrR1+SWy8nh04cNGvADT8NGEXuE8r+aEXwZkmdFU0jM3zuTcZdho3V8p2I7WTAoZG7WFiVDggM69N46h/bNPNnja99sM9NLgegTnZrrrQFxfpLllQON14zf/k+VS++R2OnS5MzN+u8hm9kbZoQL5QOsJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqTuxrqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqTuxrqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE258C4CEDF;
	Wed, 12 Feb 2025 06:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739340608;
	bh=U/Jkuw9VTuLREYECa5kxeeeM9SLbSx9IMyyyftd//T4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uqTuxrquBImv+zJXVTQq9x4onkQEuqiDYURp3oWWjmy+qHTsU2mibiRTT5ThFxIlG
	 QqIDYdwpxlK51lVMSDqctHYAbFTleAW4hTksTjWM6PfpWT5QzcC8yuYLxTwSrcaKdr
	 //D/VOSnTQLVqvQvovLf+25C5Qtr5wcouhkqF9DojyXe4INb/JKWFOZKOTQ6VH+Cbo
	 mNVsNb5Uit1ojFTjDBOEGDdWO1nzBLVYt0uKCYj+VNDM41wawiHWXST2L3htK9Z5Jh
	 R0KDKUAwHvNFt/Mx4o6Rrul37MvDyg3ElNsb9LIoT/xVl54szWL0rhkX6g2h+fK2m2
	 yP/vk3BgvGv2g==
Date: Tue, 11 Feb 2025 22:10:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 12/34] fuzzy: kill subprocesses with SIGPIPE, not SIGINT
Message-ID: <20250212061008.GJ21808@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094538.1758477.11313063681546904819.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173933094538.1758477.11313063681546904819.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

The next patch in this series fixes various issues with the recently
added fstests process isolation scheme by running each new process in a
separate process group session.  Unfortunately, the processes in the
session are created with SIGINT ignored by default because they are not
attached to the controlling terminal.  Therefore, switch the kill signal
to SIGPIPE because that is usually fatal and not masked by default.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
v3.1: fix bash typo
---
 common/fuzzy |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/common/fuzzy b/common/fuzzy
index f9f2261365d2e2..dd6f04caad60ed 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -900,7 +900,7 @@ __stress_xfs_scrub_loop() {
 	local runningfile="$2"
 	local scrub_startat="$3"
 	shift; shift; shift
-	local sigint_ret="$(( $(kill -l SIGINT) + 128 ))"
+	local signal_ret="$(( $(kill -l SIGPIPE) + 128 ))"
 	local scrublog="$tmp.scrub"
 	local now
 	local compress
@@ -921,8 +921,8 @@ __stress_xfs_scrub_loop() {
 			_scratch_scrub "$@" &> $scrublog
 			res=$?
 		fi
-		if [ "$res" -eq "$sigint_ret" ]; then
-			# Ignore SIGINT because the cleanup function sends
+		if [ "$res" -eq "$signal_ret" ]; then
+			# Ignore SIGPIPE because the cleanup function sends
 			# that to terminate xfs_scrub
 			res=0
 		fi
@@ -1203,13 +1203,11 @@ _scratch_xfs_stress_scrub_cleanup() {
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
@@ -1239,6 +1237,7 @@ _scratch_xfs_stress_scrub_cleanup() {
 	# Wait for the remaining children to exit.
 	echo "Waiting for children to exit at $(date)" >> $seqres.full
 	wait
+	echo "Children exited as of $(date)" >> $seqres.full
 
 	# Ensure the scratch fs is also writable before we exit.
 	if [ -n "$__SCRUB_STRESS_REMOUNT_LOOP" ]; then
