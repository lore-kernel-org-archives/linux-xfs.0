Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752116AbeCZRj7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 13:39:59 -0400
Date: Mon, 26 Mar 2018 17:39:56 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180326173956.GD9190@wotan.suse.de>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180324090638.GB1170@kroah.com>
 <20180324172159.GR4818@magnolia>
 <20180326045241.GA3394@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326045241.GA3394@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <Alexander.Levin@microsoft.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Mon, Mar 26, 2018 at 04:54:59AM +0000, Sasha Levin wrote:
> On Sat, Mar 24, 2018 at 10:21:59AM -0700, Darrick J. Wong wrote:
> >On Sat, Mar 24, 2018 at 10:06:38AM +0100, Greg Kroah-Hartman wrote:
> >> On Fri, Mar 23, 2018 at 06:23:02PM +0000, Luis R. Rodriguez wrote:
> >> > On Fri, Mar 23, 2018 at 10:26:20AM -0700, Darrick J. Wong wrote:
> >> > > On Fri, Mar 23, 2018 at 05:08:13PM +0000, Luis R. Rodriguez wrote:
> >> > > > On Thu, Mar 22, 2018 at 08:41:45PM -0700, Darrick J. Wong wrote:
> >> > > > > On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> >> > > > > > On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> >> > > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> > > > > > > index 61d1cb7..8012741 100644
> >> > > > > > > --- a/fs/xfs/xfs_inode.c
> >> > > > > > > +++ b/fs/xfs/xfs_inode.c
> >> > > > > > > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> >> > > > > > >  }
> >> > > > > > >
> >> > > > > > >  /*
> >> > > > > > > + * Free any local-format buffers sitting around before we reset to
> >> > > > > > > + * extents format.
> >> > > > > > > + */
> >> > > > > > > +static inline void
> >> > > > > > > +xfs_ifree_local_data(
> >> > > > > > > +	struct xfs_inode	*ip,
> >> > > > > > > +	int			whichfork)
> >> > > > > > > +{
> >> > > > > > > +	struct xfs_ifork	*ifp;
> >> > > > > > > +
> >> > > > > > > +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> >> > > > > > > +		return;
> >> > > > > >
> >> > > > > > I'm new to all this so this was a bit hard to follow. I'm confused with how
> >> > > > > > commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> >> > > > > > inode fork") exacerbated the leak, isn't that commit about
> >> > > > > > XFS_DINODE_FMT_EXTENTS?
> >> > > > >
> >> > > > > Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
> >> > > > > incore data was small enough to fit in if_inline_ata.
> >> > > >
> >> > > > Got it, I thought those were XFS_DINODE_FMT_EXTENTS by definition.
> >> > > >
> >> > > > > > Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> >> > > > > > ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?
> >> > > > >
> >> > > > > An empty directory is 6 bytes, which is what you get with a fresh mkdir
> >> > > > > or after deleting everything in the directory.  Prior to the 43518812d2
> >> > > > > patch we could get away with not even checking if we had to free if_data
> >> > > > > when deleting a directory because it fit within if_inline_data.
> >> > > >
> >> > > > Ah got it. So your fix *is* also applicable even prior to commit 43518812d2.
> >> > >
> >> > > You'd have to modify the patch so that it doesn't try to kmem_free
> >> > > if_data if if_data == if_inline_data but otherwise (in theory) I think
> >> > > that the concept applies to pre-4.15 kernels.
> >> > >
> >> > > (YMMV, please do run this through QA/kmemleak just in case I'm wrong, etc...)
> >> >
> >> > Well... so we need a resolution and better get testing this already given that
> >> > *I believe* the new auto-selection algorithm used to cherry pick patches onto
> >> > stable for linux-4.14.y (covered on a paper [0] and when used, stable patches
> >> > are prefixed with AUTOSEL, a recent discussion covered this in November 2017
> >> > [1]) recommended to merge your commit 98c4f78dcdd8 ("xfs: always free inline
> >> > data before resetting inode fork during ifree") as stable commit 1eccdbd4836a41
> >> > on v4.14.17 *without* merging commit 43518812d2 ("xfs: remove support for
> >> > inlining data/extents into the inode fork").
> >> >
> >> > Sasha, Greg,
> >> >
> >> > Can you confirm if the algorithm was used in this case?
> >>
> >> No idea.
> >>
> >> I think xfs should just be added to the "blacklist" so that it is not
> >> even looked at for these types of auto-selected patches.  Much like the
> >> i915 driver currently is handled (it too is ignored for these patches
> >> due to objections from the maintainers of it.)
> >
> >Just out of curiosity, how does this autoselection mechanism work today?
> >If it's smart enough to cherry pick patches, apply them to a kernel,
> >build the kernel and run xfstests, and propose the patches if nothing
> >weird happened, then I'd be interested in looking further.  I've nothing
> >against algorithmic selection per se, but I'd want to know more about
> >the data sets and parameters that feed the algorithm.
> 
> It won't go beyond build testing.

This is one area where we can improve things.

Perhaps the typical use case for the kernel for looking for stable fixes is to
groom for good candidate fixes using some heuristics, test compile and if there
is no issue merge. It would be not so different than a human using their own
experience of some sort using a pattern to do the same. However the big
difference for filesystems is we *need* proper testing.

The issue with filesystems is the consequence of a bug are much more severe
than just a panic. Any corner case issue can really be much more critical than
just crashing a system. Ruining your filesystem is simply unforgivable,
specially if all that was missing was a proper regression test, and we already
have infrastructure for it.

The good news is that we have proper a proper testing suite to help out, and as
per my inspection 0-day already embraces a few tests. We can do a bit more here
for expanding on these... but also use a baseline for testing proposed XFS stable
fixes. For now I suggest a bit of manual work and I can volunteer to lead this
on, with a transparent mechanism to enable other folks to reproduce similar
testing in an easy way. I had in mind a mechanism to automate this long term,
and I started working on something, so I can use that to start this effort,
and publish what I have soon.

But that would not be enough, we need proper testing and careful oversight. I
can volunteer to review the patches manually (any others?) and if any questions
come up bring them up and check / verify with others.

The new autoselection truly is state of the art and we'd be silly to not
address corner cases for subsystems to help take advantage of the candidate
patches it provides. My inspection so far revealed only one possible issue
fix, that is not bad at all.

> >I did receive the AUTOSEL tagged patches a few days ago, but I couldn't
> >figure out what automated regression testing, if any, had been done; or
> >whether the patch submission was asking if we wanted it put into 4.14
> >or if it was a declaration that they were on their way in.  Excuse me
> 
> There would be (at least) 3 different mails involved in this process:
> 
>  1. You'd get a mail from me, proposing this patch for stable. We give
>  at least 1 week (but usually closer to 2) to comment on whether this
>  patch should or should not go in stable.
> 
>  2. If no objections were received, Greg would add it to his queue and
>  you'd get another mail about that.

Is there a temporary tree with all the patches already merged by any chance?
That would help with testing the queue of candidate fixes.

>  3. A few more days later, Greg would release that stable tree and you'd
>  get another mail.

What I propose is for XFS we add a few more steps:

1a. Ensure the fixes are in a temporary tree
1b. Add me to the list of reviewers
1c. I'll run some tests against it compared to a baseline which would be
    pre-established
1d. While the tests are running do a manual inspection of the patches
1e. Only if patches produce no regressions with the established baseline and get
    a Reviewed-by by at least one developer do we publish to stable

I can work on establishing the baseline with the community next.

> >for being behind the times, but I'd gotten accustomed xfs patches only
> >ending up in the stable kernels because we'd deliberately put them
> >there. :)
> >
> >If blacklisting xfs is more convenient then I'm happy to continue things
> >as they were.
> 
> No problem with blacklisting subsystems if maintainers prefer it that
> way, but the i915 case was slightly different as their development
> process was very quirky and testing was complex, so they asked to just
> keep doing their own selection for stable.

filesystems are the same -- the issue is the risk of an issue is much more
severe.

> However, looking at stable history, it seems that no patch from fs/xfs/
> was proposed for stable for about half a year now, which is something
> that the autoselection project is trying to help with.

Indeed. I have addressed the stable question on XFS in person with at the small
BoF at Vault last year, and with other folks later. The current process may
work for some... but I think we can do better and it just requires volunteers,
and I think using the auto-selection process to come up with *candidates* is a
great opportunity, specially in light of the patches I have seen so far already
merged.

My testing of them also proved no regressions (modulo I skipped the one I
pointed out on this thread.

> A different flow I'm working on for this is to send an email as a reply
> to the original patch submission to lkml if the patch is selected by the
> network, including details about which trees it was applied to and build
> results. I think it might work better for subsystems such as xfs.

We need testing. Without testing this cannot fly.

  Luis
