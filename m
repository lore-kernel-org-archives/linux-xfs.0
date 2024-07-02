Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EBC7F9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882016; cv=none; b=ENB0IdMDEtAB8+OPU2m7Ww0SQxcmdpTfar4u0cjtY6wn1FGdpP57ct9Uzy0Q2Cgref9+4/7aEXXCHF01nelFiC1MSav61usa8f3RvCMdfSeLUEHdt98+V9+xwAFLTMc3+Ky3vSpopfnBPl/q1t1vaEyPD/MNMzbHlvYh+DKHcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882016; c=relaxed/simple;
	bh=pHtRb5eB1u+mkgAPbJcz9Jg7RY64spRKgWfuUM2OLrU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxSL7W2o0DnrNOVunX5VbzKevgF7TqKZyE+UswaJTbWfYgQsdkMLGyc+Pa91e9KlgBzqR2gcgBcNiyseBKbBIL55+FW3jdNSnDy8qfjmCNiyFDb9oxXLrn5vyxAYjK0NEvtQI5l8i+mEydxneZYzW6PZ3nWaJNyVXA5Gre6VVkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=roMWiFzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="roMWiFzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7DFC116B1;
	Tue,  2 Jul 2024 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882016;
	bh=pHtRb5eB1u+mkgAPbJcz9Jg7RY64spRKgWfuUM2OLrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=roMWiFzxfoRP49IBDDBt4uACAohMK3JiWmrIDiEo2ECdJBONYwH9raSuQhS5MnxNr
	 a50+HiiZKIj0JwSdrin76FVMTdySWh8nfLkHHAmZHOONZqmzlTq+Vxt+UlAmBMOq8p
	 F4WPzlc7Bp3gNKN9qI0m6kcm9w3PbstYnLht0uLnv+rbiokFezt8rhQLe/Q2wWmAwT
	 3CwyJLOFB9OeXeLZgdDBWj7VFbdCOnP8d+MGz4z+t7KQFBFX91hc6Go1tZECCbs6vp
	 4zBCQiY2GDv1KD7DrnAnKujja/omp0WCfS2XMX6lMu6zPjjtSEodbaWmAEwbtl22JH
	 SXJKHi8vgi1Og==
Date: Mon, 01 Jul 2024 18:00:15 -0700
Subject: [PATCH 11/13] xfs_scrub: rename struct unicrash.normalizer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117778.2007123.8328418916342708343.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
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

We're about to introduce a second normalizer, so change the name of the
existing one to reflect the algorithm that you'll get if you use it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index dfa798b09b0e..f6b53276c05d 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -87,7 +87,7 @@ struct name_entry {
 struct unicrash {
 	struct scrub_ctx	*ctx;
 	USpoofChecker		*spoof;
-	const UNormalizer2	*normalizer;
+	const UNormalizer2	*nfkc;
 	bool			compare_ino;
 	bool			is_only_root_writeable;
 	size_t			nr_buckets;
@@ -240,7 +240,7 @@ name_entry_compute_checknames(
 		goto out_unistr;
 
 	/* Normalize the string. */
-	normstrlen = unorm2_normalize(uc->normalizer, unistr, unistrlen, NULL,
+	normstrlen = unorm2_normalize(uc->nfkc, unistr, unistrlen, NULL,
 			0, &uerr);
 	if (uerr != U_BUFFER_OVERFLOW_ERROR || normstrlen < 0)
 		goto out_unistr;
@@ -248,7 +248,7 @@ name_entry_compute_checknames(
 	normstr = calloc(normstrlen + 1, sizeof(UChar));
 	if (!normstr)
 		goto out_unistr;
-	unorm2_normalize(uc->normalizer, unistr, unistrlen, normstr, normstrlen,
+	unorm2_normalize(uc->nfkc, unistr, unistrlen, normstr, normstrlen,
 			&uerr);
 	if (U_FAILURE(uerr))
 		goto out_normstr;
@@ -455,7 +455,7 @@ unicrash_init(
 	p->ctx = ctx;
 	p->nr_buckets = nr_buckets;
 	p->compare_ino = compare_ino;
-	p->normalizer = unorm2_getNFKCInstance(&uerr);
+	p->nfkc = unorm2_getNFKCInstance(&uerr);
 	if (U_FAILURE(uerr))
 		goto out_free;
 	p->spoof = uspoof_open(&uerr);

