Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12GBE55178783 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 10:11:14 -0600
Received: from bedivere.hansenpartnership.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFD591DB8174
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 08:12:22 -0800 (PST)
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com
	[66.63.167.143]) by cuda.sgi.com with ESMTP id yyTlTwX952cbwvql
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2010 08:12:22 -0800 (PST)
Subject: Re: State of XFS on ARM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <46b8a8851002020742w28891d18g24d01982631cdf2b@mail.gmail.com>
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
	<20100202112300.GA23809@infradead.org>
	<46b8a8851002020742w28891d18g24d01982631cdf2b@mail.gmail.com>
Date: Tue, 02 Feb 2010 10:12:17 -0600
Message-Id: <1265127137.2800.67.camel@mulgrave.site>
Mime-Version: 1.0
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Daniel Goller <morfic@gmail.com>

On Tue, 2010-02-02 at 07:42 -0800, Richard Sharpe wrote:
> On Tue, Feb 2, 2010 at 3:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Feb 01, 2010 at 09:24:33PM -0600, Daniel Goller wrote:
> >> It seems i have not been able to unmount it and then mounting it
> >> cleanly once, always required xfs_repair -L   /dev/sdc3
> >> I Could understand power issues or lockups causing this, but on clean
> >> umount and followed mount to see it fail is surprising.
> >> When mounting fails on the headless arm machine i move the drive to a
> >> x86_64 and run xfs_repair there when mounting there fails too (so log
> >> can't be replayed, making -L necessary).
> >> All of this leads me to ask:  "Is XFS as well maintained on ARM as it
> >> is on x86/x86_64?"
> >
> > XFS itself is platform neutral.  But it seems like you have an ARM
> > platform with virtually indexed caches, which currently can't support
> > the I/O XFS does.  James has been working on fixing this for a while,
> > but so far the architecture support patches for it unfortunately still
> > haven't made it to mainline despite many people running into this issue.
> 
> I would be interested in a precise explanation for this problem. We
> ran into an issue here with XFS on the Marvell 78200 (ARM) which has a
> VIVT cache. We eventually solved the problem by using
> flush_icache_range in a strategic place (after also discovering the
> need for flush_dcache_page, but that has to do with doing IO between
> the cores on the 78200), but we really did not understand why that
> fixed the problem. However, it stopped the corruption we were
> experiencing when using a file system exerciser.

XFS uses large buffers for log operations.  Because large physically
contiguous pieces of memory are hard to come by, it makes its logs from
virtually contiguous pages.  The problem is that doing this sets up
aliasing within the kernel: each page in the range now has two virtual
addresses: one for the standard kernel offset map and the other for the
xfs created virtual area.  When I/O is done on a kernel page, the kernel
always flushes the offset map to ensure that the data is in main memory.
However, when the page has another alias in the xfs created virtual
area, the kernel I/O subsystem has no idea about this.  Since xfs is
reading and writing to this other alias, that's what needs to be flushed
to make sure the data is safely in main memory before I/O takes place.

James


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
