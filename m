Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6F03EFe171879 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 19:03:14 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E319B447F36
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 17:06:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	JEVtsU9BnI6Ge0dS for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 17:06:09 -0700 (PDT)
Date: Thu, 15 Jul 2010 10:05:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: don't block on buffer read errors
Message-ID: <20100715000552.GE30737@dastard>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
	<1279007450-10457-2-git-send-email-david@fromorbit.com>
	<20100714182836.GA12108@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100714182836.GA12108@infradead.org>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 14, 2010 at 02:28:36PM -0400, Christoph Hellwig wrote:
> Looks good, except that I'd rework the snipplet below
> 
> >  	status = xfs_buf_iorequest(bp);
> > -	if (!status && !(flags & XBF_ASYNC))
> > +	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
> >  		status = xfs_buf_iowait(bp);
> >  	return status;
> 
> as:
> 
> 	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
> 		return status;
> 	return xfs_buf_iowait(bp);
> 
> to make it a bit more clear.

Make sense. Fixed it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
