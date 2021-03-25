Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F70C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 18:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAFD361A3E
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 18:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCYSrz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 14:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhCYSre (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 14:47:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1E6D61A3D;
        Thu, 25 Mar 2021 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616698053;
        bh=mS4KEiEFdNblnovM4tgPs/nOYfMHV8nqjCMjWk/lN+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEy+71rRMtjSVScnLdNEpiKPoi8wH0FLYiRbJ788bjqSVfOwAQQTp+ShIG4l6/MFD
         gcCo7jFIpn102wKhgLUTL0327wntomUIqXRihAQ9lzQgkEb5Wdl+GSSrtaOHXNUgWt
         CW+sTRu5GWp9HGJEr+xNMi3sGUd7EqwkbYm0Xwl+FcxC+QQNAGvUw0LbOpazFZ6ueF
         TVFNP4b8bhlODqkqdlBoQvzW6BS/9lzu/RyPbKucMySHLaGGN8w0LrFvrLmt0EaBJ+
         /UaXuC5SGZ3Us+9dsCCpheOGpG6fN8aQBS/2gtm4q8YXKA9CHUvFaV780WyFc+8KIa
         IeO/WKa897Png==
Date:   Thu, 25 Mar 2021 11:47:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix xfs_trans slab cache name
Message-ID: <20210325184730.GK4090233@magnolia>
References: <20210325164750.19599-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325164750.19599-1-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:47:50PM +0100, Anthony Iliopoulos wrote:
> Removal of kmem_zone_init wrappers accidentally changed a slab cache
> name from "xfs_trans" to "xf_trans". Fix this so that userspace
> consumers of /proc/slabinfo and /sys/kernel/slab can find it again.
> 
> Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Heh, whoops.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 699c61637961..f816137ae976 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1905,7 +1905,7 @@ xfs_init_zones(void)
>  	if (!xfs_ifork_zone)
>  		goto out_destroy_da_state_zone;
>  
> -	xfs_trans_zone = kmem_cache_create("xf_trans",
> +	xfs_trans_zone = kmem_cache_create("xfs_trans",
>  					   sizeof(struct xfs_trans),
>  					   0, 0, NULL);
>  	if (!xfs_trans_zone)
> -- 
> 2.31.0
> 
