Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D5CCD6106
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 16:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377048AbjJIQ16 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376275AbjJIQ16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 12:27:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4E399
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 09:27:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAC5C433C8;
        Mon,  9 Oct 2023 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696868876;
        bh=ZsXd8neMtbd3DeO0h/HuJ3NrPjaYW8GODhVU2Ubz7SA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bPVH3ZUpoq8rc2aSoDOpYPA7bgsdFtBgeP7E54w9uAIMYBdp1LX1ToaNkzFl5Mjl2
         0WFZXBxgpYMdgjwR//daB0sCe5sl6YFIWTfnk1+eTYe2XCD4E7VoyTwrIRQlgeHAqZ
         AB6mRTFFDIzQgszvPN1ScHdt+om/EujA35ycvqWogogCd32vc5ye829Un3tfjXQy6n
         bNI/sd+mIVk1HIhOhazFHGSRHqUdbgtFudKM6vZibvt1h0NgiWQOeiHMG6radOf994
         X19lvqngmVtmrooXbt4jdeSJ7yZsJcXqM7QHI4YyLIXiD1/TSJLdwSJqvElWKDkSWD
         zPEppRaZbqvTQ==
Date:   Mon, 9 Oct 2023 09:27:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: handle nimaps=0 from xfs_bmapi_write in
 xfs_alloc_file_space
Message-ID: <20231009162756.GB21298@frogsfrogsfrogs>
References: <20231009103020.230639-1-hch@lst.de>
 <20231009103020.230639-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009103020.230639-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2023 at 12:30:20PM +0200, Christoph Hellwig wrote:
> If xfs_bmapi_write finds a delalloc extent at the requested range, it
> tries to convert the entire delalloc extent to a real allocation.
> But if the allocator then can't find an AG with enough space to at least
> cover the start block of the requested range, xfs_bmapi_write will return
> 0 but leave *nimaps set to 0.
> In that case we simply need to keep looping with the same startoffset_fsb.
> 
> Note that this could affect any caller of xfs_bmapi_write that covers
> an existing delayed allocation.  As far as I can tell we do not have
> any other such caller, though - the regular writeback path uses
> xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
> and direct I/O invalidates the page cache first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d85580b101ad8a..556f57f757f33e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -814,12 +814,10 @@ xfs_alloc_file_space(
>  {
>  	xfs_mount_t		*mp = ip->i_mount;
>  	xfs_off_t		count;
> -	xfs_filblks_t		allocated_fsb;
>  	xfs_filblks_t		allocatesize_fsb;
>  	xfs_extlen_t		extsz, temp;
>  	xfs_fileoff_t		startoffset_fsb;
>  	xfs_fileoff_t		endoffset_fsb;
> -	int			nimaps;
>  	int			rt;
>  	xfs_trans_t		*tp;
>  	xfs_bmbt_irec_t		imaps[1], *imapp;
> @@ -842,7 +840,6 @@ xfs_alloc_file_space(
>  
>  	count = len;
>  	imapp = &imaps[0];
> -	nimaps = 1;
>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
>  	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
>  	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
> @@ -853,6 +850,7 @@ xfs_alloc_file_space(
>  	while (allocatesize_fsb && !error) {
>  		xfs_fileoff_t	s, e;
>  		unsigned int	dblocks, rblocks, resblks;
> +		int		nimaps = 1;
>  
>  		/*
>  		 * Determine space reservations for data/realtime.
> @@ -918,15 +916,20 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		allocated_fsb = imapp->br_blockcount;
> -
> -		if (nimaps == 0) {
> -			error = -ENOSPC;
> -			break;
> +		/*
> +		 * If xfs_bmapi_write finds a delalloc extent at the requested
> +		 * range, it tries to convert the entire delalloc extent to a
> +		 * real allocation.
> +		 * But if the allocator then can't find an AG with enough space
> +		 * to at least cover the start block of the requested range,

Hmm.  Given that you said this was done in the context of delalloc on
the realtime volume, I don't think there are AGs in play here?  Unless
the AG actually ran out of space allocating a bmbt block?

My hunch here is that free space on the rt volume is fragmented, but
there were still enough free rtextents to create a large delalloc
reservation.  Conversion of the reservation to an unwritten extent
managed to map one free rtextent into the file, but not enough to
convert the file mapping all the way to @startoffset_fsb.  Hence the
bmapi_write call succeeds, but returns @nmaps == 0.

If that's true, I suggest changing the second sentence of the comment to
read:

"If the allocator cannot find a single free extent large enough to
cover the start block of the requested range, xfs_bmapi_write will
return 0 but leave *nimaps set to 0."

I agree with the fix -- calling bmapi_write again with the same
startoffset_fsb will return the mapping of the space that /did/ get
allocated, which enables us to push @startoffset_fsb forward.

--D

> +		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
> +		 * In that case we simply need to keep looping with the same
> +		 * startoffset_fsb.
> +		 */
> +		if (nimaps) {
> +			startoffset_fsb += imapp->br_blockcount;
> +			allocatesize_fsb -= imapp->br_blockcount;
>  		}
> -
> -		startoffset_fsb += allocated_fsb;
> -		allocatesize_fsb -= allocated_fsb;
>  	}
>  
>  	return error;
> -- 
> 2.39.2
> 
