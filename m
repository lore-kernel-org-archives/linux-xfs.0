Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607E7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 03:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiKODuB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiKODt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 22:49:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAEB1581D
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:49:58 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g62so12940705pfb.10
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqkfqrmh9H+YNCT7Z6mHQOBds+Ml41nIOlGrl5BC9Ok=;
        b=wZN+Aht1pZ9PTAJwkbdkTx2P1VFwBg2SVBTJqKmyZnuovzdD30AikAb4usvboR7sHj
         pXQrtDY9UmQ13vWIVYSIADPweQRhKUBHTn31diRovd2umkfrc4yIApvZHqI8VOTN33fo
         gEiZp3cdxbsOmDcLbepDlJg7wrbxRbEteENh38XodoJNXjVh2/Le2kucGHfNuZuvgNzz
         BbQ4hZDZgTSWUkpe9uVOf5Tx4IDsck7yOceTGU8d7bNd9FuhOArb687iLwsMHWG3FTMz
         ce5Qc4myJjBluNydnA0H2XxlyMCoWyBDK6x+y+DetfXVFKRblD6teYu5G9oUZR1G42b3
         95Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vqkfqrmh9H+YNCT7Z6mHQOBds+Ml41nIOlGrl5BC9Ok=;
        b=s4tVi4pDzG3+MFZSY/NZoZTDloooaOHt4mxaHl4xmOEGQEvU0QR6KST05QUouKtxlr
         paCFA2hLNknPO3g+5Sj97c/1Xu5z+JrgQ0+YhsU90k06pP3S0/gJdZAOWLN/1J7EYvvG
         9oA5ScVAWsOh1tLd34ZkOAh1BVGW4de0GZj+CNMwLBgOGgCGsp1h7TKAZHrHA9phHAuG
         4HCBKvNN4kglJQmI+JGe21wunwEg0HkgkrLEoqLHIEU/p193lurtzpM23lj1s4I/V17/
         B2FpCf63E92jIuGAXh0lgh67LxJCbPk6XudECotB0W+vZAIocpneUclSVcJeJKCYdQiL
         bndw==
X-Gm-Message-State: ANoB5pkCxxp2HJG4qg5cZJ/RSY0KWnZH3dR9VnzwUjgQgYV/Hmvr+9O8
        /7s/rz7gBPo6NEdmFEyGpofMeA==
X-Google-Smtp-Source: AA0mqf7CzSWY09YACLo23KIhlmHwK1ZOHmbNE9ZGqGp5TgE/3JfQ3RKTqupdrXm33TbLxSxp20qcYw==
X-Received: by 2002:a62:c546:0:b0:56b:d03d:fdb4 with SMTP id j67-20020a62c546000000b0056bd03dfdb4mr16291019pfg.79.1668484198087;
        Mon, 14 Nov 2022 19:49:58 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id h3-20020a17090a3d0300b0020a28156e11sm10484661pjc.26.2022.11.14.19.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 19:49:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oumxO-00EMV9-GS; Tue, 15 Nov 2022 14:49:54 +1100
Date:   Tue, 15 Nov 2022 14:49:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an inode lookup race in xchk_get_inode
Message-ID: <20221115034954.GX3600936@dread.disaster.area>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482957.1084685.13676900912332698227.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473482957.1084685.13676900912332698227.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit d658e, we tried to improve the robustnes of xchk_get_inode in
> the face of EINVAL returns from iget by calling xfs_imap to see if the
> inobt itself thinks that the inode is allocated.  Unfortunately, that
> commit didn't consider the possibility that the inode gets allocated
> after iget but before imap.  In this case, the imap call will succeed,
> but we turn that into a corruption error and tell userspace the inode is
> corrupt.
> 
> Avoid this false corruption report by grabbing the AGI header and
> retrying the iget before calling imap.  If the iget succeeds, we can
> proceed with the usual scrub-by-handle code.  Fix all the incorrect
> comments too, since unreadable/corrupt inodes no longer result in EINVAL
> returns.
> 
> Fixes: d658e72b4a09 ("xfs: distinguish between corrupt inode and invalid inum in xfs_scrub_get_inode")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

OK.

