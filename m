Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88996C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCD261477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbhCCDOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:14:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1384613AbhCBPWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 10:22:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614698401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WMJ46CGYlMlnHOb+imNgDyRe8GlIaT++MCwYLndXLb0=;
        b=CgodP1z14AbNfuKGCBHwFz+PXAKJC9S7juNP2MxOl/2wPSXFR3C7gBIddWC7R+XZmPLlYS
        FJpU8znhLIZC204pdeHh9snm7posf/zLSMTAGpLGdxBre1fxr+Covlfz1dWpEKcwwgaihg
        LLg02HaRBE8egyA1xI5vwtsmJtmeMik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-jz3qAQPEMHKk5f3cR4fh9A-1; Tue, 02 Mar 2021 09:37:19 -0500
X-MC-Unique: jz3qAQPEMHKk5f3cR4fh9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7A531083EA9;
        Tue,  2 Mar 2021 14:37:18 +0000 (UTC)
Received: from bfoster (ovpn-114-60.rdu2.redhat.com [10.10.114.60])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF5D60CC5;
        Tue,  2 Mar 2021 14:37:18 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:37:16 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce buffer log item shadow allocations
Message-ID: <YD5NnITklvkLXS+A@bfoster>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 03:46:34PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we modify btrees repeatedly, we regularly increase the size of
> the logged region by a single chunk at a time (per transaction
> commit). This results in the CIL formatting code having to
> reallocate the log vector buffer every time the buffer dirty region
> grows. Hence over a typical 4kB btree buffer, we might grow the log
> vector 4096/128 = 32x over a short period where we repeatedly add
> or remove records to/from the buffer over a series of running
> transaction. This means we are doing 32 memory allocations and frees
> over this time during a performance critical path in the journal.
> 
> The amount of space tracked in the CIL for the object is calculated
> during the ->iop_format() call for the buffer log item, but the
> buffer memory allocated for it is calculated by the ->iop_size()
> call. The size callout determines the size of the buffer, the format
> call determines the space used in the buffer.
> 
> Hence we can oversize the buffer space required in the size
> calculation without impacting the amount of space used and accounted
> to the CIL for the changes being logged. This allows us to reduce
> the number of allocations by rounding up the buffer size to allow
> for future growth. This can safe a substantial amount of CPU time in
> this path:
> 
> -   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
>    - 44.49% xfs_log_commit_cil
>       - 30.78% _raw_spin_lock
>          - 30.75% do_raw_spin_lock
>               30.27% __pv_queued_spin_lock_slowpath
> 
> (oh, ouch!)
> ....
>       - 1.05% kmem_alloc_large
>          - 1.02% kmem_alloc
>               0.94% __kmalloc
> 
> This overhead here us what this patch is aimed at. After:
> 
>       - 0.76% kmem_alloc_large
>          - 0.75% kmem_alloc
>               0.70% __kmalloc
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 17960b1ce5ef..0628a65d9c55 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -142,6 +142,7 @@ xfs_buf_item_size(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	int			i;
> +	int			bytes;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -173,7 +174,7 @@ xfs_buf_item_size(
>  	}
>  
>  	/*
> -	 * the vector count is based on the number of buffer vectors we have
> +	 * The vector count is based on the number of buffer vectors we have
>  	 * dirty bits in. This will only be greater than one when we have a
>  	 * compound buffer with more than one segment dirty. Hence for compound
>  	 * buffers we need to track which segment the dirty bits correspond to,
> @@ -181,10 +182,18 @@ xfs_buf_item_size(
>  	 * count for the extra buf log format structure that will need to be
>  	 * written.
>  	 */
> +	bytes = 0;
>  	for (i = 0; i < bip->bli_format_count; i++) {
>  		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> -					  nvecs, nbytes);
> +					  nvecs, &bytes);
>  	}
> +
> +	/*
> +	 * Round up the buffer size required to minimise the number of memory
> +	 * allocations that need to be done as this item grows when relogged by
> +	 * repeated modifications.
> +	 */
> +	*nbytes = round_up(bytes, 512);
>  	trace_xfs_buf_item_size(bip);
>  }
>  
> -- 
> 2.28.0
> 

