Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22238 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751183AbdC0UHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 16:07:00 -0400
Date: Mon, 27 Mar 2017 13:05:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Remove obsolete declaration of xfs_buf_get_empty
Message-ID: <20170327200558.GI5738@birch.djwong.org>
References: <1490644909-30636-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490644909-30636-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2017 at 11:01:49PM +0300, Nikolay Borisov wrote:
> This function has been removed ever since at least 3.12-era. No need to
> keep its declaration in the header so nuke it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Will queue this for 4.12.

--D

> ---
>  fs/xfs/xfs_buf.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3c867e5a63e1..e1bc1af743fa 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -291,7 +291,6 @@ xfs_buf_readahead(
>  	return xfs_buf_readahead_map(target, &map, 1, ops);
>  }
>  
> -struct xfs_buf *xfs_buf_get_empty(struct xfs_buftarg *target, size_t numblks);
>  void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
>  int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
>  
> -- 
> 2.7.4
> 
