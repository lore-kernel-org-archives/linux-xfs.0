Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FAEC433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38F74613AE
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhDEQgB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238872AbhDEQgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 12:36:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tdgm7yQbkG1IuPABfhfpnndYwfx9pxGuSIC0ad9Rfqw=;
        b=QfpsgHuPIBnFL8TLZTPmhSWGqNEqnwE58wljDZx9bfwljmwt0nGtO9q8sHtGU9IlP7wqR5
        7mrM2nr2BQ77TVQs9EiaqasTSUnzb7hVqiQkFFIPRtpcEDPfMQ5zsckfNZTswvfZ09FvG8
        IucDyxxYWekuhzZAMoth8+e2VXyZ+jI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-isWIby4TMSOxD6vEh3L4rg-1; Mon, 05 Apr 2021 12:35:53 -0400
X-MC-Unique: isWIby4TMSOxD6vEh3L4rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 713BA190A7A1;
        Mon,  5 Apr 2021 16:35:52 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A3211349A;
        Mon,  5 Apr 2021 16:35:51 +0000 (UTC)
Date:   Mon, 5 Apr 2021 12:35:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: only look at the fork format in
 xfs_idestroy_fork
Message-ID: <YGs8ZnZF0umWnW+r@bfoster>
References: <20210402142409.372050-1-hch@lst.de>
 <20210402142409.372050-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402142409.372050-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 04:24:06PM +0200, Christoph Hellwig wrote:
> Stop using the XFS_IFEXTENTS flag, and instead switch on the fork format
> in xfs_idestroy_fork to decide how to cleanup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

And FWIW the remaining patches seem generally reasonable to me at a
quick read through. I'll probably have to take a closer look at the
details once this is more solidified..

Brian

>  fs/xfs/libxfs/xfs_inode_fork.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 1851d6f266d06b..9bdeb2d474b038 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -522,17 +522,16 @@ xfs_idestroy_fork(
>  		ifp->if_broot = NULL;
>  	}
>  
> -	/*
> -	 * If the format is local, then we can't have an extents array so just
> -	 * look for an inline data array.  If we're not local then we may or may
> -	 * not have an extents list, so check and free it up if we do.
> -	 */
> -	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
> +	switch (ifp->if_format) {
> +	case XFS_DINODE_FMT_LOCAL:
>  		kmem_free(ifp->if_u1.if_data);
>  		ifp->if_u1.if_data = NULL;
> -	} else if (ifp->if_flags & XFS_IFEXTENTS) {
> +		break;
> +	case XFS_DINODE_FMT_EXTENTS:
> +	case XFS_DINODE_FMT_BTREE:
>  		if (ifp->if_height)
>  			xfs_iext_destroy(ifp);
> +		break;
>  	}
>  }
>  
> -- 
> 2.30.1
> 

