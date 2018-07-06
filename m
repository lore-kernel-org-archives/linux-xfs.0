Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbeGFArx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 20:47:53 -0400
Date: Thu, 5 Jul 2018 17:47:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/21] xfs: repair the rmapbt
Message-ID: <20180706004637.GI32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986827881.3155.10096839660329617215.stgit@magnolia>
 <20180703053200.GH2234@dastard>
 <20180703235901.GY32415@magnolia>
 <20180704232115.GP2234@dastard>
 <20180705034858.GH32415@magnolia>
 <20180705070324.GQ2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180705070324.GQ2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 05, 2018 at 05:03:24PM +1000, Dave Chinner wrote:
> On Wed, Jul 04, 2018 at 08:48:58PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 05, 2018 at 09:21:15AM +1000, Dave Chinner wrote:
> > > On Tue, Jul 03, 2018 at 04:59:01PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jul 03, 2018 at 03:32:00PM +1000, Dave Chinner wrote:
> > > Keep in mind that online repair will never guarantee that it can fix
> > > all problems, so we're always going to have to offline repair. iWhat
> > > we want to achieve is minimising downtime for users when a repair is
> > > required. With the above IO limitations in mind, I've always
> > > considered that online repair would just be for all the simple,
> > > quick, easy to fix stuff, because complex stuff that required huge
> > > amounts of RAM and full filesystem scans to resolve would always be
> > > done faster offline.
> > >
> > > That's why I think that offline repair will be a better choice for
> > > users for the forseeable future if repairing the damage requires
> > > full filesystem metadata scans.
> > 
> > That might be, but how else can we determine that than to merge it under
> > an experimental banner, iterate it for a while, and try to persuade a
> > wider band of users than ourselves to try it on a non-production system
> > to see if it better solves their problems? :)
> 
> I think "deploy and idea to users and see if they have problems" is
> a horrible development model. That's where btrfs went off the rails
> almost 10 years ago....

I would only test-deploy to a very small and carefully selected group of
tightly-controlled internal users.  For everyone else, it hides behind a
default=N kconfig option and we disavow any support of EXPERIMENTAL
features. :)

> That aside, I'd like to make sure we're on the same page - we don't
> need online repair to fix /everything/ before it gets merged. Even

Indeed.  I'm fine with it merging the non-freezing repairers in their
current form.  I regularly run the repair tool fuzz xfstests to compare
the effectiveness of the xfs_scrub / xfs_repair.  They both have
deficiencies here and there, which will keep us busy for years to come.
:P

> without rmap rebuild, it will still be usable and useful to the vast
> majority of users wanting the filesystem to self repair the typical
> one-off corruption problems filesystems encounter during their
> typical production life.
> 
> What I'm worried about is that the online repair algorithms have a
> fundmental dependence on rmap lookups to avoid the need to build the
> global cross-references needed to isolate and repair corruptions.

Yes, the primary metadata repairers are absolutely dependent on the
secondary data to be faster than a full scan, and repairing secondary
metadata was never going to be easy to do online.

> This use of rmap, from one angle, can be seen as a performance
> optimisation, but as I've come understand more of the algorithms the
> online repair code uses, it looks more like an intractable problem
> than one of performance optimisation.
> 
> That is, if the rmap is corrupt, or we even suspect that it's
> corrupt, then we cannot use it to validate the state and contents of
> the other on-disk structures. We could propagate rmap corruptions to
> those other structures and it would go undetected. And because we
> can't determine the validity of all the other structures, the only
> way we can correctly repair the filesystem is to build a global
> cross-reference, resolve all the inconsistencies, and then rewrite
> all the structures. i.e. we need to do what xfs_repair does in phase
> 3, 4 and 5.
> 
> IOWs, ISTM that the online scrub/repair algorithms break down in the
> face of rmap corruption and it is correctable only by building a
> global cross-reference which we can then reconcile and use to
> rebuild all the per-AG metadata btrees in the filesystem. Trying to
> do it online via scanning of unverifiable structures risks making
> the problem worse and there is a good possibility that we can't
> repair the inconsistencies in a single pass.

Yeah.  I've pondered whether or not the primary repairers ought to
require at least a quick rmap scan before they touch anything, but up
till now I've preferred to keep that knowledge in xfs_scrub.

> So at this point, I'd prefer that we stop, discuss and work out a
> solution to the rmap rebuild problem rather than merge a rmap
> rebuild algorithm prematurely. This doesn't need to hold up any of
> the other online repair functionality - none of that is dependent on
> this particular piece of the puzzle being implemented.

I didn't think it would hold up the others repairers.  I always knew
that the rmapbt repair was going to be a tough project. :)

So, seeing as you're about to head off on vacation, let's set a rough
time to discuss the rmap rebuild problem in detail once you're back.
Does that sound good?

> > At worst, if future us decide that we will never figure out how to make
> > online rmapbt repair robust I'm fully prepared to withdraw it.
> 
> Merging new features before sorting out the fundamental principles,
> behaviours and algorithms of those features is how btrfs ended up
> with a pile of stuff that doesn't quite work which no-one
> understands quite well enough to fix.

Ok ok it can stay out of tree until we're all fairly confident it'll
survive on our bombardment tests.  I do have a test, xfs/422, to
simulate repairing an rmapbt under heavy load by running fsstress,
fsfreeze, and xfs_io injecting and force-repairing rmapbts in a loop.
So far it hasn't blown up or failed to regenerate the rmapbt...

> > > > > This seems like a likely thing to happen given the "no reclaim"
> > > > > state of the filesystem and the memory demand a rmapbt rebuild
> > > > > can have. If we've got GBs of rmap info in the AG that needs to be
> > > > > rebuilt, how much RAM are we going to need to index it all as we
> > > > > scan the filesystem?
> > > > 
> > > > More than I'd like -- at least 24 bytes per record (which at least is no
> > > > larger than the size of the on-disk btree) plus a list_head until I can
> > > > move the repairers away from creating huge lists.
> > > 
> > > Ok, it kinda sounds a bit like we need to be able to create the new
> > > btree on the fly, rather than as a single operation at the end. e.g.
> > > if the list builds up to, say, 100k records, we push them into the
> > > new tree and can free them. e.g. can we iteratively build the new
> > > tree on disk as we go, then do a root block swap at the end to
> > > switch from the old tree to the new tree?
> > 
> > Seeing as we have a bunch of storage at our disposal, I think we could
> > push the records out to disk (or just write them straight into a new
> > btree) when we detect low memory conditions or consume more than some
> > threshold of memory. i
> 
> *nod* That's kinda along the lines of what I was thinking of.
> 
> > For v0 I was focusing on getting it to work at all
> > even with a largeish memory cost. :)
> 
> Right, I'm not suggesting that this needs to be done before the
> initial merge - I just want to make sure we don't back ourselves
> into a corner we can't get out of.

Agreed.  I don't want to get stuck in a corner either, but I don't know
that I know where all those corners are. :)

> > > If that's a potential direction, then maybe we can look at this as a
> > > future direction? It also leads to the posibility of
> > > pausing/continuing repair from where the last chunk of records were
> > > processed, so if we do run out of memory we don't have to start from
> > > the beginning again?
> > 
> > That could be difficult to do in practice -- we'll continue to
> > accumulate deferred frees for that AG in the meantime.
> 
> I think it depends on the way we record deferred frees, but it's a
> bit premature to be discussing this right now :P

<nod>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
