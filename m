Return-Path: <SRS0=E0aF=CS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4944EC43461
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 16:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD2E20639
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Sep 2020 16:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UoPt2Uow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgIIQAe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Sep 2020 12:00:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58637 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730357AbgIIQAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Sep 2020 12:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599667203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9aotpLURod+TV9CygHv1rjUSRqJ6tcbRaAtOl3mjC0s=;
        b=UoPt2Uowh4lBuSTWx2Uj0a4Y6biWsNYqshZ/L45/7XutjGonNRskAQJFpnMsUWpqdxAJsE
        eNU8erG52J28fS3gcjeq8TfvUbRR77/3Jsf5nGJYVBoXxFYxjpDyROvs5z2poDxFXgnhvJ
        OYiQD7koSGhQGSod3kHzzQBGyCWGDqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-k9Q2YBo_Mf-CZiAxpg_Dxw-1; Wed, 09 Sep 2020 09:35:28 -0400
X-MC-Unique: k9Q2YBo_Mf-CZiAxpg_Dxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D86351008314;
        Wed,  9 Sep 2020 13:35:27 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 875FA5C230;
        Wed,  9 Sep 2020 13:35:27 +0000 (UTC)
Date:   Wed, 9 Sep 2020 09:35:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add a free space extent change reservation
Message-ID: <20200909133525.GB765129@bfoster>
References: <20200909081912.1185392-1-david@fromorbit.com>
 <20200909081912.1185392-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909081912.1185392-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 09, 2020 at 06:19:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lots of the transaction reservation code reserves space for an
> extent allocation. It is inconsistently implemented, and many of
> them get it wrong. Introduce a new function to calculate the log
> space reservation for adding or removing an extent from the free
> space btrees.
> 
> This function reserves space for logging the AGF, the AGFL and the
> free space btrees, avoiding the need to account for them seperately
> in every reservation that manipulates free space.
> 
> Convert the EFI recovery reservation to use this transaction
> reservation as EFI recovery only needs to manipulate the free space
> index.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index da2ec052ac0a..621ddb277dfa 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -79,6 +79,23 @@ xfs_allocfree_log_count(
>  	return blocks;
>  }
>  
> +/*
> + * Log reservation required to add or remove a single extent to the free space
> + * btrees.  This requires modifying:
> + *
> + * the agf header: 1 sector
> + * the agfl header: 1 sector
> + * the allocation btrees: 2 trees * (max depth - 1) * block size

Nit, but the xfs_allocfree_log_count() helper this uses clearly
indicates reservation for up to four trees. It might be worth referring
to that here just to minimize spreading details all over the place that
are likely to become stale or inconsistent over time.

> + */
> +uint
> +xfs_allocfree_extent_res(
> +	struct xfs_mount *mp)
> +{
> +	return xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
> +	       xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),

Why calculate for a single extent when an EFI can refer to multiple
extents? I thought the max was 2, but the extent free portion of the
itruncate calculation actually uses an op count of 4. The reason for
that is not immediately clear to me. It actually accounts 4 agf/agfl
blocks as well, so perhaps there's a wrong assumption somewhere. FWIW,
the truncate code allows 2 unmaps per transaction and the
xfs_extent_free_defer_type struct limits the dfp to 16. I suspect the
latter is not relevant for the current code.

Either way, multiple extents are factored into the current freeing
reservation and the extent freeing code at runtime (dfops) and during
recovery both appear to iterate on an extent count (potentially > 1) per
transaction. The itruncate comment, for reference (I also just noticed
that the subsequent patch modifies this comment, so you're presumably
aware of this mess):

/*
 * ...
 * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
 *    the agf for each of the ags: 4 * sector size
 *    the agfl for each of the ags: 4 * sector size
 *    the super block to reflect the freed blocks: sector size
 *    worst case split in allocation btrees per extent assuming 4 extents:
 *              4 exts * 2 trees * (2 * max depth - 1) * block size
 * ...
 */

Brian

> +				XFS_FSB_TO_B(mp, 1));
> +}
> +
>  /*
>   * Logging inodes is really tricksy. They are logged in memory format,
>   * which means that what we write into the log doesn't directly translate into
> @@ -922,7 +939,7 @@ xfs_trans_resv_calc(
>  	 * EFI recovery is itruncate minus the initial transaction that logs
>  	 * logs the EFI.
>  	 */
> -	resp->tr_efi.tr_logres = resp->tr_itruncate.tr_logres;
> +	resp->tr_efi.tr_logres = xfs_allocfree_extent_res(mp);
>  	resp->tr_efi.tr_logcount = resp->tr_itruncate.tr_logcount - 1;
>  	resp->tr_efi.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> -- 
> 2.28.0
> 

