Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42639 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935678AbdIYVec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 17:34:32 -0400
Date: Mon, 25 Sep 2017 14:34:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 3/3] xfs/realtime: Fix direct invocations of xfs_repair
Message-ID: <20170925213428.GB5020@magnolia>
References: <20170925195625.756877-1-rwareing@fb.com>
 <20170925195625.756877-3-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170925195625.756877-3-rwareing@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Richard Wareing <rwareing@fb.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Sep 25, 2017 at 12:56:25PM -0700, Richard Wareing wrote:
> Fixes direct invocations of xfs_repair to add in -r option if required.
> 
> Signed-off-by: Richard Wareing <rwareing@fb.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> Changes since v1:
> * Fixed kill -9 in test xfs/070
> 
>  tests/xfs/070 | 3 ++-
>  tests/xfs/291 | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/070 b/tests/xfs/070
> index 0ae6eff..a06e998 100755
> --- a/tests/xfs/070
> +++ b/tests/xfs/070
> @@ -56,7 +56,8 @@ _cleanup()
>  _xfs_repair_noscan()
>  {
>  	# invoke repair directly so we can kill the process if need be
> -	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
> +	[ -n "$SCRATCH_RTDEV" ] && rt_repair_opts="-r $SCRATCH_RTDEV"
> +	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
>  	repair_pid=$!
>  
>  	# monitor progress for as long as it is running
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
