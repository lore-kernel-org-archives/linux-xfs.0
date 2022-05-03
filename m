Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506B9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiECW7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiECW7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B47E41630
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:56:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F19B82216
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB808C385A4;
        Tue,  3 May 2022 22:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651618558;
        bh=j7Phmm5pFHtS8CBl6QpROxHHtZsRaj7nykCRgD9edH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwCl7g+2DQBD7nE99dxr+pEthSotB5TtE4quFC9KD818DL3ZQgfDnPp/CN0GacGij
         2yjb47bIoIfe0qG+0arSw84QCJa7iRglHRoAIMmTZJ/tjQfTnxHeeB9jz/IeFBfoPS
         mKWyKlSBX6eUld340QRVBswMm9VA3wG3p3Oms6PkjYiGhW7DL5yElNa00KIHALeJPl
         kkKzNPi7OC/zXNiLrIVn2hYa1+jRvdruCDoHE26TjAtDIVU8ik5CHkjNnJ7kdux1sf
         kyU/7seWrDj0K/p/xVFWYvQjrRn5v7sJOT3r6k6HDeVGl8fafNOfgyKRofyUQxa+O1
         2wWw1MT+xaBIg==
Date:   Tue, 3 May 2022 15:55:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: set XFS_FEAT_NLINK correctly
Message-ID: <20220503225558.GH8265@magnolia>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 06:20:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> While xfs_has_nlink() is not used in kernel, it is used in userspace
> (e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
> in xfs_sb_version_to_features().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Oops
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cf9e5b9374c1..ec6eec5c0e02 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -70,6 +70,8 @@ xfs_sb_version_to_features(
>  	/* optional V4 features */
>  	if (sbp->sb_rblocks > 0)
>  		features |= XFS_FEAT_REALTIME;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
> +		features |= XFS_FEAT_NLINK;
>  	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
>  		features |= XFS_FEAT_ATTR;
>  	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
> -- 
> 2.35.1
> 
