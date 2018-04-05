Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbeDESMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 14:12:40 -0400
Date: Thu, 5 Apr 2018 14:12:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: reset xfs_inode struct on reclaim in debug mode
Message-ID: <20180405181237.GA417@bfoster.bfoster>
References: <20180405121147.60897-1-bfoster@redhat.com>
 <20180405165142.GE7500@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180405165142.GE7500@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 05, 2018 at 09:51:42AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 05, 2018 at 08:11:46AM -0400, Brian Foster wrote:
> > A test case to reproduce a filestream/MRU use-after-free of a
> > reclaimed inode requires bits (e.g., ip->i_mount) of the inode to be
> > reset/reused once the inode memory is freed. This normally only
> > occurs when a new page is cycled into the zone, however.
> > 
> > Perform the "one-time" inode init immediately prior to freeing
> > inodes when in DEBUG mode. This will zero the inode, init the low
> > level structures (locks, lists, etc.) and otherwise ensure each
> > inode is in a purely uninitialized state while sitting in the zone
> > as free memory.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > I'll post a test that depends on this once this is worked out... one
> > concern this raised is if we consider any future bugs in the inode
> > initialization code (suppose we initialize some field once that should
> > be initialized on every allocation, for example), this code has the
> > potential to suppress such problems in debug mode. So an alternative to
> > this approach is to perhaps tie this to an errortag and let the
> > associated xfstests test enable it appropriately. Thoughts or
> > preferences?
> 
> How about memset()ing the entire inode with a known poison value in
> xfs_inode_free_callback and calling _init_once in xfs_inode_alloc
> instead?  That way it'll be obvious that someone touched a poisoned
> (free) inode.
> 

Ok... but note that doesn't address the concern above because we still
effectively call _init_once() for every allocation. Essentially this
means that if somebody screws up the idempotent nature of the
init_once() fields or adds a new xfs_inode field and doesn't initialize
it properly, the DEBUG mode kernel could suppress the problem by
reinvoking the ctor for each allocation (where a !DEBUG kernel
wouldn't). That's not a critical problem, but a bit of an annoying
tradeoff since IMO a DEBUG kernel should be more likely to find such
problems rather than hide them.

But if nobody objects to that tradeoff, I'm fine with doing a memset()
-> init_once() cycle as such instead of what this patch is doing. That
is probably a more robust form of use-after-free detection after all.
The minor tradeoff with the post-alloc init_once() approach is that we'd
also potentially suppress failures of the kmem_cache code to call the
ctor, but I suppose that's bound to fail spectacularly if that was ever
a problem.

Brian

> --D
> 
> > Brian
> > 
> >  fs/xfs/xfs_icache.c | 5 ++++-
> >  fs/xfs/xfs_super.c  | 2 +-
> >  fs/xfs/xfs_super.h  | 1 +
> >  3 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 9a18f69f6e96..86dc4c8a4e1d 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -111,7 +111,10 @@ xfs_inode_free_callback(
> >  		xfs_inode_item_destroy(ip);
> >  		ip->i_itemp = NULL;
> >  	}
> > -
> > +#ifdef DEBUG
> > +	/* facilitate catching use-after-free problems */
> > +	xfs_fs_inode_init_once(ip);
> > +#endif
> >  	kmem_zone_free(xfs_inode_zone, ip);
> >  }
> >  
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 612c1d5348b3..29b1be5dfebf 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1030,7 +1030,7 @@ xfs_fs_dirty_inode(
> >   * fields in the xfs inode that left in the initialise state
> >   * when freeing the inode.
> >   */
> > -STATIC void
> > +void
> >  xfs_fs_inode_init_once(
> >  	void			*inode)
> >  {
> > diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> > index 8cee8e8050e3..aae8a778f378 100644
> > --- a/fs/xfs/xfs_super.h
> > +++ b/fs/xfs/xfs_super.h
> > @@ -70,6 +70,7 @@ struct block_device;
> >  
> >  extern void xfs_quiesce_attr(struct xfs_mount *mp);
> >  extern void xfs_flush_inodes(struct xfs_mount *mp);
> > +extern void xfs_fs_inode_init_once(void *);
> >  extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
> >  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
> >  					   xfs_agnumber_t agcount);
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
