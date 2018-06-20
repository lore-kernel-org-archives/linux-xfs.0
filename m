Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754230AbeFTSNB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jun 2018 14:13:01 -0400
Date: Wed, 20 Jun 2018 14:12:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
Message-ID: <20180620181259.GD4493@bfoster>
References: <20180615130209.1970-1-hch@lst.de>
 <20180615130209.1970-24-hch@lst.de>
 <20180619165211.GD2806@bfoster>
 <20180620075655.GA2668@lst.de>
 <20180620143252.GE3241@bfoster>
 <20180620160803.GA4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620160803.GA4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 20, 2018 at 09:08:03AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 20, 2018 at 10:32:53AM -0400, Brian Foster wrote:
> > Sending again without the attachment... Christoph, let me know if it
> > didn't hit your mbox at least.
> > 
> > On Wed, Jun 20, 2018 at 09:56:55AM +0200, Christoph Hellwig wrote:
> > > On Tue, Jun 19, 2018 at 12:52:11PM -0400, Brian Foster wrote:
> > > > > +	/*
> > > > > +	 * Move the caller beyond our range so that it keeps making progress.
> > > > > +	 * For that we have to include any leading non-uptodate ranges, but
> > > > 
> > > > Do you mean "leading uptodate ranges" here? E.g., pos is pushed forward
> > > > past those ranges we don't have to read, so (pos - orig_pos) reflects
> > > > the initial uptodate range while plen reflects the length we have to
> > > > read..?
> > > 
> > > Yes.
> > > 
> > > > > +
> > > > > +	do {
> > > > 
> > > > Kind of a nit, but this catches my eye and manages to confuse me every
> > > > time I look at it. A comment along the lines of:
> > > > 
> > > >                 /*
> > > > 		 * Pass in the block aligned start/end so we get back block
> > > > 		 * aligned/adjusted poff/plen and can compare with unaligned
> > > > 		 * from/to below.
> > > >                  */
> > > > 
> > > > ... would be nice here, IMO.
> > > 
> > > Fine with me.
> > > 
> > > > > +		iomap_adjust_read_range(inode, iop, &block_start,
> > > > > +				block_end - block_start, &poff, &plen);
> > > > > +		if (plen == 0)
> > > > > +			break;
> > > > > +
> > > > > +		if ((from > poff && from < poff + plen) ||
> > > > > +		    (to > poff && to < poff + plen)) {
> > > > > +			status = iomap_read_page_sync(inode, block_start, page,
> > > > > +					poff, plen, from, to, iomap);
> > > > 
> > > > After taking another look at the buffer head path, it does look like we
> > > > have slightly different behavior here. IIUC, the former reads only the
> > > > !uptodate blocks that fall along the from/to boundaries. Here, if say
> > > > from = 1, to = PAGE_SIZE and the page is fully !uptodate, it looks like
> > > > we'd read the entire page worth of blocks (assuming contiguous 512b
> > > > blocks, for example). Intentional? Doesn't seem like a big deal, but
> > > > could be worth a followup fix.
> > > 
> > > It wasn't actuall intentional, but I actually think it is the right thing
> > > in then end, as it means we'll often do a single read instead of two
> > > separate ones.
> > 
> > Ok, but if that's the argument, then shouldn't we not be doing two
> > separate I/Os if the middle range of a write happens to be already
> > uptodate? Or more for that matter, if the page happens to be sparsely
> > uptodate for whatever reason..?
> > 
> > OTOH, I also do wonder a bit whether that may always be the right thing
> > if we consider cases like 64k page size arches and whatnot. It seems
> > like we could end up consuming more bandwidth for reads than we
> > typically have in the past. That said, unless there's a functional
> > reason to change this I think it's fine to optimize this path for these
> > kinds of corner cases in follow on patches.
> > 
> > Finally, this survived xfstests on a sub-page block size fs but I
> > managed to hit an fsx error:
> > 
> > Mapped Read: non-zero data past EOF (0x21a1f) page offset 0xc00 is
> > 0xc769
> > 
> > It repeats 100% of the time for me using the attached fsxops file (with
> > --replay-ops) on XFS w/ -bsize=1k. It doesn't occur without the final
> > patch to enable sub-page block iomap on XFS.
> 
> Funny, because I saw the exact same complaint from generic/127 last
> night on my development tree that doesn't include hch's patches and was
> going to see if I could figure out what's going on.
> 
> FWIW it's been happening sporadically for a few weeks now but every time
> I've tried to analyze it I (of course) couldn't get it to reproduce. :)
> 
> I also ran this series (all of it, including the subpagesize config)
> last night and aside from it stumbling over an unrelated locking problem
> seemed fine....
> 

That's interesting. Perhaps it's a pre-existing issue in that case and
the iomap stuff just changes the timing to make it reliably reproducible
on this particular system.

I only ran it a handful of times in both cases and now have lost access
to the server. Once I regain access, I'll try running for longer on
for-next to see if the same thing eventually triggers.

Brian

> --D
> 
> > Brian
> > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
