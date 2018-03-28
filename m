Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:47688 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751096AbeC1Dcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 23:32:33 -0400
Date: Wed, 28 Mar 2018 14:32:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180328033228.GA18129@dastard>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Sasha Levin <alexander.levin@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Mon, Mar 26, 2018 at 07:54:31PM -0400, Sasha Levin wrote:
> On Sun, Mar 25, 2018 at 6:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Mar 23, 2018 at 06:23:02PM +0000, Luis R. Rodriguez wrote:
> >> On Fri, Mar 23, 2018 at 10:26:20AM -0700, Darrick J. Wong wrote:
> >> > On Fri, Mar 23, 2018 at 05:08:13PM +0000, Luis R. Rodriguez wrote:
> >> > > On Thu, Mar 22, 2018 at 08:41:45PM -0700, Darrick J. Wong wrote:
> >> > > > On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> >> > > > > On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> >> > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> > > > > > index 61d1cb7..8012741 100644
> >> > > > > > --- a/fs/xfs/xfs_inode.c
> >> > > > > > +++ b/fs/xfs/xfs_inode.c
> >> > > > > > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> >> > > > > >  }
> >> > > > > >
> >> > > > > >  /*
> >> > > > > > + * Free any local-format buffers sitting around before we reset to
> >> > > > > > + * extents format.
> >> > > > > > + */
> >> > > > > > +static inline void
> >> > > > > > +xfs_ifree_local_data(
> >> > > > > > +   struct xfs_inode        *ip,
> >> > > > > > +   int                     whichfork)
> >> > > > > > +{
> >> > > > > > +   struct xfs_ifork        *ifp;
> >> > > > > > +
> >> > > > > > +   if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> >> > > > > > +           return;
> >> > > > >
> >> > > > > I'm new to all this so this was a bit hard to follow. I'm confused with how
> >> > > > > commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> >> > > > > inode fork") exacerbated the leak, isn't that commit about
> >> > > > > XFS_DINODE_FMT_EXTENTS?
> >> > > >
> >> > > > Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
> >> > > > incore data was small enough to fit in if_inline_ata.
> >> > >
> >> > > Got it, I thought those were XFS_DINODE_FMT_EXTENTS by definition.
> >> > >
> >> > > > > Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> >> > > > > ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?
> >> > > >
> >> > > > An empty directory is 6 bytes, which is what you get with a fresh mkdir
> >> > > > or after deleting everything in the directory.  Prior to the 43518812d2
> >> > > > patch we could get away with not even checking if we had to free if_data
> >> > > > when deleting a directory because it fit within if_inline_data.
> >> > >
> >> > > Ah got it. So your fix *is* also applicable even prior to commit 43518812d2.
> >> >
> >> > You'd have to modify the patch so that it doesn't try to kmem_free
> >> > if_data if if_data == if_inline_data but otherwise (in theory) I think
> >> > that the concept applies to pre-4.15 kernels.
> >> >
> >> > (YMMV, please do run this through QA/kmemleak just in case I'm wrong, etc...)
> >>
> >> Well... so we need a resolution and better get testing this already given that
> >> *I believe* the new auto-selection algorithm used to cherry pick patches onto
> >> stable for linux-4.14.y (covered on a paper [0] and when used, stable patches
> >> are prefixed with AUTOSEL, a recent discussion covered this in November 2017
> >> [1]) recommended to merge your commit 98c4f78dcdd8 ("xfs: always free inline
> >> data before resetting inode fork during ifree") as stable commit 1eccdbd4836a41
> >> on v4.14.17 *without* merging commit 43518812d2 ("xfs: remove support for
> >> inlining data/extents into the inode fork").
> >
> > Yikes. That sets off all my "how to break filesysetms for fun and
> > profit" alarm bells. This is like playing russian roulette with all
> > our user's data.  XFS fixes that look like they are simple often
> > have subtle dependencies in them that automated backports won't ever
> > be able to understand, and if we don't get that right, we break
> > stuff.
> 
> On the other hand, XFS has a few commits that fix possible
> corruptions, that have never ended up in a stable tree. Isn't it just
> as bad ("playing roulette") for users?

No, because most corruption problems we fix are rarely seen by
users. Those that are seen or considered a significant risk are
backported as per the usual process. What we don't do is shovel
things that *look like fixes* back in older kernels.

This is the third time in recent weeks where I've had to explain
this. e.g:

https://marc.info/?l=linux-xfs&m=152103080002315&w=2

And note Christoph's followup:
https://marc.info/?l=linux-xfs&m=152103175702634&w=2

What's important to note is that the discussion in that thread lead
to the patch being backported, validated and then included in Greg's
stable tree.

Validating that backports to all the stable kernels is effectively a
full time job in itself, and we simply don't have enough upstream
developer resources available to do that. So it's a simple: if we
don't have the resources to validate changes properly, then we
*don't change the code*.

....

> >> I do wonder if other XFS folks are *at least* aware that the auto-selection
> >> algorithm now currently merging patches onto stable for XFS?
> >
> > No I wasn't aware that this was happening.  I'm kinda shit scared
> > right now hearing about how automated backports of random kernel
> > patches are being done with minimal oversight and no visibility to
> > the subsystem developers. When did this start happening?
> 
> About half a year ago. I'm not sure about the no visibility part -
> maintainers and authors would receive at least 3 mails for each patch
> that got in this way, and would have at least a week (usually a lot
> more) to object to the inclusion. Did you not receive any mails from
> me?

I'm not the XFS maintainer (haven't been for 18 months now), I don't
subscribe to LKML anymore and none of my patches were selected for
backports. So, no, I had no idea this was going on.

> I've started working on a framework to automate reviews of sent
> patches to lkml by my framework, this will allow me to do the
> following:
> 
>  - I would send a reply to the original patch sent to LKML within a
> few hours for patches that have a high probability for being a bug fix
> rather than sending a brand new mail a few months after this patch
> made it upstream. This will help reviews as this commit is still fresh
> in the author+maintainers head.
>  - I will include the results of builds for various build testing (I
> got that working now). At this point I suspect this will mostly help
> Greg with patches that are already sent with stable tags.
>  - This will turn into an opt-in rather than opt-out, but it will be
> extremely easy to opt in (something like replying with "ack" to have
> that patch included in the proposed stable branches).
>  - In the future, I'd also like to create a per-subsystem testing
> procedure (so for example, for xfs - run xfstest). I'll try working
> with maintainers of each subsystem to create something they're happy
> with. Given this discussion, I'll make XFS my first attempt at this :)

How much time are your test rigs going to be able to spend running
xfstests? A single pass on a single filesysetm config on spinning
disks will take 3-4 hours of run time. And we have at least 4 common
configs that need validation (v4, v4 w/ 512b block size, v5
(defaults), and v5 w/ reflink+rmap) and so you're looking at a
minimum 12-24 hours of machine test time per kernel you'd need to
test.

And that's just for XFS. There's the same sort of basic
configuration matrix test for ext4 (Ted does it via kvm-xfstests on
GCE which, IIRC takes about 20 hours to run) and btrfs has similar
test requirements. Then there's f2fs, overlay, etc.

You can probably start to see the scope of the validation problem
stable kernels pose, and this is just for filesystem changes....

> The mails will look something like this (an example based on a recent
> XFS commit):
> 
> > From: Sasha Levin <alexander.levin@microsoft.com>
> > To: Sasha Levin <alexander.levin@microsoft.com>
> > To: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>
> > Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
> > In-Reply-To: <20180306102638.25322-1-vbendel@redhat.com>
> > References: <20180306102638.25322-1-vbendel@redhat.com>
> >
> > Hi Vratislav Bendel,
> >
> > [This is an automated email]
> >
> > This commit has been processed by the -stable helper bot and determined
> > to be a high probability candidate for -stable trees. (score: 6.4845)
> >
> > The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v4.4.123, v4.1.50, v3.18.101.
> >
> > v4.15.12: OK!
> > v4.14.29: OK!
> > v4.9.89: OK!
> > v4.4.123: OK!
> > v4.1.50: OK!
> > v3.18.101: OK!
> >
> > Please reply with "ack" to have this patch included in the appropriate stable trees.

That might help, but the testing and validation is completely
opaque. If I wanted to know what that "OK!" actually meant, where
do I go to find that out?

> If you look at the recent history for fs/xfs, there were no commits in
> the past half a year or so that were submitted to any stable tree in
> the "traditional" way. There are no XFS fixes in the 4.14 LTS tree
> besides the ones submitted with the autoselection method. This is not
> finger pointing at XFS, but rather at the -stable process itself.

It's not a reflection on the -stable process, it's a reflection on
the amount of work validation of filesystem changes require. If we
decide to do backports, the -stable process will work just fine for
the mechanical code movement into the stable trees. It's all the
extra stuff before and after that movement occurs that incurs the
resource costs.

> It's
> difficult to keep track on which branches authors need to test their
> patches on, what sort of tests they need to do, and how they should
> tag their commits. In quite a few cases the effort to properly tag a
> commit for stable takes more effort that writing the code for that
> commit, which deters people from working with stable.

See the link I posted above - I explicitly address the overhead
involved in adding "fixes" tags and identifying backport targets.
And even without the overhead of having to add "fixes" tags, the
broader point I'm making about effectively random selection of
commits for backports is very relevant to the auto-backport magic
we've just learnt about...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
