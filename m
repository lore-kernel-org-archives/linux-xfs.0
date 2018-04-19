Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753400AbeDSMzx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:55:53 -0400
Date: Thu, 19 Apr 2018 08:55:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 08/11] xfs: clean up scrub usage of KM_NOFS
Message-ID: <20180419125551.GB25844@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401922624.11465.11624202753005507925.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401922624.11465.11624202753005507925.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:40:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> All scrub code runs in transaction context, which means that memory
> allocations are automatically run in PF_MEMALLOC_NOFS context.  It's
> therefore unnecessary to pass in KM_NOFS to allocation routines, so
> clean them all out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader.c |    3 ++-
>  fs/xfs/scrub/btree.c    |    2 +-
>  fs/xfs/scrub/refcount.c |    2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index aacbc3f..6c6e4d8 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -798,7 +798,8 @@ xfs_scrub_agfl(
>  	}
>  	memset(&sai, 0, sizeof(sai));
>  	sai.sz_entries = agflcount;
> -	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
> +	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
> +			KM_MAYFAIL);
>  	if (!sai.entries) {
>  		error = -ENOMEM;
>  		goto out;
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 5421816..ea972da 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -442,7 +442,7 @@ xfs_scrub_btree_check_owner(
>  	 */
>  	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
>  		co = kmem_alloc(sizeof(struct check_owner),
> -				KM_MAYFAIL | KM_NOFS);
> +				KM_MAYFAIL);
>  		if (!co)
>  			return -ENOMEM;
>  		co->level = level;
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 823bda3..5fff94d 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -150,7 +150,7 @@ xfs_scrub_refcountbt_rmap_check(
>  		 * so we don't need insertion sort here.
>  		 */
>  		frag = kmem_alloc(sizeof(struct xfs_scrub_refcnt_frag),
> -				KM_MAYFAIL | KM_NOFS);
> +				KM_MAYFAIL);
>  		if (!frag)
>  			return -ENOMEM;
>  		memcpy(&frag->rm, rec, sizeof(frag->rm));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
