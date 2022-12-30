Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCE3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiLaARm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbiLaARl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:17:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9FC1261F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC4D61D08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A72C433D2;
        Sat, 31 Dec 2022 00:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445860;
        bh=57BjpEo7wTZTHd2JrdpSJSaAekL/R1qn6C51RUWP8z4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KF6rwzi7l+P2yoRPefz74OnsgAc/2RJmRsXdJ/x9Sime1eEMMMuBg1zP3lbUydFZy
         qSdcbkmV5UZRr9tgJfNhRtChKBgzJnGjJMcd7/n0czMR5aVC+or0HQBoGf5vF6cl1T
         4CPrOUhtNzNixgEayDShUhAnI8BHPD9PbHFMoyE2pI35xi9q2M1RA0I/m8ICcZdjJ0
         mHShIRHF+v+lYSijVCfOvWv62XLlkgPYP6uPHj6bC4PgQwqBJG6Uh98Eb07D2/StYH
         081BiORHKZSNQiJZoWNDcoWTMTUC1l7lpMQ9KdTGjVS5gbCo8V5DJ3V4roXMfH4WEU
         exjh3tfiZgDlw==
Subject: [PATCH 5/5] xfs_repair: remove the old bag implementation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867310.712955.11202535687694387202.stgit@magnolia>
In-Reply-To: <167243867247.712955.4006304832992035940.stgit@magnolia>
References: <167243867247.712955.4006304832992035940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the old bag implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/rmap.c |    7 ---
 repair/slab.c |  130 ---------------------------------------------------------
 repair/slab.h |   19 --------
 3 files changed, 156 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index ef1a599162b..f8294cc3e13 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -34,13 +34,6 @@ struct xfs_ag_rmap {
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
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
index 44ca0468eda..a0114ac2373 100644
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
index 019b169024d..77fb32163d5 100644
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

