Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30783 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754447AbcJQSgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 14:36:11 -0400
Date: Mon, 17 Oct 2016 11:36:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Fix uninitialized variable in
 xfs_reflink_reserve_cow_range()
Message-ID: <20161017183605.GA26485@birch.djwong.org>
References: <1476699404-5977-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1476699404-5977-1-git-send-email-geert@linux-m68k.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 17, 2016 at 12:16:44PM +0200, Geert Uytterhoeven wrote:
> with gcc 4.1.2:
> 
>     fs/xfs/xfs_reflink.c: In function ‘xfs_reflink_reserve_cow_range’:
>     fs/xfs/xfs_reflink.c:327: warning: ‘error’ may be used uninitialized in this function
> 
> Indeed, if "count" is zero, the function will return an uninitialized
> error value.
> 
> While "count" is unlikely to be zero, this function is called through
> the public iomap API. Hence fix this by preinitializing error to zero.
> 
> Fixes: 2a06705cd5954030 ("xfs: create delalloc extents in CoW fork")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_reflink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5965e9455d91e036..d48a7cc2fe007f66 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -324,7 +324,7 @@
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb, end_fsb;
>  	bool			skipped = false;
> -	int			error;
> +	int			error = 0;
>  
>  	trace_xfs_reflink_reserve_cow_range(ip, offset, count);
>  
> -- 
> 1.9.1
> 
