Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB54A33A03A
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428163; cv=none; b=JZK480uNeiDF6Il1K9M5+mP7cbCoi8+PZB2sVgBzXAIPqCFGbXGf+Hm6AVT6AO4xpQSBfr1zKyqGO5swwVFwKx8F1hd62Mm+Xl9cJRUavHlMwk2nMSEg1tZgGN/M57fHWnbRtpPNB5swK1EfMpvCeGnfsN6m8gThhmpcvCOWj3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428163; c=relaxed/simple;
	bh=sqx0NExX3AesspSfN2UpDKrBEtwvACE3oWn3bBYuoP0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMWmhQZVkUFdL62VUzJT33EVlak6B67jM+zfRJDTF+T6BOXQsGd4b0riD49n7y7CDzg32TTIJqTc3c+6ULJWNHbgx/1vujB0pKc/WwNPSJsZKjILROoZvSg84lOyqrNFmf7XbsWSqQs8QORTwhn/ukLKiR+0rEoE/Xnat5UTnKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncekVSkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncekVSkY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7E90D1F000E9;
	Thu, 25 Jun 2026 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428162;
	bh=fEAQvHQjhrdhN9zj3btAYYNE720Qskx/ECkHr9ag0lw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ncekVSkY6xTKsRy83tYaGkB47/YItZop+fNMfPcULNxTMCS4KCV98kPWX4nmXWkul
	 dfwV6rqTCXXpQ6ci1rzv5VK1Guf66ZROS+9cy1sBvFeWBQSdn5iisEwqoGJt8kZGg5
	 vRoLmHGLzci9rUSMjiaUlW+B8bWZJEhGfhPeDYzuHMALESbtolDH5kLtfTlSG2ccLH
	 UE9kS0hpetXkxsSZpNiWtkujuyyyYvs1jJ/INeBx+taZvBgPJvFdnIN+Gxr85O8jl6
	 /HWarFncLNw22rLewXJuuTO5HD0GFW/KkBx5zGK9ROcXAnsunG07hdx879JtHEsaJK
	 Oylg+3C1gbH/g==
Date: Thu, 25 Jun 2026 15:56:02 -0700
Subject: [PATCH 7/8] xfs_scrub: fix phase 8 debug reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801433.1981574.13587205107962897238.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex observes that the debug printf in fstrim_compute_minlen always
prints a threshold of 0 because we never actually set the block
threshold variable.  Fix that by using the results of the
multiplication that's passed into minlen_for_threshold.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 34bed605490f93 ("xfs_scrub: tune fstrim minlen parameter based on free space histograms")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase8.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 5bfe0ffb4868a2..61f412f7139ae9 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -141,7 +141,6 @@ fstrim_compute_minlen(
 	const struct histogram	*freesp_hist)
 {
 	uint64_t		ret;
-	double			blk_threshold = 0;
 	unsigned int		ag_max_usable;
 
 	/*
@@ -164,9 +163,9 @@ fstrim_compute_minlen(
 			freesp_hist->tot_sum * ctx->fstrim_block_pct);
 
 	if (debug > 1)
-		printf(_("fstrim minlen %lld threshold %lld ag_max_usable %u\n"),
+		printf(_("fstrim minlen %lld threshold %.2f ag_max_usable %u\n"),
 				(unsigned long long)ret,
-				(unsigned long long)blk_threshold,
+				freesp_hist->tot_sum * ctx->fstrim_block_pct,
 				ag_max_usable);
 	if (ret > ag_max_usable)
 		ret = ag_max_usable;

