Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3K8ZsXi043079 for <xfs@oss.sgi.com>; Mon, 20 Apr 2009 03:35:55 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [xfs-masters] [RESEND][PATCH 6/7] xfs: Remove code handling
	bio_alloc failure with __GFP_WAIT
Date: Mon, 20 Apr 2009 13:53:35 +0530
References: <200904151609.30677.knikanth@suse.de>
	<20090420010237.GF16929@discord.disaster>
In-Reply-To: <20090420010237.GF16929@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904201353.35858.knikanth@suse.de>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>

On Monday 20 April 2009 06:32:37 Dave Chinner wrote:
> On Wed, Apr 15, 2009 at 04:09:30PM +0530, Nikanth Karthikesan wrote:
> > Resending as I accidentally missed Jens earlier.
> >
> > Jens, can you merge this as well.
> >
> > Thanks
> > Nikanth
> >
> > Remove code handling bio_alloc failure with __GFP_WAIT.
> > GFP_NOIO implies __GFP_WAIT.
>
> Not sure that is right. The intent of the code is that if we can't
> get a large bio immediately, try a smaller one which is more likely
> to succeed when we are under memory pressure. i.e. we will get IO
> moving faster than if we waited for a maximally sized biovec to be
> allocated.
>
> IOWs, I don't think __GFP_WAIT is implied by this code, regardless
> of what GFP_NOIO actually means now. The same code fragment can be
> found in NILFS, and it uses GFP_NOWAIT, not GFP_NOIO. I suspect that
> this is what this XFS code should be changed to use to retain the
> original intent of the code....
>

Yes, if that is the intent, it needs to be changed as GFP_NOWAIT. Otherwise 
the first attempt to get a larger bio itself would return only after it 
succeeds, which makes the logic useless.

Thanks
Nikanth

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
