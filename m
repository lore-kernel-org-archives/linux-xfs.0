Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 22:22:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m335LmG7010509
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 22:21:52 -0700
Date: Thu, 3 Apr 2008 15:22:09 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080403052209.GR103491721@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.654277049@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.654277049@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:12PM +1000, Barry Naujok wrote:
> This implements the code to store the actual filename found
> during a lookup in the dentry cache and to avoid multiple entries
> in the dcache pointing to the same inode.
> 
> It also introduces a new type, xfs_name, which is similar to the
> dentry cache's qstr type. It contains a pointer to a zone allocated
> string (MAXNAMELEN sized) and the length of the actual name. This
> string does not need to be NULL terminated (a counted string).
> 
> xfs_name_t is only used in the lookup path for this patch, but may
> be used in other locations too if desired. It maybe desirable not
> to use xfs_name_t at all in the lookup functions but stick to
> separate parameters (which will mean 7 instead of 5 arguments).
> 
> To avoid polluting the dcache, we implement a new directory inode
> operations for lookup. xfs_vn_ci_lookup() interacts directly with
> the dcache and the code was derived from ntfs_lookup() in
> fs/ntfs/namei.c. The dentry hash and compare overrides introduced
> in the ASCII-CI patch has been removed.
> 
> The "actual name" is only allocated and returned for a case-
> insensitive match and not an actual match.

