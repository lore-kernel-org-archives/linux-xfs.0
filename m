Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3CAvC4g146049 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 05:57:12 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A5B214B0DE3
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:00:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mOeA1PtAT5wN5Krf for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 04:00:32 -0700 (PDT)
Date: Tue, 12 Apr 2011 21:00:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reset buffer pointers before freeing them
Message-ID: <20110412110028.GA31057@dastard>
References: <1302491405-2290-1-git-send-email-david@fromorbit.com>
	<20110412000939.GC29358@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110412000939.GC29358@infradead.org>
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

On Mon, Apr 11, 2011 at 08:09:39PM -0400, Christoph Hellwig wrote:
> >  			error = xlog_bread_noalign(log, ealign, sectbb, bp);
> > -			if (error)
> > -				break;
> >  
> > -			error = XFS_BUF_SET_PTR(bp, offset, bufblks);
> > +			/* must reset buffer pointer even on error */
> > +			error2 = XFS_BUF_SET_PTR(bp, offset, bufblks);
> 
> This seems to be incorrect both in the original and your version.
> From all that I can see XFS_BUF_SET_PTR wants a byte count while bufblks
> is a sector count, e.g. this should be:
> 
> 			error2 = XFS_BUF_SET_PTR(bp, offset, BBTOB(bufblks);

Yes, you are right. I missed that.

> While at I think this mess with the buffer virtual mapping, read into it
> and set it back mess needs to go into a single helper instead of beeing
> duplicated three times.  By having named arguments with proper types
> bugs like the existing one above should also be much more obvious to
> spot.

Ok, I'll try to come up with something sane.

> As a follow on patch to that I think we could also get rid of all the
> vmap manipultions entirely, and just specify and I/O offset and length
> manually.  The only thing required for that is a number of pages
> to skip at the beggining of the buffer from the log recovery code to
> _xfs_buf_ioapply, either by passing it down procedurally, or by adding
> a new filed to struct xfs_buf.  In fact just relaxing the b_offset
> semantics to allow offsets larger than a page only in the I/O path would
> do it, but I'm not sure that version helps long-term maintenance.

Passing the offset+len seems like the cleaner solution to me. I
don't like the idea of overloading existing fields just for the IO
path or adding new fields for one off uses, either. That can
probably wait for another day, though, because we've still got the
iclog buffer hackery to deal with.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
