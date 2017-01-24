Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54812 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdAXN7j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 08:59:39 -0500
Date: Tue, 24 Jan 2017 14:59:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170124135937.GA25885@lst.de>
References: <1480971924-4864-1-git-send-email-hch@lst.de> <1480971924-4864-3-git-send-email-hch@lst.de> <20161207190008.GC23106@bfoster.bfoster> <20161207193709.GA27479@lst.de> <20161207194634.GE23106@bfoster.bfoster> <20170124083732.GA17818@lst.de> <20170124135044.GA60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124135044.GA60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 08:50:45AM -0500, Brian Foster wrote:
> Is this reproducible on the current tree or only with this patch series?

It's only reproducible with the series modified to your review comments.

> Also, shouldn't the end_io handler only remap the range of the write,
> regardless of whether the initial allocation ended up preallocating over
> holes or purely a shared range?

The end_io handler is caller for the whole size of the write.  That's
mostly because we don't have an object corresponding to a write_begin
call.

> Perhaps what you are saying here is that we have a single dio write that
> spans wider than a shared data fork extent..?

Yes.

> In that case, we iterate
> the range in xfs_reflink_reserve_cow(). We'd skip the start of the range
> that is a hole in the data fork, but as you say, the
> xfs_bmapi_reserve_delalloc() call for the part of the I/O on the shared
> extent can widen the COW fork allocation to before the extent in the
> data fork, possibly to before the start of the I/O. (Thus we end up
> allocating COW blocks over the hole anyways...).

The problem is the following.

We have a file with the following layout


HHHHHHHHHHHHDDDDDDDDDDDDDD

where H is hole and D is data.  The H to D boundary is not aligned
to the cowextsize.

The direct I/O code now does a first pass allocating an extent for
H and copies data to it.  Then in the next step it goes on to D
and unshares it.  It then enlarges the extent into the end of the
previously H range. It does however not copy data into H again,
as the iomap iterator is past it.  The ->end_io routine however
is called for the hole range, and will move the just allocated
rounding before H back into the data fork, replacing the valid data
writtent just before.

