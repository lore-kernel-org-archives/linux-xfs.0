Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:28027 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752772AbcK0V5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2016 16:57:13 -0500
Date: Mon, 28 Nov 2016 08:56:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
Message-ID: <20161127215654.GU28177@dastard>
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
 <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
 <ca974620-fff5-e26b-897d-c1c62d47cc64@binghamton.edu>
 <20161125111814.p7ltczag7akqk3w5@eorzea.usersys.redhat.com>
 <264e0ba1-f3ea-b320-1c22-c1e23e74ffa6@binghamton.edu>
 <14553049-ef53-5594-61a7-a91394b66d95@binghamton.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14553049-ef53-5594-61a7-a91394b66d95@binghamton.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Hall <kdhall@binghamton.edu>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On Fri, Nov 25, 2016 at 12:09:10PM -0500, Dave Hall wrote:
> With a concatenated LV most AGs would be mapped to a single PV, but
> XFS would still disperse disk activity across all AGs and thus
> across all PVs.

Like all things, this is only partially true.

For inode64 (the default) the allocation load is spread based on
directory structure. If all your work hits a single directory, then
it won't get spread across multiple devices. The log will land on a
single device, so it will always be limited by the throughput of
that device. And read/overwrite workloads will only hit single
devices, too.  So unless you have a largely concurrent, widely
distributed set of access patterns, XFS won't distribute the IO
load.

Now inode32, OTOH, distributes the data to different AGs at
allocation time, meaning that data in a single directory is spread
across multiple devices. However, all the metadata will be on the
first device and that guarantees a device loading imbalance will
occur.

> With a striped LV each AG would be striped across
> multiple PVs, which would change the distribution of disk activity
> across the PVs but still lead to all PVs being fairly active.

Striped devices can be thought of as the same as a single spindle -
the characteristics from the filesystem perspective are the same,
just with some added alignment constraints to optimise placement...

> With DM-Thin, things would change.  XFS would perceive that it's AGs
> were fully allocated, but in reality new chunks of storage would be
> allocated as needed.  If DM-Thin uses a linear allocation algorithm
> on a concatenated LV it would seem that certain kinds of disk
> activity would tend to be concentrated in a single PV at a time.  On
> the other hand, DM-Thin in a striped LV would tend to spread things
> around more evenly regardless of allocation patterns.

Yup, exactly the same as for a filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
