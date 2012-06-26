Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q2KHqN046230 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 21:20:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wRNdCeFjoP9woT3p for <xfs@oss.sgi.com>;
	Mon, 25 Jun 2012 19:20:15 -0700 (PDT)
Date: Tue, 26 Jun 2012 12:20:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression] stack overflow in xfs_buf_iodone_callbacks
Message-ID: <20120626022011.GB19223@dastard>
References: <20120621091803.GB10673@dastard>
	<20120621163409.GA7897@infradead.org>
	<20120621232414.GD10673@dastard>
	<20120622164147.GA20617@infradead.org>
	<20120622233955.GY19223@dastard>
	<20120625090657.GA22726@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120625090657.GA22726@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 25, 2012 at 05:06:58AM -0400, Christoph Hellwig wrote:
> On Sat, Jun 23, 2012 at 09:39:55AM +1000, Dave Chinner wrote:
> > Hmmmm. How often do we get real io completion occurring before we
> > call _xfs_buf_ioend() here? I can't see that it is common, so this
> > is probably fine, but perhaps a few numbers might help here? If it
> > is rare as we think it is, then yeah, that would work....
> 
> The only case where I can see it ever hapen is when sending tons
> of separate I/Os in one go to a reall fast device, e.g. a very
> fragmented large directory to superfast battery backed dram device.
> 
> And even then I don't think it matters very much - for reads we
> generally do not have an b_iodone handler attached, so for these
> the change does not make any different.

We will very soon - CRC checks after reading for disk will be done
after reads. The patch series I'm working on at the moment
introduces sanity checks of buffers on read completion - it doesn't
do CRC checks yet, but it moves all the checks we do on read
completion into iodone callbacks, and when CRCs are introduced they
will simply be slotted into those functions....

> For delayed writes the
> additional context switch also doesn't have a major impact on
> performance, so the only thing where we could see a difference
> is synchronous writes, of which we don't have a lot left, and
> essentially none unless the shrinkers kick in and need to do
> synchronous reclaims.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
