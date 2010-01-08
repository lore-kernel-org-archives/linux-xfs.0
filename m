Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08Ah03H031558 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 04:43:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B310F151F32
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 02:43:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	PCBl54Wbcd8PkAV2 for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2010 02:43:52 -0800 (PST)
Date: Fri, 8 Jan 2010 21:43:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: reclaim all inodes by background tree walks
Message-ID: <20100108104348.GB8718@discord.disaster>
References: <1262819125-27083-1-git-send-email-david@fromorbit.com>
	<1262819125-27083-3-git-send-email-david@fromorbit.com>
	<20100108102408.GB16640@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100108102408.GB16640@infradead.org>
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

On Fri, Jan 08, 2010 at 05:24:08AM -0500, Christoph Hellwig wrote:
> 
> Looks safe to me.  I wonder whaimpact leaving the inodes around for
> longer has to memory usage for inode heavy workloads, though.

In terms of wall time, nothing I can measure, but it seems to reduce
system time slightly. My main concern is memory pressure - maybe it
needs a shrinker registered to reclaim inodes immediately rather
than waiting for the next xfsssyncd run...

> >  unlock_and_requeue:
> > +	/*
> > +	 * We could return EAGAIN here to make reclaim rescan the inode tree in
> > +	 * a short while. However, this just burns CPU time scanning the tree
> > +	 * waiting for IO to complete and xfssyncd never goes back to the idle
> > +	 * state. Instead, return 0 to let the next scheduled background reclaim
> > +	 * attempt to reclaim the inode again.
> > +	 */
> >  	xfs_iflags_clear(ip, XFS_IRECLAIM);
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -	return EAGAIN;
> > +	return 0;
> 
> This is an unrelated change and should be a patch of it's own.

Yup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
