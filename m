Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38483 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbeEBIoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 04:44:06 -0400
Date: Wed, 2 May 2018 16:44:01 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 7/9] xfs/422: add fsstress to the freeze-and-rmap-repair
 race test
Message-ID: <20180502084401.GD29084@desktop>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
 <152518920390.23023.633707441886698447.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152518920390.23023.633707441886698447.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, May 01, 2018 at 08:40:03AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add fsstress to the pile of things that we race with rmap repair to
> ensure that the rmap repair isolates the filesystem correctly while it
> is doing its repairs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/422 |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/422 b/tests/xfs/422
> index a8fa5d5a..b2db713c 100755
> --- a/tests/xfs/422
> +++ b/tests/xfs/422
> @@ -51,6 +51,8 @@ _supported_fs xfs
>  _require_xfs_scratch_rmapbt
>  _require_xfs_io_command "scrub"
>  _require_xfs_io_error_injection "force_repair"
> +_require_command "$KILLALL_PROG" killall
> +_require_command "$FSSTRESS_PROG" fsstress

This is not needed, as we already have

export FSSTRESS_PROG="./ltp/fsstress"                                                                                                                                                          
[ ! -x $FSSTRESS_PROG ] && _fatal "fsstress not found or executable"

in common/config. I can remove it on commit.

Thanks,
Eryu

>  
>  echo "Format and populate"
>  _scratch_mkfs > "$seqres.full" 2>&1
> @@ -89,18 +91,33 @@ repair_loop() {
>  		$XFS_IO_PROG -x -c 'repair rmapbt 0' -c 'repair rmapbt 1' $SCRATCH_MNT 2>&1 | filter_output
>  	done
>  }
> +stress_loop() {
> +	end="$1"
> +
> +	FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
> +	while [ "$(date +%s)" -lt $end ]; do
> +		$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
> +	done
> +}
>  $XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
>  
>  start=$(date +%s)
>  end=$((start + (30 * TIME_FACTOR) ))
>  
>  echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
> +stress_loop $end &
>  freeze_loop $end &
>  repair_loop $end &
>  
> -while [ "$(date +%s)" -lt $end ]; do
> +# Wait until 2 seconds after the loops should have finished...
> +while [ "$(date +%s)" -lt $((end + 2)) ]; do
>  	sleep 1
>  done
> +
> +# ...and clean up after the loops in case they didn't do it themselves.
> +$KILLALL_PROG -TERM xfs_io fsstress >> $seqres.full 2>&1
> +$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
> +
>  echo "Loop finished at $(date)" >> $seqres.full
>  echo "Test done"
>  
> 
