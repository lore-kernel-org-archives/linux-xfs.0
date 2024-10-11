Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE403232
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609968; cv=none; b=IYYRPqEozEYD+lOkmi3kUSE67N4CMf02MSLao2lVUfRL0LmAIkM67F5mOCbgsjFXChOOSRnwZ9dPDlYf2kxLG0CoetG4OJxL+HCch31uQhgEI2XICjTjHa0q8piRSRQSja2f5c2UfxxldjVR2HCE9zEv1S2FjP2zSqo9Kgbpt14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609968; c=relaxed/simple;
	bh=+wvC/LkyWjml/xLILMIN6s55Cm2wU4JrYFlxuDj2Yo0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9YPbveH7Cj5WVDR68Rg26mHhnnKkPCzsN/iovrCI47ZDzUVUPXSNWfSq+ftLFSjNtgL+52yBYG3zQIbX5t6b8aXDWKqVUj6dL1DNJRKlFSgayezkIAWXDEucm5W79JE+qm3CArb0tSApTx+EioVh6cjrQdHytT5rTRfnlFniGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfBwdLKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfBwdLKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77637C4CEC5;
	Fri, 11 Oct 2024 01:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609968;
	bh=+wvC/LkyWjml/xLILMIN6s55Cm2wU4JrYFlxuDj2Yo0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FfBwdLKwtv5WFg+OskKEbUmlPDPQyR8lwbjB6nOiVaWO9TcjP7WI8dqFiFCB15zd3
	 aLbxO5v6aOBwOXqtbeyp6C76skjDZNl5bHn8THaC+n63dOn1HFkz9IFBqaYcartk7w
	 d+NcZM2VPYX2fUym3jR7nfxZJ2EEAD4y89auID1lbEYy6Gbbv8TVcSsvrRjGpfPK/r
	 D033FuqesDpvnonHx3SpSqSP4Z2FW992pXP+XeJW6pBuXt0BINr8OUVzPgLgnYA/AM
	 v/qxhCQiEMz2CVaHdXfgoKpuClVK/43bNt4Ud4+Iq6Q5xwUYGcY5udwFNWGFUQOQwe
	 kRSyoribm12BA==
Date: Thu, 10 Oct 2024 18:26:08 -0700
Subject: [PATCH 06/43] libfrog: add bitmap_clear
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655458.4184637.12186203328158843079.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Uncomment and fix bitmap_clear so that xfs_repair can start using it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
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

