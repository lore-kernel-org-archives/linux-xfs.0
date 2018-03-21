Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbeCUL07 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 07:26:59 -0400
Date: Wed, 21 Mar 2018 07:26:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't shrink the inode cache until after setup
 completes
Message-ID: <20180321112657.GA10602@bfoster.bfoster>
References: <20180320050021.982-1-david@fromorbit.com>
 <20180320050021.982-3-david@fromorbit.com>
 <20180320120820.GB6107@bfoster.bfoster>
 <20180320132114.GS18129@dastard>
 <20180320142140.GB6454@bfoster.bfoster>
 <20180320223307.GU18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320223307.GU18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 09:33:07AM +1100, Dave Chinner wrote:
> On Tue, Mar 20, 2018 at 10:21:40AM -0400, Brian Foster wrote:
> > On Wed, Mar 21, 2018 at 12:21:14AM +1100, Dave Chinner wrote:
> > > On Tue, Mar 20, 2018 at 08:08:20AM -0400, Brian Foster wrote:
> > > > On Tue, Mar 20, 2018 at 04:00:21PM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > We recently came across an oops on a 4.14 kernel in
> > > > > xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
> > > > > and so the m_perag_tree lookup walked into lala land.
> > > > > 
> > > > > We found a mount in a failed state, blocked on teh shrinker rwsem
> > > > > here:
> > > > > 
> > > > > mount_bdev()
> > > > >   deactivate_locked_super()
> > > > >     unregister_shrinker()
> > > > > 
> > > > > Essentially, the machine was under memory pressure when the mount
> > > > > was being run, xfs_fs_fill_super() failed after allocating the
> > > > > xfs_mount and attaching it to sb->s_fs_info. It then cleaned up and
> > > > > freed the xfs_mount, but the sb->s_fs_info field still pointed to
> > > > > the freed memory. Hence when the superblock shrinker then ran
> > > > > it fell off the bad pointer.
> > > > > 
> > > > 
> > > > So this sounds like the root cause of the crash is a use after free and
> > > > not necessarily a "use before initialized," correct? I see that
> > > > ->m_perag_tree should be zeroed on allocation, but I have no idea if the
> > > > radix tree code is robust enough to deal with that.
> > > 
> > > Well, one symptom is use after free. It can also be used before it's
> > > initialised.
> > > 
> > 
> > Right.. but the user reproduced one was the use-after-free variant..?
> 
> Yeah, they are just different timings on the same issue. Basically,
> If I were to fail xfs_fs_fill_super() after xfs_mountfs() completed
> successfully and then delay in deactivate_locked_super() it would
> reproduce the use after free rather than the
> use-before-initialisation.
> 
> > > > > Setting sb->s_fs_info to NULL in this case won't solve the problem;
> > > > > we'll still crash on a null pointer in xfs_reclaim_inodes_count().
> > > > 
> > > > But the patch adds a NULL check..? I think this could be worded more
> > > > clearly.
> > > 
> > > Yes, that catches the case would have been a user after free. :)
> > > 
> > 
> > So what you're saying is that setting s_fs_info to NULL at least partly
> > solves the problem. ;P (But anyways, just wording confusion).
> 
> Yeah, just wording - "doesn't solve the whole problem" :)
> 
> > > > > The problem is that the superblock shrinker is running before the
> > > > >  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
> > > > > +	mp->m_flags |= XFS_MOUNT_PERAG_DONE;
> > > > 
> > > > But why not just move the radix tree root (and lock) initialization to
> > > > where the rest of the xfs_mount static structure initializations occur
> > > > (or at least the ones we expect to be accessible)? It looks to me that
> > > > intentionally occurs before the mp is attached to the superblock and
> > > > essentially fixes the problem the flag is trying to fix.
> > > 
> > > Could be done that way, but I still think we've got a general
> > > problem we need to deal with here. i.e. that we can't allow the
> > > shrinker to do anything until we actually initialised the parts of
> > > the xfs_mount that it uses.
> > 
> > I actually think it might be useful to initialize the static/low-level
> > data structures (i.e., locks, radix bits, etc.) as such regardless.
> 
> Well, the radix tree is already initialised - it's completely zero,
> so a lookup on a zeroed tree root should return NULL because the
> root node is null. That's the purpose of the memset before the delay
> - to ensure that a lookup executed by the shrinker actually dies a
> horrible death (which it does!)
> 

We still have to call the tree init function (and other similar
initializers) one way or another. We already do much of that immediately
after allocation.

> > There's only a couple places where we don't do that already (the perag
> > radix tree root being one), and that doesn't preclude higher level XFS
> > state management such as is being done by the XFS_MOUNT_PERAG_DONE flag,
> > if necessary. See the appended diff for reference.
> > 
> > I'm also wondering if there's value in doing a memset() (as your
> > previous patch) over the entire xfs_mount in DEBUG mode, immediately
> > after it's allocated, to facilitate catching this type of thing in the
> > future. That would require more of an audit to verify that we don't rely
> > on the kzalloc to correctly initialize certain fields (bools, ints,
> > etc.) though..
> 
> Yeah, the zeroing on allocation is done to ensure we don't have to
> zero each element individually. I'd much prefer we leave the code
> like that rather than introduce a whole new bug vector by having to
> manually initialise fields to zero...
> 

I am a little curious if we rely on that in practice (i.e., are there
any zero/false fields that are not explicitly set by the time
xfs_mountfs() returns?), but Ok, fair enough.

Brian

> > > I need to look further, because I think we're actually in a state
> > > where the shrinker scan cannot run at all during ->fill_super, which
> > > means we might actually be able to fix this at the VFS level by
> > > checking the SB_ACTIVE flag. I need to look a bit further on that,
> > > and if that's the case all this XFS stuff goes away....
> > > 
> > 
> > I'm pretty sure the dquot shrinker can run during quotacheck because we
> > had to make the previous delwri queue handling fixes to deal with that.
> > Though that shrinker is registered dynamically and so may have nothing
> > to do with the superblock inode shrinker for all I'm aware. Just a note,
> > FWIW.
> 
> We control the dquot shrinker ourselves, so we don't start it until
> it's safe to have it run. This problem is purely one of the VFS
> superblock shrinker where we don't directly control it's startup or
> access to the filesystem.
> 
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
