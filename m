Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:39428 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934115AbdKBVnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 17:43:24 -0400
Date: Fri, 3 Nov 2017 08:43:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/18] xfs: remove support for inlining data/extents into
 the inode fork
Message-ID: <20171102214321.GW5858@dastard>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-16-hch@lst.de>
 <20171031223508.GY4911@magnolia>
 <20171102185725.GE4244@lst.de>
 <20171102192634.GZ4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102192634.GZ4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 12:26:34PM -0700, Darrick J. Wong wrote:
> On Thu, Nov 02, 2017 at 07:57:25PM +0100, Christoph Hellwig wrote:
> > On Tue, Oct 31, 2017 at 03:35:08PM -0700, Darrick J. Wong wrote:
> > > Do you see any secondary effects, such as increased slab fragmentation
> > > because of the extra kmem_allocs?  In general I think this should be ok,
> > > I just worry slightly that whatever reason we had for having
> > > if_inline_data is still around and will blow up in weird ways if we get
> > > rid of it.
> > 
> > Why would we get much slab fragmentation?  The small slabs (16 or 32
> > byte for those current users) have a huge turnover, so they generally
> > aren't a majr problem.
> 
> I don't think they will be a serious problem either; this is just me
> wondering why we had if_inline_data in the first place (now that we're
> removing it).

Think back to ~1993 when XFS was first being implemented. State of
the art was 100-150MHz CPUs, and so the cost of an allocation for
every inode with a single data extent used a substantial fraction of
the available CPU. And given that most files are a single extent,
this was a worthwhile optimisation to minimise CPU overhead of the
initial data read on a file.

Nowdays, memory allocation costs less in terms of instructions than
it did on Irix in 1993, and the CPUs are also a couple of orders of
magnitudes faster. IOWs, the optimisation won't make as much
difference to performance now as it did 20 years ago...

It's the same reason we have the data fork in the inode, but the
attr fork is dynamically allocated - every inode has it's data fork
referenced, but attr fork references are comparitively rare and
generally not performance sensitive and so allocating the attr fork
was a good trade-off between CPU overhead for those that needed
attrs vs lower memory usage for the larger majority of users...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
