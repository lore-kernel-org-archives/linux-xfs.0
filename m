Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D12CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726AB61A1A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhCXR5p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236787AbhCXR5g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23F2861A1A;
        Wed, 24 Mar 2021 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616608656;
        bh=qQoMIYxbEfdlB6SNvlkwo3aNH5YQwcXNT+C2uC9d63A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dn11kMjBlIlO4aIpb2f4ugbLp+jLELvmG2Kugb0ZaxHS6pivEjlQdX+hqbYHj+woJ
         RMMDQC0OZU6AisKqIem7dEbxahrTU8S+addXpQ1lW0LCk5Mpem8duQj7YkEKlihT91
         8GPm/wvNGsKEtsq2aTNDZ9JlKjjw2kuPK9F/9JAWip8pFDD/friO6i7AtkKm9AVkrn
         guihpy41+0O03+HLOT5JOMPXN5Cw0Th0zfGedzBFcFBFl+MT/CaQ8BEkgowz5mObsG
         cXtwT15JQoAlTa5g2PeDqhqcBe3LwfiWImcb7mNCVJLfJIVzR2eu3BRCPXliokUOcd
         BGuhGtvAQRbzA==
Date:   Wed, 24 Mar 2021 10:57:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: simplify the perage inode walk infrastructure
Message-ID: <20210324175735.GX22100@magnolia>
References: <20210324070307.908462-1-hch@lst.de>
 <20210324070307.908462-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324070307.908462-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 08:03:06AM +0100, Christoph Hellwig wrote:
> Remove the generic xfs_inode_walk and just open code the only caller.

This is going in the wrong direction for me.  Maybe.

I was planning to combine the reclaim inode walk into this function, and
later on share it with inactivation.  This made for one switch-happy
iteration function, but it meant there was only one loop.

OFC maybe the point that you and/or Dave were trying to make is that I
should be doing the opposite, and combining the inactivation loop into
what is now the (badly misnamed) xfs_reclaim_inodes_ag?  And leave this
blockgc loop alone?

<shrug>

--D

