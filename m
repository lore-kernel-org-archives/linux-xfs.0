Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936254AbcKXJoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Nov 2016 04:44:08 -0500
Date: Thu, 24 Nov 2016 10:43:32 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS + LVM + DM-Thin + Multi-Volume External RAID
Message-ID: <20161124094332.o3hbaubrligsa7l3@eorzea.usersys.redhat.com>
References: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495de1c-3384-f1d6-be76-1ad02fdc8cb1@binghamton.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Hall <kdhall@binghamton.edu>
Cc: linux-xfs@vger.kernel.org

Hi,

On Wed, Nov 23, 2016 at 08:23:42PM -0500, Dave Hall wrote:
> Hello,
> 
> I'm planning a storage installation on new hardware and I'd like to
> configure for best performance.  I will have 24 to 48 drives in a
> SAS-attached RAID box with dual 12GB/s controllers (Dell MD3420 with 10K
> 1.8TB drives.  The server is dual socket with 28 cores, 256GB RAM, dual 12GB
> HBAs, and multiple 10GB NICS.
> 
> My workload is NFS for user home directories - highly random access patterns
> with frequent bursts of random writes.
> 
> In order to maximize performance I'm planning to make multiple small RAID
> volumes (i.e. RAID5 - 4+1, or RAID6 - 8+2) that would be either striped or
> concatenated together.
> 
> I'm looking for information on:
> 
> - Are there any cautions or recommendations about  XFS stability/performance
> on a thin volume with thin snapshots?
> 
> - I've read that there are tricks and calculations for aligning XFS to the
> RAID stripes.  Can use suggest any guidelines or tools for calculating the
> right configuration?

There is no magical trick :), you need to configure Stripe unit and stripe width
according to your raid configuration. You should set stripe unit (su option) to
the size of the stripes on your raid, and set the stripe width (sw option)
according to the number of data disks on your array (if you have a 4+1 raid 5,
it should be 4, into a 8+2 raid 6, it should be 8).
> 
> - I've read also about tuning the number of allocation groups to reflect the
> CPU configuration of the server.  Any suggestions on this?
> 

Allocation groups can't be bigger than 1TB. Assuming it should reflect your cpu
configuration is wrong, having too few or too many allocation groups can kill
your performance, and you also might face some another allocation problems in
the future, when the filesystem get aged when runnning with very small
allocation groups.

Determining the size of the allocation groups, is a case-by-case approach, and
it might need some experimenting.

Since you are dealing with thin provisioning devices, I'd be more careful then.
If you start with a small filesystem, and use the default configuration for
mkfs, it will give you a number of AGs according to your current block device
size, which can be a problem in the future when you decide to extend the
filesystem, AG size can't be changed after you make the filesystem. Make a
search on xfs list and you will see some reports of performance problems that
ended up being caused by very small filesystems that were extended later,
causing it to have lots of AGs.

So, what's the initial size that you expect to have such filesystems? How much
do you expect to grow them? These are some questions that might help you to have
some idea about the size of the AGs.

Regarding thing-provisioning, there are a couple things that you should keep in
mind.

- AGs segment the metadata across a whole disk, and increase parallelism in the
  filesystem, but, thin-provisioning will make such allocations sequential,
  despite where in the block device the filesystem tries to write, this is the
  nature of thin-provisioning devices so, I believe you should be more careful
  planning your DM-thin structure than the filesystem itself.

- There is a bug I'm working on with XFS while using thin-provisioning devices,
  where, if you overcommit the filesystem size (i.e. it's bigger than the real
  amount of space the dm-thin device really has), you might face some problems
  in case you try to write to the filesystem but there is no more space available
  in the dm-thin device, this thread contains a part of the story:
  http://www.spinics.net/lists/linux-xfs/msg01248.html
  Which remembers my I need to come back to this bug asap.

Just my 0.02, some other folks might remember something else.

Cheers

> Thanks.
> 
> -Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
