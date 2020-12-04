Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D570C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2674422AB0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgLDOBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgLDOBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sKzoSMd0qKi36YIuFy0D1K8RNkfzIFUErM5SruXseKw=;
        b=ihdWkyqDpbVJzw8maxnn5PIVYTEuFzi/HQNzwPXpoYenfbfAI6I/PGx141wdVbMg/NTl20
        hIFJKLe9tkcrRKKAYyoyJMNcbpP94u4pw9/8dhO9503Uq8VKe/g0+IlkKpLCbyoickmQfy
        +Y26YRusAFt/kioSWdz02BLCSD8GCWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-hD3P0402Nby5wn5rmheumw-1; Fri, 04 Dec 2020 08:59:53 -0500
X-MC-Unique: hD3P0402Nby5wn5rmheumw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2609A0C2F;
        Fri,  4 Dec 2020 13:59:52 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30D735D6AC;
        Fri,  4 Dec 2020 13:59:52 +0000 (UTC)
Date:   Fri, 4 Dec 2020 08:59:50 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: hoist recovered rmap intent checks out of
 xfs_rui_item_recover
Message-ID: <20201204135950.GE1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704431272.734470.4579974752157438262.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704431272.734470.4579974752157438262.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:11:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a rmap intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_rmap_item.c |   65 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 40 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 7adc996ca6e3..d77d104d93c6 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -460,6 +460,42 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>  	.cancel_item	= xfs_rmap_update_cancel_item,
>  };
>  
> +/* Is this recovered RUI ok? */
> +static inline bool
> +xfs_rui_validate_map(
> +	struct xfs_mount		*mp,
> +	struct xfs_map_extent		*rmap)
> +{
> +	xfs_fsblock_t			startblock_fsb;
> +	bool				op_ok;
> +
> +	startblock_fsb = XFS_BB_TO_FSB(mp,
> +			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
> +	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
> +	case XFS_RMAP_EXTENT_MAP:
> +	case XFS_RMAP_EXTENT_MAP_SHARED:
> +	case XFS_RMAP_EXTENT_UNMAP:
> +	case XFS_RMAP_EXTENT_UNMAP_SHARED:
> +	case XFS_RMAP_EXTENT_CONVERT:
> +	case XFS_RMAP_EXTENT_CONVERT_SHARED:
> +	case XFS_RMAP_EXTENT_ALLOC:
> +	case XFS_RMAP_EXTENT_FREE:
> +		op_ok = true;
> +		break;
> +	default:
> +		op_ok = false;
> +		break;
> +	}
> +	if (!op_ok || startblock_fsb == 0 ||
> +	    rmap->me_len == 0 ||
> +	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> +	    rmap->me_len >= mp->m_sb.sb_agblocks ||
> +	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Process an rmap update intent item that was recovered from the log.
>   * We need to update the rmapbt.
> @@ -475,10 +511,8 @@ xfs_rui_item_recover(
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
>  	struct xfs_mount		*mp = lip->li_mountp;
> -	xfs_fsblock_t			startblock_fsb;
>  	enum xfs_rmap_intent_type	type;
>  	xfs_exntst_t			state;
> -	bool				op_ok;
>  	int				i;
>  	int				whichfork;
>  	int				error = 0;
> @@ -489,30 +523,11 @@ xfs_rui_item_recover(
>  	 * just toss the RUI.
>  	 */
>  	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
> -		rmap = &ruip->rui_format.rui_extents[i];
> -		startblock_fsb = XFS_BB_TO_FSB(mp,
> -				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
> -		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
> -		case XFS_RMAP_EXTENT_MAP:
> -		case XFS_RMAP_EXTENT_MAP_SHARED:
> -		case XFS_RMAP_EXTENT_UNMAP:
> -		case XFS_RMAP_EXTENT_UNMAP_SHARED:
> -		case XFS_RMAP_EXTENT_CONVERT:
> -		case XFS_RMAP_EXTENT_CONVERT_SHARED:
> -		case XFS_RMAP_EXTENT_ALLOC:
> -		case XFS_RMAP_EXTENT_FREE:
> -			op_ok = true;
> -			break;
> -		default:
> -			op_ok = false;
> -			break;
> -		}
> -		if (!op_ok || startblock_fsb == 0 ||
> -		    rmap->me_len == 0 ||
> -		    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -		    rmap->me_len >= mp->m_sb.sb_agblocks ||
> -		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
> +		if (!xfs_rui_validate_map(mp,
> +					&ruip->rui_format.rui_extents[i])) {
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  			return -EFSCORRUPTED;
> +		}
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> 

