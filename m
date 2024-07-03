Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BDA18E74F
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043262; cv=none; b=MLMZ5queU3Afhe5Uh2tQ3RQXRW8Oc7ikIaDy/z6OfwMr1yrXfjSKuAjAafIw2lZ+pfszOWMBmtdjUwyNfGHSkbltQsoIrP936JqaCWBYJvt1QaaX3EMDVvKIQX0DprRX4aN1P3iXJbPWJuExV1jMwRKUeatv2DgzRaNZJ3za+jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043262; c=relaxed/simple;
	bh=xc4tuwY5YuZRLvc2DR7nETQoQf4f0PasUPMQmRoSo70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJcFcb4f4B0geclzfwJZ0Soe/POPZDkExYyfvBo+A8lUTRtWEwmB2dHy49aFUcUx/vreLehF8CGbjyzn40i0wSdajRykxFYjluZATPlWfc6lR1RRd9BBCzeWMtVps7vGaIfyvM04wpsqlFK2r3IG28r/Sdnh4Pa3nxWRzkrhb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0HSO1ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0HSO1ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569D0C4AF0A;
	Wed,  3 Jul 2024 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043262;
	bh=xc4tuwY5YuZRLvc2DR7nETQoQf4f0PasUPMQmRoSo70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t0HSO1baAoJDlEDtcvM7jTXnYMNwmqVtwi6t7tReMcMifSxP9i/u8/NiK4axvbz6R
	 GRLaEfRBchemlvWd+OS+2MNaUy1JTb+jFWlFZZAVGxFvsNiVqC4QOldXSWaOKYSTe5
	 FqDhvwhiIkHUfnxI6/VjIVIvckYj9lYCisIo/jeFSDUPI4ytKKZO/1KMRaKFh7G/4x
	 gf4gGbPdE9x3up6Vyutrtn2Gu6cXFULLeuWG7vv6cr8TV+BYMG1EqX3bNkJ9xmnmB6
	 lZN68GsWjkJs/7WVwwzt3jKEql0gm0ETrj9w68nMLH0w4Ueca53FxIo5FRcDrO5rzl
	 DQeqZpYN2uKuw==
Date: Wed, 03 Jul 2024 14:47:41 -0700
Subject: [PATCH 3/7] libfrog: print cdf of free space buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320053.3392477.14435544564673079849.stgit@frogsfrogsfrogs>
In-Reply-To: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/histogram.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++---
 libfrog/histogram.h |    8 +++++
 2 files changed, 80 insertions(+), 4 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 7cee6b350046..59d46363c1da 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -102,17 +102,81 @@ hist_free(
 	memset(hs, 0, sizeof(struct histogram));
 }
 
+/*
+ * Compute the CDF of the histogram in decreasing order of value.
+ *
+ * For a free space histogram, callers can determine how much free space is not
+ * in the long tail of small extents, e.g. 98% of the free space extents are
+ * larger than 31 blocks.
+ */
+static struct histogram_cdf *
+hist_cdf(
+	const struct histogram	*hs)
+{
+	struct histogram_cdf	*cdf;
+	int			i = hs->nr_buckets - 1;
+
+	ASSERT(hs->nr_buckets < INT_MAX);
+
+	cdf = malloc(sizeof(struct histogram_cdf));
+	if (!cdf)
+		return NULL;
+	cdf->histogram = hs;
+
+	if (hs->nr_buckets == 0) {
+		cdf->buckets = NULL;
+		return cdf;
+	}
+
+	cdf->buckets = calloc(hs->nr_buckets, sizeof(struct histbucket));
+	if (!cdf->buckets) {
+		free(cdf);
+		return NULL;
+	}
+
+	cdf->buckets[i].nr_obs = hs->buckets[i].nr_obs;
+	cdf->buckets[i].sum = hs->buckets[i].sum;
+	i--;
+
+	while (i >= 0) {
+		cdf->buckets[i].nr_obs = hs->buckets[i].nr_obs +
+					cdf->buckets[i + 1].nr_obs;
+
+		cdf->buckets[i].sum =    hs->buckets[i].sum +
+					cdf->buckets[i + 1].sum;
+		i--;
+	}
+
+	return cdf;
+}
+
+/* Free all data associated with a histogram cdf. */
+static void
+histcdf_free(
+	struct histogram_cdf	*cdf)
+{
+	free(cdf->buckets);
+	free(cdf);
+}
+
 /* Dump a histogram to stdout. */
 void
 hist_print(
 	const struct histogram		*hs,
 	const struct histogram_strings	*hstr)
 {
+	struct histogram_cdf		*cdf;
 	unsigned int			obs_w = strlen(hstr->observations);
 	unsigned int			sum_w = strlen(hstr->sum);
 	unsigned int			from_w = 7, to_w = 7;
 	unsigned int			i;
 
+	cdf = hist_cdf(hs);
+	if (!cdf) {
+		perror(_("histogram cdf"));
+		return;
+	}
+
 	for (i = 0; i < hs->nr_buckets; i++) {
 		char buf[256];
 
@@ -132,23 +196,27 @@ hist_print(
 		sum_w = max(sum_w, strlen(buf));
 	}
 
-	printf("%*s %*s %*s %*s %6s\n",
+	printf("%*s %*s %*s %*s %6s %6s %6s\n",
 			from_w, _("from"), to_w, _("to"),
 			obs_w, hstr->observations,
 			sum_w, hstr->sum,
-			_("pct"));
+			_("pct"), _("blkcdf"), _("extcdf"));
 
 	for (i = 0; i < hs->nr_buckets; i++) {
 		if (hs->buckets[i].nr_obs == 0)
 			continue;
 
-		printf("%*lld %*lld %*lld %*lld %6.2f\n",
+		printf("%*lld %*lld %*lld %*lld %6.2f %6.2f %6.2f\n",
 				from_w, hs->buckets[i].low,
 				to_w, hs->buckets[i].high,
 				obs_w, hs->buckets[i].nr_obs,
 				sum_w, hs->buckets[i].sum,
-				hs->buckets[i].sum * 100.0 / hs->tot_sum);
+				hs->buckets[i].sum * 100.0 / hs->tot_sum,
+				cdf->buckets[i].sum * 100.0 / hs->tot_sum,
+				cdf->buckets[i].nr_obs * 100.0 / hs->tot_obs);
 	}
+
+	histcdf_free(cdf);
 }
 
 /* Summarize the contents of the histogram. */
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
index d85f8edb8752..967698774b0c 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -34,6 +34,14 @@ struct histogram {
 	unsigned int		nr_buckets;
 };
 
+struct histogram_cdf {
+	/* histogram from which this cdf was computed */
+	const struct histogram	*histogram;
+
+	/* distribution information */
+	struct histbucket	*buckets;
+};
+
 int hist_add_bucket(struct histogram *hs, long long bucket_low);
 void hist_add(struct histogram *hs, long long value);
 void hist_init(struct histogram *hs);

