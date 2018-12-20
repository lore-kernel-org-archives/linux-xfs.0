Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:10679 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbeLTVDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 16:03:13 -0500
Date: Fri, 21 Dec 2018 08:03:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/11] xfs: introduce an always_cow mode
Message-ID: <20181220210309.GE4205@dastard>
References: <20181203222503.30649-1-hch@lst.de>
 <20181203222503.30649-12-hch@lst.de>
 <20181218232437.GS27208@magnolia>
 <20181219224335.GB4205@dastard>
 <20181220070741.GA9803@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220070741.GA9803@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Dec 20, 2018 at 08:07:41AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 20, 2018 at 09:43:35AM +1100, Dave Chinner wrote:
> > On Tue, Dec 18, 2018 at 03:24:37PM -0800, Darrick J. Wong wrote:
> > > On Mon, Dec 03, 2018 at 05:25:03PM -0500, Christoph Hellwig wrote:
> > > Granted, I'm still rather fuzzy on what exactly is supposed to happen
> > > with preallocating fallocate when all writes require an allocation to
> > > succeed? 
> > 
> > For always_cow mode, perhaps we could consider preallocating into
> > the COW fork rather than the data fork? That way when we go to write
> > the data, we've already got the space allocated regardless of
> > whether it is over a hole or existing data?
> 
> For a speculative preallocation that is what we already do.  But for
> persistent preallocation that doesn't help as the COW fork is not
> persistent.

Yes, I know it's not persistent, but do we care for always_cow mode?
Preallocation to prevent enospc is done just before the data is
written, and if we put it in the COW fork then it will mostly just
work and behave as expected for preventing ENOSPC on subsequent
writes. Preallocation to control data layout is largely irrelevant
to always_cow mode, so it really makes no difference to us if the
preallocation disappears when the inode is cycled out of cache....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
