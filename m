Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 17:22:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m330MC5j027016
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 17:22:14 -0700
Date: Wed, 2 Apr 2008 20:22:46 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/7] XFS: Name operation vector for hash and compare
Message-ID: <20080403002246.GB5211@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062707.797672682@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062707.797672682@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:09PM +1000, Barry Naujok wrote:
...
> Index: kern_ci/fs/xfs/xfs_da_btree.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_da_btree.h
> +++ kern_ci/fs/xfs/xfs_da_btree.h
> @@ -99,6 +99,15 @@ typedef struct xfs_da_node_entry xfs_da_
>   *========================================================================*/
>  
>  /*
> + * Search comparison results
> + */
> +typedef enum {
> +	XFS_CMP_DIFFERENT,	/* names are completely different */
> +	XFS_CMP_EXACT,		/* names are exactly the same */
> +	XFS_CMP_CASE		/* names are same but differ in case */
> +} xfs_dacmp_t;

It is somewhat unfortunate that the "matches" case has multiple values.

memcmp, strcmp, etc. return 0 if the two match, and you make >0 a match, and
0 if they don't.  This is really a nitpick, and I don't think there is a way
around...if everyone uses the enum all should be fine.

...
> +/*
> + * Name ops for directory and/or attr name operations
> + */
> +
> +typedef xfs_dahash_t	(*xfs_hashname_t)(const uchar_t *, int);
> +typedef xfs_dacmp_t	(*xfs_compname_t)(const uchar_t *, int,
> +					  const uchar_t *, int);

Why have typedefs for function pointers? Sometimes, they even cause problems
(I remember Eric finding a nasty 64-bit bug related to a function pointer
typedef).

Since IRIX isn't on the supported OS list anymore, what's the policy with
coding style within XFS?

...
> Index: kern_ci/fs/xfs/xfs_dir2.h
> ===================================================================
> --- kern_ci.orig/fs/xfs/xfs_dir2.h
> +++ kern_ci/fs/xfs/xfs_dir2.h
> @@ -85,6 +85,12 @@ extern int xfs_dir_canenter(struct xfs_t
>  				char *name, int namelen);
>  extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
>  
> +#define xfs_dir_hashname(dp, n, l) \
> +		((dp)->i_mount->m_dirnameops->hashname((n), (l)))
> +
> +#define xfs_dir_compname(dp, n1, l1, n2, l2) \
> +		((dp)->i_mount->m_dirnameops->compname((n1), (l1), (n2), (l2)))

#define vs. static inline...

I guess this comes back to my question before...what is the coding style
direction you want XFS to go in? More Linux-like (static inline)? or keep it
more IRIX-like (#define)?

...
> --- kern_ci.orig/fs/xfs/xfs_dir2_block.c
> +++ kern_ci/fs/xfs/xfs_dir2_block.c
...
> @@ -698,19 +699,33 @@ xfs_dir2_block_lookup_int(
>  			((char *)block + xfs_dir2_dataptr_to_off(mp, addr));
>  		/*
>  		 * Compare, if it's right give back buffer & entry number.
> +		 *
> +		 * lookup case - use nameops;
> +		 *
> +		 * replace/remove case - as lookup has been already been
> +		 * performed, look for an exact match using the fast method
>  		 */
> -		if (dep->namelen == args->namelen &&
> -		    dep->name[0] == args->name[0] &&
> -		    memcmp(dep->name, args->name, args->namelen) == 0) {
> +		cmp = args->oknoent ?
> +			xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen) :
> +			xfs_da_compname(dep->name, dep->namelen,
> +						args->name, args->namelen);

Initial reaction: What's going on here?

if oknoent:
	use the mount-determined cmp function
else:
	use case-sensitive

That combined with the comment above makes it understandable...but what does
"oknoent" have to do with the whole thing? Wouldn't "exact_match" be a
better name?

Aside from the oknoent rename, I might even turn the ?: into a if-else.

> +		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
> +			args->cmpresult = cmp;
>  			*bpp = bp;
>  			*entno = mid;
> -			return 0;
> +			if (cmp == XFS_CMP_EXACT)
> +				return 0;
>  		}

I'd put a comment above the above block...reminding whoever that if you get
XFS_CMP_CASE, you keep scanning to make sure you don't get XFS_CMP_EXACT.

...
> @@ -1391,19 +1394,49 @@ xfs_dir2_leaf_lookup_int(
>  		       xfs_dir2_dataptr_to_off(mp, be32_to_cpu(lep->address)));
>  		/*
>  		 * If it matches then return it.
> +		 *
> +		 * lookup case - use nameops;
> +		 *
> +		 * replace/remove case - as lookup has been already been
> +		 * performed, look for an exact match using the fast method
>  		 */
> -		if (dep->namelen == args->namelen &&
> -		    dep->name[0] == args->name[0] &&
> -		    memcmp(dep->name, args->name, args->namelen) == 0) {
> -			*dbpp = dbp;
> +		cmp = args->oknoent ?
> +			xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen) :
> +			xfs_da_compname(dep->name, dep->namelen,
> +						args->name, args->namelen);

Same as above.

This code is very similar to the above...maybe they should be factored out
in some cleanup patch series.

...
> @@ -578,19 +579,27 @@ xfs_dir2_leafn_lookup_int(
>  			/*
>  			 * Compare the entry, return it if it matches.
>  			 */
> -			if (dep->namelen == args->namelen &&
> -			    dep->name[0] == args->name[0] &&
> -			    memcmp(dep->name, args->name, args->namelen) == 0) {
> +			cmp = args->oknoent ?
> +				xfs_dir_compname(dp, dep->name, dep->namelen,
> +						args->name, args->namelen):
> +				xfs_da_compname(dep->name, dep->namelen,
> +						args->name, args->namelen);

And again, the same applies. :)

...
> +				}
>  			}
>  		}
>  	}

Side note: That's a lot of nesting...yuck :)

Josef 'Jeff' Sipek.

-- 
UNIX is user-friendly ... it's just selective about who it's friends are
