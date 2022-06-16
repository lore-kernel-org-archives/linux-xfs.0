Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37900C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 02:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350614AbiFPCKA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 22:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358702AbiFPCJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 22:09:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BC155BE71
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 19:08:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E1CF010E73D2;
        Thu, 16 Jun 2022 12:08:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1ew7-007AFM-Q8; Thu, 16 Jun 2022 12:08:43 +1000
Date:   Thu, 16 Jun 2022 12:08:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
Message-ID: <20220616020843.GA227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-2-allison.henderson@oracle.com>
 <20220615010932.GZ227878@dread.disaster.area>
 <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62aa90ae
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=rfNG3RjGYYg0x7r1vJkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 15, 2022 at 04:40:07PM -0700, Alli wrote:
> On Wed, 2022-06-15 at 11:09 +1000, Dave Chinner wrote:
> > On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson wrote:
> > > Recent parent pointer testing has exposed a bug in the underlying
> > > larp state machine.  A replace operation may remove an old attr
> > > before adding the new one, but if it is the only attr in the fork,
> > > then the fork is removed.  This later causes a null pointer in
> > > xfs_attr_try_sf_addname which expects the fork present.  This
> > > patch adds an extra state to create the fork.
> > 
> > Hmmmm.
> > 
> > I thought I fixed those problems - in xfs_attr_sf_removename() there
> > is this code:
> > 
> >         if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp)
> > &&
> >             (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> >             !(args->op_flags & (XFS_DA_OP_ADDNAME |
> > XFS_DA_OP_REPLACE))) {
> >                 xfs_attr_fork_remove(dp, args->trans);
> Hmm, ok, let me shuffle in some traces around there to see where things
> fall off the rails
> 
> > 
> > A replace operation will have XFS_DA_OP_REPLACE set, and so the
> > final remove from a sf directory will not remove the attr fork in
> > this case. There is equivalent checks in the leaf/node remove name
> > paths to avoid removing the attr fork if the last attr is removed
> > while the attr fork is in those formats.
> > 
> > How do you reproduce this issue?
> > 
> 
> Sure, you can apply this kernel set or download it here:
> https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrs
> 
> Next you'll need this xfsprogs that has the neccassary updates to run
> parent pointers
> https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs
> 
> 
> To reproduce the bug, you'll need to apply a quick patch on the kernel
> side:
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b86188b63897..f279afd43462 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -741,8 +741,8 @@ xfs_attr_set_iter(
>  		fallthrough;
>  	case XFS_DAS_SF_ADD:
>  		if (!args->dp->i_afp) {
> -			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> -			goto next_state;
> +//			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
> +//			goto next_state;
>  		}

Ah, so it's recovery that trips this....

> [  365.290048]  xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
> [  365.290423]  xfs_attr_set_iter+0x2f9/0x1510 [xfs]
> [  365.291592]  xfs_xattri_finish_update+0x66/0xd0 [xfs]
> [  365.292008]  xfs_attr_finish_item+0x43/0x120 [xfs]
> [  365.292410]  xfs_defer_finish_noroll+0x3c2/0xcc0 [xfs]
> [  365.293196]  __xfs_trans_commit+0x333/0x610 [xfs]
> [  365.294401]  xfs_trans_commit+0x10/0x20 [xfs]
> [  365.294797]  xlog_finish_defer_ops+0x133/0x270 [xfs]
> [  365.296054]  xlog_recover_process_intents+0x1f7/0x3e0 [xfs]

ayup.

> > > Additionally the new state will be used by parent pointers which
> > > need to add attributes to newly created inodes that do not yet
> > > have a fork.
> > 
> > We already have the capability of doing that in xfs_init_new_inode()
> > by passing in init_xattrs == true. So when we are creating a new
> > inode with parent pointers enabled, we know that we are going to be
> > creating an xattr on the inode and so we should always set
> > init_xattrs in that case.
> Hmm, ok.  I'll add some tracing around in there too, if I back out the
> entire first patch, we crash out earlier in recovery path because no
> state is set.  If we enter xfs_attri_item_recover with no fork, we end
> up in the following switch:
> 
> 
>         case XFS_ATTRI_OP_FLAGS_REPLACE:
>                 args->value = nv- >value.i_addr;
>                 args->valuelen = nv- >value.i_len;
>                 args->total = xfs_attr_calc_size(args, &local);
>                 if (xfs_inode_hasattr(args- >dp))
>                         attr->xattri_dela_state = xfs_attr_init_replace_state(args);
>                 else
>                         attr->xattri_dela_state = xfs_attr_init_add_state(args);
>                 break;
> 
> Which will leave the state unset if the fork is absent.

Yeah, OK, I think this is because we are combining attribute
creation with inode creation. When log recovery replays inode core
modifications, it replays the inode state into the cluster buffer
and writes it. Then when we go to replay the attr intent at the end
of recovery, the inode is read from disk via xlog_recover_iget(),
but we don't initialise the attr fork because ip->i_forkoff is zero.
i.e. it has no attrs at this point.

I suspect that we could catch that in xlog_recover_iget() when it is
called from attr recovery. i.e. we detect newly created inodes and
initialise the attr fork similar to what we do in
xfs_init_new_inode(). I was thinking something like this:

	if (init_xattrs && xfs_has_attr(mp)) {
		if (!ip->i_forkoff && !ip->i_nextents) {
			ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
			ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
		} else {
			ASSERT(ip->i_afp);
		}
	}

Would do the trick, but then I realised that the timing/ordering is
very different to runtime: we don't replay the attr intent until the
end of log recovery and all the inode changes have been replayed
into the inode cluster buffer. That means we could have already
replayed a bunch of data fork extent modifications into the inode,
and so the default attr offset is almost certainly not a safe thing
to be using here. Indeed, there might not be space in the inode for
the attr we want to insert and so we might need to convert the data
fork to a different format before we run the attr intent replay.

That does indeed take us down the path of needing to run a full attr
fork creation operation, because we aren't creating the parent attr
when the data fork is empty in recovery. i.e. recovery is changing
the temporal order of data fork vs attr operations because intent
recovery uses an eventual consistency model rather than the
immediate consistency model that runtime uses.

Hmmmm. I'm going to have to have a think about the implications of
that relevation. I think it does mean we need recovery to be able to
run an attr fork initialisation, but I suspect it also means that
the runtime fork initialisation might also need to include it, too.

I'll need to think on this a bit.

> > This should avoid the need for parent pointers to ever need to run
> > an extra transaction to create the attr fork. Hence, AFAICT, this
> > new state to handle attr fork creation shouldn't ever be needed for
> > parent pointers....
> > 
> > What am I missing?
> > 
> I hope the description helped?  I'll do some more poking around too and
> post back if I find anything else.

Yup, it most definitely helped. :)

You've pointed out something I had completely missed w.r.t. attr
intent replay ordering against replay of data fork modifications.
There's definitely an issue here, I think it might be a fundamental
issue with the recovery mechanism (and not parent pointers), and I
think we'll end up needing  something like this patch to fix it.
Let me bounce this around my head for a bit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
