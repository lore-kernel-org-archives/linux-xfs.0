Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAFDC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB6F22AB0
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgLDOBj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgLDOBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bDoAxmL8hT1MRhOKpChTC/kreS2OVkq+A0klfpr6oAE=;
        b=ArI1GKM9Kvbb9VpWzI8R0XXTLsxKdeOzxb57yBTRVHOSFvx06HjZ/qEbu5rQcj5XWRE0u0
        6ng3DjIIQ0s0x9epDXtWfsuNLoRdG5prSG0+yzCZ/BdIsSWaS1X5o7oqTFUhlaWoRlgL4p
        4d48FgDkMMNVvuhGIMJTaB5/hpkQwco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-s4zXx6QlMbitwuJ231RzTA-1; Fri, 04 Dec 2020 09:00:10 -0500
X-MC-Unique: s4zXx6QlMbitwuJ231RzTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E119A85819A;
        Fri,  4 Dec 2020 14:00:07 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72E245D9DC;
        Fri,  4 Dec 2020 14:00:07 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: hoist recovered refcount intent checks out of
 xfs_cui_item_recover
Message-ID: <20201204140005.GG1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704432626.734470.12800460361201622389.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704432626.734470.12800460361201622389.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 04, 2020 at 01:12:06AM +0000, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a refcount intent from the log, we need to validate its
> contents before we try to replay them.  Hoist the checking code into a
> separate function in preparation to refactor this code to use validation
> helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_refcount_item.c |   57 ++++++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 21 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 7529eb63ce94..a456a2fb794c 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -417,6 +417,38 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>  	.cancel_item	= xfs_refcount_update_cancel_item,
>  };
>  
> +/* Is this recovered CUI ok? */
> +static inline bool
> +xfs_cui_validate_phys(
> +	struct xfs_mount		*mp,
> +	struct xfs_phys_extent		*refc)
> +{
> +	xfs_fsblock_t			startblock_fsb;
> +	bool				op_ok;
> +
> +	startblock_fsb = XFS_BB_TO_FSB(mp,
> +			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
> +	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
> +	case XFS_REFCOUNT_INCREASE:
> +	case XFS_REFCOUNT_DECREASE:
> +	case XFS_REFCOUNT_ALLOC_COW:
> +	case XFS_REFCOUNT_FREE_COW:
> +		op_ok = true;
> +		break;
> +	default:
> +		op_ok = false;
> +		break;
> +	}
> +	if (!op_ok || startblock_fsb == 0 ||
> +	    refc->pe_len == 0 ||
> +	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> +	    refc->pe_len >= mp->m_sb.sb_agblocks ||
> +	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Process a refcount update intent item that was recovered from the log.
>   * We need to update the refcountbt.
> @@ -433,11 +465,9 @@ xfs_cui_item_recover(
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
>  	struct xfs_mount		*mp = lip->li_mountp;
> -	xfs_fsblock_t			startblock_fsb;
>  	xfs_fsblock_t			new_fsb;
>  	xfs_extlen_t			new_len;
>  	unsigned int			refc_type;
> -	bool				op_ok;
>  	bool				requeue_only = false;
>  	enum xfs_refcount_intent_type	type;
>  	int				i;
> @@ -449,26 +479,11 @@ xfs_cui_item_recover(
>  	 * just toss the CUI.
>  	 */
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> -		refc = &cuip->cui_format.cui_extents[i];
> -		startblock_fsb = XFS_BB_TO_FSB(mp,
> -				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
> -		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
> -		case XFS_REFCOUNT_INCREASE:
> -		case XFS_REFCOUNT_DECREASE:
> -		case XFS_REFCOUNT_ALLOC_COW:
> -		case XFS_REFCOUNT_FREE_COW:
> -			op_ok = true;
> -			break;
> -		default:
> -			op_ok = false;
> -			break;
> -		}
> -		if (!op_ok || startblock_fsb == 0 ||
> -		    refc->pe_len == 0 ||
> -		    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -		    refc->pe_len >= mp->m_sb.sb_agblocks ||
> -		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
> +		if (!xfs_cui_validate_phys(mp,
> +					&cuip->cui_format.cui_extents[i])) {
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  			return -EFSCORRUPTED;
> +		}
>  	}
>  
>  	/*
> 

