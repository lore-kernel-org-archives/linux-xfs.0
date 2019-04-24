Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfDXMRv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Apr 2019 08:17:51 -0400
Date: Wed, 24 Apr 2019 08:17:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/9] xfs: Add attr context to log item
Message-ID: <20190424121747.GB24717@bfoster>
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-8-allison.henderson@oracle.com>
 <20190422130338.GB56876@bfoster>
 <e60582d4-289d-92be-21d0-1d83d37bbd22@oracle.com>
 <20190423132024.GC2841@bfoster>
 <ae2f758b-fe03-23b9-4080-8763296258b0@oracle.com>
 <20190424041016.GA178347@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190424041016.GA178347@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Apr 23, 2019 at 09:10:16PM -0700, Darrick J. Wong wrote:
> Sorry I'm late back to the party...
> 
> On Tue, Apr 23, 2019 at 07:24:40PM -0700, Allison Henderson wrote:
> > 
> > On 4/23/19 6:20 AM, Brian Foster wrote:
> > > On Mon, Apr 22, 2019 at 03:01:27PM -0700, Allison Henderson wrote:
> > > > 
> > > > 
> > > > On 4/22/19 6:03 AM, Brian Foster wrote:
> > > > > On Fri, Apr 12, 2019 at 03:50:34PM -0700, Allison Henderson wrote:
> > > > > > This patch modifies xfs_attr_item to store a xfs_da_args, a xfs_buf pointer
> > > > > > and a new state type. We will use these in the next patch when
> > > > > > we modify xfs_set_attr_args to roll transactions by returning EAGAIN.
> > > > > > Because the subroutines of this function modify the contents of these
> > > > > > structures, we need to find a place to store them where they remain
> > > > > > instantiated across multiple calls to xfs_set_attr_args.
> > > > > > 
> > > > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > > ---
> > > > > 
> > > > > I see Darrick has already commented on the whole state thing. I'll
> > > > > probably have to grok the next patch to comment further, but just a
> > > > > couple initial thoughts:
> > > > > 
> > > > > First, I hit a build failure with this patch. It looks like there's a
> > > > > missed include in the scrub code:
> > > > > 
> > > > >     ...
> > > > >     CC [M]  fs/xfs/scrub/repair.o
> > > > > In file included from fs/xfs/scrub/repair.c:32:
> > > > > fs/xfs/libxfs/xfs_attr.h:105:21: error: field ‘xattri_args’ has incomplete type
> > > > >     struct xfs_da_args xattri_args;   /* args context */
> > > > Hmm, ok.  I'll get that corrected, I probably need to clean out my workspace
> > > > and build from scratch.
> > > > 
> > > > >     ...
> > > > > 
> > > > > Second, the commit log suggests that the states will reflect the current
> > > > > transaction roll points (i.e., establishing re-entry points down in
> > > > > xfs_attr_set_args(). I'm kind of wondering if we should break these
> > > > > xattr set sub-sequences down into smaller helper functions (refactoring
> > > > > the existing code as we go) such that the mechanism could technically be
> 
> I had had the thought of "why not just give each step of setting an
> attribute its own log item, so we don't have to have this STATE_NNN
> business?" but then realized that will generate an insane amount of
> boilerplate, and you're already close to a better solution, so I shut up
> to think harder. :)
> 

The thought of separating things down into smaller "ops" popped into my
head (not necessarily separate/smaller log items), but I hadn't really
thought it through to this point...

