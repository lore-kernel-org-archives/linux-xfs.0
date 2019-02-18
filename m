Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34370 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389255AbfBRSDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 13:03:49 -0500
Date: Mon, 18 Feb 2019 10:03:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: test mkfs extent size hint validation
Message-ID: <20190218180334.GF6477@magnolia>
References: <20190216003923.GV32253@magnolia>
 <20190216004119.GW32253@magnolia>
 <20190217220716.GA9805@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190217220716.GA9805@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>

On Mon, Feb 18, 2019 at 09:07:16AM +1100, Dave Chinner wrote:
> On Fri, Feb 15, 2019 at 04:41:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure mkfs won't format filesystems that fail extent size hint
> > validation.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/738     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/738.out |    2 ++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 51 insertions(+)
> >  create mode 100755 tests/xfs/738
> >  create mode 100644 tests/xfs/738.out
> > 
> > diff --git a/tests/xfs/738 b/tests/xfs/738
> > new file mode 100755
> > index 00000000..ee0ffaae
> > --- /dev/null
> > +++ b/tests/xfs/738
> > @@ -0,0 +1,48 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 738
> > +#
> > +# Make sure we can't format a filesystem with insane extent hints.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +testfile=$TEST_DIR/$seq.txt
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch_nocheck
> > +
> > +rm -f $seqres.full
> > +
> > +# Try regular extent size hint
> > +echo extszinherit >> $seqres.full
> > +_scratch_mkfs -d extszinherit=8388608 >> $seqres.full 2>&1
> > +test $? -eq 1 || echo "should have failed extszinherit"
> 
> That won't fail on 64k block size filesystems....

The extzinherit parameter is copied directly into the root inode without
any unit conversion (dopts[D_EXTSZINHERIT].convert == false), which
means that it's specified in units of fs blocks, right?  So then the
only constraints are that the value < MAXEXTLEN and value < agsize/2,
which means that block size shouldn't matter.

> > +# Try cow extent size hint if supported
> > +$MKFS_XFS_PROG -N -f $SCRATCH_DEV > $tmp.mkfs
> > +if grep -q 'reflink=' $tmp.mkfs ; then
> 
> That's testing mkfs for reflink support, yes? i.e.
> 
> _scratch_mkfs_xfs_supported -m crc=1,reflink=1 

Ok.

> [ need to explicitly say -m crc=1 here, because MKFS_OPTIONS might
> have -m crc=0, right? ]
> 
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -515,6 +515,7 @@
> >  731 dangerous_scrub dangerous_online_repair
> >  736 auto quick unlink
> >  737 auto quick unlink
> > +738 auto quick
> 
> prealloc, too. And maybe mkfs?

Will fix the last two; thanks for the review.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
