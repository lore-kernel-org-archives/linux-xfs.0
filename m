Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42990 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933672AbcKDTLW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 15:11:22 -0400
Subject: Re: [PATCH 4/6] libxfs: fix xfs_attr_shortform_bytesfit declaration
References: <147828429514.31793.3070284385118900515.stgit@birch.djwong.org>
 <147828432194.31793.10820468139447856863.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fee4c0ec-f461-dd38-823b-d35c4d66ef80@sandeen.net>
Date: Fri, 4 Nov 2016 14:11:21 -0500
MIME-Version: 1.0
In-Reply-To: <147828432194.31793.10820468139447856863.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

On 11/4/16 1:32 PM, Darrick J. Wong wrote:
> Change the xfs_attr_shortform_bytesfit declaration to have
> struct xfs_inode to avoid tripping up the libxfs-diff scanner.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I s'pose, though the function itself still uses xfs_inode_t ...
for another day I guess.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 4f2aed0..8ef420a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -51,7 +51,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> -int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
> +int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
