Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49045 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdIVTA1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 15:00:27 -0400
Date: Fri, 22 Sep 2017 12:00:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs/realtime: Fix direct invocations of xfs_repair
Message-ID: <20170922190022.GK5728@magnolia>
References: <20170922020240.2503987-1-rwareing@fb.com>
 <20170922020240.2503987-4-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922020240.2503987-4-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 07:02:40PM -0700, Richard Wareing wrote:
> Fixes direct invocations of xfs_repair to add in -r option if required.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>
> ---
>  tests/xfs/070 | 4 ++--
>  tests/xfs/291 | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/070 b/tests/xfs/070
> index 0ae6eff..453f6cc 100755
> --- a/tests/xfs/070
> +++ b/tests/xfs/070
> @@ -56,8 +56,8 @@ _cleanup()
>  _xfs_repair_noscan()
>  {
>  	# invoke repair directly so we can kill the process if need be
> -	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
> -	repair_pid=$!

This breaks the 'kill -9 $repair_pid' further down.

--D

> +	[ -n "$SCRATCH_RTDEV" ] && rt_repair_opts="-r $SCRATCH_RTDEV"
> +	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
>  
>  	# monitor progress for as long as it is running
>  	while [ `pgrep xfs_repair` ]; do
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 3f5295c..140fa33 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -122,7 +122,8 @@ _xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
>  # Can xfs_metadump cope with this monster?
>  _scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
>  xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
> -xfs_repair -f $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
> +[ -n "$SCRATCH_RTDEV" ] && rt_repair_opts="-r $SCRATCH_RTDEV"
> +xfs_repair $rt_repair_opts -f $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
>  
>  # Yes it can; success, all done
>  status=0
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
