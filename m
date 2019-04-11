Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfDKSbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 14:31:25 -0400
Date: Thu, 11 Apr 2019 11:31:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/8] xfs: track metadata health status
Message-ID: <20190411183118.GG1019523@magnolia>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494713235.1090518.11696420703305243139.stgit@magnolia>
 <20190411122900.GB2888@bfoster>
 <20190411151845.GD1019523@magnolia>
 <20190411160529.GJ2888@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411160529.GJ2888@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 11, 2019 at 12:05:30PM -0400, Brian Foster wrote:
> On Thu, Apr 11, 2019 at 08:18:45AM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 11, 2019 at 08:29:04AM -0400, Brian Foster wrote:
> > > On Wed, Apr 10, 2019 at 06:45:32PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add the necessary in-core metadata fields to keep track of which parts
> > > > of the filesystem have been observed and which parts were observed to be
> > > > unhealthy, and print a warning at unmount time if we have unfixed
> > > > problems.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/Makefile            |    1 
> > > >  fs/xfs/libxfs/xfs_health.h |  175 ++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_health.c        |  192 ++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_icache.c        |    8 ++
> > > >  fs/xfs/xfs_inode.h         |    8 ++
> > > >  fs/xfs/xfs_mount.c         |    1 
> > > >  fs/xfs/xfs_mount.h         |   23 +++++
> > > >  fs/xfs/xfs_trace.h         |   73 +++++++++++++++++
> > > >  8 files changed, 481 insertions(+)
> > > >  create mode 100644 fs/xfs/libxfs/xfs_health.h
> > > >  create mode 100644 fs/xfs/xfs_health.c
> > > > 
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index e70e7db29026..885decab4735 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -73,6 +73,8 @@ xfs_inode_alloc(
> > > >  	INIT_WORK(&ip->i_iodone_work, xfs_end_io);
> > > >  	INIT_LIST_HEAD(&ip->i_iodone_list);
> > > >  	spin_lock_init(&ip->i_iodone_lock);
> > > > +	ip->i_sick = 0;
> > > > +	ip->i_checked = 0;
> > > >  
> > > >  	return ip;
> > > >  }
> > > > @@ -133,6 +135,8 @@ xfs_inode_free(
> > > >  	spin_lock(&ip->i_flags_lock);
> > > >  	ip->i_flags = XFS_IRECLAIM;
> > > >  	ip->i_ino = 0;
> > > > +	ip->i_sick = 0;
> > > > +	ip->i_checked = 0;
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  
> > > 
> > > FWIW, I'm not totally clear on what the i_checked mask is for yet.
> > 
> > Bleh, I forgot to update the introductory comment. :(
> > 
> > /*
> >  * <introductory stuff that's in xfs_health.h now>
> >  *
> >  * Each health tracking group uses a pair of fields for reporting.  The
> >  * "checked" field tell us if a given piece of metadata has ever been examined,
> >  * and the "sick" field tells us if that piece was found to need repairs.
> >  * Therefore we can conclude that for a given mask:
> >  *
> >  *  - checked && sick  => metadata needs repair
> >  *  - checked && !sick => metadata is ok
> >  *  - !checked         => has not been examined since mount
> >  */
> > 
> > In any case, I worked out the need for this new checked field when I was
> > writing the manual pages describing how all this worked:
> > 
> > https://djwong.org/docs/man/ioctl_xfs_fsop_geometry.2.html
> > https://djwong.org/docs/man/ioctl_xfs_ag_geometry.2.html
> > https://djwong.org/docs/man/ioctl_xfs_fsbulkstat.2.html
> > 
> > (See the part "The fields sick and checked indicate...")
> > 
> > @checked is a mask of all the metadata types that scrub has looked at,
> > whether or not the metadata was any good.  @sick is the mask of all the
> > metadata that scrub thought was bad, so we now can report to userspace
> > if something's good, bad, or unchecked.
> > 
> 
> Ok, thanks.
> 
> > > That aside, is it necessary to reset these fields in the free/reclaim
> > > paths?  I wonder if it's sufficient to zero them on alloc and the
> > > cache hit path just below..?
> > 
> > I think it's not strictly needed, but once we've broken the association
> > between a (struct xfs_inode *) buffer and a particular inode number, we
> > ought to zero out the health data just in case that buffer resurfaces
> > during the rcu grace period.
> > 
> 
> I thought freeing the inode was imminent at that point. We set
> XFS_IRECLAIM then call into the RCU mechanism to free the memory. If
> lookup finds the inode, we retry on XFS_IRECLAIM or attempt to reuse on
> XFS_IRECLAIMABLE (which is covered by the fields being reset in
> iget_cache_hit()).

<nod> The i_ino change effectively prevents anyone else from seeing
stale sick/checked contents, so I might as well drop this for v3.

--D

> Brian
> 
> > --D
> > 
> > > Otherwise looks fine:
> > > 
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > 
> > > >  	__xfs_inode_free(ip);
> > > > @@ -449,6 +453,8 @@ xfs_iget_cache_hit(
> > > >  		ip->i_flags |= XFS_INEW;
> > > >  		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
> > > >  		inode->i_state = I_NEW;
> > > > +		ip->i_sick = 0;
> > > > +		ip->i_checked = 0;
> > > >  
> > > >  		ASSERT(!rwsem_is_locked(&inode->i_rwsem));
> > > >  		init_rwsem(&inode->i_rwsem);
> > > > @@ -1177,6 +1183,8 @@ xfs_reclaim_inode(
> > > >  	spin_lock(&ip->i_flags_lock);
> > > >  	ip->i_flags = XFS_IRECLAIM;
> > > >  	ip->i_ino = 0;
> > > > +	ip->i_sick = 0;
> > > > +	ip->i_checked = 0;
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  
> > > >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > index 88239c2dd824..494e47ef42cb 100644
> > > > --- a/fs/xfs/xfs_inode.h
> > > > +++ b/fs/xfs/xfs_inode.h
> > > > @@ -45,6 +45,14 @@ typedef struct xfs_inode {
> > > >  	mrlock_t		i_lock;		/* inode lock */
> > > >  	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
> > > >  	atomic_t		i_pincount;	/* inode pin count */
> > > > +
> > > > +	/*
> > > > +	 * Bitsets of inode metadata that have been checked and/or are sick.
> > > > +	 * Callers must hold i_flags_lock before accessing this field.
> > > > +	 */
> > > > +	uint16_t		i_checked;
> > > > +	uint16_t		i_sick;
> > > > +
> > > >  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
> > > >  	/* Miscellaneous state. */
> > > >  	unsigned long		i_flags;	/* see defined flags below */
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index fd63b0b1307c..6581381c12be 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> > > > @@ -231,6 +231,7 @@ xfs_initialize_perag(
> > > >  		error = xfs_iunlink_init(pag);
> > > >  		if (error)
> > > >  			goto out_hash_destroy;
> > > > +		spin_lock_init(&pag->pag_state_lock);
> > > >  	}
> > > >  
> > > >  	index = xfs_set_inode_alloc(mp, agcount);
> > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > index 110f927cf943..cf7facc36a5f 100644
> > > > --- a/fs/xfs/xfs_mount.h
> > > > +++ b/fs/xfs/xfs_mount.h
> > > > @@ -60,6 +60,20 @@ struct xfs_error_cfg {
> > > >  typedef struct xfs_mount {
> > > >  	struct super_block	*m_super;
> > > >  	xfs_tid_t		m_tid;		/* next unused tid for fs */
> > > > +
> > > > +	/*
> > > > +	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> > > > +	 * Callers must hold m_sb_lock to access these two fields.
> > > > +	 */
> > > > +	uint8_t			m_fs_checked;
> > > > +	uint8_t			m_fs_sick;
> > > > +	/*
> > > > +	 * Bitsets of rt metadata that have been checked and/or are sick.
> > > > +	 * Callers must hold m_sb_lock to access this field.
> > > > +	 */
> > > > +	uint8_t			m_rt_checked;
> > > > +	uint8_t			m_rt_sick;
> > > > +
> > > >  	struct xfs_ail		*m_ail;		/* fs active log item list */
> > > >  
> > > >  	struct xfs_sb		m_sb;		/* copy of fs superblock */
> > > > @@ -369,6 +383,15 @@ typedef struct xfs_perag {
> > > >  	xfs_agino_t	pagl_pagino;
> > > >  	xfs_agino_t	pagl_leftrec;
> > > >  	xfs_agino_t	pagl_rightrec;
> > > > +
> > > > +	/*
> > > > +	 * Bitsets of per-ag metadata that have been checked and/or are sick.
> > > > +	 * Callers should hold pag_state_lock before accessing this field.
> > > > +	 */
> > > > +	uint16_t	pag_checked;
> > > > +	uint16_t	pag_sick;
> > > > +	spinlock_t	pag_state_lock;
> > > > +
> > > >  	spinlock_t	pagb_lock;	/* lock for pagb_tree */
> > > >  	struct rb_root	pagb_tree;	/* ordered tree of busy extents */
> > > >  	unsigned int	pagb_gen;	/* generation count for pagb_tree */
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index 47fb07d86efd..f079841c7af6 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -3440,6 +3440,79 @@ DEFINE_AGINODE_EVENT(xfs_iunlink);
> > > >  DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
> > > >  DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
> > > >  
> > > > +DECLARE_EVENT_CLASS(xfs_fs_corrupt_class,
> > > > +	TP_PROTO(struct xfs_mount *mp, unsigned int flags),
> > > > +	TP_ARGS(mp, flags),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(unsigned int, flags)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->flags = flags;
> > > > +	),
> > > > +	TP_printk("dev %d:%d flags 0x%x",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __entry->flags)
> > > > +);
> > > > +#define DEFINE_FS_CORRUPT_EVENT(name)	\
> > > > +DEFINE_EVENT(xfs_fs_corrupt_class, name,	\
> > > > +	TP_PROTO(struct xfs_mount *mp, unsigned int flags), \
> > > > +	TP_ARGS(mp, flags))
> > > > +DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
> > > > +DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
> > > > +DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
> > > > +DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
> > > > +
> > > > +DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
> > > > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
> > > > +	TP_ARGS(mp, agno, flags),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_agnumber_t, agno)
> > > > +		__field(unsigned int, flags)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = mp->m_super->s_dev;
> > > > +		__entry->agno = agno;
> > > > +		__entry->flags = flags;
> > > > +	),
> > > > +	TP_printk("dev %d:%d agno %u flags 0x%x",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __entry->agno, __entry->flags)
> > > > +);
> > > > +#define DEFINE_AG_CORRUPT_EVENT(name)	\
> > > > +DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
> > > > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
> > > > +		 unsigned int flags), \
> > > > +	TP_ARGS(mp, agno, flags))
> > > > +DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
> > > > +DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
> > > > +
> > > > +DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
> > > > +	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
> > > > +	TP_ARGS(ip, flags),
> > > > +	TP_STRUCT__entry(
> > > > +		__field(dev_t, dev)
> > > > +		__field(xfs_ino_t, ino)
> > > > +		__field(unsigned int, flags)
> > > > +	),
> > > > +	TP_fast_assign(
> > > > +		__entry->dev = ip->i_mount->m_super->s_dev;
> > > > +		__entry->ino = ip->i_ino;
> > > > +		__entry->flags = flags;
> > > > +	),
> > > > +	TP_printk("dev %d:%d ino 0x%llx flags 0x%x",
> > > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > > +		  __entry->ino, __entry->flags)
> > > > +);
> > > > +#define DEFINE_INODE_CORRUPT_EVENT(name)	\
> > > > +DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
> > > > +	TP_PROTO(struct xfs_inode *ip, unsigned int flags), \
> > > > +	TP_ARGS(ip, flags))
> > > > +DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
> > > > +DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
> > > > +
> > > >  #endif /* _TRACE_XFS_H */
> > > >  
> > > >  #undef TRACE_INCLUDE_PATH
> > > > 
