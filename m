Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pARNox3m200574 for <xfs@oss.sgi.com>; Sun, 27 Nov 2011 17:50:59 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52FA61D32D9A
	for <xfs@oss.sgi.com>; Sun, 27 Nov 2011 15:50:55 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	w5j2iuvfr1EypX6n for <xfs@oss.sgi.com>;
	Sun, 27 Nov 2011 15:50:55 -0800 (PST)
Date: Mon, 28 Nov 2011 10:50:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111127235051.GX2386@dastard>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ED2C233.8010104@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Sun, Nov 27, 2011 at 05:05:23PM -0600, Eric Sandeen wrote:
> On 11/26/11 7:06 PM, Dave Chinner wrote:
> > On Thu, Nov 24, 2011 at 05:50:42PM -0200, Carlos Maiolino wrote:
> >> On Thu, Nov 24, 2011 at 05:20:51PM -0200, Carlos Maiolino wrote:
> >>> xfsprogs (mainly mkfs) is using the logical sector size of a volume to initialize
> >>> the filesystem, which, even in devices using Advanced Format, it can get a 512
> >>> bytes sector size if it is set as the logical sector size.
> >>> This patch changes the ioctl to get the physical sector size, independent of the
> >>> logical size.
> >>>
> >>
> >> Just as information, this patch proposal does not change the behaviour of mkfs in case the 
> >> user is using libblkid, which in case, mkfs will take advantage of libblkid to retrieve disk
> >> topology and information.
> >> I'm not sure if libblkid is the best way to retrieve the device sector's size here, since 
> >> this does not provide a way to retrive the physical sector size, only the logical size, but 
> >> I can be very wrong.
> > 
> > If libblkid exports the PBS (physical block size) as exposed in
> > /sys/block/<dev>/queue/physical_block_size, then we should be able
> > to get it.
> > 
> > However, the issue in my mind is not whether it is supported, but
> > what is the effect of making this change? The filesystem relies on
> > the fact that the minimum guaranteed unit of atomic IO is a sector,
> > not the PBS of the underlying disk. What guarantees do we have when
> > do a PBS sized IO is doesn't get torn into sector sized IOs by the
> > drive and hence only partitially completed on failure?  Indeed, if
> > the filesystem is sector unaligned, it is -guaranteed- to have PBS
> > sized IOs torn apart by the hardware....
> > 
> > i.e. do we have any guarantee at all that a PBS sized IO will either
> > wholly complete or wholly fail when PBS != sector size? And if not,
> > why is this a change we should make given it appears to me to
> > violate a fundamental assumption of the filesystem design?
> 
> I had the expectation that physical block size WAS the fundamental/atomic
> IO size for the disk, and anything smaller required read/modify/write.
> So I made this suggestion (and I think hch concurred) so that we weren't
> doing log IOs which required RMW & translation.

A RMW cycle does not mean the IO is not atomic. The write to disk
will still be atomic, regardless of the read that ovvurred before.

> i.e. for a 4k physical / 512 logical disk - wouldn't we want to choose
> 4k sectors?
> 
> Ok, if we have mismanaged the alignment and aligned to logical, not
> physical, then I guess there would be an issue... but at that point
> we've already messed up (though not catastrophically I guess)...

That's where I'm concerned - if alignment is screwed because the FS
is 512B sector aligned (because something read the logical sector size),
then using a 4k sector will result in torn writes because every 4k
sector write is potentially made up of 2 4k write IOs, not 1.

That's my concern - using the logical 512b sector size is -always-
safe, but using the 4k physical block size is only safe if
everything under the filesystem has detected and used the physical
block size of the disk for alignment and sector sizes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
