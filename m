Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31274 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755598AbdAJXQH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 18:16:07 -0500
Date: Tue, 10 Jan 2017 15:15:50 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 5/6] xfs: sanity check inode mode when creating new
 dentry
Message-ID: <20170110231550.GO14038@birch.djwong.org>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
 <1484062757-12433-6-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484062757-12433-6-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 05:39:16PM +0200, Amir Goldstein wrote:
> The helper xfs_dentry_to_name() is used by 2 different
> classes of callers: Callers that pass zero mode and don't care
> about the returned name.type field and Callers that pass
> non zero mode and do care about the name.type field.
> 
> Change xfs_dentry_to_name() to not take the mode argument and
> change the call sites of the first class to not pass the mode
> argument.
> 
> Create a new helper xfs_dentry_mode_to_name() which does pass
> the mode argument and returns -EFSCORRUPTED if mode is invalid.
> Callers that translate non zero mode to on-disk file type now
> check the return value and will export the error to user instead
> of staging an invalid file type to be written to directory entry.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/xfs_iops.c | 47 ++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 821f08d..ef38d0f 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -98,12 +98,27 @@ xfs_init_security(
>  static void
>  xfs_dentry_to_name(
>  	struct xfs_name	*namep,
> +	struct dentry	*dentry)
> +{
> +	namep->name = dentry->d_name.name;
> +	namep->len = dentry->d_name.len;
> +	namep->type = XFS_DIR3_FT_UNKNOWN;
> +}
> +
> +static int
> +xfs_dentry_mode_to_name(
> +	struct xfs_name	*namep,
>  	struct dentry	*dentry,
>  	int		mode)
>  {
>  	namep->name = dentry->d_name.name;
>  	namep->len = dentry->d_name.len;
>  	namep->type = xfs_mode_to_ftype(mode);
> +
> +	if (unlikely(namep->type == XFS_DIR3_FT_UNKNOWN))
> +		return -EFSCORRUPTED;
> +
> +	return 0;
>  }
>  
>  STATIC void
> @@ -119,7 +134,7 @@ xfs_cleanup_inode(
>  	 * xfs_init_security we must back out.
>  	 * ENOSPC can hit here, among other things.
>  	 */
> -	xfs_dentry_to_name(&teardown, dentry, 0);
> +	xfs_dentry_to_name(&teardown, dentry);
>  
>  	xfs_remove(XFS_I(dir), &teardown, XFS_I(inode));
>  }
> @@ -154,8 +169,12 @@ xfs_generic_create(
>  	if (error)
>  		return error;
>  
> +	/* Verify mode is valid also for tmpfile case */
> +	error = xfs_dentry_mode_to_name(&name, dentry, mode);
> +	if (unlikely(error))
> +		goto out_free_acl;
> +
>  	if (!tmpfile) {
> -		xfs_dentry_to_name(&name, dentry, mode);
>  		error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
>  	} else {
>  		error = xfs_create_tmpfile(XFS_I(dir), dentry, mode, &ip);
> @@ -248,7 +267,7 @@ xfs_vn_lookup(
>  	if (dentry->d_name.len >= MAXNAMELEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	xfs_dentry_to_name(&name, dentry, 0);
> +	xfs_dentry_to_name(&name, dentry);
>  	error = xfs_lookup(XFS_I(dir), &name, &cip, NULL);
>  	if (unlikely(error)) {
>  		if (unlikely(error != -ENOENT))
> @@ -275,7 +294,7 @@ xfs_vn_ci_lookup(
>  	if (dentry->d_name.len >= MAXNAMELEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	xfs_dentry_to_name(&xname, dentry, 0);
> +	xfs_dentry_to_name(&xname, dentry);
>  	error = xfs_lookup(XFS_I(dir), &xname, &ip, &ci_name);
>  	if (unlikely(error)) {
>  		if (unlikely(error != -ENOENT))
> @@ -310,7 +329,9 @@ xfs_vn_link(
>  	struct xfs_name	name;
>  	int		error;
>  
> -	xfs_dentry_to_name(&name, dentry, inode->i_mode);
> +	error = xfs_dentry_mode_to_name(&name, dentry, inode->i_mode);
> +	if (unlikely(error))
> +		return error;
>  
>  	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
>  	if (unlikely(error))
> @@ -329,7 +350,7 @@ xfs_vn_unlink(
>  	struct xfs_name	name;
>  	int		error;
>  
> -	xfs_dentry_to_name(&name, dentry, 0);
> +	xfs_dentry_to_name(&name, dentry);
>  
>  	error = xfs_remove(XFS_I(dir), &name, XFS_I(d_inode(dentry)));
>  	if (error)
> @@ -359,7 +380,8 @@ xfs_vn_symlink(
>  
>  	mode = S_IFLNK |
>  		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
> -	xfs_dentry_to_name(&name, dentry, mode);
> +	error = xfs_dentry_mode_to_name(&name, dentry, mode);
> +	ASSERT(error == 0);

Why not the usual 'if (error) goto out;' here?

--D

>  
>  	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip);
>  	if (unlikely(error))
> @@ -395,6 +417,7 @@ xfs_vn_rename(
>  {
>  	struct inode	*new_inode = d_inode(ndentry);
>  	int		omode = 0;
> +	int		error;
>  	struct xfs_name	oname;
>  	struct xfs_name	nname;
>  
> @@ -405,8 +428,14 @@ xfs_vn_rename(
>  	if (flags & RENAME_EXCHANGE)
>  		omode = d_inode(ndentry)->i_mode;
>  
> -	xfs_dentry_to_name(&oname, odentry, omode);
> -	xfs_dentry_to_name(&nname, ndentry, d_inode(odentry)->i_mode);
> +	error = xfs_dentry_mode_to_name(&oname, odentry, omode);
> +	if (omode && unlikely(error))
> +		return error;
> +
> +	error = xfs_dentry_mode_to_name(&nname, ndentry,
> +					d_inode(odentry)->i_mode);
> +	if (unlikely(error))
> +		return error;
>  
>  	return xfs_rename(XFS_I(odir), &oname, XFS_I(d_inode(odentry)),
>  			  XFS_I(ndir), &nname,
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
