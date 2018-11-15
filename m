Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbeKOQEk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 11:04:40 -0500
Date: Wed, 14 Nov 2018 21:58:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: make xfs_file_remap_range() static
Message-ID: <20181115055809.GT4235@magnolia>
References: <20181115011217.104363-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115011217.104363-1-ebiggers@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 14, 2018 at 05:12:17PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> xfs_file_remap_range() is only used in fs/xfs/xfs_file.c, so make it
> static.
> 
> This addresses a gcc warning when -Wmissing-prototypes is enabled.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 53c9ab8fb777f..e47425071e654 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -920,7 +920,7 @@ xfs_file_fallocate(
>  }
>  
>  
> -loff_t
> +STATIC loff_t
>  xfs_file_remap_range(
>  	struct file		*file_in,
>  	loff_t			pos_in,
> -- 
> 2.19.1.930.g4563a0d9d0-goog
> 
