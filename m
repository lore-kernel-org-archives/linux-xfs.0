Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37410 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCQQfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 12:35:46 -0400
Received: by mail-it0-f41.google.com with SMTP id g138so32695279itb.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 09:35:45 -0700 (PDT)
Subject: Re: [PATCH (TRIVIAL)] xfs: fix up inode validation failure message
References: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
From: Alex Elder <elder@ieee.org>
Message-ID: <5e2f6991-9287-4111-d34e-b08598b76363@ieee.org>
Date: Fri, 17 Mar 2017 11:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 03/17/2017 10:47 AM, Eric Sandeen wrote:
> "xfs_iread: validation failed for inode 96 failed"
> 
> One "failed" seems like enough.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> 
> Yo dawg, I heard you like failed so I put failed in your
> failed so you can fail while you fail.
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d93f9d9..09c3d1a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -508,7 +508,7 @@
>  
>  	/* even unallocated inodes are verified */
>  	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
> -		xfs_alert(mp, "%s: validation failed for inode %lld failed",
> +		xfs_alert(mp, "%s: validation failed for inode %lld",
>  				__func__, ip->i_ino);
>  
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

