Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p29B8DEi036427 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 05:08:13 -0600
Date: Wed, 9 Mar 2011 06:11:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: do not immediately reuse busy extent ranges
Message-ID: <20110309111107.GB17556@infradead.org>
References: <20110304125953.650347660@bombadil.infradead.org>
	<20110304130119.656476789@bombadil.infradead.org>
	<1299538896.2578.897.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299538896.2578.897.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Mar 07, 2011 at 05:01:36PM -0600, Alex Elder wrote:
> This time I just scanned most of the change, since it appears
> it's almost the same except for the (renamed) xfs_alloc_busy_trim()
> function.

Yes.

> It looks correct now, but I have a few things for you
> to consider.  I'll wait for your response in case you want to
> change anything.  After that I'll pull in the three patches
> (probably tomorrow).

For now please just pull the first two.  There's a fair chance number
three will change based on how the discard work goes.

> I agree that the notation (from Dave) that you use here
> is very helpful in visualizing what's going on.  But
> the underlying code is pretty simple, and it gets somewhat
> lost in the comments I think.  I therefore would kind of
> prefer to have the explanation moved up above the function.
> It clearly labels the cases being treated, and references
> to those can be put in the code, below.
> 
> (This is a style thing, so if you feel strongly that it's
> better as you have it, so be it.)

I tried that before, but matching the cases to numbers in comments
wasn't very readable so I switch to this notation.

> All the nice diagrams refer to the variable "fbno"
> and "fend" using "bno" and "end.  I think you should
> either drop the "f" in the variables or add it to
> the comments.

Indeed.  I did a last minute cleanup to consolidate the duplicate
variables and didn't update the comments.

> (Something like that anyway, I just wanted to provide
> an example rather than just saying "it's wrong.")

Ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
