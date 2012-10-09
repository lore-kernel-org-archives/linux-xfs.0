Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q994NN3f217280 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 23:23:23 -0500
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	CIsc25q9rQFnnY3V (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 21:24:51 -0700 (PDT)
Received: by mail-ie0-f181.google.com with SMTP id 16so11249780iea.26
	for <xfs@oss.sgi.com>; Mon, 08 Oct 2012 21:24:51 -0700 (PDT)
Date: Mon, 8 Oct 2012 21:24:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
In-Reply-To: <1349108796-32161-1-git-send-email-jack@suse.cz>
Message-ID: <alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>

On Mon, 1 Oct 2012, Jan Kara wrote:

> On s390 any write to a page (even from kernel itself) sets architecture
> specific page dirty bit. Thus when a page is written to via standard write, HW
> dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> finds the dirty bit and calls set_page_dirty().
> 
> Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> filesystems. The bug we observed in practice is that buffers from the page get
> freed, so when the page gets later marked as dirty and writeback writes it, XFS
> crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> from xfs_count_page_state().

What changed recently?  Was XFS hardly used on s390 until now?

> 
> Similar problem can also happen when zero_user_segment() call from
> xfs_vm_writepage() (or block_write_full_page() for that matter) set the
> hardware dirty bit during writeback, later buffers get freed, and then page
> unmapped.
> 
> Fix the issue by ignoring s390 HW dirty bit for page cache pages in
> page_mkclean() and page_remove_rmap(). This is safe because when a page gets
> marked as writeable in PTE it is also marked dirty in do_wp_page() or
> do_page_fault(). When the dirty bit is cleared by clear_page_dirty_for_io(),
> the page gets writeprotected in page_mkclean(). So pagecache page is writeable
> if and only if it is dirty.

Very interesting patch...

> 
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>

which I'd very much like Martin's opinion on...

> CC: Mel Gorman <mgorman@suse.de>

and I'm grateful to Mel's ack for reawakening me to it...

> CC: linux-s390@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

but I think it's wrong.

> ---
>  mm/rmap.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0f3b7cd..6ce8ddb 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -973,7 +973,15 @@ int page_mkclean(struct page *page)
>  		struct address_space *mapping = page_mapping(page);
>  		if (mapping) {
>  			ret = page_mkclean_file(mapping, page);
> -			if (page_test_and_clear_dirty(page_to_pfn(page), 1))
> +			/*
> +			 * We ignore dirty bit for pagecache pages. It is safe
> +			 * as page is marked dirty iff it is writeable (page is
> +			 * marked as dirty when it is made writeable and
> +			 * clear_page_dirty_for_io() writeprotects the page
> +			 * again).
> +			 */
> +			if (PageSwapCache(page) &&
> +			    page_test_and_clear_dirty(page_to_pfn(page), 1))
>  				ret = 1;

This part you could cut out: page_mkclean() is not used on SwapCache pages.
I believe you are safe to remove the page_test_and_clear_dirty() from here.

>  		}
>  	}
> @@ -1183,8 +1191,12 @@ void page_remove_rmap(struct page *page)
>  	 * this if the page is anon, so about to be freed; but perhaps
>  	 * not if it's in swapcache - there might be another pte slot
>  	 * containing the swap entry, but page not yet written to swap.
> +	 * For pagecache pages, we don't care about dirty bit in storage
> +	 * key because the page is writeable iff it is dirty (page is marked
> +	 * as dirty when it is made writeable and clear_page_dirty_for_io()
> +	 * writeprotects the page again).
>  	 */
> -	if ((!anon || PageSwapCache(page)) &&
> +	if (PageSwapCache(page) &&
>  	    page_test_and_clear_dirty(page_to_pfn(page), 1))
>  		set_page_dirty(page);

But here's where I think the problem is.  You're assuming that all
filesystems go the same mapping_cap_account_writeback_dirty() (yeah,
there's no such function, just a confusing maze of three) route as XFS.

But filesystems like tmpfs and ramfs (perhaps they're the only two
that matter here) don't participate in that, and wait for an mmap'ed
page to be seen modified by the user (usually via pte_dirty, but that's
a no-op on s390) before page is marked dirty; and page reclaim throws
away undirtied pages.

So, if I'm understanding right, with this change s390 would be in danger
of discarding shm, and mmap'ed tmpfs and ramfs pages - whereas pages
written with the write system call would already be PageDirty and secure.

You mention above that even the kernel writing to the page would mark
the s390 storage key dirty.  I think that means that these shm and
tmpfs and ramfs pages would all have dirty storage keys just from the
clear_highpage() used to prepare them originally, and so would have
been found dirty anyway by the existing code here in page_remove_rmap(),
even though other architectures would regard them as clean and removable.

If that's the case, then maybe we'd do better just to mark them dirty
when faulted in the s390 case.  Then your patch above should (I think)
be safe.  Though I'd then be VERY tempted to adjust the SwapCache case
too (I've not thought through exactly what that patch would be, just
one or two suitably placed SetPageDirtys, I think), and eliminate
page_test_and_clear_dirty() altogether - no tears shed by any of us!

A separate worry came to mind as I thought about your patch: where
in page migration is s390's dirty storage key migrated from old page
to new?  And if there is a problem there, that too should be fixed
by what I propose in the previous paragraph.

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
