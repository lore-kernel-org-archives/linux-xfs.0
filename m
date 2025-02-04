Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733525A62C;
	Tue,  4 Feb 2025 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704342; cv=none; b=l830KEX5VIj6NmSdndI7vPzvURsywfZ8mndMOO3AxMkPi8WEx2IcK/0jn2VTW6u2Qkl8VsH2WxHR+oopnpJjVtaCKBnSZysSkksaQnoBvhMZYmib2TBbP/wnh5BLKRPiwDihkyzUYjoozNaCtwFD6JCFYGDkj/a6EeBCJRHa2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704342; c=relaxed/simple;
	bh=wjhmYWvvKeHv5Nnsv89yI1WM0LNLpm2sMgPNkrbR+FM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crwP3mF8llhWXmNLqmlmFFMV18BiZw5jkxWmcJ3NdvBA/tWIjs53wFOGeZtAlesSOlBz9qQZ3I8rI4nRyWfoU4Zi+wJeAPhk7fwHWINxMIAW4qv8NxHNxBvNm76P7v5o66/JQ23C2X3nvO/hak2097E7H9HjwUHNxe8rwYE2BAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwZlpdiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwZlpdiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF503C4CEDF;
	Tue,  4 Feb 2025 21:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704342;
	bh=wjhmYWvvKeHv5Nnsv89yI1WM0LNLpm2sMgPNkrbR+FM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IwZlpdivC8wkh0Wf+j6U/qOREd67eQsXZkLMZjVSt541rV997nawVi+TPdv9s/4uu
	 w0kjoRF5FfwvO+nR7meoa5KTybcyFblufsKplnPBpNMmYyY4PAAVBHf+QP2o6v12Dq
	 xPjaH7TvxyobIgnS/TCVp3d25GBh4cyJjBo9oj9hWFGzYykSB6dlQo4EeZ3JivjkPX
	 owDAPplvCMcWquDHA3kEQ3QREULIf4uH+osLVPV/QoOTs3AFw9I9WVisCTsV93HWVH
	 PziiJAF3eBSPABpmNylC+jadE/kCbbBr9a97ZR9e4OzKRpWIR5qrdl+hSuOirkIChr
	 X3+anT8v/H0Iw==
Date: Tue, 04 Feb 2025 13:25:42 -0800
Subject: [PATCH 13/34] common/rc: hoist pkill to a helper function
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406306.546134.16510101936129304399.stgit@frogsfrogsfrogs>
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

Create a helper function to wrap pkill in preparation for the next
patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |    8 +++++++-
 tests/generic/310 |    6 +++---
 tests/generic/561 |    2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)


diff --git a/common/rc b/common/rc
index 9a6f7dce613e62..2b56d6de9c9cb1 100644
--- a/common/rc
+++ b/common/rc
@@ -30,6 +30,12 @@ _test_sync()
 	_sync_fs $TEST_DIR
 }
 
+# Kill only the processes started by this test.
+_pkill()
+{
+	pkill "$@"
+}
+
 # Common execution handling for fsstress invocation.
 #
 # We need per-test fsstress binaries because of the way fsstress forks and
@@ -69,7 +75,7 @@ _kill_fsstress()
 	if [ -n "$_FSSTRESS_PID" ]; then
 		# use SIGPIPE to avoid "Killed" messages from bash
 		echo "killing $_FSSTRESS_BIN" >> $seqres.full
-		pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
+		_pkill -PIPE $_FSSTRESS_BIN >> $seqres.full 2>&1
 		_wait_for_fsstress
 		return $?
 	fi
diff --git a/tests/generic/310 b/tests/generic/310
index 52babfdc803a21..570cc5f3859548 100755
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -29,7 +29,7 @@ _begin_fstest auto
 # Override the default cleanup function.
 _cleanup()
 {
-	pkill -9 $seq.t_readdir > /dev/null 2>&1
+	_pkill -9 $seq.t_readdir > /dev/null 2>&1
 	wait
 	rm -rf $TEST_DIR/tmp
 	rm -f $tmp.*
@@ -83,7 +83,7 @@ _test_read()
 {
 	 $TEST_DIR/$seq.t_readdir_1 $SEQ_DIR > /dev/null 2>&1 &
 	sleep $RUN_TIME
-	pkill -PIPE $seq.t_readdir_1
+	_pkill -PIPE $seq.t_readdir_1
 	wait
 
 	check_kernel_bug
@@ -97,7 +97,7 @@ _test_lseek()
 	$TEST_DIR/$seq.t_readdir_2 $SEQ_DIR > /dev/null 2>&1 &
 	readdir_pid=$!
 	sleep $RUN_TIME
-	pkill -PIPE $seq.t_readdir_2
+	_pkill -PIPE $seq.t_readdir_2
 	wait
 
 	check_kernel_bug
diff --git a/tests/generic/561 b/tests/generic/561
index afe727ac56cbd9..b260aaf16c9256 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -40,7 +40,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
-		pkill $dedup_bin >/dev/null 2>&1
+		_pkill $dedup_bin >/dev/null 2>&1
 		wait $dedup_pids
 		rm -f $dedup_prog
 	fi

