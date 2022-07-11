Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D8BC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiGKFOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGKFOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:14:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2981C64F3
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Nmu6pdoroF9qK4gxbhIQ0KaTOqeP+ner1cPJghn0uRc=; b=Hpsxn8nbcWlhp84dmTaYcLooHS
        xqycr5UBG7a0wrAyZJSQr4GXOR7MbBr6ngRo7kDEbW3XgPZgODt9HhvE42tdQBlAjus6QmLI0jBVy
        Jpx5+GsLFQc+FRgUyCMZDgOYeP4VcitlM2Er0hfdORNR+vT/TrtBQXAterDzgajLIlejWKLgH8mIc
        G7mptFvgSGd8ooeO8u6wNy7wPGtMTNga4Ufki/iFIYXJUAQPKsYMFvBO/xi8dLzsAc1XCUnGNTIbR
        DEJjctNpDfFZ3wb0+0s+njwUFRJpGhqnEXTQrsw83wSsytfwzwlOVIyfctRT3/u7ldMxucD6N5a+x
        3MUO3v2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlkP-00G4LK-0J; Mon, 11 Jul 2022 05:14:17 +0000
Date:   Sun, 10 Jul 2022 22:14:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Message-ID: <YsuxqAoM0IWD7CaE@infradead.org>
References: <20220707235259.1097443-1-david@fromorbit.com>
 <20220707235259.1097443-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707235259.1097443-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:52:56AM +1000, Dave Chinner wrote:
> index 91dc691f40a8..81ca951b451a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -531,18 +531,16 @@ xfs_buf_map_verify(
>  
>  static int
>  xfs_buf_find_lock(
> -	struct xfs_buftarg	*btp,
>  	struct xfs_buf          *bp,
>  	xfs_buf_flags_t		flags)
>  {
>  	if (!xfs_buf_trylock(bp)) {
>  		if (flags & XBF_TRYLOCK) {
> -			xfs_buf_rele(bp);
> -			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
> +			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
>  			return -EAGAIN;
>  		}
>  		xfs_buf_lock(bp);
> -		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
> +		XFS_STATS_INC(bp->b_mount, xb_get_locked_waited);
>  	}
>  
>  	/*

Not doing this to start with in the previous patch still feels
rather odd.
