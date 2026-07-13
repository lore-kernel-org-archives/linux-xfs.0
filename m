Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411D5306776
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783958113; cv=none; b=X7qPNXaR1tIdFAUsOCm3Gp1Fx91jYKCOaI/DVpsao8TmJ0KvWCWMUonL1x7CRQ+klrMM3tSCtEwkVx9xcO4AXLKI/q2Q6bbxr9xuBU3Iqd/rvSuegm6jx/dV6jolsHn0mHjstOuXPLBYFlwjcPmhkTMwBUCe/FtC5uL1Gfpc0Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783958113; c=relaxed/simple;
	bh=nPiMKaNaCGZQTubwZ+C3FVPYNCmEzKtwiCyHOrQB/HY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=T6gx0n+WSf9hbK6InfqUmM+3rLnhOcUccqVLw+3qNsKYJa70Rkr+cAME24rdniCkBgwMDNFdJZHBS+WCoexXXY/vRyMIn3znWPoOLzRPTiBj6fMJE4q8rtFYu6gdE18VV64VCaR6sTAy4/YX196ug3WM/LseERup+Gb+wJsOriE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtZ4Z3CG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtZ4Z3CG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 842D91F000E9;
	Mon, 13 Jul 2026 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958110;
	bh=ABExAm9lgPYeTR8Bkzu/+OYDQzmK22l1fpYly3nHugU=;
	h=Date:From:To:Cc:Subject;
	b=JtZ4Z3CGiCo51XWQeOviqHH2SLR2mL/ixJs2TnD20fPTZ8KclLpL5M+y5/UuRmVvf
	 xqzWKYR8U6oKBXqvw2mmM3kmGdWbAIwkR+cksffq2hOiSIZmGqv43cIyIbnllQ+UBK
	 fLF6MEAhdsz3DXuoJG0BYZEP67apG6vZ099OJPl8U77VqLzttlUE9Tel6aMBybiAMx
	 EGfkhYIGZmmjHu2D7T88PMIUdKXaoO9Xipoa0uYuHY0A9wmwI++8VIV+bT2lvbpdWb
	 eKp/3SbaIQE5tLNSZ8q14o6DQ6fvralYTct2oiPFwkbJaDmnxRQYJBmxLiY/n0+gLj
	 rI1GqDyj9F+rg==
Date: Mon, 13 Jul 2026 08:55:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH] xfs_scrub: fix spacemap scan for data volume
Message-ID: <20260713155510.GD7195@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I don't know why this hunk got copied into scan_ag_rmaps on merge.  The
original patch only touched scan_rtg_rmaps.  Get rid of this new
inclusion because now it's broken for the data device.

Cc: <linux-xfs@vger.kernel.org> # v7.1.0
Fixes: 074c18165ea339 ("xfs_scrub: fix spacemap scan for internal rt devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/spacemap.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 26d05163bde971..65d716374c9eb3 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -111,19 +111,6 @@ scan_ag_rmaps(
 	keys[1].fmr_offset = ULLONG_MAX;
 	keys[1].fmr_flags = UINT_MAX;
 
-	/*
-	 * fsmap for an internal rt volume treats physical ranges as offsets
-	 * into the underlying block device.  Shift the query range up by
-	 * @rtstart here to skip the synthetic "internal filesystem" fsmap.
-	 */
-	if (ctx->mnt.fsgeom.rtstart) {
-		uint64_t	offset = ctx->mnt.fsgeom.rtstart *
-					 ctx->mnt.fsgeom.blocksize;
-
-		keys[0].fmr_physical += offset;
-		keys[1].fmr_physical += offset;
-	}
-
 	if (sbx->aborted)
 		return;
 
