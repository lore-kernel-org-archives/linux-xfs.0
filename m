Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC6CC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6AEB2065F
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 13:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEvXMjnv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgERN2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 09:28:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26603 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726775AbgERN2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 09:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589808501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5CpdLFk72GqyGzYLeU8mv5Vn/H2WnCZWERAKVkvtyk=;
        b=NEvXMjnveLh6y1i++ZBvzz6DnszywSJPQ9G3cJcyPeuowREIEOCzjEgpTsiJiXKt4LVAjT
        mt64mOy8qh6wljLNk29+aWO7sJzd/fvFMQzyT5OKnbdnhp4Wf1L0ZeV/y5SS3sZdiZ6oYi
        7BaY2PscaT+XuoE6DmOWfoPAHL7w1Gk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-MC2utneSOcuy-7gGSLSEUg-1; Mon, 18 May 2020 09:28:19 -0400
X-MC-Unique: MC2utneSOcuy-7gGSLSEUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD12B18A0724;
        Mon, 18 May 2020 13:28:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EE425D9DC;
        Mon, 18 May 2020 13:28:18 +0000 (UTC)
Date:   Mon, 18 May 2020 09:28:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Chandan Babu R <chandanrlinux@gmail.com>
Subject: Re: [PATCH 6/6] xfs: cleanup xfs_idestroy_fork
Message-ID: <20200518132816.GE10938@bfoster>
References: <20200518073358.760214-1-hch@lst.de>
 <20200518073358.760214-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518073358.760214-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 09:33:58AM +0200, Christoph Hellwig wrote:
> Move freeing the dynamically allocated attr and COW fork, as well
> as zeroing the pointers where actually needed into the callers, and
> just pass the xfs_ifork structure to xfs_idestroy_fork.  Also simplify
> the kmem_free calls by not checking for NULL first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_leaf.c  |  7 +++----
>  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 32 +++++++++-----------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 +-
>  fs/xfs/xfs_attr_inactive.c     |  7 +++++--
>  fs/xfs/xfs_icache.c            | 15 +++++++++------
>  6 files changed, 28 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b279200519777..394805abb4535 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -718,11 +718,10 @@ xfs_attr_fork_remove(
>  {
>  	ASSERT(ip->i_afp->if_nextents == 0);
>  
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
> index ef43b4893766c..28b366275ae0e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -503,38 +503,24 @@ xfs_idata_realloc(
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
>  	if (ifp->if_broot != NULL) {
>  		kmem_free(ifp->if_broot);
>  		ifp->if_broot = NULL;
>  	}
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
> +		ifp->if_u1.if_data = NULL;
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
> -- 
> 2.26.2
> 

