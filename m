Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34250 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750918AbdLSUzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:55:45 -0500
Date: Wed, 20 Dec 2017 07:55:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: remove leftover CoW reservations when
 remounting ro
Message-ID: <20171219205542.GC4094@dastard>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335789173.26575.16460983789473064032.stgit@magnolia>
 <20171219001755.GJ4094@dastard>
 <20171219034911.GB11975@magnolia>
 <20171219043701.GO4094@dastard>
 <20171219045301.GC11975@magnolia>
 <20171219064655.GX4094@dastard>
 <20171219190026.GC11969@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219190026.GC11969@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 11:00:26AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 19, 2017 at 05:46:55PM +1100, Dave Chinner wrote:
> > On Mon, Dec 18, 2017 at 08:53:01PM -0800, Darrick J. Wong wrote:
> > > On Tue, Dec 19, 2017 at 03:37:02PM +1100, Dave Chinner wrote:
> > > > On Mon, Dec 18, 2017 at 07:49:11PM -0800, Darrick J. Wong wrote:
> > > > > On Tue, Dec 19, 2017 at 11:17:55AM +1100, Dave Chinner wrote:
> > > > > > On Fri, Dec 15, 2017 at 09:11:31AM -0800, Darrick J. Wong wrote:
> > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > 
> > > > > > > When we're remounting the filesystem readonly, remove all CoW
> > > > > > > preallocations prior to going ro.  If the fs goes down after the ro
> > > > > > > remount, we never clean up the staging extents, which means xfs_check
> > > > > > > will trip over them on a subsequent run.  Practically speaking, the
> > > > > > > next mount will clean them up too, so this is unlikely to be seen.
> > > > > > > 
> > > > > > > Found by adding clonerange to fsstress and running xfs/017.
> > > > > > > 
> > > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > > ---
> > > > > > >  fs/xfs/xfs_super.c |    8 ++++++++
> > > > > > >  1 file changed, 8 insertions(+)
> > > > > > > 
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > > > index f663022..7b6d150 100644
> > > > > > > --- a/fs/xfs/xfs_super.c
> > > > > > > +++ b/fs/xfs/xfs_super.c
> > > > > > > @@ -1369,6 +1369,14 @@ xfs_fs_remount(
> > > > > > >  
> > > > > > >  	/* rw -> ro */
> > > > > > >  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
> > > > > > > +		/* Get rid of any leftover CoW reservations... */
> > > > > > > +		cancel_delayed_work_sync(&mp->m_cowblocks_work);
> > > > > > > +		error = xfs_icache_free_cowblocks(mp, NULL);
> > > > > > > +		if (error) {
> > > > > > > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > > > > > +			return error;
> > > > > > > +		}
> > > > > > 
> > > > > > On rw->ro do we start the m_cowblocks_work back up?
> > > > > 
> > > > > Assuming you meant to ask about ro->rw, then yes it should get started
> > > > > back up the next time something sets the cowblocks tag.  I'm not opposed
> > > > > to starting it back up directly from the ro->rw handler.
> > > > > 
> > > > > > What about when we freeze the filesystem - shouldn't we clean
> > > > > > up the cow blocks there, too? We've tried hard in the past to make
> > > > > > freeze and rw->ro exactly the same so that if the system is powered
> > > > > > down while frozen it comes up almost entirely clean just like a
> > > > > > ro-remount in shutdown....
> > > > > 
> > > > > I don't see a hard requirement to clean them up at freeze time, though
> > > > > we certainly can do it for consistency's sake.
> > > > 
> > > > can't the background worker come around and attempt to do cleanup
> > > > while the fs is frozen? We've had vectors like that in the past that
> > > > have written to frozen filesystems (e.g. inode reclaim writing
> > > > inodes, memory reclaim shrinkers triggering AIL pushes) so leaving
> > > > potentially dirty objects in memory when the filesystem is frozen
> > > > is kinda dangerous. That's the reason behind trying to make
> > > > freeze/ro states identical - it makes sure we don't accidentally
> > > > leave writable objects in memory when frozen...
> > > 
> > > Hmmm, so /me tried making fsfreeze clear out the cow reservations, but
> > > doing so requires allocating a transaction, which blows the assert in
> > > sb_start_write because the fs is already frozen...
> > 
> > Ah, didn't we solve that problem years ago? Ah, yeah,
> > XFS_TRANS_NO_WRITECOUNT. That'd be a bit of a hack, but the
> > problem here is we need to run this between freezing data writes and
> > freezing transactions and we have no hook in the generic freeze
> > code to do that...
> > 
> > > I could just kill
> > > the thread without cleaning out the cow reservations and let the
> > > post-crash mount clean things up, since we already have the
> > > infrastructure to do that anyway?
> > 
> > Well, we do leave the log dirty on freeze so that we cleanup
> > unlinked inodes if we crash while frozen, so there is precedence
> > there. However, we need to balance that with the fairly common
> > problem of having to run recovery on read-only snapshots on the
> > first mount because a freeze leaves the log dirty. I don't
> > think we want to make that problem worse so I'd like to avoid this
> > solution if at all possible.
> > 
> > > (Or create a ->freeze_super and do it there...)
> > 
> > A ->freeze_data callout from the generic freezing code would be more
> > appropriate than completely reimplementing our own freeze code.
> > Right now the generic code just calls sync_filesystem(sb) to do this
> > before setting SB_FREEZE_FS - we need to do more than just sync data
> > if we are going to remove cow mappings on freeze....
> 
> <nod>
> 
> I was thinking of replacing the sync_filesystem() call in freeze_super
> with:
> 
> if (sb->s_op->freeze_data) {
> 	ret = sb->s_op->freeze_data(sb);
> 	if (ret) {
> 		printk(KERN_ERR
> 			"VFS:Filesystem dta freeze failed\n");
> 		sb->s_writers.frozen = SB_UNFROZEN;
> 		sb_freeze_unlock(sb);
> 		wake_up(&sb->s_writers.wait_unfrozen);
> 		deactivate_locked_super(sb);
> 		return ret;
> 	}
> } else {
> 	sync_filesystem(sb);
> }
> 
> Though at this point I feel that the freeze fix should be a totally
> separate patch from the ro<->rw patch.

Yup, agreed. So consider the original patch

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
