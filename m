Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 13:34:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DKYKTW021995
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:34:21 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12083126CDFC
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:35:51 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 7B1M2PuGxlEmJu5u for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 13:35:51 -0700 (PDT)
Date: Sun, 14 Sep 2008 06:35:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] XFS: xfssyncd: don't call xfs_sync
Message-ID: <20080913203549.GK5811@disturbed>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com> <1221314230-28618-6-git-send-email-david@fromorbit.com> <20080913165856.GB17721@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913165856.GB17721@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Sat, Sep 13, 2008 at 12:58:56PM -0400, Josef 'Jeff' Sipek wrote:
> On Sat, Sep 13, 2008 at 11:57:05PM +1000, Dave Chinner wrote:
> ...
> > @@ -533,8 +538,15 @@ xfs_sync_worker(
> >  {
> >  	int		error;
> >  
> > -	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
> > -		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > +		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
> > +		xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
> > +		/* dgc: errors ignored here */
> 
> Again, why?

Same again. No context for returning an error to someone useful,
and will only fail in a shutdown situation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
