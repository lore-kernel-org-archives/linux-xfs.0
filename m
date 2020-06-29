Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F41C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62612208B6
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rky6iNTI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbgF2V2v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731317AbgF2V2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 17:28:49 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B038C03E979;
        Mon, 29 Jun 2020 14:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FyJL4yyDO/gWVDZyYZ3YcoaeT7XcvdIdgrag616w1Xk=; b=Rky6iNTIwDEnIUeWaavHS2OWll
        Z1wwEEvinP2FRjO8w/yus70RentyESKNHEgmtAPCGRbbyjXNB9x0qOipwdmJRII5DKdCeXtLvjW8U
        6aOjSLiddKH9vfEi+80xwE+hhQQgMQDTN/ZWiObur7RUEPZ0lwCTryc9ODj4uTFteo+FDT7ABqH7q
        mk2rbTO7a5EkZyi0Ay2ljEhcGAGK84TI/wvPVIgewia6zbJsAsJvtUJx1h1wwCJfcjbsNYQfCmA32
        0oLoRGz2fVoaTit7ljzydi0JV6nCOYowZtWt0VS6/Bg1nwtFLe1gTcX9s/jSonLzXwWJ/v/nODxqi
        FHg2breA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jq1KI-0006Yy-Ou; Mon, 29 Jun 2020 21:28:30 +0000
Date:   Mon, 29 Jun 2020 22:28:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200629212830.GJ25523@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
 <20200629125231.GJ32461@dhcp22.suse.cz>
 <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 29, 2020 at 04:45:14PM +0300, Mike Rapoport wrote:
