Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE51C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190E724956
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/fZDdPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgEAP5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 11:57:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52992 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728495AbgEAP5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 11:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588348649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6kF38dC6MR27Y9wdd4YKVIiffOUnc5gaHaW+bPpsSU0=;
        b=Q/fZDdPZbAdUK8Qlf7rTfk5zNwQk+9IxTNiJcSKCEznPDeFLiTZcOJG2KzO/AUvh+85eLa
        5VpvQDyd+W1v0db81JstAOid2EqDZdDTntSN79thQHOJzMOEyp94t9bGetWHrTa09GM7/o
        jx3cJ0mU9Cjml88T4LRffqJWg0lNRo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-S0FDEyfuMeCZdxIltlIRgQ-1; Fri, 01 May 2020 11:57:27 -0400
X-MC-Unique: S0FDEyfuMeCZdxIltlIRgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E968107ACCA;
        Fri,  1 May 2020 15:57:26 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FAFD2B4CC;
        Fri,  1 May 2020 15:57:26 +0000 (UTC)
Date:   Fri, 1 May 2020 11:57:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200501155724.GP40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-10-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:21AM +0200, Christoph Hellwig wrote:
> The split between xfs_inode_verify_forks and the two helpers
> implementing the actual functionality is a little strange.  Reshuffle
> it so that xfs_inode_verify_forks verifies if the data and attr forks
> are actually in local format and only call the low-level helpers if
> that is the case.  Handle the actual error reporting in the low-level
> handlers to streamline the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 47 ++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
>  fs/xfs/xfs_inode.c             | 21 +++------------
>  3 files changed, 37 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index f6dcee919f59e..7e129ed2f345f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -674,34 +674,49 @@ xfs_ifork_init_cow(
>  }
>  
...
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
> +	xfs_failaddr_t		fa;
> +
>  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> -		return __this_address;
> -	return xfs_attr_shortform_verify(ip);
> +		fa = __this_address;
> +	else
> +		fa = xfs_attr_shortform_verify(ip);
> +
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> +			ip->i_afp->if_u1.if_data, ip->i_afp->if_bytes, fa);
> +		return -EFSCORRUPTED;

This explicitly makes !ip->i_afp one of the handled corruption cases for
XFS_DINODE_FMT_LOCAL, but then attempts to access it anyways. Otherwise
seems Ok modulo the comments on the previous patch...

Brian

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
> index 93967278355de..2ec7789317133 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3766,25 +3766,12 @@ bool
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

