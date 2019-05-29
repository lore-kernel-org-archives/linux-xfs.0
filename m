Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44834 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfE2Fa6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 01:30:58 -0400
MIME-Version: 1.0
References: <20190526084535.999-1-amir73il@gmail.com> <20190526084535.999-5-amir73il@gmail.com>
 <20190529021636.GB5244@magnolia>
In-Reply-To: <20190529021636.GB5244@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 08:30:47 +0300
Message-ID: <CAOQ4uxgpqpoNEZRT5+WVaAwin5usirgrrhg7OVr3pV_r2qFZ6A@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] generic: copy_file_range bounds test
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>

On Wed, May 29, 2019 at 5:16 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sun, May 26, 2019 at 11:45:34AM +0300, Amir Goldstein wrote:
> > Test that copy_file_range will return the correct errors for various
> > error conditions and boundary constraints.
> >
> > [Amir] Split out cross-device copy_range test and use only scratch dev.
> > Split out immutable/swapfile test cases to reduce the requirements to
> > run the bounds check to minimum and get coverage for more filesystems.
> > Remove the tests for read past EOF and write after chmod -r,
> > because we decided to stick with read(2)/write(2) semantics.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/990.out |  37 +++++++++++++
> >  tests/generic/group   |   1 +
> >  3 files changed, 161 insertions(+)
> >  create mode 100755 tests/generic/990
> >  create mode 100644 tests/generic/990.out
> >
> > diff --git a/tests/generic/990 b/tests/generic/990
> > new file mode 100755
> > index 00000000..5e2421b6
> > --- /dev/null
> > +++ b/tests/generic/990
> > @@ -0,0 +1,123 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 990
> > +#
> > +# Exercise copy_file_range() syscall error conditions.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1     # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> > +
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs generic
> > +
> > +rm -f $seqres.full
> > +
> > +_require_test
> > +_require_xfs_io_command "copy_range"
> > +#
> > +# This test effectively requires xfs_io v4.20 with the commits
> > +#  2a42470b xfs_io: copy_file_range length is a size_t
> > +#  1a05efba io: open pipes in non-blocking mode
>
> So, uh, is this going to cause test hangs on xfsprogs < 4.20?

Yes, from the pipe test case:
$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/fifo" $testdir/copy

I could introduce _require_xfs_io_min_ver, but it goes completely
against "testing features" methodology.

I guess I could implement _require_xfs_io_non_block_fifo, but that
also seems quite ugly to me?

BTW, per your comment about splitting the fifo test case, I believe
that would be wrong.
I split the swap/immutable file test cases to provide better bounds
test coverage for filesystems that do not support swap/immutable
files.
If I split the fifo test case, it will provide better bounds test coverage
for test setups with old xfs_io and new kernel (in old kernel bounds
test will fail anyway), so what do users gain from that?

Thanks,
Amir.
