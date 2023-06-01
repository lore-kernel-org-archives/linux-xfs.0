Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A97C77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 14:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjFAOvE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 10:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233768AbjFAOvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 10:51:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1116C132
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 07:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7865D645AC
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D730DC433D2;
        Thu,  1 Jun 2023 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685631061;
        bh=XLmIEbwd/YjWAYeAECwuwTdSzCIu352a3tRWwoq+x2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDZgwfCSB9CtfRiGGLQZgGW6Ui0vZx2aDQPX+OcNsIy2g9xbhvwWc5MIA6rTKHfeP
         bb+GNqpfJRpYxNQ2FAWurRE/9NVOKqvzDVHF1AkfDvwTXuY8UvPkb2fsEUYuvwfgRg
         LRHQeFMgQa9SI4yFaYiUEqGtvcSck0/UKvrNkp1L3C/G1Gx80wQxbMQiyb4jXI60Lp
         KC1MD3WFWzJ/ueUWi9k90pZK+dj30WH4lrhxURNypZkGqGo9eoNEPzTCpGsP1cZuVt
         BNVfZanL3Z45FUxo46kw2ij7oFPUOHdg5RJmU62yw1dmD5Wpj/8KE8RyTwrvpyUZJE
         eoRkzSBIoWT5A==
Date:   Thu, 1 Jun 2023 07:51:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: validity check agbnos on the AGFL
Message-ID: <20230601145101.GD16865@frogsfrogsfrogs>
References: <20230529000825.2325477-1-david@fromorbit.com>
 <20230529000825.2325477-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529000825.2325477-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 29, 2023 at 10:08:24AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the agfl or the indexing in the AGF has been corrupted, getting a
> block form the AGFL could return an invalid block number. If this
> happens, bad things happen. Check the agbno we pull off the AGFL
> and return -EFSCORRUPTED if we find somethign bad.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This looks like a good addition to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index fd3293a8c659..643d17877832 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2780,6 +2780,9 @@ xfs_alloc_get_freelist(
>  	 */
>  	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
>  	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
> +	if (XFS_IS_CORRUPT(tp->t_mountp, !xfs_verify_agbno(pag, bno)))
> +		return -EFSCORRUPTED;
> +
>  	be32_add_cpu(&agf->agf_flfirst, 1);
>  	xfs_trans_brelse(tp, agflbp);
>  	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
> -- 
> 2.40.1
> 
