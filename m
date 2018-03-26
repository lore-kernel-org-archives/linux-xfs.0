Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39520 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbeCZFvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 01:51:39 -0400
Date: Mon, 26 Mar 2018 06:51:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: don't scan the inode cache before SB_ACTIVE is set
Message-ID: <20180326055137.GP30522@ZenIV.linux.org.uk>
References: <20180326043503.17828-1-david@fromorbit.com>
 <20180326053151.GO30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326053151.GO30522@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Mar 26, 2018 at 06:31:51AM +0100, Al Viro wrote:
> On Mon, Mar 26, 2018 at 03:35:03PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We recently had an oops reported on a 4.14 kernel in
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
> > This is reproduced by using the mount_delay sysfs control as added
> > in teh previous patch. It produces an oops down this path during the
> > stalled mount:
> 
> > The problem is that the superblock shrinker is running before the
> > filesystem structures it depends on have been fully set up. i.e.
> > the shrinker is registered in sget(), before ->fill_super() has been
> > called, and the shrinker can call into the filesystem before
> > fill_super() does it's setup work.
> 
> Wait a sec...  How the hell does it get through trylock_super() before
> ->s_root is set and ->s_umount is unlocked?

I see...  So basically the story is

* super_cache_count() lacks trylock_super(), making it possible that it'll
be called too early on half-set superblock.
* it can't be called too late (during fs shutdown), since the shrinker is
unregistered before the call of ->kill_sb()
* making sure it won't get called too early can be done by checking SB_ACTIVE.

It's potentially racy, though - don't we need a barrier between setting the
things up and setting SB_ACTIVE?

And that, BTW, means that we want SB_BORN instead of SB_ACTIVE - unlike the
latter, the former is set only in one place.  So I'd suggest switching to
checking that, with a barrier pair added (in mount_fs() before setting the
sucker, another in super_cache_count() (before doing the
scan).
