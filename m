Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D163597E;
	Wed, 12 Feb 2025 03:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331245; cv=none; b=YrV1vkitDj1BU5BrXGkBhFM37F7gwX07xZ4Zw17XRjPgexL95F827MIjDds5djgpgbnO0p5N+973/GaxH19G8z1buQfM841beqFStifVI4g/KZPWmS/Cik9JDKWFvZz+iqmgCGrtBW8b/3iOxzGQmK5mmXujA/cXOfpg0zsqo/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331245; c=relaxed/simple;
	bh=o87ENMa59SkKVdaD6335LOnuYD1d1UGgqASmgUSXwkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZYy3Np5oYT4+1z5AxqR6OMUZiUBh/NeJsularYvhQKcKaUINAtVWWFcxIWSexGXwxX+ACM7M9Relq2BNGBSQIKA6oNR+2VkATRCWaf7FLjVUP7fsOSkuGBonpDWKp63vIl2qhPRGITjoxzFHiPDfxBo6Miy3kFdAMkR/V1R3xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhIL86Lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhIL86Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE395C4CEDF;
	Wed, 12 Feb 2025 03:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331244;
	bh=o87ENMa59SkKVdaD6335LOnuYD1d1UGgqASmgUSXwkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZhIL86LcNsFFQha8axXrsFbZQJefkoWemNlosbkaROEQfGOYw3ByvHUVBmI4PG5tg
	 ZaGXluRO6BVYQSCa4CPvZgKHGRMoVM9yEDYVQPrtsc+D6Xb4m/DCVYbkf1eHdna3YW
	 /6y3CnzodVF0J5qVYq74zrrep4d3Y9gApPozViKfdkkV35b2w2Y3hMV3GHReKodXwV
	 rjsaERTnOz99ibVHSMEK7wcVWbI8mv15MZCpg2U7nTrHyIzYK0B0IRnSOANySVMzVZ
	 6IBgvaBjmSdtI1CBIJ1ZFwA0prNgLUTeH44eKIXvVDDqpeSmQEB8Ykbxch2qd3aOaO
	 iTelZAErjZiwQ==
Date: Tue, 11 Feb 2025 19:34:04 -0800
Subject: [PATCH 13/34] common/rc: hoist pkill to a helper function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094553.1758477.3235229217751366131.stgit@frogsfrogsfrogs>
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

Create a helper function to wrap pkill in preparation for the next
patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/fuzzy      |    6 +++---
 common/rc         |    8 +++++++-
 tests/generic/310 |    6 +++---
 tests/generic/561 |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index e9df956e721949..95b4344021a735 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1175,9 +1175,9 @@ _scratch_xfs_stress_scrub_cleanup() {
 
 	echo "Killing stressor processes at $(date)" >> $seqres.full
 	_kill_fsstress
-	pkill -PIPE --parent $$ xfs_io >> $seqres.full 2>&1
-	pkill -PIPE --parent $$ fsx >> $seqres.full 2>&1
-	pkill -PIPE --parent $$ xfs_scrub >> $seqres.full 2>&1
+	_pkill -PIPE --parent $$ xfs_io >> $seqres.full 2>&1
+	_pkill -PIPE --parent $$ fsx >> $seqres.full 2>&1
+	_pkill -PIPE --parent $$ xfs_scrub >> $seqres.full 2>&1
 
 	# Tests are not allowed to exit with the scratch fs frozen.  If we
 	# started a fs freeze/thaw background loop, wait for that loop to exit
diff --git a/common/rc b/common/rc
index 1266f0307a4d7c..54e11dc0f843fd 100644
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

