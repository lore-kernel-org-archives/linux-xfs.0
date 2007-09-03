Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Sep 2007 02:01:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8391C4p007258
	for <xfs@oss.sgi.com>; Mon, 3 Sep 2007 02:01:14 -0700
Date: Mon, 3 Sep 2007 19:01:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: lockdep annotations?
Message-ID: <20070903090103.GG734179@sgi.com>
References: <alpine.DEB.0.999.0709012300030.6640@sheep.housecafe.de> <46DB7586.7040309@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DB7586.7040309@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christian Kujau <lists@nerdbynature.de>, xfs@oss.sgi.com

On Mon, Sep 03, 2007 at 12:46:30PM +1000, Lachlan McIlroy wrote:
> This is a locking inversion between the iolock and iprune_mutex.  I
> hadn't seen this one before.  Was your system running low on memory
> at the time?
> 
> We can't drop the iolock in the write path so we'll have to avoid
> acquiring the iolock in xfs_ireclaim() which means we'll need another
> way to synchronise with xfs_sync_inodes().

I don't think a deadlock exists here - we have to be going through
memory reclaim to hit this inversion, so the only place that we
can deadlock is if we are holding the iprune_mutex across a memory
allocation. I don't think we do that....

Not to mention that the inode we hold the iolock on won't be on the
inode free list so we won't ever try to lock it during reclaim, either.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
