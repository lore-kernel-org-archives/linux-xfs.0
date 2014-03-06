Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EB58E7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 12:05:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD7EF8F8068
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 10:05:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id HC1E2ZHnEhhkMsHq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 10:05:35 -0800 (PST)
Date: Thu, 6 Mar 2014 10:05:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC, PATCH] xfs: make superblock version checks reflect reality
Message-ID: <20140306180534.GA305@infradead.org>
References: <1394088890-10713-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1394088890-10713-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 06, 2014 at 05:54:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We only support filesystems that have v2 directory support, and than
> means all the checking and handling of superblock versions prior to
> this support being added is completely unnecessary overhead.
> 
> Strip out all the version 1-3 support, sanitise the good version
> checking to reflect the supported versions, update all the feature
> supported functions and clean up all the support bit definitions to
> reflect the fact that we no longer care about Irix bootloader flag
> regions for v4 feature bits.

Good idea in general, I like it.

> Because the feature bit checking is all inline code, this relatively
> small cleanup has a noticable impact on code size:

I initially though moving it out of line might not be a bad idea,
but it seems after your diet it's lean enough to not bother.

> +/*
> + * We only support superblocks that have at least V2 Dir capability. Any feature
> + * bit added after v2 dir capability is also indicates a supported superblock
> + * format.
> + */
> +#define XFS_SB_NEEDED_FEATURES		\
> +	(XFS_SB_VERSION_DIRV2BIT	| \
> +	 XFS_SB_VERSION_LOGV2BIT	| \
> +	 XFS_SB_VERSION_SECTORBIT	| \
> +	 XFS_SB_VERSION_BORGBIT		| \
>  	 XFS_SB_VERSION_MOREBITSBIT)

This seems a bit odd.  Shouldn't we simply check for
XFS_SB_VERSION_DIRV2BIT as we actually rely on that?  What if SGI had
backported any of those other features to some IRIX branch?

I'd vote to kill XFS_SB_NEEDED_FEATURES and just check the dirv2 bit
explicitly.

> +/*
> + * Supported feature bit list is just all bits in the versionnum field because
> + * we've used them all up and understand them all.
> + */
> +#define	XFS_SB_VERSION_OKBITS		\
> +	(XFS_SB_VERSION_NUMBITS		| \
> +	 XFS_SB_VERSION_ALLFBITS)
>  

> +#define	XFS_SB_VERSION2_OKBITS		\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
>  	 XFS_SB_VERSION2_PROJID32BIT	| \
>  	 XFS_SB_VERSION2_FTYPE)

> +/*
> + * The first XFS version we support is filesytsems with V2 directories.
> + */

is a v4 superblock with v2 directories?

Also filesystem is mis-spelled.

>  static inline int xfs_sb_good_version(xfs_sb_t *sbp)
>  {
> +	/* We only support v4 and v5 */
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4 ||
> +	    XFS_SB_VERSION_NUM(sbp) > XFS_SB_VERSION_5)
> +		return 0;
> +
> +	/*
> +	 * Version 5 feature checks are done separately.
> +	 */
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
>  		return 1;

How about doing this a little different?

static inline int xfs_sb_good_version(struct xfs_sb *sbp)
{
	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
		return 1;
	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
		return xfs_sb_good_v4_features(sbp);
	return 0;
}

then move the bulk of the function into xfs_sb_good_v4_features?


> +	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> +	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> +	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
>  			return 0;
> +	if (sbp->sb_shared_vn > XFS_SB_MAX_SHARED_VN)
> +		return 0;

Given that XFS_SB_MAX_SHARED_VN we might as well make that and != 0
check and document that we don't support any shared superblocks.

>  static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
>  {
> +	return !!(sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
>  }

Should this become a bool?

>  
>  static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
>  {
> +	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
>  }

I'd rather not keep the wrappers for adding these flags - the callers
already know sb internals, might as well not keep a false abstraction
here.

>  static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
>  {
> -	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> -		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> -		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
> +	return !!(sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT);
>  }

As we reject filesystems without the nlink bit we should just be able
to kill all code protected by xfs_sb_version_hasnlink checks, shouldn't
we?

>  static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
>  {
> +	sbp->sb_versionnum |= XFS_SB_VERSION_NLINKBIT;
>  }

Same for addnlink.

>  static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
>  {
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> -	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT));
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> +	       (sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
>  }

dirv2 is another candidate.

> @@ -536,11 +493,13 @@ static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
>  {
>  	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
>  	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
> +	sbp->sb_bad_features2 |= XFS_SB_VERSION2_ATTR2BIT;
>  }
>  
>  static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
>  {
>  	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
> +	sbp->sb_bad_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;

Where is this coming from?  Seems unrelated to the other changes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
