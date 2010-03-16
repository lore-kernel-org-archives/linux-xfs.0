Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2GIsN2O192306 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 13:54:23 -0500
Subject: [PATCH 1/2] xfs: remove old vmap cache
From: Alex Elder <aelder@sgi.com>
Date: Tue, 16 Mar 2010 13:55:54 -0500
Message-ID: <1268765754.1951.26.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: hch@lst.de

Re-apply a commit that had been reverted due to regressions
that have since been fixed.

    Original commit: d2859751cd0bf586941ffa7308635a293f943c17
    Author: Nick Piggin <npiggin@suse.de>
    Date: Tue, 6 Jan 2009 14:40:44 +1100

    XFS's vmap batching simply defers a number (up to 64) of vunmaps,
    and keeps track of them in a list. To purge the batch, it just goes
    through the list and calls vunamp on each one. This is pretty poor:
    a global TLB flush is generally still performed on each vunmap, with
    the most expensive parts of the operation being the broadcast IPIs
    and locking involved in the SMP callouts, and the locking involved
    in the vmap management -- none of these are avoided by just batching
    up the calls. I'm actually surprised it ever made much difference.
    (Now that the lazy vmap allocator is upstream, this description is
    not quite right, but the vunmap batching still doesn't seem to do
    much).

    Rip all this logic out of XFS completely. I will improve vmap
    performance and scalability directly in subsequent patch.

    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Reviewed-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

The only change I made was to use the "new" xfs_buf_is_vmapped()
function in a place it had been open-coded in the original.

Modified-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_buf.c |   76 ---------------------------------------------
 1 file changed, 1 insertion(+), 75 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -168,75 +168,6 @@ test_page_region(
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
 
@@ -337,7 +268,7 @@ xfs_buf_free(
 		uint		i;
 
 		if (xfs_buf_is_vmapped(bp))
-			free_address(bp->b_addr - bp->b_offset);
+			vunmap(bp->b_addr - bp->b_offset);
 
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
@@ -457,8 +388,6 @@ _xfs_buf_map_pages(
 		bp->b_addr = page_address(bp->b_pages[0]) + bp->b_offset;
 		bp->b_flags |= XBF_MAPPED;
 	} else if (flags & XBF_MAPPED) {
-		if (as_list_len > 64)
-			purge_addresses();
 		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
 					VM_MAP, PAGE_KERNEL);
 		if (unlikely(bp->b_addr == NULL))
@@ -1955,9 +1884,6 @@ xfsbufd(
 			xfs_buf_iostrategy(bp);
 			count++;
 		}
-
-		if (as_list_len > 0)
-			purge_addresses();
 		if (count)
 			blk_run_address_space(target->bt_mapping);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
