Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB3HA1aU097359 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 11:10:01 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B86801C90E6A
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 09:11:44 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8UMxFbXCxpE4bMxN for <xfs@oss.sgi.com>;
	Fri, 03 Dec 2010 09:11:44 -0800 (PST)
Date: Sat, 4 Dec 2010 04:11:40 +1100
From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101203171140.GA11889@amd>
References: <4CF7A539.1050206@shiftmail.org>
	<20101202141134.GA22012@infradead.org>
	<4CF7A9C4.2040607@shiftmail.org>
	<20101202141737.GA29799@infradead.org>
	<20101202212227.GA22703@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202212227.GA22703@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: npiggin@kernel.dk, LVM general discussion and development <linux-lvm@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Spelic <spelic@shiftmail.org>

On Thu, Dec 02, 2010 at 04:22:27PM -0500, Mike Snitzer wrote:
> On Thu, Dec 02 2010 at  9:17am -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Thu, Dec 02, 2010 at 03:14:28PM +0100, Spelic wrote:
> > > On 12/02/2010 03:11 PM, Christoph Hellwig wrote:
> > > >I'm pretty sure you have CONFIG_DEBUG_BLOCK_EXT_DEVT enabled.  This
> > > >option must never be enabled, as it causes block devices to be
> > > >randomly renumered.  Together with the ramdisk driver overloading
> > > >the BLKFLSBUF ioctl to discard all data it guarantees you to get
> > > >data loss like yours.
> > > 
> > > Nope...
> > > 
> > > # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> > 
> > Hmm, I suspect dm-linear's dumb forwarding of ioctls has the same
> > effect.
> 
> For the benefit of others:
> - mkfs.xfs will avoid sending BLKFLSBUF to any device whose major is
>   ramdisk's major, this dates back to 2004:
>   http://oss.sgi.com/archives/xfs/2004-08/msg00463.html
> - but because a kpartx partition overlay (linear DM mapping) is used for
>   the /dev/ram0p1 device, mkfs.xfs only sees a device with DM's major 
> - so mkfs.xfs sends BLKFLSBUF to the DM device blissfully unaware that
>   the backing device (behind the DM linear target) is a brd device
> - DM will forward the BLKFLSBUF ioctl to brd, which triggers
>   drivers/block/brd.c:brd_ioctl (nuking the entire ramdisk in the
>   process)
> 
> So coming full circle this is what hch was referring to when he
> mentioned:
> 1) "ramdisk driver overloading the BLKFLSBUF ioctl ..."
> 2) "dm-linear's dumb forwarding of ioctls ..."
> 
> I really can't see DM adding a specific check for ramdisk's major when
> forwarding the BLKFLSBUF ioctl.
> 
> brd has direct partition support (see commit d7853d1f8932c) so maybe
> kpartx should just blacklist /dev/ram devices?
> 
> Alternatively, what about switching brd away from overloading BLKFLSBUF
> to a real implementation of (overloaded) BLKDISCARD support in brd.c?
> One that doesn't blindly nuke the entire device but that properly
> processes the discard request.

Yeah the situation really sucks (mkfs.jfs doesn't work on ramdisk
for the same reason).

I want to unfortunately keep ioctl for compatibility, but adding new
saner ones would be welcome. Also, having a non-default config or
load time parameter for brd, to skip the special case, if that would
help testing on older userspace.

DISCARD is actually a problem for rd. To actually get proper
correctness, you need to preload brd with pages, otherwise when
doing stress tests, IO can require memory allocations and deadlock.
If we add a discard that frees pages, that introduces the same problem.
If you find any option useful for testing, however, patches are fine --
brd pretty much is only useful for testing nowadays.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
