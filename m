Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14996 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbeLFVeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Dec 2018 16:34:04 -0500
Date: Fri, 7 Dec 2018 08:33:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181206213351.GZ6311@dastard>
References: <20181205225147.12626-1-hch@lst.de>
 <20181206181139.GP24487@magnolia>
 <20181206201105.GB31797@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206201105.GB31797@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Thu, Dec 06, 2018 at 09:11:06PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 06, 2018 at 10:11:39AM -0800, Darrick J. Wong wrote:
> > I think this has the same problem that Dave complained about back in
> > October -- if I have a hard disk with 512b sectors, a xfs with 4k
> > blocks, and mount it on a machine with 64k pages, then single-sector
> > buffers will get a small slab allocation, but single-fsb buffers will
> > now fall back to grabbing a 64k page to hold 4k worth of data.
> > 
> > Even if we add a second slab for single-fsb blocks, we'll run into the
> > same problem if the filesystem contains multi-block directory blocks, so
> > then we'd potentially need a third slab, and... is there a way to ask a
> > slab allocator for multiple contiguous objects totalling less than
> > PAGE_SIZE bytes?
> 
> No, unfortunately there is not.  And the sad part is that generally it
> will give you aligned ones, just with slub debugging turned on it won't.

Can we just turn on object sized alignment for the heap slabs, which
are power of 2 sized anyway?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
