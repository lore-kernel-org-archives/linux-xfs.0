Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34776 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZQYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 12:24:21 -0400
MIME-Version: 1.0
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
 <155304275552.31707.6473598082840688691.stgit@magnolia> <CAOQ4uxhu52G1hw6h-uc50-n5Bq0OT+4pLZjdnfPxK784F=nG0Q@mail.gmail.com>
 <20190321041544.GD1186@magnolia> <20190323132948.GW2824@desktop> <20190325234839.GA15524@magnolia>
In-Reply-To: <20190325234839.GA15524@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Mar 2019 18:24:09 +0200
Message-ID: <CAOQ4uxjN8HHbo-UXxK-gWQAEfJHT4g3a9K7NTr4GLtFm-4tC2A@mail.gmail.com>
Subject: Re: [PATCH 11/12] check: wipe scratch devices between tests
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Tue, Mar 26, 2019 at 1:48 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sat, Mar 23, 2019 at 09:29:48PM +0800, Eryu Guan wrote:
> > On Wed, Mar 20, 2019 at 09:15:44PM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 20, 2019 at 09:06:08AM +0200, Amir Goldstein wrote:
> > > > On Wed, Mar 20, 2019 at 2:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > > >
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > >
> > > > > Wipe the scratch devices in between each test to ensure that tests are
> > > > > formatting them and not making assumptions about previous contents.
> > > > >
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > >  check      |    1 +
> > > > >  common/rc  |    6 ++++++
> > > > >  common/xfs |    1 +
> > > > >  3 files changed, 8 insertions(+)
> > > > >
> > > > >
> > > > > diff --git a/check b/check
> > > > > index a2c5ba21..bcf08dfe 100755
> > > > > --- a/check
> > > > > +++ b/check
> > > > > @@ -737,6 +737,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> > > > >                         # _check_dmesg depends on this log in dmesg
> > > > >                         touch ${RESULT_DIR}/check_dmesg
> > > > >                 fi
> > > > > +               _try_wipe_scratch_devs > /dev/null 2>&1
> > > > >                 if [ "$DUMP_OUTPUT" = true ]; then
> > > > >                         ./$seq 2>&1 | tee $tmp.out
> > > > >                         # Because $? would get tee's return code
> > > > > diff --git a/common/rc b/common/rc
> > > > > index 1c42515f..40eef80f 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -3942,6 +3942,12 @@ _require_fibmap()
> > > > >         rm -f $file
> > > > >  }
> > > > >
> > > > > +_try_wipe_scratch_devs()
> > > > > +{
> > > > > +       _scratch_unmount
> > > >
> > > > So I find this change strange, not because it doesn't make sense
> > > > to start every test with scratch unmounted, but because today scratch *is*
> > > > mounted on test start and there is quite a bit of code to make it mounted
> > > > on test start, which seems backwards.
> > >
> > > Huh?  On XFS the test device is always mounted, but the scratch device
> > > is never mounted before the test starts.
> >
> > Yes, as _require_test always mounts TEST_DEV and
> > _require_scratch_nocheck always umounts SCRATCH_DEV.
>
> Heh, both of you were right and I was wrong, we format and mount the
> scratch device before we start the loop.
>
> > >
> > > Hmmm, maybe this is one of those weird things that different with
> > > nonblock filesystems...?
> > >
> > > > IOW, instead of unmounting scratch just before the test runs, seems
> > > > better to make sure it is unmounted at the end of each test and before
> > > > starting the loop.
> > > >
> > > > Note that for a test with _require_scratch_nocheck, _check_filesystems()
> > > > will unmount scratch, but for a test with _require_scratch, _check_scratch_fs()
> > > > will unmount+fsck+mount scratch - inconsistent.
> > > > Or am I reading this wrong?
> >
> > For tests that don't call _require_scratch{_nocheck}, to make sure
> > SCRATCH_DEV is umounted I think we could just call _scratch_unmount
> > unconditionally in _check_filesystems(), then we could wipefs before
> > test safely.
>
> I think it does this already:
>
>         if [ -f ${RESULT_DIR}/require_scratch ]; then
>                 _check_scratch_fs || err=true
>                 rm -f ${RESULT_DIR}/require_scratch*
>         else
>                 _scratch_unmount 2> /dev/null
>         fi
>
> Right?  So I think we're covered for unmounting the scratch device after
> each test, and it's just the first time through the loop where we have
> to unmount the scratch device.
>

Right about _require_scratch_nocheck and no _require_scratch.
Test with _require_scratch will call _check_filesystems().
_check_scratch_fs() will unmount scratch; fsck; mount scratch.
So as far as I can see, its not only the first time through the loop.

Thanks,
Amir.
