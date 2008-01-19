Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 21:23:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0J5N7ER032679
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:23:09 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24ED353922C
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:23:20 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id U1wkyz3b2uhYBeud for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 21:23:20 -0800 (PST)
Message-ID: <47918927.2000603@sandeen.net>
Date: Fri, 18 Jan 2008 23:22:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW 1/2] Case insensitive support for XFS - kernel patch
References: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>


Barry Naujok wrote:
> This patch should apply to 2.6.24-rc6.

actually doesn't seem to; at least doesn't apply to rc8... mount
handling has moved, etc - well, easy enough to fix up.

The samba guys are excited about this, I bet :)

Lots of comments below; keep an open mind and a sense of humor, most
aren't demands but ideas, musings etc...


> ===========================================================================
> fs/xfs/Makefile
> ===========================================================================
> 
> --- a/fs/xfs/Makefile	2008-01-18 15:31:23.000000000 +1100
> +++ b/fs/xfs/Makefile	2007-10-23 16:17:22.173903950 +1000
> @@ -74,6 +74,7 @@ xfs-y				+= xfs_alloc.o \
>  				   xfs_trans_extfree.o \
>  				   xfs_trans_inode.o \
>  				   xfs_trans_item.o \
> +				   xfs_unicode.o \

obj-$(CONFIG_XFS_UNICODE)  perhaps?  It's a lot of new code that not
everyone needs?

>  				   xfs_utils.o \
>  				   xfs_vfsops.o \
>  				   xfs_vnodeops.o \
> 
...

> ===========================================================================
> fs/xfs/linux-2.6/xfs_iops.c
> ===========================================================================
> 
> --- a/fs/xfs/linux-2.6/xfs_iops.c	2008-01-18 15:31:23.000000000 +1100
> +++ b/fs/xfs/linux-2.6/xfs_iops.c	2008-01-17 12:26:26.905427167 +1100
> @@ -47,6 +47,8 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_utils.h"
>  #include "xfs_vnodeops.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_unicode.h"
>  
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
> @@ -388,7 +390,7 @@ xfs_vn_lookup(
>  	if (dentry->d_name.len >= MAXNAMELEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	error = xfs_lookup(XFS_I(dir), dentry, &cvp);
> +	error = xfs_lookup(XFS_I(dir), dentry, &cvp, NULL, NULL);
>  	if (unlikely(error)) {
>  		if (unlikely(error != ENOENT))
>  			return ERR_PTR(-error);
> @@ -399,6 +401,113 @@ xfs_vn_lookup(
>  	return d_splice_alias(vn_to_inode(cvp), dentry);
>  }
>  
> +STATIC struct dentry *
> +xfs_vn_ci_lookup(
> +	struct inode	*dir,
> +	struct dentry	*dentry,
> +	struct nameidata *nd)
> +{
> +	bhv_vnode_t	*cvp;
> +	int		error;
> +	struct dentry	*result;
> +	struct qstr	actual_name;
> +	struct inode	*inode;
> +
> +	if (dentry->d_name.len >= MAXNAMELEN)
> +		return ERR_PTR(-ENAMETOOLONG);
> +
> +	error = xfs_lookup(XFS_I(dir), dentry, &cvp, (char **)&actual_name.name,
> +			&actual_name.len);
> +	if (unlikely(error)) {
> +		if (unlikely(error != ENOENT))
> +			return ERR_PTR(-error);
> +		d_add(dentry, NULL);
> +		return NULL;
> +	}
> +	inode = vn_to_inode(cvp);
> +
> +	/* if exact match, just splice and exit */
> +	if (!actual_name.name) {
> +		result = d_splice_alias(inode, dentry);
> +		return result;
> +	}
> +
> +	/*
> +	 * case-insensitive match, create a dentry to return and fill it
> +	 * in with the correctly cased name. Parameter "dentry" is not
> +	 * used anymore and the caller will free it.
> +	 * Derived from fs/ntfs/namei.c
> +	 */
> +
> +	actual_name.hash = full_name_hash(actual_name.name, actual_name.len);
> +
> +	/* Does an existing dentry match? */
> +	result = d_lookup(dentry->d_parent, &actual_name);
> +	if (!result) {
> +		/* if not, create one */
> +		result = d_alloc(dentry->d_parent, &actual_name);
> +		xfs_free_unicode_nls_name((char *)actual_name.name);
> +		if (!result)
> +			return ERR_PTR(-ENOMEM);
> +		dentry = d_splice_alias(inode, result);
> +		if (dentry) {
> +			dput(result);
> +			return dentry;
> +		}
> +		return result;
> +	}
> +	xfs_free_unicode_nls_name((char *)actual_name.name);
> +
> +	/* an existing dentry matches, use it */
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
> +		}
> +		iput(inode);
> +		return result;
> +	}
> +
> +	if (!S_ISDIR(inode->i_mode)) {
> +		/* not a directory, easy to handle */
> +		d_instantiate(result, inode);
> +		return result;
> +	}
> +
> +	spin_lock(&dcache_lock);
> +	if (list_empty(&inode->i_dentry)) {
> +		/*
> +		 * Directory without a 'disconnected' dentry; we need to do
> +		 * d_instantiate() by hand because it takes dcache_lock which
> +		 * we already hold.
> +		 */
> +		list_add(&result->d_alias, &inode->i_dentry);
> +		result->d_inode = inode;
> +		spin_unlock(&dcache_lock);
> +		security_d_instantiate(result, inode);
> +		return result;
> +	}
> +	/*
> +	 * Directory with a 'disconnected' dentry; get a reference to the
> +	 * 'disconnected' dentry.
> +	 */
> +	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
> +	dget_locked(dentry);
> +	spin_unlock(&dcache_lock);
> +	security_d_instantiate(result, inode);
> +	d_move(dentry, result);
> +	iput(inode);
> +	dput(result);
> +	return dentry;
> +}
> +
> +

It seems like it might be nice to make the CI code a compile-time
option?  Fairly big new chunks... if it could be done cleanly, might be
nice...

> ===========================================================================
> fs/xfs/linux-2.6/xfs_linux.h
> ===========================================================================
> 
> --- a/fs/xfs/linux-2.6/xfs_linux.h	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/linux-2.6/xfs_linux.h	2008-01-11 14:49:16.537591564 +1100
> @@ -75,6 +75,8 @@
>  #include <linux/delay.h>
>  #include <linux/log2.h>
>  #include <linux/spinlock.h>
> +#include <linux/ctype.h>
> +#include <linux/nls.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> @@ -180,6 +182,12 @@
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
>  
>  /*
> + * NLS UTF-8 character set
> + */
> +
> +#define XFS_NLS_UTF8	"utf8"

I guess that had to go somewhere? :)

