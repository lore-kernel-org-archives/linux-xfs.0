Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K7iQNb262029 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 02:44:27 -0500
Date: Wed, 20 Jun 2012 03:44:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120620074424.GA9712@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 06, 2012 at 02:26:47PM +1000, Dave Chinner wrote:
> I think starting by renaming the xfs-syncd workqueue to the
> xfs_mount_wq because there's nothing "sync" related about it's
> functionality any more.

Is there any good reason to keep queueing different work items on the
same queue now that workqueues are incredibly cheap? 

> I'll then kill xfs_syncd_init/stop functions and open code the
> intialisation of the work structures and start them in the
> appropriate places for their functionality. e.g. reclaim work is
> demand started and stops when there's nothing more to do or at
> unmount, the flush work is demand started and we need to complete
> them all at unmount, and the xfssync work is really now "periodic
> log work" so should be started once we complete log recovery
> successfullly and stopped before we tear down the log....

Sounds good.  You probably also want to kill off xfs_sync_fsdata as
it doesn't make any sense with our current sync / ail pushing code
before that.

> Then I can move the xfs_sync_worker to xfs_log.c and rename it.

Before that you probably want to kill the xfs_ail_push_all in it in
favour or xfsaild waking up periodically by itself if there is anything
in the AIL.

> If I then convert xfs_flush_worker to use the generic writeback code
> (writeback_inodes_sb_if_idle) the xfs_sync_data() can go away.

Good plan.  It'll still need the trylock changes for it that don't
really seem to make forward progress on fsdevel.

> That
> means the only user of xfs_inode_ag_iterator is the quotaoff code
> (xfs_qm_dqrele_all_inodes), so it could be moved elsewhere (like
> xfs_inode.c).

fair enough.

> Then xfs_quiesce_data() can be moved to xfs-super.c where it can sit
> alongside the two functions that call it, and the same can be done
> for xfs_quiesce_attr().

xfs_fs_remount shouldn't really need to call it, as do_remount_sb
calls it just before entering ->remount_fs.  Although looking at it
closter do_remount_sb probably needs to move the sync_filesystem
call until after the check for r/o files and preventing new writes.

Independent of that I think xfs_quiesce_data should be merged into
xfs_fs_sync_fs - until do_remount_sb is fixed xfs_fs_remount should
simply call xfs_fs_sync_fs.

This also is a good opportunity to redo the maze of comments describing
the freeze process, which is rather outdated and a bit confusing now.

> That will leave only inode cache reclaim functions in xfs_sync.c.
> These are closely aligned to the inode allocation, freeing and cache
> lookup functions in xfs_iget.c, so I'm thinking of merging the two
> into a single file named xfs_inode_cache.c so both xfs_sync.c and
> xfs_iget.c go away.

Sounds good, although I'd call the file xfs_icache.c - that seems to
fit better with the general theme of naming schemes in XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
