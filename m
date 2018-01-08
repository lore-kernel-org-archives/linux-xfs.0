Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35317 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756327AbeAHNuG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 08:50:06 -0500
Date: Mon, 8 Jan 2018 14:50:02 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 17/18] mm, fs, dax: dax_flush_dma, handle dma vs
 block-map-change collisions
Message-ID: <20180108135002.mk427dfa3wfphsgt@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180104111233.GD29010@quack2.suse.cz>
 <CAA9_cmcL7E7F+sEp1wn6H4TQBQeNttm_MSJjKT9jNfOri8iK9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmcL7E7F+sEp1wn6H4TQBQeNttm_MSJjKT9jNfOri8iK9g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Sun 07-01-18 13:58:42, Dan Williams wrote:
> On Thu, Jan 4, 2018 at 3:12 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sat 23-12-17 16:57:31, Dan Williams wrote:
> >
> >> +     /*
> >> +      * Flush dax_dma_lock() sections to ensure all possible page
> >> +      * references have been taken, or will block on the fs
> >> +      * 'mmap_lock'.
> >> +      */
> >> +     synchronize_rcu();
> >
> > Frankly, I don't like synchronize_rcu() in a relatively hot path like this.
> > Cannot we just abuse get_dev_pagemap() to fail if truncation is in progress
> > for the pfn? We could indicate that by some bit in struct page or something
> > like that.
> 
> We would need a lockless way to take a reference conditionally if the
> page is not subject to truncation.
> 
> I recall the raid5 code did something similar where it split a
> reference count into 2 fields. I.e. take page->_refcount and use the
> upper bits as a truncation count. Something like:
> 
> do {
>     old = atomic_read(&page->_refcount);
>     if (old & trunc_mask) /* upper bits of _refcount */
>         return false;
>     new = cnt + 1;
> } while (atomic_cmpxchg(&page->_refcount, old, new) != old);
> return true; /* we incremented the _refcount while the truncation
> count was zero */
> 
> ...the only concern is teaching the put_page() path to consider that
> 'trunc_mask' when determining that the page is idle.
> 
> Other ideas?

What I rather thought about was an update to GUP paths (like
follow_page_pte()):

	if (flags & FOLL_GET) {
		get_page(page);
		if (pte_devmap(pte)) {
			/*
			 * Pairs with the barrier in the truncate path.
			 * Could be possibly _after_atomic version of the
			 * barrier.
			 */
			smp_mb();
			if (PageTruncateInProgress(page)) {
				put_page(page);
				..bail...
			}
		}
	}

and in the truncate path:

	down_write(inode->i_mmap_sem);
	walk all pages in the mapping and mark them PageTruncateInProgress().
	unmap_mapping_range(...);
	/*
	 * Pairs with the barrier in GUP path. In fact not necessary since
	 * unmap_mapping_range() provides us with the barrier already.
	 */
	smp_mb();
	/*
	 * By now we are either guaranteed to see grabbed page reference or
	 * GUP is guaranteed to see PageTruncateInProgress().
	 */
	while ((page = dax_find_referenced_page(mapping))) {
		...
	}

The barriers need some verification, I've opted for the conservative option
but I guess you get the idea.


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
