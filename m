Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49324 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfCHAsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Mar 2019 19:48:16 -0500
Date: Thu, 7 Mar 2019 16:47:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Zero initialize highstale and lowstale in
 xfs_dir2_leafn_add
Message-ID: <20190308004759.GB4676@magnolia>
References: <20190308003413.25068-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308003413.25068-1-natechancellor@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com

On Thu, Mar 07, 2019 at 05:34:13PM -0700, Nathan Chancellor wrote:
> When building with -Wsometimes-uninitialized, Clang warns:
> 
> fs/xfs/libxfs/xfs_dir2_node.c:481:6: warning: variable 'lowstale' is
> used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
> fs/xfs/libxfs/xfs_dir2_node.c:481:6: warning: variable 'highstale' is
> used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
> 
> While it isn't technically wrong, it isn't a problem in practice because
> highstale and lowstale are only initialized in xfs_dir2_leafn_add when
> compact is not zero then they are passed to xfs_dir3_leaf_find_entry,
> where they are initialized before use when compact is zero. Regardless,
> it's better not to be passing around uninitialized stack memory so zero
> initialize these variables, which silences this warning.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/393
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 3b03703c5c3d..de46f26c5292 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -444,6 +444,8 @@ xfs_dir2_leafn_add(
>  
>  	dp = args->dp;
>  	leaf = bp->b_addr;
> +	highstale = 0;
> +	lowstale = 0;

I think it would be a good idea to clean all the typedef junk out of the
function definition as well... but on its own this will at least shut up
the smatch/clang warnings, so:

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I'll have this and the cleanup tested and ready tomorrow, probably...)

Thanks for the contribution!

--D

>  	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
>  	ents = dp->d_ops->leaf_ents_p(leaf);
>  
> -- 
> 2.21.0
> 
