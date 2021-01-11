Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5980DC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00078225AC
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390441AbhAKS44 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 13:56:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390285AbhAKS4z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 13:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610391329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDV6EKCuHdijCc4d8MPXqWrvULIlnMd5uf1TMkfUW6w=;
        b=G6Vs+Ixq40ejreisLsY+19tn+rFkgTy2kR8LuXQrvgZfpClx58oQVaqWQQ1oI8IYTzo3jT
        RgNF+0tNWMiNuBfGqvoNdhT9qWFHLQv/jxYNxWs/jmaJ2D2bqYHofIxszwL512bUyXWi+u
        +UtmTCg/SlaNegOdzhTqqu8FwlTBim0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-Fx3_aGN1Owu4I0w39MaNjg-1; Mon, 11 Jan 2021 13:55:27 -0500
X-MC-Unique: Fx3_aGN1Owu4I0w39MaNjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03622802B49;
        Mon, 11 Jan 2021 18:55:26 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80C461972B;
        Mon, 11 Jan 2021 18:55:25 +0000 (UTC)
Date:   Mon, 11 Jan 2021 13:55:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 1/3] xfs: factor out a xfs_ilock_iocb helper
Message-ID: <20210111185523.GD1091932@bfoster>
References: <20210111161212.1414034-1-hch@lst.de>
 <20210111161212.1414034-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161212.1414034-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:12:10PM +0100, Christoph Hellwig wrote:
> Add a helper to factor out the nowait locking logical for the read/write
> helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 55 +++++++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index ba02780dee6439..aa3fe89628f0f1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -217,6 +217,23 @@ xfs_file_fsync(
>  	return error;
>  }
>  
> +static int
> +xfs_ilock_iocb(
> +	struct kiocb		*iocb,
> +	unsigned int		lock_mode)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, lock_mode))
> +			return -EAGAIN;
> +	} else {
> +		xfs_ilock(ip, lock_mode);
> +	}
> +
> +	return 0;
> +}
> +
>  STATIC ssize_t
>  xfs_file_dio_aio_read(
>  	struct kiocb		*iocb,
> @@ -233,12 +250,9 @@ xfs_file_dio_aio_read(
>  
>  	file_accessed(iocb->ki_filp);
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> -		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> -			return -EAGAIN;
> -	} else {
> -		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	}
> +	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	if (ret)
> +		return ret;
>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
>  			is_sync_kiocb(iocb));
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> @@ -260,13 +274,9 @@ xfs_file_dax_read(
>  	if (!count)
>  		return 0; /* skip atime */
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> -		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> -			return -EAGAIN;
> -	} else {
> -		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	}
> -
> +	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	if (ret)
> +		return ret;
>  	ret = dax_iomap_rw(iocb, to, &xfs_read_iomap_ops);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> @@ -284,12 +294,9 @@ xfs_file_buffered_aio_read(
>  
>  	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> -		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> -			return -EAGAIN;
> -	} else {
> -		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	}
> +	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
> +	if (ret)
> +		return ret;
>  	ret = generic_file_read_iter(iocb, to);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> @@ -628,13 +635,9 @@ xfs_file_dax_write(
>  	size_t			count;
>  	loff_t			pos;
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> -		if (!xfs_ilock_nowait(ip, iolock))
> -			return -EAGAIN;
> -	} else {
> -		xfs_ilock(ip, iolock);
> -	}
> -
> +	ret = xfs_ilock_iocb(iocb, iolock);
> +	if (ret)
> +		return ret;
>  	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
>  	if (ret)
>  		goto out;
> -- 
> 2.29.2
> 

