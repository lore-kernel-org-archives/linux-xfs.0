Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F3CAC7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 16:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbjCCQTa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjCCQTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 11:19:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E7622A22
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 08:19:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 026DD617BD
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE70C433D2;
        Fri,  3 Mar 2023 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677860347;
        bh=VowmwFYMcv4Mv30nmXctFq2MWF7oJVEtcC7Zx4BUFIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiHiicDC4rTjQvgDHnO8EwVe+uj8COK4nyCpp9Szp8gnUB77Yq7LjDIZhUaG+vpdv
         fyrPCeaNsHBH9aRSb7AzT5dUZIJ/+7jo6APoyfqaWHXBxea4dzpOcai9yPTIOhZxW1
         CNhfR4TeXlGbVVsU/fijnR5cFsELeVoMh87gnowoIms+EdjXR65dWE4wCG0JCyuxBb
         12RqgeYXQEohNVsyhV4VebFo/sQIYxdJNGxmU7J+68K5T7wymP0nLEtm/V4wVklRIq
         A5e52hSd6iLktLOUyLk9jQnFl0nOPGpyC/kOsVcSbNUN+keZzL0g/+lGtBUShdUJUY
         0UY6e0tFLYLQw==
Date:   Fri, 3 Mar 2023 08:19:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: fix off-by-one-block in xfs_discard_folio()
Message-ID: <ZAId+mjNl41tVa9r@magnolia>
References: <20230302231150.GK360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302231150.GK360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 03, 2023 at 10:11:50AM +1100, Dave Chinner wrote:
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

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Version 2
> - update xfs_discard_folio() comment to reflect reality
> - simplify the end offset calculation and comment to reflect the
>   fact the punch range always ends at the end of the supplied folio
>   regardless of the position we start the punch from.
> 
>  fs/xfs/xfs_aops.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 41734202796f..2ef78aa1d3f6 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -449,15 +449,17 @@ xfs_prepare_ioend(
>  }
>  
>  /*
> - * If the page has delalloc blocks on it, we need to punch them out before we
> - * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
> - * inode that can trip up a later direct I/O read operation on the same region.
> + * If the folio has delalloc blocks on it, the caller is asking us to punch them
> + * out. If we don't, we can leave a stale delalloc mapping covered by a clean
> + * page that needs to be dirtied again before the delalloc mapping can be
> + * converted. This stale delalloc mapping can trip up a later direct I/O read
> + * operation on the same region.
>   *
> - * We prevent this by truncating away the delalloc regions on the page.  Because
> + * We prevent this by truncating away the delalloc regions on the folio. Because
>   * they are delalloc, we can do this without needing a transaction. Indeed - if
>   * we get ENOSPC errors, we have to be able to do this truncation without a
> - * transaction as there is no space left for block reservation (typically why we
> - * see a ENOSPC in writeback).
> + * transaction as there is no space left for block reservation (typically why
> + * we see a ENOSPC in writeback).
>   */
>  static void
>  xfs_discard_folio(
> @@ -475,8 +477,13 @@ xfs_discard_folio(
>  		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
>  			folio, ip->i_ino, pos);
>  
> +	/*
> +	 * The end of the punch range is always the offset of the the first
> +	 * byte of the next folio. Hence the end offset is only dependent on the
> +	 * folio itself and not the start offset that is passed in.
> +	 */
>  	error = xfs_bmap_punch_delalloc_range(ip, pos,
> -			round_up(pos, folio_size(folio)));
> +				folio_pos(folio) + folio_size(folio));
>  
>  	if (error && !xfs_is_shutdown(mp))
>  		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
