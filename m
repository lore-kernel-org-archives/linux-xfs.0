Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0Q7S3mX110060 for <xfs@oss.sgi.com>; Tue, 26 Jan 2010 01:28:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E7D718A03C
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 23:28:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	jXoK5W0kDuHhKdu4 for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 23:28:38 -0800 (PST)
Date: Tue, 26 Jan 2010 18:28:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: Use delayed write for inodes rather than async
Message-ID: <20100126072835.GE15853@discord.disaster>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-3-git-send-email-david@fromorbit.com>
	<20100125115308.GC8595@infradead.org>
	<20100125223140.GN25842@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125223140.GN25842@discord.disaster>
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

On Tue, Jan 26, 2010 at 09:31:40AM +1100, Dave Chinner wrote:
> On Mon, Jan 25, 2010 at 06:53:08AM -0500, Christoph Hellwig wrote:
> > > diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> > > index 98b8937..ca0cc59 100644
> > > --- a/fs/xfs/linux-2.6/xfs_sync.c
> > > +++ b/fs/xfs/linux-2.6/xfs_sync.c
> > > @@ -270,8 +270,7 @@ xfs_sync_inode_attr(
> > >  		goto out_unlock;
> > >  	}
> > >  
> > > -	error = xfs_iflush(ip, (flags & SYNC_WAIT) ?
> > > -			   XFS_IFLUSH_SYNC : XFS_IFLUSH_DELWRI);
> > > +	error = xfs_iflush(ip, (flags & SYNC_WAIT));
> > 
> > No need for the masking here, as xfs_iflush simply ignores SYNC_TRYLOCK.
> 
> OK.
> 
> > >  	/* Now we have an inode that needs flushing */
> > >  	error = xfs_iflush(ip, sync_mode);
> > > +	if (!(sync_mode & SYNC_WAIT))
> > > +		goto requeue_no_flock;
> > 
> > So for the !wait case we entirely ignore the return value?  We should
> > at least check for an I/O error here I think.
> 
> I'm not sure we can get an error on a delayed write that we
> need to take action on. We don't actually issue the IO from this
> call, so the only error case is on reading the buffer. If we get
> an error there, what should be do?
> 
> My thinking was that if we can't write back the inode, we can't
> reclaim it, and if the error is from a transient read error (e.g. FC
> path failover) we should be retrying anyway as we do in
> xfs_buf_iodone_callbacks()...

I forgot to mention that it will get caught by a sync
reclaim pass when there is a context to return the error to....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
