Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53855 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758161AbdLSDtQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 22:49:16 -0500
Date: Mon, 18 Dec 2017 19:49:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/4] xfs: remove leftover CoW reservations when
 remounting ro
Message-ID: <20171219034911.GB11975@magnolia>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335789173.26575.16460983789473064032.stgit@magnolia>
 <20171219001755.GJ4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219001755.GJ4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 11:17:55AM +1100, Dave Chinner wrote:
> On Fri, Dec 15, 2017 at 09:11:31AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're remounting the filesystem readonly, remove all CoW
> > preallocations prior to going ro.  If the fs goes down after the ro
> > remount, we never clean up the staging extents, which means xfs_check
> > will trip over them on a subsequent run.  Practically speaking, the
> > next mount will clean them up too, so this is unlikely to be seen.
> > 
> > Found by adding clonerange to fsstress and running xfs/017.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_super.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index f663022..7b6d150 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1369,6 +1369,14 @@ xfs_fs_remount(
> >  
> >  	/* rw -> ro */
> >  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
> > +		/* Get rid of any leftover CoW reservations... */
> > +		cancel_delayed_work_sync(&mp->m_cowblocks_work);
> > +		error = xfs_icache_free_cowblocks(mp, NULL);
> > +		if (error) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +			return error;
> > +		}
> 
> On rw->ro do we start the m_cowblocks_work back up?

Assuming you meant to ask about ro->rw, then yes it should get started
back up the next time something sets the cowblocks tag.  I'm not opposed
to starting it back up directly from the ro->rw handler.

> What about when we freeze the filesystem - shouldn't we clean
> up the cow blocks there, too? We've tried hard in the past to make
> freeze and rw->ro exactly the same so that if the system is powered
> down while frozen it comes up almost entirely clean just like a
> ro-remount in shutdown....

I don't see a hard requirement to clean them up at freeze time, though
we certainly can do it for consistency's sake.

> And, FWIW, this makes ro->rw and thaw essentially the same, too.

Noted.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
