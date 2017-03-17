Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbdCQUaT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Mar 2017 16:30:19 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86A5F624C6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 20:29:45 +0000 (UTC)
Date: Fri, 17 Mar 2017 15:29:40 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH (TRIVIAL)] xfs: fix up inode validation failure message
Message-ID: <20170317202940.GA19030@redhat.com>
References: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59d16175-1c24-4bc2-5cd9-ac7a062e5ae3@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 17, 2017 at 08:47:38AM -0700, Eric Sandeen wrote:
> "xfs_iread: validation failed for inode 96 failed"
> 
> One "failed" seems like enough.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
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
