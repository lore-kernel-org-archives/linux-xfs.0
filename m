Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5J1vr7G010423 for <xfs@oss.sgi.com>; Mon, 18 Jun 2012 20:57:53 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WdgE5ZRx40D0xbGV for <xfs@oss.sgi.com>;
	Mon, 18 Jun 2012 18:57:49 -0700 (PDT)
Date: Tue, 19 Jun 2012 11:57:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
Message-ID: <20120619015745.GJ25389@dastard>
References: <4FDF9EBE.2030809@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FDF9EBE.2030809@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 18, 2012 at 11:33:50PM +0200, Spelic wrote:
> Hello all
> I am doing some testing of dm-thin on kernel 3.4.2 and latest lvm
> from source (the rest is Ubuntu Precise 12.04).
> There are a few problems with ext4 and (different ones with) xfs
> 
> I am doing this:
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync
> lvs
> rm zeroes #optional
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
> lvs
> rm zeroes #optional
> ...
> dd if=/dev/zero of=zeroes bs=1M count=1000 conv=fsync  #again
> lvs
> rm zeroes
> fstrim /mnt/mountpoint
> lvs

[snip ext4 problems]

> On xfs there is a different problem.
> Xfs apparently correctly re-uses the same blocks so that after the
> first write at 140MB/sec, subsequent overwrites of the same file are
> at full speed such as 350MB/sec (same speed as with non-thin lvm),
> and also you don't see space occupation going up at every iteration
> of dd, either with or without rm in-between the dd's. [ok actually
> now retrying it needed 3 rewrites to stabilize allocation...
> probably an AG count thing.]

That's just a characteristic of the allocation algorithm. It's not
something that you see in day-to-day operation of the filesystem,
though, because you rarely remove and rewrite a file like this
repeatedly. So in the real world, performance will be more like ext4
when you are running workloads where you actually store data for
longer than a millisecond...

Expect that the 140MB/s number is the normal performance case,
because as soon as you take a snapshot, the overwrite requires new
blocks to be allocated in dm-thinp. You don't get thinp for nothing
- it has an associated performance cost as you are now finding
out....

> However the problem with XFS is that discard doesn't appear to work.
> Fstrim doesn't work, and neither does "mount -o discard ... + rm
> zeroes" . There is apparently no way to drop the allocated blocks,
> as seen from lvs. This is in contrast to what it is written here
> http://xfs.org/index.php/FITRIM/discard which declare fstrim and
> mount -o discard to be working.

I don't see why it wouldnt be if the underlying device supports it.
Have you looked at a block trace or an xfs event trace to see if
discards are being issued by XFS?

Are you getting messages like:

XFS: (dev) discard failed for extent [0x123,4096], error -5

in dmesg, or is fstrim seeing errors returned from the trim ioctl?

> Please note that since I am above MD raid5 (I believe this is the
> reason), the passdown of discards does not work, as my dmesg says:
> [160508.497879] device-mapper: thin: Discard unsupported by data
> device (dm-1): Disabling discard passdown.
> but AFAIU, unless there is a thinp bug, this should not affect the
> unmapping of thin blocks by fstrimming xfs... and in fact ext4 is
> able to do that.

Does ext4 report that same error?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
