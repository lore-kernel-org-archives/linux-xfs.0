Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EC5A7CA2
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 23:46:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAD71304051
	for <xfs@oss.sgi.com>; Sun, 31 Jan 2016 21:46:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OPmAzI2sFewse89l for <xfs@oss.sgi.com>;
	Sun, 31 Jan 2016 21:46:53 -0800 (PST)
Date: Mon, 1 Feb 2016 16:46:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Random write result differences between RAID device and XFS
Message-ID: <20160201054639.GU6033@dastard>
References: <56AB44AF.8020807@purplehaze.ch> <20160129222553.GK20456@dastard>
	<56AC93EC.80202@purplehaze.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56AC93EC.80202@purplehaze.ch>
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
To: Christian Affolter <c.affolter@purplehaze.ch>
Cc: xfs@oss.sgi.com

On Sat, Jan 30, 2016 at 11:43:56AM +0100, Christian Affolter wrote:
> Hi Dave,
> 
> On 29.01.2016 23:25, Dave Chinner wrote:
> > On Fri, Jan 29, 2016 at 11:53:35AM +0100, Christian Affolter wrote:
> >> Hi everyone,
> >>
> >> I'm trying to understand the differences of some bandwidth and IOPs test
> >> results I see while running a random-write full-stripe-width aligned fio
> >> test (using libaio with direct IO) on a hardware RAID 6 raw device
> >> versus on the same device with the XFS file system on top of it.
> >>
> >> On the raw device I get:
> >> write: io=24828MB, bw=423132KB/s, iops=137, runt= 60085msec
> >>
> >> With XFS on top of it:
> >> write: io=14658MB, bw=249407KB/s, iops=81, runt= 60182msec
> > 
> > Now repeat with a file that is contiguously allocated before you
> > start. And also perhaps with the "swalloc" mount option.
> 
> Wow, thanks! After specifying --fallocate=none (instead of the default
> fallocate=posix), bandwidth and iops increases and are even higher than
> on the raw device:
> 
> write: io=30720MB, bw=599232KB/s, iops=195, runt= 52496msec
> 
> I'm eager to learn what's going on behind the scenes, can you give a
> short explanation?

Usually when concurrent direct IO writes are slower than the raw
device it's because something is causing IO submission
serialisation.  Usually that's to do with writes that extend the
file because that can require the inode to be locked exclusively.
Whatever behaviour the fio configuration change modifed, it removed
the IO submission serialisation and so it's now running at full disk
speed.

As to why XFS is faster than the raw block device, the XFS file
is only 30GB, so the random writes are only seeking a short
distance compared to the block device test which is seeking across
the whole device.

> Btw. mounting the volume with "swalloc" didn't make any change.

Which means there is no performance differential between stripe unit
and stripe width aligned writes in this test on your hardware.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