> > > > > used deferred or not. Re: the previous thought on whether to defer xattr
> > > > > removes or not, there might also be cases where there's not a need to
> > > > > defer xattr sets.
> > > > > 
> > > > > E.g., taking a quick peek into the next patch, the state 1 case in
> > > > > xfs_attr_try_sf_addname() is actually a transaction commit, which I
> > > > > think means we're done. We'd have done an attr memory allocation,
> > > > > deferred op and transaction roll where none was necessary so it might
> > > > > not be worth it to defer in that scenario. Hmm, it also looks like we
> > > > > return -EAGAIN in places where we've not actually done any work, like if
> > > > > a shortform add attempt returns -ENOSPC (or the -EAGAIN return before we
> > > > > even attempt the sf add). That kind of looks like a waste of transaction
> > > > > rolls and further suggests it might be cleaner to break this whole path
> > > > > down into helpers and put it back together in a way more conducive to
> > > > > deferred operations.
> 
> Er, agreed:
> 
> > > > Yes, this area is a bit of a wart the way it is right now.  I think you're
> > > > right in that ultimately we may end up having to do a lot of refactoring in
> > > > order to have more efficient "re-entry points".  The state machine is hard
> > > > to get into subroutines, so it's limited in use in the top level function.
> 
> So my current understanding of the problem is that we have this big old
> xfs_attr_set_args function that does multiple responsibilities requiring
> transaction rolls, which we can't do directly inside a ->finish_item
> handler:
> 
>  1. If no attr fork, add one.
>  2. If shortform attr fork, try to put it in the sf area.
>  3. If shortform attr fork and out of space, convert to leaf format.
>  4. Add attr to leaf/node attr tree.
> 

And there are a bunch of tx rolls down in the #4 codepath that this
series currently just tosses away. I'm not quite sure how appropriate
that is, but I also don't think we necessarily need to preserve each and
every transaction roll as implemented by the current code.

IOW, I think it absolutely makes sense to step back from the current
behavior and reassess the best/required places to roll xattr ops in
progress as well as the transaction reservation itself.

> So how about this: refactor each of these pieces into a separate
> function, then add a separate XFS_ATTR_OP_FLAGS_* value for each of
> these little pieces.  xfs_trans_attr() can call the appropriate little
> function for the OP_FLAG and xfs_attr_finish_item can figure out which
> state comes next based on the return value.
> 
> By directly mapping distinct OP_FLAGS to each piece of the attr setting
> puzzle, you can use the existing "roll and come back" part of the defer
> ops machinery.
> 
> If _finish_item thinks we're done then we just exit.  Otherwise, store
> the new state in the (struct xfs_attr_item *) parameter passed into
> _finish_item and return -EAGAIN, which puts the defer item back on the
> defer op list, logs a new xattr intent with the new state, rolls the
> transaction, and tries to finish the attr again.  I think you've already
> done this last part.
> 

That sounds plausible to me. One concern I have is that I think we
should try to avoid creating more unnecessary complexity in the dfops
state mechanism simply to accommodate a messy xattr implementation. For
example, consider the following sequence for a simple set of an xattr
that requires leaf format and remote value block(s):

- try sf add
- returns -ENOSPC, convert to leaf and roll tx
- attempt to add the xattr (xfs_attr_leaf_addname())
	- if -ENOSPC, convert to node and call xfs_attr_node_addname()
	- else call xfs_attr3_leaf_add_work()
		- add entry
		- if remoteval, set INCOMPLETE
- roll tx
- if remoteval, call xfs_attr_rmtval_set()
	- block allocation, tx roll loop
	- copy remote value into bufs, xfs_bwrite()
- if remoteval, xfs_attr3_leaf_clearflag()
	- clear INCOMPLETE
	- update/log rmt pointers
	- roll tx

I'm wondering 1.) how much of this is necessary with an intent based
implementation and 2.) how much of this can be refactored to not require
complex state tracking.

For example, all of the format conversions that occur before we actually
make any modifications associated with the xattr (i.e., -ENOSPC returns
from the current format) seem to me could easily be performed and
immediately return -EAGAIN without any state tracking. The retry should
pick up the current format of the fork and retry there. Thus, ISTM we
could drop the whole xfs_attr_leaf_addname() -> xfs_attr3_leaf_to_node()
-> xfs_attr_node_addname() codepath in favor of a format conversion and
-EAGAIN retry that calls directly into xfs_attr_node_addname().

