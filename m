Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40332 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730195AbeGSNLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 09:11:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id t6-v6so7882315wrn.7
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 05:28:48 -0700 (PDT)
Date: Thu, 19 Jul 2018 14:28:45 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/8] xfs: clean up xfs_btree_del_cursor callers
Message-ID: <20180719122845.t56jxc4cmjd7l3xp@odin.usersys.redhat.com>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905779.31685.9007503975897283723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192905779.31685.9007503975897283723.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:50:57AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Less trivial cleanups of the error argument to xfs_btree_del_cursor;
> these require some minor code refactoring.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_refcount.c |   11 +++--------
>  fs/xfs/scrub/repair.c        |    7 +++----
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 240a32984d13..a38e5840a73f 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1675,11 +1675,11 @@ xfs_refcount_recover_cow_leftovers(
>  	high.rc.rc_startblock = -1U;
>  	error = xfs_btree_query_range(cur, &low, &high,
>  			xfs_refcount_recover_extent, &debris);
> -	if (error)
> -		goto out_cursor;
> -	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	xfs_trans_brelse(tp, agbp);
>  	xfs_trans_cancel(tp);
> +	if (error)
> +		goto out_free;
>  
>  	/* Now iterate the list to free the leftovers */
>  	list_for_each_entry_safe(rr, n, &debris, rr_list) {
> @@ -1727,11 +1727,6 @@ xfs_refcount_recover_cow_leftovers(
>  		kmem_free(rr);
>  	}
>  	return error;
> -
> -out_cursor:
> -	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> -	xfs_trans_brelse(tp, agbp);
> -	goto out_trans;
>  }
>  
>  /* Is there a record covering a given extent? */
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 35c589a04fac..ea39e2bdc96a 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -747,9 +747,9 @@ xfs_repair_dispose_btree_block(
>  
>  	/* Can we find any other rmappings? */
>  	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
> +	xfs_btree_del_cursor(cur, error);
>  	if (error)
> -		goto out_cur;
> -	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +		goto out_free;
>  
>  	/*
>  	 * If there are other rmappings, this block is cross linked and must
> @@ -779,8 +779,7 @@ xfs_repair_dispose_btree_block(
>  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
>  	return xfs_repair_roll_ag_trans(sc);
>  
> -out_cur:
> -	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +out_free:
>  	if (agf_bp != sc->sa.agf_bp)
>  		xfs_trans_brelse(sc->tp, agf_bp);
>  	return error;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
