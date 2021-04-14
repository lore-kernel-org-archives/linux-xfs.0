Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E40C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C42861249
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhDNANy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 20:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhDNANx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 20:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B64F61246;
        Wed, 14 Apr 2021 00:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618359213;
        bh=8+8SRLtfKlKcFNqzZnVCAo1JFAw1IjEb1XcBe5G8BNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k7BmbgHbcpilU248YuIiQPF5pdypa2STU0AZl7N2u348nGWmCFjEEgDiQYtCytNqy
         MiJURMJSjergsPaPjcP/Ntq9SUq0gK4NPr0xQ88pA1ga4R+umb6c9m76IWThYkB1vb
         rEiDhPetVHPZgnCVrVfQfx0UkPaPG5utw+1uaDU5UA1AgnQl1+dx2B7hnDIb4xGPlT
         bRnjze0e5w4NdH1FxRCll0IsAmJ6WNmdajDZqO2fh7wUcXw2+LvfYnDMIl68Ve8y4X
         w2SFfpz3xHzKqY27wobazFYvR1R3Ne8Paooh7v5Im7zuqE8G6dukRNFmmU/nYUv0ku
         pNC+Bk34EYXPA==
Date:   Tue, 13 Apr 2021 17:13:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: remove XFS_IFBROOT
Message-ID: <20210414001332.GS3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:17PM +0200, Christoph Hellwig wrote:
> Just check for a btree format fork instead of the using the equivalent
> in-memory XFS_IFBROOT flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty straightforward to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c          | 16 +++++++---------
>  fs/xfs/libxfs/xfs_btree_staging.c |  1 -
>  fs/xfs/libxfs/xfs_inode_fork.c    |  4 +---
>  fs/xfs/libxfs/xfs_inode_fork.h    |  1 -
>  4 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e32b8228d9cc2e..580b36f19a26f7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -633,7 +633,6 @@ xfs_bmap_btree_to_extents(
>  		cur->bc_bufs[0] = NULL;
>  	xfs_iroot_realloc(ip, -1, whichfork);
>  	ASSERT(ifp->if_broot == NULL);
> -	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
>  	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>  	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
>  	return 0;
> @@ -677,7 +676,6 @@ xfs_bmap_extents_to_btree(
>  	 * to expand the root.
>  	 */
>  	xfs_iroot_realloc(ip, 1, whichfork);
> -	ifp->if_flags |= XFS_IFBROOT;
>  
>  	/*
>  	 * Fill in the root.
> @@ -4196,7 +4194,7 @@ xfs_bmapi_allocate(
>  			return error;
>  	}
>  
> -	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur)
>  		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
>  	/*
>  	 * Bump the number of extents we've allocated
> @@ -4269,7 +4267,7 @@ xfs_bmapi_convert_unwritten(
>  	 * Modify (by adding) the state flag, if writing.
>  	 */
>  	ASSERT(mval->br_blockcount <= len);
> -	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur) {
>  		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
>  					bma->ip, whichfork);
>  	}
> @@ -4732,7 +4730,7 @@ xfs_bmapi_remap(
>  	ip->i_nblocks += len;
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> -	if (ifp->if_flags & XFS_IFBROOT) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_ino.flags = 0;
>  	}
> @@ -5411,7 +5409,7 @@ __xfs_bunmapi(
>  	end--;
>  
>  	logflags = 0;
> -	if (ifp->if_flags & XFS_IFBROOT) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_ino.flags = 0;
> @@ -5885,7 +5883,7 @@ xfs_bmap_collapse_extents(
>  	if (error)
>  		return error;
>  
> -	if (ifp->if_flags & XFS_IFBROOT) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_ino.flags = 0;
>  	}
> @@ -6000,7 +5998,7 @@ xfs_bmap_insert_extents(
>  	if (error)
>  		return error;
>  
> -	if (ifp->if_flags & XFS_IFBROOT) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_ino.flags = 0;
>  	}
> @@ -6115,7 +6113,7 @@ xfs_bmap_split_extent(
>  	new.br_blockcount = got.br_blockcount - gotblkcnt;
>  	new.br_state = got.br_state;
>  
> -	if (ifp->if_flags & XFS_IFBROOT) {
> +	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
>  		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
>  		cur->bc_ino.flags = 0;
>  		error = xfs_bmbt_lookup_eq(cur, &got, &i);
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index f464a7c7cf2246..aa8dc9521c3942 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -387,7 +387,6 @@ xfs_btree_bload_prep_block(
>  		new_size = bbl->iroot_size(cur, nr_this_block, priv);
>  		ifp->if_broot = kmem_zalloc(new_size, 0);
>  		ifp->if_broot_bytes = (int)new_size;
> -		ifp->if_flags |= XFS_IFBROOT;
>  
>  		/* Initialize it and send it out. */
>  		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 73eea7939b55e4..02ad722004d3f4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -60,7 +60,7 @@ xfs_init_local_fork(
>  	}
>  
>  	ifp->if_bytes = size;
> -	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
> +	ifp->if_flags &= ~XFS_IFEXTENTS;
>  	ifp->if_flags |= XFS_IFINLINE;
>  }
>  
> @@ -214,7 +214,6 @@ xfs_iformat_btree(
>  	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
>  			 ifp->if_broot, size);
>  	ifp->if_flags &= ~XFS_IFEXTENTS;
> -	ifp->if_flags |= XFS_IFBROOT;
>  
>  	ifp->if_bytes = 0;
>  	ifp->if_u1.if_root = NULL;
> @@ -433,7 +432,6 @@ xfs_iroot_realloc(
>  			XFS_BMBT_BLOCK_LEN(ip->i_mount));
>  	} else {
>  		new_broot = NULL;
> -		ifp->if_flags &= ~XFS_IFBROOT;
>  	}
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 06682ff49a5bfc..8ffaa7cc1f7c3f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -32,7 +32,6 @@ struct xfs_ifork {
>   */
>  #define	XFS_IFINLINE	0x01	/* Inline data is read in */
>  #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
> -#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
>  
>  /*
>   * Worst-case increase in the fork extent count when we're adding a single
> -- 
> 2.30.1
> 
