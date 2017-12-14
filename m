Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbdLNHtt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Dec 2017 02:49:49 -0500
Date: Thu, 14 Dec 2017 15:49:47 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir
 count output
Message-ID: <20171214074947.GG2749@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia>
 <20171213232805.GI6896@magnolia>
 <20171213234404.GF5858@dastard>
 <CAOQ4uxhXDVPAzv4jNsgsnbuuN4Hm_yGJKS4hBTzQBp+8hw18_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhXDVPAzv4jNsgsnbuuN4Hm_yGJKS4hBTzQBp+8hw18_Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Dec 14, 2017 at 08:52:32AM +0200, Amir Goldstein wrote:
> On Thu, Dec 14, 2017 at 1:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Dec 13, 2017 at 03:28:05PM -0800, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> In this test we use a fixed sequence of operations in fsstress to create
> >> some number of files and dirs and then exercise xfsdump/xfsrestore on
> >> them.  Since clonerange/deduperange are not supported on all xfs
> >> configurations, detect if they're in fsstress and disable them so that
> >> we always execute exactly the same sequence of operations no matter how
> >> the filesystem is configured.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> ---
> >>  tests/xfs/068 |    8 ++++++++
> >>  1 file changed, 8 insertions(+)
> >>
> >> diff --git a/tests/xfs/068 b/tests/xfs/068
> >> index 7151e28..f95a539 100755
> >> --- a/tests/xfs/068
> >> +++ b/tests/xfs/068
> >> @@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
> >>  _supported_fs xfs
> >>  _supported_os Linux
> >>
> >> +# Remove fsstress commands that aren't supported on all xfs configs
> >> +if $FSSTRESS_PROG | grep -q clonerange; then
> >> +     FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
> >> +fi
> >> +if $FSSTRESS_PROG | grep -q deduperange; then
> >> +     FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
> >> +fi
> >> +
> >
> > I'd put this inside _create_dumpdir_stress_num as it's supposed to
> > DTRT for the dump/restore that follows. Otherwise looks fine.
> >
> 
> Guys,
> 
> Please take a look at the only 2 changes in the history of this test.
> I would like to make sure we are not in a loop:
> 
> 5d36d85 xfs/068: update golden output due to new operations in fsstress
> 6e5194d fsstress: Add fallocate insert range operation
> 
> The first change excludes the new insert op (by dchinner on commit)
> The second change re-includes insert op, does not exclude new
> mread/mwrite ops and updates golden output, following this discussion:
> https://marc.info/?l=fstests&m=149014697111838&w=2
> (the referenced thread ends with a ? to Dave, but was followed by v6..v8
>  that were "silently acked" by Dave).
> 
> I personally argued that the blacklist approach to xfs/068 is fragile and indeed
> this is the third time the test breaks in the history I know of,
> because of added
> fsstress ops. Fine. As long as we at least stay consistent with a decision about
> update golden output vs. exclude ops and document the decision in a comment
> with the reasoning, so we won't have to repeat this discussion next time.

I think the fundamental problem of xfs/068 is the hardcoded file numbers
in .out file, perhaps we should calculate the expected number of
files/dirs to be dumped/restored before the dump test and extract the
actual restored number of files/dirs from xfsrestore output and do a
comparison. (or save the whole tree structure for comparison? I haven't
done any test yet, just some random thoughts for now.)

Currently, xfs/068 will easily break if there's user-defined
FSSTRESS_AVOID, e.g. FSSTRESS_AVOID="-ffallocate=0", and that's totally
legal test configuration.

IHMO we really should fix xfs/068 first to avoid hitting the same
problem again and again.

Thanks,
Eryu

> 
> Darrick,
> 
> IMO, we should follow the path of updating golden output and instead of
> dropping clone/dedupe from ops table in runtime, you should make them
> a noop or ignore the error, keeping the random sequence unchanged.
> This is more or less what happens with insert/collapse (error is ignored)
> already, so it would be weird to make exceptions.
> 
> For reference, fsx does disable insert/collapse/zero/punch at runtime
> and that does change the random sequence of fsx.
> 
> Cheers,
> Amir.