> +
> +/*
>   * Various platform dependent calls that don't fit anywhere else
>   */
>  #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
> 
> ===========================================================================
> fs/xfs/linux-2.6/xfs_super.c
> ===========================================================================
> 
> --- a/fs/xfs/linux-2.6/xfs_super.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/linux-2.6/xfs_super.c	2008-01-11 14:46:25.067566854 +1100
> @@ -50,6 +50,7 @@
>  #include "xfs_vnodeops.h"
>  #include "xfs_vfsops.h"
>  #include "xfs_version.h"
> +#include "xfs_unicode.h"
>  #include "xfs_log_priv.h"
>  
>  #include <linux/namei.h>
> @@ -121,6 +122,9 @@ xfs_args_allocate(
>  #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
>  #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
>  #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
> +#define MNTOPT_NLS	"nls"		/* NLS code page to use */
> +#define MNTOPT_CILOOKUP	"ci"		/* case-insensitive dir names */
> +#define MNTOPT_CIATTR	"ciattr"	/* case-insensitive attr names */
>  #define MNTOPT_QUOTA	"quota"		/* disk quotas (user) */
>  #define MNTOPT_NOQUOTA	"noquota"	/* no quotas */
>  #define MNTOPT_USRQUOTA	"usrquota"	/* user quota enabled */


Please document in Documentation/filesystems/xfs.txt too...

> @@ -315,6 +319,18 @@ xfs_parseargs(
>  			args->flags &= ~XFSMNT_ATTR2;
>  		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
>  			args->flags2 |= XFSMNT2_FILESTREAMS;
> +		} else if (!strcmp(this_char, MNTOPT_NLS)) {
> +			if (!value || !*value) {
> +				cmn_err(CE_WARN,
> +					"XFS: %s option requires an argument",
> +					this_char);
> +				return EINVAL;
> +			}
> +			strncpy(args->nls, value, MAXNAMELEN);
> +		} else if (!strcmp(this_char, MNTOPT_CILOOKUP)) {
> +			args->flags2 |= XFSMNT2_CILOOKUP;
> +		} else if (!strcmp(this_char, MNTOPT_CIATTR)) {
> +			args->flags2 |= XFSMNT2_CIATTR;
>  		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
>  			args->flags &= ~(XFSMNT_UQUOTAENF|XFSMNT_UQUOTA);
>  			args->flags &= ~(XFSMNT_GQUOTAENF|XFSMNT_GQUOTA);
> @@ -454,6 +470,8 @@ xfs_showargs(
>  		{ XFS_MOUNT_OSYNCISOSYNC,	"," MNTOPT_OSYNCISOSYNC },
>  		{ XFS_MOUNT_ATTR2,		"," MNTOPT_ATTR2 },
>  		{ XFS_MOUNT_FILESTREAMS,	"," MNTOPT_FILESTREAM },
> +		{ XFS_MOUNT_CI_LOOKUP,		"," MNTOPT_CILOOKUP },
> +		{ XFS_MOUNT_CI_ATTR,		"," MNTOPT_CIATTR },
>  		{ XFS_MOUNT_DMAPI,		"," MNTOPT_DMAPI },
>  		{ XFS_MOUNT_GRPID,		"," MNTOPT_GRPID },
>  		{ 0, NULL }
> @@ -516,6 +534,13 @@ xfs_showargs(
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
>  		seq_puts(m, "," MNTOPT_NOQUOTA);
>  
> +	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> +		if (mp->m_nls)
> +			seq_printf(m, "," MNTOPT_NLS "=%s", mp->m_nls->charset);
> +		else
> +			seq_puts(m, "," MNTOPT_NLS "=" XFS_NLS_UTF8);
> +	}
> +
>  	return 0;
>  }
>  __uint64_t
> @@ -563,7 +588,11 @@ xfs_set_inodeops(
>  		inode->i_mapping->a_ops = &xfs_address_space_operations;
>  		break;
>  	case S_IFDIR:
> -		inode->i_op = &xfs_dir_inode_operations;
> +		inode->i_op =
> +			xfs_sb_version_hasoldci(&XFS_I(inode)->i_mount->m_sb) ||
> +			(XFS_I(inode)->i_mount->m_flags & XFS_MOUNT_CI_LOOKUP) ?
> +				&xfs_dir_ci_inode_operations :
> +				&xfs_dir_inode_operations;

Do any linux filesystems in existence actually have
XFS_SB_VERSION_OLDCIBIT?  I'd think not - this patch is *adding* that
macro - what's this for?

>  		inode->i_fop = &xfs_dir_file_operations;
>  		break;
>  	case S_IFLNK:
> 
> ===========================================================================
> fs/xfs/xfs_attr.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_attr.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_attr.c	2008-01-18 13:25:20.068339942 +1100
> @@ -106,6 +106,17 @@ ktrace_t *xfs_attr_trace_buf;
>   * Overall external interface routines.
>   *========================================================================*/
>  
> +void
> +xfs_attr_mount(struct xfs_mount *mp)
> +{
> +	mp->m_attr_magicpct = (mp->m_sb.sb_blocksize * 37) / 100;
> +	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> +		mp->m_attrnameops = (mp->m_flags & XFS_MOUNT_CI_ATTR) ?
> +			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
> +	} else
> +		mp->m_attrnameops = &xfs_default_nameops;
> +}

Hm, I thought most little mount-helper subroutines went right in next to
xfs_mountfs() in xfs_mount.c; just a thought.  Then you wouldn't need
the prototype in the header either...

> +
>  int
>  xfs_attr_fetch(xfs_inode_t *ip, const char *name, int namelen,
>  	       char *value, int *valuelenp, int flags, struct cred *cred)
> @@ -122,14 +133,14 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
>  	 * Fill in the arg structure for this request.
>  	 */
>  	memset((char *)&args, 0, sizeof(args));
> -	args.name = name;
> -	args.namelen = namelen;
>  	args.value = value;
>  	args.valuelen = *valuelenp;
>  	args.flags = flags;
> -	args.hashval = xfs_da_hashname(args.name, args.namelen);
>  	args.dp = ip;
>  	args.whichfork = XFS_ATTR_FORK;
> +	error = xfs_da_setup_name_and_hash(&args, name, namelen);
> +	if (error)
> +		return error;

In the spirit of incremental-but-functional patches, which helps to
break down & review big patchsets like this, I think this addition of
xfs_da_setup_name_and_hash() could stand on its own, and add the nls
stuff in a subsequent patch?

>  	/*
>  	 * Decide on what work routines to call based on the inode size.
> @@ -153,6 +164,7 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
>  
>  	if (error == EEXIST)
>  		error = 0;
> +	xfs_da_cleanup_name(&args, name);

I'm being a little lazy here; under which circumstances would args->name
!= name, and need to be freed?

...

> ===========================================================================
> fs/xfs/xfs_attr_leaf.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_attr_leaf.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_attr_leaf.c	2008-01-18 13:25:11.873394723 +1100
> @@ -42,6 +42,7 @@
>  #include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_error.h"
> +#include "xfs_unicode.h"
>  
>  /*
>   * xfs_attr_leaf.c
> @@ -90,6 +91,10 @@ STATIC void xfs_attr_leaf_moveents(xfs_a
>  					 xfs_mount_t *mp);
>  STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
>  
> +STATIC int xfs_attr_put_listent(xfs_attr_list_context_t *context,
> +					attrnames_t *namesp, char *name,
> +					int namelen, int valuelen, char *value);
> +
>  /*========================================================================
>   * Namespace helper routines
>   *========================================================================*/
> @@ -135,6 +140,38 @@ xfs_attr_namesp_match_overrides(int arg_
>   * External routines when attribute fork size < XFS_LITINO(mp).
>   *========================================================================*/
>  
> +STATIC xfs_attr_sf_entry_t *
> +xfs_attr_shortform_find_ent(xfs_da_args_t *args)
> +{
> +	xfs_attr_shortform_t *sf;
> +	xfs_attr_sf_entry_t *sfe;
> +	int i;
> +	xfs_attr_sf_entry_t *ci_sfe = NULL;
> +
> +	ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
> +	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
> +	sfe = &sf->list[0];
> +
> +	args->cmpresult = XFS_CMP_DIFFERENT;
> +	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> +		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
> +			continue;
> +		switch (xfs_attr_compname(args->dp, sfe->nameval, sfe->namelen,
> +				args->name, args->namelen)) {
> +		case XFS_CMP_EXACT:
> +			args->cmpresult = XFS_CMP_EXACT;
> +			return sfe;
> +		case XFS_CMP_CASE:
> +			if (!ci_sfe) {
> +				args->cmpresult = XFS_CMP_CASE;
> +				ci_sfe = sfe;
> +			}
> +		default:;
> +		}
> +	}
> +	return ci_sfe;
> +}

Perhaps this helper could be a sub-patch too?  Just a thought.

>  /*
>   * Query whether the requested number of additional bytes of extended
>   * attribute space will be able to fit inline.
> @@ -295,13 +332,10 @@ xfs_attr_shortform_add(xfs_da_args_t *ar
>  	sfe = &sf->list[0];
>  	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>  #ifdef DEBUG
> -		if (sfe->namelen != args->namelen)
> -			continue;
> -		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
> -			continue;
>  		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
>  			continue;
> -		ASSERT(0);
> +		ASSERT(xfs_attr_compname(args->dp, args->name, args->namelen,
> +			sfe->nameval, sfe->namelen) == XFS_CMP_DIFFERENT);

Perhaps this helper too could come as a subpatch.

...


> +	if (!sfe)
> +		return XFS_ERROR(ENOATTR);
> +

Indentation from here on looks busted.  Are you missing braces?

>  		if (args->flags & ATTR_KERNOVAL) {
>  			args->valuelen = sfe->valuelen;
> -			return(XFS_ERROR(EEXIST));
> +		return XFS_ERROR(EEXIST);

need another tab here?

>  		}
>  		if (args->valuelen < sfe->valuelen) {
>  			args->valuelen = sfe->valuelen;
> -			return(XFS_ERROR(ERANGE));
> +		return XFS_ERROR(ERANGE);

and here?

>  		}
>  		args->valuelen = sfe->valuelen;
> -		memcpy(args->value, &sfe->nameval[args->namelen],
> -						    args->valuelen);
> -		return(XFS_ERROR(EEXIST));
> -	}
> -	return(XFS_ERROR(ENOATTR));
> +	memcpy(args->value, &sfe->nameval[args->namelen], args->valuelen);
> +
> +	return XFS_ERROR(EEXIST);
>  }
>  
>  /*
...


> @@ -631,7 +626,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
>  				continue;
>  			}
>  			namesp = xfs_attr_flags_namesp(sfe->flags);
> -			error = context->put_listent(context,
> +			error = xfs_attr_put_listent(context,
>  					   namesp,
>  					   (char *)sfe->nameval,
>  					   (int)sfe->namelen,
> @@ -734,7 +729,7 @@ xfs_attr_shortform_list(xfs_attr_list_co
>  			cursor->hashval = sbp->hash;
>  			cursor->offset = 0;
>  		}
> -		error = context->put_listent(context,
> +		error = xfs_attr_put_listent(context,
>  					namesp,
>  					sbp->name,
>  					sbp->namelen,

maybe the introduction of xfs_attr_put_listent could be a small
prep-work patch too.  Or is this getting old ;)

> @@ -1960,6 +1955,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
>  	xfs_attr_leaf_name_remote_t *name_rmt;
>  	int probe, span;
>  	xfs_dahash_t hashval;
> +	xfs_dacmp_t cmp;
>  
>  	leaf = bp->data;
>  	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
> @@ -2008,6 +2004,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
>  	/*
>  	 * Duplicate keys may be present, so search all of them for a match.
>  	 */
> +	args->cmpresult = XFS_CMP_DIFFERENT;
>  	for (  ; (probe < be16_to_cpu(leaf->hdr.count)) &&
>  			(be32_to_cpu(entry->hashval) == hashval);
>  			entry++, probe++) {
> @@ -2019,35 +2016,40 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
>  		 * If we are looking for complete entries, show only those.
>  		 */
>  		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
> -		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
> -			continue;
> -		}
> -		if (entry->flags & XFS_ATTR_LOCAL) {
> -			name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, probe);
> -			if (name_loc->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, (char *)name_loc->nameval, args->namelen) != 0)
> +				(entry->flags & XFS_ATTR_INCOMPLETE))
>  				continue;
>  			if (!xfs_attr_namesp_match(args->flags, entry->flags))
>  				continue;
> +		if (entry->flags & XFS_ATTR_LOCAL) {
> +			name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, probe);
> +			cmp = xfs_attr_compname(args->dp, args->name, args->namelen,
> +					name_loc->nameval, name_loc->namelen);
> +			if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> +				args->cmpresult = cmp;
>  			args->index = probe;

