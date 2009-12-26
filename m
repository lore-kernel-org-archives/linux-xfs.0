Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBQ4H6DZ249531 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 22:17:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 346621C18C19
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 20:17:50 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	iSGXHFWaj9rg6pd2 for <xfs@oss.sgi.com>;
	Fri, 25 Dec 2009 20:17:50 -0800 (PST)
Date: Sat, 26 Dec 2009 15:17:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] XFS: Replace per-ag array with a radix tree
Message-ID: <20091226041746.GC13258@discord.disaster>
References: <1260857477-2368-6-git-send-email-david@fromorbit.com>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A68D1@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A68D1@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 23, 2009 at 04:08:54PM -0600, Alex Elder wrote:
> Dave Chinner wrote:
> > --- a/fs/xfs/xfs_filestream.c
> > +++ b/fs/xfs/xfs_filestream.c
> . . .
> > @@ -456,10 +455,10 @@ xfs_filestream_unmount(
> >  }
> > 
> >  /*
> > - * If the mount point's m_perag array is going to be reallocated, all
> > + * If the mount point's m_perag tree is going to be modified, all
> >   * outstanding cache entries must be flushed to avoid accessing reference count
> >   * addresses that have been freed.  The call to xfs_filestream_flush() must be
> > - * made inside the block that holds the m_peraglock in write mode to do the
> > + * made inside the block that holds the m_perag_lock in write mode to do the
> 
> Your change actually gets rid of the need to do this flush in the grow case
> (which is great), so this comment is no longer pertinent and should be killed
> off.

I am planning to kill off the unneeded filestreams stuff in another
cleanup patch - I just haven't got to it yet.
> 
> >   * reallocation.
> >   */
> >  void
> . . .
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index a13919a..37a6f62 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -167,27 +167,14 @@ xfs_growfs_data_private(
> >  	}
> >  	new = nb - mp->m_sb.sb_dblocks;
> >  	oagcount = mp->m_sb.sb_agcount;
> > -	if (nagcount > oagcount) {
> > -		void *new_perag, *old_perag;
> > -
> > -		xfs_filestream_flush(mp);
> > -
> > -		new_perag = kmem_zalloc(sizeof(xfs_perag_t) * nagcount,
> > -					KM_MAYFAIL);
> > -		if (!new_perag)
> > -			return XFS_ERROR(ENOMEM);
> > -
> > -		down_write(&mp->m_peraglock);
> > -		memcpy(new_perag, mp->m_perag, sizeof(xfs_perag_t) * oagcount);
> > -		old_perag = mp->m_perag;
> > -		mp->m_perag = new_perag;
> > -
> > -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> 
> I'm not sure why this flag was getting set, but your change
> does not implement this, at least not unconditionally.  (It
> is getting set based on mp->m_flags in xfs_initialize_perag()).
> Is that OK?

I think so - xfs_initialize_perag() got changed a while back not to
be dependent on this flag already being set to do the right thing,
but it wasn't removed from the growfs code. Hence I killed it here.

> > -		nagimax = xfs_initialize_perag(mp, nagcount);
> > -		up_write(&mp->m_peraglock);
> > 
> > -		kmem_free(old_perag);
> > +	/* allocate the new per-ag structures */
> > +	if (nagcount > oagcount) {
> 
> Maybe this occurs in another way, but in order to allow for the
> incremental update I think something needs to be done to prevent
> concurrent grow requests, possibly here.  (See more about this below.)

Agreed, and We've already got the mp->m_growlock to do this (see
xfs_growfs_data()). 

> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 4739c2c..73d61d4 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -209,13 +209,16 @@ STATIC void
> >  xfs_free_perag(
> >  	xfs_mount_t	*mp)
> >  {
> > -	if (mp->m_perag) {
> > -		int	agno;
> > +	xfs_agnumber_t	agno;
> > +	struct xfs_perag *pag;
> > 
> > -		for (agno = 0; agno < mp->m_maxagi; agno++)
> > -			if (mp->m_perag[agno].pagb_list)
> > -				kmem_free(mp->m_perag[agno].pagb_list);
> > -		kmem_free(mp->m_perag);
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> 
> Why do you switch to using m_sb.sb_agcount rather than mp->m_maxagi?

I did that because there is a window between sb_agcount() being
updated and m_maxagi being updated in the grow case. If there is
a failure between the two
> Can we get rid of the latter at some point, or is there a window
> of time where it is possible and meaningful for them to be
> different?

During the grow they can be different. e.g. if the growfs
transaction commit fails we haven't yet updated m_maxagi, but
we have already updated and initialised sb_agcount...

> > @@ -389,10 +392,11 @@ xfs_initialize_perag_icache(
> >  	}
> >  }
> > 
> > -xfs_agnumber_t
> > +int
> >  xfs_initialize_perag(
> >  	xfs_mount_t	*mp,
> > -	xfs_agnumber_t	agcount)
> > +	xfs_agnumber_t	agcount,
> > +	xfs_agnumber_t	*maxagi)
> 
> Now that you're returning an errno...  If this function is
> successful, it simply returns agcount in this location.  If
> it fails, it returns nothing meaningful.  I'd say there is
> no real need to have maxagi in the function definition any
> more (though it may just be a convenience for the caller).

*maxagi is needed to be returned because the m_maxagi is not
allowed to be updated until the growfs transaction commits
so that inode allocation does not use AGs being added during
the grow. Hence we have to be able to return both an errno and
the new maxagi from the function....

> >  	xfs_agnumber_t	index, max_metadata;
> >  	xfs_perag_t	*pag;
> > @@ -405,6 +409,33 @@ xfs_initialize_perag(
> >  	agino = XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
> >  	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
> > 
> > +	/*
> > +	 * Walk the current per-ag tree so we don't try to initialise AGs
> > +	 * that already exist (growfs case). Allocate and insert all the
> > +	 * AGs we don't find ready for initialisation.
> > +	 */
> > +	for (index = 0; index < agcount; index++) {
> > +		pag = xfs_perag_get(mp, index);
> > +		if (pag) {
> > +			xfs_perag_put(pag);
> > +			continue;
> > +		}
> > +		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
> > +		if (!pag)
> > +			return -ENOMEM;
> 
> Suppose we're adding two AG's to the file system.  What if
> the first one gets its per-ag structure successfully
> inserted, and the second one fails.  Then the call to
> xfs_initalize_perag() will fail but the mount struct's
> perag information will not be consistent.

Yup, and an ENOMEM here during a grow will cause a filesystem
shutdown, so it doesn't really matter that much.

> Neither
> m_sb.sb_agcount nor mp->m_maxagi will reflect the presence
> of this allocated perag structure, yet it could interfere
> with subsequent attempts to grow the file system.

This won't happen because the filesystem will be shut down
and a new grow attempt cannot be done without unmount/mount
cycle.

> If
> the index value were returned in *maxagi at this point
> then maybe the caller could try to recover or something,
> but I think logic to handle this case is better
> incorporated/hidden in or under this function.

Yeah, I think it needs to unwind the allocations that it has
already done. I'll send another patch to do that rather than
perturb this one again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
