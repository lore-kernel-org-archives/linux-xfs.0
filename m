Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8558FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5765920738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VU+0lqts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFBQr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:47:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30172 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725940AbgFBQr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591116476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K2ldsEzLZc/xUKhitIUNp1QTtAiBA0fFXXn07Hu/vVI=;
        b=VU+0lqtsZyTu42TzBf+7plv1cN8HG8Jky86VDrNAugIoSAZml6IxiY0G1kU0UjnyzPJVlP
        bKp5i/WvGZ1aP/elqDfttY93d2AJVbPlOM32HB4xkC9JfX4j8MFCcmT9qduqpPlxYPnD0I
        oEbqsiBA2dpfjqpsdYN0fcNq5yqE/Oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-9Q9BHEOUOE6TxcCi9vo2LA-1; Tue, 02 Jun 2020 12:47:54 -0400
X-MC-Unique: 9Q9BHEOUOE6TxcCi9vo2LA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97F9B100CCC2;
        Tue,  2 Jun 2020 16:47:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E9E561980;
        Tue,  2 Jun 2020 16:47:53 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:47:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/30] xfs: clean up whacky buffer log item list reinit
Message-ID: <20200602164751.GH7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-9-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:29AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we've emptied the buffer log item list, it does a list_del_init
> on itself to reset it's pointers to itself. This is unnecessary as
> the list is already empty at this point - it was a left-over
> fragment from the list_head conversion of the buffer log item list.
> Remove them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index d87ae6363a130..5b3cd5e90947c 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -459,7 +459,6 @@ xfs_buf_item_unpin(
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>  			xfs_buf_do_callbacks(bp);
>  			bp->b_log_item = NULL;
> -			list_del_init(&bp->b_li_list);
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> @@ -1165,7 +1164,6 @@ xfs_buf_run_callbacks(
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_log_item = NULL;
> -	list_del_init(&bp->b_li_list);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 

