Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:43820 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbfBQWHV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 17:07:21 -0500
Date: Mon, 18 Feb 2019 09:07:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: test mkfs extent size hint validation
Message-ID: <20190217220716.GA9805@dastard>
References: <20190216003923.GV32253@magnolia>
 <20190216004119.GW32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190216004119.GW32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>

On Fri, Feb 15, 2019 at 04:41:19PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure mkfs won't format filesystems that fail extent size hint
> validation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/738     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/738.out |    2 ++
>  tests/xfs/group   |    1 +
>  3 files changed, 51 insertions(+)
>  create mode 100755 tests/xfs/738
>  create mode 100644 tests/xfs/738.out
> 
> diff --git a/tests/xfs/738 b/tests/xfs/738
> new file mode 100755
> index 00000000..ee0ffaae
> --- /dev/null
> +++ b/tests/xfs/738
> @@ -0,0 +1,48 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 738
> +#
> +# Make sure we can't format a filesystem with insane extent hints.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +testfile=$TEST_DIR/$seq.txt
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch_nocheck
> +
> +rm -f $seqres.full
> +
> +# Try regular extent size hint
> +echo extszinherit >> $seqres.full
> +_scratch_mkfs -d extszinherit=8388608 >> $seqres.full 2>&1
> +test $? -eq 1 || echo "should have failed extszinherit"

That won't fail on 64k block size filesystems....

> +# Try cow extent size hint if supported
> +$MKFS_XFS_PROG -N -f $SCRATCH_DEV > $tmp.mkfs
> +if grep -q 'reflink=' $tmp.mkfs ; then

That's testing mkfs for reflink support, yes? i.e.

_scratch_mkfs_xfs_supported -m crc=1,reflink=1 

[ need to explicitly say -m crc=1 here, because MKFS_OPTIONS might
have -m crc=0, right? ]

> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -515,6 +515,7 @@
>  731 dangerous_scrub dangerous_online_repair
>  736 auto quick unlink
>  737 auto quick unlink
> +738 auto quick

prealloc, too. And maybe mkfs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
