Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8144FC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 16:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5099064DDA
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 16:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBKQr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhBKQrG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 11:47:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0E0164D87;
        Thu, 11 Feb 2021 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613061983;
        bh=q6MI1Kd023jYQQa6+wf+qgETEOThilZSsuDx5U6rC1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hw6Kj5M1ML2g6G0Zww/oNMe0iVyfMxY9FTd1Z+Jmdcin3rj1Uxo6gU9FmiH5KI/rF
         trU7sEmwG8xTcxRQY47VQyX/qwghtFpTM3sDR3bF1Xn3K3jDRwV9JWgwO+tNDlUsKt
         E6j/CepFwuxo3LIbQxzEdlv9Iujk8Z7I7Ul0no1AEZKY54FSLAd1pJgrouBVIQQBUC
         bt6ae2v4bHQnXrmwnivpzjiYKgWQsv7AaN2PjqRJgAnkpWduQhmClIqpid6EhS8jTX
         +eDFxIwmHRrZwHZNlRf+0rW96LjbV7e7B42Mrp3DeaAag10qtJNI6wiV3OPDXU82dq
         TN0hc2yH2zzAA==
Date:   Thu, 11 Feb 2021 08:46:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: consider shutdown in bmapbt cursor delete assert
Message-ID: <20210211164623.GC7193@magnolia>
References: <20210211143911.289537-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211143911.289537-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 09:39:11AM -0500, Brian Foster wrote:
> The assert in xfs_btree_del_cursor() checks that the bmapbt block
> allocation field has been handled correctly before the cursor is
> freed. This field is used for accurate calculation of indirect block
> reservation requirements (for delayed allocations), for example.
> generic/019 reproduces a scenario where this assert fails because
> the filesystem has shutdown while in the middle of a bmbt record
> insertion. This occurs after a bmbt block has been allocated via the
> cursor but before the higher level bmap function (i.e.
> xfs_bmap_add_extent_hole_real()) completes and resets the field.
> 
> Update the assert to accommodate the transient state if the
> filesystem has shutdown. While here, clean up the indentation and
> comments in the function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems like a lot of cleanup for the amount of actual code change; you
might've sent them separately but I'll merge it anyway...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index c4d7a9241dc3..b56ff451adce 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -353,20 +353,17 @@ xfs_btree_free_block(
>   */
>  void
>  xfs_btree_del_cursor(
> -	xfs_btree_cur_t	*cur,		/* btree cursor */
> -	int		error)		/* del because of error */
> +	struct xfs_btree_cur	*cur,		/* btree cursor */
> +	int			error)		/* del because of error */
>  {
> -	int		i;		/* btree level */
> +	int			i;		/* btree level */
>  
>  	/*
> -	 * Clear the buffer pointers, and release the buffers.
> -	 * If we're doing this in the face of an error, we
> -	 * need to make sure to inspect all of the entries
> -	 * in the bc_bufs array for buffers to be unlocked.
> -	 * This is because some of the btree code works from
> -	 * level n down to 0, and if we get an error along
> -	 * the way we won't have initialized all the entries
> -	 * down to 0.
> +	 * Clear the buffer pointers and release the buffers. If we're doing
> +	 * this because of an error, inspect all of the entries in the bc_bufs
> +	 * array for buffers to be unlocked. This is because some of the btree
> +	 * code works from level n down to 0, and if we get an error along the
> +	 * way we won't have initialized all the entries down to 0.
>  	 */
>  	for (i = 0; i < cur->bc_nlevels; i++) {
>  		if (cur->bc_bufs[i])
> @@ -374,17 +371,11 @@ xfs_btree_del_cursor(
>  		else if (!error)
>  			break;
>  	}
> -	/*
> -	 * Can't free a bmap cursor without having dealt with the
> -	 * allocated indirect blocks' accounting.
> -	 */
> -	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
> -	       cur->bc_ino.allocated == 0);
> -	/*
> -	 * Free the cursor.
> -	 */
> +
> +	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
> +	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
>  	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
> -		kmem_free((void *)cur->bc_ops);
> +		kmem_free(cur->bc_ops);
>  	kmem_cache_free(xfs_btree_cur_zone, cur);
>  }
>  
> -- 
> 2.26.2
> 
