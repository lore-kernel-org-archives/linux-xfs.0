Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FAA137923
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442837; cv=none; b=oxAP8TUUyPAlYlraVc7JOjPFPlR1DFMnOwWxLMN1nZ9o6I6GEMPMbxkS+3ELF7SGxImd5b4llI5RjFVQa1L+rAvZZcP2m2ECXFQNeeiQs0wcTeAGrEH29OcTCXNNZMWjUXvBPWR/LeKlJjlOmWnwz5RD8FHFoLmquYN1cv/xcQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442837; c=relaxed/simple;
	bh=3E25SqCw2AgCsmcbdowLu1lcFxRi//cFZSXKDkIjaJs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9nqzLpx0IjaeYpHV1T3Zuza9WRYXnzj9xx39fdgFyRZtheyMmMwoRMxlK2fFlFJkliQ6DH8zX/5VthYsuaqLTVZ/eSly93OTd3VYJ0ppaSjheHJeJ1Vbo0e+wlNgOJQzKiu7vkBZia/+G/fWLP5S0SsTyE8fP03gaXz9/klRfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2AG7qhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2AG7qhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E1AC2BD10;
	Mon,  3 Jun 2024 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442837;
	bh=3E25SqCw2AgCsmcbdowLu1lcFxRi//cFZSXKDkIjaJs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N2AG7qhMXP38qwVK61Rb0NGZbkBAeUXh0W3ebFXCIh5p0El9+1CPv+6hDoOPW00DB
	 R29YrO8lPrgGPz+gcRl8FCpWWEjvOOMkDafh5qhw3eR/7KEf8lgAbV/6eMS8srATM2
	 iDml2jTP9bCU1MyiLw+7EtSJXm/4x9J/kxdxSt5JIDMCrR5NkE+oK40m/1b7LG824e
	 qtIWQiNZuLvwoPV86MKfLh8SZeYbA1aY8Bxyt3OdGVxRXSV8WgQCzwtsnR3m+zTDiC
	 EqtNOpd4zgvtB8wz2sHLFd3rQtfNRGb0+OEenGt0khZTm9kXKkOr/e4U5ymNPaqIS0
	 KsPisVnhIJawg==
Date: Mon, 03 Jun 2024 12:27:16 -0700
Subject: [PATCH 4/4] xfs_repair: remove the old bag implementation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043549.1450408.13371246989152395191.stgit@frogsfrogsfrogs>
In-Reply-To: <171744043484.1450408.1711608371281603052.stgit@frogsfrogsfrogs>
References: <171744043484.1450408.1711608371281603052.stgit@frogsfrogsfrogs>
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

Remove the old bag implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rmap.c |    7 ---
 repair/slab.c |  130 ---------------------------------------------------------
 repair/slab.h |   19 --------
 3 files changed, 156 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 7cb3a315a..553c7a6c3 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -41,13 +41,6 @@ struct xfs_ag_rmap {
 	int			ar_flcount;
 };
 
-/* Only the parts of struct xfs_rmap_irec that we need to compute refcounts. */
-struct rmap_for_refcount {
-	xfs_agblock_t	rm_startblock;
-	xfs_extlen_t	rm_blockcount;
-	uint64_t	rm_owner;
-};
-
 static struct xfs_ag_rmap *ag_rmaps;
 bool rmapbt_suspect;
 static bool refcbt_suspect;
diff --git a/repair/slab.c b/repair/slab.c
index 44ca0468e..a0114ac23 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -77,28 +77,6 @@ struct xfs_slab_cursor {
 	struct xfs_slab_hdr_cursor	hcur[0];	/* per-slab cursors */
 };
 
-/*
- * Bags -- each bag is an array of record items; when a bag fills up, we resize
- * it and hope we don't run out of memory.
- */
-#define MIN_BAG_SIZE	4096
-struct xfs_bag {
-	uint64_t		bg_nr;		/* number of pointers */
-	uint64_t		bg_inuse;	/* number of slots in use */
-	char			*bg_items;	/* pointer to block of items */
-	size_t			bg_item_sz;	/* size of each item */
-};
-
-static inline void *bag_ptr(struct xfs_bag *bag, uint64_t idx)
-{
-	return &bag->bg_items[bag->bg_item_sz * idx];
-}
-
-static inline void *bag_end(struct xfs_bag *bag)
-{
-	return bag_ptr(bag, bag->bg_nr);
-}
-
 /*
  * Create a slab to hold some objects of a particular size.
  */
