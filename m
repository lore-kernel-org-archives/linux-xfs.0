Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751386AbdAYMoM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 07:44:12 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 509703A76B5
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 12:44:13 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0PCiDEs020242
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2017 07:44:13 -0500
Date: Wed, 25 Jan 2017 07:44:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: remove racy hasattr check from attr ops
Message-ID: <20170125124411.GA28388@bfoster.bfoster>
References: <1483975378-23483-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483975378-23483-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Jan 09, 2017 at 10:22:58AM -0500, Brian Foster wrote:
> xfs_attr_[get|remove]() have unlocked attribute fork checks to optimize
> away a lock cycle in cases where the fork does not exist or is otherwise
> empty. This check is not safe, however, because an attribute fork short
> form to extent format conversion includes a transient state that causes
> the xfs_inode_hasattr() check to fail. Specifically,
> xfs_attr_shortform_to_leaf() creates an empty extent format attribute
> fork and then adds the existing shortform attributes to it.
> 
> This means that lookup of an existing xattr can spuriously return
> -ENOATTR when racing against a setxattr that causes the associated
> format conversion. This was originally reproduced by an untar on a
> particularly configured glusterfs volume, but can also be reproduced on
> demand with properly crafted xattr requests.
> 
> The format conversion occurs under the exclusive ilock. xfs_attr_get()
> and xfs_attr_remove() already have the proper locking and checks further
> down in the functions to handle this situation correctly. Drop the
> unlocked checks to avoid the spurious failure and rely on the existing
> logic.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 

Ping. Any chance of getting this one in soonish?

Brian

> v2:
> - Fix up xfs_attr_remove() as well.
> v1: https://patchwork.kernel.org/patch/9501675/
> 
>  fs/xfs/libxfs/xfs_attr.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index af1ecb1..6622d46 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -131,9 +131,6 @@ xfs_attr_get(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	if (!xfs_inode_hasattr(ip))
> -		return -ENOATTR;
> -
>  	error = xfs_attr_args_init(&args, ip, name, flags);
>  	if (error)
>  		return error;
> @@ -392,9 +389,6 @@ xfs_attr_remove(
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	if (!xfs_inode_hasattr(dp))
> -		return -ENOATTR;
> -
>  	error = xfs_attr_args_init(&args, dp, name, flags);
>  	if (error)
>  		return error;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
