Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49152 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfC0D0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 23:26:53 -0400
Date: Tue, 26 Mar 2019 20:26:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] generic: prohibit fstrim on journalled filesystems with
 norecovery
Message-ID: <20190327032645.GB1183@magnolia>
References: <20190323003532.GB1180@magnolia>
 <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filipe David Manana <fdmanana@apache.org>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Mar 26, 2019 at 12:21:20PM +0000, Filipe David Manana wrote:
> On Sat, Mar 23, 2019 at 12:35 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > This test makes sure that we can't use stale unrecovered fs metadata to
> > drive a DISCARD festival on a disk and thereby destroy user data by
> > accident.
> 
> It would help to have listed the name of the patches that fix the
> issues on xfs/ext4/btrfs, to make it faster.
> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good, thanks for doing this. Just one question below.
> 
> > ---
> >  tests/generic/714     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/714.out |    4 +++
> >  tests/generic/group   |    1 +
> >  3 files changed, 66 insertions(+)
> >  create mode 100755 tests/generic/714
> >  create mode 100644 tests/generic/714.out
> >
> > diff --git a/tests/generic/714 b/tests/generic/714
> > new file mode 100755
> > index 00000000..1849a5e9
> > --- /dev/null
> > +++ b/tests/generic/714
> > @@ -0,0 +1,61 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 714
> > +#
> > +# Ensure that we can't call fstrim on filesystems mounted norecovery, because
> > +# FSTRIM implementations use free space metadata to drive the discard requests
> > +# and we told the filesystem not to make sure the metadata are up to date.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_scratch
> > +_require_fstrim
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_require_metadata_journaling $SCRATCH_DEV
> > +
> > +echo "fstrim on regular mount"
> > +_scratch_mount >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 || \
> > +       _notrun "FSTRIM not supported"
> > +_scratch_unmount
> > +
> > +echo "fstrim on ro mount"
> > +_scratch_mount -o ro >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
> > +_scratch_unmount
> > +
> > +echo "fstrim on ro mount with no log replay"
> > +norecovery="norecovery"
> > +test $FSTYP = "btrfs" && norecovery=nologreplay
> > +_scratch_mount -o ro,$norecovery >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 && \
> > +       echo "fstrim with unrecovered metadata just ate your filesystem"
> > +_scratch_unmount
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/714.out b/tests/generic/714.out
> > new file mode 100644
> > index 00000000..1158a2ff
> > --- /dev/null
> > +++ b/tests/generic/714.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 714
> > +fstrim on regular mount
> > +fstrim on ro mount
> > +fstrim on ro mount with no log replay
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 2e4341fb..c2046293 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -538,6 +538,7 @@
> >  533 auto quick attr
> >  534 auto quick log
> >  535 auto quick log
> > +714 auto trim
> 
> Any reason to not add the 'quick' group as well? It runs in 1 second
> for me on btrfs, xfs and ext4 with a debug kernel.

Probably just an oversight, I'll add it when I resubmit tomorrow.

Thanks for the review + btrfs fix. :)

--D

> >  940 auto quick clone punch
> >  941 auto quick clone punch
> >  942 auto quick clone punch
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