> +STATIC struct dentry *
> +xfs_vn_ci_lookup(
> +	struct inode	*dir,
> +	struct dentry	*dentry,
> +	struct nameidata *nd)
> +{
> +	struct xfs_inode *cip;
> +	int		error;
>  	struct dentry	*result;
> +	struct qstr	ci_name = {0, 0, NULL};
> +	struct inode	*inode;
>  
>  	if (dentry->d_name.len >= MAXNAMELEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	if (xfs_sb_version_hasoldci(&mp->m_sb))
> -		dentry->d_op = &xfs_ci_dentry_operations;
> +	error = xfs_lookup(XFS_I(dir), &dentry->d_name, &cip, &ci_name);

Bit confusing with cip = "child inode" and ci_name = "case insensitive".
i.e. same prefix, different meanings...

>  
> -	error = xfs_lookup(XFS_I(dir), dentry, &cip);
>  	if (unlikely(error)) {
>  		if (unlikely(error != ENOENT))
>  			return ERR_PTR(-error);
>  		d_add(dentry, NULL);
>  		return NULL;
>  	}
> +	inode = cip->i_vnode;
> +
> +	/* if exact match, just splice and exit */
> +	if (!ci_name.name) {
> +		result = d_splice_alias(inode, dentry);
> +		return result;
> +	}

	if (!ci_name.name)
		return d_splice_alias(inode, dentry);

>  
> -	result = d_splice_alias(cip->i_vnode, dentry);
> -	if (result)
> -		result->d_op = dentry->d_op;
> -	return result;
> +	/*
> +	 * case-insensitive match, create a dentry to return and fill it
> +	 * in with the correctly cased name. Parameter "dentry" is not
> +	 * used anymore and the caller will free it.
> +	 * Derived from fs/ntfs/namei.c
> +	 */
> +
> +	ci_name.hash = full_name_hash(ci_name.name, ci_name.len);
> +
> +	/* Does an existing dentry match? */
> +	result = d_lookup(dentry->d_parent, &ci_name);
> +	if (!result) {
> +		/* if not, create one */
> +		result = d_alloc(dentry->d_parent, &ci_name);
> +		xfs_da_name_free((char *)ci_name.name);
> +		if (!result)
> +			return ERR_PTR(-ENOMEM);
> +		dentry = d_splice_alias(inode, result);
> +		if (dentry) {
> +			dput(result);
> +			return dentry;
> +		}
> +		return result;
> +	}

This looks like it came from the ntfs code - i find that much easier
to follow with "real_dent" and "new_dent" instead of "result" and "dentry"
respectively.

> +	xfs_da_name_free((char *)ci_name.name);
> +
> +	/* an existing dentry matches, use it */

Ah, I see the rest of this is basically a copy and paste of the ntfs code
(without some of the useful comments). I think a generic helper function
is in order here that contains all the coments from the ntfs code....

> +
> +	if (result->d_inode) {
> +		/*
> +		 * already an inode attached, deref the inode that was
> +		 * refcounted with xfs_lookup and return the dentry.
> +		 */
> +		if (unlikely(result->d_inode != inode)) {
> +			/* This can happen because bad inodes are unhashed. */
> +			BUG_ON(!is_bad_inode(inode));
> +			BUG_ON(!is_bad_inode(result->d_inode));

Bit drastic - how about failing the lookup and returning EIO in this case?

> +		}
> +		iput(inode);
> +		return result;
> +	}

.....
> Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
> +++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
> @@ -566,7 +566,10 @@ xfs_set_inodeops(
>  		inode->i_mapping->a_ops = &xfs_address_space_operations;
>  		break;
>  	case S_IFDIR:
> -		inode->i_op = &xfs_dir_inode_operations;
> +		inode->i_op =
> +			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ?

+			xfs_sb_version_hasoldci(&XFS_M(inode->i_sb)->m_sb) ?
	
> +	xfs_ino_t	*inum,		/* out: inode number */
> +	xfs_name_t	*ci_name)	/* out: actual name if different */
>  {
>  	xfs_da_args_t	args;
>  	int		rval;
> @@ -259,9 +260,9 @@ xfs_dir_lookup(
>  	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
>  	XFS_STATS_INC(xs_dir_lookup);
>  
> -	args.name = name;
> -	args.namelen = namelen;
> -	args.hashval = xfs_dir_hashname(dp, name, namelen);
> +	args.name = name->name;
> +	args.namelen = name->len;
> +	args.hashval = xfs_dir_hashname(dp, name->name, name->len);
>  	args.inumber = 0;
>  	args.dp = dp;
>  	args.firstblock = NULL;
> @@ -272,6 +273,8 @@ xfs_dir_lookup(
>  	args.justcheck = args.addname = 0;
>  	args.oknoent = 1;
>  	args.cmpresult = XFS_CMP_DIFFERENT;
> +	args.value = NULL;
> +	args.valuelen = 0;

Rather than initialising more of the args to zero (already 7 members
explicitly initialised to zero or NULL), change it to:

	memset(&args, 0, sizeof(xfs_da_args_t));
	args.name = name->name;
	args.namelen = name->len;
	args.hashval = xfs_dir_hashname(dp, name->name, name->len);
	args.dp = dp;
	args.whichfork = XFS_DATA_FORK;
	args.trans = tp;
	args.oknoent = 1;
	args.cmpresult = XFS_CMP_DIFFERENT;

>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_lookup(&args);
> @@ -287,8 +290,17 @@ xfs_dir_lookup(
>  		rval = xfs_dir2_node_lookup(&args);
>  	if (rval == EEXIST)
>  		rval = 0;
> -	if (rval == 0)
> +	if (rval == 0) {

	if (!rval) {
> Index: kern_ci/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_dir2_block.c
> +++ kern_ci/fs/xfs/xfs_dir2_block.c
> @@ -616,6 +616,15 @@ xfs_dir2_block_lookup(
>  	 * Fill in inode number, release the block.
>  	 */
>  	args->inumber = be64_to_cpu(dep->inumber);
> +	/*
> +	 * If a case-insensitive match, allocate a buffer and copy the actual
> +	 * name into the buffer. Return it via args->value.
> +	 */
> +	if (args->cmpresult == XFS_CMP_CASE) {
> +		args->value = xfs_da_name_alloc();
> +		memcpy(args->value, dep->name, dep->namelen);
> +		args->valuelen = dep->namelen;

		xfs_da_ci_name_dup();
> +	}
>  	xfs_da_brelse(args->trans, bp);
>  	return XFS_ERROR(EEXIST);
>  }
> Index: kern_ci/fs/xfs/xfs_dir2_leaf.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_dir2_leaf.c
> +++ kern_ci/fs/xfs/xfs_dir2_leaf.c
> @@ -1301,6 +1301,15 @@ xfs_dir2_leaf_lookup(
>  	 * Return the found inode number.
>  	 */
>  	args->inumber = be64_to_cpu(dep->inumber);
> +	/*
> +	 * If a case-insensitive match, allocate a buffer and copy the actual
> +	 * name into the buffer. Return it via args->value.
> +	 */
> +	if (args->cmpresult == XFS_CMP_CASE) {
> +		args->value = xfs_da_name_alloc();
> +		memcpy(args->value, dep->name, dep->namelen);
> +		args->valuelen = dep->namelen;

		xfs_da_ci_name_dup();
> +	}
>  	xfs_da_brelse(tp, dbp);
>  	xfs_da_brelse(tp, lbp);
>  	return XFS_ERROR(EEXIST);
> Index: kern_ci/fs/xfs/xfs_dir2_node.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_dir2_node.c
> +++ kern_ci/fs/xfs/xfs_dir2_node.c
> @@ -643,6 +643,8 @@ xfs_dir2_leafn_lookup_for_entry(
>  			xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
>  		/*
>  		 * Compare the entry, return it if it matches.
> +		 * "oknoent" is set for lookup and clear for
> +		 * remove and replace.
>  		 */

That should have been in an earlier patch....

>  		cmp = args->oknoent ?
>  			xfs_dir_compname(dp, dep->name, dep->namelen,
> @@ -1857,10 +1859,22 @@ xfs_dir2_node_lookup(
>  	if (error)
>  		rval = error;
>  	/*
> -	 * If case-insensitive match was found in a leaf, return EEXIST.
> -	 */
> -	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE)
> +	 * If case-insensitive match was found (xfs_dir2_leafn_lookup_int
> +	 * returns ENOENT for a case-insensitive match, but sets
> +	 * args->cmpresult to XFS_CMP_CASE):
> +	 *   - Allocate a buffer and copy the actual name into the buffer and
> +	 *       return it via args->value.
> +	 *   - set rval to EEXIST
> +	 */
> +	else if (rval == ENOENT && args->cmpresult == XFS_CMP_CASE) {
> +		xfs_dir2_data_entry_t	*dep = (xfs_dir2_data_entry_t *)
> +					((char *)state->extrablk.bp->data +
> +						state->extrablk.index);
> +		args->value = xfs_da_name_alloc();
> +		memcpy(args->value, dep->name, dep->namelen);
> +		args->valuelen = dep->namelen;
>  		rval = EEXIST;
> +	}

Yeah, more reason to move the comment inside the if block....

oh, and xfs_da_ci_name_dup()....

> -	if (args->cmpresult == XFS_CMP_CASE)
> +	if (args->cmpresult == XFS_CMP_CASE) {
> +		/*
> +		 * If a case-insensitive match, allocate a buffer and copy the
> +		 * actual name into the buffer and return it via args->value.
> +		 */
> +		args->value = xfs_da_name_alloc();
> +		memcpy(args->value, ci_sfep->name, ci_sfep->namelen);
> +		args->valuelen = ci_sfep->namelen;

		xfs_da_ci_name_dup()

> --- kern_ci.orig/fs/xfs/xfs_utils.c
> +++ kern_ci/fs/xfs/xfs_utils.c
> @@ -24,6 +24,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
>  #include "xfs_ag.h"
> +#include "xfs_da_btree.h"

What's that needed for? What ever it is, i think you've put it
in the wrong header file....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
