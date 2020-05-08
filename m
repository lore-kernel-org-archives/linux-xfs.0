Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6FAC38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C28821655
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LuRa3jjo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgEHPGG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:06:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20389 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbgEHPGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NXBmjvhp7uAaW0GN/xx7Uk6O67vB5zhUq5zZZeB/HUs=;
        b=LuRa3jjo+XkaIeKhG1XhDEawF39kyG+X8yJuX3LDh/VCWs0l7199h4JqYgRxYiSFH4o1ik
        3S4uecoGbaH1sVRkUjDzwmTnDNf6OmVV6uZgsXcemNljKw8MwHS/U7tDeBQpG0B5t4v+Gs
        5RSSJpUfGj5/wkXq/bMMhzIthG0udzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-CBFr_l0LOmi9Be43ez5MDQ-1; Fri, 08 May 2020 11:05:59 -0400
X-MC-Unique: CBFr_l0LOmi9Be43ez5MDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80C9C835B41;
        Fri,  8 May 2020 15:05:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 382B610002A8;
        Fri,  8 May 2020 15:05:55 +0000 (UTC)
Date:   Fri, 8 May 2020 11:05:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200508150553.GG27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-10-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:20AM +0200, Christoph Hellwig wrote:
> The split between xfs_inode_verify_forks and the two helpers
> implementing the actual functionality is a little strange.  Reshuffle
> it so that xfs_inode_verify_forks verifies if the data and attr forks
> are actually in local format and only call the low-level helpers if
> that is the case.  Handle the actual error reporting in the low-level
> handlers to streamline the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_fork.c | 51 ++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
>  fs/xfs/xfs_inode.c             | 21 +++-----------
>  3 files changed, 40 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index e346e143f1053..401921975d75b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -674,34 +674,51 @@ xfs_ifork_init_cow(
>  }
>  
>  /* Verify the inline contents of the data fork of an inode. */
> -xfs_failaddr_t
> -xfs_ifork_verify_data(
> +int
> +xfs_ifork_verify_local_data(
>  	struct xfs_inode	*ip)
>  {
> -	/* Non-local data fork, we're done. */
> -	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> -		return NULL;
> +	xfs_failaddr_t		fa = NULL;
>  
> -	/* Check the inline data fork if there is one. */
>  	switch (VFS_I(ip)->i_mode & S_IFMT) {
>  	case S_IFDIR:
> -		return xfs_dir2_sf_verify(ip);
> +		fa = xfs_dir2_sf_verify(ip);
> +		break;
>  	case S_IFLNK:
> -		return xfs_symlink_shortform_verify(ip);
> +		fa = xfs_symlink_shortform_verify(ip);
> +		break;
>  	default:
> -		return NULL;
> +		break;
>  	}
> +
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> +			ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
>  }
>  
>  /* Verify the inline contents of the attr fork of an inode. */
> -xfs_failaddr_t
> -xfs_ifork_verify_attr(
> +int
> +xfs_ifork_verify_local_attr(
>  	struct xfs_inode	*ip)
>  {
> -	/* There has to be an attr fork allocated if aformat is local. */
> -	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
> -		return NULL;
> -	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> -		return __this_address;
> -	return xfs_attr_shortform_verify(ip);
> +	struct xfs_ifork	*ifp = ip->i_afp;
> +	xfs_failaddr_t		fa;
> +
> +	if (!ifp)
> +		fa = __this_address;
> +	else
> +		fa = xfs_attr_shortform_verify(ip);
> +
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> +			ifp ? ifp->if_u1.if_data : NULL,
> +			ifp ? ifp->if_bytes : 0, fa);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 3f84d33abd3b7..f46a8c1db5964 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -176,7 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
>  
>  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
> -xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
> -xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
> +int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> +int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
>  
>  #endif	/* __XFS_INODE_FORK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 25c00ffe18409..c8abdefe00377 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3715,25 +3715,12 @@ bool
>  xfs_inode_verify_forks(
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_ifork	*ifp;
> -	xfs_failaddr_t		fa;
> -
> -	fa = xfs_ifork_verify_data(ip);
> -	if (fa) {
> -		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> -				ifp->if_u1.if_data, ifp->if_bytes, fa);
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_data(ip))
>  		return false;
> -	}
> -
> -	fa = xfs_ifork_verify_attr(ip);
> -	if (fa) {
> -		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -				ifp ? ifp->if_u1.if_data : NULL,
> -				ifp ? ifp->if_bytes : 0, fa);
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_attr(ip))
>  		return false;
> -	}
>  	return true;
>  }
>  
> -- 
> 2.26.2
> 

