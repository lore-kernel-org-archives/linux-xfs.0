Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45718 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754502AbdKIXtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 18:49:32 -0500
Date: Thu, 9 Nov 2017 15:49:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/5] xfs: on failed mount, force-reclaim inodes after
 unmounting quota controls
Message-ID: <20171109234928.GP26910@magnolia>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <20171109060010.GK26910@magnolia>
 <20171109232425.GQ4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171109232425.GQ4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2017 at 10:24:25AM +1100, Dave Chinner wrote:
> On Wed, Nov 08, 2017 at 10:00:10PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When mounting fails, we must force-reclaim inodes (and disable delayed
> > reclaim) /after/ the realtime and quota control have let go of the
> > realtime and quota inodes.  Without this, we corrupt the timer list and
> > cause other weird problems.
> > 
> > Found by xfs/376 fuzzing u3.bmbt[0].lastoff on an rmap filesystem to
> > force a bogus post-eof extent reclaim that causes the fs to go down.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_mount.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index e9727d0..a9f0fe9 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1022,10 +1022,15 @@ xfs_mountfs(
> >  	xfs_rtunmount_inodes(mp);
> >   out_rele_rip:
> >  	IRELE(rip);
> > -	cancel_delayed_work_sync(&mp->m_reclaim_work);
> > -	xfs_reclaim_inodes(mp, SYNC_WAIT);
> >  	/* Clean out dquots that might be in memory after quotacheck. */
> >  	xfs_qm_unmount(mp);
> > +	/*
> > +	 * Cancel all delayed reclaim work and reclaim the inodes directly.
> > +	 * We have to do this /after/ rtunmount and qm_unmount because those
> > +	 * two will have scheduled delayed reclaim for the rt/quota inodes.
> > +	 */
> > +	cancel_delayed_work_sync(&mp->m_reclaim_work);
> > +	xfs_reclaim_inodes(mp, SYNC_WAIT);
> >   out_log_dealloc:
> >  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> >  	xfs_log_mount_cancel(mp);
> 
> Same bug in xfs_unmountfs(), isn't there? Otherwise this needs
> explaining why the order is different to a normal unmount...

Slightly different circumstances here.  In the unmountfs path we're
guaranteed to have called xfs_qm_unmount_quotas (which will irele the
quota inodes) before we shut down inode reclaim, but in the mountfs
error-out paths we decide to bail out after xfs_qm_newmount but before
calling xfs_qm_mount_quotas (e.g.  log_mount_finish failure), which
means that xfs_qm_unmount is the only chance we have to clean out the
quota inodes.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
