Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20332C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1D220758
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 16:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SIUwUGcv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbgJBQ2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 12:28:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgJBQ2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 12:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601656080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d00djst8bqGI7l6lAB1f0DoM2gPuRI0hjpMTqbE+1Eg=;
        b=SIUwUGcvVNGBoE1/bcJGZHf79xPlF4Gk6XWusLJfpg6fVUhzuOzOM1A+EHwwfaJKnk7DRh
        1Fo0kvfElHeIXmBgkWxXS+dK5QNJ3lHWOxropFDp5G0WG1ZuqNpXrnHW3whiKSlCS5gAaN
        rfu5Fxt1fHVTkue8M8kgC0tuIqCw1zI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-0VtPRkkgPGugUViYKjSuEg-1; Fri, 02 Oct 2020 12:27:58 -0400
X-MC-Unique: 0VtPRkkgPGugUViYKjSuEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A8351015EC4;
        Fri,  2 Oct 2020 16:27:57 +0000 (UTC)
Received: from bfoster (ovpn-114-177.rdu2.redhat.com [10.10.114.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E5EC78839;
        Fri,  2 Oct 2020 16:27:56 +0000 (UTC)
Date:   Fri, 2 Oct 2020 12:27:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20201002162754.GA4708@bfoster>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144017.830434.9012644788797432565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140144017.830434.9012644788797432565.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:44:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In most places in XFS, we have a specific order in which we gather
> resources: grab the inode, allocate a transaction, then lock the inode.
> xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> consistent.  This also makes the error bailout code a bit less weird.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c |   42 ++++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index c1f2cc3c42cb..1c9cb5a04bb5 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
...
> @@ -512,18 +513,19 @@ xfs_bui_item_recover(
>  		xfs_bmap_unmap_extent(tp, ip, &irec);
>  	}
>  
> +	/* Commit transaction, which frees tp. */
>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> +	if (error)
> +		goto err_unlock;
> +	return 0;
> +
> +err_cancel:
> +	xfs_trans_cancel(tp);
> +err_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +err_rele:
>  	xfs_irele(ip);

What happened to the unlock and irele in the non-error path?

Brian

>  	return error;
> -
> -err_inode:
> -	xfs_trans_cancel(tp);
> -	if (ip) {
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_irele(ip);
> -	}
> -	return error;
>  }
>  
>  STATIC bool
> 

