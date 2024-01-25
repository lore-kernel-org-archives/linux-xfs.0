Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E8537E3;
	Thu, 25 Jan 2024 19:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209533; cv=none; b=QMqsgDArRJ7b1Ymx1Xks+gYsGGu8v4rYT14bxPjcFCIkjwd5NLLeUQURTSyVTCUsvkUg1XhSYQ6eDMQTIVdVYzpNZ8KJi8ky3175oty5O4GdVk3uQbE474WG7uInx3ijjsEPtHwlZEx0WnjeeFPRYXu8YcURDNXIuCBVUBs2zUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209533; c=relaxed/simple;
	bh=ZCFloK9HuTCJHwMc9UDEL6A7rdoZQY8gSpEeIR0fe5c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhP8T42AZU6Iibc8FywhTkBbrlPMP43zrv/AlBlcgdZ+xmH/myJe8s8rjp7xvDA1tMVdq8yWmTQGFae5zgmm5qnWm3+sIkhjZr2/kQvV8BZ/8vu/okvhLIBg3xYSnqkQk2QUvjbyJ0XUyZhoIcG9WP7c5pwxSzorlMN2UJKvwqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5AbLLwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5AbLLwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0728C433F1;
	Thu, 25 Jan 2024 19:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209533;
	bh=ZCFloK9HuTCJHwMc9UDEL6A7rdoZQY8gSpEeIR0fe5c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n5AbLLwVXh58GvO7VcoyqM9dgQurvTq9n4WowhcDqd/bSMtOkYooJH4C3eR3mls8c
	 kgwy69Xf0wbitg4lTz6jB/d5HJiH2GoZu80rfseCUULOWajA+olsVH2hqXpTjZ6rQ6
	 U0X3wASdHvas3vfNb/28fAvCNT7WQ7NWVCtlRj7iWGnwC7B4dQ4CARrKwUumwQ2hON
	 BIYsV4NYmnHhCSdZu3epohxflu1XVZnPWMl1yoemE6DL1e2rXvdYQZZLQJD452YAWz
	 OrG0DGzMzS+0rcMSDxJHAh9ICEQQdw4k0iCFiAhzefz66SAPRtYX3kPlNCDez7OWd0
	 U4MBnZtEUiAsA==
Date: Thu, 25 Jan 2024 11:05:32 -0800
Subject: [PATCH 06/10] xfs/{129,234,253,605}: disable metadump v1 testing with
 external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924449.3283496.4305194198701650108.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

The metadump v1 format does not support capturing content from log
devices or realtime devices.  Hence it does not make sense to test these
scenarios.  Create predicates to decide if we want to test a particular
metadump format, then convert existing tests to check formats
explicitly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs_metadump_tests |   25 ++++++++++++++++++++-----
 tests/xfs/605             |    9 ---------
 2 files changed, 20 insertions(+), 14 deletions(-)


diff --git a/common/xfs_metadump_tests b/common/xfs_metadump_tests
index dd3dec1fb4..fdc3a1fb10 100644
--- a/common/xfs_metadump_tests
+++ b/common/xfs_metadump_tests
@@ -23,6 +23,24 @@ _cleanup_verify_metadump()
 	rm -f "$XFS_METADUMP_FILE" "$XFS_METADUMP_IMG"*
 }
 
+# Can xfs_metadump snapshot the fs metadata to a v1 metadump file?
+_scratch_xfs_can_metadump_v1()
+{
+	# metadump v1 does not support log devices
+	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && return 1
+
+	# metadump v1 does not support realtime devices
+	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && return 1
+
+	return 0
+}
+
+# Can xfs_metadump snapshot the fs metadata to a v2 metadump file?
+_scratch_xfs_can_metadump_v2()
+{
+	test "$MAX_XFS_METADUMP_VERSION" -ge 2
+}
+
 # Create a metadump in v1 format, restore it to fs image files, then mount the
 # images and fsck them.
 _verify_metadump_v1()
@@ -115,9 +133,6 @@ _verify_metadump_v2()
 # Verify both metadump formats if possible
 _verify_metadumps()
 {
-	_verify_metadump_v1 "$@"
-
-	if [[ $MAX_XFS_METADUMP_FORMAT == 2 ]]; then
-		_verify_metadump_v2 "$@"
-	fi
+	_scratch_xfs_can_metadump_v1 && _verify_metadump_v1 "$@"
+	_scratch_xfs_can_metadump_v2 && _verify_metadump_v2 "$@"
 }
diff --git a/tests/xfs/605 b/tests/xfs/605
index af917f0f32..4b6ffcb2b4 100755
--- a/tests/xfs/605
+++ b/tests/xfs/605
@@ -40,15 +40,6 @@ testfile=${SCRATCH_MNT}/testfile
 echo "Format filesystem on scratch device"
 _scratch_mkfs >> $seqres.full 2>&1
 
-external_log=0
-if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
-	external_log=1
-fi
-
-if [[ $MAX_XFS_METADUMP_FORMAT == 1 && $external_log == 1 ]]; then
-	_notrun "metadump v1 does not support external log device"
-fi
-
 echo "Initialize and mount filesystem on flakey device"
 _init_flakey
 _load_flakey_table $FLAKEY_ALLOW_WRITES

