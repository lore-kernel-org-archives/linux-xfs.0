Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbeHUQlv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 12:41:51 -0400
Date: Tue, 21 Aug 2018 09:21:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] xfs: reflect sb features in xfs_mount
Message-ID: <20180821132139.GA15030@bfoster>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820044851.414-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 20, 2018 at 02:48:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently on-disk feature checks require decoding the superblock
> fileds and so can be non-trivial. We have almost 400 hundred
> individual feature checks in the XFS code, so this is a significant
> amount of code. To reduce runtime check overhead, pre-process all
> the version flags into a features field in the xfs_mount at mount
> time so we can convert all the feature checks to a simple flag
> check.
> 
> There is also a need to convert the dynamic feature flags to update
> the m_features field. This is required for attr, attr2 and quota
> features. New xfs_mount based wrappers are added for this.
> 
> Before:
> 
> $ size -t fs/xfs/built-in.a
>    text	   data	    bss	    dec	    hex	filename
> ....
> 1294873	 182766	   1036	1478675	 169013	(TOTALS
> 

Was some text truncated from the commit log description here? Did you
mean to include the after size as well?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |  2 +-
>  fs/xfs/libxfs/xfs_sb.c     | 61 +++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h     |  1 +
>  fs/xfs/xfs_log_recover.c   |  1 +
>  fs/xfs/xfs_mount.c         |  1 +
>  fs/xfs/xfs_mount.h         | 79 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 144 insertions(+), 1 deletion(-)
> 
...
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a21dc61ec09e..5d0438ec07dd 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5723,6 +5723,7 @@ xlog_do_recover(
>  	xfs_buf_relse(bp);
>  
>  	/* re-initialise in-core superblock and geometry structures */
> +	mp->m_features |= xfs_sb_version_to_features(sbp);

How is this a reinit if it ORs in fields? I guess I'm curious why we OR
in fields in either case as opposed to using an assignment.

>  	xfs_reinit_percpu_counters(mp);
>  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7964513c3128..92d947f17c69 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -127,6 +127,7 @@ typedef struct xfs_mount {
>  	struct mutex		m_growlock;	/* growfs mutex */
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint64_t		m_flags;	/* global mount flags */
> +	uint64_t		m_features;	/* active filesystem features */
>  	bool			m_inotbt_nores; /* no per-AG finobt resv. */
>  	int			m_ialloc_inos;	/* inodes in inode allocation */
>  	int			m_ialloc_blks;	/* blocks in inode allocation */
> @@ -195,6 +196,84 @@ typedef struct xfs_mount {
>  #endif
>  } xfs_mount_t;
>  
> +/*
> + * Flags for m_features.
> + *
> + * These are all the active features in the filesystem, regardless of how
> + * they are configured.
> + */
> +#define	XFS_FEAT_ATTR		(1ULL << 0)	/* xattrs present in fs */
> +#define	XFS_FEAT_NLINK		(1ULL << 1)	/* 32 bit link counts */
> +#define	XFS_FEAT_QUOTA		(1ULL << 2)	/* quota active */
> +#define	XFS_FEAT_ALIGN		(1ULL << 3)	/* inode alignment */
> +#define	XFS_FEAT_DALIGN		(1ULL << 4)	/* data alignment */
> +#define XFS_FEAT_LOGV2		(1ULL << 5)	/* version 2 logs */
> +#define XFS_FEAT_SECTOR		(1ULL << 6)	/* sector size > 512 bytes */
> +#define	XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
> +#define	XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
> +#define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
> +#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
> +#define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */

Hmm, none of the parent pointer stuff has been merged yet, has it? If
not, I'm sure it will be at some point, but I'd prefer not to include
code for features that technically don't exist.

Otherwise it looks like we have some inconsistent spacing/indentation.

> +#define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
> +#define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
> +#define XFS_FEAT_PQUOTINO	(1ULL << 14)	/* non-shared proj/grp quotas */
> +#define XFS_FEAT_FTYPE		(1ULL << 15)	/* inode type in dir */
> +#define XFS_FEAT_FINOBT		(1ULL << 16)	/* free inode btree */
> +#define XFS_FEAT_RMAPBT		(1ULL << 17)	/* reverse map btree */
> +#define XFS_FEAT_REFLINK	(1ULL << 18)	/* reflinked files */
> +#define XFS_FEAT_SPINODES	(1ULL << 19)	/* sparse inode chunks */
> +#define XFS_FEAT_META_UUID	(1ULL << 20)	/* metadata UUID */
> +#define XFS_FEAT_REALTIME	(1ULL << 21)	/* realtime device present */
> +
> +#define __XFS_HAS_FEAT(name, NAME) \
> +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> +{ \

I'm assuming these xfs_has_*() calls will end up replacing the current
xfs_sb_version_has*() calls throughout the code. Could we start using a
consistent function name prefix across the helpers? E.g., I think using
'xfs_feat_ ## name' here (instead of xfs_has_) would be fine, and
consistent with the other helpers.

I don't want to get into bikeshedding too much but tbh I've always found
the xfs_sb_has_* thing kind of weird where the "has" text seems
superfluous. It's just not been worth changing. It would be nice if we
could stop propagating it here and define a consistently used prefix.

> +	return mp->m_features & XFS_FEAT_ ## NAME; \
> +}
> +
> +/* Some features can be added dynamically so they need a set wrapper, too. */
> +#define __XFS_HAS_ADDFEAT(name, NAME) \
> +	__XFS_HAS_FEAT(name, NAME); \
> +static inline void xfs_feat_add_ ## name (struct xfs_mount *mp) \
> +{ \
> +	mp->m_features |= XFS_FEAT_ ## NAME; \
> +	xfs_sb_version_add ## name(&mp->m_sb); \
> +}
> +
> +/* Some features can be cleared dynamically so they need a clear wrapper */
> +#define __XFS_HAS_REMOVEFEAT(name, NAME) \
> +	__XFS_HAS_ADDFEAT(name, NAME); \
> +static inline void xfs_feat_remove_ ## name (struct xfs_mount *mp) \
> +{ \
> +	mp->m_features &= ~XFS_FEAT_ ## NAME; \
> +	xfs_sb_version_remove ## name(&mp->m_sb); \
> +}
> +

In addition to the above, we use HAS_FEAT for an underlying xfs_has_
(i.e., no "feat") helper above, yet for some reason also use the HAS for
the underlying xfs_feat_add/remove() helpers that don't use the "has"
wording. On top of that, HAS_ADD implies HAS and HAS_REMOVE implies
HAS_ADD, which isn't really clear from the naming.

I think this would all be much clearer if we defined something like the
following:

	__XFS_FEAT -> xfs_feat_*
	__XFS_FEAT_ADD -> xfs_feat_add_*
	__XFS_FEAT_REMOVE -> xfs_feat_remove_*

... for the individual helpers (i.e., no implicit dependencies) and then
just open-coded the appropriate calls in the list below. Alternatively,
we could create another set of macros like
XFS_FEAT_[FIXED|ADDONLY|ADDRM]() for the particular combinations that we
happen to use today. Either way would make it self-evident from the list
itself what helpers are defined without having to dig into all of the
macros.

Brian

> +
> +__XFS_HAS_ADDFEAT(attr, ATTR)
> +__XFS_HAS_FEAT(nlink, NLINK)
> +__XFS_HAS_ADDFEAT(quota, QUOTA)
> +__XFS_HAS_FEAT(align, ALIGN)
> +__XFS_HAS_FEAT(dalign, DALIGN)
> +__XFS_HAS_FEAT(logv2, LOGV2)
> +__XFS_HAS_FEAT(sector, SECTOR)
> +__XFS_HAS_FEAT(extflg, EXTFLG)
> +__XFS_HAS_FEAT(asciici, ASCIICI)
> +__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
> +__XFS_HAS_REMOVEFEAT(attr2, ATTR2)
> +__XFS_HAS_FEAT(parent, PARENT)
> +__XFS_HAS_ADDFEAT(projid32, PROJID32)
> +__XFS_HAS_FEAT(crc, CRC)
> +__XFS_HAS_FEAT(pquotino, PQUOTINO)
> +__XFS_HAS_FEAT(ftype, FTYPE)
> +__XFS_HAS_FEAT(finobt, FINOBT)
> +__XFS_HAS_FEAT(rmapbt, RMAPBT)
> +__XFS_HAS_FEAT(reflink, REFLINK)
> +__XFS_HAS_FEAT(sparseinodes, SPINODES)
> +__XFS_HAS_FEAT(metauuid, META_UUID)
> +__XFS_HAS_FEAT(realtime, REALTIME)
> +
> +
>  /*
>   * Flags for m_flags.
>   */
> -- 
> 2.17.0
> 
