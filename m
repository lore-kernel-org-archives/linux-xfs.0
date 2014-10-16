Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDFDE7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 16:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F08F8F8039
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 14:05:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6ETOOeMFB6NCs9S8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 14:05:00 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9GL4xxC020659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 17:04:59 -0400
Date: Thu, 16 Oct 2014 17:04:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs_vn_rename by xfs_vn_rename2
Message-ID: <20141016210457.GA33732@bfoster.bfoster>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
	<1413397042-32229-2-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413397042-32229-2-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 15, 2014 at 03:17:21PM -0300, Carlos Maiolino wrote:
> To be able to support RENAME_EXCHANGE flag from renameat2() system call, XFS
> must have its inode_operations updated, exporting .rename2 method, instead of
> .rename.
> 
> This patch just replaces the (now old) .rename method by .rename2, using the
> same infra-structure, but checking rename flags.
> 
> calls to .rename2 using RENAME_EXCHANGE flag, although now handled inside XFS,
> still returns -EINVAL.
> 
> RENAME_NOREPLACE is handled via VFS and we don't need to care about it inside
> xfs_vn_rename2.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_iops.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 7212949..b2b92c7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -379,22 +379,27 @@ xfs_vn_symlink(
>  }
>  
>  STATIC int
> -xfs_vn_rename(
> +xfs_vn_rename2(

The function rename seems unnecessary..? Meh, not a big deal to me
either way. Otherwise, this one seems Ok.

Brian

>  	struct inode	*odir,
>  	struct dentry	*odentry,
>  	struct inode	*ndir,
> -	struct dentry	*ndentry)
> +	struct dentry	*ndentry,
> +	unsigned int	flags)
>  {
>  	struct inode	*new_inode = ndentry->d_inode;
>  	struct xfs_name	oname;
>  	struct xfs_name	nname;
>  
> +	/* XFS does not support RENAME_EXCHANGE yet */
> +	if (flags & ~RENAME_NOREPLACE)
> +		return -EINVAL;
> +
>  	xfs_dentry_to_name(&oname, odentry, 0);
>  	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
>  
>  	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
> -			  XFS_I(ndir), &nname, new_inode ?
> -						XFS_I(new_inode) : NULL);
> +			  XFS_I(ndir), &nname,
> +			  new_inode ? XFS_I(new_inode) : NULL);
>  }
>  
>  /*
> @@ -1117,7 +1122,7 @@ static const struct inode_operations xfs_dir_inode_operations = {
>  	 */
>  	.rmdir			= xfs_vn_unlink,
>  	.mknod			= xfs_vn_mknod,
> -	.rename			= xfs_vn_rename,
> +	.rename2		= xfs_vn_rename2,
>  	.get_acl		= xfs_get_acl,
>  	.set_acl		= xfs_set_acl,
>  	.getattr		= xfs_vn_getattr,
> @@ -1145,7 +1150,7 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
>  	 */
>  	.rmdir			= xfs_vn_unlink,
>  	.mknod			= xfs_vn_mknod,
> -	.rename			= xfs_vn_rename,
> +	.rename2		= xfs_vn_rename2,
>  	.get_acl		= xfs_get_acl,
>  	.set_acl		= xfs_set_acl,
>  	.getattr		= xfs_vn_getattr,
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
