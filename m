Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BC9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 16:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbiEIQr1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 12:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbiEIQrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 12:47:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEF11C5F96
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 09:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28263614E4
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F6CC385AC;
        Mon,  9 May 2022 16:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652114609;
        bh=sWymB+jio5euZRghAGImjCF45udxTsD16vm12D0tR3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zb9TtS3C3buKaqEt0EpU9sw54hG8iisAsUGiRFD07kOpCDkr/h7n5cqddlTYg6L5B
         45cNuWjscxdAGmKgJpOaI+qAg0f3lIuQcNeMaApkednW75ug6HyiPJpq9za9pTh5dc
         xQfK0MLqiglLQIpsG1oYkefb4Z/fhBGxSF6guS2dR8v6hpfxYK039VV0VTCDgi7j/n
         ccvJlcKAgQRU4rH0SsFYe6OzKr986W5OjyGBgmPC+aJpxnzjFw0HKuPXXeoWibjcse
         5VkkalhwDC8e2xgxauCmQyS8wJ9dTVcv72OGvXnKVbz5BB1Hw0Kt6aKnj4Kwtf0aJA
         7OumigSG7GcLg==
Date:   Mon, 9 May 2022 09:43:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/18] xfs: initialise attrd item to zero
Message-ID: <20220509164329.GV27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:22AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On the first allocation of a attrd item, xfs_trans_add_item() fires
> an assert like so:
> 
>  XFS (pmem0): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
>  XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 683
>  ------------[ cut here ]------------
>  kernel BUG at fs/xfs/xfs_message.c:102!
>  Call Trace:
>   <TASK>
>   xfs_trans_add_item+0x17e/0x190
>   xfs_trans_get_attrd+0x67/0x90
>   xfs_attr_create_done+0x13/0x20
>   xfs_defer_finish_noroll+0x100/0x690
>   __xfs_trans_commit+0x144/0x330
>   xfs_trans_commit+0x10/0x20
>   xfs_attr_set+0x3e2/0x4c0
>   xfs_initxattrs+0xaa/0xe0
>   security_inode_init_security+0xb0/0x130
>   xfs_init_security+0x18/0x20
>   xfs_generic_create+0x13a/0x340
>   xfs_vn_create+0x17/0x20
>   path_openat+0xff3/0x12f0
>   do_filp_open+0xb2/0x150
> 
> The attrd log item is allocated via kmem_cache_alloc, and
> xfs_log_item_init() does not zero the entire log item structure - it
> assumes that the structure is already all zeros as it only
> initialises non-zero fields. Fix the attr items to be allocated
> via the *zalloc methods.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 9061adce3f16..5f8680b05079 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -721,7 +721,7 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
>  
>  	ASSERT(tp != NULL);
>  
> -	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
> +	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>  			  &xfs_attrd_item_ops);
> -- 
> 2.35.1
> 
