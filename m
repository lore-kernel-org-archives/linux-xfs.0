Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LBddiW138265 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 06:39:39 -0500
Date: Wed, 21 Sep 2011 07:39:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs deadlock in stable kernel 3.0.4
Message-ID: <20110921113935.GA8947@infradead.org>
References: <20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
	<4E78CEFD.9030603@profihost.ag>
	<20110920223047.GA13758@infradead.org>
	<4E79940A.4000502@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E79940A.4000502@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

On Wed, Sep 21, 2011 at 09:36:42AM +0200, Stefan Priebe - Profihost AG wrote:
> >So far I haven't been able to recreate it.  How many runs did you
> >normally need on 3.1-rc?  Note that so far I've run my known working
> >kernel, I'll test your config plus the drivers I need next.
> 
> I had only used 3.0.4 with bonnie++ to reproduce. 3.1-rc was running
> on a prod. system.
> 
> Sadly i'm also not able to reproduce it reliable on every partition.
> Sometimes it works sometimes not. Just retrying does not help. I had
> to copy and delete random files from the part. and then start
> bonnie++ on it. Perhaps i can give you a dd dump of the partition.
> But i had to recreate one. My Intel SSD is now massivly slower than
> when i started the tests. No idea why.

So far it runs fine on 3.1-rc both with my default config and yours,
the latter had been running all night.  This is on a 8-core Nehalem
with 8GB of memory, and a fast PCI-e flash device.

One thing I noticed is that your config seems to run many fs tasks
a lot slower than mine, but I'm not entirely sure why.

The only interesting things I noticed in your config where that you
use slub instead of slab, which does a lot of high order allocations
and has caused lots of trouble in the past, and that you enable
CONFIG_CC_OPTIMIZE_FOR_SIZE, which has caused mis-compilation
of complicated code in the past.  I don't want to blame it directly,
but I could see how that causes problems with some of the atomic64_t
games XFS plays since 2.6.38.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
