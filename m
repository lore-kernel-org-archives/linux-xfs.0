Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39491 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732372AbfAOUXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 15:23:39 -0500
Date: Wed, 16 Jan 2019 07:23:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't crash when read verifier reports errors with
 null b_ops
Message-ID: <20190115202336.GI4205@dastard>
References: <20190115170820.GB12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115170820.GB12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 15, 2019 at 09:08:20AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xrep_findroot_block, we work out the btree type and correctness of a
> given block by calling different btree verifiers on root block
> candidates.  However, we leave the NULL b_ops while ->verify_read
> validates the block, which means that if the verifier calls
> xfs_buf_verifier_error it'll crash on the null b_ops.  Fix it to avoid
> this crash.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> FWIW I also thought about stuffing in a fake b_ops while xrep_findroot
> is calling a candidate read verifier, but thought that might just
> confuse things more?
> ---
>  fs/xfs/xfs_error.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9866f542e77b..2a02be280769 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -359,7 +359,7 @@ xfs_buf_verifier_error(
>  
>  	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx %s",
>  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> -		  fa, bp->b_ops->name, bp->b_bn, name);
> +		  fa, bp->b_ops ? bp->b_ops->name : "unknown", bp->b_bn, name);

Looks fine, but can you add a comment to xfs_buf_verifier_error()
that says that some callers might be running the verifiers
themselves rather than through the b_ops structure and so it may be
null...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
