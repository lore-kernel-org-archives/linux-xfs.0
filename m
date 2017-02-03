Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48766 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbdBCW5d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 17:57:33 -0500
Subject: Re: [PATCH] xfs: correct null checks and error processing in
 xfs_initialize_perag
References: <20170120142642.21698-1-colin.king@canonical.com>
 <20170128191957.13851-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <253f0f36-2a6e-8c2b-a4bf-c1526c356016@sandeen.net>
Date: Fri, 3 Feb 2017 16:57:31 -0600
MIME-Version: 1.0
In-Reply-To: <20170128191957.13851-1-billodo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

On 1/28/17 1:19 PM, Bill O'Donnell wrote:
> If pag cannot be allocated, the current error exit path will trip
> a null pointer deference error when calling xfs_buf_hash_destroy
> with a null pag.  Fix this by adding a new error exit labels and
> jumping to those accordingly, avoiding the hash destroy and
> unnecessary kmem_free on pag.
> 
> Up to three things need to be properly unwound:
> 
> 1) pag memory allocation
> 2) xfs_buf_hash_init
> 3) radix_tree_insert
> 
> For any given iteration through the loop, any of the above which
> succeed must be unwound for /this/ pag, and then all prior
> initialized pags must be unwound.
> 
> Fixes CoverityScan CID#1397628 ("Dereference after null check")
> 
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9b9540d..b074d2a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -190,6 +190,7 @@ xfs_initialize_perag(
>  	xfs_agnumber_t	first_initialised = 0;
>  	xfs_perag_t	*pag;
>  	int		error = -ENOMEM;
> +	bool		first_init_done = false;
>  
>  	/*
>  	 * Walk the current per-ag tree so we don't try to initialise AGs
> @@ -202,22 +203,20 @@ xfs_initialize_perag(
>  			xfs_perag_put(pag);
>  			continue;
>  		}
> -		if (!first_initialised)
> -			first_initialised = index;
>  
>  		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
>  		if (!pag)
> -			goto out_unwind;
> +			goto out_unwind_new_pags;
>  		pag->pag_agno = index;
>  		pag->pag_mount = mp;
>  		spin_lock_init(&pag->pag_ici_lock);
>  		mutex_init(&pag->pag_ici_reclaim_lock);
>  		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
>  		if (xfs_buf_hash_init(pag))
> -			goto out_unwind;
> +			goto out_free_pag;

now the hash is initialized
 
>  		if (radix_tree_preload(GFP_NOFS))
> -			goto out_unwind;
> +			goto out_free_pag;

but we doesn't destroy it if we fail here and goto out_free_pag
 
>  		spin_lock(&mp->m_perag_lock);
>  		if (radix_tree_insert(&mp->m_perag_tree, index, pag)) {
> @@ -225,10 +224,15 @@ xfs_initialize_perag(
>  			spin_unlock(&mp->m_perag_lock);
>  			radix_tree_preload_end();
>  			error = -EEXIST;
> -			goto out_unwind;
> +			goto out_hash_destroy;
>  		}
>  		spin_unlock(&mp->m_perag_lock);
>  		radix_tree_preload_end();
> +		/* a pag is fully initialized */
> +		if (!first_init_done) {
> +			first_initialised = index;
> +			first_init_done = true;
> +		}
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> @@ -239,13 +243,24 @@ xfs_initialize_perag(
>  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
>  	return 0;
>  
> -out_unwind:
> +out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
> +out_free_pag:
>  	kmem_free(pag);
> -	for (; index > first_initialised; index--) {
> -		pag = radix_tree_delete(&mp->m_perag_tree, index);
> -		xfs_buf_hash_destroy(pag);
> -		kmem_free(pag);
> +out_unwind_new_pags:
> +	/* unwind any newly initialized pags */
> +	if (first_init_done) {
> +		index--;
> +		do {
> +			pag = radix_tree_delete(&mp->m_perag_tree, index);
> +			if (pag) {

I think that if this has all been done right keeping careful
track of what was last initialized, there is no need to test
if (pag).  If you'd like to use if (pag) in lieu of some of the
other controls that's fine too, but I don't really see a reason
for both.

Just a style thing I guess, take it or leave it.

-Eric

> +				xfs_buf_hash_destroy(pag);
> +				kmem_free(pag);
> +			}
> +			if (!index)
> +				break;
> +			index--;
> +		} while (index >= first_initialised);

>  	}
>  	return error;
>  }
> 
