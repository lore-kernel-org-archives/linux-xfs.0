Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2F2C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6984D21655
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cLwl2CUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgEHPFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:05:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728128AbgEHPFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O3Yf5AaHr7PZk9aNELu/wAcrJBIo5NoCEmxqPatxfBQ=;
        b=cLwl2CUk61KnudhJn2AO/RVTSYMCOEt50ui3p2BQG2dk6g2xCF6KJFH5TH41wzXIwWgSrI
        cFxBstdnt5trAaROQF1ZXcbvyFC3mRH/sCWhuGRoZOAOLhyU6L9tbIjv9h8dISQ+GH+qOn
        iggnU+VvFVsDGv8wxoTrWWLxSMJD4FY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-PEiJiUZVPpSjkMlWLmDFgQ-1; Fri, 08 May 2020 11:05:47 -0400
X-MC-Unique: PEiJiUZVPpSjkMlWLmDFgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F607835B42;
        Fri,  8 May 2020 15:05:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6D212E199;
        Fri,  8 May 2020 15:05:45 +0000 (UTC)
Date:   Fri, 8 May 2020 11:05:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200508150543.GF27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:19AM +0200, Christoph Hellwig wrote:
> xfs_ifork_ops add up to two indirect calls per inode read and flush,
> despite just having a single instance in the kernel.  In xfsprogs
> phase6 in xfs_repair overrides the verify_dir method to deal with inodes
> that do not have a valid parent, but that can be fixed pretty easily
> by ensuring they always have a valid looking parent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Code looks fine, but I assume we'll want a repair fix completed and
merged before wiping this out:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++--------------
>  fs/xfs/libxfs/xfs_inode_fork.h | 15 ++-------------
>  fs/xfs/xfs_inode.c             |  4 ++--
>  3 files changed, 9 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 5fadfa9a17eb9..e346e143f1053 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -673,18 +673,10 @@ xfs_ifork_init_cow(
>  	ip->i_cnextents = 0;
>  }
>  
> -/* Default fork content verifiers. */
> -struct xfs_ifork_ops xfs_default_ifork_ops = {
> -	.verify_attr	= xfs_attr_shortform_verify,
> -	.verify_dir	= xfs_dir2_sf_verify,
> -	.verify_symlink	= xfs_symlink_shortform_verify,
> -};
> -
>  /* Verify the inline contents of the data fork of an inode. */
>  xfs_failaddr_t
>  xfs_ifork_verify_data(
> -	struct xfs_inode	*ip,
> -	struct xfs_ifork_ops	*ops)
> +	struct xfs_inode	*ip)
>  {
>  	/* Non-local data fork, we're done. */
>  	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> @@ -693,9 +685,9 @@ xfs_ifork_verify_data(
>  	/* Check the inline data fork if there is one. */
>  	switch (VFS_I(ip)->i_mode & S_IFMT) {
>  	case S_IFDIR:
> -		return ops->verify_dir(ip);
> +		return xfs_dir2_sf_verify(ip);
>  	case S_IFLNK:
> -		return ops->verify_symlink(ip);
> +		return xfs_symlink_shortform_verify(ip);
>  	default:
>  		return NULL;
>  	}
> @@ -704,13 +696,12 @@ xfs_ifork_verify_data(
>  /* Verify the inline contents of the attr fork of an inode. */
>  xfs_failaddr_t
>  xfs_ifork_verify_attr(
> -	struct xfs_inode	*ip,
> -	struct xfs_ifork_ops	*ops)
> +	struct xfs_inode	*ip)
>  {
>  	/* There has to be an attr fork allocated if aformat is local. */
>  	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
>  		return NULL;
>  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
>  		return __this_address;
> -	return ops->verify_attr(ip);
> +	return xfs_attr_shortform_verify(ip);
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 8487b0c88a75e..3f84d33abd3b7 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -176,18 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
>  
>  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
> -typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
> -
> -struct xfs_ifork_ops {
> -	xfs_ifork_verifier_t	verify_symlink;
> -	xfs_ifork_verifier_t	verify_dir;
> -	xfs_ifork_verifier_t	verify_attr;
> -};
> -extern struct xfs_ifork_ops	xfs_default_ifork_ops;
> -
> -xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
> -		struct xfs_ifork_ops *ops);
> -xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
> -		struct xfs_ifork_ops *ops);
> +xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
> +xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
>  
>  #endif	/* __XFS_INODE_FORK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ab31a5dec7aab..25c00ffe18409 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3718,7 +3718,7 @@ xfs_inode_verify_forks(
>  	struct xfs_ifork	*ifp;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
> +	fa = xfs_ifork_verify_data(ip);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> @@ -3726,7 +3726,7 @@ xfs_inode_verify_forks(
>  		return false;
>  	}
>  
> -	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
> +	fa = xfs_ifork_verify_attr(ip);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -- 
> 2.26.2
> 

