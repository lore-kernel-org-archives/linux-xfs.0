Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752249AbeCOOZv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 10:25:51 -0400
Date: Thu, 15 Mar 2018 10:25:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC][PATCH] xfs: adjust size/used/avail information for quota-df
Message-ID: <20180315142549.GC45325@bfoster.bfoster>
References: <1520601355-180600-1-git-send-email-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1520601355-180600-1-git-send-email-cgxu519@gmx.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chengguang Xu <cgxu519@gmx.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Fri, Mar 09, 2018 at 09:15:55PM +0800, Chengguang Xu wrote:
> In order to more accurately reflect size/used/avail information
> for quota-df, slightly adjust related counting logic.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> 
> Hello folks,
> 
> Recently I’m testing  project quota  for our container users and found
> sometimes the result of df command could not exactly represent
> block/inode usage amount. So I checked  the logic in function xfs_qm_statvfs()
> and I think it might be better if slightly adjusting the counting logic.
> What do you think?
> 
> Terms:
> # Size(F)   - The size field  in df result of filesystem
> # Size(Q) - The size field of in df result of pquota-dir
> # Used(F) - The used field  in df result of filesystem
> # Used(Q) - The used field  in df result of pquota-dir
> # Avail(F)  - The avail field  in df result of filesystem
> # Avail(Q)  - The avail field  in df result of pquota-dir
> # Used(A) - Actual used
> 
> Problems that I found.
> 1) Avail(Q) can be higher than Avail(F)

Does this refer to a quota limit that exceeds the size of the fs? I'm
not sure that's necessarily a problem.

> 2) Used(A) can be higher than Used(Q)
> 

I'm not quite sure what this means.

As it is, the commit log doesn't clearly explain the problem you're
trying to solve. Perhaps you should provide some example commands and
output that demonstrate the problem and solution.

> 
>  fs/xfs/xfs_qm_bhv.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 2be6d27..cb2e6c9 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -38,21 +38,41 @@
>  	limit = dqp->q_core.d_blk_softlimit ?
>  		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
>  		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> -	if (limit && statp->f_blocks > limit) {
> -		statp->f_blocks = limit;
> -		statp->f_bfree = statp->f_bavail =
> -			(statp->f_blocks > dqp->q_res_bcount) ?
> -			 (statp->f_blocks - dqp->q_res_bcount) : 0;

So the current logic is that if there's a quota limit and the limit is
more restrictive than the fs, we clamp the stat size/free info to the
pquota limit.

> +
> +	if (limit) {
> +		if (limit > dqp->q_res_bcount + statp->f_bavail)
> +			statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;
> +		else
> +			statp->f_blocks = limit;
> +	} else {
> +		statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;
> +	}
> +

Now it looks like we fix up f_blocks regardless of whether there's a
limit set. IOW:

	if (limit && limit <= dqp->q_res_bcount + statp->f_bavail)
		statp->f_blocks = limit;
	else
		statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;

The purpose of the original code was to make a subtree with a pquota
appear like a smaller fs to a subtenant, for example. What is the
additional purpose of the f_blocks adjustment?

> +	if (dqp->q_res_bcount >= statp->f_blocks) {
> +		statp->f_blocks = dqp->q_res_bcount;
> +		statp->f_bfree = statp->f_bavail = 0;
> +	} else {
> +		statp->f_bfree = statp->f_bavail = statp->f_blocks - dqp->q_res_bcount;
>  	}

q_res_bcount is a component of f_blocks in the else case above, so I
think the first case here turns the logic into something like:

	if (limit && limit <= dqp->q_res_bcount + statp->f_bavail) {
		if (dqp->q_res_bcount > limit)
			limit = dqp->q_res_bcount;
		statp->f_blocks = limit;
	} else
		statp->f_blocks = dqp->q_res_bcount + statp->f_bavail;
	statp->f_bfree = statp->f_bavail = statp->f_blocks - dqp->q_res_bcount;

Is the purpose here to deal with an over limit soft quota or something?

Brian

>  
>  	limit = dqp->q_core.d_ino_softlimit ?
>  		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
>  		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> -	if (limit && statp->f_files > limit) {
> -		statp->f_files = limit;
> -		statp->f_ffree =
> -			(statp->f_files > dqp->q_res_icount) ?
> -			 (statp->f_ffree - dqp->q_res_icount) : 0;
> +
> +	if (limit) {
> +		if (limit > dqp->q_res_icount + statp->f_ffree)
> +			statp->f_files = dqp->q_res_icount + statp->f_ffree;
> +		else
> +			statp->f_files = limit;
> +	} else {
> +		statp->f_files = dqp->q_res_icount + statp->f_ffree;
> +	}
> +
> +	if (dqp->q_res_icount >= statp->f_files) {
> +		statp->f_files = dqp->q_res_icount;
> +		statp->f_ffree = 0;
> +	} else {
> +		statp->f_ffree = statp->f_files - dqp->q_res_icount;
>  	}
>  }
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
