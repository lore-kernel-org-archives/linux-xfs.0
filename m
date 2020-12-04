Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E017C4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D875122AB9
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgLDOBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:01:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgLDOBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 09:01:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bK4lB4g2jPUHpNQd2ijFAUfNewDvcAmMwhqhW8sHmSQ=;
        b=ILuZ733g8h1E5+IqGdJfidDCZuKbINgLAfE5Upq4c03pDspfpjnNV1C3cQVxSjVrx1VR9U
        N8hh8h5h6uPjUvG1Ad4M0vIYfma06so+JncYMUIsIyVGM33gN6jYFMhG6p6jMH4WLB8rgA
        Fdb3UjLHKArXBXYRwC5Q8WhRfhqAFnY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-oKgxJVCjPcCatjMs_9e9Ig-1; Fri, 04 Dec 2020 09:00:23 -0500
X-MC-Unique: oKgxJVCjPcCatjMs_9e9Ig-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FD80A0CA5;
        Fri,  4 Dec 2020 14:00:22 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D35960936;
        Fri,  4 Dec 2020 14:00:21 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:00:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: hoist recovered extent-free intent checks out
 of xfs_efi_item_recover
Message-ID: <20201204140019.GI1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704433854.734470.16229052921938871989.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704433854.734470.16229052921938871989.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:12:18PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we recover a extent-free intent from the log, we need to validate
> its contents before we try to replay them.  Hoist the checking code into
> a separate function in preparation to refactor this code to use
> validation helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.c |   31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6c11bfc3d452..5e0f0b0a6c83 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -578,6 +578,25 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>  	.cancel_item	= xfs_extent_free_cancel_item,
>  };
>  
> +/* Is this recovered EFI ok? */
> +static inline bool
> +xfs_efi_validate_ext(
> +	struct xfs_mount		*mp,
> +	struct xfs_extent		*extp)
> +{
> +	xfs_fsblock_t			startblock_fsb;
> +
> +	startblock_fsb = XFS_BB_TO_FSB(mp,
> +			   XFS_FSB_TO_DADDR(mp, extp->ext_start));
> +	if (startblock_fsb == 0 ||
> +	    extp->ext_len == 0 ||
> +	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> +	    extp->ext_len >= mp->m_sb.sb_agblocks)
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Process an extent free intent item that was recovered from
>   * the log.  We need to free the extents that it describes.
> @@ -592,7 +611,6 @@ xfs_efi_item_recover(
>  	struct xfs_efd_log_item		*efdp;
>  	struct xfs_trans		*tp;
>  	struct xfs_extent		*extp;
> -	xfs_fsblock_t			startblock_fsb;
>  	int				i;
>  	int				error = 0;
>  
> @@ -602,14 +620,11 @@ xfs_efi_item_recover(
>  	 * just toss the EFI.
>  	 */
>  	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> -		extp = &efip->efi_format.efi_extents[i];
> -		startblock_fsb = XFS_BB_TO_FSB(mp,
> -				   XFS_FSB_TO_DADDR(mp, extp->ext_start));
> -		if (startblock_fsb == 0 ||
> -		    extp->ext_len == 0 ||
> -		    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -		    extp->ext_len >= mp->m_sb.sb_agblocks)
> +		if (!xfs_efi_validate_ext(mp,
> +					&efip->efi_format.efi_extents[i])) {
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  			return -EFSCORRUPTED;
> +		}
>  	}
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> 

