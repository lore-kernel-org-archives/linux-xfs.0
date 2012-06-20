Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KHIRP1116545 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 12:18:27 -0500
Date: Wed, 20 Jun 2012 12:18:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120620171838.GB10196@sgi.com>
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
Cc: xfs@oss.sgi.com

Hey Christoph,

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

There isn't a race on the mount side related to the MS_ACTIVE flag.  It's only
on the unmount side.  I agree that we could get rid of the MS_ACTIVE check if
we move xfs_syncd_queue_sync to the last thing in the mount process.

The patch as-is has been well tested and I feel it is ready for a 3.5 rc merge.
I'd like to address the MS_ACTIVE check for the 3.6 merge window.  I do think
it is a good idea.

> On just slightly related issue with m_sync_work: what does the force
> flush of it from xfs_fs_sync_fs in laptop mode buys us?  The sync
> just did the log_force and log coverage, so the only think it will do
> is force out the AIL after we did the log force and thus guarantee to
> keep the fs busy for a while.  I can't really see how that's actually
> useful for batter life.  Note that ->sync_fs is only called for an
> epxlicit sync (in addition to umount,remount ro and freeze), so for
> normal desktop operation it's entirely irrelevant anyway.

1001 STATIC int
1002 xfs_fs_sync_fs(
1003         struct super_block      *sb,
1004         int                     wait)
1005 {
1006         struct xfs_mount        *mp = XFS_M(sb);
1007         int                     error;
1008 
1009         /*
1010          * Doing anything during the async pass would be counterproductive.
1011          */
1012         if (!wait)
1013                 return 0;
1014 
1015         error = xfs_quiesce_data(mp);
1016         if (error)
1017                 return -error;
1018 
1019         if (laptop_mode) {
1020                 /*
1021                  * The disk must be active because we're syncing.
1022                  * We schedule xfssyncd now (now that the disk is
1023                  * active) instead of later (when it might not be).
1024                  */
1025                 flush_delayed_work_sync(&mp->m_sync_work);
1026         }
1027 
1028         return 0;
1029 }

Is that comment misleading?  I think it could be interpreted like this:

"We're currently syncing, so the disk must already be active.  Since it is
already active, lets schedule xfssyncd now so that the work gets done
immediately.  Otherwise the disk could be spun down between now and when xfssyncd
would normally have been scheduled, only to be spun up once again by xfssyncd."

Before removing this we should take a look at the commit where this was added
and see what was up.  A bit of research to do.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
