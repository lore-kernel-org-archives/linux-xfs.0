Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C713E7F47
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2015 17:56:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7EFF304032
	for <xfs@oss.sgi.com>; Sun, 26 Apr 2015 15:56:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wtYEwGtE4Bp7TbSO for <xfs@oss.sgi.com>;
	Sun, 26 Apr 2015 15:56:39 -0700 (PDT)
Date: Mon, 27 Apr 2015 08:56:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: call xfs_idestroy_fork() in xfs_ilock() critical
	section
Message-ID: <20150426225625.GP15810@dastard>
References: <1429724021-7675-1-git-send-email-Waiman.Long@hp.com>
	<20150422231758.GQ21261@dastard>
	<20150423122149.GA13131@bfoster.bfoster>
	<20150423220823.GJ15810@dastard>
	<20150424115733.GA4177@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150424115733.GA4177@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 24, 2015 at 07:57:33AM -0400, Brian Foster wrote:
> On Fri, Apr 24, 2015 at 08:08:23AM +1000, Dave Chinner wrote:
> > On Thu, Apr 23, 2015 at 08:21:50AM -0400, Brian Foster wrote:
> > > On Thu, Apr 23, 2015 at 09:17:58AM +1000, Dave Chinner wrote:
> > > > @@ -410,11 +418,12 @@ xfs_attr_inactive(xfs_inode_t *dp)
> > > > +	lock_mode = XFS_ILOCK_EXCL;
> > > > +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT;
> > > > +	xfs_ilock(dp, lock_mode);
> > > >  
> > > >  	/*
> > > >  	 * No need to make quota reservations here. We expect to release some
> > > > @@ -423,28 +432,36 @@ xfs_attr_inactive(xfs_inode_t *dp)
> > > >  	xfs_trans_ijoin(trans, dp, 0);
> > > >  
> > > >  	/*
> > > > -	 * Decide on what work routines to call based on the inode size.
> > > > +	 * It's unlikely we've raced with an attribute fork creation, but check
> > > > +	 * anyway just in case.
> > > >  	 */
> > > > -	if (!xfs_inode_hasattr(dp) ||
> > > > -	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > > > -		error = 0;
> > > > -		goto out;
> > > > +	if (!XFS_IFORK_Q(dp))
> > > > +		goto out_cancel;
> > > 
> > > What about attribute fork creation would cause di_forkoff == 0 if that
> > > wasn't the case above? Do you mean to say a potential race with
> > > attribute fork destruction?
> > 
> > atrtibute fork creation will never leave di_forkoff == 0. See
> > xfs_attr_shortform_bytesfit() as a guideline for the min/max fork
> > offset at attribute fork creation time.
> > 
> > The race I'm talking about is the fact we check for an attr fork,
> > then drop the lock, do the trans reserve and then grab the lock
> > again. The inode could have changed in that time, so we need to
> > check again. It's extremely unlikely that the inode has changed due
> > to the fact it is in the ->evict path and can't be referenced by the
> > VFS again until it's in a reclaimable state. Hence it is only
> > internal filesystem stuff that could modify it, which I don't think
> > can happen. So, leave the check, mark the race as unlikely to occur.
> 
> The check seems fine to me. I'm referring to the comment above: "It's
> unlikely we've raced with an attribute fork creation, ..." 

Oh, ok, I missed that. I'll fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
