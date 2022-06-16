Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79529C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 05:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242913AbiFPFcw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbiFPFcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 01:32:51 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB03C1E3E1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 22:32:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E640B5EC9D5;
        Thu, 16 Jun 2022 15:32:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1i7a-007DkO-AT; Thu, 16 Jun 2022 15:32:46 +1000
Date:   Thu, 16 Jun 2022 15:32:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
Message-ID: <20220616053246.GB227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-2-allison.henderson@oracle.com>
 <20220615010932.GZ227878@dread.disaster.area>
 <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
 <20220616020843.GA227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616020843.GA227878@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62aac080
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=Qji4nGbRO_eDcGUZOkUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 12:08:43PM +1000, Dave Chinner wrote:
> On Wed, Jun 15, 2022 at 04:40:07PM -0700, Alli wrote:
> > On Wed, 2022-06-15 at 11:09 +1000, Dave Chinner wrote:
> > > On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson wrote:
> > > > Recent parent pointer testing has exposed a bug in the underlying
> > > > larp state machine.  A replace operation may remove an old attr
> > > > before adding the new one, but if it is the only attr in the fork,
> > > > then the fork is removed.  This later causes a null pointer in
> > > > xfs_attr_try_sf_addname which expects the fork present.  This
> > > > patch adds an extra state to create the fork.
> > > 
> > > Hmmmm.
> > > 
> > > I thought I fixed those problems - in xfs_attr_sf_removename() there
> > > is this code:
> > > 
> > >         if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp)
> > > &&
> > >             (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> > >             !(args->op_flags & (XFS_DA_OP_ADDNAME |
> > > XFS_DA_OP_REPLACE))) {
> > >                 xfs_attr_fork_remove(dp, args->trans);
> > Hmm, ok, let me shuffle in some traces around there to see where things
> > fall off the rails
> > 
> > > 
> > > A replace operation will have XFS_DA_OP_REPLACE set, and so the
> > > final remove from a sf directory will not remove the attr fork in
> > > this case. There is equivalent checks in the leaf/node remove name
> > > paths to avoid removing the attr fork if the last attr is removed
> > > while the attr fork is in those formats.
> > > 
> > > How do you reproduce this issue?
> > > 
> > 
> > Sure, you can apply this kernel set or download it here:
> > https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrs
> > 
> > Next you'll need this xfsprogs that has the neccassary updates to run
> > parent pointers
> > https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs
> > 
> > 
> > To reproduce the bug, you'll need to apply a quick patch on the kernel
> > side:
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index b86188b63897..f279afd43462 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> >  		fallthrough;
> >  	case XFS_DAS_SF_ADD:
> >  		if (!args->dp->i_afp) {
> > -			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > -			goto next_state;
> > +//			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > +//			goto next_state;
> >  		}
> 
> Ah, so it's recovery that trips this....
> 
> > [  365.290048]  xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
> > [  365.290423]  xfs_attr_set_iter+0x2f9/0x1510 [xfs]
> > [  365.291592]  xfs_xattri_finish_update+0x66/0xd0 [xfs]
> > [  365.292008]  xfs_attr_finish_item+0x43/0x120 [xfs]
> > [  365.292410]  xfs_defer_finish_noroll+0x3c2/0xcc0 [xfs]
> > [  365.293196]  __xfs_trans_commit+0x333/0x610 [xfs]
> > [  365.294401]  xfs_trans_commit+0x10/0x20 [xfs]
> > [  365.294797]  xlog_finish_defer_ops+0x133/0x270 [xfs]
> > [  365.296054]  xlog_recover_process_intents+0x1f7/0x3e0 [xfs]
> 
> ayup.
> 
> > > > Additionally the new state will be used by parent pointers which
> > > > need to add attributes to newly created inodes that do not yet
> > > > have a fork.
> > > 
> > > We already have the capability of doing that in xfs_init_new_inode()
> > > by passing in init_xattrs == true. So when we are creating a new
> > > inode with parent pointers enabled, we know that we are going to be
> > > creating an xattr on the inode and so we should always set
> > > init_xattrs in that case.
> > Hmm, ok.  I'll add some tracing around in there too, if I back out the
> > entire first patch, we crash out earlier in recovery path because no
> > state is set.  If we enter xfs_attri_item_recover with no fork, we end
> > up in the following switch:
> > 
> > 
> >         case XFS_ATTRI_OP_FLAGS_REPLACE:
> >                 args->value = nv- >value.i_addr;
> >                 args->valuelen = nv- >value.i_len;
> >                 args->total = xfs_attr_calc_size(args, &local);
> >                 if (xfs_inode_hasattr(args- >dp))
> >                         attr->xattri_dela_state = xfs_attr_init_replace_state(args);
> >                 else
> >                         attr->xattri_dela_state = xfs_attr_init_add_state(args);
> >                 break;
> > 
> > Which will leave the state unset if the fork is absent.
> 
> Yeah, OK, I think this is because we are combining attribute
> creation with inode creation. When log recovery replays inode core
> modifications, it replays the inode state into the cluster buffer
> and writes it. Then when we go to replay the attr intent at the end
> of recovery, the inode is read from disk via xlog_recover_iget(),
> but we don't initialise the attr fork because ip->i_forkoff is zero.
> i.e. it has no attrs at this point.
> 
> I suspect that we could catch that in xlog_recover_iget() when it is
> called from attr recovery. i.e. we detect newly created inodes and
> initialise the attr fork similar to what we do in
> xfs_init_new_inode(). I was thinking something like this:
> 
> 	if (init_xattrs && xfs_has_attr(mp)) {
> 		if (!ip->i_forkoff && !ip->i_nextents) {
> 			ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
> 			ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> 		} else {
> 			ASSERT(ip->i_afp);
> 		}
> 	}
> 
> Would do the trick, but then I realised that the timing/ordering is
> very different to runtime: we don't replay the attr intent until the
> end of log recovery and all the inode changes have been replayed
> into the inode cluster buffer. That means we could have already
> replayed a bunch of data fork extent modifications into the inode,
> and so the default attr offset is almost certainly not a safe thing
> to be using here. Indeed, there might not be space in the inode for
> the attr we want to insert and so we might need to convert the data
> fork to a different format before we run the attr intent replay.

Ok, so after further thought, I don't think this can happen. If we
are replaying an attr intent, it means we crashed before the intent
done was recorded in the log. At this point in time the inode was
locked and so there could be no racing changes to the inode data
fork in the log. i.e. because of log item ordering, if the intent
done is not in the log, none of the future changes that occurred
after the intent done will be in the log, either. The inode on disk
will not contain them either because the intent done must be in the
log before the inode gets unpinned and is able to be written to
disk.

Hence if we've got an attr intent to replay, it must be the last
active modification to that inode that must be replayed, and the
state of the inode on disk at the time of recovering the attr intent
should match the state of the inode in memory at the time the attr
intent was started.

Hence there isn't a consistency model coherency problem here, and
that means if there's no attr fork at the time the attr recovery is
started, it *must* be a newly created inode. If the inode already
existed and a transaction had to be run to create the attr fork
(i.e. xfs_bmap_add_attrfork() had to be run) then that transaction
would have been recovered from the log before attr replay started,
and so xlog_recovery_iget() should see a non-zero ip->i_forkoff and
initialise the attr fork correctly.

But this makes me wonder further. If the attr intent is logged in
the same transaction as the inode is allocated, then the setting of
ip->i_forkoff in xfs_init_new_inode() should also be logged in that
transaction (because XFS_ILOG_CORE is used) and hence be replayed
into the on-disk inode by recovery before the attr intent recovery
starts. Hence xlog_recover_iget() should be initialising the attr
fork through this path:

xlog_recover_iget
  xfs_iget
    xfs_iget_cache_miss
      xfs_inode_from_disk
	if (ip->i_forkoff)
	  xfs_iformat_attr_fork()

This means the newly allocated inode would have an attr fork
allocated to it, in extent format with zero extents. If we then look
at xfs_inode_hasattr():

int
xfs_inode_hasattr(
        struct xfs_inode        *ip)
{
        if (!XFS_IFORK_Q(ip))
                return 0;
        if (!ip->i_afp)
                return 0;
>>>>>   if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
>>>>>       ip->i_afp->if_nextents == 0)
>>>>>           return 0;
        return 1;
}

