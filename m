Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81D9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 17:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244120AbiCJRG6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 12:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiCJRG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 12:06:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D74151361;
        Thu, 10 Mar 2022 09:05:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9529B618EE;
        Thu, 10 Mar 2022 17:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3369C340E8;
        Thu, 10 Mar 2022 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646931955;
        bh=ye95MDOTg75h+aOy7KtD+fguU2tjhcPOdfH6e9wfgKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QYnQ0LrK4RQjWot15ZCwZD7DbpRTrElze8K4Aa22TKOQSbhNEEJpBbKvVQtNJvq2r
         vYaxS+DueMcJ/wfg+HP2iMpq4D0S5ntzyHeu/7K9beXjCRvK42l0fURLwNz2rqoqjw
         Tn2HODpO2y7+60Lh4o+2hlYE+TGmkl6kdN94PX2iYmY+VG1J/QZ6m7geaZfhKAvY1W
         poIJvfZNAKDEQbZg+wbnLhXR7ig/P398H63tqHPYwUuZ10cqp5pMFMsjRoZngMdyXG
         RkOMUDfdYR6nNO09tTtBHBI6k4X2xfSrvtrg182MDKNr+VkkARK5ZPqmIkOhjOMUm0
         D5HfXWERBrUfw==
Date:   Thu, 10 Mar 2022 09:05:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: xfs_rmap_item: Add ASSERT after calling kmem_zalloc
Message-ID: <20220310170554.GH8224@magnolia>
References: <20220310094303.2013165-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310094303.2013165-1-jiasheng@iscas.ac.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 05:43:03PM +0800, Jiasheng Jiang wrote:
> As the potential failure of the kmem_zalloc() without __GFP_NOFAIL,
> it should be better to check it in order to avoid the dereference
> of NULL pointer.
> 
> Fixes: 5880f2d78ff1 ("xfs: create rmap update intent log items")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  fs/xfs/xfs_rmap_item.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c3966b4c58ef..66395faeeb87 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -143,6 +143,7 @@ xfs_rui_init(
>  	else
>  		ruip = kmem_cache_zalloc(xfs_rui_cache,
>  					 GFP_KERNEL | __GFP_NOFAIL);
> +	ASSERT(ruip);
>  
>  	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);

Setting aside for a moment the fact that we'll crash immediately on the
very next line anyways --

The defer ops code will never create an rmap intent item with nextents >
XFS_RUI_MAX_FAST_EXTENTS, so the only way that we'd end up in the
kmem_zalloc path is if one came in via log recovery.  We're allowed to
fail log recovery, so why not return NULL if kmem_zalloc fails, and then
patch xlog_recover_rui_commit_pass2 to return ENOMEM if it cannot
allocate ruip?

While we're on this topic -- do the other xfs log intent items need
similar corrections in the xfs_*_init() callers?

--D

>  	ruip->rui_format.rui_nextents = nextents;
> -- 
> 2.25.1
> 
