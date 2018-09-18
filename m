Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49242 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbeIRXvL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:51:11 -0400
Date: Tue, 18 Sep 2018 20:17:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: delalloc and reflink fixes & tweaks
Message-ID: <20180918181728.GA7171@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917212323.GF16550@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917212323.GF16550@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Sep 18, 2018 at 07:23:23AM +1000, Dave Chinner wrote:
> Do you have any numbers that demonstrate the performance impact of
> the preallocation change? We've always intended to fix this exposure
> issue as you've done, I'm just interested in the sort of impact it
> has (if any).

For the absolute worst case - completely random 4k writes to a sparse
file I see a slowdown of about 3%.  Which is less than the improvement
that we saw from removing buffer heads.

> Also, with this change to use unwritten extents for all delalloc
> extents, we can start doing speculative preallocation for writes
> into holes inside EOF without leaving uninitialised/unzeroed blocks
> laying around.

Careful.  We already have issues because delalloc blocks before EOF don't
ever get reclaimed.  This triggers up on xfs/442 with 1k blocksize for
me.  I actually have a fix for that now, but that will require dropping
one of the cleanup patches from this series, so expect a respin.

If we want to more generic preallocation I guess we should follow the
example of the COW direct I/O path and mark all preallocated extents
as unwritten - that way we know delalloc extents that have the unwritten
bit set can be safely reclaimed.  But that is more work than I want
to do for this merge window at least.

> Using spec.  prealloc for "extend-via-truncate,
> sequential write to fill hole" workloads would greatly benefit from
> that. Did you have any plans to look at that code?

Not anytime soon.
