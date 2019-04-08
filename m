Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHFsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 01:48:18 -0400
Subject: Re: [PATCH 2/4] xfs: unlock inode when xfs_ioctl_setattr_get_trans
 can't get transaction
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
 <155466883603.633834.5683596746694707981.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0342fa7f-23f3-2acf-f40f-c485e66d4762@oracle.com>
Date: Sun, 7 Apr 2019 22:48:08 -0700
MIME-Version: 1.0
In-Reply-To: <155466883603.633834.5683596746694707981.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Looks ok:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 4/7/19 1:27 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We passed an inode into xfs_ioctl_setattr_get_trans with join_flags
> indicating which locks are held on that inode.  If we can't allocate a
> transaction then we need to unlock the inode before we bail out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6ecdbb3af7de..91938c4f3c67 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1142,7 +1142,7 @@ xfs_ioctl_setattr_get_trans(
>   
>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
>   	if (error)
> -		return ERR_PTR(error);
> +		goto out_unlock;
>   
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | join_flags);
> 
