Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99Mx8ON120755 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 17:59:09 -0500
Received: from mail-ia0-f181.google.com (mail-ia0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	R3CLG9USoGLEkHvy (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 16:00:39 -0700 (PDT)
Received: by mail-ia0-f181.google.com with SMTP id x2so1365443iad.26
	for <xfs@oss.sgi.com>; Tue, 09 Oct 2012 16:00:38 -0700 (PDT)
Date: Tue, 9 Oct 2012 16:00:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
In-Reply-To: <20121009093250.GP29125@suse.de>
Message-ID: <alpine.LSU.2.00.1210091530020.30446@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009093250.GP29125@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: linux-s390@vger.kernel.org, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>

On Tue, 9 Oct 2012, Mel Gorman wrote:
> On Mon, Oct 08, 2012 at 09:24:40PM -0700, Hugh Dickins wrote:
> > 
> > So, if I'm understanding right, with this change s390 would be in danger
> > of discarding shm, and mmap'ed tmpfs and ramfs pages - whereas pages
> > written with the write system call would already be PageDirty and secure.
> > 
> 
> In the case of ramfs, what marks the page clean so it could be discarded? It
> does not participate in dirty accounting so it's not going to clear the
> dirty flag in clear_page_dirty_for_io(). It doesn't have a writepage
> handler that would use an end_io handler to clear the page after "IO"
> completes. I am not seeing how a ramfs page can get discarded at the moment.

But we don't have a page clean bit: we have a page dirty bit, and where
is that set in the ramfs read-fault case?  I've not experimented to check,
maybe you're right and ramfs is exempt from the issue.  I thought it was
__do_fault() which does the set_page_dirty, but only if FAULT_FLAG_WRITE.
Ah, you quote almost the very place further down.

> 
> shm and tmpfs are indeed different and I did not take them into account
> (ba dum tisch) when reviewing. For those pages would it be sufficient to
> check the following?
> 
> PageSwapCache(page) || (page->mapping && !bdi_cap_account_dirty(page->mapping)

Something like that, yes: I've a possible patch I'll put in reply to Jan.

> 
> The problem the patch dealt with involved buffers associated with the page
> and that shouldn't be a problem for tmpfs, right?

Right, though I'm now beginning to wonder what the underlying bug is.
It seems to me that we have a bug and an optimization on our hands,
and have rushed into the optimization which would avoid the bug,
without considering what the actual bug is.  More in reply to Jan.

> I recognise that this
> might work just because of co-incidence and set off your "Yuck" detector
> and you'll prefer the proposed solution below.

No, I was mistaken to think that s390 would have dirty pages where
others had clean, Martin has now explained that SetPageUptodate cleans.
I didn't mind continuing an (imagined) inefficiency in s390, but I don't
want to make it more inefficient.

> 
> > You mention above that even the kernel writing to the page would mark
> > the s390 storage key dirty.  I think that means that these shm and
> > tmpfs and ramfs pages would all have dirty storage keys just from the
> > clear_highpage() used to prepare them originally, and so would have
> > been found dirty anyway by the existing code here in page_remove_rmap(),
> > even though other architectures would regard them as clean and removable.
> > 
> > If that's the case, then maybe we'd do better just to mark them dirty
> > when faulted in the s390 case.  Then your patch above should (I think)
> > be safe.  Though I'd then be VERY tempted to adjust the SwapCache case
> > too (I've not thought through exactly what that patch would be, just
> > one or two suitably placed SetPageDirtys, I think), and eliminate
> > page_test_and_clear_dirty() altogether - no tears shed by any of us!

So that fantasy was all wrong: appealing, but wrong.

> >  
> 
> Do you mean something like this?
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 5736170..c66166f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3316,7 +3316,20 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		} else {
>  			inc_mm_counter_fast(mm, MM_FILEPAGES);
>  			page_add_file_rmap(page);
> -			if (flags & FAULT_FLAG_WRITE) {
> +
> +			/*
> +			 * s390 depends on the dirty flag from the storage key
> +			 * being propagated when the page is unmapped from the
> +			 * page tables. For dirty-accounted mapping, we instead
> +			 * depend on the page being marked dirty on writes and
> +			 * being write-protected on clear_page_dirty_for_io.
> +			 * The same protection does not apply for tmpfs pages
> +			 * that do not participate in dirty accounting so mark
> +			 * them dirty at fault time to avoid the data being
> +			 * lost
> +			 */
> +			if (flags & FAULT_FLAG_WRITE ||
> +			    !bdi_cap_account_dirty(page->mapping)) {
>  				dirty_page = page;
>  				get_page(dirty_page);
>  			}
> 
> Could something like this result in more writes to swap? Lets say there
> is an unmapped tmpfs file with data on it -- a process maps it, reads the
> entire mapping and exits. The page is now dirty and potentially will have
> to be rewritten to swap. That seems bad. Did I miss your point?

My point was that I mistakenly thought s390 must already be behaving
like that, so wanted it to continue that way, but with cleaner source.

But the CONFIG_S390 in SetPageUptodate makes sure that the zeroed page
starts out storage-key-clean: so you're exactly right, my suggestion
would result in more writes to swap for it, which is not acceptable.

(Plus, having insisted that ramfs is also affected, I went on
to forget that, and was imagining a simple change in mm/shmem.c.)

Hugh

> 
> > A separate worry came to mind as I thought about your patch: where
> > in page migration is s390's dirty storage key migrated from old page
> > to new?  And if there is a problem there, that too should be fixed
> > by what I propose in the previous paragraph.
> > 
> 
> hmm, very good question. It should have been checked in
> migrate_page_copy() where it could be done under the page lock before
> the PageDirty check. Martin?
> 
> -- 
> Mel Gorman
> SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
