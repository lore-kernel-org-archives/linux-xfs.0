Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102B3C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D304620661
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgQrmAfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgELJsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725889AbgELJsp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:48:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1096AC061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 02:48:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f7so6116438pfa.9
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 02:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t8wHHvZywF7rCJiCMw0lr6HQes12Y+7wwRd4LGMGDf8=;
        b=hgQrmAfUS3eXKO0HBldYFGuY6q16kiVeKa86oeFZP5ECKKehwpalIeZcTuwk2pNFg4
         ZpIIL5XT6L/r2uHYyVI7fYiIx1vaHnE9NPJB2DGtGNZSLjGmHD0UlyC4JqscUCtNKRbs
         G0Jo8k2lEqd3IgjP0FN+KdpHwWdaDoAl6LtchoxhNnMOZ+Mtadn601Nov2QX1W5klS0u
         6ekV3hXNKiXGr0ph2Owq2MXvHkxqCWVkJaZTs5n2khixfdKiOLg5Hocifecd3ZGh7iWH
         W+JdKqFzGcTYjLxNvqsuc+2BtIe8ONg1pt2FHMx1GEngJfrDPndHinEWb93z2ySqCJBC
         OsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t8wHHvZywF7rCJiCMw0lr6HQes12Y+7wwRd4LGMGDf8=;
        b=U9sj9YClul2MqwwijUePBCC1jDygVPYBFvYWxP6F6P3lWgvs0ubTgj0vBUGjqfrK84
         3rxYmxEN6JREiWqPZk1zUxIkHd0Q4436qy6e59xCk7sWF0cqs/9ANaDe9jRNnMYHeRkB
         Fi+CcJz+YJuzd+M562EallIcu/IP3zFt8Z6we/4aa7IMQnLWcyWjFTQbGccw0ihqYSXr
         ox0BvtGPPLYf196fJpnZI/6DsIHrO6KnZVm8JL/D9BqxqFzKNyf+PaSH0vhK9ZgWzXD4
         m17uMETOG25wtbv2oZViwr3xauYrE4JToF8QehbcuOJ0rzhu++K6s+n+r2EH5UEUIlu8
         Lqnw==
X-Gm-Message-State: AGi0PubM7Zx4nX1U0gwSszf/vf+2YfDmHeFjE5cpRbRJHyTPNRyVm4Te
        McRzElW0YWAq6/d+ll3i500=
X-Google-Smtp-Source: APiQypLDfNNokaJwgI2M0bwOaiRmiEfXwwNDgbkCxTlBRAJKiijpBbii59vniyuV5myXjXvdrqH9vg==
X-Received: by 2002:a63:e602:: with SMTP id g2mr18750167pgh.380.1589276924447;
        Tue, 12 May 2020 02:48:44 -0700 (PDT)
Received: from garuda.localnet ([122.179.53.43])
        by smtp.gmail.com with ESMTPSA id 1sm9812219pgy.77.2020.05.12.02.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 02:48:43 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: cleanup xfs_idestroy_fork
