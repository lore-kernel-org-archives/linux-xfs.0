Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA71C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t33/OVIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0F7C433C8;
	Sun, 31 Dec 2023 22:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063078;
	bh=7ZwA/uglfcdUp0h+p4XSB1pcmjtqKKLiQ0Rx5JGQpOg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t33/OVIT1n19cgcU6MU2hg1KQ86X7a9bpvxsn1q7tjII+ItuNFoAJc1ICXa9u9cgT
	 stGl0P4efq/N4HXpLRiTRfmsTkqmZWkHUUAgtOEAgA9Ng3EZmzFT5LgmpmvlFUNoy0
	 mU43luqtydtmpLcIY1H13PjdCKKLcCsfu3C0hGxDmwH6ULDxdwRMGduvWqR6WQFmKa
	 OFVAr2nBBOS5BU8UNh4CEK9wbkebl64RHqXrVBzK5HX0ka/bUPLOmH1gEcctz6Tqb0
	 jdj6e/a2dBt2r1M/ndB8GghUc+rrVy3wSB5jMI58O5k0tME5tGGXvMoYQWb+Wq2jhK
	 1kkNmKNc83V2g==
Date: Sun, 31 Dec 2023 14:51:17 -0800
Subject: [PATCH 3/7] libfrog: print cdf of free space buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001497.1798998.3976296418747063248.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
References: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
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

Print the cumulative distribution function of the free space buckets in
reverse order.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 5053d5eafc2..bed79e35b02 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -103,13 +103,64 @@ hist_free(
 	memset(hs, 0, sizeof(struct histogram));
 }
 
+/*
+ * Compute the CDF of the free space in decreasing order of extent length.
+ * This enables users to determine how much free space is not in the long tail
+ * of small extents, e.g. 98% of the free space extents are larger than 31
+ * blocks.
+ */
+static int
+hist_cdf(
+	const struct histogram	*hs,
+	struct histogram	*cdf)
+{
+	struct histent		*buckets;
+	int			i = hs->nr_buckets - 1;
+
+	ASSERT(cdf->nr_buckets == 0);
+	ASSERT(hs->nr_buckets < INT_MAX);
+
+	if (hs->nr_buckets == 0)
+		return 0;
+
+	buckets = calloc(hs->nr_buckets, sizeof(struct histent));
+	if (!buckets)
+		return errno;
+
+	memset(cdf, 0, sizeof(struct histogram));
+	cdf->buckets = buckets;
+
+	cdf->buckets[i].count = hs->buckets[i].count;
+	cdf->buckets[i].blocks = hs->buckets[i].blocks;
+	i--;
+
+	while (i >= 0) {
+		cdf->buckets[i].count = hs->buckets[i].count +
+				       cdf->buckets[i + 1].count;
+
+		cdf->buckets[i].blocks = hs->buckets[i].blocks +
+					cdf->buckets[i + 1].blocks;
+		i--;
+	}
+
+	return 0;
+}
+
 /* Dump a histogram to stdout. */
 void
 hist_print(
 	const struct histogram	*hs)
 {
+	struct histogram	cdf = { };
 	unsigned int		from_w, to_w, extents_w, blocks_w;
 	unsigned int		i;
+	int			error;
+
+	error = hist_cdf(hs, &cdf);
+	if (error) {
+		printf(_("histogram cdf: %s\n"), strerror(error));
+		return;
+	}
 
 	from_w = to_w = extents_w = blocks_w = 7;
 	for (i = 0; i < hs->nr_buckets; i++) {
@@ -131,20 +182,24 @@ hist_print(
 		blocks_w = max(blocks_w, strlen(buf));
 	}
 
-	printf("%*s %*s %*s %*s %6s\n",
+	printf("%*s %*s %*s %*s %6s %6s %6s\n",
 		from_w, _("from"), to_w, _("to"), extents_w, _("extents"),
-		blocks_w, _("blocks"), _("pct"));
+		blocks_w, _("blocks"), _("pct"), _("blkcdf"), _("extcdf"));
 	for (i = 0; i < hs->nr_buckets; i++) {
 		if (hs->buckets[i].count == 0)
 			continue;
 
-		printf("%*lld %*lld %*lld %*lld %6.2f\n",
+		printf("%*lld %*lld %*lld %*lld %6.2f %6.2f %6.2f\n",
 				from_w, hs->buckets[i].low,
 				to_w, hs->buckets[i].high,
 				extents_w, hs->buckets[i].count,
 				blocks_w, hs->buckets[i].blocks,
-				hs->buckets[i].blocks * 100.0 / hs->totblocks);
+				hs->buckets[i].blocks * 100.0 / hs->totblocks,
+				cdf.buckets[i].blocks * 100.0 / hs->totblocks,
+				cdf.buckets[i].count * 100.0 / hs->totexts);
 	}
+
+	hist_free(&cdf);
 }
 
 /* Summarize the contents of the histogram. */

