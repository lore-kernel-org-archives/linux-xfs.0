Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1C9C11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D95AA2467B
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 17:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2ovf6P+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgBTR7t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:59:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53448 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727298AbgBTR7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 12:59:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582221588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XjPFZr9araf72JyZzTYGjxQSksCQczofnfzbmXDvYSA=;
        b=a2ovf6P+Jw0ic96yenEL0f8X22YoYMyi6WrwHOS9qE9e8eXUDPCvMFlSdgYfHgVRkwf9X6
        IjPTxeGEgRATMg6nFgr6FZbCcY//nW8RYUTz/ysW4NgmL9GK0emjX0eJaCOWpeTTbn5qC5
        LjXGcDqaKv/rOrKEQUBGOm2b7T8PCkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-O-SmNl9OOmaNtKwDJ5mIKA-1; Thu, 20 Feb 2020 12:59:44 -0500
X-MC-Unique: O-SmNl9OOmaNtKwDJ5mIKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E02A100550E;
        Thu, 20 Feb 2020 17:59:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E604E8B55D;
        Thu, 20 Feb 2020 17:59:42 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:59:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: ratelimit xfs_buf_ioerror_alert messages
Message-ID: <20200220175941.GJ48977@bfoster>
References: <20200220153921.383899-1-hch@lst.de>
 <20200220153921.383899-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220153921.383899-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:39:20AM -0800, Christoph Hellwig wrote:
> Use printk_ratelimit() to limit the amount of messages printed from
> xfs_buf_ioerror_alert.  Without that a failing device causes a large
> number of errors that doesn't really help debugging the underling
> issue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 217e4f82a44a..0ceaa172545b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1238,7 +1238,7 @@ xfs_buf_ioerror_alert(
>  	struct xfs_buf		*bp,
>  	xfs_failaddr_t		func)
>  {
> -	xfs_alert(bp->b_mount,
> +	xfs_alert_ratelimited(bp->b_mount,
>  "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
>  			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
>  			-bp->b_error);
> -- 
> 2.24.1
> 

