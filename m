Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23527C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 00:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiF3Ak1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 20:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiF3Ak1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 20:40:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352733FBF2
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 17:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6EECB826F8
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 00:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F46C34114;
        Thu, 30 Jun 2022 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656549621;
        bh=NcIfvHH3kHUDymXE8Ewyho9nkkH70KlRPtz/OCdBp1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hplpJC8XLz+9EYTRTPK50Xd0oq1uh0bkRcKqxU1PnIjccoiJClubUCFGj7L+6+V1M
         W1FLt8Sp9cS0zmBqJjRxUl9ODM2rp2iFjlhC9qB6BdjnSr3Kp3IZk7HWA/wSSQAStV
         eqKmCKrm48COGsEZaElwUKHwhdKT9ZSM4l30Niun30yT/f9ViZ7VbW4h4fcMwoPSJO
         xEz4AZJ/Y1PZFScNYpYE+zZ3XOXRPOSl5amWYjlzGgvbMr16kltla6FZYXaU6LLMJ2
         p3FcXOkDEPiVKvIdzsyWHMiNJXUyiYtyZLwT4fJeuRgXyEhib6f29VyfGwz4hDFTmZ
         izg5Zy/r/dSpA==
Date:   Wed, 29 Jun 2022 17:40:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
Message-ID: <Yrzw9F5aGsaldrmR@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-2-allison.henderson@oracle.com>
 <20220615010932.GZ227878@dread.disaster.area>
 <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
 <20220616020843.GA227878@dread.disaster.area>
 <20220616053246.GB227878@dread.disaster.area>
 <362a6fa4525ec1c6229df729f9dc4eb5c5122c16.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <362a6fa4525ec1c6229df729f9dc4eb5c5122c16.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 11:33:49PM -0700, Alli wrote:
