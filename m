Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBH6fesb199017 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 00:41:40 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67E591CD7543
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 22:43:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	AjGk72BgwcNlfDFa for <xfs@oss.sgi.com>;
	Thu, 16 Dec 2010 22:43:33 -0800 (PST)
Date: Fri, 17 Dec 2010 17:43:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: ensure sync write errors are returned
Message-ID: <20101217064329.GD5193@dastard>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-2-git-send-email-david@fromorbit.com>
	<1292532649.2457.54.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292532649.2457.54.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 16, 2010 at 02:50:49PM -0600, Alex Elder wrote:
> On Wed, 2010-12-15 at 12:23 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_file_aio_write() only returns the error from synchronous
> > flushing of the data and inode if error == 0. At the point where
> > error is being checked, it is guaranteed to be > 0. Therefore any
> 
> Actually, we have this above the affected code:
>         ...
>         error = -ret;   
>         if (ret <= 0)
>                 goto out_unlock_internal;
> 
> So ret must be positive, therefore error is negative
> (the negative of the number of bytes written).  In
> other words, we enter this block without having seen
> an error.
> 
> The return at the end of the function is:
> 	return -error;
> 
> And by the convoluted logic here, that means that the
> value of error should be a negative byte count if
> successful, or a positive errno otherwise.

Oh, right, yeah, I screwed that up, didn't I?

> And since filemap_write_and_wait_range() returns a
> negative errno, your fix doesn't look right to me.

I will fix it up.

> The existing code is wrong and should be fixed, but a
> better fix might make the meaning of the variable "error"
> a little less weird.

The real problem is that xfs functions return positive errors, and
the linux functions return negative errors.  It would be much less
of a hassle if we fixed that problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
