Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 01:24:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L8NwH6027939
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:23:59 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CC8A144AEBB
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:25:43 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id OM2b5XFgRJY0qZ1f for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 01:25:43 -0700 (PDT)
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 7ECC3429D3
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 10:31:48 +0200 (CEST)
Date: Tue, 21 Oct 2008 10:25:42 +0200
From: Nick Piggin <npiggin@suse.de>
Subject: [patch 1/2] xfs: remove old vmap cache
Message-ID: <20081021082542.GA6974@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


XFS's vmap batching simply defers a number (up to 64) of vunmaps, and keeps
track of them in a list. To purge the batch, it just goes through the list and
calls vunamp on each one. This is pretty poor: a global TLB flush is generally
still performed on each vunmap, with the most expensive parts of the operation
being the broadcast IPIs and locking involved in the SMP callouts, and the
locking involved in the vmap management -- none of these are avoided by just
batching up the calls. I'm actually surprised it ever made much difference.
(Now that the lazy vmap allocator is upstream, this description is not quite
right, but the vunmap batching still doesn't seem to do much)

Rip all this logic out of XFS completely. I will improve vmap performance
and scalability directly in subsequent patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -166,75 +166,6 @@ test_page_region(
 }
 
 /*
- *	Mapping of multi-page buffers into contiguous virtual space
- */
-
-typedef struct a_list {
-	void		*vm_addr;
-	struct a_list	*next;
-} a_list_t;
-
-static a_list_t		*as_free_head;
-static int		as_list_len;
-static DEFINE_SPINLOCK(as_lock);
-
-/*
- *	Try to batch vunmaps because they are costly.
- */
-STATIC void
-free_address(
-	void		*addr)
-{
-	a_list_t	*aentry;
-
-#ifdef CONFIG_XEN
-	/*
-	 * Xen needs to be able to make sure it can get an exclusive
-	 * RO mapping of pages it wants to turn into a pagetable.  If
-	 * a newly allocated page is also still being vmap()ed by xfs,
-	 * it will cause pagetable construction to fail.  This is a
-	 * quick workaround to always eagerly unmap pages so that Xen
-	 * is happy.
-	 */
-	vunmap(addr);
-	return;
-#endif
-
-	aentry = kmalloc(sizeof(a_list_t), GFP_NOWAIT);
-	if (likely(aentry)) {
-		spin_lock(&as_lock);
-		aentry->next = as_free_head;
-		aentry->vm_addr = addr;
-		as_free_head = aentry;
-		as_list_len++;
-		spin_unlock(&as_lock);
-	} else {
-		vunmap(addr);
-	}
-}
-
-STATIC void
-purge_addresses(void)
-{
-	a_list_t	*aentry, *old;
-
-	if (as_free_head == NULL)
-		return;
-
-	spin_lock(&as_lock);
-	aentry = as_free_head;
-	as_free_head = NULL;
-	as_list_len = 0;
-	spin_unlock(&as_lock);
-
-	while ((old = aentry) != NULL) {
-		vunmap(aentry->vm_addr);
-		aentry = aentry->next;
-		kfree(old);
-	}
-}
-
-/*
  *	Internal xfs_buf_t object manipulation
  */
 
@@ -333,7 +264,7 @@ xfs_buf_free(
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
-			free_address(bp->b_addr - bp->b_offset);
+			vunmap(bp->b_addr - bp->b_offset);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -455,8 +386,6 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		if (as_list_len > 64)
-			purge_addresses();
 		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
 					VM_MAP, PAGE_KERNEL);
 		if (unlikely(bp->b_addr == NULL))
@@ -1732,8 +1661,6 @@ xfsbufd(
 			count++;
 		}
 
-		if (as_list_len > 0)
-			purge_addresses();
 		if (count)
 			blk_run_address_space(target->bt_mapping);
 
