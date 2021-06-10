Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3800BC48BD1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17896613F1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 22:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFJWu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFJWu4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Jun 2021 18:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E84CD613E7;
        Thu, 10 Jun 2021 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623365340;
        bh=xyYG/xWv9OgETqjrIIwvx02poA2J2VsIeOaXhCAVG7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrX9RP7wLT+vrsW/F6+uom1i7Xc7Vqtygo4wnkgSAvZHhlLSMch4Q3g1efJI29Uni
         nHwFvVMLYZzb7BbHG6/pwBkKOV3wWqYTKBDbc9NlqcUjfySx9Zqw+Vi53GhyufVARR
         KvGDHFpRzOjRtOonepcj5Q+Jt4pRAdtEa9UA8PrWeZeVkPbN55PQtKbN8+LDx7jRL/
         /lJxsFkHS5BaSh22ilRary0eYEG58wsE6eYkulinIr3Vvx9Dw9vWIajsMVK//AXxQ+
         MLGhwJbEQVkY/LjV8f2mylelY5DPUvIGSbYBBMTR6Z8unDDYTgmqndMgwjN0WBZPFZ
         k8iLL7k1VBeSg==
Date:   Thu, 10 Jun 2021 15:48:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: perag may be null in xfs_imap()
Message-ID: <20210610224859.GC2945738@locust>
References: <YMGuMliXClE/dz5y@mwanda>
 <20210610223747.GR664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610223747.GR664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 08:37:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Dan Carpenter's static checker reported:
> 
> The patch 7b13c5155182: "xfs: use perag for ialloc btree cursors"
> from Jun 2, 2021, leads to the following Smatch complaint:
> 
>     fs/xfs/libxfs/xfs_ialloc.c:2403 xfs_imap()
>     error: we previously assumed 'pag' could be null (see line 2294)
> 
> And it's right. Fix it.
> 
> Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks correct to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 654a8d9681e1..57d9cb632983 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2398,7 +2398,8 @@ xfs_imap(
>  	}
>  	error = 0;
>  out_drop:
> -	xfs_perag_put(pag);
> +	if (pag)
> +		xfs_perag_put(pag);
>  	return error;
>  }
>  
