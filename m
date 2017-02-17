Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42465 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933235AbdBQMnA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 07:43:00 -0500
Date: Fri, 17 Feb 2017 13:42:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: tune down agno asserts in the bmap code
Message-ID: <20170217124257.GC23739@lst.de>
References: <20170216211035.4206-1-hch@lst.de> <20170217011117.GK6813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217011117.GK6813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 16, 2017 at 05:11:17PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 16, 2017 at 10:10:35PM +0100, Christoph Hellwig wrote:
> > In various places we currently assert that xfs_bmap_btalloc allocates
> > from the same as the firstblock value passed in, unless it's either
> > NULLAGNO or the dop_low flag is set.  But the reflink code does not
> > fully follow this convention as it passes in firstblock purely as
> > a hint for the allocator without actually having previous allocations
> 
> Are you referring to BMAPI_REMAP?

Yes.

> In that case *firstblock isn't a
> hint, it's the new physical location of the extent.

Yes and no.  For the high-level bmap code it is indeed the location of the
extent, but it then also gets passed down to the btree code, where is
is treated as both a hint for allocating the bmap btree blocks close
to it, which limits the allocation to the same AG.  We work around that
a bit using the try_another_ag loop, but it's all a bit of a mess.

> By the way, was it your intent to push this series into 4.11?

It's just a single patch, and given that it's fairly easy to trigger
we should defintively have it in 4.11 and later -stable.
