Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728950AbfAUPvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 10:51:11 -0500
Date: Mon, 21 Jan 2019 07:51:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190121155110.GB31678@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190120124502.GA65044@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190120124502.GA65044@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sun, Jan 20, 2019 at 07:45:02AM -0500, Brian Foster wrote:
> 4. Kind of a nit, but the comment update in xfs_bmapi_write() that
> describes the ilock and associated race window and whatnot should really
> be split between there and xfs_iomap_write_allocate(). The former should
> just explain what exactly XFS_BMAPI_DELALLOC does (i.e., skip holes,
> real extents, over a range..). The latter should explain how
> the use of XFS_BMAPI_DELALLOC helps us deal with the race window in the
> writeback code.

Ok.

> One option that comes to mind is to perhaps split off XFS_BMAPI_DELALLOC
> from xfs_bmapi_write() into a new xfs_bmapi_delalloc() function that
> facilitates new semantics (I'm not terribly comfortable with overloading
> the semantics of xfs_bmapi_write()). Instead of passing a range to
> xfs_bmapi_delalloc(), just pass the offset we care about and expect that
> this function will attempt to allocate the entire extent currently
> backing offset. (Alternatively, we could perhaps pass a range by value
> and allow xfs_bmapi_delalloc() to update the range in the event of
> delalloc discontiguity.) Either way, the extent returned may not cover
> the offset (due to fragmentation, as today) and thus the caller needs to
> iterate until that happens. The larger point is that we'd lookup the
> current extent _at offset_ on each iteration and thus shouldn't ever
> contend with new delalloc reservations. Thoughts?

I considered splitting it off and even had an early prototype.  I
got something wrong and it didn't work, and it created a little too
much duplication for my taste so I gave up on it for now.  But
fundamentally having the delalloc conversion separate from
xfs_bmapi_write is the right thing.  I'll just have to find some
time for it or pass this work off to you..
