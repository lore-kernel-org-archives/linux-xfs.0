Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:44790 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbdLOHGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 02:06:24 -0500
MIME-Version: 1.0
In-Reply-To: <20171215043747.GD4094@dastard>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia> <20171213232805.GI6896@magnolia>
 <20171213234404.GF5858@dastard> <CAOQ4uxhXDVPAzv4jNsgsnbuuN4Hm_yGJKS4hBTzQBp+8hw18_Q@mail.gmail.com>
 <20171214074947.GG2749@eguan.usersys.redhat.com> <20171214213541.GH5858@dastard>
 <20171215020419.GL6896@magnolia> <20171215043747.GD4094@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Dec 2017 09:06:23 +0200
Message-ID: <CAOQ4uxg2pbYe7nVK-_gskuWTp2jf22pM6+9VpDTYr9Qr4nwK4Q@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir count output
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Fri, Dec 15, 2017 at 6:37 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 14, 2017 at 06:04:19PM -0800, Darrick J. Wong wrote:
>> On Fri, Dec 15, 2017 at 08:35:41AM +1100, Dave Chinner wrote:
>> > On Thu, Dec 14, 2017 at 03:49:47PM +0800, Eryu Guan wrote:
>> > > On Thu, Dec 14, 2017 at 08:52:32AM +0200, Amir Goldstein wrote:
>> > > > On Thu, Dec 14, 2017 at 1:44 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > > > > On Wed, Dec 13, 2017 at 03:28:05PM -0800, Darrick J. Wong wrote:
>> > > > >> From: Darrick J. Wong <darrick.wong@oracle.com>
>> > > > >>
>> > > > >> In this test we use a fixed sequence of operations in fsstress to create
>> > > > >> some number of files and dirs and then exercise xfsdump/xfsrestore on
>> > > > >> them.  Since clonerange/deduperange are not supported on all xfs
>> > > > >> configurations, detect if they're in fsstress and disable them so that
>> > > > >> we always execute exactly the same sequence of operations no matter how
>> > > > >> the filesystem is configured.
>> > > > >>
>> > > > >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> > > > >> ---
>> > > > >>  tests/xfs/068 |    8 ++++++++
>> > > > >>  1 file changed, 8 insertions(+)
>> > > > >>
>> > > > >> diff --git a/tests/xfs/068 b/tests/xfs/068
>> > > > >> index 7151e28..f95a539 100755
>> > > > >> --- a/tests/xfs/068
>> > > > >> +++ b/tests/xfs/068
>> > > > >> @@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>> > > > >>  _supported_fs xfs
>> > > > >>  _supported_os Linux
>> > > > >>
>> > > > >> +# Remove fsstress commands that aren't supported on all xfs configs
>> > > > >> +if $FSSTRESS_PROG | grep -q clonerange; then
>> > > > >> +     FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
>> > > > >> +fi
>> > > > >> +if $FSSTRESS_PROG | grep -q deduperange; then
>> > > > >> +     FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
>> > > > >> +fi
>> > > > >> +
>> > > > >
>> > > > > I'd put this inside _create_dumpdir_stress_num as it's supposed to
>> > > > > DTRT for the dump/restore that follows. Otherwise looks fine.
>> > > > >
>> > > >
>> > > > Guys,
>> > > >
>> > > > Please take a look at the only 2 changes in the history of this test.
>> > > > I would like to make sure we are not in a loop:
>> > > >
>> > > > 5d36d85 xfs/068: update golden output due to new operations in fsstress
>> > > > 6e5194d fsstress: Add fallocate insert range operation
>> > > >
>> > > > The first change excludes the new insert op (by dchinner on commit)
>> > > > The second change re-includes insert op, does not exclude new
>> > > > mread/mwrite ops and updates golden output, following this discussion:
>> > > > https://marc.info/?l=fstests&m=149014697111838&w=2
>> > > > (the referenced thread ends with a ? to Dave, but was followed by v6..v8
>> > > >  that were "silently acked" by Dave).
>> > > >
>> > > > I personally argued that the blacklist approach to xfs/068 is fragile and indeed
>> > > > this is the third time the test breaks in the history I know of,
>> > > > because of added
>> > > > fsstress ops. Fine. As long as we at least stay consistent with a decision about
>> > > > update golden output vs. exclude ops and document the decision in a comment
>> > > > with the reasoning, so we won't have to repeat this discussion next time.
>> > >
>> > > I think the fundamental problem of xfs/068 is the hardcoded file numbers
>> > > in .out file, perhaps we should calculate the expected number of
>> > > files/dirs to be dumped/restored before the dump test and extract the
>> > > actual restored number of files/dirs from xfsrestore output and do a
>> > > comparison. (or save the whole tree structure for comparison? I haven't
>> > > done any test yet, just some random thoughts for now.)
>> >
>> > Or we don't waste any more time on trying to make a reliable, stable
>> > regression test that has a history of detecting bulkstat regressions
>> > work differently?
>>
>> <shrug> See now, the frustrating part about fixing this testcase is that
>> I still don't feel like I have a good grasp on what this thing is trying
>> to test -- apparently we're checking for bulkstat regressions, dump
>> problems, and restore problems?
>
> commit 481c28f52fd4ed3976f2733a1c65f92760138258
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Tue Oct 14 22:59:39 2014 +1100
>
>     xfs: test larger dump/restore to/from file
>
>     This test creates a large-ish directory structure using
>     fsstress, and does a dump/restore to make sure we dump
>     all the files.
>
>     Without the fix for the regression caused by:
>     c7cb51d xfs: fix error handling at xfs_inumbers
>
>     we will see failures like:
>
>         -xfsrestore: 486 directories and 1590 entries processed
>         +xfsrestore: 30 directories and 227 entries processed
>
>     as it fails to process all inodes.
>
>     I think that existing tests have a much smaller set of files,
>     and so don't trip the bug.
>
>     I don't do a file-by-file comparison here, because for some
>     reason the diff output gets garbled; this test only checks
>     that we've dumped & restored the correct number of files.
>
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>
>
> FWIW, I'm pretty sure the diff problems were related to binary file
> contents, so it was dropped as it wasn't critical to validting
> that bulkstat and inode number iteration worked correctly.
>
>> Are we also looking for problems that
>> might crop up with the newer APIs, whatever those might be?
>
> No, we're explicitly using fsstress to generate a dataset large
> enough to cause iteration over various API xfsdump relies on to
> work correctly. i.e. the features fsstress have are irrelevant to
> the functioning of this test - we want it to generate a specific,
> consistent, deterministic data set and that's it.
>
> Really, all I care about is that we don't overcomplicate the
> problem and the solution. Just adding commands to the avoid list
> for fsstress is a perfectly acceptible, simple solutioni - we've
> done it twice in 3 years for this test, and we've done it for other
> tests, too. It's hardly a crippling maintenance burden.
>
> And, FWIW, we check the file count from xfsrestore in teh golden
> output of pretty much every xfsdump/restore test:
>
> $ git grep "entries processed" tests/xfs
> tests/xfs/022:_do_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
> tests/xfs/022.out:xfsrestore: NUM directories and NUM entries processed
> tests/xfs/023.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/024.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/025.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/026.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/027.out:xfsrestore: 3 directories and 39 entries processed
> tests/xfs/035.out:xfsrestore: 3 directories and 6 entries processed
> tests/xfs/036.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/037.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/038.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/039.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/043.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/046.out:xfsrestore: 3 directories and 10 entries processed
> tests/xfs/055.out:xfsrestore: 3 directories and 38 entries processed
> tests/xfs/056.out:xfsrestore: 7 directories and 11 entries processed
> tests/xfs/060.out:xfsrestore: 3 directories and 41 entries processed
> tests/xfs/061.out:xfsrestore: 7 directories and 11 entries processed
> tests/xfs/063.out:xfsrestore: 4 directories and 21 entries processed
> .....
>
> Really, I don't see a need to do anything else than avoid the
> fsstress ops that caused the change of behaviour. All the other
> xfsdump/restore tests do file and directory tree validations, so
> they are going to catch any regression on that side of things. This
> test just exercises iteration of various APIs that we've broken in
> the past...
>
>> Currently I have a reworked version of this patch that runs
>> fsstress, measures the number of directories and inodes in
>> $dump_dir, then programmatically compares that to whatever
>> xfsrestore tells us it restored.  This ought to be enough that we
>> can create a sufficiently messy filesystem with whatever sequence
>> of syscalls we want, and make sure that dump/restore actually work
>> on them.
>>
>> First we run fsstress, then we count the number of dirs, the
>> number of fs objects, take a snapshot of the 'find .' output, and
>> md5sum every file in the dump directory.
>>
>> If fsstress creates fewer than 100 dirs or 600 inodes, we fail the
>> test because that wasn't enough.
>>
>> If bulkstat fails to iterate all the inodes, restore's output will
>> reflect fewer files than was expected.
>>
>> If dump fails to generate a full dump, restore's output will
>> reflect fewer files than was expected.
>>
>> If restore fails to restore the full dump, restore's output will
>> reflect fewer files than was expected.
>>
>> If the restore output doesn't reflect the number of dirs/inodes we
>> counted at the beginning, we fail the test.
>>
>> If the 'find .' output of the restored dir doesn't match the
>> original, we fail the test.
>>
>> If the md5sum -c output shows corrupt files, we fail the test.
>>
>> So now I really have no idea -- is that enough to check that
>> everything works?  I felt like it does, but given all the back and
>> forth now I'm wondering if even this is enough.
>
> What did I say about not wanting to overcomplicate the problem and
> the solution? :/
>
> Folks, I don't say "leave it alone, it's fine" without a good
> reason.  If you've never tried to debug xfsdump or xfsrestore, and
> you aren't familiar with the ancient xfsdump and restore unit tests
> that were written before anyone here was working on linux, then
> don't suggest we rewrite them to make them nicer. Their value is in
> the fact they've been around almost entirely unchanged for 15 years
> and they still catch bugs....
>
> Make whatever changes are necessary to keep them running
> exactly as they are and don't change them unless xfsdump/restore
> testing requires them to be changed.
>
>> (Yeah, I'm frustrated because the fsstress additions have been
>> very helpful at flushing out more reflink bugs and I feel like I'm
>> making very little progress on this xfs/068 thing.  Sorry.)
>
> Well, I thought it was all sorted until people started suggesting we
> do crazy things like you've now gone and done.
>

Please read this test description out loud and tell yourself this is a good
sanity test:
1. perform a $series of fs operations
2. backup & restore
3. count the number of file&dir
4. makes sure the $count didn't change across $kernel & user $tools releases

Now developer changes the test variable $series, so the result $count obviously
changes, so developer changes the expected count  WITHOUT verifying that
the expected count is actually correct.

There is NOTHING in the current test (before Darrick's "crazy" changes) that
promise we are not actually validating that bulkstat *is* broken.

Amir.