> On Thu, 2022-06-16 at 15:32 +1000, Dave Chinner wrote:
> > On Thu, Jun 16, 2022 at 12:08:43PM +1000, Dave Chinner wrote:
> > > On Wed, Jun 15, 2022 at 04:40:07PM -0700, Alli wrote:
> > > > On Wed, 2022-06-15 at 11:09 +1000, Dave Chinner wrote:
> > > > > On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson
> > > > > wrote:
> > > > > > Recent parent pointer testing has exposed a bug in the
> > > > > > underlying
> > > > > > larp state machine.  A replace operation may remove an old
> > > > > > attr
> > > > > > before adding the new one, but if it is the only attr in the
> > > > > > fork,
> > > > > > then the fork is removed.  This later causes a null pointer
> > > > > > in
> > > > > > xfs_attr_try_sf_addname which expects the fork present.  This
> > > > > > patch adds an extra state to create the fork.
> > > > > 
> > > > > Hmmmm.
> > > > > 
> > > > > I thought I fixed those problems - in xfs_attr_sf_removename()
> > > > > there
> > > > > is this code:
> > > > > 
> > > > >         if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
> > > > > xfs_has_attr2(mp)
> > > > > &&
> > > > >             (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> > > > >             !(args->op_flags & (XFS_DA_OP_ADDNAME |
> > > > > XFS_DA_OP_REPLACE))) {
> > > > >                 xfs_attr_fork_remove(dp, args->trans);
> > > > Hmm, ok, let me shuffle in some traces around there to see where
> > > > things
> > > > fall off the rails
> > > > 
> > > > > A replace operation will have XFS_DA_OP_REPLACE set, and so the
> > > > > final remove from a sf directory will not remove the attr fork
> > > > > in
> > > > > this case. There is equivalent checks in the leaf/node remove
> > > > > name
> > > > > paths to avoid removing the attr fork if the last attr is
> > > > > removed
> > > > > while the attr fork is in those formats.
> > > > > 
> > > > > How do you reproduce this issue?
> > > > > 
> > > > 
> > > > Sure, you can apply this kernel set or download it here:
> > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrs__;!!ACWV5N9M2RV99hQ!O7bhq9bR_z2xjlhlwWb78ZXwzigOh6P8V3_EkeL9AHFOpdYdr_irAwUocygT_G8LI-lKDL5_01Df49lTy27a$ 
> > > > 
> > > > Next you'll need this xfsprogs that has the neccassary updates to
> > > > run
> > > > parent pointers
> > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs__;!!ACWV5N9M2RV99hQ!O7bhq9bR_z2xjlhlwWb78ZXwzigOh6P8V3_EkeL9AHFOpdYdr_irAwUocygT_G8LI-lKDL5_01Df4w3Mct8F$ 
> > > > 
> > > > 
> > > > To reproduce the bug, you'll need to apply a quick patch on the
> > > > kernel
> > > > side:
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index b86188b63897..f279afd43462 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> > > >  		fallthrough;
> > > >  	case XFS_DAS_SF_ADD:
> > > >  		if (!args->dp->i_afp) {
> > > > -			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> > > > -			goto next_state;
> > > > +//			attr->xattri_dela_state =
> > > > XFS_DAS_CREATE_FORK;
> > > > +//			goto next_state;
> > > >  		}
> > > 
> > > Ah, so it's recovery that trips this....
> > > 
> > > > [  365.290048]  xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
> > > > [  365.290423]  xfs_attr_set_iter+0x2f9/0x1510 [xfs]
> > > > [  365.291592]  xfs_xattri_finish_update+0x66/0xd0 [xfs]
> > > > [  365.292008]  xfs_attr_finish_item+0x43/0x120 [xfs]
> > > > [  365.292410]  xfs_defer_finish_noroll+0x3c2/0xcc0 [xfs]
> > > > [  365.293196]  __xfs_trans_commit+0x333/0x610 [xfs]
> > > > [  365.294401]  xfs_trans_commit+0x10/0x20 [xfs]
> > > > [  365.294797]  xlog_finish_defer_ops+0x133/0x270 [xfs]
> > > > [  365.296054]  xlog_recover_process_intents+0x1f7/0x3e0 [xfs]
> > > 
> > > ayup.
> > > 
> > > > > > Additionally the new state will be used by parent pointers
> > > > > > which
> > > > > > need to add attributes to newly created inodes that do not
> > > > > > yet
> > > > > > have a fork.
> > > > > 
> > > > > We already have the capability of doing that in
> > > > > xfs_init_new_inode()
> > > > > by passing in init_xattrs == true. So when we are creating a
> > > > > new
> > > > > inode with parent pointers enabled, we know that we are going
> > > > > to be
> > > > > creating an xattr on the inode and so we should always set
> > > > > init_xattrs in that case.
> > > > Hmm, ok.  I'll add some tracing around in there too, if I back
> > > > out the
> > > > entire first patch, we crash out earlier in recovery path because
> > > > no
> > > > state is set.  If we enter xfs_attri_item_recover with no fork,
> > > > we end
> > > > up in the following switch:
> > > > 
> > > > 
> > > >         case XFS_ATTRI_OP_FLAGS_REPLACE:
> > > >                 args->value = nv- >value.i_addr;
> > > >                 args->valuelen = nv- >value.i_len;
> > > >                 args->total = xfs_attr_calc_size(args, &local);
> > > >                 if (xfs_inode_hasattr(args- >dp))
> > > >                         attr->xattri_dela_state =
> > > > xfs_attr_init_replace_state(args);
> > > >                 else
> > > >                         attr->xattri_dela_state =
> > > > xfs_attr_init_add_state(args);
> > > >                 break;
> > > > 
> > > > Which will leave the state unset if the fork is absent.
> > > 
> > > Yeah, OK, I think this is because we are combining attribute
> > > creation with inode creation. When log recovery replays inode core
> > > modifications, it replays the inode state into the cluster buffer
> > > and writes it. Then when we go to replay the attr intent at the end
> > > of recovery, the inode is read from disk via xlog_recover_iget(),
> > > but we don't initialise the attr fork because ip->i_forkoff is
> > > zero.
> > > i.e. it has no attrs at this point.
> > > 
> > > I suspect that we could catch that in xlog_recover_iget() when it
> > > is
> > > called from attr recovery. i.e. we detect newly created inodes and
> > > initialise the attr fork similar to what we do in
> > > xfs_init_new_inode(). I was thinking something like this:
> > > 
> > > 	if (init_xattrs && xfs_has_attr(mp)) {
> > > 		if (!ip->i_forkoff && !ip->i_nextents) {
> > > 			ip->i_forkoff = xfs_default_attroffset(ip) >>
> > > 3;
> > > 			ip->i_afp =
> > > xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > > 		} else {
> > > 			ASSERT(ip->i_afp);
> > > 		}
> > > 	}
> > > 
> > > Would do the trick, but then I realised that the timing/ordering is
> > > very different to runtime: we don't replay the attr intent until
> > > the
> > > end of log recovery and all the inode changes have been replayed
> > > into the inode cluster buffer. That means we could have already
> > > replayed a bunch of data fork extent modifications into the inode,
> > > and so the default attr offset is almost certainly not a safe thing
> > > to be using here. Indeed, there might not be space in the inode for
> > > the attr we want to insert and so we might need to convert the data
> > > fork to a different format before we run the attr intent replay.
> > 
> > Ok, so after further thought, I don't think this can happen. If we
> > are replaying an attr intent, it means we crashed before the intent
> > done was recorded in the log. At this point in time the inode was
> > locked and so there could be no racing changes to the inode data
> > fork in the log. i.e. because of log item ordering, if the intent
> > done is not in the log, none of the future changes that occurred
> > after the intent done will be in the log, either. The inode on disk
> > will not contain them either because the intent done must be in the
> > log before the inode gets unpinned and is able to be written to
> > disk.
> > 
> > Hence if we've got an attr intent to replay, it must be the last
> > active modification to that inode that must be replayed, and the
> > state of the inode on disk at the time of recovering the attr intent
> > should match the state of the inode in memory at the time the attr
> > intent was started.
> > 
> > Hence there isn't a consistency model coherency problem here, and
> > that means if there's no attr fork at the time the attr recovery is
> > started, it *must* be a newly created inode. If the inode already
> > existed and a transaction had to be run to create the attr fork
> > (i.e. xfs_bmap_add_attrfork() had to be run) then that transaction
> > would have been recovered from the log before attr replay started,
> > and so xlog_recovery_iget() should see a non-zero ip->i_forkoff and
> > initialise the attr fork correctly.
> > 
> > But this makes me wonder further. If the attr intent is logged in
> > the same transaction as the inode is allocated, then the setting of
> > ip->i_forkoff in xfs_init_new_inode() should also be logged in that
> > transaction (because XFS_ILOG_CORE is used) and hence be replayed
> > into the on-disk inode by recovery before the attr intent recovery
> > starts. Hence xlog_recover_iget() should be initialising the attr
> > fork through this path:
> > 
> > xlog_recover_iget
> >   xfs_iget
> >     xfs_iget_cache_miss
> >       xfs_inode_from_disk
> > 	if (ip->i_forkoff)
> > 	  xfs_iformat_attr_fork()
> > 
> > This means the newly allocated inode would have an attr fork
> > allocated to it, in extent format with zero extents. If we then look
> > at xfs_inode_hasattr():
> > 
> > int
> > xfs_inode_hasattr(
> >         struct xfs_inode        *ip)
> > {
> >         if (!XFS_IFORK_Q(ip))
> >                 return 0;
> >         if (!ip->i_afp)
> >                 return 0;
> > > > > > >   if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> > > > > > >       ip->i_afp->if_nextents == 0)
> > > > > > >           return 0;
> >         return 1;
> > }
> > 
> > It would still say that it has no attrs even though the fork has
> > been initialised and we go down the xfs_attr_init_add_state()
> > branch.  This does:
> > 
> > static inline enum xfs_delattr_state
> > xfs_attr_init_add_state(struct xfs_da_args *args)
> > {
> >         /*
> >          * When called from the completion of a attr remove to
> > determine the
> >          * next state, the attribute fork may be null. This can occur
> > only occur
> >          * on a pure remove, but we grab the next state before we
> > check if a
> >          * replace operation is being performed. If we are called
> > from any other
> >          * context, i_afp is guaranteed to exist. Hence if the attr
> > fork is
> >          * null, we were called from a pure remove operation and so
> > we are done.
> >          */
> > > > > >    if (!args->dp->i_afp)
> > > > > >            return XFS_DAS_DONE;
> > 
> >         args->op_flags |= XFS_DA_OP_ADDNAME;
> >         if (xfs_attr_is_shortform(args->dp))
> >                 return XFS_DAS_SF_ADD;
> >         if (xfs_attr_is_leaf(args->dp))
> >                 return XFS_DAS_LEAF_ADD;
> >         return XFS_DAS_NODE_ADD;
> > }
> > 
> > Which would return XFS_DAS_DONE if there was no attr fork
> > initialised and recovery would be skipped completely. Hence for this
> > change to be required to trigger failures:
> > 
> > > > @@ -741,8 +741,8 @@ xfs_attr_set_iter(
> > > >             fallthrough;
> > > >     case XFS_DAS_SF_ADD:
> > > >             if (!args->dp->i_afp) {
> > > > -                   attr->xattri_dela_state =
> > > > XFS_DAS_CREATE_FORK;
> > > > -                   goto next_state;
> > > > +//                 attr->xattri_dela_state =
> > > > XFS_DAS_CREATE_FORK;
> > > > +//                 goto next_state;
> > > >             }
> > 
> > then it implies the only way we can get here is via a replace
> > operation that has removed the attr fork during the remove and we
> > hit this on the attr add. Yet, AFAICT, the attr fork does not get
> > removed when a replace operation is in progress.
> > 
> > Maybe there's a new bug introduced in the PP patchset that triggers
> > this - I'll do some more looking...
> > 
> > > > > This should avoid the need for parent pointers to ever need to
> > > > > run
> > > > > an extra transaction to create the attr fork. Hence, AFAICT,
> > > > > this
> > > > > new state to handle attr fork creation shouldn't ever be needed
> > > > > for
> > > > > parent pointers....
> > > > > 
> > > > > What am I missing?
> > > > > 
> > > > I hope the description helped?  I'll do some more poking around
> > > > too and
> > > > post back if I find anything else.
> > > 
> > > Yup, it most definitely helped. :)
> > > 
> > > You've pointed out something I had completely missed w.r.t. attr
> > > intent replay ordering against replay of data fork modifications.
> > > There's definitely an issue here, I think it might be a fundamental
> > > issue with the recovery mechanism (and not parent pointers), and I
> > > think we'll end up needing  something like this patch to fix it.
> > > Let me bounce this around my head for a bit...
> > 
> > In summary, after further thought this turns out not to be an issue
> > at all, so I'm back to "replace doesn't remove the attr fork, so
> > how does this happen?"....
> Just a follow up here...
> 
> So, I think what is happening is we are getting interleaved replays.
> When a parent changes, the parent pointer attribute needs to be
> updated.  But since this changes the attribute name, it cant be an attr
> replace.  So we queue up an attr set and then a remove (in xfs_rename).
> The test case sets the inject which starts a replay of a set and
> remove.  The set expands the leaf, and bounces out the EAGAIN
> into xfs_attri_item_recover.  We then fall into this error handling:
> 
>         ret = xfs_xattri_finish_update(attr,
> done_item);                        
>         if (ret == -EAGAIN)
> {                                                   
>                 /* There's more work to do, so add it to this
> transaction */    
>                 xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
> >xattri_list);
>         }
> 
> Which I think is queuing up the rest of the set operation, but on the
> other side of the remove operation.  The remove operation removes the
> fork, and we get the null pointer when the set operation resumes.
> 
> I havnt quite worked out a fix yet, but I'm pretty sure that's the
> problem description....  I think what we're going to need is some sort
> of defer_push operation or something similar.

