Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762FF1BBBDC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992094; cv=none; b=GrAYOeXEz7hmrYEtZ241go54+BksxYD+BNOtG35hXowNcpi6oxlB43G5YuYPWMc4tjLXe8w2tnqeKJFVj5zeNHHhcewp/x4DOaxHFd0qwr54wIsx/rDQ21lol4pQNJO8X7ZCpHjv3/o0+txGuxjC4cLO+k0iZwMuRPynLtxzGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992094; c=relaxed/simple;
	bh=7K/DGv7FEDSrk/Ic4p/gTBi/MX6vbblO5iUkjEU5aS0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gR+/3fqhOKOPpzkBTk81KjBgG3SkFj2ZYFB0ue3Jxv7r4McvxdvjRmvPMNS8d9O0hz4PjuCCLnbj9audxjJLzs1xhleIRzKoow8k0H5OXFNYedlkHzREUCjhd4KIGmh4o63RZPNkRsgc/ihqJ6/fRKrFPAU+g+jZMATP6epu0a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMRVT61e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMRVT61e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C0FC4CED3;
	Mon, 23 Dec 2024 22:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992094;
	bh=7K/DGv7FEDSrk/Ic4p/gTBi/MX6vbblO5iUkjEU5aS0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GMRVT61e2QZfdStnfYjqxIYYvNGzk8taTqFI+qd5v+3qLR9sj+HUns1HzkHLnO/id
	 N3kv/jVKDigWtSzgXbbEKECxaXoLdjfoxem2XwbcY0CQsMVaPGzj0VFL7TALBc0CpK
	 Vm11EDvzjpHsclVXhPskoHHpqm58Im0wGFDgEt/kuELQ+vt2H+qqW9y0im8qPrcIhs
	 7d5bTRAsyPefZJZ88EM0rVT89T+nQ49vNhoOEKq9Um+DIvY7s92j1Dx4i2XXTFWiT/
	 DkifjoVTTgCvELmixLm9Jo6liQ8Bi7LBIjGkBnTGUEQFzYM1Ohqw1r9NyEO4MH+2A1
	 sZCS/Ef+5KL2w==
Date: Mon, 23 Dec 2024 14:14:53 -0800
Subject: [PATCH 12/51] libfrog: add bitmap_clear
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943988.2297565.16798595244468929206.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Uncomment and fix bitmap_clear so that xfs_repair can start using it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/bitmap.c |   25 +++++++++++++++++++------
 libfrog/bitmap.h |    1 +
 2 files changed, 20 insertions(+), 6 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index 5af5ab8dd6b3bb..0308886d446ff2 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -233,10 +233,9 @@ bitmap_set(
 	return res;
 }
 
-#if 0	/* Unused, provided for completeness. */
 /* Clear a region of bits. */
-int
-bitmap_clear(
+static int
+__bitmap_clear(
 	struct bitmap		*bmap,
 	uint64_t		start,
 	uint64_t		len)
@@ -251,8 +250,8 @@ bitmap_clear(
 	uint64_t		new_length;
 	struct avl64node	*node;
 	int			stat;
+	int			ret = 0;
 
-	pthread_mutex_lock(&bmap->bt_lock);
 	/* Find any existing nodes over that range. */
 	avl64_findranges(bmap->bt_tree, start, start + len, &firstn, &lastn);
 
@@ -312,10 +311,24 @@ bitmap_clear(
 	}
 
 out:
-	pthread_mutex_unlock(&bmap->bt_lock);
 	return ret;
 }
-#endif
+
+/* Clear a region of bits. */
+int
+bitmap_clear(
+	struct bitmap		*bmap,
+	uint64_t		start,
+	uint64_t		length)
+{
+	int			res;
+
+	pthread_mutex_lock(&bmap->bt_lock);
+	res = __bitmap_clear(bmap, start, length);
+	pthread_mutex_unlock(&bmap->bt_lock);
+
+	return res;
+}
 
 /* Iterate the set regions of this bitmap. */
 int
diff --git a/libfrog/bitmap.h b/libfrog/bitmap.h
index 043b77eece65b3..47df0ad38467ce 100644
--- a/libfrog/bitmap.h
+++ b/libfrog/bitmap.h
@@ -14,6 +14,7 @@ struct bitmap {
 int bitmap_alloc(struct bitmap **bmap);
 void bitmap_free(struct bitmap **bmap);
 int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
+int bitmap_clear(struct bitmap *bmap, uint64_t start, uint64_t length);
 int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
 		void *arg);
 int bitmap_iterate_range(struct bitmap *bmap, uint64_t start, uint64_t length,

