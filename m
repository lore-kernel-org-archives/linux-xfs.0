Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T1NIL5232904 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 19:23:18 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ijIjOEUm0lVAFhFj for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 17:23:17 -0800 (PST)
Date: Wed, 29 Feb 2012 12:22:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Poor performance using discard
Message-ID: <20120229012259.GW3592@dastard>
References: <1330469778.9688.7.camel@core24>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330469778.9688.7.camel@core24>
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
To: Thomas Lynema <lyz27@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 05:56:18PM -0500, Thomas Lynema wrote:
> Please reply to my personal email as well as I am not subscribed to the
> list.
> 
> I have a PP120GS25SSDR it does support trim 
> 
> cat /sys/block/sdc/queue/discard_max_bytes 
> 2147450880
> 
> The entire drive is one partition that is totally used by LVM.
> 
> I made a test vg and formatted it with mkfs.xfs.  Then mounted it with
> discard and got the following result when deleting a kernel source:
> 
> /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> (rw,noatime,nodiratime,discard)
> 
> time rm -rf linux-3.2.6-gentoo/
> real   5m7.139s
> user   0m0.080s
> sys   0m1.580s 
> 

I'd say your problem is that trim is extremely slow on your
hardware. You've told XFS to execute a discard command for every
single extent that is freed, and that can be very slow if you are
freeing lots of small extents (like a kernel tree contains) and you
have a device that is slow at executing discards.

> There where lockups where the system would pause for about a minute
> during the process.

Yup, that's because it runs as part of the journal commit
completion, and if your SSD is extremely slow the journal will stall
waiting for all the discards to complete.

Basically, online discard is not really a smart thing to use for
consumer SSDs. Indeed, it's just not a smart thign to run for most
workloads and use cases precisely because discard is a very slow
and non-queuable operation on most hardware that supports it.

If you really need to run discard, just run a background discard
(fstrim) from a cronjob that runs when the system is mostly idle.
You won't have any runtime overhead on every unlink but you'll still
get the benefit of discarding unused blocks regularly.

> ext4 handles this scenerio fine:
> 
> /dev/mapper/ssdvg0-testLV on /media/temp type ext4
> (rw,noatime,nodiratime,discard)
> 
> time rm -rf linux-3.2.6-gentoo/
> 
> real   0m0.943s
> user   0m0.050s
> sys   0m0.830s 

I very much doubt that a single discard IO was issued during that
workload - ext4 uses the same fine-grained discard method XFS does,
and it does it at journal checkpoint completion just like XFS. So
I'd say that ext4 didn't commit the journal during this workload,
and no discards were issued, unlike XFS.

So, now time how long it takes to run sync to get the discards
issued and completed on ext4. Do the same with XFS and see what
happens. i.e.:

$ time (rm -rf linux-3.2.6-gentoo/ ; sync)

is the only real way to compare performance....

> xfs mounted without discard seems to handle this fine:
> 
> /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> (rw,noatime,nodiratime)
> 
> time rm -rf linux-3.2.6-gentoo/
> real	0m1.634s
> user	0m0.040s
> sys	0m1.420s

Right, that's how long XFS takes with normal journal checkpoint
IO latency. Add to that the time it takes for all the discards to be
run, and you've got the above number.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
