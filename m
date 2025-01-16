Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D00244F88;
	Thu, 16 Jan 2025 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070208; cv=none; b=jwwmww1Sjv06quk3qyHPnawHy4UPFUc5tFP9R9Y6rMCJ2xjyzRyeCQJBzUcYkXXxtX2Apa/rQfgE0qdv2WhuYwg9/Z6oGskLcsDfqJHC9woc2ilxsb/cH81ubPPsqmN1OTVoIKf0PEGynyBXRj0EqDMnAi9dyRFeswj7qKgSIlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070208; c=relaxed/simple;
	bh=8W4jon+wBP5T2YfRVfvvWAa61PCluVstIBpzRPPKUtQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfX0SBUPVeeqGNWUd9acbOdUtSDs4kOudanRDUJ9OOM+TlvL1Z0UJedbB/JQna0rBD4fBAJ4Paroeu/JKNjri19CMEuZ6/rElguszgXx/yosc+sxNbKgkm65K28DyvB3blagHemZIGbKQJ7ipJrEzDlf33AbNdRtU9M+R6qzkUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dq509AcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dq509AcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F1DC4CED6;
	Thu, 16 Jan 2025 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070207;
	bh=8W4jon+wBP5T2YfRVfvvWAa61PCluVstIBpzRPPKUtQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dq509AcFegUcW7DKuOGSKbBIr+AMDH1rRmkUys8q82YbiHcb15XQ54XnaMwKtoMaY
	 G83RQMoFx+jCOKynjrkfalHZKtPP1k0FzS0L6SFZoSShAkNWSHMXEvKEmfVfIlFZoB
	 z3MCnuKX9+/fJY+6B+M+JrZHwf62b9LsVFzNzyJ9/mJtHqYF5oEi7mkEx3tDWOquXm
	 uEzwF5hYMeO9kZou5ZqLDz9JQdYCbs553HCggx7QlLOJMgeCCkAEYm7bg+/k27bXt9
	 uRqOfnhNjlyZNLHiWW9L1LViLab9bPvMj0+Xtphkyz6LalsV0xInlgC8NHIWBWNdDJ
	 nmcc7QbLVNhOg==
Date: Thu, 16 Jan 2025 15:30:07 -0800
Subject: [PATCH 19/23] common/rc: don't copy fsstress to $TEST_DIR
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974363.1927324.3221404706023084828.stgit@frogsfrogsfrogs>
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

Now that we can pkill only processes that were started by this test, we
don't need to copy the fsstress binary to $TEST_DIR to avoid killing the
wrong program instances.  This avoids a whole slew of ETXTBSY problems
with scrub stress tests that run multiple copies of fsstress in the
background.

Revert most of the changes to generic/270, because it wants to do
something fancy with the fsstress binary, so it needs to control the
process directly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |   14 +++++---------
 tests/generic/270 |   10 ++++++----
 tests/generic/482 |    1 +
 3 files changed, 12 insertions(+), 13 deletions(-)


diff --git a/common/rc b/common/rc
index d7f3c48eafe590..25eb13ab2c5a48 100644
--- a/common/rc
+++ b/common/rc
@@ -56,11 +56,9 @@ _pgrep()
 # task name to kill.
 #
 # If tasks want to start fsstress themselves (e.g. under a different uid) then
-# they can set up _FSSTRESS_BIN and record _FSSTRESS_PID themselves. Then if the
-# test is killed then it will get cleaned up automatically.
+# they can record _FSSTRESS_PID themselves. Then if the test is killed then it
+# will get cleaned up automatically.
 
-_FSSTRESS_BIN="$seq.fsstress"
-_FSSTRESS_PROG="$TEST_DIR/$seq.fsstress"
 _FSSTRESS_PID=""
 _wait_for_fsstress()
 {
@@ -71,7 +69,6 @@ _wait_for_fsstress()
 		ret=$?
 		unset _FSSTRESS_PID
 	fi
-	rm -f $_FSSTRESS_PROG
 	return $ret
 }
 
@@ -80,8 +77,8 @@ _kill_fsstress()
 {
 	if [ -n "$_FSSTRESS_PID" ]; then
 		# use SIGPIPE to avoid "Killed" messages from bash
-		echo "killing $_FSSTRESS_BIN" >> $seqres.full
-		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
+		echo "killing fsstress" >> $seqres.full
+		_pkill -PIPE fsstress >> $seqres.full 2>&1
 		_wait_for_fsstress
 		return $?
 	fi
@@ -89,8 +86,7 @@ _kill_fsstress()
 
 _run_fsstress_bg()
 {
-	cp -f $FSSTRESS_PROG $_FSSTRESS_PROG
-	$_FSSTRESS_PROG $FSSTRESS_AVOID "$@" >> $seqres.full 2>&1 &
+	$FSSTRESS_PROG $FSSTRESS_AVOID "$@" >> $seqres.full 2>&1 &
 	_FSSTRESS_PID=$!
 }
 
diff --git a/tests/generic/270 b/tests/generic/270
index d74971bb535239..ce51592004fe77 100755
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -28,8 +28,8 @@ _workout()
 	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
 	echo "fsstress $args" >> $seqres.full
 	# Grant chown capability 
-	cp $FSSTRESS_PROG $_FSSTRESS_PROG
-	$SETCAP_PROG cap_chown=epi $_FSSTRESS_PROG
+	cp $FSSTRESS_PROG $tmp.fsstress.bin
+	$SETCAP_PROG cap_chown=epi $tmp.fsstress.bin
 
 	# io_uring accounts memory it needs under the rlimit memlocked option,
 	# which can be quite low on some setups (especially 64K pagesize). root
@@ -37,7 +37,7 @@ _workout()
 	# io_uring_queue_init fail on ENOMEM, set max locked memory to unlimited
 	# temporarily.
 	ulimit -l unlimited
-	_su $qa_user -c "$_FSSTRESS_PROG $args" > /dev/null 2>&1 &
+	_su $qa_user -c "$tmp.fsstress.bin $args" > /dev/null 2>&1 &
 	_FSSTRESS_PID=$!
 
 	echo "Run dd writers in parallel"
@@ -50,7 +50,9 @@ _workout()
 		sleep $enospc_time
 	done
 
-	_kill_fsstress
+	_pkill -PIPE -f fsstress
+	pidwait $_FSSTRESS_PID
+	return 0
 }
 
 _require_quota
diff --git a/tests/generic/482 b/tests/generic/482
index 0efc026a160040..8c114ee03058c6 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -68,6 +68,7 @@ lowspace=$((1024*1024 / 512))		# 1m low space threshold
 
 # Use a thin device to provide deterministic discard behavior. Discards are used
 # by the log replay tool for fast zeroing to prevent out-of-order replay issues.
+_test_unmount
 _dmthin_init $devsize $devsize $csize $lowspace
 _log_writes_init $DMTHIN_VOL_DEV
 _log_writes_mkfs >> $seqres.full 2>&1

