Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q82K0L074932 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 03:02:20 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cWXQWH0JVUJ5kn3N (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Jun 2012 01:02:19 -0700 (PDT)
Date: Tue, 26 Jun 2012 04:02:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mkfs.xfs states log stripe unit is too large
Message-ID: <20120626080217.GA30767@infradead.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120626023059.GC19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Ingo J?rgensmann <ij@2012.bluespice.org>, xfs@oss.sgi.com

On Tue, Jun 26, 2012 at 12:30:59PM +1000, Dave Chinner wrote:
> You can't, simple as that. The maximum supported is 256k. As it is,
> a default chunk size of 512k is probably harmful to most workloads -
> large chunk sizes mean that just about every write will trigger a
> RMW cycle in the RAID because it is pretty much impossible to issue
> full stripe writes. Writeback doesn't do any alignment of IO (the
> generic page cache writeback path is the problem here), so we will
> lamost always be doing unaligned IO to the RAID, and there will be
> little opportunity for sequential IOs to merge and form full stripe
> writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
> 
> IOWs, every time you do a small isolated write, the MD RAID volume
> will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> Given that most workloads are not doing lots and lots of large
> sequential writes this is, IMO, a pretty bad default given typical
> RAID5/6 volume configurations we see....

Not too long ago I benchmarked out mdraid stripe sizes, and at least
for XFS 32kb was a clear winner, anything larger decreased performance.

ext4 didn't get hit that badly with larger stripe sizes, probably
because they still internally bump the writeback size like crazy, but
they did not actually get faster with larger stripes either.

This was streaming data heavy workloads, anything more metadata heavy
probably will suffer from larger stripes even more.

Ccing the linux-raid list if there actually is any reason for these
defaults, something I wanted to ask for a long time but never really got
back to.

Also I'm pretty sure back then the md default was 256kb writes, not 512
so it seems the defaults further increased.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
