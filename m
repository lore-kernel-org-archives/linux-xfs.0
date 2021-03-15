Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138F1C43381
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D473564F9B
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhCOOx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:53:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240821AbhCOOwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9QOgJOK6EUJZDk3p6W1Xw7RvNiLdjc/ecx8fQ+HTksE=;
        b=fyyxum5uzNpF93QwrtHSFUo4sZDZyV2E5EXekgCC1c+kql7oyf2jjffq6VPDIRoarnDtk1
        5/oUErU1UPqRi7FzVP8b2IdqbV1oWM63UeTyt3etGKFcZG1xjiYeCQipse19uXNFfNfK63
        JEpRAYk6C4pbGz1T/nnvCqQZtEDOlX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-jCug1kDiMtKD3S-5koHxAQ-1; Mon, 15 Mar 2021 10:52:37 -0400
X-MC-Unique: jCug1kDiMtKD3S-5koHxAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 918CA81747C;
        Mon, 15 Mar 2021 14:52:36 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BFC56B8F9;
        Mon, 15 Mar 2021 14:52:36 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:52:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/45] xfs: reduce buffer log item shadow allocations
Message-ID: <YE90su7fzdQciZk5@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-11-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:08PM +1100, Dave Chinner wrote:
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
> The size of 512 bytes is based on the bitmap chunk size being 128
> bytes and that random directory entry updates almost never require
> more than 3-4 128 byte regions to be logged in the directory block.
> 
> The other observation is for per-ag btrees. When we are inserting
> into a new btree block, we'll pack it from the front. Hence the
> first few records land in the first 128 bytes so we log only 128
> bytes, the next 8-16 records land in the second region so now we log
> 256 bytes. And so on.  If we are doing random updates, it will only
> allocate every 4 random 128 byte regions that are dirtied instead of
> every single one.
> 
> Any larger than 512 bytes and I noticed an increase in memory
> footprint in my scalability workloads. Any less than this and I
> didn't really see any significant benefit to CPU usage.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

It looks like I have posted feedback (mostly reviewed-by tags, fwiw) on
previous posts of this patch and the next three that appears to have
been either ignored or lost.

Brian

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

