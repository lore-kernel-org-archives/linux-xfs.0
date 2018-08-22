Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728184AbeHVPmj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Aug 2018 11:42:39 -0400
Date: Wed, 22 Aug 2018 08:17:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 01/10] xfs: reflect sb features in xfs_mount
Message-ID: <20180822121755.GB26084@bfoster>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-2-david@fromorbit.com>
 <20180821132139.GA15030@bfoster>
 <20180821233133.GK31495@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821233133.GK31495@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 22, 2018 at 09:31:33AM +1000, Dave Chinner wrote:
> On Tue, Aug 21, 2018 at 09:21:40AM -0400, Brian Foster wrote:
> > On Mon, Aug 20, 2018 at 02:48:42PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Currently on-disk feature checks require decoding the superblock
> > > fileds and so can be non-trivial. We have almost 400 hundred
> > > individual feature checks in the XFS code, so this is a significant
> > > amount of code. To reduce runtime check overhead, pre-process all
> > > the version flags into a features field in the xfs_mount at mount
> > > time so we can convert all the feature checks to a simple flag
> > > check.
> > > 
> > > There is also a need to convert the dynamic feature flags to update
> > > the m_features field. This is required for attr, attr2 and quota
> > > features. New xfs_mount based wrappers are added for this.
> > > 
> > > Before:
> > > 
> > > $ size -t fs/xfs/built-in.a
> > >    text	   data	    bss	    dec	    hex	filename
> > > ....
> > > 1294873	 182766	   1036	1478675	 169013	(TOTALS
> > > 
> > 
> > Was some text truncated from the commit log description here? Did you
> > mean to include the after size as well?
> 
> Yeah, I thought I did update that. Maybe forgot to refresh the
> header once I did. The before and after are:
> 
> 	text	   data	    bss	    dec	    hex	filename
> before	1326155	 189006	   1036	1516197	 1722a5	(TOTALS)
> after	1322929	 189006	   1036	1512971	 17160b	(TOTALS)
> 

That's a much larger delta than what I saw when I checked out of
curiousity, but I just ran against this first patch. It looks like this
delta is before/after the whole series. It might be good to qualify that
in the commit log (i.e., "after the old xfs_sb_version_* wrappers are
removed") just because the series context isn't always clear in the
broader git log history.

> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h |  2 +-
> > >  fs/xfs/libxfs/xfs_sb.c     | 61 +++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_sb.h     |  1 +
> > >  fs/xfs/xfs_log_recover.c   |  1 +
> > >  fs/xfs/xfs_mount.c         |  1 +
> > >  fs/xfs/xfs_mount.h         | 79 ++++++++++++++++++++++++++++++++++++++
> > >  6 files changed, 144 insertions(+), 1 deletion(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index a21dc61ec09e..5d0438ec07dd 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -5723,6 +5723,7 @@ xlog_do_recover(
> > >  	xfs_buf_relse(bp);
> > >  
> > >  	/* re-initialise in-core superblock and geometry structures */
> > > +	mp->m_features |= xfs_sb_version_to_features(sbp);
> > 
> > How is this a reinit if it ORs in fields?
> 
> The only feature bit that can be removed by log recovery is the
> attr2 feature bit which means the last mount was mounted with
> "noattr2". So apart from that feature bit, ORing in the new
> superblock feature mask works just fine.
> 

To be clear.. that's because attr2 is the only feature that can be
currently unset at runtime, right?

> As it is, for v5 attr2 can't be turned off, so it's just fine for
> v5 filesystems. For v4 the old code would set XFS_MOUNT_ATTR2 if the
> sb feature bit was set /prior/ to log recovery being run. Hence if
> log recovery removed the feature bit, the very next attr creation
> will turn it straight back on.
> 
> The only way to not have attr2 enabled in this case is to use the
> noattr2 mount option, and the new code has exactly the same
> behaviour - the attr2 superblock bit and the feature flag will get
> cleared after log recovery if the noattr2 mount option is set.
> 
> Also worth noting is that if there's a sb_bad_features2
> interatction, it will re-add the feature bit because it just ORs the
> two fields together.
> 
> IOWs, the behaviour of this patch is roughly the same as the
> existing code when it comes to the attr2 flag being removed when the
> superblock is recovered as well as when there is a features2
> mismatch.
> 

Ok, but this all sounds like a happy coincidence that depends on the
semantics of attr2. IOW, the behavior of attr2 may ultimately be the
same (which I haven't fully grokked), but unless I'm missing something
more fundamental the logic in this patch still seems slightly dynamic
feature challenged in this regard.

Mount a filesystem with some feature enabled, disable it and crash with
the superblock change in the dirty log. Mount again, enable said feature
based on sb, log recovery updates sb, feature remains inconsistently
enabled due to not being cleared by the post-recovery feature init.
Unless I'm missing something, this is handled correctly by the existing
mechanism simply because each feature check refers to the superblock.

> I think there's more work needed on the attr2 feature side of
> things, as noted in the cover description. In addition to the
> unpredictable behaviour via log recovery, I don't see a reason for
> noattr2 existing these days. It doesn't get rid of existing attr2
> format inodes on disk - it just stops new ones from being created.
> We've used attr2 for more than 10 years now without it being an
> issue, so there's no reason for needing to turn it off anymore. I
> think we should deprecate the option and remove it.
> 
> > I guess I'm curious why we OR
> > in fields in either case as opposed to using an assignment.
> 
> Because mount option features are already set in m_features, so we
> can't just overwrite it with just the superblock features.
> 

That doesn't appear to be the case as of this patch. If it's a factor
later in the series, we should tweak it then where the intent is clear.

This also doesn't strike me as a technically difficult problem to
address. We just need to filter out the set of superblock based features
one way or another. If you wanted to simplify it further, we could just
have the sb -> features function update ->m_features itself in a safe
manner (i.e., the subset of features it is responsible for) and then the
caller context doesn't really have to be concerned with such details.

> > 
> > >  	xfs_reinit_percpu_counters(mp);
> > >  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
> > >  	if (error) {
> > ...
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 7964513c3128..92d947f17c69 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -127,6 +127,7 @@ typedef struct xfs_mount {
> > >  	struct mutex		m_growlock;	/* growfs mutex */
> > >  	int			m_fixedfsid[2];	/* unchanged for life of FS */
> > >  	uint64_t		m_flags;	/* global mount flags */
> > > +	uint64_t		m_features;	/* active filesystem features */
> > >  	bool			m_inotbt_nores; /* no per-AG finobt resv. */
> > >  	int			m_ialloc_inos;	/* inodes in inode allocation */
> > >  	int			m_ialloc_blks;	/* blocks in inode allocation */
> > > @@ -195,6 +196,84 @@ typedef struct xfs_mount {
> > >  #endif
> > >  } xfs_mount_t;
> > >  
> > > +/*
> > > + * Flags for m_features.
> > > + *
> > > + * These are all the active features in the filesystem, regardless of how
> > > + * they are configured.

Given the point above around mount options, I think the comment above
would be more helpful if it said something like:

"These are all the active features in the filesystem. Some are
configured based on superblock version, others are based on mount
options."

> > > + */
> > > +#define	XFS_FEAT_ATTR		(1ULL << 0)	/* xattrs present in fs */
> > > +#define	XFS_FEAT_NLINK		(1ULL << 1)	/* 32 bit link counts */
> > > +#define	XFS_FEAT_QUOTA		(1ULL << 2)	/* quota active */
> > > +#define	XFS_FEAT_ALIGN		(1ULL << 3)	/* inode alignment */
> > > +#define	XFS_FEAT_DALIGN		(1ULL << 4)	/* data alignment */
> > > +#define XFS_FEAT_LOGV2		(1ULL << 5)	/* version 2 logs */
> > > +#define XFS_FEAT_SECTOR		(1ULL << 6)	/* sector size > 512 bytes */
> > > +#define	XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
> > > +#define	XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
> > > +#define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
> > > +#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
> > > +#define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */
> > 
> > Hmm, none of the parent pointer stuff has been merged yet, has it? If
> > not, I'm sure it will be at some point, but I'd prefer not to include
> > code for features that technically don't exist.
> 
> We already have the parent point feature bit declared and this is a
> direct translation of the superblock feature bits. If it's unused,
> then the compiler elides the xfs_has_parent() check function,
> otherwise it's just a flag...
> 

Ok, I just wasn't aware it was already defined.

> > Otherwise it looks like we have some inconsistent spacing/indentation.
> 
> Inherited from the superblock feature bit definitions. I'll clean it
> up.
> 
> > 
> > > +#define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
> > > +#define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
> > > +#define XFS_FEAT_PQUOTINO	(1ULL << 14)	/* non-shared proj/grp quotas */
> > > +#define XFS_FEAT_FTYPE		(1ULL << 15)	/* inode type in dir */
> > > +#define XFS_FEAT_FINOBT		(1ULL << 16)	/* free inode btree */
> > > +#define XFS_FEAT_RMAPBT		(1ULL << 17)	/* reverse map btree */
> > > +#define XFS_FEAT_REFLINK	(1ULL << 18)	/* reflinked files */
> > > +#define XFS_FEAT_SPINODES	(1ULL << 19)	/* sparse inode chunks */
> > > +#define XFS_FEAT_META_UUID	(1ULL << 20)	/* metadata UUID */
> > > +#define XFS_FEAT_REALTIME	(1ULL << 21)	/* realtime device present */
> > > +
> > > +#define __XFS_HAS_FEAT(name, NAME) \
> > > +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> > > +{ \
> > 
> > I'm assuming these xfs_has_*() calls will end up replacing the current
> > xfs_sb_version_has*() calls throughout the code. Could we start using a
> 
> Yes.
> 
> > consistent function name prefix across the helpers? E.g., I think using
> > 'xfs_feat_ ## name' here (instead of xfs_has_) would be fine, and
> > consistent with the other helpers.
> 
> I'd prefer to drop the _feat_ prefix for the couple of add/remove
> wrappers that exist, not add it to every feature check.
> 
> > I don't want to get into bikeshedding too much but tbh I've always found
> > the xfs_sb_has_* thing kind of weird where the "has" text seems
> > superfluous. It's just not been worth changing. It would be nice if we
> > could stop propagating it here and define a consistently used prefix.
> 
> Yet we use "is" all over the place when checking if an object is
> <something> (e.g. xfs_btree_ptr_is_null(), xfs_iext_rec_is_empty(),
> xfs_rmap_is_mergeable(), etc) because it makes the code more
> readable. The old sbversion namespace format is the problem, not the
> use of "has" to indicate we are checking if the filesystem has a
> feature...
> 

Each of the examples you cited above have widely used function name
prefixes. There's a reason they are named as they are and not as
xfs_is_empty_iext_rec(), for example. That's what I'm asking for here.
I don't fundamentally object to the fact that we use "has" or "is." I'm
merely pointing out that I think "has" is superfluous with respect to a
properly used function prefix and therefore we could replace it with the
prefix used by the other related helpers, restoring consistency without
sacrificing readability.

IOW, if you wanted to rename these to something like
xfs_feat_crc_enablement_it_has(mp), that wouldn't exactly be my
preference...  but I won't object if we can address the function prefix
thing. ;P

> I omitted the "_feat_" part of the name because it's effectively
> redundant when you read it. i.e. if (xfs_has_pquotaino(mp)) reads as
> a well composed sentence: "if XFS has project quotas inodes on this
> mount". Doing s/has/feature/ does not improve the readbility of the
> code, just makes it unnecessarily verbose.
> 

Eh, I don't think anybody is going to be confused by
xfs_has_pquotaino(mp) vs. xfs_feat_pquotaino(mp). Either way is
self-descriptive and obvious IMO. As noted, I'm not really looking to
bikeshed over the most clear way to say "if this feature is enabled" in
a function name. I'd just prefer to use the associated function prefix
as we do most everywhere else.

> 
> 
> 
> > > +	return mp->m_features & XFS_FEAT_ ## NAME; \
> > > +}
> > > +
> > > +/* Some features can be added dynamically so they need a set wrapper, too. */
> > > +#define __XFS_HAS_ADDFEAT(name, NAME) \
> > > +	__XFS_HAS_FEAT(name, NAME); \
> > > +static inline void xfs_feat_add_ ## name (struct xfs_mount *mp) \
> > > +{ \
> > > +	mp->m_features |= XFS_FEAT_ ## NAME; \
> > > +	xfs_sb_version_add ## name(&mp->m_sb); \
> > > +}
> > > +
> > > +/* Some features can be cleared dynamically so they need a clear wrapper */
> > > +#define __XFS_HAS_REMOVEFEAT(name, NAME) \
> > > +	__XFS_HAS_ADDFEAT(name, NAME); \
> > > +static inline void xfs_feat_remove_ ## name (struct xfs_mount *mp) \
> > > +{ \
> > > +	mp->m_features &= ~XFS_FEAT_ ## NAME; \
> > > +	xfs_sb_version_remove ## name(&mp->m_sb); \
> > > +}
> > > +
> > 
> > In addition to the above, we use HAS_FEAT for an underlying xfs_has_
> > (i.e., no "feat") helper above, yet for some reason also use the HAS for
> > the underlying xfs_feat_add/remove() helpers that don't use the "has"
> > wording. On top of that, HAS_ADD implies HAS and HAS_REMOVE implies
> > HAS_ADD, which isn't really clear from the naming.
> 
> I'll remove the HAS from them - that was just a side effect of a
> quick copy-n-paste.
> 
> > I think this would all be much clearer if we defined something like the
> > following:
> > 
> > 	__XFS_FEAT -> xfs_feat_*
> > 	__XFS_FEAT_ADD -> xfs_feat_add_*
> > 	__XFS_FEAT_REMOVE -> xfs_feat_remove_*
> 
> Adding and removing features dynamically is the exception rather
> than the common case. I want the common case to be simple and easy,
> and I'd much prefer we special case the implementation of the rare,
> unusual corner cases rather than make the common case more complex.
> 
> > ... for the individual helpers (i.e., no implicit dependencies) and then
> > just open-coded the appropriate calls in the list below. Alternatively,
> > we could create another set of macros like
> > XFS_FEAT_[FIXED|ADDONLY|ADDRM]() for the particular combinations that we
> > happen to use today. Either way would make it self-evident from the list
> > itself what helpers are defined without having to dig into all of the
> > macros.
> 
> I'll rename the constructor macros so it's clearer.
> 

Ok. All I'm really asking for is the ability to look at the list of
macros and know what's going on without having to dig into the
underlying implementation every time. If that can be accomplished with
more clear names, then that works too.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
