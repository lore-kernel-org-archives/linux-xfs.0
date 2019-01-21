Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfAURnH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 12:43:07 -0500
Date: Mon, 21 Jan 2019 12:43:05 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190121174304.GC14281@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190120124502.GA65044@bfoster>
 <20190121155110.GB31678@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121155110.GB31678@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 07:51:10AM -0800, Christoph Hellwig wrote:
> On Sun, Jan 20, 2019 at 07:45:02AM -0500, Brian Foster wrote:
> > 4. Kind of a nit, but the comment update in xfs_bmapi_write() that
> > describes the ilock and associated race window and whatnot should really
> > be split between there and xfs_iomap_write_allocate(). The former should
> > just explain what exactly XFS_BMAPI_DELALLOC does (i.e., skip holes,
> > real extents, over a range..). The latter should explain how
> > the use of XFS_BMAPI_DELALLOC helps us deal with the race window in the
> > writeback code.
> 
> Ok.
> 
> > One option that comes to mind is to perhaps split off XFS_BMAPI_DELALLOC
> > from xfs_bmapi_write() into a new xfs_bmapi_delalloc() function that
> > facilitates new semantics (I'm not terribly comfortable with overloading
> > the semantics of xfs_bmapi_write()). Instead of passing a range to
> > xfs_bmapi_delalloc(), just pass the offset we care about and expect that
> > this function will attempt to allocate the entire extent currently
> > backing offset. (Alternatively, we could perhaps pass a range by value
> > and allow xfs_bmapi_delalloc() to update the range in the event of
> > delalloc discontiguity.) Either way, the extent returned may not cover
> > the offset (due to fragmentation, as today) and thus the caller needs to
> > iterate until that happens. The larger point is that we'd lookup the
> > current extent _at offset_ on each iteration and thus shouldn't ever
> > contend with new delalloc reservations. Thoughts?
> 
> I considered splitting it off and even had an early prototype.  I
> got something wrong and it didn't work, and it created a little too
> much duplication for my taste so I gave up on it for now.  But
> fundamentally having the delalloc conversion separate from
> xfs_bmapi_write is the right thing.  I'll just have to find some
> time for it or pass this work off to you..

Ok, well I don't mind looking into how to refactor that code, but my
priority for this series is to fix the underlying problem. As a
temporary compromise, I think there might be a couple simple options to
create an xfs_bmapi_delalloc() wrapper over xfs_bmapi_write(). I'm
curious whether we could just pass bno and len == 1 from the delalloc
wrapper and get the behavior we want. Alternatively, perhaps we could
just factor out the bma.got lookup from xfs_bmapi_write() and use that
to handle the range properly in the delalloc case (i.e., pass *got and
*eof into a __xfs_bmapi_write() internal function that does most of
everything else).

If either of those don't work, a temporary fallback may be to just bury
the seqno lookup logic from this patch into xfs_bmapi_delalloc() and
document that further refactoring is required. That would retain the
extra lookup (for now), but TBH the testing I've already down wrt to
excessive higher level revalidations kind of shows that this has no real
impact on writeback performance, it's just a bit ugly.

Brian
