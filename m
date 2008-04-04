Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 17:04:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3404jhb028471
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 17:04:48 -0700
Date: Fri, 4 Apr 2008 10:05:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 6/7] XFS: Native Language Support for Unicode in XFS
Message-ID: <20080404000511.GV103491721@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.286398420@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080402062709.286398420@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:14PM +1000, Barry Naujok wrote:
> Implement the "-o nls=<charset>" mount option and required conversion 
> of older style charater sets to/from UTF-8 to support non-UTF8 locales. 
> This option is compatible with other Linux filesystems supporting
> the "nls" mount option.
> 
> NLS conversion is performed on filename operations including readdir and
> also user domain extended attribute names. The name zone defined in
> the "return name" patch is used for temporarily holding the converted
> name.
> 
> If Unicode is not configed Y, then the NLS support is virtually a no-op.
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> 
> ---
>  fs/xfs/linux-2.6/xfs_linux.h |    5 +
>  fs/xfs/linux-2.6/xfs_super.c |   21 ++++++
>  fs/xfs/xfs_attr.c            |   78 +++++++++++++++---------
>  fs/xfs/xfs_attr.h            |    6 -
>  fs/xfs/xfs_attr_leaf.c       |   74 ++++++++++++++++-------
>  fs/xfs/xfs_clnt.h            |    1 
>  fs/xfs/xfs_dir2_block.c      |   14 +++-
>  fs/xfs/xfs_dir2_leaf.c       |   15 ++++
>  fs/xfs/xfs_dir2_sf.c         |   12 +++
>  fs/xfs/xfs_mount.h           |    2 
>  fs/xfs/xfs_rename.c          |   12 +++
>  fs/xfs/xfs_unicode.c         |  137 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_unicode.h         |   16 +++++
>  fs/xfs/xfs_vfsops.c          |   21 ++++++
>  fs/xfs/xfs_vnodeops.c        |  117 +++++++++++++++++++++++++-----------
>  15 files changed, 429 insertions(+), 102 deletions(-)
> 
> Index: kern_ci/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_linux.h
> +++ kern_ci/fs/xfs/linux-2.6/xfs_linux.h
> @@ -181,6 +181,11 @@
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
>  
>  /*
> + * NLS UTF-8 (unicode) character set
> + */
> +#define XFS_NLS_UTF8	"utf8"
> +
> +/*
>   * Various platform dependent calls that don't fit anywhere else
>   */
>  #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
> Index: kern_ci/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- kern_ci.orig/fs/xfs/linux-2.6/xfs_super.c
> +++ kern_ci/fs/xfs/linux-2.6/xfs_super.c
> @@ -126,6 +126,7 @@ xfs_args_allocate(
>  #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
>  #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
>  #define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir lookup */
> +#define MNTOPT_NLS	"nls"		/* NLS code page to use */
>  #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
>  #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
>  #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */
> @@ -320,9 +321,20 @@ xfs_parseargs(
>  			args->flags &= ~XFSMNT_ATTR2;
>  		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
>  			args->flags2 |= XFSMNT2_FILESTREAMS;
> +#ifdef CONFIG_XFS_UNICODE
>  		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
>  			args->flags2 |= XFSMNT2_CILOOKUP;
> -#ifndef CONFIG_XFS_UNICODE
> +		} else if (!strcmp(this_char, MNTOPT_NLS)) {
> +			if (!value || !*value) {
> +				cmn_err(CE_WARN,
> +					"XFS: %s option requires an argument",
> +					this_char);
> +				return EINVAL;
> +			}
> +			strncpy(args->nls, value, MAXNAMELEN);
> +#else
> +		} else if (!strcmp(this_char, MNTOPT_CILOOKUP) ||
> +			   !strcmp(this_char, MNTOPT_NLS)) {
>  			cmn_err(CE_WARN,
>  				"XFS: %s option requires Unicode support",
>  				this_char);

Parse these options unconditionally - reject them later once we
have all the info we need off disk (as has been previously suggested).

>   *========================================================================*/
>  
>  int
> -xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
> +xfs_attr_fetch(xfs_inode_t *ip, const uchar_t *name, int namelen,
>  	       char *value, int *valuelenp, int flags, struct cred *cred)

May as well change these to the standard XFS function format....

>  {
>  	xfs_da_args_t   args;
> @@ -167,6 +167,7 @@ xfs_attr_get(
>  	cred_t		*cred)
>  {
>  	int		error, namelen;
> +	const uchar_t	*uni_name;
>  
>  	XFS_STATS_INC(xs_attr_get);
>  
> @@ -176,24 +177,29 @@ xfs_attr_get(
>  	if (namelen >= MAXNAMELEN)
>  		return(EFAULT);		/* match IRIX behaviour */
>  
> +	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> +		return(EIO);
> +
>  	/* Enforce UTF-8 only for user attr names */
>  	if (xfs_sb_version_hasunicode(&ip->i_mount->m_sb) &&
>  			(flags & (ATTR_ROOT | ATTR_SECURE)) == 0) {
> -		error = xfs_unicode_validate(name, namelen);
> +		error = xfs_nls_to_unicode(ip->i_mount, name, namelen,
> +				&uni_name, &namelen);

Ok, so you are replacing the validation now with conversion.

>  		if (error)
>  			return error;
> -	}
> -	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
> -		return(EIO);
> +	} else
> +		uni_name = name;
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	error = xfs_attr_fetch(ip, name, namelen, value, valuelenp, flags, cred);
> +	error = xfs_attr_fetch(ip, uni_name, namelen, value, valuelenp,
> +				flags, cred);
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	xfs_unicode_nls_free(name, uni_name);
>  	return(error);

kill the () in the return statement while you are there....

>  	xfs_ilock(dp, XFS_ILOCK_SHARED);
>  	if (XFS_IFORK_Q(dp) == 0 ||
>  		   (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>  		    dp->i_d.di_anextents == 0)) {
>  		xfs_iunlock(dp, XFS_ILOCK_SHARED);
> +		xfs_unicode_nls_free(name, uni_name);
>  		return(XFS_ERROR(ENOATTR));

Stack the error conditions at the end of the function and jump to
them. i.e. do this here:

		error = ENOATTR;
		goto out_error;
>  	}
>  	xfs_iunlock(dp, XFS_ILOCK_SHARED);
>  
> -	return xfs_attr_remove_int(dp, name, namelen, flags);
> +	error = xfs_attr_remove_int(dp, uni_name, namelen, flags);

out_error:

> +	xfs_unicode_nls_free(name, uni_name);
> +	return error;
>  }
>  
>  int								/* error */
> @@ -658,9 +676,9 @@ xfs_attr_list_int(xfs_attr_list_context_
>   */
>  /*ARGSUSED*/
>  STATIC int
> -xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
> -		     char *name, int namelen,
> -		     int valuelen, char *value)
> +xfs_attr_user_list(xfs_attr_list_context_t *context, attrnames_t *namesp,
> +		   char *name, int namelen,
> +		   int valuelen, char *value)

Formatting.

[snip a shiteload of whitespace fixes]

>  		if (dp->i_d.di_forkoff) {
> -			if (offset < dp->i_d.di_forkoff) 
> +			if (offset < dp->i_d.di_forkoff)
>  				return 0;
> -			else 
> +			else
>  				return dp->i_d.di_forkoff;

just kill the else there.

[more whitespace]

> @@ -734,7 +738,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
>  			cursor->hashval = sbp->hash;
>  			cursor->offset = 0;
>  		}
> -		error = context->put_listent(context,
> +		error = á(context,
>  					namesp,
>  					sbp->name,
>  					sbp->namelen,

That looks completely busted ;)

> +/*
> + * Do NLS name conversion if required for user attribute names and call
> + * context's put_listent routine
> + */
> +
> +STATIC int
> +xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
> +	char *name, int namelen, int valuelen, char *value)
> +{
> +	char *nls_name;
> +	int nls_namelen;
> +	int error;
> +
> +	if (xfs_is_using_nls(context->dp->i_mount) && namesp == attr_user) {
> +		error = xfs_unicode_to_nls(context->dp->i_mount, name, namelen,
> +				&nls_name, &nls_namelen);
> +		if (error)
> +			return error;
> +		error = context->put_listent(context, namesp, nls_name,
> +				nls_namelen, valuelen, value);
> +		xfs_unicode_nls_free(name, nls_name);
> +		return error;
> +	} else
> +		return context->put_listent(context, namesp, name, namelen,
> +				valuelen, value);

Kill the else.

> @@ -513,16 +516,21 @@ xfs_dir2_block_getdents(
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
>  #endif
> -
> +		error = xfs_unicode_to_nls(mp, dep->name, dep->namelen,
> +				&nls_name, &nls_namelen);
> +		if (error)
> +			break;
>  		/*
>  		 * If it didn't fit, set the final offset to here & return.
>  		 */
> -		if (filldir(dirent, dep->name, dep->namelen, cook,
> +		if (filldir(dirent, nls_name, nls_namelen, cook,
>  			    ino, DT_UNKNOWN)) {
>  			*offset = cook;
> +			xfs_unicode_nls_free(dep->name, nls_name);
>  			xfs_da_brelse(NULL, bp);
>  			return 0;
>  		}
> +		xfs_unicode_nls_free(dep->name, nls_name);

This whole chunk is repeated inmany places with only slight
variations in error handling. A wrapper function that encompasses
this filldir callback section would be appropriate. say
xfs_dir_filldir()?

> @@ -1087,13 +1090,21 @@ xfs_dir2_leaf_getdents(
>  		ino += mp->m_inoadd;
>  #endif
>  
> +		error = xfs_unicode_to_nls(mp, dep->name, dep->namelen,
> +				&nls_name, &nls_namelen);
> +		if (error)
> +			break;
> +
>  		/*
>  		 * Won't fit.  Return to caller.
>  		 */
> -		if (filldir(dirent, dep->name, dep->namelen,
> +		if (filldir(dirent, nls_name, nls_namelen,
>  			    xfs_dir2_byte_to_dataptr(mp, curoff),
> -			    ino, DT_UNKNOWN))
> +			    ino, DT_UNKNOWN)) {
> +			xfs_unicode_nls_free(dep->name, nls_name);
>  			break;
> +		}
> +		xfs_unicode_nls_free(dep->name, nls_name);

xfs_dir_filldir()

> @@ -789,12 +793,18 @@ xfs_dir2_sf_getdents(
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
>  #endif
> +		error = xfs_unicode_to_nls(mp, sfep->name, sfep->namelen,
> +				&nls_name, &nls_namelen);
> +		if (error)
> +			return error;
>  
> -		if (filldir(dirent, sfep->name, sfep->namelen,
> +		if (filldir(dirent, nls_name, nls_namelen,
>  					    off, ino, DT_UNKNOWN)) {
>  			*offset = off;
> +			xfs_unicode_nls_free(sfep->name, nls_name);
>  			return 0;
>  		}
> +		xfs_unicode_nls_free(sfep->name, nls_name);

xfs_dir_filldir()

> @@ -250,10 +250,14 @@ xfs_rename(
>  	xfs_itrace_entry(target_dp);
>  
>  	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> -		error = xfs_unicode_validate(src_name, src_namelen);
> +		error = xfs_nls_to_unicode(mp,
> +				VNAME(src_vname), VNAMELEN(src_vname),
> +				(const uchar_t **)&src_name, &src_namelen);
>  		if (error)
>  			return error;
> -		error = xfs_unicode_validate(target_name, target_namelen);
> +		error = xfs_nls_to_unicode(mp,
> +				VNAME(target_vname), VNAMELEN(target_vname),
> +				(const uchar_t **)&target_name, &target_namelen);

This is kinda messy with all those macros and casts. I think I
mentioned before that the mess should be hidden in a helper function....

>  		if (error)
>  			return error;
>  	}
> @@ -265,6 +269,8 @@ xfs_rename(
>  					src_name, target_name,
>  					0, 0, 0);
>  		if (error) {
> +			xfs_unicode_nls_free(VNAME(src_vname), src_name);
> +			xfs_unicode_nls_free(VNAME(target_vname), target_name);
>  			return error;

			goto out_error;

>  		}
>  	}
> @@ -598,6 +604,8 @@ std_return:
>  					src_name, target_name,
>  					0, error, 0);
>  	}

out_error:

> +	xfs_unicode_nls_free(VNAME(src_vname), src_name);
> +	xfs_unicode_nls_free(VNAME(target_vname), target_name);
>  	return error;
>  
>   abort_return:

> --- kern_ci.orig/fs/xfs/xfs_unicode.c
> +++ kern_ci/fs/xfs/xfs_unicode.c
.....
> +	}
> +	if (i == uni_namelen) {
> +		*nls_name = n;
> +		*nls_namelen = o;
> +		return 0;
> +	}
> +	error = ENAMETOOLONG;
> +err_out:
> +	xfs_da_name_free(n);
> +	return error;
> +}

That's kind of convoluted - took me a moment to work out where the
successful return was coming from.

	if (i != uni_namelen) {
		error = ENAMETOOLONG;
		goto out_err;
	}

	*nls_name = n;
	*nls_namelen = o;
	return 0;
err_out:
	xfs_da_name_free(n);
	return error;
}

> @@ -76,6 +84,14 @@ void xfs_unicode_free_cft(const xfs_cft_
>  #define xfs_unicode_read_cft(mp)	(EOPNOTSUPP)
>  #define xfs_unicode_free_cft(cft)
>  
> +#define xfs_is_using_nls(mp)		0
> +
> +#define xfs_unicode_to_nls(mp, uname, ulen, pnname, pnlen) \
> +		((*(pnname)) = (uname), (*(pnlen)) = (ulen), 0)
> +#define xfs_nls_to_unicode(mp, nname, nlen, puname, pulen) \
> +		((*(puname)) = (nname), (*(pulen)) = (nlen), 0)
> +#define xfs_unicode_nls_free(sname, cname)
> +

static inline where possible.

> --- kern_ci.orig/fs/xfs/xfs_vfsops.c
> +++ kern_ci/fs/xfs/xfs_vfsops.c
> @@ -405,13 +405,30 @@ xfs_finish_flags(
>  	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
>  		if (ap->flags2 & XFSMNT2_CILOOKUP)
>  			mp->m_flags |= XFS_MOUNT_CILOOKUP;
> +
> +		mp->m_nls = ap->nls[0] ? load_nls(ap->nls) : load_nls_default();
> +		if (!mp->m_nls) {
> +			cmn_err(CE_WARN,
> +	"XFS: unable to load nls mapping \"%s\"\n", ap->nls);
> +			return XFS_ERROR(EINVAL);
> +		}
> +		if (strcmp(mp->m_nls->charset, XFS_NLS_UTF8) == 0) {
> +			/* special case utf8 - no translation required */
> +			unload_nls(mp->m_nls);
> +			mp->m_nls = NULL;
> +		}

Can you push this off into a xfs_nls_load() helper function?

> @@ -647,6 +664,8 @@ out:
>  		xfs_unmountfs(mp, credp);
>  		xfs_qmops_put(mp);
>  		xfs_dmops_put(mp);
> +		if (xfs_is_using_nls(mp))
> +			unload_nls(mp->m_nls);

and an unload function as well (put those two lines inside it).

>  	if (xfs_sb_version_hasunicode(&dp->i_mount->m_sb)) {
> -		error = xfs_unicode_validate(d_name->name, d_name->len);
> +		error = xfs_nls_to_unicode(dp->i_mount, d_name->name,
> +				d_name->len, &name.name, &name.len);
>  		if (error)
>  			return error;
> +	} else {
> +		name.name = d_name->name;
> +		name.len = d_name->len;
>  	}

wrapper function.

> -	namelen = VNAMELEN(dentry);
> -
>  	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> -		error = xfs_unicode_validate(name, namelen);
> +		error = xfs_nls_to_unicode(mp, VNAME(dentry), VNAMELEN(dentry),
> +				(const uchar_t **)&name, &namelen);
>  		if (error)
>  			return error;
> +	} else {
> +		name = VNAME(dentry);
> +		namelen = VNAMELEN(dentry);
>  	}

same wrapper

>  
>  	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
> @@ -1846,8 +1853,10 @@ xfs_create(
>  				DM_RIGHT_NULL, name, NULL,
>  				mode, 0, 0);
>  
> -		if (error)
> +		if (error) {
> +			xfs_unicode_nls_free(VNAME(dentry), name);
>  			return error;
> +		}

goto out_error;

>  		dm_event_sent = 1;
>  	}
>  
> @@ -1999,6 +2008,7 @@ std_return:
>  			DM_RIGHT_NULL, name, NULL,
>  			mode, error, 0);
>  	}

out_error:

> +	xfs_unicode_nls_free(VNAME(dentry), name);
>  	return error;
>  
>   abort_return:
.....

fix up all the other functions that have the same mods.


Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
