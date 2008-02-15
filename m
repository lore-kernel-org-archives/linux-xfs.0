Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 20:26:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F4QnHY029918
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 20:26:51 -0800
Date: Fri, 15 Feb 2008 15:27:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Use atomics for iclog reference counting
Message-ID: <20080215042712.GY155259@sgi.com>
References: <20080121053021.GH155259@sgi.com> <4796CCF5.8010509@sgi.com> <20080214234758.GP155259@sgi.com> <20080215002429.GT155259@sgi.com> <47B5085D.30409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B5085D.30409@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 15, 2008 at 02:34:53PM +1100, Timothy Shimmin wrote:
> Dave,
> 
> So a bunch of incs/decs/tests converted to the atomic versions.
> And the interesting stuff appears to be in xlog_state_release_iclog().
> Okay that looks reasonable.
> If the decrement of the cnt doesn't go down to zero then we just
> return straight away - because we won't be going to sync anything.
> And if we do go to zero then we take the lock and continue.
> Why do we test for the error/EIO beforehand now too?
> Because we don't want to return 0 if we have an error to return?

Right. Effectively it retains the same behaviour as the old code.
i.e.  A call to xlog_state_release_iclog() with an elevated refcount
used to return EIO if the log had been shutdown and we need the
initial (unlocked) check to retain that behaviour.

However, this check is racy and so in the case where the last
ref goes away and we get the lock we need to check again when
we can't possibly race with a shutdown state change.

> Seems good.
> 
> In the 1st 2 cases of the patch:
> > @@ -675,7 +675,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
> >
> >  		spin_lock(&log->l_icloglock);
> >  		iclog = log->l_iclog;
> > -		iclog->ic_refcnt++;
> > +		atomic_inc(&iclog->ic_refcnt);
> >  		spin_unlock(&log->l_icloglock);
> >  		xlog_state_want_sync(log, iclog);
> >  		(void) xlog_state_release_iclog(log, iclog);
> > @@ -713,7 +713,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
> >  		 */
> >  		spin_lock(&log->l_icloglock);
> >  		iclog = log->l_iclog;
> > -		iclog->ic_refcnt++;
> > +		atomic_inc(&iclog->ic_refcnt);
> >  		spin_unlock(&log->l_icloglock);
> 
> Do we still really need to take the lock etc?

log->iclog is protected by the l_icloglock as well, so the lock
needs to be retained to prevent races when reading and taking a
reference to it. IOWs, the l_icloglock still synchronises increments
and the final decrement on an iclog; we only need the atomic counter
to enable unlocked refcount decrements when the refcount is > 1.
 
Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
