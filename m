Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33638 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdCOTAR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 15:00:17 -0400
Date: Wed, 15 Mar 2017 12:00:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: warn about dirty log with -n option
Message-ID: <20170315190011.GE5280@birch.djwong.org>
References: <a59b1187-cf8c-56ac-565d-9c37472730c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59b1187-cf8c-56ac-565d-9c37472730c4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 01:32:34PM -0500, Eric Sandeen wrote:
> When looking at xfs_repair -n output today, we have no idea if
> reported errors may be due to an un-replayed dirty log.  If this
> is the case, mention it in the output.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> pls check double-check my logic for the 3 cases :)
> 
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 5964244..c21778b 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -90,11 +90,16 @@ zero_log(
>  	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
>  				head_blk, tail_blk);
>  		}
> -		if (!no_modify && head_blk != tail_blk) {
> -			if (zap_log) {
> +		if (head_blk != tail_blk) {
> +			if (!no_modify && zap_log) {
>  				do_warn(_(
>  "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
>  "destroyed because the -L option was used.\n"));
> +			} else if (no_modify) {
> +				do_warn(_(
> +"ALERT: The filesystem has valuable metadata changes in a log which is being\n"
> +"ignored because the -n option was used.  Expect spurious inconsistencies\n"
> +"which may be resolved by first mounting the filesystem to replay the log.\n"));
>  			} else {
>  				do_warn(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
