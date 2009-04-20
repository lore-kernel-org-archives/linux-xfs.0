Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3K12oJ1018367 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 20:02:50 -0500
Date: Mon, 20 Apr 2009 11:02:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs-masters] [RESEND][PATCH 6/7] xfs: Remove code handling
	bio_alloc failure with __GFP_WAIT
Message-ID: <20090420010237.GF16929@discord.disaster>
References: <200904151609.30677.knikanth@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200904151609.30677.knikanth@suse.de>
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
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>

On Wed, Apr 15, 2009 at 04:09:30PM +0530, Nikanth Karthikesan wrote:
> Resending as I accidentally missed Jens earlier.
> 
> Jens, can you merge this as well.
> 
> Thanks
> Nikanth
> 
> Remove code handling bio_alloc failure with __GFP_WAIT.
> GFP_NOIO implies __GFP_WAIT.

Not sure that is right. The intent of the code is that if we can't
get a large bio immediately, try a smaller one which is more likely
to succeed when we are under memory pressure. i.e. we will get IO
moving faster than if we waited for a maximally sized biovec to be
allocated.

IOWs, I don't think __GFP_WAIT is implied by this code, regardless
of what GFP_NOIO actually means now. The same code fragment can be
found in NILFS, and it uses GFP_NOWAIT, not GFP_NOIO. I suspect that
this is what this XFS code should be changed to use to retain the
original intent of the code....

Cheers,

Dave.
-- 
Dave Chinner
dgc@evostor.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
