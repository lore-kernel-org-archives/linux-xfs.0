Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2FD17E0
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530067; cv=none; b=kRUMmVhcgz37NIy0tGeoBKwLxgDEz+yWNWPBkqggG5x2ndnSugdMJHefqDmiqXUHeZ85ZehBUvUlbbzMU3lFo+YM1SsDj8ZVMntS9/vJYN1iqnv9beLlOGlsckzyxIV91IhRLPUQ94bgwX8M3/apkUT+CcnX/QT96ThWl3lSH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530067; c=relaxed/simple;
	bh=HDf3DlhHdAG37vvaPn5SYzT28qN+bWx7IhJ9dKaY++E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hmIxADhKfgyj/l9p5wyvxhDc7xBuUdfGvV4vs0Ug+XbMwNErFkJk6xMdurrsYgZ2VF8P3U352KFnfvCsg8b228n6TapXEvYLEwCiP7ohZJVn2dHWrWkdnJh9N84HIjCdbuP9Mt/FBPc3uXCGOReSHhw4hTkqQNQwrJcV/3cAd5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfpJMqHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfpJMqHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEDAC4CED1;
	Sat,  7 Dec 2024 00:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530067;
	bh=HDf3DlhHdAG37vvaPn5SYzT28qN+bWx7IhJ9dKaY++E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rfpJMqHl4mD+47uwKadncY8nHxULYK1DDxO6LMtqoINwSGcXeXf8SOPR7/ZNOdVXQ
	 v01I3AXTnui723E1CsagLJliq8bX2u8NXAKlBETgob6qRhFynbKuTVoV3FKaRdN7F6
	 lT87bkhqNhetRJVpuI4x9f9Y+2VF2vcPT1R/ymK2Ck9MJarRSrcLUAS1OjbRr0nWgD
	 vzPvqJOxMYhP1vHQA5CQVEVYefo7UMiSvg/wwTdmTnZMgmwVicxYZCXy+aaoEk7zzk
	 8CYhciKnZKVdyacs3scjReQibFW6Eq/GEFpYCwNio5N/RHF50BDhq4QgBjL9Ky3mO0
	 dKeD/cdC5cmrQ==
Date: Fri, 06 Dec 2024 16:07:46 -0800
Subject: [PATCH 11/50] libfrog: add bitmap_clear
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752113.126362.10879746688196189472.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

