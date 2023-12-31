Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400CEC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGLl7ywU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD4FC433C7;
	Sun, 31 Dec 2023 22:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062875;
	bh=sD8RU6wwTvCQbjCnc3UstBWuC9vuHpDmAblCjl4Rcpo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OGLl7ywUf4mSWJ0KXPb6ZLFO2XueBGVuSPcGItbZfnh9MomGbNXOzVtdCxT5x+LwY
	 cyiaKvX/KF4Xglb5jPXT1iiCTSdYVN8TNJ6gUNeaSOraNOa/0BvGhgLltJLGPk/3vX
	 a8KsJfBRJ4FcgkcpOtXedppUgLNVW4QO0KKRBK9yZB4oD2Yj5EKKwe53+HMvRez10y
	 N1KBnotst6qt1+19MMLRhkKZkJ8HGg2XNF3HzKp66zcQpsIWKoAwk6CTPZFlMkSowz
	 KtJOvM8A0ecSYrtb0yTKpqdT7cGjHcapupN8FcSKruCWiU8w/MVmPoIMSR4905kLRA
	 Ct0O+s8XtswZA==
Date: Sun, 31 Dec 2023 14:47:54 -0800
Subject: [PATCH 11/13] xfs_scrub: rename struct unicrash.normalizer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000729.1798385.9981470652048416800.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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
index dfa798b09b0..f6b53276c05 100644
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

