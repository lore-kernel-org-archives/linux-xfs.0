Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC3DC11D05
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB3FB208C4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 14:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdnTnqvY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgBTOMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 09:12:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26908 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728225AbgBTOMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 09:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582207934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1R3GNEfOwtMJiSsu+Z0CdJt+Emqv5Ig3UoemRRtYRw=;
        b=FdnTnqvYNurMVN5nHItz45WSAXnnksjvWuTwCOsk5BlDE86ICLQO4HE3yhqu9T6NiMd9d2
        lOyerZa4aW55pSkMR6vErkd7aYTzoBexst1h7sRkc4iAEVtQ+Gk7/NVk73l0XwjF4qsW/P
        E1zmExVIZIcfZqpbtGtjVwjpkUayFO4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-m_m6qHoVP7GDxsa9i4ao5w-1; Thu, 20 Feb 2020 09:12:09 -0500
X-MC-Unique: m_m6qHoVP7GDxsa9i4ao5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 998B8107B284;
        Thu, 20 Feb 2020 14:12:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0E95C297;
        Thu, 20 Feb 2020 14:12:08 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:12:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: ratelimit xfs_buf_ioerror_alert
Message-ID: <20200220141206.GE48977@bfoster>
References: <20200220040549.366547-1-hch@lst.de>
 <20200220040549.366547-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220040549.366547-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 08:05:48PM -0800, Christoph Hellwig wrote:
> Use printk_ratelimit() to limit the amount of messages printed from
> xfs_buf_ioerror_alert.  Without that a failing device causes a large
> number of errors that doesn't really help debugging the underling
> issue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 217e4f82a44a..e010680a665e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1238,6 +1238,8 @@ xfs_buf_ioerror_alert(
>  	struct xfs_buf		*bp,
>  	xfs_failaddr_t		func)
>  {
> +	if (!printk_ratelimit())
> +		return;

xfs_alert_ratelimited() ?

Brian

>  	xfs_alert(bp->b_mount,
>  "metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
>  			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
> -- 
> 2.24.1
> 

