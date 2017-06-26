Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18837 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFZPwg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 11:52:36 -0400
Date: Mon, 26 Jun 2017 08:52:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/11] xfs: Don't clear SGID when inheriting ACLs
Message-ID: <20170626155227.GE4733@birch.djwong.org>
References: <20170622133115.16968-1-jack@suse.cz>
 <20170622133115.16968-12-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622133115.16968-12-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 22, 2017 at 03:31:15PM +0200, Jan Kara wrote:
> When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> set, DIR1 is expected to have SGID bit set (and owning group equal to
> the owning group of 'DIR0'). However when 'DIR0' also has some default
> ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> 'DIR1' to get cleared if user is not member of the owning group.
> 
> Fix the problem by calling __xfs_set_acl() instead of xfs_set_acl() when
> setting up inode in xfs_generic_create(). That prevents SGID bit
> clearing and mode is properly set by posix_acl_create() anyway. We also
> reorder arguments of __xfs_set_acl() to match the ordering of
> xfs_set_acl() to make things consistent.
> 
> Fixes: 073931017b49d9458aa351605b43a7e34598caef
> CC: stable@vger.kernel.org
> CC: Darrick J. Wong <darrick.wong@oracle.com>
> CC: linux-xfs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks ok, will pull into xfs tree...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_acl.c  | 6 +++---
>  fs/xfs/xfs_acl.h  | 1 +
>  fs/xfs/xfs_iops.c | 4 ++--
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index b468e041f207..7034e17535de 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -170,8 +170,8 @@ xfs_get_acl(struct inode *inode, int type)
>  	return acl;
>  }
>  
> -STATIC int
> -__xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
> +int
> +__xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
>  	unsigned char *ea_name;
> @@ -268,5 +268,5 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>  	}
>  
>   set_acl:
> -	return __xfs_set_acl(inode, type, acl);
> +	return __xfs_set_acl(inode, acl, type);
>  }
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 286fa89217f5..04327318ef67 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -24,6 +24,7 @@ struct posix_acl;
>  #ifdef CONFIG_XFS_POSIX_ACL
>  extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
>  extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
> +extern int __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  #else
>  static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
>  {
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ebfc13350f9a..077e2b2ac773 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -190,12 +190,12 @@ xfs_generic_create(
>  
>  #ifdef CONFIG_XFS_POSIX_ACL
>  	if (default_acl) {
> -		error = xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
> +		error = __xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
>  		if (error)
>  			goto out_cleanup_inode;
>  	}
>  	if (acl) {
> -		error = xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
> +		error = __xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
>  		if (error)
>  			goto out_cleanup_inode;
>  	}
> -- 
> 2.12.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
