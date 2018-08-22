Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45860 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbeHWD0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Aug 2018 23:26:18 -0400
Date: Thu, 23 Aug 2018 09:59:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/10] xfs: reflect sb features in xfs_mount
Message-ID: <20180822235912.GY2234@dastard>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-2-david@fromorbit.com>
 <20180821132139.GA15030@bfoster>
 <20180821233133.GK31495@dastard>
 <20180822121755.GB26084@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180822121755.GB26084@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 22, 2018 at 08:17:55AM -0400, Brian Foster wrote:
> On Wed, Aug 22, 2018 at 09:31:33AM +1000, Dave Chinner wrote:
> > On Tue, Aug 21, 2018 at 09:21:40AM -0400, Brian Foster wrote:
> > > On Mon, Aug 20, 2018 at 02:48:42PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Currently on-disk feature checks require decoding the superblock
> > > > fileds and so can be non-trivial. We have almost 400 hundred
> > > > individual feature checks in the XFS code, so this is a significant
> > > > amount of code. To reduce runtime check overhead, pre-process all
> > > > the version flags into a features field in the xfs_mount at mount
> > > > time so we can convert all the feature checks to a simple flag
> > > > check.
> > > > 
> > > > There is also a need to convert the dynamic feature flags to update
> > > > the m_features field. This is required for attr, attr2 and quota
> > > > features. New xfs_mount based wrappers are added for this.
> > > > 
> > > > Before:
> > > > 
> > > > $ size -t fs/xfs/built-in.a
> > > >    text	   data	    bss	    dec	    hex	filename
> > > > ....
> > > > 1294873	 182766	   1036	1478675	 169013	(TOTALS
> > > > 
> > > 
> > > Was some text truncated from the commit log description here? Did you
> > > mean to include the after size as well?
> > 
> > Yeah, I thought I did update that. Maybe forgot to refresh the
> > header once I did. The before and after are:
> > 
> > 	text	   data	    bss	    dec	    hex	filename
> > before	1326155	 189006	   1036	1516197	 1722a5	(TOTALS)
> > after	1322929	 189006	   1036	1512971	 17160b	(TOTALS)
> > 
> 
> That's a much larger delta than what I saw when I checked out of
> curiousity, but I just ran against this first patch. It looks like this
> delta is before/after the whole series.

Yeah, it is - I couldn't find the original numbers in the scrollback
history of the build machine terminal. However, ~90% of the reduction
it comes from the first patch (3kB vs 3.2kB for the entire series)

> It might be good to qualify that
> in the commit log (i.e., "after the old xfs_sb_version_* wrappers are
> removed") just because the series context isn't always clear in the
> broader git log history.

Yeah, I'll fix it up, put the right number in it.

> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_format.h |  2 +-
> > > >  fs/xfs/libxfs/xfs_sb.c     | 61 +++++++++++++++++++++++++++++
> > > >  fs/xfs/libxfs/xfs_sb.h     |  1 +
> > > >  fs/xfs/xfs_log_recover.c   |  1 +
> > > >  fs/xfs/xfs_mount.c         |  1 +
> > > >  fs/xfs/xfs_mount.h         | 79 ++++++++++++++++++++++++++++++++++++++
> > > >  6 files changed, 144 insertions(+), 1 deletion(-)
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index a21dc61ec09e..5d0438ec07dd 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -5723,6 +5723,7 @@ xlog_do_recover(
> > > >  	xfs_buf_relse(bp);
> > > >  
> > > >  	/* re-initialise in-core superblock and geometry structures */
> > > > +	mp->m_features |= xfs_sb_version_to_features(sbp);
> > > 
> > > How is this a reinit if it ORs in fields?
> > 
> > The only feature bit that can be removed by log recovery is the
> > attr2 feature bit which means the last mount was mounted with
> > "noattr2". So apart from that feature bit, ORing in the new
> > superblock feature mask works just fine.
> > 
> 
> To be clear.. that's because attr2 is the only feature that can be
> currently unset at runtime, right?

Well, it's not really at runtime - it can only be cleared at mount
time before log recovery is run.  IMO, the attr2/noattr2 mount
option stuff really just needs to go away.

> > As it is, for v5 attr2 can't be turned off, so it's just fine for
> > v5 filesystems. For v4 the old code would set XFS_MOUNT_ATTR2 if the
> > sb feature bit was set /prior/ to log recovery being run. Hence if
> > log recovery removed the feature bit, the very next attr creation
> > will turn it straight back on.
> > 
> > The only way to not have attr2 enabled in this case is to use the
> > noattr2 mount option, and the new code has exactly the same
> > behaviour - the attr2 superblock bit and the feature flag will get
> > cleared after log recovery if the noattr2 mount option is set.
> > 
> > Also worth noting is that if there's a sb_bad_features2
> > interatction, it will re-add the feature bit because it just ORs the
> > two fields together.
> > 
> > IOWs, the behaviour of this patch is roughly the same as the
> > existing code when it comes to the attr2 flag being removed when the
> > superblock is recovered as well as when there is a features2
> > mismatch.
> > 
> 
> Ok, but this all sounds like a happy coincidence that depends on the
> semantics of attr2. IOW, the behavior of attr2 may ultimately be the
> same (which I haven't fully grokked), but unless I'm missing something
> more fundamental the logic in this patch still seems slightly dynamic
> feature challenged in this regard.
> 
> Mount a filesystem with some feature enabled, disable it and crash with
> the superblock change in the dirty log. Mount again, enable said feature
> based on sb, log recovery updates sb, feature remains inconsistently
> enabled due to not being cleared by the post-recovery feature init.
> Unless I'm missing something, this is handled correctly by the existing
> mechanism simply because each feature check refers to the superblock.

The only way to disable it is via the noattr2 mount option. So to
have the above occur, you've have to first mount with noattr2, crash
after mount has logged the superblock (which happens after
recovery), then mount again *without* the noattr2 mount option set.

IOWs, the XFS_MOUNT_ATTR2 flag in this case is set during
xfs_finish_flags() (i.e. mount option parsing) because the
unrecovered superblock has the feature flag set and
XFS_MOUNT_NOATTR2 is not set. All future decisions about whether to
create attr2 format forks are based on XFS_MOUNT_ATTR2, not the
superblock feature bit. If log recovery clears the sb feature bit,
then the next attribute fork creation will see XFS_MOUNT_ATTR2 set
and re-add the superblock bit.

IOWs, in the crash+recover case of attr2 sb feature bit removal, the
code I wrote does the same thing as the existing code - you need to
use the noattr2 mount option to guarantee that attr2 is not used.

IMO, this is legacy code (attr2 is permanently enabled for v5) that
has nasty warts. While the noattr2 mount option was introduced right
at the start in 2005, it didn't remove the superblock feature bit
until more than 3 years later because the sb feature bit processing
got moved by the sb_bad_features2 debacle and that broke noattr2. SO
instead of just looking at the noattr2 mount option again, it was
decided to clear the feature bit from the superblock. This is
despite the fact there are still attr2 format inode forks on disk.

i.e. the removal of the attr2 sb feature bit breaks all the
conventions we have for "sb feature bit indicates a specific on disk
format feature is present in the fs". The original noattr2 code did
not have this problem, and as such I think we should be reverting to
the original behaviour of the noattr2 mount option and stop trying
to screw with the on-disk sb flag once it is set because of the
above can of worms it opened.

I think I'll rework the attr2 code as the initial patch in this
series now, and get rid of the sb feature bit removal code
altogether so this whole problem goes away.

> > I think there's more work needed on the attr2 feature side of
> > things, as noted in the cover description. In addition to the
> > unpredictable behaviour via log recovery, I don't see a reason for
> > noattr2 existing these days. It doesn't get rid of existing attr2
> > format inodes on disk - it just stops new ones from being created.
> > We've used attr2 for more than 10 years now without it being an
> > issue, so there's no reason for needing to turn it off anymore. I
> > think we should deprecate the option and remove it.
> > 
> > > I guess I'm curious why we OR
> > > in fields in either case as opposed to using an assignment.
> > 
> > Because mount option features are already set in m_features, so we
> > can't just overwrite it with just the superblock features.
> 
> That doesn't appear to be the case as of this patch. If it's a factor
> later in the series, we should tweak it then where the intent is clear.

Patches don't exist in isolation. Please look at the work as a
whole, not just patches in isolation.

> This also doesn't strike me as a technically difficult problem to
> address. We just need to filter out the set of superblock based features
> one way or another. If you wanted to simplify it further, we could just
> have the sb -> features function update ->m_features itself in a safe
> manner (i.e., the subset of features it is responsible for) and then the
> caller context doesn't really have to be concerned with such details.

We shouldn't be clearing superblock feature bits while there are
still those features on disk. Only attr2 does this, and as per
above, it's broken. I'm going to remove the code that removes the
attr2 feature bit in the next round of the patch, and then this
whole problem goes away.

> 
> > > 
> > > >  	xfs_reinit_percpu_counters(mp);
> > > >  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
> > > >  	if (error) {
> > > ...
> > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > index 7964513c3128..92d947f17c69 100644
> > > > --- a/fs/xfs/xfs_mount.h
> > > > +++ b/fs/xfs/xfs_mount.h
> > > > @@ -127,6 +127,7 @@ typedef struct xfs_mount {
> > > >  	struct mutex		m_growlock;	/* growfs mutex */
> > > >  	int			m_fixedfsid[2];	/* unchanged for life of FS */
> > > >  	uint64_t		m_flags;	/* global mount flags */
> > > > +	uint64_t		m_features;	/* active filesystem features */
> > > >  	bool			m_inotbt_nores; /* no per-AG finobt resv. */
> > > >  	int			m_ialloc_inos;	/* inodes in inode allocation */
> > > >  	int			m_ialloc_blks;	/* blocks in inode allocation */
> > > > @@ -195,6 +196,84 @@ typedef struct xfs_mount {
> > > >  #endif
> > > >  } xfs_mount_t;
> > > >  
> > > > +/*
> > > > + * Flags for m_features.
> > > > + *
> > > > + * These are all the active features in the filesystem, regardless of how
> > > > + * they are configured.
> 
> Given the point above around mount options, I think the comment above
> would be more helpful if it said something like:
> 
> "These are all the active features in the filesystem. Some are
> configured based on superblock version, others are based on mount
> options."

Bigger picture: what about options we may set through, say, /proc,
/sys, ioctls, online repair, etc? I think that the the places and
ways we can set feature flags is only going to grow in future, and
hence I'd prefer to leave this as a generic comment that encompasses
everything rather than have it grow stale over time.

> > > I don't want to get into bikeshedding too much but tbh I've always found
> > > the xfs_sb_has_* thing kind of weird where the "has" text seems
> > > superfluous. It's just not been worth changing. It would be nice if we
> > > could stop propagating it here and define a consistently used prefix.
> > 
> > Yet we use "is" all over the place when checking if an object is
> > <something> (e.g. xfs_btree_ptr_is_null(), xfs_iext_rec_is_empty(),
> > xfs_rmap_is_mergeable(), etc) because it makes the code more
> > readable. The old sbversion namespace format is the problem, not the
> > use of "has" to indicate we are checking if the filesystem has a
> > feature...
> > 
> 
> Each of the examples you cited above have widely used function name
> prefixes.

The prefix indicates the subsystem the operation belongs to.

However, filesystem features are, well, belong in the global
context.  They span all subsystems, and are a property of the global
mount structure. IOWs, They don't have a single widely used
subsystem that can be used as a namespace prefix, and using
"feature" because "we must have a namespace prefix" turns all the
function names into tautologies.

Consider this: why is xfs_is_read_only(mp) an acceptible function
name for checking global filesystem state, but xfs_has_attr2(mp) is
not acceptible for checking global filesystem state?

> There's a reason they are named as they are and not as
> xfs_is_empty_iext_rec(), for example. That's what I'm asking for here.
> I don't fundamentally object to the fact that we use "has" or "is." I'm
> merely pointing out that I think "has" is superfluous with respect to a
> properly used function prefix and therefore we could replace it with the
> prefix used by the other related helpers, restoring consistency without
> sacrificing readability.
> 
> IOW, if you wanted to rename these to something like
> xfs_feat_crc_enablement_it_has(mp), that wouldn't exactly be my
> preference...  but I won't object if we can address the function prefix
> thing. ;P
> 
> > I omitted the "_feat_" part of the name because it's effectively
> > redundant when you read it. i.e. if (xfs_has_pquotaino(mp)) reads as
> > a well composed sentence: "if XFS has project quotas inodes on this
> > mount". Doing s/has/feature/ does not improve the readbility of the
> > code, just makes it unnecessarily verbose.
> > 
> 
> Eh, I don't think anybody is going to be confused by
> xfs_has_pquotaino(mp) vs. xfs_feat_pquotaino(mp). Either way is

I find it confusing. Is it checking if the feature is enabled? Is it
manipulating the feature in some way? Is it checking if we actually
have a project quota inode present on the xfs_mount? Or maybe
something else?

i.e. There's no action defined or implied by the function name and so
I can't tell what that function is doing without looking at it.
That's what "has" or "is" adds to the function name: a definitive
action. i.e.  it's not the namespace prefix that is meaningful here
- it's the action in the name ("has") that makes it obvious what the
function does.

> self-descriptive and obvious IMO. As noted, I'm not really looking to
> bikeshed over the most clear way to say "if this feature is enabled" in
> a function name. I'd just prefer to use the associated function prefix
> as we do most everywhere else.

And that's the issue I have here - we must do exactly what we've
done in the past, even though those rules are falling down around
us. Look at the mess this blind obedience to namespace rules got the
scrub code into; it was ending up an unreadable jumble of noise
because every structure and function had 25+ character namespace
prefixes you had to read on every line of code before you get to the
meaningful information.

Namespacing structures and functions have their place, but there is
such a thing as taking it too far. Stuff that is easily
understandable without verbose namespace prefixes should not have
verbose/redundant namespace prefixes. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
