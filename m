Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42274 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfCUEPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Mar 2019 00:15:51 -0400
Date: Wed, 20 Mar 2019 21:15:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/12] check: wipe scratch devices between tests
Message-ID: <20190321041544.GD1186@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
 <155304275552.31707.6473598082840688691.stgit@magnolia>
 <CAOQ4uxhu52G1hw6h-uc50-n5Bq0OT+4pLZjdnfPxK784F=nG0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhu52G1hw6h-uc50-n5Bq0OT+4pLZjdnfPxK784F=nG0Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Mar 20, 2019 at 09:06:08AM +0200, Amir Goldstein wrote:
> On Wed, Mar 20, 2019 at 2:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Wipe the scratch devices in between each test to ensure that tests are
> > formatting them and not making assumptions about previous contents.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  check      |    1 +
> >  common/rc  |    6 ++++++
> >  common/xfs |    1 +
> >  3 files changed, 8 insertions(+)
> >
> >
> > diff --git a/check b/check
> > index a2c5ba21..bcf08dfe 100755
> > --- a/check
> > +++ b/check
> > @@ -737,6 +737,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
> >                         # _check_dmesg depends on this log in dmesg
> >                         touch ${RESULT_DIR}/check_dmesg
> >                 fi
> > +               _try_wipe_scratch_devs > /dev/null 2>&1
> >                 if [ "$DUMP_OUTPUT" = true ]; then
> >                         ./$seq 2>&1 | tee $tmp.out
> >                         # Because $? would get tee's return code
> > diff --git a/common/rc b/common/rc
> > index 1c42515f..40eef80f 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3942,6 +3942,12 @@ _require_fibmap()
> >         rm -f $file
> >  }
> >
> > +_try_wipe_scratch_devs()
> > +{
> > +       _scratch_unmount
> 
> So I find this change strange, not because it doesn't make sense
> to start every test with scratch unmounted, but because today scratch *is*
> mounted on test start and there is quite a bit of code to make it mounted
> on test start, which seems backwards.

Huh?  On XFS the test device is always mounted, but the scratch device
is never mounted before the test starts.

Hmmm, maybe this is one of those weird things that different with
nonblock filesystems...?

> IOW, instead of unmounting scratch just before the test runs, seems
> better to make sure it is unmounted at the end of each test and before
> starting the loop.
> 
> Note that for a test with _require_scratch_nocheck, _check_filesystems()
> will unmount scratch, but for a test with _require_scratch, _check_scratch_fs()
> will unmount+fsck+mount scratch - inconsistent.
> Or am I reading this wrong?
> 
> 
> > +       test -x "$WIPEFS_PROG" && $WIPEFS_PROG -a $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV
> 
> Please check that $SCRATCH_DEV is not a network name (nfs|cifs) and that it
> is really a blockdev (overlayfs) before trying to wipefs.

I wonder if maybe we only bother with wipefs for filesystems where
all tests have been fixed to not stumble over unformatted scratchdev
(i.e. xfs and ext* only)

--D

> Thanks,
> Amir.
