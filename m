Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGLtMOA132581 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 15:55:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C90B8145CA98
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 13:57:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	CU85eOdy1Pkhli1n for <xfs@oss.sgi.com>;
	Thu, 16 Dec 2010 13:57:15 -0800 (PST)
Date: Fri, 17 Dec 2010 08:57:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: ensure sync write errors are returned
Message-ID: <20101216215712.GB5193@dastard>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-2-git-send-email-david@fromorbit.com>
	<20101216115738.GB20445@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101216115738.GB20445@infradead.org>
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

On Thu, Dec 16, 2010 at 06:57:38AM -0500, Christoph Hellwig wrote:
> >  		error2 = filemap_write_and_wait_range(mapping, pos, end);
> > -		if (!error)
> > +		if (error2)
> >  			error = error2;
> >  		if (need_i_mutex)
> >  			mutex_lock(&inode->i_mutex);
> > @@ -777,7 +777,7 @@ write_retry:
> >  
> >  		error2 = -xfs_file_fsync(file,
> >  					 (file->f_flags & __O_SYNC) ? 0 : 1);
> > -		if (!error)
> > +		if (error2 && error >= 0)
> >  			error = error2;
> 
> Shouldn't the filemap_write_and_wait_range clause use a similar check as
> this one?

No need, because when we enter the branch, error is guaranteed to be
greater than zero as the code jumps over this branch if it is <= 0.
Hence we only need to overwrite error  with error2 from
filemap_write_and_wait_range() if error2 actually contains an error
(i.e. < 0).

The second hunk then has to deal with the fact that error can have
any value, and we only want to overwrite error if it doesn't already
contain an error value and error2 does. Hence the check for error >=
0 to ensure we don't overwrite an error from
filemap_write_and_wait_range().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
