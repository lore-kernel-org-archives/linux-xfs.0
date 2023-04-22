Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA093C7618E
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Apr 2023 03:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDVDxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 23:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDVDxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 23:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADF019AD
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 20:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4914761CEC
        for <linux-xfs@vger.kernel.org>; Sat, 22 Apr 2023 03:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E59C433EF;
        Sat, 22 Apr 2023 03:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682135581;
        bh=IkfFmbgaOdMGab3mOFIOhHWVekWLSF5B03ja2Stoza8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hW5yNQLU2pKJqdADA7yJ4kaXRDUgttNh3qoQ8s4mY4V5NpbMokA4MEN8Y50br/2Is
         wF4JEjIbmsmO01QyWYEMytkfEEPD5YDkesB+UQsaiFEGpckA1hGmAxb1tgND/ONHL9
         hsdflwILqXH2Ksb20Ph/nK/b9I9YI8nUsxgavr1gxASvfoEOAAlAi+jjHjtuh9i621
         Lg0/F2MoS9sw5sBFXTiuOr+DfVLO2YXUYG44ShLOu9cj29RmPod5MKLVlNPVWdDu54
         o7COLC3xfzCGUOtM0nt72pBPNkjpNBhVoU7kPUhcpKRGyIyGfn/qdWcjA33bb8G3Tg
         GWN1f3a5044CQ==
Date:   Fri, 21 Apr 2023 20:53:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230422035300.GL360889@frogsfrogsfrogs>
References: <20230421222440.2722482-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421222440.2722482-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 22, 2023 at 08:24:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On a filesystem with a non-zero stripe unit and a large sequential
> write, delayed allocation will set a minimum allocation length of
> the stripe unit. If allocation fails because there are no extents
> long enough for an aligned minlen allocation, it is supposed to
> fall back to unaligned allocation which allows single block extents
> to be allocated.
> 
> When the allocator code was rewritting in the 6.3 cycle, this
> fallback was broken - the old code used args->fsbno as the both the
> allocation target and the allocation result, the new code passes the
> target as a separate parameter. The conversion didn't handle the
> aligned->unaligned fallback path correctly - it reset args->fsbno to
> the target fsbno on failure which broke allocation failure detection
> in the high level code and so it never fell back to unaligned
> allocations.
> 
> This resulted in a loop in writeback trying to allocate an aligned
> block, getting a false positive success, trying to insert the result
> in the BMBT. This did nothing because the extent already was in the
> BMBT (merge results in an unchanged extent) and so it returned the
> prior extent to the conversion code as the current iomap.
> 
> Because the iomap returned didn't cover the offset we tried to map,
> xfs_convert_blocks() then retries the allocation, which fails in the
> same way and now we have a livelock.
> 
> Reported-by: Brian Foster <bfoster@redhat.com>
> Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Will give this one a spin through the test system over the weekend.

In the meantime, can one of you come up with a reproducer?  From the
description, it doesn't sound like that should be too hard -- mount with
no stripe unit set, fragment the free space, mount with a stripe unit
set, then run the fs out of space?

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1a4e446194dd..b512de0540d5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3540,7 +3540,6 @@ xfs_bmap_btalloc_at_eof(
>  	 * original non-aligned state so the caller can proceed on allocation
>  	 * failure as if this function was never called.
>  	 */
> -	args->fsbno = ap->blkno;
>  	args->alignment = 1;
>  	return 0;
>  }
> -- 
> 2.39.2
> 