Once we have leaf format and we're doing remote block allocation, how
much could we get away with by re-looking up the entry, finding that
we're still short of remote blocks and performing another
xfs_bmapi_write() -> -EAGAIN cycle until we're good to copy in the xattr
value?

What about all this INCOMPLETE stuff? Do we even need that with an
intent based implementation? My understanding was that was because we
had to roll the transaction and thus could leave an incomplete xattr on
disk. I haven't looked too far into it so perhaps there's more to it
than that, but if not and this is no longer a problem with an intent
based implementation then perhaps much of that code and associated tx
rolls can be bypassed as well.

This is not to say that we won't require any such state tracking as
you've described above. The whole block allocation thing above may
require a state marker to get around attempts to set the xattr name
again and get back to the remote value block allocation code. It also
looks like we can do post xattr set format changes (i.e., node -> leaf,
leaf -> sf) that might require something like that to make sure we don't
go an retry an xattr set we've already completed. The point is just that
I'd prefer that we explore how much we can simplify this mess of an
implementation as much as possible (the above is all very handwavy)
first to reduce the state tracking complexity, particularly if these
states end up written to the log via the intent.

Hmm, I'm starting to think that maybe what we really need to do here is
step back from the code and logically map out what these states and the
resulting operation flow needs to be, particularly since there are so
many variations between different format conversions, renames, remote
blocks, etc. Once we have this whole mess mapped out, coding it up
should be more of an effort in refactoring.

> xfs_attri_recover then becomes much simpler -- we're passed in the
> reconstructed log item from which we figure out which step we need to
> do.  We call xfs_trans_attr() to do that one step, but unlike
> _finish_item, we use the new state to construct a *new* attr intent and
> attach it to the transaction, then call xfs_defer_move at the end to
> move all the queued defer_ops to the parent_tp because log recovery
> requires us to recover all the incomplete log intent items before
> finishing any new ones that were created as part of recovery.
> 
> This does mean that we end up with dramatically separate code paths for
> defer ops attr setting vs. regular attr setting, but as you point out
> the parent pointer feature will give the new code paths plenty of exercise.
> Tying the new log intent items to a new feature bit is key to preventing
> old kernels from stumbling across our new intent items, so we needed to
> preserve the old attr set paths anyway.
> 

That's a good point wrt to the other discussion around the direct xattr
codepath. It sounds like we do need to keep that entire path around
regardless to support v4 filesystems and such. The current series just
unconditionally switches things over to deferred ops.

> Anyway, if this all seems confusing, you can track me down, because I
> wrote most of this system and therefore have forgotten all of
> it^W^W^W^W^Wam available to help. :)
> 
> > > > 
> > > > I was also starting to wonder if maybe I could do some refactoring in
> > > > xfs_defer_finish_noroll to capture the common code associated with the
> > > > -EAGAIN handling.  Then maybe we could make a function pointer that we can
> > > > pass through the finish_item interface.  The idea being that subroutines
> > > > could use the function pointer to cycle out the transaction when needed
> > > > instead of having to record states and back out like this. It'd be a new
> 
> The state tracking and rolling is already built into xfs_defer.c. :)
> 
> > > > parameter to pipe around, but it'd be more efficient than the state machine,
> > > > and less surgery in the refactor.  And maybe a blessing to any other
> > > > operations that might need to go through this transition in the future.
> > > > Thoughts?
> > > > 
> > > 
> > > That's an interesting idea. It still strikes me as a bit of a
> > > fallback/hack as opposed to organizing the code to properly fit into the
> > > dfops infrastructure, but it could be useful as a transient solution.
> > >  From a high level, it looks like we'd have to create a new intent, relog
> > > this item and all remaining items associated with the dfp to it, roll
> > > the tx, and finally create a done item associated with the intent in the
> > > new tx. You'd need access to the dfp for some of that, so it's not
> > > immediately clear to me that this ends up much easier than fixing up
> > > the xattr code.
> 
> (I think the code that handles EAGAIN being returned from finish_item
> does this for you....)
> 

