Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfBAMqo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 07:46:44 -0500
Date: Fri, 1 Feb 2019 07:46:42 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/11] xfs: don't try to map blocks beyond i_size in
 writeback
Message-ID: <20190201124641.GA40798@bfoster>
References: <20190131075524.4769-1-hch@lst.de>
 <20190131075524.4769-5-hch@lst.de>
 <20190131181108.GF36239@bfoster>
 <20190201072520.GB14711@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201072520.GB14711@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 08:25:20AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 31, 2019 at 01:11:09PM -0500, Brian Foster wrote:
> > The code looks fine, but I don't see any more value in this code than
> > the similar code down in xfs_iomap_write_allocate(). The comment implies
> > this skips writeback for the rest of the file, but AFACT the higher
> > level page->index code in xfs_do_writepage() already does that. All
> > these checks do is skip the remaining blocks in the current page. When
> > you consider that we're most likely sending an I/O in the latter case
> > either way, I'm curious why we'd bother to keep this around at all.
> 
> It just seems a little pointless to take locks and do a lookup in the
> extent tree.  But I can try dropping it and re-run tests without it.

I agree that is pointless, but what's the point of saving lock cycles
and an in-core extent lookup when we've already committed to sending an
I/O? AFAICT we may also still have to cycle through however many pages
are still referenced by the current pagevec. The racing truncate is
going to wait on the higher level page lock and page writeback state
before it ever gets to the point of contending on ilock.

More broadly, this is a codepath that is historically brittle with
regard to uncommon branches in the code, whether that be incorrect error
handling (page discard), the similar truncate detection code in
xfs_iomap_write_allocate() that clearly had broken -EAGAIN handling code
for who knows how long, etc. IMO, this all stems from lack of good test
coverage in the area of writeback failure.

Unless I'm missing something where this code is required for correctness
or somehow provides a measureable performance benefit, I think we're
better off keeping this path as simple as possible. It should be fairly
easy to provide test coverage for the page granularity truncate handling
code (generic/524 may already cover this). I'm not so sure about that
for the block granularity handling without having some kind of
additional instrumentation.

Brian