Hm.  To summarize (poorly) a conversation we had on IRC, I guess the
problem here is that xfs_rename logs both an attr-set and an attr-remove
log item to a rename transaction.  Then log recovery finds both, starts
the first step of the attr-set, and we capture-and-commit the rest of
the chain.  Next it recovers the the attr-remove, starts the first step
of /that/ (which clobbers the attr fork) and capture-and-commits that.
Finally, we continue the attr-set, which promptly barfs because the attr
fork disappeared on it!

So I guess this is a gaping hole in how log recovery works because we
don't write enough information into the log intent items to be able to
reconstruct the full defer ops chains that were attached to a
transaction.  If we could do that, then we'd know that there exists a
data dependency between the set and the remove such that we must finish
the entire set chain before moving on to the remove chain.

However, we don't know this.  Thus far in the lifespan of defer ops, I
think we've been careful/lucky enough that we've never had this problem,
and reworking the log format to encode transaction chain details is
quite a lot of work.

---

A second thought -- the xattri log recovery routine recreates the defer
ops state, logs an xattrd for the recovered item, takes one step in the
state machine, and uses capture-and-commit to defer any more steps to a
later time.  What if instead the recovery routine didn't take that extra
step?  If all it did was recreate the incore defer ops state and
deferred everything else to xlog_finish_defer_ops, the attr set and attr
remove recoveries would not overlap and trip over each other.

