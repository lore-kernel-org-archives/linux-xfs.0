Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA26C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1B9A218AC
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsIwGnas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgEHPFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:05:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726767AbgEHPFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NYwrt/3dObdNxTaVx7cwvIWU04LK6h4NPQPfDObiC0=;
        b=hsIwGnasx6lmnmc0GwK8SWhjzUJgo7w8IV28IOwvN4cRH2b8nQYYVZhVEX/ei1L0xvLa17
        pIiR0sBo6YfrYKQD0UQkuLxjyy0ZzMG+NT0QDMQZJE82JI1ElK9kzzR/zmQWkTbUUHvUM+
        8pu11+xf5KB+PTEpCELg7EMLSBsn3E8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-IgGfWIkTPBWYoJQte5P1cQ-1; Fri, 08 May 2020 11:05:12 -0400
X-MC-Unique: IgGfWIkTPBWYoJQte5P1cQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C6B0107ACF4;
        Fri,  8 May 2020 15:05:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FAE9707DA;
        Fri,  8 May 2020 15:05:10 +0000 (UTC)
Date:   Fri, 8 May 2020 11:05:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200508150508.GD27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:14AM +0200, Christoph Hellwig wrote:
> xfs_iformat_fork is a weird catchall.  Split it into one helper for
> the data fork and one for the attr fork, and then call both helper
> as well as the COW fork initialization from xfs_inode_from_disk.  Order
> the COW fork initialization after the attr fork initialization given
> that it can't fail to simplify the error handling.
> 
> Note that the newly split helpers are moved down the file in
> xfs_inode_fork.c to avoid the need for forward declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c  |  20 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c | 186 +++++++++++++++------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |   3 +-
>  3 files changed, 103 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index dc00ce6fc4a2f..abdecc80579e3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -187,6 +187,10 @@ xfs_inode_from_disk(
>  {
>  	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
> +	int			error;
> +
> +	ASSERT(ip->i_cowfp == NULL);
> +	ASSERT(ip->i_afp == NULL);
>  
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
> @@ -242,7 +246,21 @@ xfs_inode_from_disk(
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
>  
> -	return xfs_iformat_fork(ip, from);
> +	error = xfs_iformat_data_fork(ip, from);
> +	if (error)
> +		return error;
> +	if (XFS_DFORK_Q(from)) {
> +		error = xfs_iformat_attr_fork(ip, from);
> +		if (error)
> +			goto out_destroy_data_fork;
> +	}
> +	if (xfs_is_reflink_inode(ip))
> +		xfs_ifork_init_cow(ip);
> +	return 0;
> +
> +out_destroy_data_fork:
> +	xfs_idestroy_fork(ip, XFS_DATA_FORK);
> +	return error;
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 3e9a42f1e23b9..5fadfa9a17eb9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -26,110 +26,6 @@
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> -STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
> -STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
> -STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
> -
> -/*
> - * Copy inode type and data and attr format specific information from the
> - * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
> - * and sockets this means set i_rdev to the proper value.  For files,
> - * directories, and symlinks this means to bring in the in-line data or extent
> - * pointers as well as the attribute fork.  For a fork in B-tree format, only
> - * the root is immediately brought in-core.  The rest will be read in later when
> - * first referenced (see xfs_iread_extents()).
> - */
> -int
> -xfs_iformat_fork(
> -	struct xfs_inode	*ip,
> -	struct xfs_dinode	*dip)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	struct xfs_attr_shortform *atp;
> -	int			size;
> -	int			error = 0;
> -	xfs_fsize_t             di_size;
> -
> -	switch (inode->i_mode & S_IFMT) {
> -	case S_IFIFO:
> -	case S_IFCHR:
> -	case S_IFBLK:
> -	case S_IFSOCK:
> -		ip->i_d.di_size = 0;
> -		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
> -		break;
> -
> -	case S_IFREG:
> -	case S_IFLNK:
> -	case S_IFDIR:
> -		switch (dip->di_format) {
> -		case XFS_DINODE_FMT_LOCAL:
> -			di_size = be64_to_cpu(dip->di_size);
> -			size = (int)di_size;
> -			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK, size);
> -			break;
> -		case XFS_DINODE_FMT_EXTENTS:
> -			error = xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
> -			break;
> -		case XFS_DINODE_FMT_BTREE:
> -			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
> -			break;
> -		default:
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -					dip, sizeof(*dip), __this_address);
> -			return -EFSCORRUPTED;
> -		}
> -		break;
> -
> -	default:
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		return -EFSCORRUPTED;
> -	}
> -	if (error)
> -		return error;
> -
> -	if (xfs_is_reflink_inode(ip)) {
> -		ASSERT(ip->i_cowfp == NULL);
> -		xfs_ifork_init_cow(ip);
> -	}
> -
> -	if (!XFS_DFORK_Q(dip))
> -		return 0;
> -
> -	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> -
> -	switch (dip->di_aformat) {
> -	case XFS_DINODE_FMT_LOCAL:
> -		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
> -		size = be16_to_cpu(atp->hdr.totsize);
> -
> -		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
> -		break;
> -	case XFS_DINODE_FMT_EXTENTS:
> -		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> -		break;
> -	case XFS_DINODE_FMT_BTREE:
> -		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
> -		break;
> -	default:
> -		xfs_inode_verifier_error(ip, error, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		error = -EFSCORRUPTED;
> -		break;
> -	}
> -	if (error) {
> -		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> -		ip->i_afp = NULL;
> -		if (ip->i_cowfp)
> -			kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> -		ip->i_cowfp = NULL;
> -		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> -	}
> -	return error;
> -}
> -
>  void
>  xfs_init_local_fork(
>  	struct xfs_inode	*ip,
> @@ -325,6 +221,88 @@ xfs_iformat_btree(
>  	return 0;
>  }
>  
> +int
> +xfs_iformat_data_fork(
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFIFO:
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFSOCK:
> +		ip->i_d.di_size = 0;
> +		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
> +		return 0;
> +	case S_IFREG:
> +	case S_IFLNK:
> +	case S_IFDIR:
> +		switch (dip->di_format) {
> +		case XFS_DINODE_FMT_LOCAL:
> +			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
> +					be64_to_cpu(dip->di_size));
> +		case XFS_DINODE_FMT_EXTENTS:
> +			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
> +		case XFS_DINODE_FMT_BTREE:
> +			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
> +		default:
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +					dip, sizeof(*dip), __this_address);
> +			return -EFSCORRUPTED;
> +		}
> +		break;
> +	default:
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +				sizeof(*dip), __this_address);
> +		return -EFSCORRUPTED;
> +	}
> +}
> +
> +static uint16_t
> +xfs_dfork_attr_shortform_size(
> +	struct xfs_dinode		*dip)
> +{
> +	struct xfs_attr_shortform	*atp =
> +		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
> +
> +	return be16_to_cpu(atp->hdr.totsize);
> +}
> +
> +int
> +xfs_iformat_attr_fork(
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip)
> +{
> +	int			error = 0;
> +
> +	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	switch (dip->di_aformat) {
> +	case XFS_DINODE_FMT_LOCAL:
> +		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
> +				xfs_dfork_attr_shortform_size(dip));
> +		break;
> +	case XFS_DINODE_FMT_EXTENTS:
> +		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> +		break;
> +	case XFS_DINODE_FMT_BTREE:
> +		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
> +		break;
> +	default:
> +		xfs_inode_verifier_error(ip, error, __func__, dip,
> +				sizeof(*dip), __this_address);
> +		error = -EFSCORRUPTED;
> +		break;
> +	}
> +
> +	if (error) {
> +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> +		ip->i_afp = NULL;
> +	}
> +	return error;
> +}
> +
>  /*
>   * Reallocate the space for if_broot based on the number of records
>   * being added or deleted as indicated in rec_diff.  Move the records
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 668ee942be224..8487b0c88a75e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -88,7 +88,8 @@ struct xfs_ifork {
>  
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
> -int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
> +int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> +int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
>  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>  				struct xfs_inode_log_item *, int);
>  void		xfs_idestroy_fork(struct xfs_inode *, int);
> -- 
> 2.26.2
> 

