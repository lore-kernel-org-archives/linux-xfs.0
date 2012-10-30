Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UMSRKd077849 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 17:28:27 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WttTnX8LajlGOtaE for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 15:30:16 -0700 (PDT)
Date: Wed, 31 Oct 2012 09:30:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/25] xfs: add buffer pre-write callback
Message-ID: <20121030223015.GE29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-22-git-send-email-david@fromorbit.com>
	<20121026085014.GC3035@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121026085014.GC3035@infradead.org>
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

On Fri, Oct 26, 2012 at 04:50:14AM -0400, Christoph Hellwig wrote:
> >  	/*
> > +	 * run the pre-io callback function if it exists. If this function
> > +	 * fails it will mark the buffer with an error and the IO should
> > +	 * not be dispatched.
> > +	 */
> > +	if (bp->b_pre_io) {
> > +		bp->b_pre_io(bp);
> > +		if (bp->b_error) {
> 
> Wouldn't it be a cleaner calling convention to return the erro from the
> callback?

Perhaps. I just wrote it in a manner consistent with the iodone
function where errors are returned in bp->b_error. Other functions
pass buffer errors like this, too - xfs_buf_ioapply_map(),
xfs_buf_read_map(), and _xfs_buf_ioapply() - so it's not unusual,
really..

I can change it, but that involves changing every callback function
as well and I don't see that as really necessary. i.e. they call
xfs_buf_ioerror() already, so do we really need to have them return
bp->b_error as well?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
