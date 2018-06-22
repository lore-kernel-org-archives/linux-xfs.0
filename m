Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeFVGfu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:35:50 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 5/8] xfs: recheck reflink state after grabbing
 ILOCK_SHARED for a write
References: <152960594943.26479.1457883867468749220.stgit@magnolia>
 <152960596196.26479.13083497192197135552.stgit@magnolia>
Message-ID: <d67f52df-2347-41d1-13c6-7411938ab99a@oracle.com>
Date: Thu, 21 Jun 2018 23:35:38 -0700
MIME-Version: 1.0
In-Reply-To: <152960596196.26479.13083497192197135552.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 06/21/2018 11:31 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In "xfs: fix fdblocks accounting w/ RMAPBT per-AG reservation", we fixed
> the per-ag reservation code so that we always decrease fdblocks by the
> reserved size because rmapbt blocks are counted as free space.
> 
> The primary symptom of this bug is that if the rmapbt has expanded since
> mount time, the disk block counters reported via statfs will change
> across a remount.  Therefore, we exercise this as a regression test.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   tests/xfs/712     |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/712.out |    1 +
>   tests/xfs/group   |    1 +
>   3 files changed, 64 insertions(+)
>   create mode 100755 tests/xfs/712
>   create mode 100644 tests/xfs/712.out

Humm, was there supposed to be more to this maybe?  Shouldn't we see a 
712.out somewhere?
> 
> 
> diff --git a/tests/xfs/712 b/tests/xfs/712
> new file mode 100755
> index 00000000..f90c7ec9
> --- /dev/null
> +++ b/tests/xfs/712
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle, Inc.  All rights reserved.
> +#
> +# FS QA Test No. 712
> +#
> +# Make sure that the statfs b_avail counter doesn't change across remount
> +# after the rmapbt has grown in size.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +. ./common/filter
> +
> +# remo
> 