It would still say that it has no attrs even though the fork has
been initialised and we go down the xfs_attr_init_add_state()
branch.  This does:

static inline enum xfs_delattr_state
xfs_attr_init_add_state(struct xfs_da_args *args)
{
        /*
         * When called from the completion of a attr remove to determine the
         * next state, the attribute fork may be null. This can occur only occur
         * on a pure remove, but we grab the next state before we check if a
         * replace operation is being performed. If we are called from any other
         * context, i_afp is guaranteed to exist. Hence if the attr fork is
         * null, we were called from a pure remove operation and so we are done.
         */
>>>>    if (!args->dp->i_afp)
>>>>            return XFS_DAS_DONE;

        args->op_flags |= XFS_DA_OP_ADDNAME;
        if (xfs_attr_is_shortform(args->dp))
                return XFS_DAS_SF_ADD;
        if (xfs_attr_is_leaf(args->dp))
                return XFS_DAS_LEAF_ADD;
        return XFS_DAS_NODE_ADD;
}

Which would return XFS_DAS_DONE if there was no attr fork
initialised and recovery would be skipped completely. Hence for this
change to be required to trigger failures:

> > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> >             fallthrough;
> >     case XFS_DAS_SF_ADD:
> >             if (!args->dp->i_afp) {
> > -                   attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > -                   goto next_state;
> > +//                 attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > +//                 goto next_state;
> >             }

then it implies the only way we can get here is via a replace
operation that has removed the attr fork during the remove and we
hit this on the attr add. Yet, AFAICT, the attr fork does not get
removed when a replace operation is in progress.

Maybe there's a new bug introduced in the PP patchset that triggers
this - I'll do some more looking...

> > > This should avoid the need for parent pointers to ever need to run
> > > an extra transaction to create the attr fork. Hence, AFAICT, this
> > > new state to handle attr fork creation shouldn't ever be needed for
> > > parent pointers....
> > > 
> > > What am I missing?
> > > 
> > I hope the description helped?  I'll do some more poking around too and
> > post back if I find anything else.
> 
> Yup, it most definitely helped. :)
> 
> You've pointed out something I had completely missed w.r.t. attr
> intent replay ordering against replay of data fork modifications.
> There's definitely an issue here, I think it might be a fundamental
> issue with the recovery mechanism (and not parent pointers), and I
> think we'll end up needing  something like this patch to fix it.
> Let me bounce this around my head for a bit...

In summary, after further thought this turns out not to be an issue
at all, so I'm back to "replace doesn't remove the attr fork, so
how does this happen?"....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
