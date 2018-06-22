Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbeFVGjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:39:11 -0400
Date: Thu, 21 Jun 2018 23:39:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/8] xfs: recheck reflink state after grabbing
 ILOCK_SHARED for a write
Message-ID: <20180622063905.GN4838@magnolia>
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
 <152960596196.26479.13083497192197135552.stgit@magnolia>
 <d67f52df-2347-41d1-13c6-7411938ab99a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d67f52df-2347-41d1-13c6-7411938ab99a@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 21, 2018 at 11:35:38PM -0700, Allison Henderson wrote:
> On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In "xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation", we fixed
> > the per-ag reservation code so that we always decrease fdblocks by the
> > reserved size because rmapbt blocks are counted as free space.
> > 
> > The primary symptom of this bug is that if the rmapbt has expanded since
> > mount time, the disk block counters reported via statfs will change
> > across a remount.  Therefore, we exercise this as a regression test.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   tests/xfs/712     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   tests/xfs/712.out |    1 +
> >   tests/xfs/group   |    1 +
> >   3 files changed, 64 insertions(+)
> >   create mode 100755 tests/xfs/712
> >   create mode 100644 tests/xfs/712.out
> 
> Humm, was there supposed to be more to this maybe?  Shouldn't we see a
> 712.out somewhere?
> > 
> > 
> > diff --git a/tests/xfs/712 b/tests/xfs/712
> > new file mode 100755
> > index 00000000..f90c7ec9
> > --- /dev/null
> > +++ b/tests/xfs/712
> > @@ -0,0 +1,62 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
> > +#
> > +# FS QA Test No. 712
> > +#
> > +# Make sure that the statfs b_avail counter doesn't change across remount
> > +# after the rmapbt has grown in size.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
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
> > +. ./common/filter
> > +
> > +# remo
> > 

Hmm, well, you did actually catch that I omitted the usual "Silence is
golden" but I do wonder about this cutting off right there....

Will send v2.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
