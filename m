Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 791C87F37
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 17:52:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0B1E3AC005
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 15:52:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cBrOE7iXjKYOSy3h for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 15:52:50 -0700 (PDT)
Date: Fri, 20 Sep 2013 08:52:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfsprog: add xfs sb v4 support for dirent filetype
	field
Message-ID: <20130919225243.GK9901@dastard>
References: <20130919211523.407741285@sgi.com>
	<20130919211539.028138471@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130919211539.028138471@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 19, 2013 at 04:05:24PM -0500, Mark Tinguely wrote:
> Add xfsprog superblock v4 support for the directory inode type
> in xfs_sb.h.
> 
> This support adds a feature bit for version 4 superblocks and
> leaves the original superblock 5 incompatibility bit.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
> include/xfs_sb.h |   20 ++++++++++++--------
>  include/xfs_sb.h |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: b/include/xfs_sb.h
> ===================================================================
> --- a/include/xfs_sb.h
> +++ b/include/xfs_sb.h
> @@ -84,11 +84,13 @@ struct xfs_trans;
>  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
>  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
>  #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
> +#define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
>  
>  #define	XFS_SB_VERSION2_OKREALFBITS	\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
> -	 XFS_SB_VERSION2_PROJID32BIT)
> +	 XFS_SB_VERSION2_PROJID32BIT	| \
> +	 XFS_SB_VERSION2_FTYPE)
>  #define	XFS_SB_VERSION2_OKSASHFBITS	\
>  	(0)
>  #define XFS_SB_VERSION2_OKREALBITS	\
> @@ -631,8 +633,10 @@ static inline int xfs_sb_version_has_pqu
>  
>  static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
> +	       (xfs_sb_version_hasmorebits(sbp) &&
> +		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));

This is kinda inefficient. Seeing as I didn't review the kernel
version, I'll review it now. Expand it out:

	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
	       ((XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
	        (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
	        (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT))) &&
	       (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
	

so, really, the check could be refined to:

	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
	       (xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE) ||
	        ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE)));

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
