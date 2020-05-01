Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E6BC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F541216FD
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 15:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYHZpl+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgEAP41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 11:56:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27754 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729037AbgEAP41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 11:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588348585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aXbAvnlluvqolVbnTIAv0bE7z6ypeDDUijScHdI1dX0=;
        b=EYHZpl+57E3FQVwsjj3sFd4ZQODZKnOSGhCzoeO+kRH3on5M9KZEenhvii70j8cfkUehj4
        A18Y7UYxigpR9jCjCulVe28veCQOW+c+i5L1wjljhwSsRgsqNUIzA+Yx9IF8VBh8NluyEJ
        wcOjknu2HYwzNCu1KecwC5xKT7vbqO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-2zTJ6FCENXWeQAyiXbGcAw-1; Fri, 01 May 2020 11:56:18 -0400
X-MC-Unique: 2zTJ6FCENXWeQAyiXbGcAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10CE107ACCA;
        Fri,  1 May 2020 15:56:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6347E5D714;
        Fri,  1 May 2020 15:56:17 +0000 (UTC)
Date:   Fri, 1 May 2020 11:56:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: remove xfs_iread
Message-ID: <20200501155615.GN40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-8-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:19AM +0200, Christoph Hellwig wrote:
> There is not much point in the xfs_iread function, as it has a single
> caller and not a whole lot of code.  Move it into the only caller,
> and trim down the overdocumentation to just documenting the important
> "why" instead of a lot of redundant "what".
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 73 -----------------------------------
>  fs/xfs/libxfs/xfs_inode_buf.h |  2 -
>  fs/xfs/xfs_icache.c           | 33 +++++++++++++++-
>  3 files changed, 32 insertions(+), 76 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8bf1d15be3f6a..dd757c6614956 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
...
> @@ -510,10 +511,40 @@ xfs_iget_cache_miss(
>  	if (!ip)
>  		return -ENOMEM;
>  
> -	error = xfs_iread(mp, tp, ip, flags);
> +	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, flags);
>  	if (error)
>  		goto out_destroy;
>  
> +	/*
> +	 * For version 5 superblocks, if we are initialising a new inode and we
> +	 * are not utilising the XFS_MOUNT_IKEEP inode cluster mode, we can
> +	 * simple build the new inode core with a random generation number.

I'm assuming the original comment meant to say "simply" here instead of
"simple." Otherwise looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	 *
> +	 * For version 4 (and older) superblocks, log recovery is dependent on
> +	 * the di_flushiter field being initialised from the current on-disk
> +	 * value and hence we must also read the inode off disk even when
> +	 * initializing new inodes.
> +	 */
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> +		VFS_I(ip)->i_generation = prandom_u32();
> +	} else {
> +		struct xfs_dinode	*dip;
> +		struct xfs_buf		*bp;
> +
> +		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0, flags);
> +		if (error)
> +			goto out_destroy;
> +
> +		error = xfs_inode_from_disk(ip, dip);
> +		if (!error)
> +			xfs_buf_set_ref(bp, XFS_INO_REF);
> +		xfs_trans_brelse(tp, bp);
> +
> +		if (error)
> +			goto out_destroy;
> +	}
> +
>  	if (!xfs_inode_verify_forks(ip)) {
>  		error = -EFSCORRUPTED;
>  		goto out_destroy;
> -- 
> 2.26.2
> 