Yeah, I'm not totally sure it's an ideal/feasible approach, but for the
sake of clarity I think what Allison is getting at is that if there was
a way to trigger a dfops -EAGAIN roll sequence via a callback/helper
function, we wouldn't need to refactor the xattr subsystem to have
-EAGAIN return points. Instead we could just invoke the callback at the
existing roll points and achieve the same behavior (in theory). It's
kind of like providing an inside-out xfs_defer_finish_noroll() -EAGAIN
implementation via a helper function for code down in ->finish_item().

Brian

> > > 
> > > BTW, if we did end up with something like that I'd probably prefer to
> > > see it as an exported dfops helper function as opposed to a function
> > > pointer being passed around, if possible.
> > > 
> > 
> > Alrighty, I think for now I may try to pursue something more like what you
> > proposed in the next patch and see where I get first.  Maybe I'll come back
> > to this later if for some reason it doesn't work out, but I think what you
> > have there is reasonable.
> 
> <nod>
> 
> --D
> 
> > 
> > Thanks again for the reviews!
> > Allison
> > 
> > > Brian
> > > 
> > > > Thanks again for the reviews!
> > > > 
> > > > Allison
> > > > 
> > > > > 
> > > > > Brian
> > > > > 
> > > > > 
> > > > > >    fs/xfs/libxfs/xfs_attr.h | 18 +++++++++++++++++-
> > > > > >    fs/xfs/scrub/common.c    |  2 ++
> > > > > >    fs/xfs/xfs_acl.c         |  2 ++
> > > > > >    fs/xfs/xfs_attr_item.c   |  2 +-
> > > > > >    fs/xfs/xfs_ioctl.c       |  2 ++
> > > > > >    fs/xfs/xfs_ioctl32.c     |  2 ++
> > > > > >    fs/xfs/xfs_iops.c        |  1 +
> > > > > >    fs/xfs/xfs_xattr.c       |  1 +
> > > > > >    8 files changed, 28 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > > > > index 974c963..4ce3b0a 100644
> > > > > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > > > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > > > > @@ -77,6 +77,13 @@ typedef struct attrlist_ent {	/* data from attr_list() */
> > > > > >    	char	a_name[1];	/* attr name (NULL terminated) */
> > > > > >    } attrlist_ent_t;
> > > > > > +/* Attr state machine types */
> > > > > > +enum xfs_attr_state {
> > > > > > +	XFS_ATTR_STATE1 = 1,
> > > > > > +	XFS_ATTR_STATE2 = 2,
> > > > > > +	XFS_ATTR_STATE3 = 3,
> > > > > > +};
> > > > > > +
> > > > > >    /*
> > > > > >     * List of attrs to commit later.
> > > > > >     */
> > > > > > @@ -88,7 +95,16 @@ struct xfs_attr_item {
> > > > > >    	void		  *xattri_name;	      /* attr name */
> > > > > >    	uint32_t	  xattri_name_len;    /* length of name */
> > > > > >    	uint32_t	  xattri_flags;       /* attr flags */
> > > > > > -	struct list_head  xattri_list;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Delayed attr parameters that need to remain instantiated
> > > > > > +	 * across transaction rolls during the defer finish
> > > > > > +	 */
> > > > > > +	struct xfs_buf		*xattri_leaf_bp;  /* Leaf buf to release */
> > > > > > +	enum xfs_attr_state	xattri_state;	  /* state machine marker */
> > > > > > +	struct xfs_da_args	xattri_args;	  /* args context */
> > > > > > +
> > > > > > +	struct list_head	xattri_list;
> > > > > >    	/*
> > > > > >    	 * A byte array follows the header containing the file name and
> > > > > > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > > > > > index 0c54ff5..270c32e 100644
> > > > > > --- a/fs/xfs/scrub/common.c
> > > > > > +++ b/fs/xfs/scrub/common.c
> > > > > > @@ -30,6 +30,8 @@
> > > > > >    #include "xfs_rmap_btree.h"
> > > > > >    #include "xfs_log.h"
> > > > > >    #include "xfs_trans_priv.h"
> > > > > > +#include "xfs_da_format.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_reflink.h"
> > > > > >    #include "scrub/xfs_scrub.h"
> > > > > > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > > > > > index 142de8d..9b1b93e 100644
> > > > > > --- a/fs/xfs/xfs_acl.c
> > > > > > +++ b/fs/xfs/xfs_acl.c
> > > > > > @@ -10,6 +10,8 @@
> > > > > >    #include "xfs_mount.h"
> > > > > >    #include "xfs_inode.h"
> > > > > >    #include "xfs_acl.h"
> > > > > > +#include "xfs_da_format.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_trace.h"
> > > > > >    #include <linux/slab.h>
> > > > > > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > > > > > index 0ea19b4..36e6d1e 100644
> > > > > > --- a/fs/xfs/xfs_attr_item.c
> > > > > > +++ b/fs/xfs/xfs_attr_item.c
> > > > > > @@ -19,10 +19,10 @@
> > > > > >    #include "xfs_rmap.h"
> > > > > >    #include "xfs_inode.h"
> > > > > >    #include "xfs_icache.h"
> > > > > > -#include "xfs_attr.h"
> > > > > >    #include "xfs_shared.h"
> > > > > >    #include "xfs_da_format.h"
> > > > > >    #include "xfs_da_btree.h"
> > > > > > +#include "xfs_attr.h"
> > > > > >    static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
> > > > > >    {
> > > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > > index ab341d6..c8728ca 100644
> > > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > > @@ -16,6 +16,8 @@
> > > > > >    #include "xfs_rtalloc.h"
> > > > > >    #include "xfs_itable.h"
> > > > > >    #include "xfs_error.h"
> > > > > > +#include "xfs_da_format.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_bmap.h"
> > > > > >    #include "xfs_bmap_util.h"
> > > > > > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > > > > > index 5001dca..23f6990 100644
> > > > > > --- a/fs/xfs/xfs_ioctl32.c
> > > > > > +++ b/fs/xfs/xfs_ioctl32.c
> > > > > > @@ -21,6 +21,8 @@
> > > > > >    #include "xfs_fsops.h"
> > > > > >    #include "xfs_alloc.h"
> > > > > >    #include "xfs_rtalloc.h"
> > > > > > +#include "xfs_da_format.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_ioctl.h"
> > > > > >    #include "xfs_ioctl32.h"
> > > > > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > > > > index e73c21a..561c467 100644
> > > > > > --- a/fs/xfs/xfs_iops.c
> > > > > > +++ b/fs/xfs/xfs_iops.c
> > > > > > @@ -17,6 +17,7 @@
> > > > > >    #include "xfs_acl.h"
> > > > > >    #include "xfs_quota.h"
> > > > > >    #include "xfs_error.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_trans.h"
> > > > > >    #include "xfs_trace.h"
> > > > > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > > > > index 3013746..938e81d 100644
> > > > > > --- a/fs/xfs/xfs_xattr.c
> > > > > > +++ b/fs/xfs/xfs_xattr.c
> > > > > > @@ -11,6 +11,7 @@
> > > > > >    #include "xfs_mount.h"
> > > > > >    #include "xfs_da_format.h"
> > > > > >    #include "xfs_inode.h"
> > > > > > +#include "xfs_da_btree.h"
> > > > > >    #include "xfs_attr.h"
> > > > > >    #include "xfs_attr_leaf.h"
> > > > > >    #include "xfs_acl.h"
> > > > > > -- 
> > > > > > 2.7.4
> > > > > > 
