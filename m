Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195A0C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1C3208DB
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J35TuBMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgEANeo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:34:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54536 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729589AbgEANen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q4uqJ94gILTg6URfmFOZ/gNT3q09kkcarLI71DQ7asE=;
        b=J35TuBMqmUOR9UWx27Brfgin4sYUntV6QSBO1NRR02UkwdpaGzR1J7rKgn/sk6x2m8Q0Ol
        aTbzu39HjZejbrETAfyJ4mVnSiKbB8JeRfff5d60H15MsnpTqhygfVXPe34A8Wpd0JCieR
        BUbpwtNzgxgCzgqhtuD+Xag3gvBefGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-8eIZ4b1pOF6QCW04dLu6Vg-1; Fri, 01 May 2020 09:34:35 -0400
X-MC-Unique: 8eIZ4b1pOF6QCW04dLu6Vg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15A42107ACCA;
        Fri,  1 May 2020 13:34:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 986A7196AE;
        Fri,  1 May 2020 13:34:33 +0000 (UTC)
Date:   Fri, 1 May 2020 09:34:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200501133431.GJ40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:15AM +0200, Christoph Hellwig wrote:
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
>  fs/xfs/libxfs/xfs_inode_buf.c  |  20 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c | 186 +++++++++++++++------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |   3 +-
>  3 files changed, 103 insertions(+), 106 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 518c6f0ec3a61..f30d43364aa92 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
...
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

Can we fix this function up to use an error variable and return error at
the end like xfs_iformat_attr_work() does? Otherwise nice cleanup..

Brian

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

