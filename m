Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q62889Nf187120 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 03:08:10 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DBvtrQZDM7U5tV9Z for <xfs@oss.sgi.com>;
	Mon, 02 Jul 2012 01:08:07 -0700 (PDT)
Date: Mon, 2 Jul 2012 18:08:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs states log stripe unit is too large
Message-ID: <20120702080802.GQ19223@dastard>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
	<20120626080217.GA30767@infradead.org>
	<20120702061827.GB16671@infradead.org>
	<20120702164113.109162be@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120702164113.109162be@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, Ingo J?rgensmann <ij@2012.bluespice.org>, xfs@oss.sgi.com

On Mon, Jul 02, 2012 at 04:41:13PM +1000, NeilBrown wrote:
> On Mon, 2 Jul 2012 02:18:27 -0400 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Ping to Neil / the raid list.
> 
> Thanks for the reminder.
> 
> > 
> > On Tue, Jun 26, 2012 at 04:02:17AM -0400, Christoph Hellwig wrote:
> > > On Tue, Jun 26, 2012 at 12:30:59PM +1000, Dave Chinner wrote:
> > > > You can't, simple as that. The maximum supported is 256k. As it is,
> > > > a default chunk size of 512k is probably harmful to most workloads -
> > > > large chunk sizes mean that just about every write will trigger a
> > > > RMW cycle in the RAID because it is pretty much impossible to issue
> > > > full stripe writes. Writeback doesn't do any alignment of IO (the
> > > > generic page cache writeback path is the problem here), so we will
> > > > lamost always be doing unaligned IO to the RAID, and there will be
> > > > little opportunity for sequential IOs to merge and form full stripe
> > > > writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
> > > > 
> > > > IOWs, every time you do a small isolated write, the MD RAID volume
> > > > will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> > > > Given that most workloads are not doing lots and lots of large
> > > > sequential writes this is, IMO, a pretty bad default given typical
> > > > RAID5/6 volume configurations we see....
> > > 
> > > Not too long ago I benchmarked out mdraid stripe sizes, and at least
> > > for XFS 32kb was a clear winner, anything larger decreased performance.
> > > 
> > > ext4 didn't get hit that badly with larger stripe sizes, probably
> > > because they still internally bump the writeback size like crazy, but
> > > they did not actually get faster with larger stripes either.
> > > 
> > > This was streaming data heavy workloads, anything more metadata heavy
> > > probably will suffer from larger stripes even more.
> > > 
> > > Ccing the linux-raid list if there actually is any reason for these
> > > defaults, something I wanted to ask for a long time but never really got
> > > back to.
> > > 
> > > Also I'm pretty sure back then the md default was 256kb writes, not 512
> > > so it seems the defaults further increased.
> 
> "originally" the default chunksize was 64K.
> It was changed in late 2009 to 512K - this first appeared in mdadm 3.1.1
> 
> I don't recall the details of why it was changed but I'm fairly sure that
> it was based on measurements that I had made and measurements that others had
> made.  I suspect the tests were largely run on ext3.
> 
> I don't think there is anything close to a truly optimal chunk size.  What
> works best really depends on your hardware, your filesystem, and your work
> load. 

That's true, but the characterisitics of spinning disks have not
changed in the past 20 years, nor has the typical file size
distributions in filesystems, nor have the RAID5/6 algorithms. So
it's not really clear to me why you;d woul deven consider changing
the default the downsides of large chunk sizes on RAID5/6 volumes is
well known. This may well explain the apparent increase in "XFS has
hung but it's really just waiting for lots of really slow IO on MD"
cases I've seen over the past couple of years.

The only time I'd ever consider stripe -widths- of more than 512k or
1MB with RAID5/6 is if I knew my workload is almost exclusively
using large files and sequential access with little metadata load,
and there's relatively few workloads where that is the case.
Typically those workloads measure throughput in GB/s and everyone
uses hardware RAID for them because MD simply doesn't scale to this
sort of usage.

> If 512K is always suboptimal for XFS then that is unfortunate but I don't

I think 512k chunk sizes are suboptimal for most users, regardless
of the filesystem or workload....

> think it is really possible to choose a default that everyone will be happy
> with.  Maybe we just need more documentation and warning emitted by various
> tools.  Maybe mkfs.xfs could augment the "stripe unit too large" message with
> some text about choosing a smaller chunk size?

We work to the mantra that XFS should always choose the defaults
that give the best overall performance and aging characteristics so
users don't need to be a storage expert to get the best the
filesystem can offer. The XFS warning is there to indicate that the
user might be doing something wrong. If that's being emitted with a
default MD configuration, then that indicates that the MD defaults
need to be revised....

If you know what a stripe unit or chunk size is, then you know how
to deal with the problem. But for the majority of people, that's way
more knowledge than they are prepared to learn about or should be
forced to learn about.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
