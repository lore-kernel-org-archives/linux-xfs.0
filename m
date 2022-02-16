Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDB4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 02:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiBPC12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 21:27:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238195AbiBPC12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 21:27:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26A3F4D30
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 18:27:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F29F6185A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 02:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17B1C340EB;
        Wed, 16 Feb 2022 02:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644978436;
        bh=np+uCnwFfWDyCau96UeWshGlW1onNniAXb13fsuT2X0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IE3ToBCSkKCOgQCU6wxQomh3wHXAPY4fWM1Uazxidq8uMiN53+hVJKN+PtYWlUCt4
         dHIEfTzD1sNR5N2upkhE4ufArpgk64VHGiBFQ1b1sLAU92Z6refDdG2GOCwZQHK65K
         /v7ttX1mOZVMcwjp+h/SD0q8L/EpFGFnLXkzzASYx/+9jK9akn7WShZm3e3Ranf++9
         5RrWTRX/zp4rKpaQLEqXSzBO8ZrOaJEw9eJ2H7vW7fKCxg88CiqLUviP5TWfBsU0Og
         ZXK+chD99F3va8scDOieRd/zIfTzJMpjy1Yk+P8rHTbj4yFWHIdNBXEI/j4uHSaMoh
         Dn1gq3YFAj8pg==
Date:   Tue, 15 Feb 2022 18:27:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 02/15] xfs: don't commit the first deferred
 transaction without intents
Message-ID: <20220216022716.GJ8313@magnolia>
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216013713.1191082-3-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 15, 2022 at 06:37:00PM -0700, Allison Henderson wrote:
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
> 
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 6dac8d6b8c21..26680e9f50f5 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -510,9 +510,16 @@ xfs_defer_finish_noroll(
>  		xfs_defer_create_intents(*tp);
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		/*
> +		 * We must ensure the transaction is clean before we try to finish
> +		 * deferred work by committing logged intent items and anything
> +		 * else that dirtied the transaction.

Hm.  I think the comment needs a slight tweak: "...before we try to
finish the next deferred work item by committing..."

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +		 */
> +		if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
> +			error = xfs_defer_trans_roll(tp);
> +			if (error)
> +				goto out_shutdown;
> +		}
>  
>  		/* Possibly relog intent items to keep the log moving. */
>  		error = xfs_defer_relog(tp, &dop_pending);
> -- 
> 2.25.1
> 
