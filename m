Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KMxqK4183666 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 17:59:52 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cnZ70onloqMCEvA9 for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 15:59:50 -0700 (PDT)
Date: Thu, 21 Jun 2012 08:59:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120620225948.GM30705@dastard>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com>
	<20120620073600.GA4399@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620073600.GA4399@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 03:36:00AM -0400, Christoph Hellwig wrote:
> On Fri, May 25, 2012 at 03:45:36PM -0500, Ben Myers wrote:
> > Hey Dave,
> > 
> > On Thu, May 24, 2012 at 05:39:52PM -0500, Ben Myers wrote:
> > > Anyway, I'll make some time to work on this tomorrow so I can test it over
> > > the weekend.
> > 
> > This is going to spin over the weekend.  See what you think.
> > 
> > -----------
> > 
> > xfs:  shutdown xfs_sync_worker before the log
> > 
> > Revert commit 1307bbd, which uses the s_umount semaphore to provide
> > exclusion between xfs_sync_worker and unmount, in favor of shutting down
> > the sync worker before freeing the log in xfs_log_unmount.  This is a
> > cleaner way of resolving the race between xfs_sync_worker and unmount
> > than using s_umount.
> 
> I like the cancel_delayed_work_sync on unmount side of this, but I don't
> really like the MS_ACTIVE check - why can't we only do the initial
> xfs_syncd_queue_sync as the last thing in the mount process?

That's what i plan to fix as a followup - this is really just the
minimal fix to solve the problem at hand for 3.5....

> On just slightly related issue with m_sync_work: what does the force
> flush of it from xfs_fs_sync_fs in laptop mode buys us?  The sync
> just did the log_force and log coverage, so the only think it will do
> is force out the AIL after we did the log force and thus guarantee to
> keep the fs busy for a while.  I can't really see how that's actually
> useful for batter life.  Note that ->sync_fs is only called for an
> epxlicit sync (in addition to umount,remount ro and freeze), so for
> normal desktop operation it's entirely irrelevant anyway.

The laptop mode stuff has bit rotted for a long time - I've never
really cared about it, and realistically, we should either make it
work properly or rip it out. I'm in favor of ripping it out at the
moment, as SSDs are really making "keep the fs idle to avoid
spinning up the disk" optimisations redundant.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
