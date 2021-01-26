Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFF4C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF502076D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313707AbhAZXDq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:42860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392644AbhAZR7g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 12:59:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F057422240;
        Tue, 26 Jan 2021 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611683936;
        bh=r4NFXtZvH4j/ZSA4bw3YwcYY0oEkZ+mU0yKX0PYo1Rs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDvyIYAjmmt5Bd8f7uxuNf/SJaXAXEW1MV7lwr7lwnhet7YFSRPLNdpOihwvwiCD+
         zl2N6YGaqatM7YeLjEKq5gKCso/3Bncf8OzuWOTKeamfBLacRff4mTCkkcfzKe0V7I
         0gYHcdL3O+eMfzLa2pLRPf2E7UgAJP+UepfdXq3OU4gWMr/+t30nzkKY0IVe1mhwnr
         pN+/mPLSrADY3d+WBUEDuYq/rgMT/4NX1/gu260zsFLD82DcLRLVUnLG7N5BRba1H9
         FYxlPGgk4h5Tdo9+dkipGu4BkcuHCsjr8kYt+fFkRDO0uGcILLWg+pagPLl6g5k/Q6
         dEengOYnXOhBg==
Date:   Tue, 26 Jan 2021 09:58:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 1/2] xfsprogs: xfs_fsr: Interpret arguments of qsort's
 compare function correctly
Message-ID: <20210126175855.GW7698@magnolia>
References: <20210125095809.219833-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125095809.219833-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 03:28:08PM +0530, Chandan Babu R wrote:
> The first argument passed to qsort() in fsrfs() is an array of "struct
> xfs_bulkstat". Hence the two arguments to the cmp() function must be
> interpreted as being of type "struct xfs_bulkstat *" as against "struct
> xfs_bstat *" that is being used to currently typecast them.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fsr/xfs_fsr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 77a10a1d..635e4c70 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -702,9 +702,8 @@ out0:
>  int
>  cmp(const void *s1, const void *s2)
>  {
> -	return( ((struct xfs_bstat *)s2)->bs_extents -
> -	        ((struct xfs_bstat *)s1)->bs_extents);
> -
> +	return( ((struct xfs_bulkstat *)s2)->bs_extents -
> +	        ((struct xfs_bulkstat *)s1)->bs_extents);

It might be a good idea to check bs_version here to avoid future
maintainer screwups <coughs this maintainer>

Thanks for catching this,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
>  /*
> -- 
> 2.29.2
> 
