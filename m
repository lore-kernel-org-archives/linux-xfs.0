Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86780C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiECWor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243801AbiECWop (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:44:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4683A42A26
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCEACB82220
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB93C385C1;
        Tue,  3 May 2022 22:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651617662;
        bh=d3yaY5XCt01E7o6lzFYBKzZD6PaVX5RWSni7Z604V5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aKo3QTS4NYaexFAv6cygqEDqT0ploi+bbzpztyT9GnmWDveueLZyoS5huLaEFHGfO
         hc0vR1IHHzHwGW2mXX4lQ4Ja8J8U42EOfStvGT9+TaZFe4X3WpZfQk5zw40OrAT4a0
         YtL37TDCgITY6dDszui9bIeCm3+w8dM/Od4A+FHBT215qFtOj/LqsdUnPjC8Vy2wqQ
         4/VR+VIxAsyVMvHJk8Yy/wQ8ZzluQ7LvF1ArCY2Nxh6dkDFekcHWez+gWCVdApEQ9Y
         S6HhQ2kgv8+lfSusp9AUGyVNvk5fB1AkwcygDhvD6z3MPLJiJvdCcvTg/MtRU7okFf
         cDuSShTWI41zQ==
Date:   Tue, 3 May 2022 15:41:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: zero inode fork buffer at allocation
Message-ID: <20220503224101.GB8265@magnolia>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221728.185449-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 08:17:19AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we first allocate or resize an inline inode fork, we round up
> the allocation to 4 byte alingment to make journal alignment
> constraints. We don't clear the unused bytes, so we can copy up to
> three uninitialised bytes into the journal. Zero those bytes so we
> only ever copy zeros into the journal.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Yup.  Thanks for the cleanup.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9aee4a1e2fe9..a15ff38c3d41 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -50,8 +50,13 @@ xfs_init_local_fork(
>  		mem_size++;
>  
>  	if (size) {
> +		/*
> +		 * As we round up the allocation here, we need to ensure the
> +		 * bytes we don't copy data into are zeroed because the log
> +		 * vectors still copy them into the journal.
> +		 */
>  		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -500,10 +505,11 @@ xfs_idata_realloc(
>  	/*
>  	 * For inline data, the underlying buffer must be a multiple of 4 bytes
>  	 * in size so that it can be logged and stay on word boundaries.
> -	 * We enforce that here.
> +	 * We enforce that here, and use __GFP_ZERO to ensure that size
> +	 * extensions always zero the unused roundup area.
>  	 */
>  	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
> -				      GFP_NOFS | __GFP_NOFAIL);
> +				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
>  	ifp->if_bytes = new_size;
>  }
>  
> -- 
> 2.35.1
> 
