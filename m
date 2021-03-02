Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF84C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A6461494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbhCCDOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:14:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1578978AbhCBPyR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 10:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614700366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=04UjvJXQaDt6Ojn3DGHIgO8UiHUwpAAH3OjtZ6zdgds=;
        b=Mqjwqj0M66LQMZ9yVSRqLIJq6kCMq0Yx96NaCggx7NcehOrQKI6nPWeyC5I7wJYqaO+Cfp
        QjDzD+zdbx9kuStlPL3h04H93xz2HQWu5WoAA1KXXgZ3lTRSMngpJYKWc6eiYcoNUY60tw
        X6rd70Zc2wDqdQB5uc+IlmES/tBMuDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-HpJlVZQGMkWpxd8XTw8sjA-1; Tue, 02 Mar 2021 09:37:27 -0500
X-MC-Unique: HpJlVZQGMkWpxd8XTw8sjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A74551936B7B;
        Tue,  2 Mar 2021 14:37:26 +0000 (UTC)
Received: from bfoster (ovpn-114-60.rdu2.redhat.com [10.10.114.60])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58DC45D9E2;
        Tue,  2 Mar 2021 14:37:26 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:37:24 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: xfs_buf_item_size_segment() needs to pass
 segment offset
Message-ID: <YD5NpMOcaVymLPwC@bfoster>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223044636.3280862-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 03:46:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Otherwise it doesn't correctly calculate the number of vectors
> in a logged buffer that has a contiguous map that gets split into
> multiple regions because the range spans discontigous memory.
> 
> Probably never been hit in practice - we don't log contiguous ranges
> on unmapped buffers (inode clusters).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf_item.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 0628a65d9c55..91dc7d8c9739 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -55,6 +55,18 @@ xfs_buf_log_format_size(
>  			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
>  }
>  
> +static inline bool
> +xfs_buf_item_straddle(
> +	struct xfs_buf		*bp,
> +	uint			offset,
> +	int			next_bit,
> +	int			last_bit)
> +{
> +	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
> +		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
> +		 XFS_BLF_CHUNK);
> +}
> +
>  /*
>   * Return the number of log iovecs and space needed to log the given buf log
>   * item segment.
> @@ -67,6 +79,7 @@ STATIC void
>  xfs_buf_item_size_segment(
>  	struct xfs_buf_log_item		*bip,
>  	struct xfs_buf_log_format	*blfp,
> +	uint				offset,
>  	int				*nvecs,
>  	int				*nbytes)
>  {
> @@ -101,12 +114,8 @@ xfs_buf_item_size_segment(
>  		 */
>  		if (next_bit == -1) {
>  			break;
> -		} else if (next_bit != last_bit + 1) {
> -			last_bit = next_bit;
> -			(*nvecs)++;
> -		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
> -			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
> -			    XFS_BLF_CHUNK)) {
> +		} else if (next_bit != last_bit + 1 ||
> +		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
>  			last_bit = next_bit;
>  			(*nvecs)++;
>  		} else {
> @@ -141,8 +150,10 @@ xfs_buf_item_size(
>  	int			*nbytes)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> +	struct xfs_buf		*bp = bip->bli_buf;
>  	int			i;
>  	int			bytes;
> +	uint			offset = 0;
>  
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -184,8 +195,9 @@ xfs_buf_item_size(
>  	 */
>  	bytes = 0;
>  	for (i = 0; i < bip->bli_format_count; i++) {
> -		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
> +		xfs_buf_item_size_segment(bip, &bip->bli_formats[i], offset,
>  					  nvecs, &bytes);
> +		offset += BBTOB(bp->b_maps[i].bm_len);
>  	}
>  
>  	/*
> @@ -212,18 +224,6 @@ xfs_buf_item_copy_iovec(
>  			nbits * XFS_BLF_CHUNK);
>  }
>  
> -static inline bool
> -xfs_buf_item_straddle(
> -	struct xfs_buf		*bp,
> -	uint			offset,
> -	int			next_bit,
> -	int			last_bit)
> -{
> -	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
> -		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
> -		 XFS_BLF_CHUNK);
> -}
> -
>  static void
>  xfs_buf_item_format_segment(
>  	struct xfs_buf_log_item	*bip,
> -- 
> 2.28.0
> 

