Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A128CD98F3
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 05:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjJKFs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 01:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjJKFsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 01:48:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1C194
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 22:48:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437E6C433C8;
        Wed, 11 Oct 2023 05:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697003333;
        bh=+X2CVJHDcoQT1C7/3ua7IQrQaYuu12DSA+GOOtELWG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0PEQpwfngJZW/QRDj7QBC21sZKGi3mDm5sR2eTjfahCcsZmkoJuKcZxTD8RLfNvZ
         4EY/2RTnolVdhpqzP8cNQBRUzHVE0V8tDBt3tXx08/0kP1PUvLJxbPIhPuPNDjca+W
         z4Yrd09BnmO3uhZb1YXWEszERHwA6HGqSwEyCFou15mNssN1suoB8VBbYrK+KRjy7h
         qC6EXi4Jo7U3PZbWLoKfAm0/rrN3ErKugXBSyZhs0KIfmmpTDvC2HLU6Hpi3pM/jyJ
         Ja+BPN86Zq3GwFFv0xIRsaF6qSZU+UNsaUdU00PeEPgBWmTFrmBzRmT3mViotAJ2TR
         HQRBaKsWP5I6w==
Date:   Tue, 10 Oct 2023 22:48:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: handle nimaps=0 from xfs_bmapi_write in
 xfs_alloc_file_space
Message-ID: <20231011054852.GK21298@frogsfrogsfrogs>
References: <20231011051626.498678-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011051626.498678-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 07:16:26AM +0200, Christoph Hellwig wrote:
> If xfs_bmapi_write finds a delalloc extent at the requested range, it
> tries to convert the entire delalloc extent to a real allocation.
> 
> But if the allocator cannot find a single free extent large enough to
> cover the start block of the requested range, xfs_bmapi_write will
> return 0 but leave *nimaps set to 0.
> 
> In that case we simply need to keep looping with the same startoffset_fsb
> so that one of the following allocations will eventually reach the
> requested range.
> 
> Note that this could affect any caller of xfs_bmapi_write that covers
> an existing delayed allocation.  As far as I can tell we do not have
> any other such caller, though - the regular writeback path uses
> xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
> and direct I/O invalidates the page cache first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Changes since v1:
>  - update comments and the commit log
> 
>  fs/xfs/xfs_bmap_util.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index d85580b101ad8a..2458be8532c7aa 100644
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
> @@ -918,15 +916,19 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		allocated_fsb = imapp->br_blockcount;
> -
> -		if (nimaps == 0) {
> -			error = -ENOSPC;
> -			break;
> +		/*
> +		 * If the allocator cannot find a single free extent large
> +		 * enough to cover the start block of the requested range,
> +		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
> +		 *
> +		 * In that case we simply need to keep looping with the same
> +		 * startoffset_fsb so that one of the following allocations
> +		 * will eventually reach the requested range.
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
