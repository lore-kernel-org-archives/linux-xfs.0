Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543236492C;
	Thu, 25 Jun 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406263; cv=none; b=OWpRhcMIUDn8D6ha6d8LX4hYG0djL2D3VO92iokRWw4oOJ/Xxiba8oqPSvUTOw/x56YmeGSiyFD0gI7uzPLlpnANcgtkrO05Vn6DEBcRnF7atcBHwJzWDQdMNeuYbao7te3DoUPGpELEmgDqMWZQ3kEnWoxOmo4clNG2hK5cAYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406263; c=relaxed/simple;
	bh=e98MjeoNAElY5waky0SL6/K5c65914HptKF1JLdELZs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=su7TYLElSTv0zHLP/OUUMnuxEnz8hlUXur0BRQiOAy0H53qkMx60LJuEYI1XAwFWlbQ7avSwxBrFkapwAxI1Su+HrOfa0agvtRUrAoYVHloru+pffCI0WXXCikdsMQQapQXkJ00gv6atzqhLNO8z/coj5GVhfzDpOy7EI2CIIxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdPah1gh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdPah1gh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ACE261F000E9;
	Thu, 25 Jun 2026 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406262;
	bh=bM5fyZrmZxJuWGfoLWck6wSKKI7CBreEMYfXmAttyL4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=cdPah1ghNh+ScyUz8lfsGMVBg4l8Kes09558ZNIhOjmHooYx8kxIGEvdjEiIgDJFh
	 /uuVC9xjf1reMKag+nCoF10pL0bNa8qbIFEgPiGNf4l3Ttc+pRZjPAePbjBJDrIfCO
	 LcyR+eIJeXs27BDLX9Fg2LPA122T6wXn3oWPJANGfKBV9+xQN9iofrH3Wafef+KEuj
	 DgzwNp9Dzmv2tLzqnz6sTz40phyVkOOqEDcD2IT7frTypIoorXYFaW8JVJPoh3LH4J
	 +waM6Fn4IEAGmCgSlB0fUEcP08AK2yufEVmOWeW95rzXCIsfpctYeuViXvRXWa73Pu
	 Nu8xNgiPDHPXg==
Date: Thu, 25 Jun 2026 09:51:02 -0700
Subject: [PATCH 1/2] common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: fstests@vger.kernel.org, hch@lst.de, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <178240619650.1665857.270820682280764430.stgit@frogsfrogsfrogs>
In-Reply-To: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
References: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

