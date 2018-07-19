Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:37367 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeGSNIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 09:08:47 -0400
Received: by mail-wr1-f47.google.com with SMTP id q10-v6so7887716wrd.4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 05:25:51 -0700 (PDT)
Date: Thu, 19 Jul 2018 14:25:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/8] xfs: trivial xfs_btree_del_cursor cleanups
Message-ID: <20180719122547.etvommd76q5wfqfb@odin.usersys.redhat.com>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192905163.31685.17441257298247003323.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192905163.31685.17441257298247003323.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:50:51AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The error argument to xfs_btree_del_cursor already understands the
> "nonzero for error" semantics, so remove pointless error testing in the
> callers and pass it directly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c         |   24 ++++++++----------------
>  fs/xfs/libxfs/xfs_bmap_btree.c   |    2 +-
>  fs/xfs/libxfs/xfs_ialloc.c       |    2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
>  fs/xfs/libxfs/xfs_refcount.c     |    2 +-
>  fs/xfs/libxfs/xfs_rmap.c         |   18 +++---------------
>  fs/xfs/scrub/bmap.c              |    5 ++---
>  fs/xfs/scrub/repair.c            |    2 +-
>  fs/xfs/xfs_discard.c             |    2 +-
>  fs/xfs/xfs_fsmap.c               |    2 +-
>  fs/xfs/xfs_itable.c              |    6 ++----
>  fs/xfs/xfs_reflink.c             |    2 +-
>  12 files changed, 23 insertions(+), 46 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7205268b30bc..50119b54a2b5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -975,8 +975,7 @@ xfs_bmap_add_attrfork_extents(
>  		flags, XFS_DATA_FORK);
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
> -		xfs_btree_del_cursor(cur,
> -			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  	}
>  	return error;
>  }
> @@ -4500,8 +4499,7 @@ xfs_bmapi_write(
>  				       bma.cur->bc_private.b.firstblock));
>  			*firstblock = bma.cur->bc_private.b.firstblock;
>  		}
> -		xfs_btree_del_cursor(bma.cur,
> -			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(bma.cur, error);
>  	}
>  	if (!error)
>  		xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
> @@ -4599,10 +4597,8 @@ xfs_bmapi_remap(
>  
>  	if (logflags)
>  		xfs_trans_log_inode(tp, ip, logflags);
> -	if (cur) {
> -		xfs_btree_del_cursor(cur,
> -				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> -	}
> +	if (cur)
> +		xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
>  
> @@ -5505,8 +5501,7 @@ __xfs_bunmapi(
>  			*firstblock = cur->bc_private.b.firstblock;
>  			cur->bc_private.b.allocated = 0;
>  		}
> -		xfs_btree_del_cursor(cur,
> -			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  	}
>  	return error;
>  }
> @@ -5773,8 +5768,7 @@ xfs_bmap_collapse_extents(
>  	*next_fsb = got.br_startoff;
>  del_cursor:
>  	if (cur)
> -		xfs_btree_del_cursor(cur,
> -			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  	if (logflags)
>  		xfs_trans_log_inode(tp, ip, logflags);
>  	return error;
> @@ -5905,8 +5899,7 @@ xfs_bmap_insert_extents(
>  	*next_fsb = got.br_startoff;
>  del_cursor:
>  	if (cur)
> -		xfs_btree_del_cursor(cur,
> -			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  	if (logflags)
>  		xfs_trans_log_inode(tp, ip, logflags);
>  	return error;
> @@ -6026,8 +6019,7 @@ xfs_bmap_split_extent_at(
>  del_cursor:
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
> -		xfs_btree_del_cursor(cur,
> -				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  	}
>  
>  	if (logflags)
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index e1a2d9ceb615..cd2da4ef614f 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -645,7 +645,7 @@ xfs_bmbt_change_owner(
>  	cur->bc_private.b.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
>  
>  	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 0d968e8143aa..dd0a0fb0abc8 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2260,7 +2260,7 @@ xfs_imap_lookup(
>  	}
>  
>  	xfs_trans_brelse(tp, agbp);
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index a5237afec5ab..735a33252eb2 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -566,7 +566,7 @@ xfs_inobt_count_blocks(
>  
>  	cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno, btnum);
>  	error = xfs_btree_count_blocks(cur, tree_blocks);
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	xfs_buf_relse(agbp);
>  
>  	return error;
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 9dda6fd0bb13..240a32984d13 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1067,7 +1067,7 @@ xfs_refcount_finish_one_cleanup(
>  	if (rcur == NULL)
>  		return;
>  	agbp = rcur->bc_private.a.agbp;
> -	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(rcur, error);
>  	if (error)
>  		xfs_trans_brelse(tp, agbp);
>  }
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 8b2a2f81d110..fb266fa2cc45 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -670,14 +670,8 @@ xfs_rmap_free(
>  	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
>  
>  	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
> -	if (error)
> -		goto out_error;
>  
> -	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> -	return 0;
> -
> -out_error:
> -	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
>  
> @@ -912,14 +906,8 @@ xfs_rmap_alloc(
>  
>  	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
>  	error = xfs_rmap_map(cur, bno, len, false, oinfo);
> -	if (error)
> -		goto out_error;
>  
> -	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> -	return 0;
> -
> -out_error:
> -	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
>  
> @@ -2156,7 +2144,7 @@ xfs_rmap_finish_one_cleanup(
>  	if (rcur == NULL)
>  		return;
>  	agbp = rcur->bc_private.a.agbp;
> -	xfs_btree_del_cursor(rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(rcur, error);
>  	if (error)
>  		xfs_trans_brelse(tp, agbp);
>  }
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 3d08589f5c60..ebbfab173e97 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -404,8 +404,7 @@ xfs_scrub_bmap_btree(
>  	cur = xfs_bmbt_init_cursor(mp, sc->tp, ip, whichfork);
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
>  	error = xfs_scrub_btree(sc, cur, xfs_scrub_bmapbt_rec, &oinfo, info);
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR :
> -					  XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
>  
> @@ -514,7 +513,7 @@ xfs_scrub_bmap_check_ag_rmaps(
>  	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
>  		error = 0;
>  
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  out_agf:
>  	xfs_trans_brelse(sc->tp, agf);
>  	return error;
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 326be4e8b71e..35c589a04fac 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1009,7 +1009,7 @@ xfs_repair_find_ag_btree_roots(
>  
>  	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
>  	error = xfs_rmap_query_all(cur, xfs_repair_findroot_rmap, &ri);
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 678a5fcd7576..93f07edafd81 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -128,7 +128,7 @@ xfs_trim_extents(
>  	}
>  
>  out_del_cursor:
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	xfs_buf_relse(agbp);
>  out_put_perag:
>  	xfs_perag_put(pag);
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index c7157bc48bd1..f7e00e42f360 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -219,7 +219,7 @@ xfs_getfsmap_is_shared(
>  	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
>  			rec->rm_blockcount, &fbno, &flen, false);
>  
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 24f4f1c555b5..65810827a8d0 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -458,8 +458,7 @@ xfs_bulkstat(
>  		 * pending error, then we are done.
>  		 */
>  del_cursor:
> -		xfs_btree_del_cursor(cur, error ?
> -					  XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +		xfs_btree_del_cursor(cur, error);
>  		xfs_buf_relse(agbp);
>  		if (error)
>  			break;
> @@ -632,8 +631,7 @@ xfs_inumbers(
>  
>  	kmem_free(buffer);
>  	if (cur)
> -		xfs_btree_del_cursor(cur, (error ? XFS_BTREE_ERROR :
> -					   XFS_BTREE_NOERROR));
> +		xfs_btree_del_cursor(cur, error);
>  	if (agbp)
>  		xfs_buf_relse(agbp);
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 592fb2071a03..268d51e35812 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -162,7 +162,7 @@ xfs_reflink_find_shared(
>  	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
>  			find_end_of_shared);
>  
> -	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(cur, error);
>  
>  	xfs_trans_brelse(tp, agbp);
>  	return error;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
