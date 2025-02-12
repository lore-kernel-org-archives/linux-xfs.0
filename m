Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763DD271839;
	Wed, 12 Feb 2025 03:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331307; cv=none; b=LsmR2jw+i6lNqkAKYNltRzx8ocQ5dw1/QHfvAf5C3O7yu3rvqxOR0iPLFCVzcZmbipGsaof95CrFXWKKgFW8DrnYxAGB7H03LuDyPDCyeIo1e3yvNeQsKyWCXD9JhvS9TeafY5YevHezQU7f3zNu6h6HEmPOFDjIlr6162mL7MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331307; c=relaxed/simple;
	bh=PywwwPANMMP0s8YhUCPCTqq8oG9dq07WZayJ9PWOhd0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cps44l7epHYKGkbUa+wjacvZ5LKF2yOKqwMY/jryKGcu7RemoAf6+fzgyY/9unxQXYRghb9oOoLsJiq2fUn75/F4f/BIHrR/SmTycEdiZzp+l3gEHNXdIS2QCXnDq5Lhas+zIJvdR40iWnxmeX8APDgzT4pdlimPxlLXGgqa9dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZRmcUID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZRmcUID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1AAC4CEDF;
	Wed, 12 Feb 2025 03:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331307;
	bh=PywwwPANMMP0s8YhUCPCTqq8oG9dq07WZayJ9PWOhd0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QZRmcUIDmXenX4CZ9vOhdtQjKDjWICCiUkKmcqh/puiI2OHoFyxhOfbQsr0o0Q9CK
	 CTD94RrMZhz6fGIvLXvC5fxSuGR1Ft1SO/kmwEqCO1REANxsjfbnebtB7F1ZNw1YX0
	 9Nc6vNKALnm5Ar1SeszI+JFl77ERvqiLCnlyuq9SFmxYpkb/yxDcSNQbyHIKmDIKnq
	 +/H68wOA+JOfxwl8HnjVRX7y6d1LxC4ElJ85SsL9DMJJ/p2Hmn6ZhmAkuUk2jHrsLH
	 oqvL86ZtN4JxaNtUEBGFwFcdmQlvcESFXXqkgYYTkNln8gu++sEz4gytFs8nU+Lbon
	 QFelM6CnWQkfw==
Date: Tue, 11 Feb 2025 19:35:06 -0800
Subject: [PATCH 17/34] common/rc: don't copy fsstress to $TEST_DIR
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094615.1758477.4760929380347908128.stgit@frogsfrogsfrogs>
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

Now that we can pkill only processes that were started by this test, we
don't need to copy the fsstress binary to $TEST_DIR to avoid killing the
wrong program instances.  This avoids a whole slew of ETXTBSY problems
with scrub stress tests that run multiple copies of fsstress in the
background.

Revert most of the changes to generic/270, because it wants to do
something fancy with the fsstress binary, so it needs to control the
process directly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/rc         |   13 ++++---------
 tests/generic/270 |   10 ++++++----
 2 files changed, 10 insertions(+), 13 deletions(-)


diff --git a/common/rc b/common/rc
index 8d42396777c950..46581976a6ce8c 100644
--- a/common/rc
+++ b/common/rc
@@ -54,11 +54,9 @@ _pkill()
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
@@ -69,7 +67,6 @@ _wait_for_fsstress()
 		ret=$?
 		unset _FSSTRESS_PID
 	fi
-	rm -f $_FSSTRESS_PROG
 	return $ret
 }
 
@@ -78,8 +75,7 @@ _kill_fsstress()
 {
 	if [ -n "$_FSSTRESS_PID" ]; then
 		# use SIGPIPE to avoid "Killed" messages from bash
-		echo "killing $_FSSTRESS_BIN" >> $seqres.full
-		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
+		_pkill --echo -PIPE fsstress >> $seqres.full 2>&1
 		_wait_for_fsstress
 		return $?
 	fi
@@ -87,8 +83,7 @@ _kill_fsstress()
 
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

