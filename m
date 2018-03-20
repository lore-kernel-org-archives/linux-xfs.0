Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:56184 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753019AbeCTNVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 09:21:17 -0400
Date: Wed, 21 Mar 2018 00:21:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: don't shrink the inode cache until after setup
 completes
Message-ID: <20180320132114.GS18129@dastard>
References: <20180320050021.982-1-david@fromorbit.com>
 <20180320050021.982-3-david@fromorbit.com>
 <20180320120820.GB6107@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320120820.GB6107@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 20, 2018 at 08:08:20AM -0400, Brian Foster wrote:
> On Tue, Mar 20, 2018 at 04:00:21PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We recently came across an oops on a 4.14 kernel in
> > xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
> > and so the m_perag_tree lookup walked into lala land.
> > 
> > We found a mount in a failed state, blocked on teh shrinker rwsem
> > here:
> > 
> > mount_bdev()
> >   deactivate_locked_super()
> >     unregister_shrinker()
> > 
> > Essentially, the machine was under memory pressure when the mount
> > was being run, xfs_fs_fill_super() failed after allocating the
> > xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
> > freed the xfs_mount, but the sb->s_fs_info field still pointed to
> > the freed memory. Hence when the superblock shrinker then ran
> > it fell off the bad pointer.
> > 
> 
> So this sounds like the root cause of the crash is a use after free and
> not necessarily a "use before initialized," correct? I see that
> ->m_perag_tree should be zeroed on allocation, but I have no idea if the
> radix tree code is robust enough to deal with that.

Well, one symptom is use after free. It can also be used before it's
initialised.

> > Setting sb->s_fs_info to NULL in this case won't solve the problem;
> > we'll still crash on a null pointer in xfs_reclaim_inodes_count().
> 
> But the patch adds a NULL check..? I think this could be worded more
> clearly.

Yes, that catches the case would have been a user after free. :)

> > The problem is that the superblock shrinker is running before the
> > filesystem structures it depends on have been fully set up. i.e.
> > the shrinker is registered in sget(), before ->fill_super() has been
> > called, and the shrinker can call into the filesystem before
> > fill_super() does it's setup work.
> > 
> > The twist here is that we need the sb shrinker to run in the XFS
> > mount process because of the memory pressure that log recovery and
> > quota check can create. Hence we need to prevent the indoe cache
> > scanning from occurring until after we've set up the per-ag
> > structures and caches that it depends on. We also need to ensure
> > that we clear the flag and sb->s_fs_info on failure so that we
> > can do the right thing in all cases in xfs_reclaim_inodes_count().
> > 
> 
> Makes sense...
> 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.c | 2 ++
> >  fs/xfs/xfs_mount.h | 1 +
> >  fs/xfs/xfs_super.c | 9 +++++++++
> >  3 files changed, 12 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 6f5a5e6764d8..35a263c90fc0 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -155,6 +155,7 @@ xfs_free_perag(
> >  	xfs_agnumber_t	agno;
> >  	struct xfs_perag *pag;
> >  
> > +	mp->m_flags &= ~XFS_MOUNT_PERAG_DONE;
> >  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> >  		spin_lock(&mp->m_perag_lock);
> >  		pag = radix_tree_delete(&mp->m_perag_tree, agno);
> > @@ -244,6 +245,7 @@ xfs_initialize_perag(
> >  		*maxagi = index;
> >  
> >  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
> > +	mp->m_flags |= XFS_MOUNT_PERAG_DONE;
> 
> But why not just move the radix tree root (and lock) initialization to
> where the rest of the xfs_mount static structure initializations occur
> (or at least the ones we expect to be accessible)? It looks to me that
> intentionally occurs before the mp is attached to the superblock and
> essentially fixes the problem the flag is trying to fix.

Could be done that way, but I still think we've got a general
problem we need to deal with here. i.e. that we can't allow the
shrinker to do anything until we actually initialised the parts of
the xfs_mount that it uses.

I need to look further, because I think we're actually in a state
where the shrinker scan cannot run at all during ->fill_super, which
means we might actually be able to fix this at the VFS level by
checking the SB_ACTIVE flag. I need to look a bit further on that,
and if that's the case all this XFS stuff goes away....

> > +++ b/fs/xfs/xfs_mount.h
> > @@ -239,6 +239,7 @@ typedef struct xfs_mount {
> >  #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
> >  						   allocator */
> >  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
> > +#define XFS_MOUNT_PERAG_DONE	(1ULL << 26)	/* perag icache init done */
> 
> PERAG_DONE sounds odd to me. XFS_MOUNT_PERAG_INIT perhaps?

Tried to keep it short. INIT_DONE is what I firs thought, then I
dropped the init bit...

> >  {
> > +	/*
> > +	 * Don't do anything until the filesystem is fully set up, or in the
> 
> s/filesystem fully set up/perag infrastructure is initialized/ ?
> 
> "Fully set up" to me implies the mount is complete, where as noted in
> the commit log the shrinker needs to be functional for log recovery and
> quotacheck.

Well, that used to be true (th equotacheck thing) but as I mentioned
above, I'm not sure the shrinker runs at all during quotacheck...

> > +	 * process of being torn down due to a mount failure.
> > +	 */
> > +	if (!sb->s_fs_info)
> > +		return 0;
> > +	if (!(XFS_M(sb)->m_flags & XFS_MOUNT_PERAG_DONE))
> > +		return 0;
> 
> 	struct xfs_mount	*mp = XFS_M(sb);
> 
> 	if (!mp || !(mp->m_flags & XFS_MOUNT_PERAG_DONE))
> 		return 0;

I'd much prefer an explicit check of s_fs_info here, because
then it's obvious exactly what we expect to be null. XFS_M() could
ahve more code in it than just a cast of sb->s_fs_info. BUt, like I
said, this code might just go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
