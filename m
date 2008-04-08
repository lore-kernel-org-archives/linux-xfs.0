Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 22:13:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m385CvmS009243
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 22:13:01 -0700
Date: Tue, 8 Apr 2008 15:13:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] cleanup - remove bhv_vname_t
Message-ID: <20080408051324.GW108924158@sgi.com>
References: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t89zp3j63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Tue, Apr 08, 2008 at 02:50:17PM +1000, Barry Naujok wrote:
> +static inline struct xfs_name *
> +xfs_dentry_name(
> +	struct xfs_name	*namep,
> +	struct dentry	*dentry)
> +{
> +	namep->name = dentry->d_name.name;
> +	namep->len = dentry->d_name.len;
> +	return namep;
> +}

xfs_dentry_to_name()

> @@ -246,20 +256,19 @@ xfs_cleanup_inode(
>  	struct dentry	*dentry,
>  	int		mode)
>  {
> -	struct dentry   teardown = {};
> +	struct xfs_name	name;

I'd leave the variable name as 'teardown'. ie.

+	struct xfs_name	teardown;

> @@ -371,12 +383,13 @@ xfs_vn_lookup(
>  	struct nameidata *nd)
>  {
>  	struct xfs_inode *cip;
> +	struct xfs_name	name;
>  	int		error;
> 
>  	if (dentry->d_name.len >= MAXNAMELEN)
>  		return ERR_PTR(-ENAMETOOLONG);
> 
> -	error = xfs_lookup(XFS_I(dir), dentry, &cip);
> +	error = xfs_lookup(XFS_I(dir), xfs_dentry_name(&name, dentry), &cip);

I'd prefer this to be separate operations:

+	xfs_dentry_to_name(&name, dentry);
+	error = xfs_lookup(XFS_I(dir), &name, &cip);

that way it's clear that we're passing name down the stack....

Same for all the others....

> @@ -489,9 +509,12 @@ xfs_vn_rename(
>  	struct dentry	*ndentry)
>  {
>  	struct inode	*new_inode = ndentry->d_inode;
> +	struct xfs_name	oname, nname;

+	struct xfs_name	oname;
+	struct xfs_name	nname;

......

> -	args.hashval = xfs_da_hashname(name, namelen);
> +	args.name = name->name;
> +	args.namelen = name->len;
> +	args.hashval = xfs_da_hashname(name->name, name->len);

Seems like future work would be to drive the xfs_name_t further
into these leaf functions....

> @@ -83,17 +83,16 @@ int xfs_rename_skip, xfs_rename_nskip;
>   */
>  STATIC int
>  xfs_lock_for_rename(
> -	xfs_inode_t	*dp1,	/* old (source) directory inode */
> -	xfs_inode_t	*dp2,	/* new (target) directory inode */
> -	bhv_vname_t	*vname1,/* old entry name */
> -	bhv_vname_t	*vname2,/* new entry name */
> -	xfs_inode_t	**ipp1,	/* inode of old entry */
> -	xfs_inode_t	**ipp2,	/* inode of new entry, if it
> +	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
> +	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
> +	xfs_name_t	*name2,	/* in: new entry name */
> +	xfs_inode_t	**ipp1,	/* in/out: inode of old entry */
> +	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
>  				   already exists, NULL otherwise. */
> -	xfs_inode_t	**i_tab,/* array of inode returned, sorted */
> -	int		*num_inodes)  /* number of inodes in array */
> +	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
> +	int		*num_inodes)  /* out: number of inodes in array */
>  {
> -	xfs_inode_t		*ip1 = VNAME_TO_INODE(vname1);
> +	xfs_inode_t		*ip1;
>  	xfs_inode_t		*ip2, *temp;
>  	xfs_ino_t		inum1, inum2;
>  	int			error;
> @@ -101,6 +100,7 @@ xfs_lock_for_rename(
>  	uint			lock_mode;
>  	int			diff_dirs = (dp1 != dp2);
> 
> +	ip1 = *ipp1;
>  	ip2 = NULL;

	ASSERT(ip1);
.....
>  	 * Initially assume that the file does not exist and
>  	 * reserve the resources for that case.  If that is not
> @@ -1883,7 +1879,7 @@ xfs_create(
>  	if (error)
>  		goto error_return;
> 
> -	if (resblks == 0 && (error = xfs_dir_canenter(tp, dp, name, 
> namelen)))
> +	if (resblks == 0 && (error = xfs_dir_canenter(tp, dp, name)))
>  		goto error_return;

If you're touching lines like that, you should restructure it at the
same time to match accepted style more closely.

	if (!resblks) {
		error = xfs_dir_canenter(tp, dp, name);
		if (error)
			goto error_return;
	}

> @@ -2567,12 +2558,12 @@ xfs_link(
>  	}
> 
>  	if (resblks == 0 &&
> -	    (error = xfs_dir_canenter(tp, tdp, target_name, target_namelen)))
> +	    (error = xfs_dir_canenter(tp, tdp, target_name)))
>  		goto error_return;

Same again.

> @@ -2719,7 +2708,7 @@ xfs_mkdir(
>  		goto error_return;
> 
>  	if (resblks == 0 &&
> -	    (error = xfs_dir_canenter(tp, dp, dir_name, dir_namelen)))
> +	    (error = xfs_dir_canenter(tp, dp, dir_name)))
>  		goto error_return;

more!

> @@ -3201,7 +3184,7 @@ xfs_symlink(
>  	 * Check for ability to enter directory entry, if no space reserved.
>  	 */
>  	if (resblks == 0 &&
> -	    (error = xfs_dir_canenter(tp, dp, link_name, link_namelen)))
> +	    (error = xfs_dir_canenter(tp, dp, link_name)))
>  		goto error_return;

how many times do we do almost the same thing? :P

Looks pretty good, otherwise....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
