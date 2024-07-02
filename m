Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BAE4436
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882220; cv=none; b=l4ISdgGxITG6T75Zdnr10leVXPlqK1vjakmaqa9q/J8LNZDRO3hxAjNcUaUzcmJ2oDKQ1WJK3mtN2ZzirDNRlHq8jcaJMYZS+06YDxjQxM3iKGsKMX5JChAKqELWeiWardcH59ZLU9SCJP7kbW7Ohs9BBmp/8/HBH9K39A/T6C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882220; c=relaxed/simple;
	bh=6tZ4XRI8M1dk5wLJfDlL53AyNHNpEzIzYY67lG/sfGo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eo+wc2WyK2TlkMlokAvEMzfrw8MGnfQNNp265p8iPGdKjFYEDe3cBpC3XW312qhm/QXfLEfJN5u2CVTf/YsOyDymu4J6fZRcSbUGB5hBYwIM6Yh+5bfY9dkgvIwYbwsKgrm6p0J9sIBqyqGsctyQMDSpLdeF1WKSbtJspRFPX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3bKTUrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3bKTUrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E1C116B1;
	Tue,  2 Jul 2024 01:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882219;
	bh=6tZ4XRI8M1dk5wLJfDlL53AyNHNpEzIzYY67lG/sfGo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K3bKTUrHyjCGjE9lCQ+OxM/T8qYTQN6NGWyJJRGLw40iRCfsmVYLzeqLp2b+vRR3g
	 7y6Y+1QCPRA3vk2iCoBlNZ6N0xfkaw6gruVwQQQcVvXNixBKHmeeld3fxtamGt5e6X
	 F46JuxdUZcH5WgFF9mB2Z85bu4V/EWGk2xKGPhiNe6cU05MNJ9llYfQH9bphaRQh0K
	 lGyW8G1sI/Nb6YLhlySdoG1Aw4UBMWXvKgoSoGFDQySQ9BH/yxd2JN9Vy+lvK8LHkL
	 l5Fam3OLhE/Xp8z2wcYPe1mOKAhD5tV0me8GyJ2XNBDHzvBIBM/SYYjkTgkpcGvin8
	 x7HRd4Lh9cLlw==
Date: Mon, 01 Jul 2024 18:03:39 -0700
Subject: [PATCH 3/7] libfrog: print cdf of free space buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118625.2007921.7225855318666248252.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
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
index 5053d5eafc26..bed79e35b021 100644
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

