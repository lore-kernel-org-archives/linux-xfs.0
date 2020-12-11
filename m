Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A8DC4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250AF23EF1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 17:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406623AbgLKQSR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 11:18:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406586AbgLKQSC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 11:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607703395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OB+FyrKun+wOiuEkCV12MipGACL7wIFiV1dFtYOO9Fg=;
        b=i7Odm69oQ3MAzj2YfL9o6XT2QvN0qW41HdRrYV0S4iyh7dC2nfpG0if/RvGPcJ3Zv/Vk6Q
        cfe2yrEQlA9ijEP2iOGDAiLUYE1yG4SEoSsNohqgkUTGEkC12pbVDS0xNcTfyLdkcAJFJ6
        xpAuQF6Gj+JPAl0QpjD3GflwCEasA+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-nYj9jL1iMNmE_bjMfJHI9w-1; Fri, 11 Dec 2020 11:16:31 -0500
X-MC-Unique: nYj9jL1iMNmE_bjMfJHI9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65C476D520;
        Fri, 11 Dec 2020 16:16:30 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BA255D6A8;
        Fri, 11 Dec 2020 16:16:29 +0000 (UTC)
Date:   Fri, 11 Dec 2020 11:16:28 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_vn_setattr_nonsize
Message-ID: <20201211161628.GF2032335@bfoster>
References: <20201210054821.2704734-1-hch@lst.de>
 <20201210054821.2704734-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210054821.2704734-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 06:48:20AM +0100, Christoph Hellwig wrote:
> Merge xfs_vn_setattr_nonsize into the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c | 26 +++++++-------------------
>  fs/xfs/xfs_iops.h |  1 -
>  2 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1414ab79eacfc2..54c7c94f82951b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -826,22 +826,6 @@ xfs_setattr_nonsize(
>  	return error;
>  }
>  
> -int
> -xfs_vn_setattr_nonsize(
> -	struct dentry		*dentry,
> -	struct iattr		*iattr)
> -{
> -	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> -	int error;
> -
> -	trace_xfs_setattr(ip);
> -
> -	error = xfs_vn_change_ok(dentry, iattr);
> -	if (error)
> -		return error;
> -	return xfs_setattr_nonsize(ip, iattr, 0);
> -}
> -
>  /*
>   * Truncate file.  Must have write permission and not be a directory.
>   *
> @@ -1069,11 +1053,11 @@ xfs_vn_setattr(
>  	struct dentry		*dentry,
>  	struct iattr		*iattr)
>  {
> +	struct inode		*inode = d_inode(dentry);
> +	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
>  
>  	if (iattr->ia_valid & ATTR_SIZE) {
> -		struct inode		*inode = d_inode(dentry);
> -		struct xfs_inode	*ip = XFS_I(inode);
>  		uint			iolock;
>  
>  		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> @@ -1088,7 +1072,11 @@ xfs_vn_setattr(
>  		error = xfs_vn_setattr_size(dentry, iattr);
>  		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
>  	} else {
> -		error = xfs_vn_setattr_nonsize(dentry, iattr);
> +		trace_xfs_setattr(ip);
> +
> +		error = xfs_vn_change_ok(dentry, iattr);
> +		if (!error)
> +			error = xfs_setattr_nonsize(ip, iattr, 0);
>  	}
>  
>  	return error;
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index 4d24ff309f593f..a91e2d1b47b45d 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -21,7 +21,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
>  extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
>  			       int flags);
> -extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);
>  extern int xfs_vn_setattr_size(struct dentry *dentry, struct iattr *vap);
>  
>  #endif /* __XFS_IOPS_H__ */
> -- 
> 2.29.2
> 

