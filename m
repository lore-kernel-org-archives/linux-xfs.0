Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9CDC47247
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF07421655
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4OdA74m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEHPGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:06:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728103AbgEHPGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588950365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URsW1HUKo2u2WoGappUIN6v16o01W7mi9Fe4j/80S2I=;
        b=B4OdA74mmtu8N91CuP0D5ijYZ+tOn8e/ym+RmrcH5Bo6IhdkDfXmq/iPLYRWeKiW8onv9e
        6fX0vq7q0+3v/rBv16IZ/BI2077qokOQ6kdzzTCzx2kBEwHZzTkFvrlBGs9s4O95GBBV+K
        6DD0yHE1CpMywI9D7Rb9DvaIiG7DiK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-eNqcqWrDNQiW0Zrc8YgRhQ-1; Fri, 08 May 2020 11:06:03 -0400
X-MC-Unique: eNqcqWrDNQiW0Zrc8YgRhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5CBB81CBE3;
        Fri,  8 May 2020 15:06:02 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A3AB60BEC;
        Fri,  8 May 2020 15:06:02 +0000 (UTC)
Date:   Fri, 8 May 2020 11:06:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: improve local fork verification
Message-ID: <20200508150600.GH27577@bfoster>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-11-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:21AM +0200, Christoph Hellwig wrote:
> Call the data/attr local fork verifies as soon as we are ready for them.
> This keeps them close to the code setting up the forks, and avoids a
> few branches later on.  Also open code xfs_inode_verify_forks in the
> only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_fork.c |  8 +++++++-
>  fs/xfs/xfs_icache.c            |  6 ------
>  fs/xfs/xfs_inode.c             | 28 +++++++++-------------------
>  fs/xfs/xfs_inode.h             |  2 --
>  fs/xfs/xfs_log_recover.c       |  5 -----
>  5 files changed, 16 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 401921975d75b..2fe325e38fd88 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -227,6 +227,7 @@ xfs_iformat_data_fork(
>  	struct xfs_dinode	*dip)
>  {
>  	struct inode		*inode = VFS_I(ip);
> +	int			error;
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -241,8 +242,11 @@ xfs_iformat_data_fork(
>  	case S_IFDIR:
>  		switch (dip->di_format) {
>  		case XFS_DINODE_FMT_LOCAL:
> -			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
> +			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK,
>  					be64_to_cpu(dip->di_size));
> +			if (!error)
> +				error = xfs_ifork_verify_local_data(ip);
> +			return error;
>  		case XFS_DINODE_FMT_EXTENTS:
>  			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
>  		case XFS_DINODE_FMT_BTREE:
> @@ -282,6 +286,8 @@ xfs_iformat_attr_fork(
>  	case XFS_DINODE_FMT_LOCAL:
>  		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
>  				xfs_dfork_attr_shortform_size(dip));
> +		if (!error)
> +			error = xfs_ifork_verify_local_attr(ip);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index af5748f5d9271..5a3a520b95288 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -543,14 +543,8 @@ xfs_iget_cache_miss(
>  			goto out_destroy;
>  	}
>  
> -	if (!xfs_inode_verify_forks(ip)) {
> -		error = -EFSCORRUPTED;
> -		goto out_destroy;
> -	}
> -
>  	trace_xfs_iget_miss(ip);
>  
> -
>  	/*
>  	 * Check the inode free state is valid. This also detects lookup
>  	 * racing with unlinks.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c8abdefe00377..549ff468b7b60 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3707,23 +3707,6 @@ xfs_iflush(
>  	return error;
>  }
>  
> -/*
> - * If there are inline format data / attr forks attached to this inode,
> - * make sure they're not corrupt.
> - */
> -bool
> -xfs_inode_verify_forks(
> -	struct xfs_inode	*ip)
> -{
> -	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> -	    xfs_ifork_verify_local_data(ip))
> -		return false;
> -	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> -	    xfs_ifork_verify_local_attr(ip))
> -		return false;
> -	return true;
> -}
> -
>  STATIC int
>  xfs_iflush_int(
>  	struct xfs_inode	*ip,
> @@ -3808,8 +3791,15 @@ xfs_iflush_int(
>  	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
>  		ip->i_d.di_flushiter++;
>  
> -	/* Check the inline fork data before we write out. */
> -	if (!xfs_inode_verify_forks(ip))
> +	/*
> +	 * If there are inline format data / attr forks attached to this inode,
> +	 * make sure they are not corrupt.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_data(ip))
> +		goto flush_out;
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_attr(ip))
>  		goto flush_out;
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 83073c883fbf9..ff846197941e4 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -498,8 +498,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
> -bool xfs_inode_verify_forks(struct xfs_inode *ip);
> -
>  int xfs_iunlink_init(struct xfs_perag *pag);
>  void xfs_iunlink_destroy(struct xfs_perag *pag);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 3960caf51c9f7..87b940cb760db 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2878,11 +2878,6 @@ xfs_recover_inode_owner_change(
>  	if (error)
>  		goto out_free_ip;
>  
> -	if (!xfs_inode_verify_forks(ip)) {
> -		error = -EFSCORRUPTED;
> -		goto out_free_ip;
> -	}
> -
>  	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
>  		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
> -- 
> 2.26.2
> 

