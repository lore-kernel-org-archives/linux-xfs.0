Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33064 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdLNIPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 03:15:13 -0500
MIME-Version: 1.0
In-Reply-To: <20171214074947.GG2749@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314505158.18893.11894289091110903029.stgit@magnolia> <20171213232805.GI6896@magnolia>
 <20171213234404.GF5858@dastard> <CAOQ4uxhXDVPAzv4jNsgsnbuuN4Hm_yGJKS4hBTzQBp+8hw18_Q@mail.gmail.com>
 <20171214074947.GG2749@eguan.usersys.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 Dec 2017 10:15:12 +0200
Message-ID: <CAOQ4uxhgV7HCmbFpzsYes_XJVScHDBjJCqLYmYzO+z5JiaoofQ@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] xfs/068: fix clonerange problems in file/dir count output
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Dec 14, 2017 at 9:49 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Dec 14, 2017 at 08:52:32AM +0200, Amir Goldstein wrote:
>> On Thu, Dec 14, 2017 at 1:44 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Dec 13, 2017 at 03:28:05PM -0800, Darrick J. Wong wrote:
>> >> From: Darrick J. Wong <darrick.wong@oracle.com>
>> >>
>> >> In this test we use a fixed sequence of operations in fsstress to create
>> >> some number of files and dirs and then exercise xfsdump/xfsrestore on
>> >> them.  Since clonerange/deduperange are not supported on all xfs
>> >> configurations, detect if they're in fsstress and disable them so that
>> >> we always execute exactly the same sequence of operations no matter how
>> >> the filesystem is configured.
>> >>
>> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> >> ---
>> >>  tests/xfs/068 |    8 ++++++++
>> >>  1 file changed, 8 insertions(+)
>> >>
>> >> diff --git a/tests/xfs/068 b/tests/xfs/068
>> >> index 7151e28..f95a539 100755
>> >> --- a/tests/xfs/068
>> >> +++ b/tests/xfs/068
>> >> @@ -43,6 +43,14 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>> >>  _supported_fs xfs
>> >>  _supported_os Linux
>> >>
>> >> +# Remove fsstress commands that aren't supported on all xfs configs
>> >> +if $FSSTRESS_PROG | grep -q clonerange; then
>> >> +     FSSTRESS_AVOID="-f clonerange=0 $FSSTRESS_AVOID"
>> >> +fi
>> >> +if $FSSTRESS_PROG | grep -q deduperange; then
>> >> +     FSSTRESS_AVOID="-f deduperange=0 $FSSTRESS_AVOID"
>> >> +fi
>> >> +
>> >
>> > I'd put this inside _create_dumpdir_stress_num as it's supposed to
>> > DTRT for the dump/restore that follows. Otherwise looks fine.
>> >
>>
>> Guys,
>>
>> Please take a look at the only 2 changes in the history of this test.
>> I would like to make sure we are not in a loop:
>>
>> 5d36d85 xfs/068: update golden output due to new operations in fsstress
>> 6e5194d fsstress: Add fallocate insert range operation
>>
>> The first change excludes the new insert op (by dchinner on commit)
>> The second change re-includes insert op, does not exclude new
>> mread/mwrite ops and updates golden output, following this discussion:
>> https://marc.info/?l=fstests&m=149014697111838&w=2
>> (the referenced thread ends with a ? to Dave, but was followed by v6..v8
>>  that were "silently acked" by Dave).
>>
>> I personally argued that the blacklist approach to xfs/068 is fragile and indeed
>> this is the third time the test breaks in the history I know of,
>> because of added
>> fsstress ops. Fine. As long as we at least stay consistent with a decision about
>> update golden output vs. exclude ops and document the decision in a comment
>> with the reasoning, so we won't have to repeat this discussion next time.
>
> I think the fundamental problem of xfs/068 is the hardcoded file numbers
> in .out file, perhaps we should calculate the expected number of
> files/dirs to be dumped/restored before the dump test and extract the
> actual restored number of files/dirs from xfsrestore output and do a
> comparison. (or save the whole tree structure for comparison? I haven't
> done any test yet, just some random thoughts for now.)
>
> Currently, xfs/068 will easily break if there's user-defined
> FSSTRESS_AVOID, e.g. FSSTRESS_AVOID="-ffallocate=0", and that's totally
> legal test configuration.
>
> IHMO we really should fix xfs/068 first to avoid hitting the same
> problem again and again.
>

Agreed.
And while at it, need to redirect:

echo "fsstress : $_param"

to $seq.full and remove it from golden output and print the
actual parameters in the log including  $FSSTRESS_AVOID, not the
make believe params.

Amir.
