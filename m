Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67E24594D;
	Mon, 19 Aug 2024 05:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724044902; cv=none; b=U1Cs07ySWBmuO20GkAC4K4hn/bul2kYg5i7qBsCYefq7yC03NFdpt4WDcazQMKPKe5oManufHIRFUey21WUz19AEo4MHZTy6bdLxwS0n+GV3bB+vvXdxpP8jRul1iM0VLIpKFP8hGy00UXCksmmPpPzz96ChMmNQY4tEbaex6dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724044902; c=relaxed/simple;
	bh=Nk53ja8l6ZSorPqgLK4v3HcIbCyr8MB3FKgTwqIV7rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0GrEA5WA++lkJFTWiYOa0ows7hZZ6LaHwGsYRaXKpuNCRZE9iXH2xWmMR5mJHwoRKC7zBOyRm7n+DirBCvr1FVpqMhbabv3ThV/qzKcuSSHgqrCKG7y4wJzTD2BPC/Um8bJjpL+S6ti8u00fiqoYK+IKzX8T51/4DsEjQ8+pb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VX2gnxSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VX2gnxSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C7EC32782;
	Mon, 19 Aug 2024 05:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724044901;
	bh=Nk53ja8l6ZSorPqgLK4v3HcIbCyr8MB3FKgTwqIV7rI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VX2gnxSxAjbYVxzNfeXYqN52YYUIamgyGsVizk6usgKUgF3+A046OWvZRg8IoqRLR
	 ltCJheea30fjbt4IlfEOXjbyzP+X6FLmhYpUpBvgFdPkbL5ULbUtpQOi5Y+ExViMUB
	 ECw8ULpoUD3nnhNccHrIjK0uTblBQ3Xsn2Gp8MGrjBMFvmjA178AtMziyYC9zjUZqn
	 8LrcxNE/ssOqjlWucGKmnjqIrivR5/0Gd3SOms6r3OeV6W8zWSBBJ6b7LxiSaRSYvu
	 KDvpGum7LBAcLgDDb+eFK6zFR/rcEl2JooOwrr5IJQ+ki8MX6O4Wae10sKIrH+rWZV
	 39BWaBDkANliQ==
Date: Sun, 18 Aug 2024 22:21:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V4 1/2] xfs: Fix the owner setting issue for rmap query
 in xfs fsmap
Message-ID: <20240819052140.GN865349@frogsfrogsfrogs>
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <20240819005320.304211-2-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819005320.304211-2-wozizhi@huawei.com>

On Mon, Aug 19, 2024 at 08:53:19AM +0800, Zizhi Wo wrote:
> I notice a rmap query bug in xfs_io fsmap:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>  EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
>    0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
>    1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
>    2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
>    3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
>    4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
>    5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
>    6: 253:16 [104..127]:           free space                          0  (104..127)               24
>    ......
> 
> Bug:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
> [root@fedora ~]#
> Normally, we should be able to get one record, but we got nothing.
> 
> The root cause of this problem lies in the incorrect setting of rm_owner in
> the rmap query. In the case of the initial query where the owner is not
> set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
> This is done to prevent any omissions when comparing rmap items. However,
> if the current ag is detected to be the last one, the function sets info's
> high_irec based on the provided key. If high->rm_owner is not specified, it
> should continue to be set to ULLONG_MAX; otherwise, there will be issues
> with interval omissions. For example, consider "start" and "end" within the
> same block. If high->rm_owner == 0, it will be smaller than the founded
> record in rmapbt, resulting in a query with no records. The main call stack
> is as follows:
> 
> xfs_ioc_getfsmap
>   xfs_getfsmap
>     xfs_getfsmap_datadev_rmapbt
>       __xfs_getfsmap_datadev
>         info->high.rm_owner = ULLONG_MAX
>         if (pag->pag_agno == end_ag)
> 	  xfs_fsmap_owner_to_rmap
> 	    // set info->high.rm_owner = 0 because fmr_owner == -1ULL
> 	    dest->rm_owner = 0
> 	// get nothing
> 	xfs_getfsmap_datadev_rmapbt_query
> 
> The problem can be resolved by simply modify the xfs_fsmap_owner_to_rmap
> function internal logic to achieve.
> 
> After applying this patch, the above problem have been solved:
> [root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
>  EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
>    0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8
> 
> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 85dbb46452ca..3a30b36779db 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -71,7 +71,7 @@ xfs_fsmap_owner_to_rmap(
>  	switch (src->fmr_owner) {
>  	case 0:			/* "lowest owner id possible" */
>  	case -1ULL:		/* "highest owner id possible" */
> -		dest->rm_owner = 0;
> +		dest->rm_owner = src->fmr_owner;
>  		break;
>  	case XFS_FMR_OWN_FREE:
>  		dest->rm_owner = XFS_RMAP_OWN_NULL;
> -- 
> 2.39.2
> 
> 
