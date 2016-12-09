Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21375 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752430AbcLIVrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2016 16:47:01 -0500
Date: Sat, 10 Dec 2016 08:46:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
 selecting an AG
Message-ID: <20161209214651.GR4326@dastard>
References: <1481303709-12632-1-git-send-email-hch@lst.de>
 <20161209173213.GZ16813@birch.djwong.org>
 <20161209174145.GA15960@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209174145.GA15960@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, eguan@redhat.com

On Fri, Dec 09, 2016 at 06:41:45PM +0100, Christoph Hellwig wrote:
> On Fri, Dec 09, 2016 at 09:32:13AM -0800, Darrick J. Wong wrote:
> > > +	if (xfs_alloc_is_userdata(args->datatype))
> > > +		indlen = __xfs_bmap_worst_indlen(args->mp, max(args->minlen, args->maxlen));
> > 
> > /me wonders, when is it the case that minlen > maxlen?
> 
> Good question.  I just added that when I noticed minlen alone doesn't
> work as we might need the bigger calculation based on maxlen.  I'll
> do a quick audit and move to maxlen only.
> 
> > 
> > I'm also wondering why we can't just increase args->minleft to require
> > that we leave enough space in whichever AG we pick to expand to bmbt?
> > AFAICT that's the purpose of the minleft field.
> 
> Not sure what the original intentions was, but as-is it seems pretty
> b0rked.
> 
> E.g. xfs_bmap_btalloc, xfs_bmapi_allocate or xfs_alloc_vextentjust set
> minleft to 0 when when we are low on space which make it a bit pointless.

I'm pretty sure these cases were added as a mechanism to prevent
ENOSPC occurrences during delalloc conversion when, in the general
case, the allocation would have succeeded. i.e. "in most cases the
BMBT is not going to change shape, so let's just ignore the blocks
that might be needed for that and hope we don't need them".

> Also in the bmap code where we set minleft we don't really know how
> much we'll need as we'll only decide on the actual final allocation
> size deep down in the allocator.  I'll do a little archeology session
> now to figure out how we got the current minleft semantics, as they seem
> really weird.

I'd just set it according to maxlen. I don't really care if we can't
allocate the last few blocks in an AG for certain types of
allocation - the failure fallbacks should drop back to an allocation
attempt of maxlen = minlen and we can set minleft accordingly
for those. If it still fails, then we really have ENOSPC...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
