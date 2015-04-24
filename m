Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 814187F50
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 06:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00BEEAC004
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 04:57:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PchSD7n7ZLQvhKHL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Apr 2015 04:57:48 -0700 (PDT)
Date: Fri, 24 Apr 2015 07:57:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
Message-ID: <20150424115733.GA4177@laptop.bfoster>
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
	<20150422231758.GQ21261@dastard>
	<20150423122149.GA13131@bfoster.bfoster>
	<20150423220823.GJ15810@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150423220823.GJ15810@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 24, 2015 at 08:08:23AM +1000, Dave Chinner wrote:
> On Thu, Apr 23, 2015 at 08:21:50AM -0400, Brian Foster wrote:
> > On Thu, Apr 23, 2015 at 09:17:58AM +1000, Dave Chinner wrote:
> > > @@ -410,11 +418,12 @@ xfs_attr_inactive(xfs_inode_t *dp)
> > >  	 */
> > >  	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
> > >  	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
> > > -	if (error) {
> > > -		xfs_trans_cancel(trans, 0);
> > > -		return error;
> > > -	}
> > > -	xfs_ilock(dp, XFS_ILOCK_EXCL);
> > > +	if (error)
> > > +		goto out_cancel;
> > > +
> > 
> > The error path expects a locked inode, but it isn't here.
> 
> Right, xfs/181 tripped that. I've fixed it in my current version ;)
> 
> > 
> > > +	lock_mode = XFS_ILOCK_EXCL;
> > > +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT;
> > > +	xfs_ilock(dp, lock_mode);
> > >  
> > >  	/*
> > >  	 * No need to make quota reservations here. We expect to release some
> > > @@ -423,28 +432,36 @@ xfs_attr_inactive(xfs_inode_t *dp)
> > >  	xfs_trans_ijoin(trans, dp, 0);
> > >  
> > >  	/*
> > > -	 * Decide on what work routines to call based on the inode size.
> > > +	 * It's unlikely we've raced with an attribute fork creation, but check
> > > +	 * anyway just in case.
> > >  	 */
> > > -	if (!xfs_inode_hasattr(dp) ||
> > > -	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > > -		error = 0;
> > > -		goto out;
> > > +	if (!XFS_IFORK_Q(dp))
> > > +		goto out_cancel;
> > 
> > What about attribute fork creation would cause di_forkoff == 0 if that
> > wasn't the case above? Do you mean to say a potential race with
> > attribute fork destruction?
> 
> atrtibute fork creation will never leave di_forkoff == 0. See
> xfs_attr_shortform_bytesfit() as a guideline for the min/max fork
> offset at attribute fork creation time.
> 
> The race I'm talking about is the fact we check for an attr fork,
> then drop the lock, do the trans reserve and then grab the lock
> again. The inode could have changed in that time, so we need to
> check again. It's extremely unlikely that the inode has changed due
> to the fact it is in the ->evict path and can't be referenced by the
> VFS again until it's in a reclaimable state. Hence it is only
> internal filesystem stuff that could modify it, which I don't think
> can happen. So, leave the check, mark the race as unlikely to occur.
> 

The check seems fine to me. I'm referring to the comment above: "It's
unlikely we've raced with an attribute fork creation, ..." 

> > > +	/* invalidate and truncate the attribute fork extents */
> > > +	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
> > > +		error = xfs_attr3_root_inactive(&trans, dp);
> > > +		if (error)
> > > +			goto out_cancel;
> > > +
> > > +		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
> > > +		if (error)
> > > +			goto out_cancel;
> > >  	}
> > > -	error = xfs_attr3_root_inactive(&trans, dp);
> > > -	if (error)
> > > -		goto out;
> > >  
> > > -	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
> > > -	if (error)
> > > -		goto out;
> > > +	/* Reset the attribute fork - this also destroys the in-core fork */
> > > +	xfs_attr_fork_reset(dp, trans);
> > >  
> > >  	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
> > > -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > > -
> > > +	xfs_iunlock(dp, lock_mode);
> > >  	return error;
> > >  
> > > -out:
> > > -	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> > > -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> > > +out_cancel:
> > > +	xfs_trans_cancel(trans, cancel_flags);
> > > +out_destroy_fork:
> > > +	/* kill the in-core attr fork before we drop the inode lock */
> > > +	if (dp->i_afp)
> > > +		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
> > > +	xfs_iunlock(dp, lock_mode);
> > 
> > I wonder if a warning or some kind of notification is appropriate here.
> > If we get to this point, we're removing an inode potentially without
> > having freed attr fork blocks and thus leaving them permanently
> > unreferenced, yes?
> 
> We end up leaving the inode on the unlinked list because we abort
> the inactivation on error. The in-core inode still gets reclaimed
> properly, but it's now up to log recovery to re-run inactivation to
> try to free the inode or xfs_repair to cleanit up.  Either way, it's
> safe just to leave the inode where it is on the unlinked list - it's
> free and not getting in the way, so IMO warnings at this point don't
> serve any useful purpose...
> 

Ok, so the inode is actually not yet freed on-disk in that scenario.
Sounds reasonable.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
