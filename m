Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L2Bdjq103170 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 21:11:39 -0500
Date: Wed, 21 Sep 2011 12:11:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
Message-ID: <20110921021133.GM15688@dastard>
References: <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110920223047.GA13758@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Tue, Sep 20, 2011 at 06:30:47PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 20, 2011 at 07:35:57PM +0200, Stefan Priebe - Profihost AG wrote:
> > Am 20.09.2011 19:24, schrieb Christoph Hellwig:
> > >On Tue, Sep 20, 2011 at 07:23:00PM +0200, Stefan Priebe - Profihost AG wrote:
> > >>>  - what is the fs geometry?
> > >>What do you exactly mean? I've seen this on 1TB and 160GB SSD
> > >>devices with totally different disk layout.
> > >
> > >The output of mkfs.xfs (of xfs_info after it's been created)
> > 
> > ssd:~# xfs_info /dev/sda3
> > meta-data=/dev/root              isize=256    agcount=4, agsize=9517888 blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=38071552, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=18589, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Nothing special there.
> 
> So far I haven't been able to recreate it.  How many runs did you
> normally need on 3.1-rc?  Note that so far I've run my known working
> kernel, I'll test your config plus the drivers I need next.

How much memory does your test machine have? The performance will be
vastly different if there is enough RAM to hold the working set of
inodes and page cache (~20GB all up), and that could be one of the
factors contributing to the problems.

The above xfs_info output is from your 160GB SSD - what's the output
from the 1TB device?

Also, what phase do you see it hanging in? the random stat phase is
terribly slow on spinning disks, so if I can avoid that it woul dbe
nice....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