Date:   Tue, 12 May 2020 15:18:41 +0530
Message-ID: <2391865.AtcxAzAOE0@garuda>
In-Reply-To: <20200510072404.986627-7-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-7-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 10 May 2020 12:54:04 PM IST Christoph Hellwig wrote:
> Move freeing the dynamically allocated attr and COW fork, as well
> as zeroing the pointers where actually needed into the callers, and
> just pass the xfs_ifork structure to xfs_idestroy_fork.  Simplify
> the kmem_free calls by not checking for NULL first, and not zeroing
> the pointers in structure that are about to be freed (either the
> ifork or the containing inode in case of the data fork).
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
>  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 36 +++++++++-------------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>  fs/xfs/xfs_attr_inactive.c     |  7 +++++--
>  fs/xfs/xfs_icache.c            | 15 ++++++++------
>  6 files changed, 28 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d7f3173ce3c31..8d775942f1c6c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -716,11 +716,10 @@ xfs_attr_fork_remove(
>  	struct xfs_inode	*ip,
>  	struct xfs_trans	*tp)
>  {
> -	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> +	xfs_idestroy_fork(ip->i_afp);
> +	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> +	ip->i_afp = NULL;
>  	ip->i_d.di_forkoff = 0;
> -
> -	ASSERT(ip->i_afp == NULL);
> -
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ab555671e1543..6f84ea85fdd83 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -271,7 +271,7 @@ xfs_inode_from_disk(
>  	return 0;
>  
>  out_destroy_data_fork:
> -	xfs_idestroy_fork(ip, XFS_DATA_FORK);
> +	xfs_idestroy_fork(&ip->i_df);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 6562f2bcd15cc..577cc20e03170 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -495,38 +495,20 @@ xfs_idata_realloc(
>  
>  void
>  xfs_idestroy_fork(
> -	xfs_inode_t	*ip,
> -	int		whichfork)
> +	struct xfs_ifork	*ifp)
>  {
> -	struct xfs_ifork	*ifp;
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (ifp->if_broot != NULL) {
> -		kmem_free(ifp->if_broot);
> -		ifp->if_broot = NULL;
> -	}
> +	kmem_free(ifp->if_broot);
>  
>  	/*
> -	 * If the format is local, then we can't have an extents
> -	 * array so just look for an inline data array.  If we're
> -	 * not local then we may or may not have an extents list,
> -	 * so check and free it up if we do.
> +	 * If the format is local, then we can't have an extents array so just
> +	 * look for an inline data array.  If we're not local then we may or may
> +	 * not have an extents list, so check and free it up if we do.
>  	 */
>  	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
> -		if (ifp->if_u1.if_data != NULL) {
> -			kmem_free(ifp->if_u1.if_data);
> -			ifp->if_u1.if_data = NULL;
> -		}
> -	} else if ((ifp->if_flags & XFS_IFEXTENTS) && ifp->if_height) {
> -		xfs_iext_destroy(ifp);
> -	}
> -
> -	if (whichfork == XFS_ATTR_FORK) {
> -		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> -		ip->i_afp = NULL;
> -	} else if (whichfork == XFS_COW_FORK) {
> -		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> -		ip->i_cowfp = NULL;
> +		kmem_free(ifp->if_u1.if_data);
> +	} else if (ifp->if_flags & XFS_IFEXTENTS) {
> +		if (ifp->if_height)
> +			xfs_iext_destroy(ifp);
>  	}
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index d849cca103edd..a4953e95c4f3f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -86,7 +86,7 @@ int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
>  int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
>  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>  				struct xfs_inode_log_item *, int);
> -void		xfs_idestroy_fork(struct xfs_inode *, int);
> +void		xfs_idestroy_fork(struct xfs_ifork *ifp);
>  void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
>  				int whichfork);
>  void		xfs_iroot_realloc(struct xfs_inode *, int, int);
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index 00ffc46c0bf71..bfad669e6b2f8 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -388,8 +388,11 @@ xfs_attr_inactive(
>  	xfs_trans_cancel(trans);
>  out_destroy_fork:
>  	/* kill the in-core attr fork before we drop the inode lock */
> -	if (dp->i_afp)
> -		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
> +	if (dp->i_afp) {
> +		xfs_idestroy_fork(dp->i_afp);
> +		kmem_cache_free(xfs_ifork_zone, dp->i_afp);
> +		dp->i_afp = NULL;
> +	}
>  	if (lock_mode)
>  		xfs_iunlock(dp, lock_mode);
>  	return error;
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c09b3e9eab1da..d806d3bfa8936 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -87,15 +87,18 @@ xfs_inode_free_callback(
>  	case S_IFREG:
>  	case S_IFDIR:
>  	case S_IFLNK:
> -		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> +		xfs_idestroy_fork(&ip->i_df);
>  		break;
>  	}
>  
> -	if (ip->i_afp)
> -		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> -	if (ip->i_cowfp)
> -		xfs_idestroy_fork(ip, XFS_COW_FORK);
> -
> +	if (ip->i_afp) {
> +		xfs_idestroy_fork(ip->i_afp);
> +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> +	}
> +	if (ip->i_cowfp) {
> +		xfs_idestroy_fork(ip->i_cowfp);
> +		kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> +	}
>  	if (ip->i_itemp) {
>  		ASSERT(!test_bit(XFS_LI_IN_AIL,
>  				 &ip->i_itemp->ili_item.li_flags));
> 


-- 
chandan



