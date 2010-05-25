Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PMuAQU046723 for <xfs@oss.sgi.com>; Tue, 25 May 2010 17:56:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EB7D14426EE
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 15:58:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	ZgRnH9H4oPi5KUsO for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 15:58:31 -0700 (PDT)
Date: Wed, 26 May 2010 08:58:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix race in inode cluster freeing failing to
	stale inodes
Message-ID: <20100525225829.GO2150@dastard>
References: <1274581478-19260-1-git-send-email-david@fromorbit.com>
	<20100525164052.GA18666@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100525164052.GA18666@infradead.org>
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

On Tue, May 25, 2010 at 12:40:52PM -0400, Christoph Hellwig wrote:
> Looks good, but some minor nits on the comments below:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> >  		/*
> > +		 * Now we've locked out tail pushing and flushing by locking
> > +		 * the buffer, look for each inode in memory and attempt to
> > +		 * lock it. Any inode we get the locks on add it to the inode
> > +		 * buffer and set it up for being staled on buffer IO
> > +		 * completion.
> 
> This comment reads a bit odd.  The first thing we do in the loop is
> locking the buffer, so the "Now" at the beginning of the comment feels
> rather out of place.  What about:
> 
> 		/*
> 		 * For each inode in memory attempt to add it to the inode
> 		 * buffer and set it up for being staled on buffer IO
> 		 * completion.  This is safe as we've locked out tail
> 		 * pushing and flushing by locking the buffer.
> 		 *
> 		 * We have already marked every inode that was part of
> 		 * a transaction stale above, which means there is no
> 		 * point in even trying to lock them.
> 		 */

That reads better. I'll update it to match.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
