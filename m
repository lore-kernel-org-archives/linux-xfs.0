Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3925CC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E82461175
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhELMzh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:55:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233406AbhELMxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620823958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2kDx9vbE/1Fbo562wAkuc8YrS5W8WuSD+vDyGR3G/t4=;
        b=MD9WZokymFiBBpExtt5HkO0UFM6HQ7udCIXXEsKF2LpX1B5gjA7jDAdvbS/2GvMPouWts6
        k9VoaDrDmswNDPNP/43WbcrYtSHIr5tzsVfzOJzFwbTg9VOkx9fRxtzf2NvWhVdJf7cAU9
        2noXndTdpi2h/s4StzfzSANSHixlKNo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-d_VuzeJRO9WT3QrWZxdKmA-1; Wed, 12 May 2021 08:52:37 -0400
X-MC-Unique: d_VuzeJRO9WT3QrWZxdKmA-1
Received: by mail-qv1-f72.google.com with SMTP id r11-20020a0cb28b0000b02901c87a178503so18739299qve.22
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2kDx9vbE/1Fbo562wAkuc8YrS5W8WuSD+vDyGR3G/t4=;
        b=ov9wAa9074HRz2v91fYr0knp4A36breTmBgq+R7D999UU00jwJArEAOHK0RkMLI9bm
         KfUC2oY71OducJOzXr0r9Q4Ovhxgrfq5POLAnW76tSjY7BC0Lwg13MwT+AtclYrEi4Bf
         BoX/3nzd9cHAs3x7L+5MFCByWP0uO/l7FDg0XzBh4A4C4lJgUKPgM3iqdXOQfOsGtTxI
         Zggh8+0i1Q+OtvbHS4KaOscllgAb5vm1NG5u/vb+kS1w/Yzwhe875w9lPJr0Z+MivtRc
         qEG6MWAtOvHj+FCOWNc3YiP7EBMap7/N/ncIQAeHEJARtYibtWr4vzAmCZEAjoCUq8Qv
         SK7w==
X-Gm-Message-State: AOAM532B8fsemXS37gzfECF7mtBNcep7A8smlkF8z52tWdbTLGDmt2PB
        qBPrPjH2gMIcfstr1MDZE3+R5/v8Xuv784ftHB5b75rXBAFDSkS5cZQ8Hqm9c91hXcc3RArU77s
        V5o9okDfQoPqnuGSPQ40Y
X-Received: by 2002:ac8:7f13:: with SMTP id f19mr7038632qtk.237.1620823956788;
        Wed, 12 May 2021 05:52:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIHyQMh7FM6UtnM5a2mK7WrXQsA/hyGeJ3zkqym85P9D0TjsGHHXynrUzm6q8Tb0be4GZpZA==
X-Received: by 2002:ac8:7f13:: with SMTP id f19mr7038618qtk.237.1620823956517;
        Wed, 12 May 2021 05:52:36 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id v10sm16335754qtf.39.2021.05.12.05.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:52:36 -0700 (PDT)
