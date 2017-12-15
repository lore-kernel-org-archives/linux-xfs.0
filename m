Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59335 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754731AbdLOCKd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 21:10:33 -0500
Date: Thu, 14 Dec 2017 18:04:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir
 count output
Message-ID: <20171215020419.GL6896@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
 <20171213232805.GI6896@magnolia>
 <20171213234404.GF5858@dastard>
 <CAOQ4uxhXDVPAzv4jNsgsnbuuN4Hm_yGJKS4hBTzQBp+8hw18_Q@mail.gmail.com>
 <20171214074947.GG2749@eguan.usersys.redhat.com>
 <20171214213541.GH5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171214213541.GH5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Fri, Dec 15, 2017 at 08:35:41AM +1100, Dave Chinner wrote:
> On Thu, Dec 14, 2017 at 03:49:47PM +0800, Eryu Guan wrote:
> > On Thu, Dec 14, 2017 at 08:52:32AM +0200, Amir Goldstein wrote:
> > > On Thu, Dec 14, 2017 at 1:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> > > > On Wed, Dec 13, 2017 at 03:28:05PM -0800, Darrick J. Wong wrote:
> > > >> From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >>
> > > >> In this test we use a fixed sequence of operations in fsstress to create
> > > >> some number of files and dirs and then exercise xfsdump/xfsrestore on
> > > >> them.  Since clonerange/deduperange are not supported on all xfs
> > > >> configurations, detect if they're in fsstress and disable them so that
> > > >> we always execute exactly the same sequence of operations no matter how
> > > >> the filesystem is configured.
> > > >>
> > > >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > >> ---
> > > >>  tests/xfs/068 |    8 ++++++++
> > > >>  1 file changed, 8 insertions(+)
> > > >>
> > > >> diff --git a/tests/xfs/068 b/tests/xfs/068
> > > >> index 7151e28..f95a539 100755
> > > >> --- a/tests/xfs/068
> > > >> +++ b/tests/xfs/068
> > > >> @@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
> > > >>  _supported_fs xfs
> > > >>  _supported_os Linux
> > > >>
> > > >> +# Remove fsstress commands that aren't supported on all xfs configs
> > > >> +if $FSSTRESS_PROG | grep -q clonerange; then
> > > >> +     FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
> > > >> +fi
> > > >> +if $FSSTRESS_PROG | grep -q deduperange; then
> > > >> +     FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
> > > >> +fi
> > > >> +
> > > >
> > > > I'd put this inside _create_dumpdir_stress_num as it's supposed to
> > > > DTRT for the dump/restore that follows. Otherwise looks fine.
> > > >
> > > 
> > > Guys,
> > > 
> > > Please take a look at the only 2 changes in the history of this test.
> > > I would like to make sure we are not in a loop:
> > > 
> > > 5d36d85 xfs/068: update golden output due to new operations in fsstress
> > > 6e5194d fsstress: Add fallocate insert range operation
> > > 
> > > The first change excludes the new insert op (by dchinner on commit)
> > > The second change re-includes insert op, does not exclude new
> > > mread/mwrite ops and updates golden output, following this discussion:
> > > https://marc.info/?l=fstests&m=149014697111838&w=2
> > > (the referenced thread ends with a ? to Dave, but was followed by v6..v8
> > >  that were "silently acked" by Dave).
> > > 
> > > I personally argued that the blacklist approach to xfs/068 is fragile and indeed
> > > this is the third time the test breaks in the history I know of,
> > > because of added
> > > fsstress ops. Fine. As long as we at least stay consistent with a decision about
> > > update golden output vs. exclude ops and document the decision in a comment
> > > with the reasoning, so we won't have to repeat this discussion next time.
> > 
> > I think the fundamental problem of xfs/068 is the hardcoded file numbers
> > in .out file, perhaps we should calculate the expected number of
> > files/dirs to be dumped/restored before the dump test and extract the
> > actual restored number of files/dirs from xfsrestore output and do a
> > comparison. (or save the whole tree structure for comparison? I haven't
> > done any test yet, just some random thoughts for now.)
> 
> Or we don't waste any more time on trying to make a reliable, stable
> regression test that has a history of detecting bulkstat regressions
> work differently?

<shrug> See now, the frustrating part about fixing this testcase is that
I still don't feel like I have a good grasp on what this thing is trying
to test -- apparently we're checking for bulkstat regressions, dump
problems, and restore problems?  Are we also looking for problems that
might crop up with the newer APIs, whatever those might be?

Currently I have a reworked version of this patch that runs fsstress,
measures the number of directories and inodes in $dump_dir, then
programmatically compares that to whatever xfsrestore tells us it
restored.  This ought to be enough that we can create a sufficiently
messy filesystem with whatever sequence of syscalls we want, and make
sure that dump/restore actually work on them.

First we run fsstress, then we count the number of dirs, the number
of fs objects, take a snapshot of the 'find .' output, and md5sum every
file in the dump directory.

If fsstress creates fewer than 100 dirs or 600 inodes, we fail the test
because that wasn't enough.

If bulkstat fails to iterate all the inodes, restore's output will
reflect fewer files than was expected.

If dump fails to generate a full dump, restore's output will
reflect fewer files than was expected.

If restore fails to restore the full dump, restore's output will
reflect fewer files than was expected.

If the restore output doesn't reflect the number of dirs/inodes we
counted at the beginning, we fail the test.

If the 'find .' output of the restored dir doesn't match the original,
we fail the test.

If the md5sum -c output shows corrupt files, we fail the test.

So now I really have no idea -- is that enough to check that everything
works?  I felt like it does, but given all the back and forth now I'm
wondering if even this is enough.

(Yeah, I'm frustrated because the fsstress additions have been very
helpful at flushing out more reflink bugs and I feel like I'm making
very little progress on this xfs/068 thing.  Sorry.)

--D

> Indeed, the problem here is our "turn on new functionality in
> fsstress as it is added" process will always break older tests that
> require fixed functionality to test.  Having tests fail when we do
> this is perfectly reasonable - it means we have to consider whether
> that new fsstress operation is valid for the test being run. 
> 
> Making tests silently accept new operations that may not be valid
> for the thing being tested doesn't improve our test coverage. What
> it does is take away a warning canary that tells us we may have
> broken something we didn't intend to break. e.g. maybe this test is
> telling us reflink breaks xfsdump or xfsrestore? That's the point of
> having hard coded numbers in the golden output - any change whether
> intended, expected or otherwise requires us to go look at whether
> that new functionality has broken xfsdump/restore.
> 
> That's what regression tests are for, and taking that away from the
> test under the guise of "easier test maintenance" is misguided.
> Regression tests require validation and checking when new
> functionality is added to the tools they use. Having old tests fail
> when new features are added is exactly what we want the regression
> tests to do, otherwise we'll miss regressions that the current code
> actually catches.
> 
> > Currently, xfs/068 will easily break if there's user-defined
> > FSSTRESS_AVOID, e.g. FSSTRESS_AVOID="-ffallocate=0", and that's totally
> > legal test configuration.
> 
> I think that's a strawman argument - who tests XFS without fallocate
> enabled these days? Indeed, fsstress will still be doing
> preallocation via the old ALLOCSP and RESVSP ioctls that predate
> fallocate....
> 
> > IHMO we really should fix xfs/068 first to avoid hitting the same
> > problem again and again.
> 
> IMO, we should not be changing the way old tests work, especially
> those that have, in the past, been very good at exposing bugs in
> kernel interfaces.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