weird indentation here too...

> -			return(XFS_ERROR(EEXIST));
> +				args->rmtblkno = 0;
> +				args->rmtblkcnt = 0;
> +				if (cmp == XFS_CMP_EXACT)
> +					return XFS_ERROR(EEXIST);
> +			}
>  		} else {
>  			name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, probe);
> -			if (name_rmt->namelen != args->namelen)
> -				continue;
> -			if (memcmp(args->name, (char *)name_rmt->name,
> -					     args->namelen) != 0)
> -				continue;
> -			if (!xfs_attr_namesp_match(args->flags, entry->flags))
> -				continue;
> +			cmp = xfs_attr_compname(args->dp, args->name, args->namelen,
> +					name_rmt->name, name_rmt->namelen);
> +			if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> +				args->cmpresult = cmp;
>  			args->index = probe;
>  			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
>  			args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount,
>  						   be32_to_cpu(name_rmt->valuelen));
> -			return(XFS_ERROR(EEXIST));
> +				if (cmp == XFS_CMP_EXACT)
> +					return XFS_ERROR(EEXIST);

and here

> +			}
>  		}
>  	}
> +	if (args->cmpresult == XFS_CMP_CASE)
> +		return XFS_ERROR(EEXIST);
> +
>  	args->index = probe;
>  	return(XFS_ERROR(ENOATTR));
>  }
> @@ -2418,7 +2420,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
>  			xfs_attr_leaf_name_local_t *name_loc =
>  				XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
>  
> -			retval = context->put_listent(context,
> +			retval = xfs_attr_put_listent(context,

sub-patch? :)

...				(int)name_rmt->namelen,
> @@ -2472,6 +2474,31 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
>  	return(retval);
>  }
>  
> +/*
> + * Do NLS name conversion if required for attribute name and call
> + * context's put_listent routine
> + */
> +
> +STATIC int
> +xfs_attr_put_listent(xfs_attr_list_context_t *context, attrnames_t *namesp,
> +	char *name, int namelen, int valuelen, char *value)
> +{
> +	xfs_mount_t *mp = context->dp->i_mount;
> +	char *nls_name = NULL;
> +	int rval;
> +
> +	if (!mp->m_nls)
> +		return context->put_listent(context, namesp, name, namelen,
> +				valuelen, value);
> +
> +	rval = xfs_unicode_to_nls(mp->m_nls, name, namelen, &nls_name);
> +	if (rval < 0)
> +		return -rval;
> +	rval = context->put_listent(context, namesp, nls_name, rval,
> +			valuelen, value);
> +	xfs_free_unicode_nls_name(nls_name);
> +	return rval;
> +}
>  
>  /*========================================================================
>   * Manage the INCOMPLETE flag in a leaf entry
> ===========================================================================
> fs/xfs/xfs_attr_leaf.h
> ===========================================================================
> 
> --- a/fs/xfs/xfs_attr_leaf.h	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_attr_leaf.h	2008-01-11 14:16:44.268796245 +1100
> @@ -36,6 +36,7 @@ struct xfs_da_args;
>  struct xfs_da_state;
>  struct xfs_da_state_blk;
>  struct xfs_inode;
> +struct xfs_mount;
>  struct xfs_trans;
>  
>  /*========================================================================
> @@ -204,6 +205,16 @@ static inline int xfs_attr_leaf_entsize_
>  	return (((bsize) >> 1) + ((bsize) >> 2));
>  }
>  
> +/*
> + * Do hash and name compare based on nameops
> + */
> +#define xfs_attr_hashname(dp, n, l) \
> +		((dp)->i_mount->m_attrnameops->hashname((dp), (n), (l)))
> +
> +#define xfs_attr_compname(dp, n1, l1, n2, l2) \
> +		((dp)->i_mount->m_attrnameops->compname((dp), (n1), (l1), \
> +							(n2), (l2)))
> +
>  
>  /*========================================================================
>   * Structure used to pass context around among the routines.
> @@ -296,6 +307,7 @@ int	xfs_attr_root_inactive(struct xfs_tr
>  /*
>   * Utility routines.
>   */
> +void	xfs_attr_mount(struct xfs_mount *mp);

