Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q960GdVr139583 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 19:16:40 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ai47TyeJ3AGRm9Xu for <xfs@oss.sgi.com>;
	Fri, 05 Oct 2012 17:18:05 -0700 (PDT)
Date: Sat, 6 Oct 2012 10:17:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs mount fails 'can't read superblock'
Message-ID: <20121006001757.GE23644@dastard>
References: <50583590.7060702@tbi.univie.ac.at>
	<20120918205508.GA31501@dastard>
	<505D85CF.9070701@tbi.univie.ac.at>
	<506C02CB.50009@tbi.univie.ac.at>
	<506EA487.8050903@tbi.univie.ac.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <506EA487.8050903@tbi.univie.ac.at>
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
To: Richard Neuboeck <hawk@tbi.univie.ac.at>
Cc: xfs@oss.sgi.com

On Fri, Oct 05, 2012 at 11:12:39AM +0200, Richard Neuboeck wrote:
> On 10/3/12 11:18 AM, Richard Neuboeck wrote:
> > Hi,
> > 
> > just in case someone stumbles over this thread in search for help. I
> > found a solution.
> > 
> > I upgraded the host machine from Ubuntu lucid to Ubuntu precise and
> > expected the same mounting behavior like in the virtual machine running
> > 'precise'. However on the host no error message showed up.
> > 
> > Long story short after some test on the virtual machine configuration
> > (libvirt, qemu/kvm) it turned out to be the 'caching=none' option. After
> > changing this to <driver name='qemu' type='raw' cache='default'/>
> > everything works.

So, you converted it to use buffered IO.

> And I forgot to mention that this 'bug' is still XFS dependent.

It's not a bug if theproblem is a sector size mismatch in your
configuration. You haven't provided any of the details that have
been asked for to confirm this, so it would be appreciated if you
could so we know in future....

> I have
> the same setup RAID/LVM/virtio setup in use with ext4. Which works fine.
> Either ext4 does something wrong so that it works or not I can not tell.
> The end result is that ext4 works, xfs only with modification to the
> virtual machine setup.

ext4 only does filesystem block sized IOs, which by default will be
4k, and hence work just fine on a 4k sector size host filesystem.
XFS does sector size IO in some cases, and that's where you appear
to behaving problems. Assuming the problem is a sector size
mismatch, then make your guest XFS filesystems use 4k sector
size, and everything will be fine....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
