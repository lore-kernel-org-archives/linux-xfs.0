Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22916F265;
	Wed, 19 Feb 2025 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926346; cv=none; b=A+sUWh452VDqXnAeolNtiOgi3ZhS7RHaa08nVJdAx5buaSd0QQuXhRP0Y9hCgmpLz87jrOB390Z1uOrLiOz3v3SDzxLQfPOgZTgnNgJF15Kcdp5w3q3b90LoZV61xD0Ky9XM0XnM02QyOJe5fN29X8OroD8VjGYTl4QCxwzmyTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926346; c=relaxed/simple;
	bh=xHdJSNtorQswsndb/ShOlkb0xCKVS5pPKzwLyK9EjAs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgzL/5xK3GDF/iYuXhQvClBveOa8MuHkqqZRj1hKL8ZkfcR6njNE2ovsDUWHAX66Tg6G7GJQ/SIuSEIgHTsdzQH70zfKtsj9A+AR8kkOyD6R4XGoPPnlMpwtW5ZcVxxj16ea6QqbAsmjIS8WZftrKjTFde8UGxTKd5bgRcNrGlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUmQmlBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUmQmlBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59780C4CEE2;
	Wed, 19 Feb 2025 00:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926345;
	bh=xHdJSNtorQswsndb/ShOlkb0xCKVS5pPKzwLyK9EjAs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tUmQmlBHuPdDLCrRGVGqHd9TIlbCN6UOzoBQg+wgkNFwNB/r+dHeb2t2WC+UoNmgV
	 JZmzZ2aP0MQm3L1r8xDrimaMnzWiqCHADOD6dJRm6hwb4AppSEnFVVmGuI3/l5vBRa
	 Mq2IN0lQOl7nlgw/jrvvneeIUgAJfEMgYaJeN1byblstHP2dbj1wPHUHbChn++CSGS
	 fXU8YPWb/dVE9sQd7QNITVcnu8iW+Ek17uofa3qwD1tg6zutiU9b2Z/bWzCXt2NNu2
	 rH2PVx6DTqhH0t0y1/+PWOs5TfWd9PaxJqzgqp/ANbJTJYaRYsMFb/N0C61r4HKlt8
	 rLfUD+OXm2sOQ==
Date: Tue, 18 Feb 2025 16:52:24 -0800
Subject: [PATCH 08/12] misc: fix misclassification of verifier fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587551.4078254.1109177653377657721.stgit@frogsfrogsfrogs>
In-Reply-To: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

All the tests in the "fuzzers_norepair" group do not test xfs_scrub.
Therefore, we should remove them all from 'dangerous_scrub' group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/735 |    2 +-
 tests/xfs/738 |    2 +-
 tests/xfs/745 |    2 +-
 tests/xfs/746 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/735 b/tests/xfs/735
index 861763b3db8bd8..8e927572b6ecd8 100755
--- a/tests/xfs/735
+++ b/tests/xfs/735
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/738 b/tests/xfs/738
index f432607075ca91..e8d2cd2a815f8b 100755
--- a/tests/xfs/738
+++ b/tests/xfs/738
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair
+_begin_fstest dangerous_fuzzers fuzzers_norepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/745 b/tests/xfs/745
index 38a858e8cffd0a..3549ad08772c2c 100755
--- a/tests/xfs/745
+++ b/tests/xfs/745
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair realtime
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/746 b/tests/xfs/746
index e81d4f93a9059f..5afc71ad19c6e6 100755
--- a/tests/xfs/746
+++ b/tests/xfs/746
@@ -8,7 +8,7 @@
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_norepair realtime
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
 
 _register_cleanup "_cleanup" BUS
 

