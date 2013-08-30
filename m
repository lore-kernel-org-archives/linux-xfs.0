Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 098F57F53
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:38:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B260430404E
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:38:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2QP16OvztQccJpQr for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 20:38:02 -0700 (PDT)
Date: Fri, 30 Aug 2013 13:38:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: higher agcount on LVM2 thinp volumes
Message-ID: <20130830033800.GX12779@dastard>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<521FF8F4.9040009@hardwarefreak.com>
	<DD759368-581C-4C94-BC5E-E6EC3A83FC61@colorremedies.com>
	<20130830025819.GB23571@dastard>
	<B40ABF48-E2CB-4C02-9DF9-B68BB84341C3@colorremedies.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <B40ABF48-E2CB-4C02-9DF9-B68BB84341C3@colorremedies.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chris Murphy <lists@colorremedies.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Thu, Aug 29, 2013 at 09:21:15PM -0600, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 8:58 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > Check the contents of
> > /sys/block/<dev>/queue/{minimum,optimal}_io_size for the single
> > device, the standard LV and the thinp device.
> 
> physical device:
> 
> [root@f19s ~]# cat /sys/block/sda/queue/minimum_io_size 
> 512
> [root@f19s ~]# cat /sys/block/sda/queue/optimal_io_size 
> 0
> 
> conventional LV on that physical device:
>      
> [root@f19s ~]# cat /sys/block/dm-0/queue/minimum_io_size 
> 512
> [root@f19s ~]# cat /sys/block/dm-0/queue/optimal_io_size 
> 0
> 
> 
> thinp pool and LV:
> 
> lrwxrwxrwx. 1 root root       7 Aug 29 20:46 vg1-thinp -> ../dm-3
> 
> [root@f19s ~]# cat /sys/block/dm-3/queue/minimum_io_size 
> 512
> [root@f19s ~]# cat /sys/block/dm-3/queue/optimal_io_size 
> 262144
> [root@f19s ~]# 
> 
> lrwxrwxrwx. 1 root root       7 Aug 29 20:47 vg1-data -> ../dm-4
> 
> [root@f19s ~]# cat /sys/block/dm-4/queue/minimum_io_size 
> 512
> [root@f19s ~]# cat /sys/block/dm-4/queue/optimal_io_size 
> 262144

Yup, there's the problem - minimum_io_size is 512 bytes, which is
too small for a stripe unit to be set to. Hence sunit/swidth get set
to zero.

The problem here is that minimum_io_size is not the minimum IO size
that can be done, but the minimum IO size that is *efficient*. For
example, my workstation has a MD RAID0 device with a 512k chunk size
and two drives:

$ cat /sys/block/md0/queue/minimum_io_size 
524288
$ cat /sys/block/md0/queue/optimal_io_size 
1048576

Here we see the minimum *efficient* IO size is the stripe chunk size
(i.e. what gets written to a single disk) and the optimal is an IO
that hits all disks at once.

So, what dm-thinp is trying to tell us is that the minimum
*physical* IO size is 512 bytes (i.e. /sys/.../physical_block_size)
but the efficient IO size is 256k. So dm-thinp is exposing the
information incorrectly. What it shoul dbe doing is setting both the
minimum_io_size and the optimal_io_size to the same value of 256k...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
