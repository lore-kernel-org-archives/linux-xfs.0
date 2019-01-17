Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfAQQlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:41:49 -0500
Date: Thu, 17 Jan 2019 08:41:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] xfs: validate writeback mapping using data fork seq
 counter
Message-ID: <20190117164148.GA15959@infradead.org>
References: <20190111123032.31538-1-bfoster@redhat.com>
 <20190111123032.31538-4-bfoster@redhat.com>
 <20190113214905.GB4205@dastard>
 <20190114153422.GA3148@bfoster>
 <20190117144728.GA28225@infradead.org>
 <20190117163516.GD37591@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117163516.GD37591@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 11:35:17AM -0500, Brian Foster wrote:
> Hmm, it would be nice if these fixes were separate from the whole
> always_cow thing. Some initial thoughts on a quick look through the
> first few patches on the v3 post:

We can always skip the last patch.  It just helps to really nicely
show a lot of the problems that are otherwise hard to reproduce, but
already exist.

FYI, I just resent it like a minute before reading your mail.

> 1. It's probably best to drop your xfs_trim_extent_eof() changes as I
> have a stable patch to add a couple more calls and then I subsequently
> remove the whole thing going forward. Refactoring it is just churn at
> this point.

Sure.

> 2. The whole explicit race with truncate detection looks rather involved
> to me at first glance. I'm trying to avoid relying on i_size at all for
> this because it doesn't seem like a reliable approach. E.g., Dave
> described a hole punch vector for the same fundamental problem this
> series is trying to address:
> 
>   https://marc.info/?l=linux-xfs&m=154692641021480&w=2
> 
> I don't think looking at i_size really helps us with that, but I could
> be missing other changes in the cow series.

The i_size detection isn't new in this series, just slightly moved
around.  And it really is just intended as an optimization to not
even bother if we are beyond i_size.

> 
> In general I'm looking at putting something like this in
> xfs_iomap_write_allocate() once the data fork sequence number tracking
> is enabled:
> 
>                         /*
>                          * Now that we have ILOCK we must account for the fact
>                          * that the fork (and thus our mapping) could have
>                          * changed while the inode was unlocked. If the fork
>                          * has changed, trim the caller's mapping to the
>                          * current extent in the fork.

We don't even look at the callers mapping except for the range to
cover.  And that is how e.g. direct I/O also works and a good thing
as far as I can tell.  To make use of the previous mapping we'd have
to rewrite xfs_bmapi_write.

If we want to be able to reuse existing mapings I think the sequences
are helping us a bit, but a lot more work is needed, and it should
be done in a generic way and not just in this path.
