Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE01C77B61
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Apr 2023 15:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjDYPUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 11:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjDYPUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2023 11:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92FF127
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2023 08:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5246162F5B
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2023 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B0FC433D2;
        Tue, 25 Apr 2023 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682436052;
        bh=/O5CVvpipHABzSEaoeL0VKSl7oI1/u7Q8VdDpsBuf7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gOAgBcH97jbWkaEA+QcLukC9AcP2oni8jPeMmWHYWI771VDhzfgM+KDFmJHjd+Wm2
         cHbSdQXymwjj3s2r/v39TZwMqM3htz8mifuu1AX8jluT2dQCiSPDLcBiqwVeZr1/ng
         4vDZ3hX4NGgHyMNSPOyGWrljI4PW3kJ/IIFuEImHAvuXI5tRZ4LmD0c45E7Shhua5g
         ZmapkvlEADJQ8FKmqPCVY51Rldtm5OUfE7lrFyfVG7h4kFrLHckWHrj8ZgaDQcnv+v
         OJCfvLQ1gR/SraqwaBWtddrDOvBmDlBdx3OCl6Xodl7vIyuOtbbgfHe7LQg4q3xYup
         UZsBeETkZqcuw==
Date:   Tue, 25 Apr 2023 08:20:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: fix livelock in delayed allocation at ENOSPC
Message-ID: <20230425152052.GT360889@frogsfrogsfrogs>
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

Insofar as this has revealed a whole ton of *more* problems in mkfs,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Specifically: if I set su=128k,sw=4, some tests will try to format a
512M filesystem.  This results in an 8-AG filesystem with a log that
fills up almost but not all of an entire AG.  The AG then ends up with
an empty bnobt and an empty AGFL, and 25 missing blocks...

...oh and the new test vms that run this config failed to finish for
some reason.  Sigh.

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
