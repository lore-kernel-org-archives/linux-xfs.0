Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CD1C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiF2WBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbiF2WBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:01:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67176275DD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04CC8614D9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6189EC341C8;
        Wed, 29 Jun 2022 22:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656540078;
        bh=RgzdgNXn/3QVwPFA8DYf8Ris/EfIOruiZeIb23DjZhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iiQ73ugaTluR5Y3NbxDtltS167ivWiLVJfZxKwAS6JxgBaXka4YZnbmuvMVOrO6SS
         JSuADbWYFWgT6TwLJyAMPvlYVVbv6uUjHS19M1AZ5KHNYr/RqbnLIv7tZ7nPto20EH
         izLG1BKVuiUm/p4/Eyvghd9jZ3fVoki2vt28Knejy2vIXaaypv7Ax5QrF/ZgIsaIkF
         r8hY4Mfjq6xzPy456qSe9Wd/WkSXybEYIFGE7S2SwuXZOnNdL+yBa+RKNeWHZoF5ek
         8kJ5OnQNlNlYRYD1TbOv+QheICJCpl9lp3zO8jitncWIX2Prk2J0DF20wHnAHvQOKp
         UlocFKNO61oMA==
Date:   Wed, 29 Jun 2022 15:01:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: remove a superflous hash lookup when inserting
 new buffers
Message-ID: <YrzLrflIa91lnWIz@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:40PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently on the slow path insert we repeat the initial hash table
> lookup before we attempt the insert, resulting in a two traversals
> of the hash table to ensure the insert is valid. The rhashtable API
> provides a method for an atomic lookup and insert operation, so we
> can avoid one of the hash table traversals by using this method.
> 
> Adapted from a large patch containing this optimisation by Christoph
> Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

That's pretty neat!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3bcb691c6d95..3461ef3ebc1c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -623,8 +623,15 @@ xfs_buf_find_insert(
>  	}
>  
>  	spin_lock(&pag->pag_buf_lock);
> -	bp = rhashtable_lookup(&pag->pag_buf_hash, cmap, xfs_buf_hash_params);
> +	bp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
> +			&new_bp->b_rhash_head, xfs_buf_hash_params);
> +	if (IS_ERR(bp)) {
> +		error = PTR_ERR(bp);
> +		spin_unlock(&pag->pag_buf_lock);
> +		goto out_free_buf;
> +	}
>  	if (bp) {
> +		/* found an existing buffer */
>  		atomic_inc(&bp->b_hold);
>  		spin_unlock(&pag->pag_buf_lock);
>  		error = xfs_buf_find_lock(bp, flags);
> @@ -635,10 +642,8 @@ xfs_buf_find_insert(
>  		goto out_free_buf;
>  	}
>  
> -	/* The buffer keeps the perag reference until it is freed. */
> +	/* The new buffer keeps the perag reference until it is freed. */
>  	new_bp->b_pag = pag;
> -	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
> -			       xfs_buf_hash_params);
>  	spin_unlock(&pag->pag_buf_lock);
>  	*bpp = new_bp;
>  	return 0;
> -- 
> 2.36.1
> 
