Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727409AbeGaMLY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Jul 2018 08:11:24 -0400
Date: Tue, 31 Jul 2018 06:31:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: move extent busy tree initialization to
 xfs_initialize_perag
Message-ID: <20180731103142.GA39795@bfoster>
References: <20180731035812.GU30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731035812.GU30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 30, 2018 at 08:58:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the per-AG busy extent tree initialization to the per-ag structure
> initialization since we don't want online repair to leak the old tree.
> We only deconstruct the tree at unmount time, so this should be safe.
> This also enables us to eliminate the commented out initialization in
> the xfsprogs libxfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |    3 ---
>  fs/xfs/xfs_mount.c        |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3c3f2d5119ea..9847c1632712 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2755,9 +2755,6 @@ xfs_alloc_read_agf(
>  		pag->pagf_levels[XFS_BTNUM_RMAPi] =
>  			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
>  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
> -		spin_lock_init(&pag->pagb_lock);
> -		pag->pagb_count = 0;
> -		pag->pagb_tree = RB_ROOT;
>  		pag->pagf_init = 1;
>  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
>  	}
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 8f739e4d0d1c..99db27d6ac8a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -207,6 +207,9 @@ xfs_initialize_perag(
>  		if (xfs_buf_hash_init(pag))
>  			goto out_free_pag;
>  		init_waitqueue_head(&pag->pagb_wait);
> +		spin_lock_init(&pag->pagb_lock);
> +		pag->pagb_count = 0;
> +		pag->pagb_tree = RB_ROOT;
>  
>  		if (radix_tree_preload(GFP_NOFS))
>  			goto out_hash_destroy;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
