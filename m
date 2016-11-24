Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:25416 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751095AbcKXToY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2016 14:44:24 -0500
Date: Fri, 25 Nov 2016 06:44:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
Message-ID: <20161124194419.GR28177@dastard>
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
 <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Hall <kdhall@binghamton.edu>, linux-xfs@vger.kernel.org

On Thu, Nov 24, 2016 at 10:43:32AM +0100, Carlos Maiolino wrote:
> Hi,
> 
> On Wed, Nov 23, 2016 at 08:23:42PM -0500, Dave Hall wrote:
> > Hello,
> > 
> > I'm planning a storage installation on new hardware and I'd like to
> > configure for best performance.  I will have 24 to 48 drives in a
> > SAS-attached RAID box with dual 12GB/s controllers (Dell MD3420 with 10K
> > 1.8TB drives.  The server is dual socket with 28 cores, 256GB RAM, dual 12GB
> > HBAs, and multiple 10GB NICS.
> > 
> > My workload is NFS for user home directories - highly random access patterns
> > with frequent bursts of random writes.
> > 
> > In order to maximize performance I'm planning to make multiple small RAID
> > volumes (i.e. RAID5 - 4+1, or RAID6 - 8+2) that would be either striped or
> > concatenated together.
> > 
> > I'm looking for information on:
> > 
> > - Are there any cautions or recommendations about  XFS stability/performance
> > on a thin volume with thin snapshots?
> > 
> > - I've read that there are tricks and calculations for aligning XFS to the
> > RAID stripes.  Can use suggest any guidelines or tools for calculating the
> > right configuration?
> 
> There is no magical trick :), you need to configure Stripe unit and stripe width
> according to your raid configuration. You should set stripe unit (su option) to
> the size of the stripes on your raid, and set the stripe width (sw option)
> according to the number of data disks on your array (if you have a 4+1 raid 5,
> it should be 4, into a 8+2 raid 6, it should be 8).

mkfs.xfs will do this setup automatically on software raid and any
block device that exports the necessary information to set it up.
In general, it's only older/cheaper hardware RAID that you have to
worry about this anymore.

> > - I've read also about tuning the number of allocation groups to reflect the
> > CPU configuration of the server.  Any suggestions on this?
> > 
> 
> Allocation groups can't be bigger than 1TB. Assuming it should reflect your cpu
> configuration is wrong, having too few or too many allocation groups can kill
> your performance, and you also might face some another allocation problems in
> the future, when the filesystem get aged when runnning with very small
> allocation groups.

It also depends on your storage, mostly. SSDs can handle
agcount=NCPUS*2 easily, but for spinning storage this will cause
additional seek loading and slow things down. In this case, the
defaults are best.

> Determining the size of the allocation groups, is a case-by-case approach, and
> it might need some experimenting.
> 
> Since you are dealing with thin provisioning devices, I'd be more careful then.
> If you start with a small filesystem, and use the default configuration for
> mkfs, it will give you a number of AGs according to your current block device
> size, which can be a problem in the future when you decide to extend the
> filesystem, AG size can't be changed after you make the filesystem. Make a
> search on xfs list and you will see some reports of performance problems that
> ended up being caused by very small filesystems that were extended later,
> causing it to have lots of AGs.

Yup, rule of thumb is that growing the fs size by an order of
magnitude is fine, growing it by two orders of magnitude will cause
problems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
