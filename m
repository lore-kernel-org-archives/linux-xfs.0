Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37611 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbdAXRFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 12:05:19 -0500
Date: Tue, 24 Jan 2017 09:05:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: xfs_db: Interpret inode's di_format field as
 unsigned
Message-ID: <20170124170513.GB9134@birch.djwong.org>
References: <1485262673-22783-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485262673-22783-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 06:27:53PM +0530, Chandan Rajendra wrote:
> On a ppc64 big endian system, xfs_db would print the following,
> 
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0100600
> core.version = 3
> core.format = -253
> 
> This is due to fp_dinode_fmt() interpretting the di_format field as
> signed. This commit fixes the bug by passing BVUNSIGNED (instead of
> BVSIGNED) as the argument to getbitval(). With this commit applied, we
> now get,
> 
> xfs_db> p
> core.magic = 0x494e
> core.mode = 0100600
> core.version = 3
> core.format = 3 (btree)
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

I hit this bug running fuzztests on ppc64, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  db/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/inode.c b/db/inode.c
> index cac19fc..8b7a41e 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -238,7 +238,7 @@ fp_dinode_fmt(
>  	int			i;
>  
>  	for (i = 0, bitpos = bit; i < count; i++, bitpos += size) {
> -		f = (xfs_dinode_fmt_t)getbitval(obj, bitpos, size, BVSIGNED);
> +		f = (xfs_dinode_fmt_t)getbitval(obj, bitpos, size, BVUNSIGNED);
>  		if (array)
>  			dbprintf("%d:", i + base);
>  		if (f < 0 || f >= dinode_fmt_name_size)
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
