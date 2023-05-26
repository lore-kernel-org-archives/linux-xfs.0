Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2B8C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjEZBv3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbjEZBv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39BE194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD5164C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB535C433EF;
        Fri, 26 May 2023 01:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065884;
        bh=v3KGvNRjafQ76kx7nPUxMJ+AX9i7Z8wd4tep/ZXPELg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iowXNVfFLDaTVH+5EUT6i5YJqW3P12VGdGgPfW9suRH1BQKXV3DOkSEkWsgjAW6go
         TKQ2tyuoK8+/v3sGl2b7OQI+ZZgTKjAOc5QpX6d1bOBB+h0xkk1qMG+Slulh1ccHNX
         b6DN78yfL6o/EuxFpTsBpoOnL6bx1MsEfSK0wGh0cCyP+/dRHxHqmFH3dLPthzSfP6
         Z35LpwVGTm5i/pohWfVFPa5xHwDzEjuwCdXBH5N+jDMwbZR9JRkwKd8095JlEQ3FKu
         7XP2H0wMeHfFDvpjegK5ZSAWoAW2prZM1xbqxR00yEBHU6Ixk301lYETd/XtKe6BJf
         fX5ARIMXfvdqg==
Date:   Thu, 25 May 2023 18:51:24 -0700
Subject: [PATCH 3/7] libfrog: print cdf of free space buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073507.3745433.8242934070876734847.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
References: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Print the cumulative distribution function of the free space buckets in
reverse order.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 458b414d0f9..ff780606011 100644
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

