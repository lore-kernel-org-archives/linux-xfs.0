Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37258 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDBNbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 09:31:10 -0400
Date: Tue, 2 Apr 2019 06:30:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] xfs: track metadata health levels
Message-ID: <20190402133059.GB5147@magnolia>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413861577.4966.12311071928325570886.stgit@magnolia>
 <20190402132237.GC2899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402132237.GC2899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 02, 2019 at 09:22:40AM -0400, Brian Foster wrote:
> On Mon, Apr 01, 2019 at 10:10:15AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add the necessary in-core metadata fields to keep track of which parts
> > of the filesystem have been observed to be unhealthy, and print a
> > warning at unmount time if we have unfixed problems.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile            |    1 
> >  fs/xfs/libxfs/xfs_health.h |  201 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_health.c        |  192 ++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.h         |    7 ++
> >  fs/xfs/xfs_mount.c         |    1 
> >  fs/xfs/xfs_mount.h         |   23 +++++
> >  fs/xfs/xfs_trace.h         |   73 ++++++++++++++++
> >  7 files changed, 498 insertions(+)
> >  create mode 100644 fs/xfs/libxfs/xfs_health.h
> >  create mode 100644 fs/xfs/xfs_health.c
> > 
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> > new file mode 100644
> > index 000000000000..0d51bd2689ea
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_health.h
> > @@ -0,0 +1,201 @@
> ...
> > +/* Secondary state related to (but not primary evidence of) health problems. */
> > +#define XFS_HEALTH_FS_SECONDARY	(0)
> > +#define XFS_HEALTH_RT_SECONDARY	(0)
> > +#define XFS_HEALTH_AG_SECONDARY	(0)
> > +#define XFS_HEALTH_INO_SECONDARY (0)
> > +
> > +/* Evidence of health problems elsewhere. */
> > +#define XFS_HEALTH_FS_INDIRECT	(0)
> > +#define XFS_HEALTH_RT_INDIRECT	(0)
> > +#define XFS_HEALTH_AG_INDIRECT	(0)
> > +#define XFS_HEALTH_INO_INDIRECT	(0)
> > +
> 
> I'm a little confused by the secondary tracking logic in general. Some
> of these masks are cleared in the associated helpers below (i.e., when
> the fs is made healthy and all primary bits are cleared), but there are
> no secondary or indirect bits in use. On a quick look ahead, these are
> still zeroed as of the end of this series as well. Can we defer this
> secondary tracking logic until there's a demonstrated use? Otherwise the
> rest looks reasonable to me.

Doh, I forgot that I don't start using the indirect flags until much
later (specifically, repair part 2) so all this can fall out until then.
The future use for indirect flags is so that the AG health flags can
remember if we inactivated an inode that had primary health flags set.

But, we don't need that part yet so I think all that can drop out until
that later series.

--D

