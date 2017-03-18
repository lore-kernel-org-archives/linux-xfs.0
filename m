Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4589 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750712AbdCRHpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Mar 2017 03:45:31 -0400
Date: Sat, 18 Mar 2017 18:38:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 V2] xfs: toggle readonly state around
 xfs_log_mount_finish
Message-ID: <20170318073835.GZ17542@dastard>
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
 <36942625-073a-56ba-4d31-cd9511f3bfb8@sandeen.net>
 <74f6a009-211c-617a-2d6f-0a115ceb366b@sandeen.net>
 <20170315113629.GA23221@bfoster.bfoster>
 <20170316191500.GL5280@birch.djwong.org>
 <20170316234249.GW17542@dastard>
 <900524f8-4f2d-17e7-31a8-ecde486acc50@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900524f8-4f2d-17e7-31a8-ecde486acc50@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 16, 2017 at 04:52:43PM -0700, Eric Sandeen wrote:
> On 3/16/17 4:42 PM, Dave Chinner wrote:
> > On Thu, Mar 16, 2017 at 12:15:00PM -0700, Darrick J. Wong wrote:
> >> On Wed, Mar 15, 2017 at 07:36:29AM -0400, Brian Foster wrote:
> >>> On Tue, Mar 14, 2017 at 06:23:57PM -0500, Eric Sandeen wrote:
> >>>> When we do log recovery on a readonly mount, unlinked inode
> >>>> processing does not happen due to the readonly checks in
> >>>> xfs_inactive(), which are trying to prevent any I/O on a
> >>>> readonly mount.
> >>>>
> >>>> This is misguided - we do I/O on readonly mounts all the time,
> >>>> for consistency; for example, log recovery.  So do the same
> >>>> RDONLY flag twiddling around xfs_log_mount_finish() as we
> >>>> do around xfs_log_mount(), for the same reason.
> >>>>
> >>>> This all cries out for a big rework but for now this is a
> >>>> simple fix to an obvious problem.
> >>>>
> >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>>> ---
> >>>>
> >>
> >> Both patches look ok, so I'll put them on the test queue for -rc4.
> >> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > FWIW, I don't think this is a -rc candidate. Making log recovery
> > process unlinked inode transactions on read-only mounts is a pretty
> > major change in behaviour. Who knows exactly what dragons are
> > lurking at lower layers that have never been run in this context
> > until now.
> > 
> > Also, it's not urgent - we've lived with this behaviour for years -
> > so waiting a month for the next merge window is not going to hurt
> > anyone and it gives us a chance to test it - XFS developers are the
> > people who should be burnt by the lurking dragons, not users who
> > updated to a late -rcX kernel....
> 
> To shield Darrick a bit ;) I was agitating/asking for sooner, but
> admittedly that was a little bit selfish on my part.
> 
> Still, we have had field reports of people with /gigabytes/ missing
> from the root filesystem, and it was not fixable without an 
> xfs_repair.  Which on a root filesystem is ... special.

That's information that should be in the commit message....

> So, my fault for getting it sent late, for sure - but I do think it's
> an important fix.  I know we can't really address the "unknown unknown"
> dragons easily, but actually completing recovery on RO mounts seems
> straightforward to me... we allow half of recovery to go, and
> disallow the other half.  Seems plainly broken.

I still don't think that makes it an urgent, immediate -rcX fix.  It
definitely makes it a fix that should go to stable kernels, but that
does not mean we should short-cut our integrationa nd testing
processes. If anything, it makes it far more important to ensure the
change is safe and well tested, because it's going to be distributed
to /everyone/ in the near future through the stable update process,
distros included.

As I've already said: rushing fixes upstream without adequate test
time is almost always the wrong thing to do. Call me conservative,
but I have plenty of scars to justify being careful about pushing
fixes too quickly.

I'm more worried about the impact on the unknown number of read-only
filesystems out there across the entire userbase that have the
potential to process inodes that have been sitting orphaned for
years than I am about the few recent users who have had to run
xfs-repair on their root filesystem to fix this up due to the nature
of ro->rw transition in root filesystem mounting.  Let's make really
sure everything is OK before we expose it to all our users running
stable/distro kernels....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
