Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933206AbeGJBCG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jul 2018 21:02:06 -0400
Date: Mon, 9 Jul 2018 21:02:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 21/22] xfs: add support for sub-pagesize writeback
 without buffer_heads
Message-ID: <20180710010202.GA5835@killians.ges.redhat.com>
References: <20180702145813.22496-1-hch@lst.de>
 <20180702145813.22496-22-hch@lst.de>
 <20180703123603.GB22789@bfoster>
 <20180703220501.GX32415@magnolia>
 <20180708151615.GC14418@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180708151615.GC14418@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Jul 08, 2018 at 05:16:15PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 03, 2018 at 03:05:01PM -0700, Darrick J. Wong wrote:
> > > So the buffer completion code clears the uptodate status of the buffer
> > > on error. I assume that means the next read would replace the data we
> > > failed to write with whatever was previously on disk.
> > 
> > I've always found it a little weird that we basically throw away the
> > newer page contents on error, but we shouldn't be changing the behavior
> > in quite so subtle a way.
> > 
> > Also, since we clear uptodate the next (buffered) write will reread the
> > page contents.
> > 
> > > I guess it's debatable whether that is the right thing to do in
> > > general, but that seems like a higher level issue nonetheless (i.e., I
> > > don't think we'd ever retry the writepage either?).
> > 
> > AFAIK we don't retry failed writes unless userspace dirties the page.
> > 
> > > So is there any reason not to do the analogous in the iomap completion
> > > code?
> > 
> > Will let Christoph answer that one.
> 
> As far as I can tell the write path should never even touch the
> uptodate bit, and the buffer head path is only doing so for very
> old legacy reasons.  I'd rather keep the iomap write path out of
> the update bit manipulation business from the very beginning instead
> of carry junk like this over.

I'm more interested in preserving the expected behavior in the event of
a write error as opposed to just copying whatever state the buffer head
code sets. It looks to me that if the page itself isn't uptodate, we
overwrite a block of that page and then the writepage fails, clearing
the buffer uptodate status means that the next read would return what is
on disk (not what was just written to the page). I'm not sure that's
what happens if the page was already uptodate before the
overwrite/writepage, however, I didn't notice anything that cleared page
uptodate status on a writepage I/O error..?

Brian
