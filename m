Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37360 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751439AbdHKX7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 19:59:30 -0400
Date: Fri, 11 Aug 2017 16:59:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/3] xfs: evict all inodes involved with log redo item
 recovery
Message-ID: <20170811235900.GI24087@magnolia>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
 <150234263191.13754.5037661818451431724.stgit@magnolia>
 <20170811195010.GH24087@magnolia>
 <20170811234204.GV21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811234204.GV21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk, Christoph Hellwig <hch@infradead.org>

On Sat, Aug 12, 2017 at 09:42:04AM +1000, Dave Chinner wrote:
> On Fri, Aug 11, 2017 at 12:50:10PM -0700, Darrick J. Wong wrote:
> > When we introduced the bmap redo log items, we set MS_ACTIVE on the
> > mountpoint and XFS_IRECOVERY on the inode to prevent unlinked inodes
> > from being truncated prematurely during log recovery.  This also had the
> > effect of putting linked inodes on the lru instead of evicting them.
> > 
> > Unfortunately, we neglected to find all those unreferenced lru inodes
> > and evict them after finishing log recovery, which means that we leak
> > them if anything goes wrong in the rest of xfs_mountfs, because the lru
> > is only cleaned out on unmount.
> > 
> > Therefore, evict unreferenced inodes in the lru list immediately
> > after clearing MS_ACTIVE.
> > 
> > Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Cc: viro@ZenIV.linux.org.uk
> > ---
> > v2: use the vfs evict_inodes instead of duplicating it
> > ---
> >  fs/inode.c         |    1 +
> >  fs/internal.h      |    1 -
> >  fs/xfs/xfs_mount.c |   12 ++++++++++++
> >  include/linux/fs.h |    1 +
> >  4 files changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/inode.c b/fs/inode.c
> > index 5037059..6a1626e 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -637,6 +637,7 @@ void evict_inodes(struct super_block *sb)
> >  
> >  	dispose_list(&dispose);
> >  }
> > +EXPORT_SYMBOL_GPL(evict_inodes);
> >  
> >  /**
> >   * invalidate_inodes	- attempt to free all inodes on a superblock
> > diff --git a/fs/internal.h b/fs/internal.h
> > index 9676fe1..fedfe94 100644
> > --- a/fs/internal.h
> > +++ b/fs/internal.h
> > @@ -132,7 +132,6 @@ static inline bool atime_needs_update_rcu(const struct path *path,
> >  extern void inode_io_list_del(struct inode *inode);
> >  
> >  extern long get_nr_dirty_inodes(void);
> > -extern void evict_inodes(struct super_block *);
> >  extern int invalidate_inodes(struct super_block *, bool);
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index a46c9d7..351e2c3 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -956,10 +956,22 @@ xfs_mountfs(
> >  	 * inodes.  Turn it off immediately after xfs_log_mount_finish
> >  	 * so that we don't leak the quota inodes if subsequent mount
> >  	 * activities fail.
> > +	 *
> > +	 * We let all inodes involved in redo item processing end up on
> > +	 * the LRU instead of being evicted immediately so that if we do
> > +	 * something to an unlinked inode, the irele won't cause
> > +	 * premature truncation and freeing of the inode, which results
> > +	 * in log recovery failure.  We have to evict the unreferenced
> > +	 * lru inodes after clearing MS_ACTIVE because we don't
> > +	 * otherwise clean up the lru if there's a subsequent failure in
> > +	 * xfs_mountfs, which leads to us leaking the inodes if nothing
> > +	 * else (e.g. quotacheck) references the inodes before the
> > +	 * mount failure occurs.
> >  	 */
> >  	mp->m_super->s_flags |= MS_ACTIVE;
> >  	error = xfs_log_mount_finish(mp);
> >  	mp->m_super->s_flags &= ~MS_ACTIVE;
> > +	evict_inodes(mp->m_super);
> 
> Shouldn't all this MS_ACTIVE flag and inode eviction stuff be put
> inside xfs_log_mount_finish()? Seems to me like wrapping it aroudn
> the outside is the wrong place to be putting it...

Yeah, I suppose we ought to shove everything into xfs_log_mount_finish
instead of dumping it all here...

--D

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