@@ -386,111 +364,3 @@ slab_count(
 {
 	return slab->s_nr_items;
 }
-
-/*
- * Create a bag to point to some objects.
- */
-int
-init_bag(
-	struct xfs_bag	**bag,
-	size_t		item_sz)
-{
-	struct xfs_bag	*ptr;
-
-	ptr = calloc(1, sizeof(struct xfs_bag));
-	if (!ptr)
-		return -ENOMEM;
-	ptr->bg_item_sz = item_sz;
-	ptr->bg_items = calloc(MIN_BAG_SIZE, item_sz);
-	if (!ptr->bg_items) {
-		free(ptr);
-		return -ENOMEM;
-	}
-	ptr->bg_nr = MIN_BAG_SIZE;
-	*bag = ptr;
-	return 0;
-}
-
-/*
- * Free a bag of pointers.
- */
-void
-free_bag(
-	struct xfs_bag	**bag)
-{
-	struct xfs_bag	*ptr;
-
-	ptr = *bag;
-	if (!ptr)
-		return;
-	free(ptr->bg_items);
-	free(ptr);
-	*bag = NULL;
-}
-
-/*
- * Add an object to the pointer bag.
- */
-int
-bag_add(
-	struct xfs_bag	*bag,
-	void		*ptr)
-{
-	void		*p, *x;
-
-	p = bag_ptr(bag, bag->bg_inuse);
-	if (p == bag_end(bag)) {
-		/* No free space, alloc more pointers */
-		uint64_t	nr;
-
-		nr = bag->bg_nr * 2;
-		x = realloc(bag->bg_items, nr * bag->bg_item_sz);
-		if (!x)
-			return -ENOMEM;
-		bag->bg_items = x;
-		memset(bag_end(bag), 0, bag->bg_nr * bag->bg_item_sz);
-		bag->bg_nr = nr;
-		p = bag_ptr(bag, bag->bg_inuse);
-	}
-	memcpy(p, ptr, bag->bg_item_sz);
-	bag->bg_inuse++;
-	return 0;
-}
-
-/*
- * Remove a pointer from a bag.
- */
-int
-bag_remove(
-	struct xfs_bag	*bag,
-	uint64_t	nr)
-{
-	ASSERT(nr < bag->bg_inuse);
-	memmove(bag_ptr(bag, nr), bag_ptr(bag, nr + 1),
-		(bag->bg_inuse - nr - 1) * bag->bg_item_sz);
-	bag->bg_inuse--;
-	return 0;
-}
-
-/*
- * Return the number of items in a bag.
- */
-uint64_t
-bag_count(
-	struct xfs_bag	*bag)
-{
-	return bag->bg_inuse;
-}
-
-/*
- * Return the nth item in a bag.
- */
-void *
-bag_item(
-	struct xfs_bag	*bag,
-	uint64_t	nr)
-{
-	if (nr >= bag->bg_inuse)
-		return NULL;
-	return bag_ptr(bag, nr);
-}
diff --git a/repair/slab.h b/repair/slab.h
index 019b16902..77fb32163 100644
--- a/repair/slab.h
+++ b/repair/slab.h
@@ -26,23 +26,4 @@ void *peek_slab_cursor(struct xfs_slab_cursor *cur);
 void advance_slab_cursor(struct xfs_slab_cursor *cur);
 void *pop_slab_cursor(struct xfs_slab_cursor *cur);
 
-struct xfs_bag;
-
-int init_bag(struct xfs_bag **bagp, size_t itemsz);
-void free_bag(struct xfs_bag **bagp);
-int bag_add(struct xfs_bag *bag, void *item);
-int bag_remove(struct xfs_bag *bag, uint64_t idx);
-uint64_t bag_count(struct xfs_bag *bag);
-void *bag_item(struct xfs_bag *bag, uint64_t idx);
-
-#define foreach_bag_ptr(bag, idx, ptr) \
-	for ((idx) = 0, (ptr) = bag_item((bag), (idx)); \
-	     (idx) < bag_count(bag); \
-	     (idx)++, (ptr) = bag_item((bag), (idx)))
-
-#define foreach_bag_ptr_reverse(bag, idx, ptr) \
-	for ((idx) = bag_count(bag) - 1, (ptr) = bag_item((bag), (idx)); \
-	     (ptr) != NULL; \
-	     (idx)--, (ptr) = bag_item((bag), (idx)))
-
 #endif /* SLAB_H_ */

