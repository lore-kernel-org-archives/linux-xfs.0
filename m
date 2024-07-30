Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53AD10E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301721; cv=none; b=DXd9+P+dvAmmO6lM4ecNaB0eGo3l7z9R0gTVhwg3W0Ev1vvtaFMWsDB8tFaSdut35siCtRtLvAMRvIQ/6T53JWCnARDYjhEMBDBZx7J1VDTc1rPSgqjrh4z/1upEQEFyRk/DwHIR/nzRQ937a09RVCdl+oDU2FICMryVj+eO5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301721; c=relaxed/simple;
	bh=dOyOyTnSQVlRDMxGss5Ydyf63y30U3aB4uSHZb9bq84=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkKf6VCPLwd5GIZrlsHMCKWEOablOuFirnkHgns8m1UfFkM+rc0LbB5efeEeBmVJS/jvaXHtVBKzQwaD84Y9eoeg0XWbuRslQvqjUWlQ/5n5INIrAQqYFcNe20Q9ktPTTJRNS61TM1x4EfX4yI0ld5t8UtgrMx4AoUhV3gjN0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOYrtNBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOYrtNBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0A8C32786;
	Tue, 30 Jul 2024 01:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301720;
	bh=dOyOyTnSQVlRDMxGss5Ydyf63y30U3aB4uSHZb9bq84=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dOYrtNBLWztuXrh7h1Y7txQ3MdXbnjl1sfmcEVU/ijNBYWW05CRlK0eRfBWwNXCQY
	 //mMHmpmNCSzXWrMaFaowvCkfqGU3J44dhF/2dGJARpToVr7FYjBH1pMs253hv4Z3f
	 iIEly2DjruGhsC+gx3rYE/KsRr15jOq6OXZFt2zYSZzEKqsXyRo16fld+jnscH0qwK
	 4W60DlNtcMX50ERgvg350c/p39WH96BJ2/ifhhLsPmTio+wqjb/p7W3pbpQKv4lopO
	 oR7iUOEOAD3WphLV/stXs4mzQsPs7c4QdgxdOyURKIxccgf4MvXMS4c4RSfVRU4J9j
	 NUnZu7d+vcDVA==
Date: Mon, 29 Jul 2024 18:08:39 -0700
Subject: [PATCH 11/13] xfs_scrub: rename struct unicrash.normalizer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847697.1348850.293417564068933959.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 74c0fe1f9..9cde9afff 100644
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
@@ -242,7 +242,7 @@ name_entry_compute_checknames(
 		goto out_unistr;
 
 	/* Normalize the string. */
-	normstrlen = unorm2_normalize(uc->normalizer, unistr, unistrlen, NULL,
+	normstrlen = unorm2_normalize(uc->nfkc, unistr, unistrlen, NULL,
 			0, &uerr);
 	if (uerr != U_BUFFER_OVERFLOW_ERROR || normstrlen < 0)
 		goto out_unistr;
@@ -250,7 +250,7 @@ name_entry_compute_checknames(
 	normstr = calloc(normstrlen + 1, sizeof(UChar));
 	if (!normstr)
 		goto out_unistr;
-	unorm2_normalize(uc->normalizer, unistr, unistrlen, normstr, normstrlen,
+	unorm2_normalize(uc->nfkc, unistr, unistrlen, normstr, normstrlen,
 			&uerr);
 	if (U_FAILURE(uerr))
 		goto out_normstr;
@@ -457,7 +457,7 @@ unicrash_init(
 	p->ctx = ctx;
 	p->nr_buckets = nr_buckets;
 	p->compare_ino = compare_ino;
-	p->normalizer = unorm2_getNFKCInstance(&uerr);
+	p->nfkc = unorm2_getNFKCInstance(&uerr);
 	if (U_FAILURE(uerr))
 		goto out_free;
 	p->spoof = uspoof_open(&uerr);

