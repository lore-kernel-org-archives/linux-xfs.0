Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8F6C11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 18:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D592467A
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 18:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RKqoCxcQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgBTSAF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:00:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42253 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgBTSAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 13:00:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582221604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhjsUvCpVFMgmaXx5KxTCZt2A0wWqnGInMsprGM8Ck0=;
        b=RKqoCxcQxq2sg7MdvCOFxfpWeI9Oa95e72O9AuVSzaYdIKzKuIiAM0e0K+MmQaEl8bEEgG
        LALasdT0XwaUaUKPunY/8YxujZqn6mut1wMAiyc6MTnnflxWOrVE3Palbq7JG7YcPmo0CT
        Ljnzicwtf/DbZFLZxu6AFrNYGRCwNeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-WNLPjDc9PPe_-wePt0E51g-1; Thu, 20 Feb 2020 12:59:59 -0500
X-MC-Unique: WNLPjDc9PPe_-wePt0E51g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C48918A5502;
        Thu, 20 Feb 2020 17:59:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D0F198ED16;
        Thu, 20 Feb 2020 17:59:57 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:59:55 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: ratelimit xfs_discard_page messages
Message-ID: <20200220175955.GK48977@bfoster>
References: <20200220153921.383899-1-hch@lst.de>
 <20200220153921.383899-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220153921.383899-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:39:21AM -0800, Christoph Hellwig wrote:
> Use printk_ratelimit() to limit the amount of messages printed from
> xfs_discard_page.  Without that a failing device causes a large
> number of errors that doesn't really help debugging the underling
> issue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 58e937be24ce..9d9cebf18726 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -539,7 +539,7 @@ xfs_discard_page(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		goto out_invalidate;
>  
> -	xfs_alert(mp,
> +	xfs_alert_ratelimited(mp,
>  		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
>  			page, ip->i_ino, offset);
>  
> -- 
> 2.24.1
> 

