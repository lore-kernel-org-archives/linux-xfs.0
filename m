Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdAXQRV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 11:17:21 -0500
Date: Tue, 24 Jan 2017 11:17:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20170124161719.GE60234@bfoster.bfoster>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
 <1480971924-4864-3-git-send-email-hch@lst.de>
 <20161207190008.GC23106@bfoster.bfoster>
 <20161207193709.GA27479@lst.de>
 <20161207194634.GE23106@bfoster.bfoster>
 <20170124083732.GA17818@lst.de>
 <20170124135044.GA60234@bfoster.bfoster>
 <20170124135937.GA25885@lst.de>
 <20170124150222.GD60234@bfoster.bfoster>
 <20170124150959.GA27705@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124150959.GA27705@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 04:09:59PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 10:02:22AM -0500, Brian Foster wrote:
> > Ok, well then I'm probably not going to be able to follow the details
> > well enough to try and provide constructive feedback without seeing the
> > code. Looking back, my comments were generally about the tradeoff of
> > bypassing the extent size hint mechanism that has been built into
> > reflink to avoid cow fragmention.
> 
> Ok - really very little change here - only the call to the extsize
> alignment in xfs_bmap_btalloc reinstated and the according reservation
> changes in the caller.
> 
> Note that with the previously posted series there is no change in
> handling the cowextsize hint for real on-disk allocations.  While
> the current code rounds down based on the cowextsize for creating
> the delayed extent we will never convert the alignment before the
> write start to a real extent - it will just get cleaned up later
> at inode eviction time or using the timer.
> 

I thought that while not necessarily guaranteed, generally the entire
extent gets converted from delalloc to real blocks. IIRC, that's what
I've seen in the past when looking into the cow fork with bmap. After
all, isn't that the point of the extent size hint? Allocate wider than
the write to accommodate potential subsequent writes into a more
contiguous range.

> > Without seeing the code, perhaps we need to pull up the cow extent size
> > hint mechanism from the bmapi layer to something similar to how
> > xfs_iomap_direct_write() handles the traditional extent size hints..?
> > That may allow us to more intelligently consider the current state
> > across the data and cow forks in such cases (to not preallocate over
> > existing blocks, for example, without having to kill off the extent size
> > hint entirely).
> 
> We could.  On the other hand I'd love to get the current series in
> first as the only thing it change in behavior is not allocating
> additional delayed extent space that never gets used, and not writing
> data twice if it's sub-blocksize, all of which seem like a clear
> improvement.  And it's also the base for my pending DAX reflink support.

Fair enough, that's a different discussion. Personally, I'd prefer to
fix up the stuff we know that needs fixing before piling more stuff on
top. Particularly since something like cow I/O to a reflinked vm image
file (taking full advantage of cowextszhint) might be a more common use
case than DAX reflink at the moment.

All of this stuff is "experimental," however, so I don't feel strongly
about the order so long as we agree the regression can/should be fixed
up. So I'll defer to the maintainer on that one. ;)

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
