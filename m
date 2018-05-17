Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:32484 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751163AbeEQAlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 20:41:22 -0400
Date: Thu, 17 May 2018 10:41:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/22] xfs: add helpers to collect and sift btree block
 pointers during repair
Message-ID: <20180517004119.GZ23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
 <20180516075652.GR23861@dastard>
 <20180516180125.GI23858@magnolia>
 <20180516213237.GW23861@dastard>
 <20180516220537.GN23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516220537.GN23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 03:05:37PM -0700, Darrick J. Wong wrote:
> On Thu, May 17, 2018 at 07:32:37AM +1000, Dave Chinner wrote:
> > On Wed, May 16, 2018 at 11:01:27AM -0700, Darrick J. Wong wrote:
> > > So far I haven't noticed /much/ heat from this routine even with
> > > deliberately aged filesystems, but that's probably due to the slab
> > > allocator eating way more time. :(
> > 
> > Perhaps it is worth looking at using named slab caches for some of
> > these objects to take some heat off of the heap slabs?
> 
> Early versions of repair actually did that to try to avoid fragmenting
> the power-of-2 slabs by using named slab caches, but slub emits udev
> events whenever a named slab is created, and the resulting horrible

Really? That's so gross!

Anyway, WTF are udev events on internal kernel slab cache creation
needed for?

> cacophony of udev rule processing ate an entire CPU core and uncovered
> deadlocks in the parts of the slab management code that manage
> /sys/kernel/slab.  That code /really/ does not like you creating and
> removing slabs concurrently.

I wasn't suggesting dynamically creating slab caches during a repair
operation, just have one for the structure type created when we
first initialise the XFS kernel module like we do for xfs_buf,
xfs_inode, etc. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
