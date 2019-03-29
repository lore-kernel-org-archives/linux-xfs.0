Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40691 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbfC2ODa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 29 Mar 2019 10:03:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAA333D945
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 14:03:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68B985D9D1
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 14:03:30 +0000 (UTC)
Date: Fri, 29 Mar 2019 10:03:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix use after free in buf log item unlock assert
Message-ID: <20190329140328.GA12358@bfoster>
References: <20190206160107.63672-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206160107.63672-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Feb 06, 2019 at 11:01:07AM -0500, Brian Foster wrote:
> The xfs_buf_log_item ->iop_unlock() callback asserts that the buffer
> is unlocked when either non-stale or aborted. This assert occurs
> after the bli refcount has been dropped and the log item potentially
> freed. The aborted check is thus a potential use after free. This
> problem has been reproduced with KASAN enabled via generic/475.
> 
> Fix up xfs_buf_item_unlock() to query aborted state before the bli
> reference is dropped to prevent a potential use after free.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---

Ping on this one.. looks like it was reviewed and maybe fell through the
cracks?

Brian

>  fs/xfs/xfs_buf_item.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 010db5f8fb00..65b32acfa0f6 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -605,6 +605,8 @@ xfs_buf_item_unlock(
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
>  	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> +	bool			aborted = test_bit(XFS_LI_ABORTED,
> +						   &lip->li_flags);
>  #endif
>  
>  	trace_xfs_buf_item_unlock(bip);
> @@ -633,7 +635,7 @@ xfs_buf_item_unlock(
>  	released = xfs_buf_item_put(bip);
>  	if (hold || (stale && !released))
>  		return;
> -	ASSERT(!stale || test_bit(XFS_LI_ABORTED, &lip->li_flags));
> +	ASSERT(!stale || aborted);
>  	xfs_buf_relse(bp);
>  }
>  
> -- 
> 2.17.2
> 