Date:   Wed, 12 May 2021 08:52:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/22] xfs: get rid of xfs_dir_ialloc()
Message-ID: <YJvPkuVsN3TbH0Nu@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-20-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-20-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is just a simple wrapper around the per-ag inode allocation
> that doesn't need to exist. The internal mechanism to select and
> allocate within an AG does not need to be exposed outside
> xfs_ialloc.c, and it being exposed simply makes it harder to follow
> the code and simplify it.
> 
> This is simplified by internalising xf_dialloc_select_ag() and
> xfs_dialloc_ag() into a single xfs_dialloc() function and then
> xfs_dir_ialloc() can go away.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks fine to me modulo the kernel robot thing:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c | 15 +++++----
>  fs/xfs/libxfs/xfs_ialloc.h | 27 +++-------------
>  fs/xfs/xfs_inode.c         | 66 +++++++-------------------------------
>  fs/xfs/xfs_inode.h         |  9 +++---
>  fs/xfs/xfs_qm.c            |  9 ++++--
>  fs/xfs/xfs_symlink.c       |  9 ++++--
>  6 files changed, 43 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index b22556556bba..2c0ef2dd46d9 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1602,24 +1602,23 @@ xfs_ialloc_next_ag(
>   * can be allocated, -ENOSPC be returned.
>   */
>  int
> -xfs_dialloc_select_ag(
> +xfs_dialloc(
>  	struct xfs_trans	**tpp,
>  	xfs_ino_t		parent,
>  	umode_t			mode,
> -	struct xfs_buf		**IO_agbp)
> +	xfs_ino_t		*new_ino)
>  {
>  	struct xfs_mount	*mp = (*tpp)->t_mountp;
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
> -	int			error;
> +	int			error = 0;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	bool			okalloc = true;
>  	int			needspace;
>  	int			flags;
> -
> -	*IO_agbp = NULL;
> +	xfs_ino_t		ino;
>  
>  	/*
>  	 * Files of these types need at least one block if length > 0
> @@ -1763,7 +1762,11 @@ xfs_dialloc_select_ag(
>  	return error ? error : -ENOSPC;
>  found_ag:
>  	xfs_perag_put(pag);
> -	*IO_agbp = agbp;
> +	/* Allocate an inode in the found AG */
> +	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
> +	if (error)
> +		return error;
> +	*new_ino = ino;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 3511086a7ae1..886f6748fb22 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -33,30 +33,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
>  }
>  
>  /*
> - * Allocate an inode on disk.
> - * Mode is used to tell whether the new inode will need space, and whether
> - * it is a directory.
> - *
> - * There are two phases to inode allocation: selecting an AG and ensuring
> - * that it contains free inodes, followed by allocating one of the free
> - * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
> - * to the caller, ensuring that followup call to xfs_dialloc_ag() will
> - * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
> - * number of the free inode we allocated.
> + * Allocate an inode on disk.  Mode is used to tell whether the new inode will
> + * need space, and whether it is a directory.
>   */
> -int					/* error */
> -xfs_dialloc_select_ag(
> -	struct xfs_trans **tpp,		/* double pointer of transaction */
> -	xfs_ino_t	parent,		/* parent inode (directory) */
> -	umode_t		mode,		/* mode bits for new inode */
> -	struct xfs_buf	**IO_agbp);
> -
> -int
> -xfs_dialloc_ag(
> -	struct xfs_trans	*tp,
> -	struct xfs_buf		*agbp,
> -	xfs_ino_t		parent,
> -	xfs_ino_t		*inop);
> +int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
> +		xfs_ino_t *new_ino);
>  
>  /*
>   * Free disk inode.  Carefully avoids touching the incore inode, all
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 3918c99fa95b..26668b6846e2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -749,7 +749,7 @@ xfs_inode_inherit_flags2(
>   * Initialise a newly allocated inode and return the in-core inode to the
>   * caller locked exclusively.
>   */
> -static int
> +int
>  xfs_init_new_inode(
>  	struct user_namespace	*mnt_userns,
>  	struct xfs_trans	*tp,
> @@ -885,54 +885,6 @@ xfs_init_new_inode(
>  	return 0;
>  }
>  
> -/*
> - * Allocates a new inode from disk and return a pointer to the incore copy. This
> - * routine will internally commit the current transaction and allocate a new one
> - * if we needed to allocate more on-disk free inodes to perform the requested
> - * operation.
> - *
> - * If we are allocating quota inodes, we do not have a parent inode to attach to
> - * or associate with (i.e. dp == NULL) because they are not linked into the
> - * directory structure - they are attached directly to the superblock - and so
> - * have no parent.
> - */
> -int
> -xfs_dir_ialloc(
> -	struct user_namespace	*mnt_userns,
> -	struct xfs_trans	**tpp,
> -	struct xfs_inode	*dp,
> -	umode_t			mode,
> -	xfs_nlink_t		nlink,
> -	dev_t			rdev,
> -	prid_t			prid,
> -	bool			init_xattrs,
> -	struct xfs_inode	**ipp)
> -{
> -	struct xfs_buf		*agibp;
> -	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
> -	xfs_ino_t		ino;
> -	int			error;
> -
> -	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> -
> -	/*
> -	 * Call the space management code to pick the on-disk inode to be
> -	 * allocated.
> -	 */
> -	error = xfs_dialloc_select_ag(tpp, parent_ino, mode, &agibp);
> -	if (error)
> -		return error;
> -
> -	/* Allocate an inode from the selected AG */
> -	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
> -	if (error)
> -		return error;
> -	ASSERT(ino != NULLFSINO);
> -
> -	return xfs_init_new_inode(mnt_userns, *tpp, dp, ino, mode, nlink, rdev,
> -				  prid, init_xattrs, ipp);
> -}
> -
>  /*
>   * Decrement the link count on an inode & log the change.  If this causes the
>   * link count to go to zero, move the inode to AGI unlinked list so that it can
> @@ -990,6 +942,7 @@ xfs_create(
>  	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_trans_res	*tres;
>  	uint			resblks;
> +	xfs_ino_t		ino;
>  
>  	trace_xfs_create(dp, name);
>  
> @@ -1046,14 +999,16 @@ xfs_create(
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, is_dir ? 2 : 1, rdev,
> -			       prid, init_xattrs, &ip);
> +	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
> +	if (!error)
> +		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> +				is_dir ? 2 : 1, rdev, prid, init_xattrs, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
>  	/*
>  	 * Now we join the directory inode to the transaction.  We do not do it
> -	 * earlier because xfs_dir_ialloc might commit the previous transaction
> +	 * earlier because xfs_dialloc might commit the previous transaction
>  	 * (and release all the locks).  An error from here on will result in
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
> @@ -1143,6 +1098,7 @@ xfs_create_tmpfile(
>  	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_trans_res	*tres;
>  	uint			resblks;
> +	xfs_ino_t		ino;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
> @@ -1167,8 +1123,10 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_release_dquots;
>  
> -	error = xfs_dir_ialloc(mnt_userns, &tp, dp, mode, 0, 0, prid,
> -				false, &ip);
> +	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
> +	if (!error)
> +		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
> +				0, 0, prid, false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ca826cfba91c..4b6703dbffb8 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -431,11 +431,10 @@ void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
>  xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>  xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  
> -int		xfs_dir_ialloc(struct user_namespace *mnt_userns,
> -			       struct xfs_trans **tpp, struct xfs_inode *dp,
> -			       umode_t mode, xfs_nlink_t nlink, dev_t dev,
> -			       prid_t prid, bool need_xattr,
> -			       struct xfs_inode **ipp);
> +int xfs_init_new_inode(struct user_namespace *mnt_userns, struct xfs_trans *tp,
> +		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
> +		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
> +		struct xfs_inode **ipp);
>  
>  static inline int
>  xfs_itruncate_extents(
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f7baf4dc2554..fe341f3fd419 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -24,6 +24,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_error.h"
>  #include "xfs_ag.h"
> +#include "xfs_ialloc.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> @@ -788,8 +789,12 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&init_user_ns, &tp, NULL, S_IFREG, 1, 0,
> -				       0, false, ipp);
> +		xfs_ino_t	ino;
> +
> +		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
> +		if (!error)
> +			error = xfs_init_new_inode(&init_user_ns, tp, NULL, ino,
> +					S_IFREG, 1, 0, 0, false, ipp);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index b4fa70282383..44596c31f4c9 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -21,6 +21,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
> +#include "xfs_ialloc.h"
>  
>  /* ----- Kernel only functions below ----- */
>  int
> @@ -161,6 +162,7 @@ xfs_symlink(
>  	struct xfs_dquot	*gdqp = NULL;
>  	struct xfs_dquot	*pdqp = NULL;
>  	uint			resblks;
> +	xfs_ino_t		ino;
>  
>  	*ipp = NULL;
>  
> @@ -223,8 +225,11 @@ xfs_symlink(
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -	error = xfs_dir_ialloc(mnt_userns, &tp, dp, S_IFLNK | (mode & ~S_IFMT),
> -			       1, 0, prid, false, &ip);
> +	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
> +	if (!error)
> +		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
> +				S_IFLNK | (mode & ~S_IFMT), 1, 0, prid,
> +				false, &ip);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.31.1
> 

