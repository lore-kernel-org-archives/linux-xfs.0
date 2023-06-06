Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079ACC77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 15:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbjFFPRM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 11:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjFFPRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 11:17:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233B18F
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 08:17:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B305162AC1
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 15:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D09BC433EF;
        Tue,  6 Jun 2023 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686064630;
        bh=TTrQjPq7z12yZYiyAOUpDNoHomMLQT+8b+1FmXHIn+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OMs6fQWl4biiRBkGfLn1tQ2XMqFKI4Blu5qZPhKVDMJbCwcrNG4Jkian66d1GgttS
         lK8+hszwBBejOcUZeiqju+FRAenKXYdJ1+UxbBElHu0ZETW6fhJ8WPptUPkZmi1KD9
         k+1YQrnJReauewzBpRS/42fQnI2tDJ2sl8AOXjz72IjEbgw9HrIIyNwi8FBTfd8Ie0
         pr13XA8E1GdVjZlxDtX+Xri9BZLLu2mHJdjXrmEaTL9ZBOJS5VKo81uUSB5Tt3Ytkt
         ZZeuPmbKhmaN+tLONMBZWnjwt55j3gXvULbV0uZcxxuIrghFxujlOa//aMJS0vy/7u
         p82YdoTQszG8g==
Date:   Tue, 6 Jun 2023 08:17:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230606151709.GO1325469@frogsfrogsfrogs>
References: <20230606151122.853315-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606151122.853315-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 05:11:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Comment the code out so kernel test robot stop complaining about it
> every single test build.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Thank you,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/fscounters.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index e382a35e98d88..228efe0c99be8 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -153,6 +153,7 @@ xchk_setup_fscounters(
>  	return xchk_trans_alloc(sc, 0);
>  }
>  
> +#if 0
>  /*
>   * Part 1: Collecting filesystem summary counts.  For each AG, we add its
>   * summary counts (total inodes, free inodes, free data blocks) to an incore
> @@ -349,6 +350,7 @@ xchk_fscount_count_frextents(
>  	return 0;
>  }
>  #endif /* CONFIG_XFS_RT */
> +#endif
>  
>  /*
>   * Part 2: Comparing filesystem summary counters.  All we have to do here is
> @@ -422,7 +424,10 @@ xchk_fscounters(
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xchk_fscounters	*fsc = sc->buf;
>  	int64_t			icount, ifree, fdblocks, frextents;
> +
> +#if 0
>  	int			error;
> +#endif
>  
>  	/* Snapshot the percpu counters. */
>  	icount = percpu_counter_sum(&mp->m_icount);
> @@ -452,6 +457,7 @@ xchk_fscounters(
>  	 */
>  	return 0;
>  
> +#if 0
>  	/*
>  	 * If ifree exceeds icount by more than the minimum variance then
>  	 * something's probably wrong with the counters.
> @@ -489,4 +495,5 @@ xchk_fscounters(
>  		xchk_set_corrupt(sc);
>  
>  	return 0;
> +#endif
>  }
> -- 
> 2.30.2
> 
