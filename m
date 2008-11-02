Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 15:10:47 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA2NAXDk031039
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 15:10:34 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 320EB1BDB3E3
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 15:10:33 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id QkfEtPpprC9now4g for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 15:10:33 -0800 (PST)
Date: Mon, 3 Nov 2008 10:10:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: handle memory allocation failures during log
	initialisation
Message-ID: <20081102231023.GJ19509@disturbed>
References: <1225416366-3116-1-git-send-email-david@fromorbit.com> <490A8AAD.50207@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490A8AAD.50207@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 03:33:49PM +1100, Timothy Shimmin wrote:
> Hi Dave,
> 
> Dave Chinner wrote:
> > When there is no memory left in the system, xfs_buf_get_noaddr()
> > can fail. If this happens at mount time during xlog_alloc_log()
> > we fail to catch the error and oops.
> > 
> > Catch the error from xfs_buf_get_noaddr(), and allow other memory
> > allocations to fail and catch those errors too. Report the error
> > to the console and fail the mount with ENOMEM.
> > 
> > Tested by manually injecting errors into xfs_buf_get_noaddr() and
> > xlog_alloc_log().
> > 
> > Version 2:
> > o remove unnecessary casts of the returned pointer from kmem_zalloc()
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/xfs_log.c |   39 ++++++++++++++++++++++++++++++++++++---
> >  1 files changed, 36 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 5184017..92c20a8 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -563,6 +563,11 @@ xfs_log_mount(
> >  	}
> >  
> >  	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> > +	if (!mp->m_log) {
> > +		cmn_err(CE_WARN, "XFS: Log allocation failed: No memory!");
> > +		error = ENOMEM;
> > +		goto out;
> > +	}
> >  
> >  	/*
> >  	 * Initialize the AIL now we have a log.
> > @@ -601,6 +606,7 @@ xfs_log_mount(
> >  	return 0;
> >  error:
> >  	xfs_log_unmount_dealloc(mp);
> > +out:
> >  	return error;
> >  }	/* xfs_log_mount */
> >  
> > @@ -1217,7 +1223,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
> >  	int			i;
> >  	int			iclogsize;
> >  
> > -	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_SLEEP);
> > +	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
> > +	if (!log)
> > +		return NULL;
> >  
> >  	log->l_mp	   = mp;
> >  	log->l_targ	   = log_target;
> > @@ -1249,6 +1257,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
> >  	xlog_get_iclog_buffer_size(mp, log);
> >  
> >  	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
> > +	if (!bp)
> > +		goto out_free_log;
> >  	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> >  	XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
> >  	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
> > @@ -1275,13 +1285,17 @@ xlog_alloc_log(xfs_mount_t	*mp,
> >  	iclogsize = log->l_iclog_size;
> >  	ASSERT(log->l_iclog_size >= 4096);
> >  	for (i=0; i < log->l_iclog_bufs; i++) {
> > -		*iclogp = (xlog_in_core_t *)
> > -			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
> > +		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
> > +		if (!*iclogp)
> > +			goto out_free_iclog;
> > +
> >  		iclog = *iclogp;
> >  		iclog->ic_prev = prev_iclog;
> >  		prev_iclog = iclog;
> >  
> >  		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
> > +		if (!bp)
> > +			goto out_free_iclog;
> >  		if (!XFS_BUF_CPSEMA(bp))
> >  			ASSERT(0);
> >  		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
> > @@ -1323,6 +1337,25 @@ xlog_alloc_log(xfs_mount_t	*mp,
> >  	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
> >  
> >  	return log;
> > +
> > +out_free_iclog:
> > +	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
> > +		prev_iclog = iclog->ic_next;
> > +		if (iclog->ic_bp) {
> > +			sv_destroy(&iclog->ic_force_wait);
> > +			sv_destroy(&iclog->ic_write_wait);
> > +			xfs_buf_free(iclog->ic_bp);
> > +			xlog_trace_iclog_dealloc(iclog);
> > +		}
> > +		kmem_free(iclog);
> > +	}
> > +	spinlock_destroy(&log->l_icloglock);
> > +	spinlock_destroy(&log->l_grant_lock);
> > +	xlog_trace_loggrant_dealloc(log);
> > +	xfs_buf_free(log->l_xbuf);
> > +out_free_log:
> > +	kmem_free(log);
> > +	return NULL;
> >  }	/* xlog_alloc_log */
> >  
> >  
> 
> I would have done s/prev_iclog/next_iclog/
> as I'm not sure why you look at it as previous.

Already had a local variable of the right type - not much
point in declaring a new variable to use as a list iterator
when you've already got a variable that is used as a list
iterator in another, non-overlapping part of the code ;)

> However, I think it would be nicer to modify xlog_dealloc_log()
> to handle less than l_iclog_bufs.
> i.e put the code you have here into xlog_dealloc_log()
> and do the deallocation in one place.

The current trend is to unwind complex initialisation errors at
the place they occur, even if there is a destructor function for
a completely intialised object/subsystem. I just followed that
construct. And to be truly complete, it should also handle
trace buffer initialisation failure, which would make the
unwinding even more complex than it is above.

Given that this is a regression fix I didn't want to perturb the
log destructor code by making it have to handle partially set up
lists and objects....

If you still want me to push this into xlog_dealloc_log() I will,
just let me know.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
