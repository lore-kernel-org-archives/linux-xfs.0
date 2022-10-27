Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167C7FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 20:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236747AbiJ0U6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiJ0U5x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 16:57:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967AA4A138
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 13:50:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pb15so2760873pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 13:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfKqjy1oX1Nlx2IkjFAr3/xvhLFv2pXP2LmCaaz+Abs=;
        b=1zoFoamToOj2zbOEn94gpt7m2onEmZ4SXjB3F8DNsIPRbkQPqANHd0tcxf6vGizWGF
         mwxku74CL5JsiO06SVBkVBvYHlpKzFNnmch6LCg+8m/7Y/uZF6Dwkfr4U6Lwz5KeVwXg
         a8+ljmHG52xe2BRLsVlv8OZHZzmbNdb2sGMMmMhVGX1lB2OrqyFK3JPiIJ5t5e5iklAk
         xb9EKuBMaL98OD3IxH3bZFGuj71YIxizOOMl81OXu8tv9jp74muTqz875bVi/ZQDAUZV
         r82ZrFBKHg8QVGUmGXamMlqmlsZdu2EkzChUJP8QtDkOSZJhWHX0fAPa85fHEwJ6MYrS
         dRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfKqjy1oX1Nlx2IkjFAr3/xvhLFv2pXP2LmCaaz+Abs=;
        b=FcjXz6uRsyGVuyubYY6M4ua0a/ffjYuIEfuDpB+Wztji4yq7gP3eEuLeQg/rdtzBue
         bJzeCXCoxJmpTQiCeJsdPZ83r0LwHwkgrP1f6APd2d96aZSyudoo9/ExBmFVDsOJI1eN
         PQ59gvrL4JUJ7W/xP4HTG34fRh5Lu7jzcT10ca51Kp1MBxB1GbZzXXwhjOn/tA5ueRf0
         xNCxmOPj+wpWAOEP9sppZs8r2ixa/QcH3FjBg3BVl/ClWX9mjfoTjaWUSqzrNZ9Fu8aX
         axBh0zMGerUFCQBhCVqVsvF+89x7QpsF17LqQJugTHK8MNPtj6O9vpOh5mJ/iSpo7gEj
         wUQA==
X-Gm-Message-State: ACrzQf3nXJ8iWhpFn7yvht113ht3JrRkNlyHiqHjMVpx6S93Szk2VP4W
        0afENs8K6GNwz8rf99UVYROMkGvuwOxVkQ==
X-Google-Smtp-Source: AMsMyM7BvXxiqYCQjBSAjqEs73etMJWX0V4xsn5MwGfbdwVAk5Z+pz+lo4v+YMtMAcnZ9MzQEeNSfw==
X-Received: by 2002:a05:6a00:ac6:b0:530:3197:48b6 with SMTP id c6-20020a056a000ac600b00530319748b6mr50324120pfl.80.1666903800699;
        Thu, 27 Oct 2022 13:50:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id y27-20020a63181b000000b0041cd5ddde6fsm1416389pgl.76.2022.10.27.13.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:50:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oo9p7-0079G5-Tb; Fri, 28 Oct 2022 07:49:57 +1100
Date:   Fri, 28 Oct 2022 07:49:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: check deferred refcount op continuation
 parameters
Message-ID: <20221027204957.GR3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689085464.3788582.2756559047908250104.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689085464.3788582.2756559047908250104.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:14AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're in the middle of a deferred refcount operation and decide to
> roll the transaction to avoid overflowing the transaction space, we need
> to check the new agbno/aglen parameters that we're about to record in
> the new intent.  Specifically, we need to check that the new extent is
> completely within the filesystem, and that continuation does not put us
> into a different AG.
> 
> If the keys of a node block are wrong, the lookup to resume an
> xfs_refcount_adjust_extents operation can put us into the wrong record
> block.  If this happens, we might not find that we run out of aglen at
> an exact record boundary, which will cause the loop control to do the
> wrong thing.
> 
> The previous patch should take care of that problem, but let's add this
> extra sanity check to stop corruption problems sooner than later.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   48 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 46 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 831353ba96dc..c6aa832a8713 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1138,6 +1138,44 @@ xfs_refcount_finish_one_cleanup(
>  		xfs_trans_brelse(tp, agbp);
>  }
>  
> +/*
> + * Set up a continuation a deferred refcount operation by updating the intent.
> + * Checks to make sure we're not going to run off the end of the AG.
> + */
> +static inline int
> +xfs_refcount_continue_op(
> +	struct xfs_btree_cur		*cur,
> +	xfs_fsblock_t			startblock,
> +	xfs_agblock_t			new_agbno,
> +	xfs_extlen_t			new_len,
> +	xfs_fsblock_t			*fsbp)
> +{
> +	struct xfs_mount		*mp = cur->bc_mp;
> +	struct xfs_perag		*pag = cur->bc_ag.pag;
> +	xfs_fsblock_t			new_fsbno;
> +	xfs_agnumber_t			old_agno;
> +
> +	old_agno = XFS_FSB_TO_AGNO(mp, startblock);
> +	new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
> +
> +	/*
> +	 * If we don't have any work left to do, then there's no need
> +	 * to perform the validation of the new parameters.
> +	 */
> +	if (!new_len)
> +		goto done;

Shouldn't we be validating new_fsbno rather than just returning
whatever we calculated here?

> +	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, new_fsbno, new_len)))
> +		return -EFSCORRUPTED;
> +
> +	if (XFS_IS_CORRUPT(mp, old_agno != XFS_FSB_TO_AGNO(mp, new_fsbno)))
> +		return -EFSCORRUPTED;

We already know what agno new_fsbno sits in - we calculated it
directly from pag->pag_agno above, so this can jsut check against
pag->pag_agno directly, right?

i.e.

	if (XFS_IS_CORRUPT(mp,
			XFS_FSB_TO_AGNO(mp, startblock) != pag->pag_agno))
		return -EFSCORRUPTED;

and we don't need the local variable for it....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
