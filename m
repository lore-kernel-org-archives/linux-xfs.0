Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ALRAse160943 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 16:27:10 -0500
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	GrehgfYA7SHmWvHO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 14:28:41 -0700 (PDT)
Received: by mail-ie0-f181.google.com with SMTP id 16so1874251iea.26
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 14:28:41 -0700 (PDT)
Date: Wed, 10 Oct 2012 14:28:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
In-Reply-To: <20121010085524.GA32581@quack.suse.cz>
Message-ID: <alpine.LSU.2.00.1210101402310.1939@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009162107.GE15790@quack.suse.cz>
	<alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
	<20121010085524.GA32581@quack.suse.cz>
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

On Wed, 10 Oct 2012, Jan Kara wrote:
> On Tue 09-10-12 19:19:09, Hugh Dickins wrote:
> > On Tue, 9 Oct 2012, Jan Kara wrote:
> > > On Mon 08-10-12 21:24:40, Hugh Dickins wrote:
> > > > On Mon, 1 Oct 2012, Jan Kara wrote:
> > > > 
> > > > > On s390 any write to a page (even from kernel itself) sets architecture
> > > > > specific page dirty bit. Thus when a page is written to via standard write, HW
> > > > > dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> > > > > finds the dirty bit and calls set_page_dirty().
> > > > > 
> > > > > Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> > > > > filesystems. The bug we observed in practice is that buffers from the page get
> > > > > freed, so when the page gets later marked as dirty and writeback writes it, XFS
> > > > > crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> > > > > from xfs_count_page_state().
> ...
> > > > > Similar problem can also happen when zero_user_segment() call from
> > > > > xfs_vm_writepage() (or block_write_full_page() for that matter) set the
> > > > > hardware dirty bit during writeback, later buffers get freed, and then page
> > > > > unmapped.
> > 
> > Similar problem, or is that the whole of the problem?  Where else does
> > the page get written to, after clearing page dirty?  (It may not be worth
> > spending time to answer me, I feel I'm wasting too much time on this.)
>   I think the devil is in "after clearing page dirty" -
> clear_page_dirty_for_io() has an optimization that it does not bother
> transfering pte or storage key dirty bits to page dirty bit when page is
> not mapped.

Right, its "if (page_mkclean) set_page_dirty".

> On s390 that results in storage key dirty bit set once buffered
> write modifies the page.

Ah yes, because set_page_dirty does not clean the storage key,
as perhaps I was expecting (and we wouldn't want to add that if
everything is working without).

> 
> BTW there's no other place I'm aware of (and I was looking for some time
> before I realized that storage key could remain set from buffered write as
> described above).

> > I guess I'm worrying too much; but it's not crystal clear to me why any
> > !mapping_cap_account_dirty mapping would necessarily not have the problem.
>   They can have a problem - if they cared that page_remove_rmap() can mark
> as dirty a page which was never written to via mmap. So far we are lucky
> and all !mapping_cap_account_dirty users don't care.

Yes, I think it's good enough: it's a workaround rather than a thorough
future-proof fix; a workaround with a nice optimization bonus for s390.

> > >   Things should be ok (modulo the ugliness of this condition), right?
> > 
> > (Setting aside my reservations above...) That's almost exactly right, but
> > I think the issue of a racing truncation (which could reset page->mapping
> > to NULL at any moment) means we have to be a bit more careful.  Usually
> > we guard against that with page lock, but here we can rely on mapcount.
> > 
> > page_mapping(page), with its built-in PageSwapCache check, actually ends
> > up making the condition look less ugly; and so far as I could tell,
> > the extra code does get optimized out on x86 (unless CONFIG_DEBUG_VM,
> > when we are left with its VM_BUG_ON(PageSlab(page))).
> > 
> > But please look this over very critically and test (and if you like it,
> > please adopt it as your own): I'm not entirely convinced yet myself.
>   OK, I'll push the kernel with your updated patch to our build machines
> and let it run there for a few days (it took about a day to reproduce the
> issue originally). Thanks a lot for helping me with this.

And thank you for explaining it repeatedly for me.

I expect you're most interested in testing the XFS end of it; but if
you've time to check the swap/tmpfs aspect too, fsx on tmpfs while
heavily swapping should do it.

But perhaps these machines aren't much into heavy swapping.  Now, 
if Martin would send me a nice little zSeries netbook for Xmas,
I could then test that end of it myself ;)

I've just arrived at the conclusion that page migration does _not_
have a problem with transferring the dirty storage key: I had been
thinking that your testing might stumble on that issue, and need a
further patch, but I'll explain in other mail why now I think not.

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
