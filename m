Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65A110E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301908; cv=none; b=uqY2yH30XTPf7YCIZAEeFkGciUfzmqyOhPpDPfJ/vreiKLq/tNWlSATHaoLWkLG826d1zS6tt2KHY28/uDNWQe7pw6hnmAk2Zmfi9O3KeGY0+xGfMGgnCmF+2AwU1c0H3URotjZLXd3oUkz+XynwQcV6Lavl8J/cvRGiyInl8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301908; c=relaxed/simple;
	bh=kuctmHSgIdZfxIc/PjhSVSVtI1lPW8kburz7baFJ7QA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZFwwbC4PiiCty0lmFjDAxCgMsXvgJT/FtwTpPOi/PknJZ69eyvjrTEqrjLvixN/YsXsEk/o7gGZFPlAj/yJcULrd5+o6zog/hKVT25H+aN9PNzh/iQHSrkgyhB1frea1XG+pqo6SzWqb5re9jj39mxL3Ug3EAVv67Ctf1zmWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9lklGCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9lklGCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEEAC32786;
	Tue, 30 Jul 2024 01:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301908;
	bh=kuctmHSgIdZfxIc/PjhSVSVtI1lPW8kburz7baFJ7QA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M9lklGCb8/G2SmaoFkpOmcEZMQiDdz+8N8wJBiB6Q5uUMLFF4vhta5bR3zz2CARSG
	 Nb8N3Dvmad2R2kWLUqhUTzdLXvwKzMWPovZRLWJdShu3hoC8VtLeKxJS3swV/9WpIS
	 NbNEHmU8z5Kqg10JKa1Qynlmbg1n/dqWz3E5+hZnI9kOGfwmsoWHc7hWdM034+ObPP
	 ebgW3jz14PTvKrqxNxj6zs39Y+2M9CEMFsem58uFNt9S58kDrn/aP/kuTXwDjJUFKM
	 xLhxBCQ1siGcLCN2Y/NxFFdqJ5VCCz+xQiyl9MxsLgrAVQe47Idw/YeWlrxEwsYyW/
	 qNIap5iITQpOw==
Date: Mon, 29 Jul 2024 18:11:47 -0700
Subject: [PATCH 3/7] libfrog: print cdf of free space buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848491.1349623.5655363871381537933.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
References: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
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
index 7cee6b350..59d46363c 100644
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
index 68afdeb29..0c534f65d 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -33,6 +33,14 @@ struct histogram {
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