> ---
>  fs/xfs/scrub/common.c |  203 ++++++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/scrub/common.h |    4 +
>  fs/xfs/xfs_icache.c   |    3 -
>  fs/xfs/xfs_icache.h   |    1 
>  4 files changed, 172 insertions(+), 39 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 42a25488bd25..9a811c5fa8f7 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -635,6 +635,14 @@ xchk_ag_init(
>  
>  /* Per-scrubber setup functions */
>  
> +void
> +xchk_trans_cancel(
> +	struct xfs_scrub	*sc)
> +{
> +	xfs_trans_cancel(sc->tp);
> +	sc->tp = NULL;
> +}
> +
>  /*
>   * Grab an empty transaction so that we can re-grab locked buffers if
>   * one of our btrees turns out to be cyclic.
> @@ -720,6 +728,80 @@ xchk_iget(
>  	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
>  }
>  
> +/*
> + * Try to grab an inode.  If we can't, return the AGI buffer so that the caller
> + * can single-step the loading process to see where things went wrong.

"Try to grab an inode in a manner that avoids races with physical inode
allocation. If we can't, return the locked AGI buffer so that the
caller can single-step the loading process to see where things went
wrong."

> + *
> + * If the iget succeeds, return 0, a NULL AGI, and the inode.
> + * If the iget fails, return the error, the AGI, and a NULL inode.  This can

"... the locked AGI, ...."

> + * include -EINVAL and -ENOENT for invalid inode numbers or inodes that are no
> + * longer allocated; or any other corruption or runtime error.
> + * If the AGI read fails, return the error, a NULL AGI, and NULL inode.
> + * If a fatal signal is pending, return -EINTR, a NULL AGI, and a NULL inode.
> + */
> +int
> +xchk_iget_agi(
> +	struct xfs_scrub	*sc,
> +	xfs_ino_t		inum,
> +	struct xfs_buf		**agi_bpp,
> +	struct xfs_inode	**ipp)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_trans	*tp = sc->tp;
> +	struct xfs_perag	*pag;
> +	int			error;
> +
> +again:
> +	*agi_bpp = NULL;
> +	*ipp = NULL;
> +	error = 0;
> +
> +	if (xchk_should_terminate(sc, &error))
> +		return error;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
> +	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
> +	xfs_perag_put(pag);
> +	if (error)
> +		return error;
> +
> +	error = xfs_iget(mp, tp, inum,
> +			XFS_IGET_NOWAIT | XFS_IGET_UNTRUSTED, 0, ipp);

OK, IGET_NOWAIT is new....

> +#define XFS_IGET_NOWAIT		0x10	/* return EAGAIN instead of blocking */

But it doesn't prevent blocking. XFS_IGET_UNTRUSTED means we do a
inobt record lookup (btree buffer locking and IO that can block) as
well as reading the inode cluster from disk if it's not already in
cache. Hence this isn't what I'd call a "non-blocking" or "no wait"
operation. 

AFAICT, what is needed here is avoiding the -retry mechanism- of the
lookup, not "non blocking/no wait" semantics. i.e. this seems
reasonable to get an -EAGAIN error instead of delaying and trying
again if we are using XFS_IGET_NORETRY semantics....

> +	if (error == -EAGAIN) {
> +		/*
> +		 * Cached inode awaiting inactivation.  Drop the AGI buffer in
> +		 * case the inactivation worker is now waiting for it, and try
> +		 * the iget again.
> +		 */

That's not the only reason xfs_iget() could return -EAGAIN,
right? radix_tree_preload() failing can cause -EAGAIN to be returned
from xfs_iget_cache_miss(), as can an instantiation race inserting
the new inode into the radix tree. The cache hit path has a bunch
more cases, too. Perhaps:

		/*
		 * The inode may be in core but temporarily
		 * unavailable and may require the AGI buffer before
		 * it can be returned. Drop the AGI buffer and retry
		 * the lookup.
		 */

> +		xfs_trans_brelse(tp, *agi_bpp);
> +		delay(1);
> +		goto again;
> +	}
> +	if (error == 0) {
> +		/* We got the inode, so we can release the AGI. */
> +		ASSERT(*ipp != NULL);
> +		xfs_trans_brelse(tp, *agi_bpp);
> +		*agi_bpp = NULL;
> +	}
> +
> +	return error;

That's better written as:

	if (error)
		return error;

	/* We got the inode, so we can release the AGI. */
	ASSERT(*ipp != NULL);
	xfs_trans_brelse(tp, *agi_bpp);
	*agi_bpp = NULL;
	return 0;

Other than that, the code makes sense.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
