Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4D6C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 17:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjJaRDq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbjJaRD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 13:03:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F91121
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 09:53:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D565C433C7;
        Tue, 31 Oct 2023 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698771212;
        bh=z763AGwYNKm1GJkQkcTueZMVEcslvH12w3oiXHVEUqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=INTsCTs2VIduGB8JS6wBJiMYsiwacsxeL5jkwX66M1iIli4aZGh4DcWYdvYQFSxSE
         v/3w6sq9BnOdXUa9pzM/6/WcR0Ajt5sf3Wkcjaeq+mxD/Rn0lpF5VhLyLRvxlu+mW+
         Eyt1xc+EDUxaQptpoSvtyqf6epdmUvLqAcqckOukFX16K/sxNqTQL2W0ce6/QIjQ2u
         KZkix6k78KRT6WTilUZnF7A/Qxb+1f0h1kTiYL0CpZvQkmL1QB4zcqc1q+0U+M7eHs
         4rCBu6wrLlM+T5N0z1r1/PmJY87mfsmnP6fruAlSWkd2jDSbAvT5qAU/00lkKATYqY
         1Xee20eAmLObw==
Date:   Tue, 31 Oct 2023 09:53:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH, realtime-rmap branch] xfs: lock the RT bitmap inode in
 xfs_efi_item_recover
Message-ID: <20231031165330.GC1041814@frogsfrogsfrogs>
References: <20231031095038.1559309-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031095038.1559309-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 10:50:38AM +0100, Christoph Hellwig wrote:
> xfs_trans_free_extent expects the rtbitmap and rtsum inodes to be locked.
> Ensure that is the case during log recovery as well.
> 
> Fixes: 3ea32f5cc5f9 ("xfs: support logging EFIs for realtime extents")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> I found this when testing the realtime-rmap branch with additional
> patches on top.  Probably makes sense to just fold it in for the next
> rebase of that branch.
> 
>  fs/xfs/xfs_extfree_item.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 5b3e7dca4e1ba0..070070b6401d66 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -768,6 +768,8 @@ xfs_efi_item_recover(
>  
>  		if (!requeue_only) {
>  			xfs_extent_free_get_group(mp, &fake);
> +			if (xfs_efi_is_realtime(&fake))
> +				xfs_rtbitmap_lock(tp, mp);

Curious, I thought that patch "xfs: support logging EFIs for realtime
extents" already locked the rt bitmap?

	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
	if (error)
		return error;
	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);

	/* Lock the rt bitmap if we've any realtime extents to free. */
	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
		struct xfs_extent		*extp;

		extp = &efip->efi_format.efi_extents[i];
		if (extp->ext_len & XFS_EFI_EXTLEN_REALTIME_EXT) {
			xfs_rtbitmap_lock(tp, mp);

Here			^^^^^^^^^

			break;
		}
	}

	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
		struct xfs_extent_free_item	fake = {
			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
			.xefi_agresv		= XFS_AG_RESV_NONE,
		};
		struct xfs_extent		*extp;
		unsigned int			len;

		extp = &efip->efi_format.efi_extents[i];

		fake.xefi_startblock = extp->ext_start;
		len = extp->ext_len;
		if (len & XFS_EFI_EXTLEN_REALTIME_EXT) {
			len &= ~XFS_EFI_EXTLEN_REALTIME_EXT;
			fake.xefi_flags |= XFS_EFI_REALTIME;
		}
		fake.xefi_blockcount = len;

		if (!requeue_only) {
			xfs_extent_free_get_group(mp, &fake);
			error = xfs_trans_free_extent(tp, efdp, &fake);
			xfs_extent_free_put_group(&fake);
		}

So that by the time we get to this part of the loop, the rtbitmap will
be locked already?

What sort of error message did you get?

<confused>

--D

>  			error = xfs_trans_free_extent(tp, efdp, &fake);
>  			xfs_extent_free_put_group(&fake);
>  		}
> -- 
> 2.39.2
> 
