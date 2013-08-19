Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 949587F82
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 18:41:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E3FEAC001
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 16:41:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	R5u7Jfb0T9alMnF2 for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 16:41:04 -0700 (PDT)
Date: Tue, 20 Aug 2013 09:40:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130819234057.GB6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130819201940.516942026@sgi.com>
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

On Mon, Aug 19, 2013 at 03:19:36PM -0500, Mark Tinguely wrote:
> Add XFS superblock v4 support for the file type field in the
> directory entry feature.
> 
> This support adds a feature bit for version 4 superblocks and
> leaves the original superblock 5 incompatibility bit.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_sb.h |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: b/fs/xfs/xfs_sb.h
> ===================================================================
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
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
>  }

Ok, that's the 5 lines of kernel code I mentioned it would take to
enable it. Like I said, the code to enable it is the simple part.

There's a fair bit more to getting it into releaseable state, though:

	- XFS_IOC_FSGEOM support to export the feature bit to
	  userspace. It needs to be consistent across v4/v5
	  filesystems, too.
	- xfs_db support:
		- needs to understand the feature bit in the version
		  command
		- both v4/v5 need to output the new feature bit text
		  to say it's enabled
		- all the dtype stuff is plumbed directly into the
		  v3 directory decoding, not the v2 directory
		  decoding. New display fields will have to be added
		  to the v2 directory decoding and display made
		  conditional on the XFS_SB_VERSION2_FTYPE bit being
		  set.
	- xfs_info needs to output the state of support, consistent
	  for v4/v5
	- mkfs.xfs needs a new command line option to turn the
	  feature on, new output to indicate it's state. output
	  needs to be consistent for v4/v5, but the command line
	  option is only valid for v4 superblock filesystems

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
