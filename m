Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729717AbeGQRro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 13:47:44 -0400
Date: Tue, 17 Jul 2018 10:13:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] libxfs: Fix a couple of sparse complaintis
Message-ID: <20180717171352.GT32415@magnolia>
References: <20180717094544.24144-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717094544.24144-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 17, 2018 at 11:45:44AM +0200, Carlos Maiolino wrote:
> No significant changes, just silence a couple of sparse errors.
> 
> Using cpu_to_be32(NULLAGINO), the NULLAGINO constant will be encoded in
> BE as a constant, avoiding a BE -> CPU conversion every iteraction of
> the loop, if be32_to_cpu(agi->agi_unlinked[i]) was used instead.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2:
> 	Convert NULLAGINO to BE32 instead of converting agi_unlinked[i] to cpu
> 
>  fs/xfs/libxfs/xfs_ag_resv.h | 2 +-
>  fs/xfs/libxfs/xfs_ialloc.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index 4619b554ee90..dc953fc84b2f 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -28,7 +28,7 @@ xfs_ag_resv_rmapbt_alloc(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno)
>  {
> -	struct xfs_alloc_arg	args = {0};
> +	struct xfs_alloc_arg	args = { NULL };
>  	struct xfs_perag	*pag;
>  
>  	args.len = 1;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 0d968e8143aa..9a6bada8a919 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2539,7 +2539,7 @@ xfs_agi_verify(
>  		return __this_address;
>  
>  	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> -		if (agi->agi_unlinked[i] == NULLAGINO)
> +		if (agi->agi_unlinked[i] == cpu_to_be32(NULLAGINO))
>  			continue;
>  		if (!xfs_verify_ino(mp, be32_to_cpu(agi->agi_unlinked[i])))
>  			return __this_address;
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
