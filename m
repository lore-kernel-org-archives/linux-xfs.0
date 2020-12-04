Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFC4C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 13:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3C122AB9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 13:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgLDN4k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 08:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbgLDN4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 08:56:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/kmMQrf62+0/LKnvzuy4zcqyAVwrE007kpb+JDE5Srs=;
        b=e0ItYenp6x4cwGN7tIoCc9os48idZDBTQadiMl1PS+gvV74Bjt9VdZs5xcQtlj4Mn+2bnY
        hvs11DtIBqbXiV37xhwfN6QkkUOITBirTsgtjCMKXFAbEO05i867jddYs5dApMb94e+qsZ
        QjeReVcYuXZafKbJJfaffjwGyz0GbhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-EwTObsEnOgm7dQQh2vIc7A-1; Fri, 04 Dec 2020 08:55:09 -0500
X-MC-Unique: EwTObsEnOgm7dQQh2vIc7A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF994612A3;
        Fri,  4 Dec 2020 13:55:08 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E15F100164C;
        Fri,  4 Dec 2020 13:55:08 +0000 (UTC)
Date:   Fri, 4 Dec 2020 08:55:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/10] xfs: hoist recovered bmap intent checks out of
 xfs_bui_item_recover
Message-ID: <20201204135506.GC1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704430044.734470.16065444609448176719.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704430044.734470.16065444609448176719.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:11:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a bmap intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c |   73 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 46 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 9e16a4d0f97c..555453d0e080 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -417,6 +417,49 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>  	.cancel_item	= xfs_bmap_update_cancel_item,
>  };
>  
> +/* Is this recovered BUI ok? */
> +static inline bool
> +xfs_bui_validate(
> +	struct xfs_mount		*mp,
> +	struct xfs_bui_log_item		*buip)
> +{
> +	struct xfs_map_extent		*bmap;
> +	xfs_fsblock_t			startblock_fsb;
> +	xfs_fsblock_t			inode_fsb;
> +
> +	/* Only one mapping operation per BUI... */
> +	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> +		return false;
> +
> +	bmap = &buip->bui_format.bui_extents[0];
> +	startblock_fsb = XFS_BB_TO_FSB(mp,
> +			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
> +	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
> +			XFS_INO_TO_FSB(mp, bmap->me_owner)));
> +
> +	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
> +		return false;
> +
> +	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
> +	case XFS_BMAP_MAP:
> +	case XFS_BMAP_UNMAP:
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	if (startblock_fsb == 0 ||
> +	    bmap->me_len == 0 ||
> +	    inode_fsb == 0 ||
> +	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> +	    bmap->me_len >= mp->m_sb.sb_agblocks ||
> +	    inode_fsb >= mp->m_sb.sb_dblocks ||
> +	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
> +		return false;

Looks like the ->me_flags check is duplicated here and above. Otherwise
looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	return true;
> +}
> +
>  /*
>   * Process a bmap update intent item that was recovered from the log.
>   * We need to update some inode's bmbt.
> @@ -433,47 +476,23 @@ xfs_bui_item_recover(
>  	struct xfs_mount		*mp = lip->li_mountp;
>  	struct xfs_map_extent		*bmap;
>  	struct xfs_bud_log_item		*budp;
> -	xfs_fsblock_t			startblock_fsb;
> -	xfs_fsblock_t			inode_fsb;
>  	xfs_filblks_t			count;
>  	xfs_exntst_t			state;
>  	unsigned int			bui_type;
>  	int				whichfork;
>  	int				error = 0;
>  
> -	/* Only one mapping operation per BUI... */
> -	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> +	if (!xfs_bui_validate(mp, buip)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
> +	}
>  
> -	/*
> -	 * First check the validity of the extent described by the
> -	 * BUI.  If anything is bad, then toss the BUI.
> -	 */
>  	bmap = &buip->bui_format.bui_extents[0];
> -	startblock_fsb = XFS_BB_TO_FSB(mp,
> -			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
> -	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
> -			XFS_INO_TO_FSB(mp, bmap->me_owner)));
>  	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
>  			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
>  	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
>  			XFS_ATTR_FORK : XFS_DATA_FORK;
>  	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
> -	switch (bui_type) {
> -	case XFS_BMAP_MAP:
> -	case XFS_BMAP_UNMAP:
> -		break;
> -	default:
> -		return -EFSCORRUPTED;
> -	}
> -	if (startblock_fsb == 0 ||
> -	    bmap->me_len == 0 ||
> -	    inode_fsb == 0 ||
> -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -	    bmap->me_len >= mp->m_sb.sb_agblocks ||
> -	    inode_fsb >= mp->m_sb.sb_dblocks ||
> -	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
> -		return -EFSCORRUPTED;
>  
>  	/* Grab the inode. */
>  	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
> 

