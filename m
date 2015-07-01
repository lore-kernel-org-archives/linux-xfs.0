Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 266517FA1
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 17:52:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C91D88F8037
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 15:52:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UynSgGeMNvXhFwMg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 15:52:17 -0700 (PDT)
Date: Wed, 1 Jul 2015 15:52:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/14] xfs: create a per-AG btree to track reference counts
Message-ID: <20150701225213.GA10043@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625233916.4992.12808.stgit@birch.djwong.org>
	<20150701001306.GP22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701001306.GP22807@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 10:13:06AM +1000, Dave Chinner wrote:
> On Thu, Jun 25, 2015 at 04:39:16PM -0700, Darrick J. Wong wrote:
> > Create a per-AG btree to track the reference counts of physical blocks
> > to support reflink.
> 
> Few things from a quick glance...
> 
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -54,6 +54,8 @@ xfs_extlen_t
> >  xfs_prealloc_blocks(
> >  	struct xfs_mount	*mp)
> >  {
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return XFS_RL_BLOCK(mp) + 1;
> 
> Should introduce the sb version stuff as a separate patch perhaps
> with the basic infrastructure defines (see how I did the first rmap
> btree patch).

Ok.

> > @@ -1117,6 +1118,9 @@ xfs_btree_set_refs(
> >  	case XFS_BTNUM_RMAP:
> >  		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
> >  		break;
> > +	case XFS_BTNUM_RL:
> 
> Probably better to call it XFS_BTNUM_REFLINK

I was thinking about renaming the whole thing to 'refcount', i.e.
XFS_BTNUM_REFCOUNT since it /is/ a btree of reference counts.

> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 48ab2b1..a3f8661 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -43,6 +43,7 @@ union xfs_btree_key {
> >  	xfs_alloc_key_t			alloc;
> >  	struct xfs_inobt_key		inobt;
> >  	struct xfs_rmap_key		rmap;
> > +	xfs_reflink_key_t		reflink;
> 
> No new typedefs. struct xfs_reflink_key...
> 
> (only say this once, but applies many times ;)

Yeah, sorry about that.

> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 9cff517..e4954ab 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -446,9 +446,11 @@ xfs_sb_has_compat_feature(
> >  
> >  #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> > +#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflink btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> >  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> > -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
> > +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > +		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
> 
> The XFS_SB_FEAT_RO_COMPAT_REFLINK flag shoul dbe added as a separate
> patch and put last in the series so it is only enabled once
> everything is complete.

What if I define XFS_SB_FEAT_RO_COMPAT_REFLINK at the beginning but omit it
from the XFS_SB_FEAT_RO_COMPAT_ALL definition until the final patch?  That
should prohibit anyone from using the half-baked feature during a bisect.

> >  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
> >  static inline bool
> >  xfs_sb_has_ro_compat_feature(
> > @@ -522,6 +524,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
> >  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
> >  }
> >  
> > +static inline int xfs_sb_version_hasreflink(xfs_sb_t *sbp)
> 
> bool.
> 
> > @@ -1338,6 +1349,50 @@ typedef __be32 xfs_rmap_ptr_t;
> >  	 XFS_IBT_BLOCK(mp) + 1)
> >  
> >  /*
> > + * reflink Btree format definitions
> > + *
> > + */
> > +#define	XFS_RLBT_CRC_MAGIC	0x524C4233	/* 'RLB3' */
> 
> #define        XFS_RMAP_CRC_MAGIC      0x524d4233      /* 'RMB3' */
> 
> Only one bit difference in the magic numbers, which means they are
> too similar. "RFL3" might be better or maybe "R3FL"...

"RFC3" ?

> > +/*
> > + * Data record/key structure
> > + */
> > +typedef struct xfs_reflink_rec {
> > +	__be32		rr_startblock;	/* starting block number */
> > +	__be32		rr_blockcount;	/* count of blocks */
> > +	__be32		rr_nlinks;	/* number of inodes linked here */
> > +} xfs_reflink_rec_t;
> > +
> > +typedef struct xfs_reflink_key {
> > +	__be32		rr_startblock;	/* starting block number */
> > +} xfs_reflink_key_t;
> > +
> > +typedef struct xfs_reflink_rec_incore {
> > +	xfs_agblock_t	rr_startblock;	/* starting block number */
> > +	xfs_extlen_t	rr_blockcount;	/* count of free blocks */
> > +	xfs_nlink_t	rr_nlinks;	/* number of inodes linked here */
> > +} xfs_reflink_rec_incore_t;
> 
> We have being using "irec" as shorthand for "in-core record". i.e:
> struct xfs_reflink_irec.

Noted.

> (kill typedefs)
> 
> > +
> > +/*
> > + * When a block hits MAXRLCOUNT references, it becomes permanently
> > + * stuck in CoW mode, because who knows how many times it's really
> > + * referenced.
> > + */
> > +#define MAXRLCOUNT	((xfs_nlink_t)~0U)
> > +#define MAXRLEXTLEN	((xfs_extlen_t)~0U)
> 
> I'd suggest that if we hit the maximum count, we just abort the
> reflink operation.

<nod>

> > +/* btree pointer type */
> > +typedef __be32 xfs_reflink_ptr_t;
> > +
> > +#define	XFS_RL_BLOCK(mp) \
> > +	(xfs_sb_version_hasrmapbt(&((mp)->m_sb)) ? \
> > +	 XFS_RMAP_BLOCK(mp) + 1 : \
> > +	 (xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
> > +	  XFS_FIBT_BLOCK(mp) + 1 : \
> > +	  XFS_IBT_BLOCK(mp) + 1))
> 
> That's getting unwieldy. It's large enough for a function....

Ok.

> > +#ifdef REFLINK_DEBUG
> > +# define dbg_printk(f, a...)  do {printk(KERN_ERR f, ## a); } while (0)
> > +#else
> > +# define dbg_printk(f, a...)
> > +#endif
> 
> xfs_debug() is your friend.
> 
> > +#define CHECK_AG_NUMBER(mp, agno) \
> > +	do { \
> > +		ASSERT((agno) != NULLAGNUMBER); \
> > +		ASSERT((agno) < (mp)->m_sb.sb_agcount); \
> > +	} while(0);
> 
> Ugh. Used once, just open code.
> 
> > +#define CHECK_AG_EXTENT(mp, agbno, len) \
> > +	do { \
> > +		ASSERT((agbno) != NULLAGBLOCK); \
> > +		ASSERT((len) > 0); \
> > +		ASSERT((unsigned long long)(agbno) + (len) <= \
> > +				(mp)->m_sb.sb_agblocks); \
> > +	} while(0);
> 
> These are really used in places where corruption checks are
> warranted, or the extent has already been checked....
> 
> > +#define XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, have, agbno, len, nr, label) \
> > +	do { \
> > +		XFS_WANT_CORRUPTED_GOTO((mp), (have) == 1, label); \
> > +		XFS_WANT_CORRUPTED_GOTO((mp), (len) > 0, label); \
> > +		XFS_WANT_CORRUPTED_GOTO((mp), (nr) >= 2, label); \
> > +		XFS_WANT_CORRUPTED_GOTO((mp), (unsigned long long)(agbno) + \
> > +				(len) <= (mp)->m_sb.sb_agblocks, label); \
> > +	} while(0);
> 
> Unused.
> 
> > +
> > +STATIC int
> > +xfs_reflinkbt_alloc_block(
> > +	struct xfs_btree_cur	*cur,
> > +	union xfs_btree_ptr	*start,
> > +	union xfs_btree_ptr	*new,
> > +	int			*stat)
> > +{
> > +	int			error;
> > +	xfs_agblock_t		bno;
> > +
> > +	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
> > +
> > +	/* Allocate the new block from the freelist. If we can't, give up.  */
> > +	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
> > +				       &bno, 1);
> > +	if (error) {
> > +		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> > +		return error;
> > +	}
> 
> Why does the reflink btree use the free list? Why can't it use
> block allocation like the BMBT tree?

I'm confused about the intended usage of the AGFL -- the XFS FS structure doc
says that it's for growing the free space btrees and can't be used for anything
else, but the rmap btree uses it.

Originally it /did/ use xfs_alloc_vextent(), though it won't be difficult to
revert.

> 
> > +/*
> > + * Allocate a new reflink btree cursor.
> > + */
> > +struct xfs_btree_cur *			/* new reflink btree cursor */
> > +xfs_reflinkbt_init_cursor(
> > +	struct xfs_mount	*mp,		/* file system mount point */
> > +	struct xfs_trans	*tp,		/* transaction pointer */
> > +	struct xfs_buf		*agbp,		/* buffer for agf structure */
> > +	xfs_agnumber_t		agno)		/* allocation group number */
> 
> No real need for these comments on the variables. They are redundant
> as the code documents what they are just fine.

I was playing monkey-see monkey-do.  Some of the other functions had
commented args. :)

> 
> > +{
> > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > +	struct xfs_btree_cur	*cur;
> > +
> > +	CHECK_AG_NUMBER(mp, agno);
> > +	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
> > +
> > +	cur->bc_tp = tp;
> > +	cur->bc_mp = mp;
> > +	cur->bc_btnum = XFS_BTNUM_RL;
> > +	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> > +	cur->bc_ops = &xfs_reflinkbt_ops;
> > +
> > +	cur->bc_nlevels = be32_to_cpu(agf->agf_reflink_level);
> > +
> > +	cur->bc_private.a.agbp = agbp;
> > +	cur->bc_private.a.agno = agno;
> > +
> > +	if (xfs_sb_version_hascrc(&mp->m_sb))
> > +		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> 
> Can be set unconditionally.
> 
> The next set of functions normally go into a different file. i.e the
> "xfs_foo_btree.c" file contains the functions required by the
> generic btree abstraction to implement the "foo" btree format.  The
> file "xfs_foo.c" then contains the code/logic that provides the
> external foo API, manages the information inthe foo btree, and calls
> the generic btree functions to manage the btree. This logic isn't
> present in the patch, so really it shoul dbe added by the patch that
> starts implementing the reflink API....

Ok, I'll split this stuff out into smaller files.

> > +/*
> > + * Get the data from the pointed-to record.
> > + */
> > +int					/* error */
> > +xfs_reflink_get_rec(
> > +	struct xfs_btree_cur	*cur,	/* btree cursor */
> > +	xfs_agblock_t		*bno,	/* output: starting block of extent */
> > +	xfs_extlen_t		*len,	/* output: length of extent */
> > +	xfs_nlink_t		*nlink,	/* output: number of links */
> > +	int			*stat)	/* output: success/failure */
> > +{
> > +	union xfs_btree_rec	*rec;
> > +	int			error;
> > +
> > +	error = xfs_btree_get_rec(cur, &rec, stat);
> > +	if (!error && *stat == 1) {
> > +		CHECK_AG_EXTENT(cur->bc_mp,
> > +			be32_to_cpu(rec->reflink.rr_startblock),
> > +			be32_to_cpu(rec->reflink.rr_blockcount));
> > +		*bno = be32_to_cpu(rec->reflink.rr_startblock);
> > +		*len = be32_to_cpu(rec->reflink.rr_blockcount);
> > +		*nlink = be32_to_cpu(rec->reflink.rr_nlinks);
> > +	}
> > +	return error;
> 
> 	if (error || !*stat)
> 		return error;
> 	.....
> 	return 0;
> 
> > +	error = xfs_reflink_get_rec(cur, &bno, &len, &nr, &x);
> > +	if (error)
> > +		return error;
> > +	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, x == 1, error0);
> > +	error = xfs_btree_delete(cur, i);
> > +	if (error)
> > +		return error;
> > +	error = xfs_reflink_lookup_ge(cur, bno, &x);
> > +error0:
> 
> New code should use sane jump labels. e.g. "out_error" is a pretty
> standard jump label name for this...
> 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index 88efbb4..d1de74e 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -216,6 +216,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
> >  #define	XFS_INO_REF		2
> >  #define	XFS_ATTR_BTREE_REF	1
> >  #define	XFS_DQUOT_REF		1
> > +#define XFS_REFLINK_BTREE_REF	1
> 
> whitespace.
> 
> > @@ -315,6 +317,9 @@ typedef struct xfs_perag {
> >  	/* for rcu-safe freeing */
> >  	struct rcu_head	rcu_head;
> >  	int		pagb_count;	/* pagb slots in use */
> > +
> > +	/* reflink */
> > +	__uint8_t	pagf_reflink_level;
> 
> May as well just make it the same as what is on disk (i.e.
> uint32_t).
> 
> > +++ b/fs/xfs/xfs_stats.c
> > @@ -61,6 +61,7 @@ static int xfs_stat_proc_show(struct seq_file *m, void *v)
> >  		{ "ibt2",		XFSSTAT_END_IBT_V2		},
> >  		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
> >  		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
> > +		{ "rlbt2",		XFSSTAT_END_RLBT_V2		},
> 
> "reflinkbt". No need for the "2", as there is only one set of
> reflink btree stats.

Ok, thanks for the review!

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
