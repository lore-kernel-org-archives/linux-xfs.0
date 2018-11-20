Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbeKUC6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 21:58:32 -0500
Date: Tue, 20 Nov 2018 08:28:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] xfs: don't ENOSPC on writeback when punching holes
Message-ID: <20181120162833.GA2470@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-7-david@fromorbit.com>
 <20181120082040.GF30481@infradead.org>
 <20181120095042.GO19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120095042.GO19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:50:42PM +1100, Dave Chinner wrote:
> > > because the writeback error of ENOSPC was being reported. We're
> > > going to free that space, so we don't care if there was a ENOSPC
> > > writeback error. So ignore ENOSPC errors and punch anyway.
> > 
> > How do even get -ENOSPC back from writeback?  It seems like we have
> > a much worse root cause lingering here.
> 
> It hammered ENOSPC pretty hard - I think it had consumed the entire
> reserve pool and that can causes allocation transaction reservations
> in xfs_iomap_write_allocate() to return ENOSPC even if we've got a
> reservation for the data extents being allocated.

Well, that means we do have a problem somewhere in our accounting,
as writeback should not run into ENOSPC.

> This doesn't happen very often in the real world, but if it does we
> need operations like punch to work to be able to free space and
> get us out of that hole...

I'm ok(-ish) with the patch, but I wish we could also sort out the
root cause..
