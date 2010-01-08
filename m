Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08B4d0m033659 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 05:04:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 428E3EE74D9
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 03:05:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	LQVRLVlG0Cn0590D for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2010 03:05:27 -0800 (PST)
Date: Fri, 8 Jan 2010 22:05:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: Use delayed write for inodes rather than async
Message-ID: <20100108110524.GC8718@discord.disaster>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<1262649861-28530-2-git-send-email-david@fromorbit.com>
	<20100108103620.GA11769@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100108103620.GA11769@infradead.org>
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

On Fri, Jan 08, 2010 at 05:36:21AM -0500, Christoph Hellwig wrote:
> > +++ b/fs/xfs/linux-2.6/xfs_sync.c
> > @@ -460,8 +460,8 @@ xfs_quiesce_fs(
> >  {
> >  	int	count = 0, pincount;
> >  
> > +	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
> >  	xfs_flush_buftarg(mp->m_ddev_targp, 0);
> > -	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> 
> Hmm.  I think the current code here is simply wrong.  We do need to
> flush all delwri buffers after the inode reclaim.  Maybe we should
> get this hunk in for .33?

I don't think it really matters for the existing code as we do the
xfs_flush_buftarg(SYNC_WAIT) in the loop below which will push out
inodes flushed during reclaim.

Hmmm - given that xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI) can skip
inodes, there probably should be a sync reclaim done in the flush
loop to ensure we've caught them.

> > -		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> > +		xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
> >  		/* dgc: errors ignored here */
> >  		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
> >  		error = xfs_sync_fsdata(mp, SYNC_TRYLOCK);
> > @@ -687,7 +687,7 @@ xfs_reclaim_inode(
> >  		spin_unlock(&ip->i_flags_lock);
> >  		write_unlock(&pag->pag_ici_lock);
> >  		xfs_perag_put(pag);
> > -		return -EAGAIN;
> > +		return EAGAIN;
> 
> Unrelated bug in the upsteam code.  But your inode direct reclaim
> changes should sort this out already.

*nod*

> > @@ -3012,16 +3001,6 @@ xfs_iflush_int(
> >  	iip = ip->i_itemp;
> >  	mp = ip->i_mount;
> >  
> > -
> > -	/*
> > -	 * If the inode isn't dirty, then just release the inode
> > -	 * flush lock and do nothing.
> > -	 */
> > -	if (xfs_inode_clean(ip)) {
> > -		xfs_ifunlock(ip);
> > -		return 0;
> > -	}
> > -
> 
> while we now have this check in xfs_reclaim_inode there still are
> various other callers.  Did you audit them all to make sure we don't
> need the check here anymore?

Yes - xfs_iflush_int() gets called only from xfs_iflush() and
xfs_iflush_cluster() and both check first.

> > index 223d9c3..16c4654 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1444,7 +1444,14 @@ xfs_unmountfs(
> >  	 * need to force the log first.
> >  	 */
> >  	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
> > -	xfs_reclaim_inodes(mp, XFS_IFLUSH_ASYNC);
> > +
> > +	/*
> > +	 * flush the delwri buffers before the reclaim so that it doesn't
> > +	 * block for a long time waiting to reclaim inodes that are already
> > +	 * in the delwri state.
> > +	 */
> > +	XFS_bflush(mp->m_ddev_targp);
> > +	xfs_reclaim_inodes(mp, XFS_IFLUSH_SYNC);
> 
> Wouldn't it be more efficient to also write them out delwri and then
> flush out the delwri queue again?

The delayed write flush can skip inodes, so we need to do a sync
flush to guarantee that we reclaim all dirty inodes. The flush is done
first so the sync flush doesn't block on the flush locks for too
long for inodes that are already locked for delwri flushing.
Perhaps a:

	xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI);
	XFS_bflush(mp->m_ddev_targp);
	xfs_reclaim_inodes(mp, XFS_IFLUSH_SYNC);

sequence would be better here?

> Either way the current code seems fishy to me with an async writeout
> here.

Agreed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