Maybe a POC would be to have the _recover function log the xattrd for
the recovered log item and call xfs_defer_ops_capture_and_commit without
actually bothering with xfs_attri_finish_update?  Something like this?

	xfs_init_attr_trans(args, &tres, &total);
	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE,
			&tp);
	if (error)
		goto out;

	args->trans = tp;
	done_item = xfs_trans_get_attrd(tp, attrip);

	xfs_ilock(ip, XFS_ILOCK_EXCL);
	xfs_trans_ijoin(tp, ip, 0);

	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
	if (error)
		goto out_unlock;

	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	xfs_irele(ip);
	return 0;

---

A third thought I had for solving this problem would be to extend the
xattr log format to be able to record a "rename and rewrite" operation.
I only suggest this because directory online repair currently works by
creating a temporary file, using the regular xfs_dir_createname function
to build the directory structures (without touching the children) and
then uses swapext to exchange the directory structure blocks.  When
parent pointers come along, I guess we'll have to figure out how to
insert dirents at specific offsets, or we'll have to figure out how to
update all the parent pointers atomically.  Yuck.

While a "rename and reset" xattr op would work here, I suppose the
online repair case is a lot simpler -- it never needs to update the
dirent name, so all we really have to do is rewrite the xattr key,
remove the dabtree hash mapping, and insert a new one.

Hmm ok I'm going to go eat dinner and think about my second suggestion
tomorrow.

--D

> Allison
> 
> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
