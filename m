Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29B0C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FE164F0D
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhBXVaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232245AbhBXVaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3475064F0D;
        Wed, 24 Feb 2021 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614202170;
        bh=BEZMZMs1G2XDtOOI0w6OLJpqtIsQN2MjswXN7nX7I+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=po2yaIWtltvOaQMq7VCwQ1ZoM4ZYcUoWugM5wZiE1WfDHRhMNkToxJpBawZAj6V0l
         g7a8UWjbUv3Jb9M7QZl2egWXAQm5sMXGklyJVtWWp9VaDMXKC8nT9Gq/VXSUgpoN3J
         XCzyXTcs+UkdaBkipuz8R4plu3DT0ey6zW3bF+A4CWU0QCqhboT3YWjr1VPvv6XxBi
         5SfRUMsROV0Mbg/9Crs28hoaGpx9Y8pAMRMGsWmkiIK1+FbtBD/cXFUvEgUyLeFvKd
         bFDb4NIOiAqRhrnzSkH7GQBTFSV4pyUsp+Z9yXYHY5LEb1BP5EoyRP09BqXTCIxPxB
         rNhkBOj3DjI/A==
Date:   Wed, 24 Feb 2021 13:29:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce buffer log item shadow allocations
Message-ID: <20210224212929.GY7272@magnolia>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-2-david@fromorbit.com>
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

Any particular reason for 512?  It looks like you simply picked an
arbitrary power of 2, but was there a particular target in mind? i.e.
we never need to realloc for the usual 4k filesystem?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
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