> Note that this leads to a somewhat ugly forward delcaration for
> xfs_blockgc_scan_inode, but with other changes in that area pending
> it seems like the lesser evil.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 103 +++++++++++++-------------------------------
>  fs/xfs/xfs_icache.h |  11 -----
>  2 files changed, 30 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c0d084e3526a9c..7fdf77df66269c 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -728,11 +728,9 @@ xfs_icache_inode_is_allocated(
>   */
>  STATIC bool
>  xfs_inode_walk_ag_grab(
> -	struct xfs_inode	*ip,
> -	int			flags)
> +	struct xfs_inode	*ip)
>  {
>  	struct inode		*inode = VFS_I(ip);
> -	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
>  
>  	ASSERT(rcu_read_lock_held());
>  
> @@ -742,8 +740,7 @@ xfs_inode_walk_ag_grab(
>  		goto out_unlock_noent;
>  
>  	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
> -	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
> -	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
> +	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
>  		goto out_unlock_noent;
>  	spin_unlock(&ip->i_flags_lock);
>  
> @@ -763,17 +760,19 @@ xfs_inode_walk_ag_grab(
>  	return false;
>  }
>  
> +static int
> +xfs_blockgc_scan_inode(
> +	struct xfs_inode	*ip,
> +	void			*args);
> +
>  /*
>   * For a given per-AG structure @pag, grab, @execute, and rele all incore
>   * inodes with the given radix tree @tag.
>   */
>  STATIC int
> -xfs_inode_walk_ag(
> +xfs_blockgc_free_space_ag(
>  	struct xfs_perag	*pag,
> -	int			iter_flags,
> -	int			(*execute)(struct xfs_inode *ip, void *args),
> -	void			*args,
> -	int			tag)
> +	struct xfs_eofblocks	*eofb)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
>  	uint32_t		first_index;
> @@ -793,17 +792,9 @@ xfs_inode_walk_ag(
>  		int		i;
>  
>  		rcu_read_lock();
> -
> -		if (tag == XFS_ICI_NO_TAG)
> -			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> -					(void **)batch, first_index,
> -					XFS_LOOKUP_BATCH);
> -		else
> -			nr_found = radix_tree_gang_lookup_tag(
> -					&pag->pag_ici_root,
> -					(void **) batch, first_index,
> -					XFS_LOOKUP_BATCH, tag);
> -
> +		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> +				(void **) batch, first_index,
> +				XFS_LOOKUP_BATCH, XFS_ICI_BLOCKGC_TAG);
>  		if (!nr_found) {
>  			rcu_read_unlock();
>  			break;
> @@ -816,7 +807,7 @@ xfs_inode_walk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			struct xfs_inode *ip = batch[i];
>  
> -			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
> +			if (done || !xfs_inode_walk_ag_grab(ip))
>  				batch[i] = NULL;
>  
>  			/*
> @@ -844,10 +835,7 @@ xfs_inode_walk_ag(
>  		for (i = 0; i < nr_found; i++) {
>  			if (!batch[i])
>  				continue;
> -			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
> -			    xfs_iflags_test(batch[i], XFS_INEW))
> -				xfs_inew_wait(batch[i]);
> -			error = execute(batch[i], args);
> +			error = xfs_blockgc_scan_inode(batch[i], eofb);
>  			xfs_irele(batch[i]);
>  			if (error == -EAGAIN) {
>  				skipped++;
> @@ -872,49 +860,6 @@ xfs_inode_walk_ag(
>  	return last_error;
>  }
>  
> -/* Fetch the next (possibly tagged) per-AG structure. */
> -static inline struct xfs_perag *
> -xfs_inode_walk_get_perag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno,
> -	int			tag)
> -{
> -	if (tag == XFS_ICI_NO_TAG)
> -		return xfs_perag_get(mp, agno);
> -	return xfs_perag_get_tag(mp, agno, tag);
> -}
> -
> -/*
> - * Call the @execute function on all incore inodes matching the radix tree
> - * @tag.
> - */
> -int
> -xfs_inode_walk(
> -	struct xfs_mount	*mp,
> -	int			iter_flags,
> -	int			(*execute)(struct xfs_inode *ip, void *args),
> -	void			*args,
> -	int			tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			last_error = 0;
> -	xfs_agnumber_t		ag;
> -
> -	ag = 0;
> -	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
> -		ag = pag->pag_agno + 1;
> -		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
> -		xfs_perag_put(pag);
> -		if (error) {
> -			last_error = error;
> -			if (error == -EFSCORRUPTED)
> -				break;
> -		}
> -	}
> -	return last_error;
> -}
> -
>  /*
>   * Grab the inode for reclaim exclusively.
>   *
> @@ -1617,8 +1562,7 @@ xfs_blockgc_worker(
>  
>  	if (!sb_start_write_trylock(mp->m_super))
>  		return;
> -	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
> -			XFS_ICI_BLOCKGC_TAG);
> +	error = xfs_blockgc_free_space_ag(pag, NULL);
>  	if (error)
>  		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
>  				pag->pag_agno, error);
> @@ -1634,10 +1578,23 @@ xfs_blockgc_free_space(
>  	struct xfs_mount	*mp,
>  	struct xfs_eofblocks	*eofb)
>  {
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		ag = 0;
> +	int			error = 0, last_error = 0;
> +
>  	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
>  
> -	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
> -			XFS_ICI_BLOCKGC_TAG);
> +	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_BLOCKGC_TAG))) {
> +		ag = pag->pag_agno + 1;
> +		error = xfs_blockgc_free_space_ag(pag, eofb);
> +		xfs_perag_put(pag);
> +		if (error) {
> +			if (error == -EFSCORRUPTED)
> +				return error;
> +			last_error = error;
> +		}
> +	}
> +	return last_error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index d70d93c2bb1084..da390097546c67 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -20,8 +20,6 @@ struct xfs_eofblocks {
>  /*
>   * tags for inode radix tree
>   */
> -#define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
> -					   in xfs_inode_walk */
>  #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
>  /* Inode has speculative preallocations (posteof or cow) to clean. */
>  #define XFS_ICI_BLOCKGC_TAG	1
> @@ -34,11 +32,6 @@ struct xfs_eofblocks {
>  #define XFS_IGET_DONTCACHE	0x4
>  #define XFS_IGET_INCORE		0x8	/* don't read from disk or reinit */
>  
> -/*
> - * flags for AG inode iterator
> - */
> -#define XFS_INODE_WALK_INEW_WAIT	0x1	/* wait on new inodes */
> -
>  int xfs_iget(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t ino,
>  	     uint flags, uint lock_flags, xfs_inode_t **ipp);
>  
> @@ -68,10 +61,6 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
>  
>  void xfs_blockgc_worker(struct work_struct *work);
>  
> -int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
> -	int (*execute)(struct xfs_inode *ip, void *args),
> -	void *args, int tag);
> -
>  int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  xfs_ino_t ino, bool *inuse);
>  
> -- 
> 2.30.1
> 
