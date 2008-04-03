Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 19:50:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m332oDTX017472
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 19:50:17 -0700
Date: Wed, 2 Apr 2008 22:34:34 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 4/7] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080403023434.GF5211@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.654277049@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.654277049@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:12PM +1000, Barry Naujok wrote:
...
> +	/*
> +	 * Directory with a 'disconnected' dentry; get a reference to the
> +	 * 'disconnected' dentry.
> +	 */
> +	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);

list_first_entry does the .next for you.

...
> --- kern_ci.orig/fs/xfs/xfs_da_btree.c
> +++ kern_ci/fs/xfs/xfs_da_btree.c
> @@ -2176,6 +2176,22 @@ xfs_da_reada_buf(
>  		return rval;
>  }
>  
> +
> +kmem_zone_t	*xfs_da_name_zone;
> +
> +uchar_t *
> +xfs_da_name_alloc(void)
> +{
> +	return kmem_zone_zalloc(xfs_da_name_zone, KM_SLEEP);
> +}
> +
> +void
> +xfs_da_name_free(const uchar_t *name)

Since you don't care about the type anyway, you might want to make it void*,
and remove the cast from the lookup_ci code.

> +{
> +	kmem_zone_free(xfs_da_name_zone, (void *)name);

No need for the cast.

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

Perhaps having a static inline xfs_da_name_dup(...) would be useful...

...
> --- kern_ci.orig/fs/xfs/xfs_vnodeops.c
> +++ kern_ci/fs/xfs/xfs_vnodeops.c
> @@ -1762,24 +1762,33 @@ xfs_inactive(
>  int
>  xfs_lookup(
>  	xfs_inode_t		*dp,
> -	bhv_vname_t		*dentry,
> -	xfs_inode_t		**ipp)
> +	bhv_vstr_t		*d_name,
> +	xfs_inode_t		**ipp,
> +	bhv_vstr_t		*ci_name)
>  {
>  	xfs_inode_t		*ip;
>  	xfs_ino_t		e_inum;
>  	int			error;
>  	uint			lock_mode;
> +	xfs_name_t		name, rname;
>  
>  	xfs_itrace_entry(dp);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return XFS_ERROR(EIO);
>  
> +	name.name = (uchar_t *)d_name->name;

d_name->name is: const unsigned char*
name.name is:	 const uchar_t*

Is there any reason why you use uchar_t - beyond the other parts of XFS use
it? (I guess this is the same question that I asked before - coding style.)

xfs_types.h defines uchar_t as unsigned char...

Josef 'Jeff' Sipek.

-- 
Defenestration n. (formal or joc.):
  The act of removing Windows from your computer in disgust, usually
  followed by the installation of Linux or some other Unix-like operating
  system.
