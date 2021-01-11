Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD08C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4CB22795
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 18:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbhAKS5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 13:57:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731326AbhAKS5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 13:57:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610391338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i9QXZws2K7xjjX0CK4IS5QXRLQ8ZTxjoix3Q1E30ink=;
        b=f4FYvNnTWYbyzRFvJjibVbLIpAE0CGPL9UVlUfUPqG3rjL2BtIlTMh/ZPWGNwoY4XOmzOS
        Cs7BocVMqs0Vr7LVlDbAVNGOscGGWLMFv4vG3nY6efnisRCjmBG2FNiDkksV3uAC2oqdXD
        l+zIkvmPtLYQ4AzGrbb0/qGuekdbg1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-Laa_56hbMH-4xX_-TCUDzQ-1; Mon, 11 Jan 2021 13:55:34 -0500
X-MC-Unique: Laa_56hbMH-4xX_-TCUDzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD2C410051A8;
        Mon, 11 Jan 2021 18:55:33 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3562A5D9DB;
        Mon, 11 Jan 2021 18:55:33 +0000 (UTC)
Date:   Mon, 11 Jan 2021 13:55:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 2/3] xfs: make xfs_file_aio_write_checks IOCB_NOWAIT-aware
Message-ID: <20210111185531.GE1091932@bfoster>
References: <20210111161212.1414034-1-hch@lst.de>
 <20210111161212.1414034-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161212.1414034-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:12:11PM +0100, Christoph Hellwig wrote:
> Ensure we don't block on the iolock, or waiting for I/O in
> xfs_file_aio_write_checks if the caller asked to avoid that.
> 
> Fixes: 29a5d29ec181 ("xfs: nowait aio support")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index aa3fe89628f0f1..1470fc4f2e0255 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -355,7 +355,14 @@ xfs_file_aio_write_checks(
>  	if (error <= 0)
>  		return error;
>  
> -	error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		error = break_layout(inode, false);
> +		if (error == -EWOULDBLOCK)
> +			error = -EAGAIN;
> +	} else {
> +		error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
> +	}
> +
>  	if (error)
>  		return error;
>  
> @@ -366,7 +373,11 @@ xfs_file_aio_write_checks(
>  	if (*iolock == XFS_IOLOCK_SHARED && !IS_NOSEC(inode)) {
>  		xfs_iunlock(ip, *iolock);
>  		*iolock = XFS_IOLOCK_EXCL;
> -		xfs_ilock(ip, *iolock);
> +		error = xfs_ilock_iocb(iocb, *iolock);
> +		if (error) {
> +			*iolock = 0;
> +			return error;
> +		}
>  		goto restart;
>  	}
>  	/*
> @@ -388,6 +399,10 @@ xfs_file_aio_write_checks(
>  	isize = i_size_read(inode);
>  	if (iocb->ki_pos > isize) {
>  		spin_unlock(&ip->i_flags_lock);
> +
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return -EAGAIN;
> +
>  		if (!drained_dio) {
>  			if (*iolock == XFS_IOLOCK_SHARED) {
>  				xfs_iunlock(ip, *iolock);
> @@ -613,7 +628,8 @@ xfs_file_dio_aio_write(
>  			   &xfs_dio_write_ops,
>  			   is_sync_kiocb(iocb) || unaligned_io);
>  out:
> -	xfs_iunlock(ip, iolock);
> +	if (iolock)
> +		xfs_iunlock(ip, iolock);
>  
>  	/*
>  	 * No fallback to buffered IO after short writes for XFS, direct I/O
> @@ -652,7 +668,8 @@ xfs_file_dax_write(
>  		error = xfs_setfilesize(ip, pos, ret);
>  	}
>  out:
> -	xfs_iunlock(ip, iolock);
> +	if (iolock)
> +		xfs_iunlock(ip, iolock);
>  	if (error)
>  		return error;
>  
> -- 
> 2.29.2
> 

