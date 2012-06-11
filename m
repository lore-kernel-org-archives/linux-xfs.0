Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BKcJj9133803 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 15:38:19 -0500
Date: Mon, 11 Jun 2012 15:45:16 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120611204516.GR4721@sgi.com>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com> <20120606042647.GK22848@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120606042647.GK22848@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Wed, Jun 06, 2012 at 02:26:47PM +1000, Dave Chinner wrote:
> On Fri, May 25, 2012 at 03:45:36PM -0500, Ben Myers wrote:
> > xfs:  shutdown xfs_sync_worker before the log
> > 
> > Revert commit 1307bbd, which uses the s_umount semaphore to provide
> > exclusion between xfs_sync_worker and unmount, in favor of shutting down
> > the sync worker before freeing the log in xfs_log_unmount.  This is a
> > cleaner way of resolving the race between xfs_sync_worker and unmount
> > than using s_umount.
> 
> Looks fine to me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

> Once you commit this, I think I'll do a followup set of patches that
> remove all the problems caused by trying to start and stop unrelated
> functionality in the same place.

I think that's a good idea.

> I think starting by renaming the xfs-syncd workqueue to the
> xfs_mount_wq because there's nothing "sync" related about it's
> functionality any more.
>
> I'll then kill xfs_syncd_init/stop functions and open code the
> intialisation of the work structures and start them in the
> appropriate places for their functionality. e.g. reclaim work is
> demand started and stops when there's nothing more to do or at
> unmount, the flush work is demand started and we need to complete
> them all at unmount, and the xfssync work is really now "periodic
> log work" so should be started once we complete log recovery
> successfullly and stopped before we tear down the log....
> 
> Then I can move the xfs_sync_worker to xfs_log.c and rename it.
> If I then convert xfs_flush_worker to use the generic writeback code
> (writeback_inodes_sb_if_idle) the xfs_sync_data() can go away. That
> means the only user of xfs_inode_ag_iterator is the quotaoff code
> (xfs_qm_dqrele_all_inodes), so it could be moved elsewhere (like
> xfs_inode.c).
> 
> Then xfs_quiesce_data() can be moved to xfs-super.c where it can sit
> alongside the two functions that call it, and the same can be done
> for xfs_quiesce_attr().
> 
> That will leave only inode cache reclaim functions in xfs_sync.c.
> These are closely aligned to the inode allocation, freeing and cache
> lookup functions in xfs_iget.c, so I'm thinking of merging the two
> into a single file named xfs_inode_cache.c so both xfs_sync.c and
> xfs_iget.c go away.
> 
> Thoughts?

That sounds pretty good.  In particular, I think that making the start
and stop of the workqueues correct should be the high priority.  I'm not
as concerned about the accuracy of the names, or cleaning up xfs_sync.c
and xfs_iget.c, but cleanups are worth doing too.

I hit a crash related to the xfslogd workqueue awhile back.  Mark has
taken it up, so there might be a little coordination to do with him.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
