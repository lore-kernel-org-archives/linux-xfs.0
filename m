Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A91B78F26;
	Tue, 21 Jul 2026 03:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604259; cv=none; b=tYFeaeA+4KpCh87spqn7t0tEVZ1PYiLmO7Y6ex5sAGqVL1yahCyV5f3OSe4DCPkAV0VKuVbw93V4r/y1bCOMpEicTCw+buiQ3BBdyTTKShrq4nK2KPImcO1LoPErdGOvXjLku1NlPeQf0nezLk9VpvrrOfIAMNCMFGkHB0Hm7qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604259; c=relaxed/simple;
	bh=iUhmL8tLsaO/FvAOCIdQds7shdxj8r+i2BVho/qJevY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BqOO8k5YrWVF04ixEcALsVf0jlo8iNDJRnYYoSi3/5WHFYgHalHimEAipAYeIXpqrRVX3NdUUoWslwBlFtiSJbuRG1p6WL++TGOMBHKFPIfx49O9ynyzE4UrSUBvzVyclIeEXIabJyAR4T3gC4LKPJTq9PaloXG4trUdfhba9Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aB8hc/5r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aB8hc/5r"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1C97E1F000E9;
	Tue, 21 Jul 2026 03:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604258;
	bh=HRUhhQaSCPfZF8ep5OYl+Xsq2VwLW1WNf2Puu5yH61g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=aB8hc/5r06kbL+8R5urd0wuTMNPWJruirvbWFumZKFfKb6h6NRhOVYOxOsjUUPbA2
	 SrOQLpBibK7M0PBkSPgVCjWGMkWTJzoJsPXVE/8FFZwW/+Iln7jtqfx/xRR5T11fPL
	 OAY0zcU/GWGrnsuwKCmNZ4+VvNlMQN428eMUJ6DU+9tL6hPv5TTu8e8wkLG9QaE1Xz
	 9tpJodU9MHYuLdReB+6584DSuLNZfGwA04amwOnVM42yw1Mrx3Uoq+iJKMMUewr4pN
	 d28SfNaXJj3N6FMjOQ8AYij/3UKTfeM8mFJ7axj6DNWA6udidu/cVxN1Fr8X98U24a
	 i8teHQ3Zfw7PQ==
Date: Mon, 20 Jul 2026 20:24:17 -0700
Subject: [PATCH 3/5] xfs: rtsummary scrub should treat rtbitmap corruption
 errors as an xref error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419149.830618.14920105685278204532.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
References: <178460419060.830618.6327864598367400225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notes the discrepancy between the comment saying that this is an
xref error and the code, which marks a (non-xref) corruption error.
This appears to be a regression.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtsummary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 78f72a0468870e..546b335ade1354 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -358,7 +358,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ip_set_corrupt(sc, rbmip);
+		xchk_ip_xref_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (error)