this could just go in xfs_mount.c and be static.

>  xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_dabuf *bp, int *count);
>  int	xfs_attr_leaf_order(struct xfs_dabuf *leaf1_bp,
>  				   struct xfs_dabuf *leaf2_bp);
> 

> ===========================================================================
> fs/xfs/xfs_da_btree.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_da_btree.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_da_btree.c	2007-10-31 16:04:16.463309546 +1100
> @@ -46,6 +46,7 @@
>  #include "xfs_dir2_block.h"
>  #include "xfs_dir2_node.h"
>  #include "xfs_error.h"
> +#include "xfs_unicode.h"
>  
>  /*
>   * xfs_da_btree.c
> @@ -1530,6 +1531,100 @@ xfs_da_hashname(const uchar_t *name, int
>  	}
>  }
>  
> +
> +static xfs_dahash_t
> +xfs_default_hashname(xfs_inode_t *inode, const uchar_t *name, int namelen)
> +{
> +	return xfs_da_hashname(name, namelen);
> +}

Could these be rolled into one instead of the wrapper?  I see 3 other
direct callers of xfs_da_hashname... and does xfs_attr_shortform_list
need to use xfs_attr_hashname instead of xfs_da_hashname?  Do "." and
".." ever have different answers in different codepages?  Does that matter?

> +xfs_dacmp_t
> +xfs_default_compname(xfs_inode_t *inode, const uchar_t *name1, int len1,
> +	const uchar_t *name2, int len2)
> +{
> +	return (len1 == len2 && memcmp(name1, name2, len1) == 0) ?
> +			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
> +}
> +
> +static xfs_dahash_t
> +xfs_unicode_ci_hashname(
> +	xfs_inode_t	*inode,
> +	const uchar_t	*name,
> +	int		namelen)
> +{
> +	return xfs_unicode_hash(inode->i_mount->m_cft, name, namelen);
> +}

this wrapper is the only caller of xfs_unicode_hash?  Is it just to
conveniently get from inode to m_cft?

strikes me as a little interesting that while an inode is passed into a
xfs_hashname_t, it's never actually used directly - same for compname -
would it make any sense to just pass the xfs_cft in from the start?

...

> ===========================================================================
> fs/xfs/xfs_dir2.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_dir2.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_dir2.c	2008-01-11 14:24:51.701973714 +1100
> @@ -42,8 +42,56 @@
>  #include "xfs_dir2_node.h"
>  #include "xfs_dir2_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_unicode.h"
>  #include "xfs_vnodeops.h"
>  
> +/*
> + * V1 case-insensitive support for directories
> + */

