Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:63247 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752268AbcLRXza (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 18:55:30 -0500
Date: Mon, 19 Dec 2016 10:55:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in
 xfs_alloc_space_available
Message-ID: <20161218235527.GM4326@dastard>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-4-git-send-email-hch@lst.de>
 <20161216002851.GW4219@dastard>
 <20161216082544.GD32288@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216082544.GD32288@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Fri, Dec 16, 2016 at 09:25:44AM +0100, Christoph Hellwig wrote:
> On Fri, Dec 16, 2016 at 11:28:51AM +1100, Dave Chinner wrote:
> > > +	/*
> > > +	 * Clamp maxlen to the amount of free space available for the actual
> > > +	 * extent allocation.
> > > +	 */
> > > +	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> > > +		args->maxlen = available;
> > > +		ASSERT(args->maxlen > 0);
> > > +	}
> > 
> > I'd love to get rid of all these (int) casts, too...
> 
> The problem here is that we compare 32-bit signed to 32-bit unsigned
> variables.  And given that this is ripe for nasty bugs due to the C
> type promotion rules I'd rather be extra careful.

Yes, I know - it's bitten me several times in the past. The
underlying problem (IMO) is using xfs_extlen_t for things that
aren't physical BMBT extent lengths, which are bound to:

#define MAXEXTLEN       ((xfs_extlen_t)0x001fffff)      /* 21 bits */            

but it's grown to be used for everything that needs to store or
operate on the length of an extent.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
