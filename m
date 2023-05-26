Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAF0C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEZBvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbjEZBvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55909199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B5F64868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A8AC433EF;
        Fri, 26 May 2023 01:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065869;
        bh=Qc30zDkAdAS3qOXbgCHR4Ti+ENVvKs2N8Pj4RQalnBQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gj0Ue39gRZaWJO7uay16UMCejvWosL7oyfzayOaBUEopbIA7LEFZ2Bok1QkndE6wZ
         Nwebm1BDFkrDfNOsbzofJ3BvNv6F+Cyw1yUQfZIrWkxdLrlGEArcDsWKnsD/KgVtKK
         KSXf1SfNAEMZ+mrqHk9rVQTKMdZTlLKhUuRGxYBWDn9L5dKA+TzfirSwIJv+/mK+l3
         3oGltsc97EwQZ33J/tF+S4B2wv4LPyDC71CUbVlFmBg4qQg67EUbaW+d2JSbfag+qi
         SO83gtbWYyeXIOttgr2YKMghhdlaQDen8lCuCsiaWczAsl9EHa+jcG7rUbT1qqnukD
         gtOiQgw0gnkIA==
Date:   Thu, 25 May 2023 18:51:08 -0700
Subject: [PATCH 2/7] libfrog: print wider columns for free space histogram
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073494.3745433.15976752668175255977.stgit@frogsfrogsfrogs>
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

The values reported here can reach very large values, so compute the
column width dynamically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index e854ac5e467..458b414d0f9 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -108,17 +108,41 @@ void
 hist_print(
 	const struct histogram	*hs)
 {
+	unsigned int		from_w, to_w, extents_w, blocks_w;
 	unsigned int		i;
 
-	printf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
+	from_w = to_w = extents_w = blocks_w = 7;
+	for (i = 0; i < hs->nr_buckets; i++) {
+		char buf[256];
+
+		if (!hs->buckets[i].count)
+			continue;
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].low);
+		from_w = max(from_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].high);
+		to_w = max(to_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].count);
+		extents_w = max(extents_w, strlen(buf));
+
+		snprintf(buf, sizeof(buf) - 1, "%lld", hs->buckets[i].blocks);
+		blocks_w = max(blocks_w, strlen(buf));
+	}
+
+	printf("%*s %*s %*s %*s %6s\n",
+		from_w, _("from"), to_w, _("to"), extents_w, _("extents"),
+		blocks_w, _("blocks"), _("pct"));
 	for (i = 0; i < hs->nr_buckets; i++) {
 		if (hs->buckets[i].count == 0)
 			continue;
 
-		printf("%7lld %7lld %7lld %7lld %6.2f\n",
-				hs->buckets[i].low, hs->buckets[i].high,
-				hs->buckets[i].count, hs->buckets[i].blocks,
+		printf("%*lld %*lld %*lld %*lld %6.2f\n",
+				from_w, hs->buckets[i].low,
+				to_w, hs->buckets[i].high,
+				extents_w, hs->buckets[i].count,
+				blocks_w, hs->buckets[i].blocks,
 				hs->buckets[i].blocks * 100.0 / hs->totblocks);
 	}
 }

