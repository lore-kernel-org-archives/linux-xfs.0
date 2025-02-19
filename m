Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDFC14A639;
	Wed, 19 Feb 2025 00:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926392; cv=none; b=VyWXd2yHtK/G1YTVJQeP+N20/JF1yJoXEclar3xkYXdE6Shq/AnkDwRjatCHZ/xoNK9N8ktWMJ5yCIcWyuIVOS4YMxFT0jVpWg9dntEUYY1j9p2PIMt4+Q+ObfJdvA+muY6QjRjfoxOUEtKurb6zVEB/ilLjfuHJgrCwlAaM3vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926392; c=relaxed/simple;
	bh=37mFLD5t0rY0DIIzDZFAZ5pAmMYzYzqJFNWPnQInqRU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mkx/bKSo0G4eDbkUvU8aOrW78FrCcJWeKJvJrFV+YEfMYE3OA6mb+50iXWB05h0fbD9g4F6Gec8ODASLEfjW0OgoAU3s4BWZ3wt2TkXC1hiHuRWbLM5dJwRqdGMss/UTNWQEYJds93S+fBHy1K7eizL0YCT9hd3TN5KIqPSjHwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYWtX8q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYWtX8q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468F9C4CEE2;
	Wed, 19 Feb 2025 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926392;
	bh=37mFLD5t0rY0DIIzDZFAZ5pAmMYzYzqJFNWPnQInqRU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HYWtX8q7LV2Y5KNBODXXXF9Rx6VvRZjgklCyJog0cSG2iqLc8R7Lsy6mTB6z3mlaP
	 El0TGEhD7BkKXpwZHH/UK7wwXO3OyP6UOysMGlL6QGbfa2wvyZN0Y1WK9JlA753ocX
	 Eu6ReobdtgbOZjcR4CF22JsadMZWrrFf17upLzS/nvX/B+qUPLLechayzdXUsQlgrL
	 UKMghm+9bbljKEpB+GSALPLFJCbsAsfVzVnEAiwupBR9Fz61bQ+WD4wL3+R0qSe7Ar
	 f2yE8lbdLIfA4Rxp5x9Sfzva2y5ozqvfG5R/TORPHUuF8nW8PttZ/2UjaWQocaaf1+
	 g0cpfzFb0gArw==
Date: Tue, 18 Feb 2025 16:53:11 -0800
Subject: [PATCH 11/12] xfs/28[56],xfs/56[56]: add to the auto group
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587607.4078254.10572528213509901449.stgit@frogsfrogsfrogs>
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

Enable /some/ testing of online fsck for everybody by adding these two
fsstress tests and two fsx tests to the auto group.  At this time I
don't have any plans to do the same for the other scrub stress tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/285 |    2 +-
 tests/xfs/286 |    2 +-
 tests/xfs/565 |    2 +-
 tests/xfs/566 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/285 b/tests/xfs/285
index f08cb449b61ad4..205f8cdf943e47 100755
--- a/tests/xfs/285
+++ b/tests/xfs/285
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub fsstress_scrub
+_begin_fstest auto scrub fsstress_scrub
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/286 b/tests/xfs/286
index 046638296e04c6..abc4cafdb0992f 100755
--- a/tests/xfs/286
+++ b/tests/xfs/286
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair fsstress_online_repair
+_begin_fstest auto online_repair fsstress_online_repair
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/565 b/tests/xfs/565
index 43185a253d4d71..d07706b3815b21 100755
--- a/tests/xfs/565
+++ b/tests/xfs/565
@@ -8,7 +8,7 @@
 # or livelock.
 #
 . ./common/preamble
-_begin_fstest scrub fsstress_scrub
+_begin_fstest auto scrub fsstress_scrub
 
 _cleanup() {
 	cd /
diff --git a/tests/xfs/566 b/tests/xfs/566
index 5398d1d0827ca2..2667e25f239559 100755
--- a/tests/xfs/566
+++ b/tests/xfs/566
@@ -8,7 +8,7 @@
 # crash or livelock.
 #
 . ./common/preamble
-_begin_fstest online_repair fsstress_online_repair
+_begin_fstest auto online_repair fsstress_online_repair
 
 _cleanup() {
 	cd /

