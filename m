Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JLXSbS252397 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 16:33:28 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bnVuFuyzuouPQHy5 for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 14:34:39 -0700 (PDT)
Date: Thu, 20 Sep 2012 07:34:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Writeback Stalls
Message-ID: <20120919213427.GD31501@dastard>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7A3@EXCHANGE.collogia.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735831B7A3@EXCHANGE.collogia.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 19, 2012 at 06:36:11PM +0000, Markus Stockhausen wrote:
> Hello,
> 
> I'm not sure if you can help me with the following problem but I must start somewhere.
> 
> We have an small sized VMWare infrastructure. 8 hosts with round about 50 VMs. 
> Their images are hosted on 2 Ubuntu 12.04 NFS storage servers with each of them
> having a 14 disk RAID 6 array. On top of the array runs a single XFS filesystem with 
> round about 10TB of disk space.
> 
> From time to time we see stalls in the infrastructure. The machines become unresponsive
> and hang for a few seconds. The controller was the first item to be under suspect. 
> But after a lot examination we created a very artifical setup that shows the real reasons
> for the stalls: Writeback handling. The parameters are:
> 

So:

> - set NFS to async

Disable the NFS server-client writeback throttling control loop
(i.e. commits block until data is synced to disk). Also, data loss
on NFS server crash.

> - disable controller and disk writeback cache

IO is exceedingly slow.

> - enable cgroup
> - set dirty_background_bytes to some very high value (4GB)
> - set dirty_bytes to some very high value (4GB)
> - set dirty_expire_centisecs to to some very high value (60 secs)

Allow lots of dirty data in memory before writeback starts

> - set blkio.throttle.write_bps_device to a very low value (2MB/sek)

And throttle writeback to 2MB/s.

Gun. Foot. Point. Shoot.

> Now generate some write load on a Windows VM. During the test we observe what
> is happening on the storage and the VM. The result is:
> 
> - dirty pages are increasing
> - writeback is constantly 0
> - VM is working well

The VM is not "working well" with this configuration - it's building
up a large cache of dirty pages that you've limited to draining at a
very slow rate. IOWs, on an NFS server, having a writeback value of
0 is exactly the problem, and disabling the client-server throttling
feedback loop only makes it worse. You want writeback on the server
to start early, not delay it until you run out of memory.

> At some point writeback is kicking in and all of a sudden the VM stalls. During
> this time the setup shows
> 
> - most of the dirty pages are transfered to writeback pages
> - writeback is done at the above set limit (2MB/sek)
> - VM is not responding 

Because you ran out of clean pages and it takes forever to write
4GB of dirty data @ 2MB/s.

> After writeback has finished everything goes back to normal. Additional remark:
> VMs DO NOT hang if I create heavy writes on the XFS into non-VM related files.

Probably because they are not in the throttled cgroup that the NFS
daemons are in.

> We are interested in this kind of setup for several reasons:
> 
> 1. Keep VMs reponsive
> 
> 2. Allow VMs to generate short spikes of write I/Os at a higher rate than the 
> disk subsystem is capable of. 
> 
> 3. Write this data back to the disk in the background over a longer period
> of time. Ensure that a limited writeback rate keeps enough headroom so that
> read I/Os are not delayed too much.

Fundamentally, you are doing it all wrong. High throughput, low
latency NFS servers write dirty data to disk fast, not leave it
memory until you run out of clean memory because that causes
everything to block waiting for writeback IO completion to be ale to
free memory...

This really isn't an XFS problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
