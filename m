Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbdAXPCX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 10:02:23 -0500
Date: Tue, 24 Jan 2017 10:02:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20170124150222.GD60234@bfoster.bfoster>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
 <1480971924-4864-3-git-send-email-hch@lst.de>
 <20161207190008.GC23106@bfoster.bfoster>
 <20161207193709.GA27479@lst.de>
 <20161207194634.GE23106@bfoster.bfoster>
 <20170124083732.GA17818@lst.de>
 <20170124135044.GA60234@bfoster.bfoster>
 <20170124135937.GA25885@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124135937.GA25885@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 02:59:37PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 08:50:45AM -0500, Brian Foster wrote:
> > Is this reproducible on the current tree or only with this patch series?
> 
> It's only reproducible with the series modified to your review comments.
> 

Ok, well then I'm probably not going to be able to follow the details
well enough to try and provide constructive feedback without seeing the
code. Looking back, my comments were generally about the tradeoff of
bypassing the extent size hint mechanism that has been built into
reflink to avoid cow fragmention.

> > Also, shouldn't the end_io handler only remap the range of the write,
> > regardless of whether the initial allocation ended up preallocating over
> > holes or purely a shared range?
> 
> The end_io handler is caller for the whole size of the write.  That's
> mostly because we don't have an object corresponding to a write_begin
> call.
> 
> > Perhaps what you are saying here is that we have a single dio write that
> > spans wider than a shared data fork extent..?
> 
> Yes.
> 
> > In that case, we iterate
> > the range in xfs_reflink_reserve_cow(). We'd skip the start of the range
> > that is a hole in the data fork, but as you say, the
> > xfs_bmapi_reserve_delalloc() call for the part of the I/O on the shared
> > extent can widen the COW fork allocation to before the extent in the
> > data fork, possibly to before the start of the I/O. (Thus we end up
> > allocating COW blocks over the hole anyways...).
> 
> The problem is the following.
> 
> We have a file with the following layout
> 
> 
> HHHHHHHHHHHHDDDDDDDDDDDDDD
> 
> where H is hole and D is data.  The H to D boundary is not aligned
> to the cowextsize.
> 
> The direct I/O code now does a first pass allocating an extent for
> H and copies data to it.  Then in the next step it goes on to D
> and unshares it.  It then enlarges the extent into the end of the
> previously H range. It does however not copy data into H again,
> as the iomap iterator is past it.  The ->end_io routine however
> is called for the hole range, and will move the just allocated
> rounding before H back into the data fork, replacing the valid data
> writtent just before.
> 

Without seeing the code, perhaps we need to pull up the cow extent size
hint mechanism from the bmapi layer to something similar to how
xfs_iomap_direct_write() handles the traditional extent size hints..?
That may allow us to more intelligently consider the current state
across the data and cow forks in such cases (to not preallocate over
existing blocks, for example, without having to kill off the extent size
hint entirely).

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
