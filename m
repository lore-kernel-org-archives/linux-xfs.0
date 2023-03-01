Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD28C64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 00:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCAArF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 19:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCAArE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 19:47:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F98CA0D
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 16:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2949560FD9
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 00:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F91AC433EF;
        Wed,  1 Mar 2023 00:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677631622;
        bh=RApj/CrdEjmck6ZEKoQ0YWrOzdvbkH1MNqdsXvu7t4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g05DiMjKxtzyPC5K8p2hCEnpSzCHLSYiWJjHoe47YTSNYLEemmHUobL3qadmEuwrY
         7surWnT7QxxHyRjLM+QpPNw/N7L8vMfH4SbWe66mjLpIde+yPKVY2OC8+61tCMxSy/
         Oi3bKsiI6S23e20U+y5tuNFCbFi6Qnhbf3qdIfNOdZjt2JG7iBf6wzZN4Szrbg76mA
         V0m/YU8r5Yp/y8UiM8wJT3i+XWYgXdgiw3ilI9RKDAzopu6W/FRtrLppJ2Gu3V1JHF
         gmtAvKDjqjV4JkRwktByEemVQ01P5lHXjOlE6not2xjshyj8dQLzyDvmZ014ufRpIu
         dr5nSXYBa5DUA==
Date:   Tue, 28 Feb 2023 16:47:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <Y/6ghfyWXLuCefkn@magnolia>
References: <20230301001706.1315973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301001706.1315973-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 11:17:06AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent writeback corruption fixes changed the code in
> xfs_discard_folio() to calculate a byte range to for punching
> delalloc extents. A mistake was made in using round_up(pos) for the
> end offset, because when pos points at the first byte of a block, it
> does not get rounded up to point to the end byte of the block. hence
> the punch range is short, and this leads to unexpected behaviour in
> certain cases in xfs_bmap_punch_delalloc_range.
> 
> e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
> there is no previous extent and it rounds up the punch to the end of
> the delalloc extent it found at offset 0, not the end of the range
> given to xfs_bmap_punch_delalloc_range().
> 
> Fix this by handling the zero block offset case correctly.
> 
> Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
> Found-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 41734202796f..429f63cfd7d4 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -466,6 +466,7 @@ xfs_discard_folio(
>  {
>  	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
>  	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_off_t		end_off;
>  	int			error;
>  
>  	if (xfs_is_shutdown(mp))
> @@ -475,8 +476,17 @@ xfs_discard_folio(
>  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
>  			folio, ip->i_ino, pos);
>  
> -	error = xfs_bmap_punch_delalloc_range(ip, pos,
> -			round_up(pos, folio_size(folio)));
> +	/*
> +	 * Need to be careful with the case where the pos passed in points to
> +	 * the first byte of the folio - rounding up won't change the value,
> +	 * but in all cases here we need to end offset to point to the start
> +	 * of the next folio.
> +	 */
> +	if (pos == folio_pos(folio))
> +		end_off = pos + folio_size(folio);
> +	else
> +		end_off = round_up(pos, folio_size(folio));

Can this construct be simplified to:

	end_off = round_up(pos + 1, folio_size(folio));

If pos is the first byte of the folio, it'll round end_off to the start
of the next folio.  If pos is (somehow) the last byte of the folio, the
first argument to round_up is already the first byte of the next folio,
and rounding won't change it.

I'll run this through fstests since it's getting late already.

--D

> +	error = xfs_bmap_punch_delalloc_range(ip, pos, end_off);
>  
>  	if (error && !xfs_is_shutdown(mp))
>  		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
> -- 
> 2.39.2
> 
