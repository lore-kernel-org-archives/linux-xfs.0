Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51614 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeJZUdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 16:33:12 -0400
Date: Fri, 26 Oct 2018 04:56:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20181026115623.GA8116@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-5-david@fromorbit.com>
 <20181026102424.GC29302@infradead.org>
 <20181026105842.GG19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026105842.GG19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 09:58:42PM +1100, Dave Chinner wrote:
> > The only case where we have a fbp here is if we had a fblk passed in,
> > but it it did have the index set to -1.  But as far as I can tell
> > searching that again doesn't make any sense at all, so I'd apply
> > something like this in top of your patch (some of this also seems
> > to be in your next patch, so independent of the logic change might
> > be worth moving over here):
> 
> So you've done a bunch of the rework that already in the next patch
> in the series, plus a "fbno = fblk->blkno + 1;" logic change. 

I don't think this is a new logic change, as we start at fbno
already (both in the existing code and with your patch), but we got
here because that block did not contain a suitable free space.

That being said with the reverse search in the next patch the + 1
is pointless as that code changes again.  But many of the other changes
in this patch or your next patch (which I hadn't looked at yet when
I did this) should probably be in this one, otherwise we just create
churn.
