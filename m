Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D8143737
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924899; cv=none; b=kM9vOjSQhWzSScjmX+ODI1QlPd5pXuXw8rR9op6SYI64KM/HAuxCqds+FGShuEr2Wr8bjqUGsT0SHXf4ECYkTqI0DXkQmIZ7ZM5NZf5Bdx7qzLuPBMRpnMzxm7OO9wcwwud6F73hTW/GTObfBiwrhLcynG2pFljXbcpBkbw0gVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924899; c=relaxed/simple;
	bh=HGARBBkUhDOH8YoC3XEy1p6EbM1qv2SkC57aEy5gSQA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DA79W7dQjlxx2P3nOMbnBQrdADscqLzwsKuk6Ud/UKQkHDKg4q9JQ1Zl1LPtR37lLbP9HaEhQsRxCxHrPxXOxbHXzufBnz5a6ny9LjIPAXjsVkcSaRmjQFu5ohj+lrM8TO7VYwmGCyyaqUR2kbhxBoc1tAAxvvYrFIn73GJd60I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fY8izWtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fY8izWtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBB6C2BD10;
	Thu, 20 Jun 2024 23:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924899;
	bh=HGARBBkUhDOH8YoC3XEy1p6EbM1qv2SkC57aEy5gSQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fY8izWtw7z19PbGpPCpEHhvxB3RJvCw+xO+6tGcjzAzJNFW8t6StV7Z1mEtq4/feY
	 +IQ5GWJwVSemfwovVrvTauf+pkBD69EgFVUtOBGtT9bnbVG625pRyeyg1ds4gqQyu7
	 ofQSJVZpI/RWwQy57ymbbnsM7Hqt+2R9wksqHLO7GKTLHSvAMs/CbgMQOZ9HcmbCn6
	 11PsEAvVTdKss0T4mSVpox+WdeGNUWMO0vK+Gb663D1JKzvDS3PwU44umjQ6sZJ11c
	 +IEA9hCW8xAto4IcTBXUsG2oQ0AspYZLAsvd938arSJRzADYRLxyDQpizocrPbrnWn
	 8p/aeua9SjSxg==
Date: Thu, 20 Jun 2024 16:08:18 -0700
Subject: [PATCH 5/9] xfs: add a ri_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419318.3184396.11472056104029458239.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helper to translate from the item list head to the
rmap_intent_item structure and use it so shorten assignments
and avoid the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 7e998a7eb0422..1cc1ec597a0bd 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -226,6 +226,11 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_intent	= xfs_rud_item_intent,
 };
 
+static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_rmap_intent, ri_list);
+}
+
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -233,11 +238,8 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_rmap_intent		*ra;
-	struct xfs_rmap_intent		*rb;
-
-	ra = container_of(a, struct xfs_rmap_intent, ri_list);
-	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -364,11 +366,9 @@ xfs_rmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_rmap_intent		*ri;
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	error = xfs_rmap_finish_one(tp, ri, state);
 
 	xfs_rmap_update_put_group(ri);
@@ -389,9 +389,7 @@ STATIC void
 xfs_rmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_rmap_intent		*ri;
-
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 
 	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);

