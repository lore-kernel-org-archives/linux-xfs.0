Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 13:33:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DKX3RV021810
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:33:03 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 596301BD0EDE
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:34:33 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id lM1CkWKUy2d7WO3W for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:34:33 -0700 (PDT)
Date: Sun, 14 Sep 2008 06:34:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/10] XFS: split out two helpers from xfs_syncsub
Message-ID: <20080913203428.GJ5811@disturbed>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com> <1221314230-28618-2-git-send-email-david@fromorbit.com> <20080913165341.GA17721@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913165341.GA17721@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 12:53:41PM -0400, Josef 'Jeff' Sipek wrote:
> On Sat, Sep 13, 2008 at 11:57:01PM +1000, Dave Chinner wrote:
> ...
> > diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> > index 53d85ec..59da332 100644
> > --- a/fs/xfs/linux-2.6/xfs_sync.c
> > +++ b/fs/xfs/linux-2.6/xfs_sync.c
> > @@ -315,6 +315,93 @@ xfs_sync_inodes(
> >  	return XFS_ERROR(last_error);
> >  }
> >  
> > +STATIC int
> > +xfs_commit_dummy_trans(
> > +	struct xfs_mount	*mp,
> > +	uint			log_flags)
> > +{
> > +	struct xfs_inode	*ip = mp->m_rootip;
> > +	struct xfs_trans	*tp;
> > +	int			error;
> > +
> > +	/*
> > +	 * Put a dummy transaction in the log to tell recovery
> > +	 * that all others are OK.
> > +	 */
> > +	tp = xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
> > +	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> > +	if (error) {
> > +		xfs_trans_cancel(tp, 0);
> > +		return error;
> > +	}
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ihold(tp, ip);
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +	/* XXX(hch): ignoring the error here.. */
> 
> Why? Was this supposed to be ignored in the final version of these patches?

The only possible error here is the result of a shutdown,
at which point we really don't care if this transaction
makes it to disk or not. There's nobody we can return the
error to, anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
