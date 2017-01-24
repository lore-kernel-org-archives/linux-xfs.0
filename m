Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdAXNuq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 08:50:46 -0500
Date: Tue, 24 Jan 2017 08:50:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct I/O
 COW writes
Message-ID: <20170124135044.GA60234@bfoster.bfoster>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
 <1480971924-4864-3-git-send-email-hch@lst.de>
 <20161207190008.GC23106@bfoster.bfoster>
 <20161207193709.GA27479@lst.de>
 <20161207194634.GE23106@bfoster.bfoster>
 <20170124083732.GA17818@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124083732.GA17818@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 09:37:32AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 07, 2016 at 02:46:34PM -0500, Brian Foster wrote:
> > Only for end_fsb... xfs_bmap_btalloc() calls xfs_bmap_extsize_align()
> > with the alignment, which rounds out the start and end offsets.
> 
> ... and corrupts data in the direct I/O case.
> 
> The problem is that the down-alignment in xfs_bmap_extsize_align will
> now create a real extent that spans before the extent that we have
> to COW in this write_begin call.  But the area before might have been
> a hole before the dio write that had just before been filled with
> an allocation in the data fork.  And due to the direct I/O end_io
> interface that only covers the range of the whole write we don't
> know at that point where exactly the COW operation started and will
> happily splice back our front pad into the data fork, replacing
> the just written data with garbage.  xfs/228 and sometimes generic/199
> reproduce this nicely.

Is this reproducible on the current tree or only with this patch series?

Also, shouldn't the end_io handler only remap the range of the write,
regardless of whether the initial allocation ended up preallocating over
holes or purely a shared range?

Perhaps what you are saying here is that we have a single dio write that
spans wider than a shared data fork extent..? In that case, we iterate
the range in xfs_reflink_reserve_cow(). We'd skip the start of the range
that is a hole in the data fork, but as you say, the
xfs_bmapi_reserve_delalloc() call for the part of the I/O on the shared
extent can widen the COW fork allocation to before the extent in the
data fork, possibly to before the start of the I/O. (Thus we end up
allocating COW blocks over the hole anyways...).

>From there we are going to drop into iomap_dio_rw(), which looks like
it's going to check the COW fork for blocks and if found, write to those
blocks (as opposed to doing a data fork allocation). AFAICT, that means
the extent size hint shouldn't be a problem. What am I missing?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