remind me, what's "V1?"

> +static xfs_dahash_t
> +xfs_ascii_ci_hashname(
> +	xfs_inode_t	*inode,
> +	const uchar_t	*name,
> +	int		namelen)
> +{
> +	xfs_dahash_t	hash;
> +	int		i;
> +
> +	for (i = 0, hash = 0; i < namelen; i++)
> +		hash = tolower(name[i]) ^ rol32(hash, 7);
> +
> +	return hash;
> +}
> +
> +static xfs_dacmp_t
> +xfs_ascii_ci_compname(
> +	xfs_inode_t	*inode,
> +	const uchar_t	*name1,
> +	int		len1,
> +	const uchar_t	*name2,
> +	int 		len2)
> +{
> +	xfs_dacmp_t	result = XFS_CMP_EXACT;
> +	int		i;
> +
> +	if (len1 != len2)
> +		return XFS_CMP_DIFFERENT;
> +
> +	for (i = 0; i < len1; i++) {
> +		if (name1[i] == name2[i])
> +			continue;
> +		if (tolower(name1[i]) != tolower(name2[i]))
> +			return XFS_CMP_DIFFERENT;
> +		result = XFS_CMP_CASE;
> +	}
> +
> +	return result;
> +}
> +
> +static const struct xfs_nameops xfs_ascii_ci_nameops = {
> +	.hashname	= xfs_ascii_ci_hashname,
> +	.compname	= xfs_ascii_ci_compname,
> +};
>  
>  void
>  xfs_dir_mount(
> @@ -64,6 +112,13 @@ xfs_dir_mount(
>  		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
>  		(uint)sizeof(xfs_da_node_entry_t);
>  	mp->m_dir_magicpct = (mp->m_dirblksize * 37) / 100;
> +
> +	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> +		mp->m_dirnameops = (mp->m_flags & XFS_MOUNT_CI_LOOKUP) ?
> +			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
> +	} else
> +		mp->m_dirnameops = (xfs_sb_version_hasoldci(&mp->m_sb)) ?
> +			&xfs_ascii_ci_nameops : &xfs_default_nameops;

Oh, "V1" is oldci - can you document it that way in the comment?  And if
that hasn't been seen in the wild on linux can this go away?

...

> ===========================================================================
> fs/xfs/xfs_dir2_block.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_dir2_block.c	2008-01-18 15:31:24.000000000 +1100
> +++ b/fs/xfs/xfs_dir2_block.c	2008-01-11 14:28:44.763934272 +1100
...

> @@ -697,20 +720,34 @@ xfs_dir2_block_lookup_int(
>  		dep = (xfs_dir2_data_entry_t *)
>  			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
>  		/*
> -		 * Compare, if it's right give back buffer & entry number.
> -		 */
> -		if (dep->namelen == args->namelen &&
> -		    dep->name[0] == args->name[0] &&
> -		    memcmp(dep->name, args->name, args->namelen) == 0) {
> +		 * Compare, if it's right give back buffer & entry number:
> +		 *
> +		 * lookup case - use nameops;
> +		 *
> +		 * replace/remove case - as lookup has been already been
> +		 * performed, look for an exact match using the fast method
> +		 */
> +		cmp = args->oknoent ?
> +			xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen) :
> +			xfs_default_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen);
> +		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> +			args->cmpresult = cmp;
>  			*bpp = bp;
>  			*entno = mid;
> +			if (cmp == XFS_CMP_EXACT)
>  			return 0;
>  		}
> -	} while (++mid < be32_to_cpu(btp->count) && be32_to_cpu(blp[mid].hashval) == hash);
> +	} while (++mid < be32_to_cpu(btp->count) &&
> +			be32_to_cpu(blp[mid].hashval) == hash);

