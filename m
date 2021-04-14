Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD48C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F8C6128E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhDNAGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 20:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhDNAGD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 20:06:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FB2F61246;
        Wed, 14 Apr 2021 00:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618358743;
        bh=bG1wGr1+8KePAL///ru1gYThdWq1MEgxAr2K9zxvxa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tmWiqsfVXpeQC7XBlAmiSe8YG5Jxw4BghexCj2XSiA++1f1bEfs3uZHFl7iM/aOPZ
         Vp0MTUthGg7yRzu7f5qsGY1mnsji8xPZaYMqeBH04i5dN0hFWcqcHl4/C2sKQpFPfq
         uRWzRFzCGVgPdZGNL1FS+/gBpfnD/x8n+TbWNwMvRkEcJ/uvDxp4zmZKllsanAwemB
         LxyNJuKjER7O2pCNQ28YCCzFd1laAUI0Hmtym1K/fhkgMJvYYP35VufK6cJfw10vvK
         ruvgPrNGqPBKXI9PQOmg6xIN3aBIRTOeGz2/9byrhSGgODXkmDzXXRRSJBbO2RfbCT
         QN3Donwm46zUg==
Date:   Tue, 13 Apr 2021 17:05:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/7] xfs: rename and simplify xfs_bmap_one_block
Message-ID: <20210414000542.GP3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:14PM +0200, Christoph Hellwig wrote:
> xfs_bmap_one_block is only called for the attribute fork.  Move it to
> xfs_attr.c, drop the unused whichfork argument and code only executed for
> the data fork and rename the result to xfs_attr_is_leaf.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_attr.h |  1 +
>  fs/xfs/libxfs/xfs_bmap.c | 32 --------------------------------
>  fs/xfs/libxfs/xfs_bmap.h |  1 -
>  fs/xfs/xfs_attr_list.c   |  2 +-
>  5 files changed, 27 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 902e5f7e664231..fd61c67f573925 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -70,6 +70,26 @@ xfs_inode_hasattr(
>  	return 1;
>  }
>  
> +/*
> + * Returns true if the there is exactly only block in the attr fork, in which
> + * case the attribute fork consists of a single leaf block entry.
> + */
> +bool
> +xfs_attr_is_leaf(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_ifork	*ifp = ip->i_afp;
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_bmbt_irec	imap;
> +
> +	if (ifp->if_nextents != 1 || ifp->if_format != XFS_DINODE_FMT_EXTENTS)
> +		return false;
> +
> +	xfs_iext_first(ifp, &icur);
> +	xfs_iext_get_extent(ifp, &icur, &imap);
> +	return imap.br_startoff == 0 && imap.br_blockcount == 1;

/me kinda wonders if this ought to be mp->m_attr_geo->fsbcount, but
seeing as adding support for large xattr blocks would require a full
audit anyway, it's probably not worth fussing over.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +}
> +
>  /*========================================================================
>   * Overall external interface routines.
>   *========================================================================*/
> @@ -89,7 +109,7 @@ xfs_attr_get_ilocked(
>  
>  	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_shortform_getvalue(args);
> -	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
> +	if (xfs_attr_is_leaf(args->dp))
>  		return xfs_attr_leaf_get(args);
>  	return xfs_attr_node_get(args);
>  }
> @@ -293,7 +313,7 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +	if (xfs_attr_is_leaf(dp)) {
>  		error = xfs_attr_leaf_addname(args);
>  		if (error != -ENOSPC)
>  			return error;
> @@ -347,7 +367,7 @@ xfs_has_attr(
>  		return xfs_attr_sf_findname(args, NULL, NULL);
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +	if (xfs_attr_is_leaf(dp)) {
>  		error = xfs_attr_leaf_hasname(args, &bp);
>  
>  		if (bp)
> @@ -374,7 +394,7 @@ xfs_attr_remove_args(
>  	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>  		error = xfs_attr_shortform_remove(args);
> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +	} else if (xfs_attr_is_leaf(dp)) {
>  		error = xfs_attr_leaf_removename(args);
>  	} else {
>  		error = xfs_attr_node_removename(args);
> @@ -1283,7 +1303,7 @@ xfs_attr_node_removename(
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_attr_is_leaf(dp))
>  		error = xfs_attr_node_shrink(args, state);
>  
>  out:
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3e97a935e7121f..2b1f61987a9dec 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -85,6 +85,7 @@ int xfs_attr_inactive(struct xfs_inode *dp);
>  int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
>  int xfs_attr_list(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
> +bool xfs_attr_is_leaf(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1b1b58af41fa7f..e32b8228d9cc2e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1441,38 +1441,6 @@ xfs_bmap_last_offset(
>  	return 0;
>  }
>  
> -/*
> - * Returns whether the selected fork of the inode has exactly one
> - * block or not.  For the data fork we check this matches i_disk_size,
> - * implying the file's range is 0..bsize-1.
> - */
> -int					/* 1=>1 block, 0=>otherwise */
> -xfs_bmap_one_block(
> -	struct xfs_inode	*ip,		/* incore inode */
> -	int			whichfork)	/* data or attr fork */
> -{
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> -	int			rval;		/* return value */
> -	struct xfs_bmbt_irec	s;		/* internal version of extent */
> -	struct xfs_iext_cursor icur;
> -
> -#ifndef DEBUG
> -	if (whichfork == XFS_DATA_FORK)
> -		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
> -#endif	/* !DEBUG */
> -	if (ifp->if_nextents != 1)
> -		return 0;
> -	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS)
> -		return 0;
> -	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
> -	xfs_iext_first(ifp, &icur);
> -	xfs_iext_get_extent(ifp, &icur, &s);
> -	rval = s.br_startoff == 0 && s.br_blockcount == 1;
> -	if (rval && whichfork == XFS_DATA_FORK)
> -		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
> -	return rval;
> -}
> -
>  /*
>   * Extent tree manipulation functions used during allocation.
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index a49df4092c304b..f9a390ecfb1d9a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -200,7 +200,6 @@ int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_fileoff_t *last_block, int whichfork);
>  int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
>  		int whichfork);
> -int	xfs_bmap_one_block(struct xfs_inode *ip, int whichfork);
>  int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
>  		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
>  		int *nmap, int flags);
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 8f8837fe21cf02..25dcc98d50e6da 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -514,7 +514,7 @@ xfs_attr_list_ilocked(
>  		return 0;
>  	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_shortform_list(context);
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_attr_is_leaf(dp))
>  		return xfs_attr_leaf_list(context);
>  	return xfs_attr_node_list(context);
>  }
> -- 
> 2.30.1
> 
