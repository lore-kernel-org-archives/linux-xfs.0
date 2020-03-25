Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F95C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38DD32078A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VGz/t5iY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCYNac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:30:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59503 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgCYNac (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 09:30:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585143031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Cf1kFU0qv2jPk86YkQN1DKstUKYJmtHZSbvvdY8rZM=;
        b=VGz/t5iYQVlbeQFpvclyC35EFmXv0IPAIfD5ngoZ0KMzJMcZ9N508yWNkVw/y+P+19G3Ew
        Km6BkyesJRxa2/T89LrAFvRAtA8YZbcvxXD/yatbR1FjA7aY8SuQ64rSe1oRi4DfVO3TAo
        XzWpw/mypz7RWocMFVY+Cbduabdoknw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-eW9ULVnVNqGlWmrvkvr1Og-1; Wed, 25 Mar 2020 09:30:27 -0400
X-MC-Unique: eW9ULVnVNqGlWmrvkvr1Og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A3513F5;
        Wed, 25 Mar 2020 13:30:26 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5717389E76;
        Wed, 25 Mar 2020 13:30:26 +0000 (UTC)
Date:   Wed, 25 Mar 2020 09:30:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: Improve metadata buffer reclaim accountability
Message-ID: <20200325133024.GA11912@bfoster>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffer cache shrinker frees more than just the xfs_buf slab
> objects - it also frees the pages attached to the buffers. Make sure
> the memory reclaim code accounts for this memory being freed
> correctly, similar to how the inode shrinker accounts for pages
> freed from the page cache due to mapping invalidation.
> 
> We also need to make sure that the mm subsystem knows these are
> reclaimable objects. We provide the memory reclaim subsystem with a
> a shrinker to reclaim xfs_bufs, so we should really mark the slab
> that way.
> 
> We also have a lot of xfs_bufs in a busy system, spread them around
> like we do inodes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

https://lore.kernel.org/linux-xfs/20191101120513.GD59146@bfoster/

>  fs/xfs/xfs_buf.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f880141a22681..9ec3eaf1c618f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -327,6 +327,9 @@ xfs_buf_free(
>  
>  			__free_page(page);
>  		}
> +		if (current->reclaim_state)
> +			current->reclaim_state->reclaimed_slab +=
> +							bp->b_page_count;
>  	} else if (bp->b_flags & _XBF_KMEM)
>  		kmem_free(bp->b_addr);
>  	_xfs_buf_free_pages(bp);
> @@ -2114,9 +2117,11 @@ xfs_buf_delwri_pushbuf(
>  int __init
>  xfs_buf_init(void)
>  {
> -	xfs_buf_zone = kmem_cache_create("xfs_buf",
> -					 sizeof(struct xfs_buf), 0,
> -					 SLAB_HWCACHE_ALIGN, NULL);
> +	xfs_buf_zone = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
> +					 SLAB_HWCACHE_ALIGN |
> +					 SLAB_RECLAIM_ACCOUNT |
> +					 SLAB_MEM_SPREAD,
> +					 NULL);
>  	if (!xfs_buf_zone)
>  		goto out;
>  
> -- 
> 2.26.0.rc2
> 