> 
> 
> On June 29, 2020 3:52:31 PM GMT+03:00, Michal Hocko <mhocko@kernel.org> wrote:
> >On Mon 29-06-20 13:18:16, Matthew Wilcox wrote:
> >> On Mon, Jun 29, 2020 at 08:08:51AM +0300, Mike Rapoport wrote:
> >> > > @@ -886,8 +868,12 @@ static struct dm_buffer
> >*__alloc_buffer_wait_no_callback(struct dm_bufio_client
> >> > >  			return NULL;
> >> > >  
> >> > >  		if (dm_bufio_cache_size_latch != 1 && !tried_noio_alloc) {
> >> > > +			unsigned noio_flag;
> >> > > +
> >> > >  			dm_bufio_unlock(c);
> >> > > -			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY |
> >__GFP_NOMEMALLOC | __GFP_NOWARN);
> >> > > +			noio_flag = memalloc_noio_save();
> >> > 
> >> > I've read the series twice and I'm still missing the definition of
> >> > memalloc_noio_save().
> >> > 
> >> > And also it would be nice to have a paragraph about it in
> >> > Documentation/core-api/memory-allocation.rst
> >> 
> >>
> >Documentation/core-api/gfp_mask-from-fs-io.rst:``memalloc_nofs_save``,
> >``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
> >> Documentation/core-api/gfp_mask-from-fs-io.rst:   :functions:
> >memalloc_noio_save memalloc_noio_restore
> >> Documentation/core-api/gfp_mask-from-fs-io.rst:allows nesting so it
> >is safe to call ``memalloc_noio_save`` or
> > 
> >The patch is adding memalloc_nowait* and I suspect Mike had that in
> >mind, which would be a fair request. 
> 
> Right, sorry misprinted that.
> 
> > Btw. we are missing
> >memalloc_nocma*
> >documentation either - I was just reminded of its existence today..

Heh.  Oops, not sure how those got left out.  I hadn't touched the
documentation either, so -1 points to me.

The documentation is hard to add a new case to, so I rewrote it.  What
do you think?  (Obviously I'll split this out differently for submission;
this is just what I have in my tree right now).

diff --git a/Documentation/core-api/gfp_mask-from-fs-io.rst b/Documentation/core-api/gfp_mask-from-fs-io.rst
deleted file mode 100644
index e7c32a8de126..000000000000
--- a/Documentation/core-api/gfp_mask-from-fs-io.rst
+++ /dev/null
@@ -1,68 +0,0 @@
-.. _gfp_mask_from_fs_io:
-
-=================================
-GFP masks used from FS/IO context
-=================================
-
-:Date: May, 2018
-:Author: Michal Hocko <mhocko@kernel.org>
-
-Introduction
-============
-
-Code paths in the filesystem and IO stacks must be careful when
-allocating memory to prevent recursion deadlocks caused by direct
-memory reclaim calling back into the FS or IO paths and blocking on
-already held resources (e.g. locks - most commonly those used for the
-transaction context).
-
-The traditional way to avoid this deadlock problem is to clear __GFP_FS
-respectively __GFP_IO (note the latter implies clearing the first as well) in
-the gfp mask when calling an allocator. GFP_NOFS respectively GFP_NOIO can be
-used as shortcut. It turned out though that above approach has led to
-abuses when the restricted gfp mask is used "just in case" without a
-deeper consideration which leads to problems because an excessive use
-of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
-reclaim issues.
-
-New API
-========
-
-Since 4.12 we do have a generic scope API for both NOFS and NOIO context
-``memalloc_nofs_save``, ``memalloc_nofs_restore`` respectively ``memalloc_noio_save``,
-``memalloc_noio_restore`` which allow to mark a scope to be a critical
-section from a filesystem or I/O point of view. Any allocation from that
-scope will inherently drop __GFP_FS respectively __GFP_IO from the given
-mask so no memory allocation can recurse back in the FS/IO.
-
-.. kernel-doc:: include/linux/sched/mm.h
-   :functions: memalloc_nofs_save memalloc_nofs_restore
-.. kernel-doc:: include/linux/sched/mm.h
-   :functions: memalloc_noio_save memalloc_noio_restore
-
-FS/IO code then simply calls the appropriate save function before
-any critical section with respect to the reclaim is started - e.g.
-lock shared with the reclaim context or when a transaction context
-nesting would be possible via reclaim. The restore function should be
-called when the critical section ends. All that ideally along with an
-explanation what is the reclaim context for easier maintenance.
-
-Please note that the proper pairing of save/restore functions
-allows nesting so it is safe to call ``memalloc_noio_save`` or
-``memalloc_noio_restore`` respectively from an existing NOIO or NOFS
-scope.
-
-What about __vmalloc(GFP_NOFS)
-==============================
-
-vmalloc doesn't support GFP_NOFS semantic because there are hardcoded
-GFP_KERNEL allocations deep inside the allocator which are quite non-trivial
-to fix up. That means that calling ``vmalloc`` with GFP_NOFS/GFP_NOIO is
-almost always a bug. The good news is that the NOFS/NOIO semantic can be
-achieved by the scope API.
-
-In the ideal world, upper layers should already mark dangerous contexts
-and so no special care is required and vmalloc should be called without
-any problems. Sometimes if the context is not really clear or there are
-layering violations then the recommended way around that is to wrap ``vmalloc``
-by the scope API with a comment explaining the problem.
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 15ab86112627..55f611e34a1d 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -90,7 +90,6 @@ more memory-management documentation in :doc:`/vm/index`.
    genalloc
    pin_user_pages
    boot-time-mm
-   gfp_mask-from-fs-io
 
 Interfaces for kernel debugging
 ===============================
diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 4aa82ddd01b8..c6287c25ff99 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -69,13 +69,12 @@ here we briefly outline their recommended usage:
     ``GFP_USER`` means that the allocated memory is not movable and it
     must be directly accessible by the kernel.
 
-You may notice that quite a few allocations in the existing code
-specify ``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to
-prevent recursion deadlocks caused by direct memory reclaim calling
-back into the FS or IO paths and blocking on already held
-resources. Since 4.12 the preferred way to address this issue is to
-use new scope APIs described in
-:ref:`Documentation/core-api/gfp_mask-from-fs-io.rst <gfp_mask_from_fs_io>`.
+You may notice that quite a few allocations in the existing code specify
+``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to prevent
+recursion deadlocks caused by direct memory reclaim calling back into
+the FS or IO paths and blocking on already held resources. Since 4.12
+the preferred way to address this issue is to use the new scope APIs
+described below.
 
 Other legacy GFP flags are ``GFP_DMA`` and ``GFP_DMA32``. They are
 used to ensure that the allocated memory is accessible by hardware
@@ -84,6 +83,37 @@ driver for a device with such restrictions, avoid using these flags.
 And even with hardware with restrictions it is preferable to use
 `dma_alloc*` APIs.
 
+Memory scoping API
+==================
+
+Traditionally, we have passed GFP flags to functions that we call,
+indicating what kind of actions may be taken to free up memory if none
+is currently available.  This has proved impractical in some places and
+so we are currently transitioning to the calls below which override the
+flags specified by any particular call to allocate memory.
+
+.. kernel-doc:: include/linux/sched/mm.h
+   :functions: memalloc_nofs_save memalloc_nofs_restore
+.. kernel-doc:: include/linux/sched/mm.h
+   :functions: memalloc_noio_save memalloc_noio_restore
+.. kernel-doc:: include/linux/sched/mm.h
+   :functions: memalloc_nocma_save memalloc_nocma_restore
+.. kernel-doc:: include/linux/sched/mm.h
+   :functions: memalloc_nowait_save memalloc_nowait_restore
+
+These functions should be called at the point where any memory allocation
+would start to cause problems.  That is, do not simply wrap individual
+memory allocation calls which currently use ``GFP_NOFS`` with a pair
+of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
+find the lock which is taken that would cause problems if memory reclaim
+reentered the filesystem, place a call to memalloc_nofs_save() before it
+is acquired and a call to memalloc_nofs_restore() after it is released.
+Ideally also add a comment explaining why this lock will be problematic.
+
+Please note that the proper pairing of save/restore functions
+allows nesting so it is safe to call memalloc_noio_save() and
+memalloc_noio_restore() within an existing NOIO or NOFS scope.
+
 Selecting memory allocator
 ==========================
 
@@ -104,16 +134,19 @@ ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
 alignment is also guaranteed to be at least the respective size.
 
 For large allocations you can use vmalloc() and vzalloc(), or directly
-request pages from the page allocator. The memory allocated by `vmalloc`
-and related functions is not physically contiguous.
+request pages from the page allocator.  The memory allocated by `vmalloc`
+and related functions is not physically contiguous.  The `vmalloc`
+family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
+flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
+the allocator which are hard to remove.  However, the scope APIs described
+above can be used to limit the `vmalloc` functions.
 
 If you are not sure whether the allocation size is too large for
 `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
 try to allocate memory with `kmalloc` and if the allocation fails it
-will be retried with `vmalloc`. There are restrictions on which GFP
-flags can be used with `kvmalloc`; please see kvmalloc_node() reference
-documentation. Note that `kvmalloc` may return memory that is not
-physically contiguous.
+will be retried with `vmalloc`. That means the GFP flags supported by
+`kvmalloc` are the same as those supported by `vmalloc` and `kvmalloc`
+may return memory that is not physically contiguous.
 
 If you need to allocate many identical objects you can use the slab
 cache allocator. The cache should be set up with kmem_cache_create() or
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 6484569f50df..9fc091274d1d 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -186,9 +186,10 @@ static inline gfp_t current_gfp_context(gfp_t flags)
 		 * them.  noio implies neither IO nor FS and it is a weaker
 		 * context so always make sure it takes precedence.
 		 */
-		if (current->memalloc_nowait)
+		if (current->memalloc_nowait) {
 			flags &= ~__GFP_DIRECT_RECLAIM;
-		else if (current->memalloc_noio)
+			flags |= __GFP_NOWARN;
+		} else if (current->memalloc_noio)
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (current->memalloc_nofs)
 			flags &= ~__GFP_FS;
@@ -275,6 +276,36 @@ static inline void memalloc_nofs_restore(unsigned int flags)
 	current->memalloc_nofs = flags ? 1 : 0;
 }
 
+/**
+ * memalloc_nowait_save - Marks implicit GFP_NOWAIT allocation scope.
+ *
+ * This functions marks the beginning of the GFP_NOWAIT allocation scope.
+ * All further allocations will implicitly disallow all waiting in the
+ * page allocator.  Use memalloc_nowait_restore() to end the scope with
+ * flags returned by this function.
+ *
+ * This function is safe to be used from any context.
+ */
+static inline unsigned int memalloc_nowait_save(void)
+{
+	unsigned int flags = current->memalloc_nowait;
+	current->memalloc_nowait = 1;
+	return flags;
+}
+
+/**
+ * memalloc_nowait_restore - Ends the implicit GFP_NOWAIT scope.
+ * @flags: Flags to restore.
+ *
+ * Ends the implicit GFP_NOWAIT scope started by memalloc_nowait_save().
+ * Always make sure that that the given flags is the return value from the
+ * pairing memalloc_nowait_save call.
+ */
+static inline void memalloc_nowait_restore(unsigned int flags)
+{
+	current->memalloc_nowait = flags ? 1 : 0;
+}
+
 static inline unsigned int memalloc_noreclaim_save(void)
 {
 	unsigned int flags = current->flags & PF_MEMALLOC;
