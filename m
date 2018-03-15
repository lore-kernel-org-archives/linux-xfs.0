Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43230 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932822AbeCOWsE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 18:48:04 -0400
Date: Fri, 16 Mar 2018 09:48:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: detect agfl count corruption and reset agfl
Message-ID: <20180315224801.GL18129@dastard>
References: <20180314171724.41951-1-bfoster@redhat.com>
 <20180314181218.GR4865@magnolia>
 <CAC=E7cUme5-0z9GjVOynD==nK5aG2athrHmm=WKA8HBFWX-hRQ@mail.gmail.com>
 <20180315103839.GA44732@bfoster.bfoster>
 <20180315154604.GX4865@magnolia>
 <CAC=E7cW7eae8Un++GQNchmPi2QA3sZFPF1BiVHW9bw7c8vj2tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cW7eae8Un++GQNchmPi2QA3sZFPF1BiVHW9bw7c8vj2tg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chiluk <chiluk+linuxxfs@indeed.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 15, 2018 at 11:27:02AM -0500, Dave Chiluk wrote:
> On Thu, Mar 15, 2018 at 10:46 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Thu, Mar 15, 2018 at 06:38:39AM -0400, Brian Foster wrote:
> >> On Wed, Mar 14, 2018 at 03:42:50PM -0500, Dave Chiluk wrote:
> >> > On Wed, Mar 14, 2018 at 1:12 PM, Darrick J. Wong
> >> > <darrick.wong@oracle.com> wrote:
> >> > > On Wed, Mar 14, 2018 at 01:17:24PM -0400, Brian Foster wrote:
> >> ...
> >> >
> >> > Reviewed-by Dave Chiluk <chiluk+linuxxfs@indeed.com>
> >> >
> >> > I'm also assuming this will get submitted back to the linux-stable
> >> > trees as the agfl packing change is already causing issues in the
> >> > stable trees.  If you do not intend to push it into the linux-stable
> >> > trees let me know and I'll take care of at least the major ones.
> >> >
> >>
> >> Yeah, I can cc stable in the next post along with the other minor fixes.
> >> My question is how far back should this fix go? Was the plan to only go
> >> back to v4.5 because that is where the packing fix first went in? Or
> >> should this go back further because it looks like the packing fix was
> >> backported to v3.10:
> >>
> >> $ git show 96f859d52bcb1
> >> commit 96f859d52bcb1c6ea6f3388d39862bf7143e2f30
> >> Author: Darrick J. Wong <darrick.wong@oracle.com>
> >> Date:   Mon Jan 4 16:13:21 2016 +1100
> >>
> >>     libxfs: pack the agfl header structure so XFS_AGFL_SIZE is correct
> >>
> >>     ...
> >>
> >>     cc: <stable@vger.kernel.org> # 3.10 - 4.4
> >>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
> >>     Signed-off-by: Dave Chinner <david@fromorbit.com>
> >
> > Hmmm, I'm assuming that you'd want 3.10 at least for RHEL, but I'll let
> > you all figure that one out.
> >
> > As far as the upstream kernels, 4.14.27, 4.9.87, 4.4.121, and 4.1.50
> > have that packing patch so I guess they'll all need some version of this.
> >
> > --D
> >
> >>
> >> Brian
> >>
> >> > Thanks,
> >> > Dave
> >> > --
> 
> RHEL is actually fine for now, since they explicitly remove the
> packing patch in their kernel, and xfsprogs.  Once you submit the
> patches to linux-stable the ubuntu-kernel team monitors and includes
> patches for the releases that they are stable maintainers of *(they
> are downstream for 4.4 of gregkh, but currently maintain a 3.13, 4.13,
> and 4.15 tree).
> 
> Also please add a Fixes line to your commit so it's obvious what patch
> it helps remediate.  Fixes is actually not a great word here, but that
> looks to be what the submitting-patches.txt doc calls for.
> 
> Fixes: 96f859d52bcb libxfs: pack the agfl header structure so
> XFS_AGFL_SIZE is correct

No, please don't dumb down a complex issue to a simple, naive
metadata tag like this. Explain the issue fully in the commit
message, mentioning/referencing commits when appropriate.

As I've mentioned in another thread recently about backports - it
you are relying on "fixes" tags to determine what needs backporting,
your backporting process is fundamentally broken.  I don't care what
the kernel documentatin says - it frequently does not apply because
it's written by someone else for their own reasons and requirements
that aren't relevant to us. They are guidelines, not rules, for that
reason.

> This way stable maintainers understand that the fix resolves an issue
> that was introduced by that patch, and can apply/not apply
> appropriately.

I simply don't trust the stable process to get complex XFS backports
right and correctly tested. e.g. We've had this problem before with
things like error numbers changing sign @ 3.16 - patches from >3.16
were getting backported with negative errnos to kernels <3.16, and
they were breaking because errors were not being correctly detected. 

Because nobody in the stable process was regression testing
filesystem backports other than booting kernels, it wasn't until
users installed and started reporting stable kernel regressions to
us that we were able to identify the bugs and the process issues
that caused them.

Put simply: the stable kernel maintainers are not filesystem experts
and they don't run filesystem regression tests to determine that the
fixes don't have any unexpected side effects. What that means is
that stable kernel backports need to be done under the eye of an XFS
developer who then follows up by reviewing the backports once merged
and running regression tests agtainst the resulting kernel as we
cannot rely on the stable process to do this.  It's a serious amount
of work for something as critical as fixing an on-disk format
problem, and we simply can't trust anyone else to do the job
properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