> Brian
> 
> > +/* All health masks. */
> > +#define XFS_HEALTH_FS_ALL	(XFS_HEALTH_FS_PRIMARY | \
> > +				 XFS_HEALTH_FS_SECONDARY | \
> > +				 XFS_HEALTH_FS_INDIRECT)
> > +
> > +#define XFS_HEALTH_RT_ALL	(XFS_HEALTH_RT_PRIMARY | \
> > +				 XFS_HEALTH_RT_SECONDARY | \
> > +				 XFS_HEALTH_RT_INDIRECT)
> > +
> > +#define XFS_HEALTH_AG_ALL	(XFS_HEALTH_AG_PRIMARY | \
> > +				 XFS_HEALTH_AG_SECONDARY | \
> > +				 XFS_HEALTH_AG_INDIRECT)
> > +
> > +#define XFS_HEALTH_INO_ALL	(XFS_HEALTH_INO_PRIMARY | \
> > +				 XFS_HEALTH_INO_SECONDARY | \
> > +				 XFS_HEALTH_INO_INDIRECT)
> > +
> > +/* These functions must be provided by the xfs implementation. */
> > +
> > +void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
> > +void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> > +unsigned int xfs_fs_measure_sickness(struct xfs_mount *mp);
> > +
> > +void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
> > +void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
> > +unsigned int xfs_rt_measure_sickness(struct xfs_mount *mp);
> > +
> > +void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
> > +void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
> > +unsigned int xfs_ag_measure_sickness(struct xfs_perag *pag);
> > +
> > +void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
> > +void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
> > +unsigned int xfs_inode_measure_sickness(struct xfs_inode *ip);
> > +
> > +/* Now some helpers. */
> > +
> > +static inline bool
> > +xfs_fs_is_sick(struct xfs_mount *mp, unsigned int mask)
> > +{
> > +	return (xfs_fs_measure_sickness(mp) & mask) != 0;
> > +}
> > +
> > +static inline bool
> > +xfs_rt_is_sick(struct xfs_mount *mp, unsigned int mask)
> > +{
> > +	return (xfs_rt_measure_sickness(mp) & mask) != 0;
> > +}
> > +
> > +static inline bool
> > +xfs_ag_is_sick(struct xfs_perag *pag, unsigned int mask)
> > +{
> > +	return (xfs_ag_measure_sickness(pag) & mask) != 0;
> > +}
> > +
> > +static inline bool
> > +xfs_inode_is_sick(struct xfs_inode *ip, unsigned int mask)
> > +{
> > +	return (xfs_inode_measure_sickness(ip) & mask) != 0;
> > +}
> > +
> > +static inline bool
> > +xfs_fs_healthy(struct xfs_mount *mp)
> > +{
> > +	return xfs_fs_measure_sickness(mp) == 0;
> > +}
> > +
> > +static inline bool
> > +xfs_rt_healthy(struct xfs_mount *mp)
> > +{
> > +	return xfs_rt_measure_sickness(mp) == 0;
> > +}
> > +
> > +static inline bool
> > +xfs_ag_healthy(struct xfs_perag *pag)
> > +{
> > +	return xfs_ag_measure_sickness(pag) == 0;
> > +}
> > +
> > +static inline bool
> > +xfs_inode_healthy(struct xfs_inode *ip)
> > +{
> > +	return xfs_inode_measure_sickness(ip) == 0;
> > +}
> > +
> > +#endif	/* __XFS_HEALTH_H__ */
> > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > new file mode 100644
> > index 000000000000..e9d6859f7501
> > --- /dev/null
> > +++ b/fs/xfs/xfs_health.c
> > @@ -0,0 +1,192 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_bit.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_health.h"
> > +
> > +/* Mark unhealthy per-fs metadata. */
> > +void
> > +xfs_fs_mark_sick(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_FS_ALL));
> > +	trace_xfs_fs_mark_sick(mp, mask);
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sick |= mask;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Mark a per-fs metadata healed. */
> > +void
> > +xfs_fs_mark_healthy(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_FS_ALL));
> > +	trace_xfs_fs_mark_healthy(mp, mask);
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sick &= ~mask;
> > +	if (!(mp->m_sick & XFS_HEALTH_FS_PRIMARY))
> > +		mp->m_sick &= ~XFS_HEALTH_FS_SECONDARY;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Sample which per-fs metadata are unhealthy. */
> > +unsigned int
> > +xfs_fs_measure_sickness(
> > +	struct xfs_mount	*mp)
> > +{
> > +	unsigned int		ret;
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	ret = mp->m_sick;
> > +	spin_unlock(&mp->m_sb_lock);
> > +	return ret;
> > +}
> > +
> > +/* Mark unhealthy realtime metadata. */
> > +void
> > +xfs_rt_mark_sick(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_RT_ALL));
> > +	trace_xfs_rt_mark_sick(mp, mask);
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_rt_sick |= mask;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Mark a realtime metadata healed. */
> > +void
> > +xfs_rt_mark_healthy(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_RT_ALL));
> > +	trace_xfs_rt_mark_healthy(mp, mask);
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	mp->m_rt_sick &= ~mask;
> > +	if (!(mp->m_rt_sick & XFS_HEALTH_RT_PRIMARY))
> > +		mp->m_rt_sick &= ~XFS_HEALTH_RT_SECONDARY;
> > +	spin_unlock(&mp->m_sb_lock);
> > +}
> > +
> > +/* Sample which realtime metadata are unhealthy. */
> > +unsigned int
> > +xfs_rt_measure_sickness(
> > +	struct xfs_mount	*mp)
> > +{
> > +	unsigned int		ret;
> > +
> > +	spin_lock(&mp->m_sb_lock);
> > +	ret = mp->m_rt_sick;
> > +	spin_unlock(&mp->m_sb_lock);
> > +	return ret;
> > +}
> > +
> > +/* Mark unhealthy per-ag metadata. */
> > +void
> > +xfs_ag_mark_sick(
> > +	struct xfs_perag	*pag,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_AG_ALL));
> > +	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
> > +
> > +	spin_lock(&pag->pag_state_lock);
> > +	pag->pag_sick |= mask;
> > +	spin_unlock(&pag->pag_state_lock);
> > +}
> > +
> > +/* Mark per-ag metadata ok. */
> > +void
> > +xfs_ag_mark_healthy(
> > +	struct xfs_perag	*pag,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_AG_ALL));
> > +	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
> > +
> > +	spin_lock(&pag->pag_state_lock);
> > +	pag->pag_sick &= ~mask;
> > +	if (!(pag->pag_sick & XFS_HEALTH_AG_PRIMARY))
> > +		pag->pag_sick &= ~XFS_HEALTH_AG_SECONDARY;
> > +	spin_unlock(&pag->pag_state_lock);
> > +}
> > +
> > +/* Sample which per-ag metadata are unhealthy. */
> > +unsigned int
> > +xfs_ag_measure_sickness(
> > +	struct xfs_perag	*pag)
> > +{
> > +	unsigned int		ret;
> > +
> > +	spin_lock(&pag->pag_state_lock);
> > +	ret = pag->pag_sick;
> > +	spin_unlock(&pag->pag_state_lock);
> > +	return ret;
> > +}
> > +
> > +/* Mark the unhealthy parts of an inode. */
> > +void
> > +xfs_inode_mark_sick(
> > +	struct xfs_inode	*ip,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_INO_ALL));
> > +	trace_xfs_inode_mark_sick(ip, mask);
> > +
> > +	spin_lock(&ip->i_flags_lock);
> > +	ip->i_sick |= mask;
> > +	spin_unlock(&ip->i_flags_lock);
> > +}
> > +
> > +/* Mark parts of an inode healed. */
> > +void
> > +xfs_inode_mark_healthy(
> > +	struct xfs_inode	*ip,
> > +	unsigned int		mask)
> > +{
> > +	ASSERT(!(mask & ~XFS_HEALTH_INO_ALL));
> > +	trace_xfs_inode_mark_healthy(ip, mask);
> > +
> > +	spin_lock(&ip->i_flags_lock);
> > +	ip->i_sick &= ~mask;
> > +	if (!(ip->i_sick & XFS_HEALTH_INO_PRIMARY))
> > +		ip->i_sick &= ~XFS_HEALTH_INO_SECONDARY;
> > +	spin_unlock(&ip->i_flags_lock);
> > +}
> > +
> > +/* Sample which parts of an inode are unhealthy. */
> > +unsigned int
> > +xfs_inode_measure_sickness(
> > +	struct xfs_inode	*ip)
> > +{
> > +	unsigned int		ret;
> > +
> > +	spin_lock(&ip->i_flags_lock);
> > +	ret = ip->i_sick;
> > +	spin_unlock(&ip->i_flags_lock);
> > +	return ret;
> > +}
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 88239c2dd824..877acdd5f026 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -45,6 +45,13 @@ typedef struct xfs_inode {
> >  	mrlock_t		i_lock;		/* inode lock */
> >  	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
> >  	atomic_t		i_pincount;	/* inode pin count */
> > +
> > +	/*
> > +	 * Bitset noting which parts of an inode are not healthy.
> > +	 * Callers must hold i_flags_lock before accessing this field.
> > +	 */
> > +	unsigned int		i_sick;
> > +
> >  	spinlock_t		i_flags_lock;	/* inode i_flags lock */
> >  	/* Miscellaneous state. */
> >  	unsigned long		i_flags;	/* see defined flags below */
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 950752e5ec2c..fc1f24dd0386 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -231,6 +231,7 @@ xfs_initialize_perag(
> >  		error = xfs_iunlink_init(pag);
> >  		if (error)
> >  			goto out_hash_destroy;
> > +		spin_lock_init(&pag->pag_state_lock);
> >  	}
> >  
> >  	index = xfs_set_inode_alloc(mp, agcount);
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 15dc02964113..63bbafb01eb5 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -60,6 +60,13 @@ struct xfs_error_cfg {
> >  typedef struct xfs_mount {
> >  	struct super_block	*m_super;
> >  	xfs_tid_t		m_tid;		/* next unused tid for fs */
> > +
> > +	/*
> > +	 * Bitset of unhealthy per-fs metadata.
> > +	 * Callers must hold m_sb_lock to access this field.
> > +	 */
> > +	unsigned int		m_sick;
> > +
> >  	struct xfs_ail		*m_ail;		/* fs active log item list */
> >  
> >  	struct xfs_sb		m_sb;		/* copy of fs superblock */
> > @@ -71,6 +78,11 @@ typedef struct xfs_mount {
> >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> >  	char			*m_fsname;	/* filesystem name */
> >  	int			m_fsname_len;	/* strlen of fs name */
> > +	/*
> > +	 * Bitset of unhealthy rt volume metadata.
> > +	 * Callers must hold m_sb_lock to access this field.
> > +	 */
> > +	unsigned int		m_rt_sick;
> >  	char			*m_rtname;	/* realtime device name */
> >  	char			*m_logname;	/* external log device name */
> >  	int			m_bsize;	/* fs logical block size */
> > @@ -389,6 +401,17 @@ typedef struct xfs_perag {
> >  	 * or have some other means to control concurrency.
> >  	 */
> >  	struct rhashtable	pagi_unlinked_hash;
> > +
> > +	/* Spinlock to protect in-core per-ag state */
> > +	spinlock_t	pag_state_lock;
> > +
> > +	/*
> > +	 * Bitset of unhealthy AG metadata.
> > +	 *
> > +	 * Callers should hold pag_state_lock and the relevant AG header buffer
> > +	 * lock before accessing this field.
> > +	 */
> > +	unsigned int	pag_sick;
> >  } xfs_perag_t;
> >  
> >  static inline struct xfs_ag_resv *
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 47fb07d86efd..f079841c7af6 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -3440,6 +3440,79 @@ DEFINE_AGINODE_EVENT(xfs_iunlink);
> >  DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
> >  DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
> >  
> > +DECLARE_EVENT_CLASS(xfs_fs_corrupt_class,
> > +	TP_PROTO(struct xfs_mount *mp, unsigned int flags),
> > +	TP_ARGS(mp, flags),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(unsigned int, flags)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->flags = flags;
> > +	),
> > +	TP_printk("dev %d:%d flags 0x%x",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->flags)
> > +);
> > +#define DEFINE_FS_CORRUPT_EVENT(name)	\
> > +DEFINE_EVENT(xfs_fs_corrupt_class, name,	\
> > +	TP_PROTO(struct xfs_mount *mp, unsigned int flags), \
> > +	TP_ARGS(mp, flags))
> > +DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
> > +DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
> > +DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
> > +DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
> > +
> > +DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
> > +	TP_ARGS(mp, agno, flags),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(unsigned int, flags)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->flags = flags;
> > +	),
> > +	TP_printk("dev %d:%d agno %u flags 0x%x",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->agno, __entry->flags)
> > +);
> > +#define DEFINE_AG_CORRUPT_EVENT(name)	\
> > +DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
> > +		 unsigned int flags), \
> > +	TP_ARGS(mp, agno, flags))
> > +DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
> > +DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
> > +
> > +DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
> > +	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
> > +	TP_ARGS(ip, flags),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_ino_t, ino)
> > +		__field(unsigned int, flags)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = ip->i_mount->m_super->s_dev;
> > +		__entry->ino = ip->i_ino;
> > +		__entry->flags = flags;
> > +	),
> > +	TP_printk("dev %d:%d ino 0x%llx flags 0x%x",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->ino, __entry->flags)
> > +);
> > +#define DEFINE_INODE_CORRUPT_EVENT(name)	\
> > +DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
> > +	TP_PROTO(struct xfs_inode *ip, unsigned int flags), \
> > +	TP_ARGS(ip, flags))
> > +DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
> > +DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
> > +
> >  #endif /* _TRACE_XFS_H */
> >  
> >  #undef TRACE_INCLUDE_PATH
> > 