thanks... can you trim down the other > 80 char lines you've added, too? :)

> @@ -1300,10 +1313,17 @@ xfs_dir2_leaf_lookup(
>  	/*
>  	 * Return the found inode number.
>  	 */
> +	error = EEXIST;
>  	args->inumber = be64_to_cpu(dep->inumber);
> +	if (args->cmpresult == XFS_CMP_CASE) {
> +		args->valuelen = xfs_unicode_to_nls(args->dp->i_mount->m_nls,
> +				dep->name, dep->namelen, (char **)&args->value);
> +		if (args->valuelen < 0)
> +			error = -args->valuelen;

hm, error signs... new functions return negative, whereas old xfs code
returns positive errors?

...

> @@ -1391,19 +1413,31 @@ xfs_dir2_leaf_lookup_int(
>  		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
>  		/*
>  		 * If it matches then return it.
> -		 */
> -		if (dep->namelen == args->namelen &&
> -		    dep->name[0] == args->name[0] &&
> -		    memcmp(dep->name, args->name, args->namelen) == 0) {
> +		 *
> +		 * lookup case - use nameops;
> +		 *
> +		 * replace/remove case - as lookup has been already been
> +		 * performed, look for an exact match using the fast method
> +		 */
> +		cmp = args->oknoent ?
> +			xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen) :
> +			xfs_default_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen);
> +		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> +			args->cmpresult = cmp;
>  			*dbpp = dbp;
>  			*indexp = index;
> +			if (cmp == XFS_CMP_EXACT)
>  			return 0;

tab missing?


> ===========================================================================
> fs/xfs/xfs_dir2_node.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_dir2_node.c	2008-01-18 15:31:25.000000000 +1100
> +++ b/fs/xfs/xfs_dir2_node.c	2007-10-31 12:32:04.060201390 +1100
...

> @@ -572,28 +575,34 @@ xfs_dir2_leafn_lookup_int(
>  			/*
>  			 * Point to the data entry.
>  			 */
> -			dep = (xfs_dir2_data_entry_t *)
> -			      ((char *)curbp->data +
> +			dep = (xfs_dir2_data_entry_t *)((char *)curbp->data +
>  			       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
>  			/*
>  			 * Compare the entry, return it if it matches.
>  			 */
> -			if (dep->namelen == args->namelen &&
> -			    dep->name[0] == args->name[0] &&
> -			    memcmp(dep->name, args->name, args->namelen) == 0) {
> +			cmp = args->oknoent ?
> +				xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen):
> +				xfs_default_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen);
> +			if (cmp != XFS_CMP_DIFFERENT &&
> +					cmp != args->cmpresult) {
> +				args->cmpresult = cmp;
>  				args->inumber = be64_to_cpu(dep->inumber);
>  				*indexp = index;
>  				state->extravalid = 1;
>  				state->extrablk.bp = curbp;
>  				state->extrablk.blkno = curdb;
> -				state->extrablk.index =
> -					(int)((char *)dep -
> +				state->extrablk.index = (int)((char *)dep -
>  					      (char *)curbp->data);
>  				state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
> +				if (cmp == XFS_CMP_EXACT)
>  				return XFS_ERROR(EEXIST);

tab...  Hmm wonder if I caught all of these...

> ===========================================================================
> fs/xfs/xfs_dir2_sf.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_dir2_sf.c	2008-01-18 15:31:25.000000000 +1100
> +++ b/fs/xfs/xfs_dir2_sf.c	2008-01-17 12:25:01.552398622 +1100
> @@ -38,6 +38,7 @@
>  #include "xfs_dir2_leaf.h"
>  #include "xfs_dir2_block.h"
>  #include "xfs_dir2_trace.h"
> +#include "xfs_unicode.h"
>  
>  /*
>   * Prototypes for internal functions.
> @@ -708,6 +709,8 @@ xfs_dir2_sf_getdents(
>  	xfs_dir2_dataptr_t	dot_offset;
>  	xfs_dir2_dataptr_t	dotdot_offset;
>  	xfs_ino_t		ino;
> +	char			*nls_name = NULL; /* NLS name buffer */
> +	int			nls_namelen = 0;
>  
>  	mp = dp->i_mount;
>  
> @@ -772,6 +775,9 @@ xfs_dir2_sf_getdents(
>  		}
>  	}
>  
> +	if (mp->m_nls)
> +		nls_name = xfs_alloc_unicode_nls_name();
> +
>  	/*
>  	 * Loop while there are more entries and put'ing works.
>  	 */
> @@ -789,16 +795,22 @@ xfs_dir2_sf_getdents(
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
>  #endif
> -
> -		if (filldir(dirent, sfep->name, sfep->namelen,
> +		if (mp->m_nls)
> +			nls_namelen = xfs_unicode_to_nls(mp->m_nls, sfep->name,
> +					sfep->namelen, &nls_name);
> +		if (filldir(dirent,
> +				nls_namelen > 0 ? nls_name : (char *)sfep->name,
> +				nls_namelen > 0 ? nls_namelen : sfep->namelen,
>  					    off, ino, DT_UNKNOWN)) {

Hmm we've seen the foo > 0 ? bar : baz stuff a few times, should this
get a helper?

...

> @@ -844,23 +857,43 @@ xfs_dir2_sf_lookup(
>  	if (args->namelen == 2 &&
>  	    args->name[0] == '.' && args->name[1] == '.') {
>  		args->inumber = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
> +		args->cmpresult = XFS_CMP_EXACT;
>  		return XFS_ERROR(EEXIST);
>  	}
>  	/*
>  	 * Loop over all the entries trying to match ours.
>  	 */
> -	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
> -	     i < sfp->hdr.count;
> +	args->cmpresult = XFS_CMP_DIFFERENT;
> +	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
>  	     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
> -		if (sfep->namelen == args->namelen &&
> -		    sfep->name[0] == args->name[0] &&
> -		    memcmp(args->name, sfep->name, args->namelen) == 0) {
> -			args->inumber =
> -				xfs_dir2_sf_get_inumber(sfp,
> +		switch (xfs_dir_compname(dp, sfep->name, sfep->namelen,
> +				args->name, args->namelen)) {
> +		case XFS_CMP_EXACT:
> +			args->cmpresult = XFS_CMP_EXACT;
> +			args->inumber = xfs_dir2_sf_get_inumber(sfp,
>  					xfs_dir2_sf_inumberp(sfep));
> +			if (args->value) {
> +				xfs_free_unicode_nls_name(args->value);
> +				args->value = NULL;
> +			}
>  			return XFS_ERROR(EEXIST);
> +
> +		case XFS_CMP_CASE:
> +			if (!args->value) {
> +				args->valuelen = xfs_unicode_to_nls(
> +					args->dp->i_mount->m_nls, sfep->name,
> +					sfep->namelen, (char **)&args->value);
> +				if (args->valuelen < 0)
> +					return XFS_ERROR(-args->valuelen);
> +				args->cmpresult = XFS_CMP_CASE;
> +				args->inumber = xfs_dir2_sf_get_inumber(sfp,
> +						xfs_dir2_sf_inumberp(sfep));
> +			}
> +		default: ;

Hmm that's a little funky, to my eyes anyway.

...

> ===========================================================================
> fs/xfs/xfs_mount.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_mount.c	2008-01-18 15:31:25.000000000 +1100
> +++ b/fs/xfs/xfs_mount.c	2008-01-17 17:10:29.777728874 +1100
> @@ -25,6 +25,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_ag.h"
>  #include "xfs_dir2.h"
> +#include "xfs_attr.h"
>  #include "xfs_dmapi.h"
>  #include "xfs_mount.h"
>  #include "xfs_bmap_btree.h"
> @@ -43,6 +44,9 @@
>  #include "xfs_rw.h"
>  #include "xfs_quota.h"
>  #include "xfs_fsops.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr_leaf.h"
> +#include "xfs_unicode.h"
>  
>  STATIC void	xfs_mount_log_sbunit(xfs_mount_t *, __int64_t);
>  STATIC int	xfs_uuid_mount(xfs_mount_t *);
> @@ -119,6 +123,8 @@ static const struct {
>      { offsetof(xfs_sb_t, sb_logsectsize),0 },
>      { offsetof(xfs_sb_t, sb_logsunit),	 0 },
>      { offsetof(xfs_sb_t, sb_features2),	 0 },
> +    { offsetof(xfs_sb_t, sb_bad_features2), 0 },

bad_features2?  what's this and what does it have to do w/ CI, and why
is it set but never used in xfs_sb_from_disk?

if features2 "could be here" shouldn't we be doing something with that?
 This could do with comments at least, somewhere.

...

> @@ -1165,6 +1176,17 @@ xfs_mountfs(
>  	}
>  
>  	/*
> +	 * Load in unicode case folding table from disk
> +	 */
> +	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
> +		error = xfs_unicode_read_cft(mp);
> +		if (error) {
> +			cmn_err(CE_WARN, "XFS: failed to read case folding table");

80+ chars...

..

> ===========================================================================
> fs/xfs/xfs_sb.h
> ===========================================================================
> 
> --- a/fs/xfs/xfs_sb.h	2008-01-18 15:31:25.000000000 +1100
> +++ b/fs/xfs/xfs_sb.h	2007-10-23 16:55:47.440178601 +1000
> @@ -46,10 +46,12 @@ struct xfs_mount;
>  #define XFS_SB_VERSION_SECTORBIT	0x0800
>  #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
>  #define	XFS_SB_VERSION_DIRV2BIT		0x2000
> +#define XFS_SB_VERSION_OLDCIBIT		0x4000
>  #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
>  #define	XFS_SB_VERSION_OKSASHFBITS	\
>  	(XFS_SB_VERSION_EXTFLGBIT | \
> -	 XFS_SB_VERSION_DIRV2BIT)
> +	 XFS_SB_VERSION_DIRV2BIT | \
> +	 XFS_SB_VERSION_OLDCIBIT)

there's that oldcibit again...

>  #define	XFS_SB_VERSION_OKREALFBITS	\
>  	(XFS_SB_VERSION_ATTRBIT | \
>  	 XFS_SB_VERSION_NLINKBIT | \
> @@ -77,10 +79,12 @@ struct xfs_mount;
>  #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk counters */
>  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
>  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
> +#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
>  
>  #define	XFS_SB_VERSION2_OKREALFBITS	\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> -	 XFS_SB_VERSION2_ATTR2BIT)
> +	 XFS_SB_VERSION2_ATTR2BIT | \
> +	 XFS_SB_VERSION2_UNICODEBIT)
>  #define	XFS_SB_VERSION2_OKSASHFBITS	\
>  	(0)
>  #define XFS_SB_VERSION2_OKREALBITS	\
> @@ -145,6 +149,9 @@ typedef struct xfs_sb {
>  	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
>  	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
>  	__uint32_t	sb_features2;	/* additional feature bits */
> +	__uint32_t	sb_bad_features2; /* features2 could be here */

Ok, so...?

...

> @@ -463,6 +475,12 @@ static inline int xfs_sb_version_hassect
>  		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
>  }
>  
> +static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
> +		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);
> +}

You forgot the uppercase indirection macro!   ;)

...


> ===========================================================================
> fs/xfs/xfs_unicode.c
> ===========================================================================
...

> +
> +char *
> +xfs_alloc_unicode_nls_name(void)
> +{
> +	return kmem_zone_alloc(xfs_nls_uni_zone, KM_SLEEP);
> +}

Why wrap/hide this?

> +
> +
> +void
> +xfs_free_unicode_nls_name(
> +	char		*name)
> +{
> +	kmem_zone_free(xfs_nls_uni_zone, name);
> +}

Or this?  Eh, maybe it's handy.

> +int
> +xfs_nls_to_unicode(
> +	struct nls_table *nls,
> +	const char	*nls_name,
> +	int		nls_namelen,
> +	char		**uni_name)
> +{
> +	char		*n;
> +	int		i, o;
> +	wchar_t		uc;
> +	int		nlen;
> +	int		u8len;
> +	int		rval;
> +
> +	n = *uni_name ? *uni_name : xfs_alloc_unicode_nls_name();
> +
> +	if (!nls) {
> +		if (nls_namelen > MAXNAMELEN) {
> +			rval = -ENAMETOOLONG;

The rest of core xfs code returns positive errors; why the shift in this
file?  Well, I guess because you want to return a length, but this
strikes me as a bit inconsistent... we've been burned by getting error
signs wrong in the past, this looks like an exception to the existing
sign conventions

...


> +int
> +xfs_unicode_validate(
> +	const uchar_t	*name,
> +	int		namelen)
> +{
> +	wchar_t		uc;
> +	int		i, nlen;
> +
> +	for (i = 0; i < namelen; i += nlen) {
> +		if (*name >= 0xf0) {
> +			cmn_err(CE_WARN, "xfs_unicode_validate: "
> +					"UTF-8 char beyond U+FFFF\n");
> +			return -EINVAL;
> +		}
> +		/* utf8_mbtowc must fail on overlong sequences too */
> +		nlen = utf8_mbtowc(&uc, name + i, namelen - i);
> +		if (nlen < 0) {
> +			cmn_err(CE_WARN, "xfs_unicode_validate: "
> +					"invalid UTF-8 sequence\n");
> +			return -EILSEQ;
> +		}
> +		/* check for invalid/surrogate/private unicode chars */
> +		if (uc >= 0xfffe || (uc >= 0xd800 && uc <= 0xf8ff)) {
> +			cmn_err(CE_WARN, "xfs_unicode_validate: "
> +					"unsupported UTF-8 char\n");
> +			return -EINVAL;
> +		}
> +	}
> +	return 0;
> +}

and now this leads to stuff like:

                        rval = xfs_unicode_validate(name, namelen);
                        if (rval < 0)
                                return -rval;

... this looks odd to me.

...

> +xfs_unicode_read_cft(
> +	xfs_mount_t	*mp)
> +{
> +	int		error;
> +	xfs_inode_t	*cftip;
> +	int		size;
> +	int		nfsb;
> +	int             nmap;
> +	xfs_bmbt_irec_t *mapp;
> +	int		n;
> +	int		byte_cnt;
> +	xfs_buf_t	*bp;
> +	char		*table;
> +	xfs_dcft_t	*dcft;
> +
> +	if (mp->m_sb.sb_cftino == NULLFSINO || mp->m_sb.sb_cftino == 0)
> +		return EINVAL;

oh, here it's positive? :)

...

> +void
> +xfs_unicode_free_cft(
> +	const xfs_cft_t	*cft)
> +{
> +	remove_cft(cft);
> +}

why the wrapper?

> +void
> +xfs_unicode_init(void)
> +{
> +	mutex_init(&cft_lock);
> +	xfs_nls_uni_zone = kmem_zone_init(MAXNAMELEN, "xfs_nls_uni");
> +}

Hm, no corresponding mutex_destroy

> +void
> +xfs_unicode_uninit(void)
> +{
> +	int		i;
> +
> +	mutex_lock(&cft_lock);
> +
> +	for (i = 0; i < cft_size; i++) {
> +		ASSERT(cft_list[i].refcount == 0);
> +		vfree(cft_list[i].table);
> +	}
> +	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
> +	cft_size = 0;
> +	cft_list = NULL;
> +
> +	mutex_unlock(&cft_lock);

destroy mutex here too just for tidiness

> +	kmem_zone_destroy(xfs_nls_uni_zone);
> +}
> 

...
