Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0D53FE652;
	Wed, 20 May 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303124; cv=none; b=tIo9gyue6k8JlzNmCjyscWPqmWpw915ytvDU6evRsdgTAi5J2ZEKyrtZMpBaP9VNLAk7vIrXc3oLswCUBW9LAirSncEVvgSqnh2pTMGPEIe4/jntHtLiEWa9Z2BP0Zt02OXzEg7iHDutm7VoWmpKjADGk4/mjhANiRyiam3L3GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303124; c=relaxed/simple;
	bh=S9IS+5gtJXSSpxuNaGfrSCotdh3Cj09XFPaf9CWKLYc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bqO6sY7TTp/TCRQ6/j/pDVrm5ICxk8dbPKv1BGDfcDE5ZleRds9s92sYeznUIaplfQq/5DBokxydJx/A6AUeNA3NeIxfQA7sGUPO7wSVQizcP7iO2dz2dwK4COAgkgYE/17lH5bd0mA6OJcZGkA29kOReDEy8eg+TZ5g2hfWblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOdsO7n8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOdsO7n8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 59C801F000E9;
	Wed, 20 May 2026 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779303123;
	bh=fac7YQtva8Ggeq4uKOSfB2rCA9x80cPq9/PKU8QrQD4=;
	h=Date:From:To:Cc:Subject;
	b=mOdsO7n8ZAky+PG1fx54GY4POPndqezFTA+jaoMRDoQS4DOljbFv1RMEe2kRkHU7m
	 TU58aINCYj0mtSl3wB39XgEtGAioPdszSCLJ5ucOTITIPl66tBMjTiuV+jDYSthEMj
	 N5MRHViOrAesWZQhPledGWBsTOscdHb02sk/fppnjajB404MwgFxYhKa30EPq0Clbo
	 1lwe61XC0i6MAyFR8f7P6MiMSv18+oAERawkJWUBg5FGttQTtzwG/5XqtlIaazhcKX
	 bC2Ou8wdITBdQWt4fNeGIM36l2OphsLYhzu4b29Pv5r6j4rvbSfZqOHw4wqNNQfN1n
	 OK8gpsSAPDVnw==
Date: Wed, 20 May 2026 11:52:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 1/2] common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
Message-ID: <20260520185202.GD9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

generic/347 regresses when external logs are in the configuration:

 --- a/generic/347.out		2025-07-15 14:45:15.044714644 -0700
 +++ b/generic/347.out.bad	2026-05-18 23:17:01.687750781 -0700
 @@ -1,2 +1,36 @@
  QA output created by 347
 -=== completed
 +Cannot specify both -l logdev and -l concurrency
 +Usage: mkfs.xfs

Since this actually tests running mkfs.xfs with $SCRATCH_OPTIONS, the
helper ought to have detected that you can't give both.  Unfortunately,
there's a weird switch that turns -l into -d even though they're not
quite the same option.  Delete that, and fix the indentation (tabs, not
spaces) in the helper.

Cc: <fstests@vger.kernel.org> # v2026.05.17
Fixes: 7f162f5bcf50fc ("common/xfs: helper function to check if -l/-d/-r concurrecy flags.")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/common/xfs b/common/xfs
index 4b3a7f7d153282..88299acdd086be 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2431,8 +2431,7 @@ _require_xfs_healer()
 # -l/-d concurrency came in same xfsprogs release v6.7
  _scratch_mkfs_xfs_supports_concurrency()
 {
-    local arg="${1:-d}"
+	local arg="${1:-d}"
 
-    test "$arg" = "-l" && arg="-d"
-    _scratch_mkfs_xfs_supported "$arg" concurrency=0
+	_scratch_mkfs_xfs_supported "$arg" concurrency=0
 }
