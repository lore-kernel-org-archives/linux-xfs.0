Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C71192D8E;
	Wed, 19 Feb 2025 00:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926330; cv=none; b=D7LP7jQN/dqI+T/obNktyKP1fAp2MubY3xPM3eV3WCJoiXj9lNmDcgT5+6CkZ4c6Sd14RG4i+1HUExuCvEGZHH/UJtQuuuj7+v7YoC5UZMIYVvPtQl0rZY6TXv9oI1oKY5GzkEjIlSlpGxoDmaUvtgcbOvBOvO74P0MbZitGusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926330; c=relaxed/simple;
	bh=FGqqXrHLLmbXjyGkCTLfY/bK7c58Qye7G00zy8XPaT8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eTKOC9M0eFB44g8rZwBUEuLMwfsSQupVfRl8GWUO+5ZOm8BnoP3VTn2wNHz3cei8++0Vv/T8ObAHRMX8ahXw/b/xLHKJpyeQHG4JdODjIemdzu7OH8y/Hy7Y5sZrTI4CWNahGbJsX896/OW7IciPembLZbH9kD0U2BstK7z8vyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbME9mEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbME9mEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D43C4CEE2;
	Wed, 19 Feb 2025 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926329;
	bh=FGqqXrHLLmbXjyGkCTLfY/bK7c58Qye7G00zy8XPaT8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mbME9mEnLN3MfYLlGyYfeNKhXZJk4pzsoYyUIgdWjUsaOcts0VN3LwiVrl2gq6fT9
	 lyEye/apIGf64s++qXzCBGwG4GeEgsHLp+wq7qNH2/oG65/gLfL8kB/nU8VM+A7NPM
	 d/+s0HaB4rdYXwQjjxFLxoYNXI/zsZyF1bQrlyxfTjbV9OGc9+2HHwl6CfQYOJaWiM
	 KN4MqKVCw/Ddvn/UGcH4pkIsqWeYiWM0abn+KyuuGjiWGTHH2peUSfQqdOGUj5KC9j
	 9zhXdzHowGwDYC96tRpOcEttlKYpMLEdyUKSL/M0dRzhHPvKU/1IOUTTTl/xzfjL2t
	 gPlEQ4xOdjaRw==
Date: Tue, 18 Feb 2025 16:52:09 -0800
Subject: [PATCH 07/12] misc: fix misclassification of xfs_scrub + xfs_repair
 fuzz tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587533.4078254.9647021431489098153.stgit@frogsfrogsfrogs>
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

All the tests in the "fuzzers_bothrepair" group actually test xfs_scrub
and xfs_repair.  Therefore, we should put them in the 'repair' group.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/743 |    2 +-
 tests/xfs/744 |    2 +-
 tests/xfs/783 |    2 +-
 tests/xfs/784 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/743 b/tests/xfs/743
index 90b3872440cb07..1dcb79bc46fe48 100755
--- a/tests/xfs/743
+++ b/tests/xfs/743
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/744 b/tests/xfs/744
index e7778417b53ff4..7b554e977b20d2 100755
--- a/tests/xfs/744
+++ b/tests/xfs/744
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair realtime
+_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair realtime
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/783 b/tests/xfs/783
index dcb1292217d37d..79bf34c1b2bd12 100755
--- a/tests/xfs/783
+++ b/tests/xfs/783
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 
diff --git a/tests/xfs/784 b/tests/xfs/784
index 286797257e025e..99d84545c90e79 100755
--- a/tests/xfs/784
+++ b/tests/xfs/784
@@ -9,7 +9,7 @@
 # to test the most likely usage pattern.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers dangerous_scrub fuzzers_bothrepair
+_begin_fstest dangerous_fuzzers dangerous_scrub repair fuzzers_bothrepair
 
 _register_cleanup "_cleanup" BUS
 

