Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A8AC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiF2WAc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiF2WA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4805D22534
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93066154F
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E22C34114;
        Wed, 29 Jun 2022 22:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656540028;
        bh=OOH/Q3vzUKsCuxZQcluqFkgs6v1Y0jINFo/pNPE4x4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCeXS5AuyRNEp8idRMw0xfrRtCE5zvD3iq4/zBpKLEr2/8GYQZAF2X2VvjqEAD5jJ
         y4dA172oapVArUb/xy2fRIqpUsvhp7ue4YRJR7P05gOD7EU1jmDEymjMyrtrCKQiCy
         jgCwGXIqi7f0acdiTTvmf+Ou5o4LoV23PLItj70Y0dpNCBMi/95a/4SEhTeqO+FF2t
         24DVHpS1zriWkMXBS7WV+GZvKEM00SBDgfQCAUCclAlP9lNq1QcTv4Q2AosNDBLjAP
         sX43LNmrYbPcuu1xEvdirEgrZMTDJ98qwZxgqbES1vc5NYmwA0TWUOXsUSkVJvektA
         /H201f8JGXuQA==
Date:   Wed, 29 Jun 2022 15:00:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: reduce the number of atomic when locking a
 buffer after lookup
Message-ID: <YrzLe3smFrdutwHA@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Avoid an extra atomic operation in the non-trylock case by only
> doing a trylock if the XBF_TRYLOCK flag is set. This follows the
> pattern in the IO path with NOWAIT semantics where the
> "trylock-fail-lock" path showed 5-10% reduced throughput compared to
> just using single lock call when not under NOWAIT conditions. So
> make that same change here, too.
> 
> See commit 942491c9e6d6 ("xfs: fix AIM7 regression") for details.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [hch: split from a larger patch]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 469e84fe21aa..3bcb691c6d95 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -534,11 +534,12 @@ xfs_buf_find_lock(
>  	struct xfs_buf          *bp,
>  	xfs_buf_flags_t		flags)
>  {
> -	if (!xfs_buf_trylock(bp)) {
> -		if (flags & XBF_TRYLOCK) {
> +	if (flags & XBF_TRYLOCK) {
> +		if (!xfs_buf_trylock(bp)) {
>  			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
>  			return -EAGAIN;
>  		}
> +	} else {
>  		xfs_buf_lock(bp);
>  		XFS_STATS_INC(bp->b_mount, xb_get_locked_waited);
>  	}
> -- 
> 2.36.1
> 
