Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E53xPg134523 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 00:04:00 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SzR8l10yYXvltgeL for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 22:03:57 -0700 (PDT)
Date: Wed, 14 Mar 2012 16:03:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
Message-ID: <20120314050354.GX3592@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org>
	<20120312175519.GE7762@sgi.com>
	<20120313084241.GA359@infradead.org>
	<20120313152748.GG7762@sgi.com> <20120313214027.GF5091@dastard>
	<CAAp5ZgO+jJM5WHzbFLE98FoGmqztWZoQZ6u5-Zp=b6ow10JV=w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAp5ZgO+jJM5WHzbFLE98FoGmqztWZoQZ6u5-Zp=b6ow10JV=w@mail.gmail.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 01:34:29PM +1100, Nathan Scott wrote:
> On 14 March 2012 08:40, Dave Chinner <david@fromorbit.com> wrote:
> > It ignores lines that it doesn't understand the descriptor for (like
> > all the v2 btree stats). I should probably update the pmda fo all
> > those stats....
> >
> 
> That was done quite awhile back (mid-2010), unless there's some other
> stats come along since then that I don't know about yet?  (are these the
> ones you mean, Dave?...)
> 
> $ egrep '^[a-z]+2 ' /proc/fs/xfs/stat
> abtb2 4769967 54332939 635853 643428 507 508 282413 22672 61298 45587 1093
> 1111 1600 1619 393677507
> abtc2 10166604 113971561 4264119 4272402 1213 1214 77487 9464 29584 35760
> 1551 1571 2764 2785 1438715558
> bmbt2 152523 1231148 52950 42558 0 0 1372 1385 5117 1340 85 48 85 48 1545160
> ibt2 9475130 102652889 5672 2878 0 0 6549337 15214 801 869 17 0 17 0 1202730
> $
> 
> ( those are the xfs.btree.alloc_blocks.*, xfs.btree.alloc_contig.*,
> xfs.btree.block_map.*, and xfs.btree.inode.lookup.* metrics )

Yeah, that's them. I hadn't noticed them in name space because I'd
been looking for similar metric names to xfs.bmap_btree rather than
in a separate xfs.btree heirarchy.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
