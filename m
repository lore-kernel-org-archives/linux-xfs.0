Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9DF47F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 16:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7A5F8F8040
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 14:26:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JRtBu3G3w50xEFgn for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 14:26:00 -0700 (PDT)
Date: Tue, 7 Oct 2014 08:25:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/16] xfs: add a superblock feature bit to indicate
	UTF-8 support.
Message-ID: <20141006212558.GF2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003215945.GH1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003215945.GH1865@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 04:59:46PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> When UTF-8 support is enabled, the xfs_dir_ci_inode_operations must be
> installed. Add xfs_sb_version_hasci(), which tests both the borgbit and
> the utf8bit, and returns true if at least one of them is set. Replace
> calls to xfs_sb_version_hasasciici() as needed.
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>
> ---
>  fs/xfs/libxfs/xfs_sb.h | 24 +++++++++++++++++++++++-
>  fs/xfs/xfs_fs.h        |  1 +
>  fs/xfs/xfs_fsops.c     |  4 +++-
>  fs/xfs/xfs_iops.c      |  4 ++--
>  4 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 2e73970..525eacb 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -70,6 +70,7 @@ struct xfs_trans;
>  #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
>  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
>  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
> +#define XFS_SB_VERSION2_UTF8BIT		0x00000020      /* utf8 names */
>  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */

Can you explain why this bit is safe to use? I don't recall why
XFS_SB_VERSION2_PROJID32BIT skipped several bits because there
aren't any comments explaining why that value was chosen. Adding a
comment about the 0x00000040 bit at the same time would be useful.

>  #define XFS_SB_VERSION2_CRCBIT		0x00000100	/* metadata CRCs */
>  #define XFS_SB_VERSION2_FTYPE		0x00000200	/* inode type in dir */
> @@ -77,6 +78,7 @@ struct xfs_trans;
>  #define	XFS_SB_VERSION2_OKBITS		\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
> +	 XFS_SB_VERSION2_UTF8BIT	| \
>  	 XFS_SB_VERSION2_PROJID32BIT	| \
>  	 XFS_SB_VERSION2_FTYPE)
>  
> @@ -509,8 +511,10 @@ xfs_sb_has_ro_compat_feature(
>  }
>  
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> +#define XFS_SB_FEAT_INCOMPAT_UTF8	(1 << 1)	/* utf-8 name support */
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
> -		(XFS_SB_FEAT_INCOMPAT_FTYPE)
> +		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> +		 XFS_SB_FEAT_INCOMPAT_UTF8)

Don't add support to the filesystem until all the supporting
code is in place. This avoids git bisects landing on commits in the
series where the filesystem says it supports the feature bit it
doesn't actually work. Add a patch at the end of the series that
adds these bits to the feature masks.

>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -558,6 +562,24 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
>  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
>  }
>  
> +static inline int xfs_sb_version_hasutf8(xfs_sb_t *sbp)

bool, no typedefs.

> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UTF8)) ||
> +		(xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_UTF8BIT));

xfs_sb_version_hasmorebits() already checks for XFS_SB_VERSION_5,
so this could be:

	return xfs_sb_version_hasmorebits(sbp) &&
		(xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UTF8) ||
		 (sbp->sb_features2 & XFS_SB_VERSION2_UTF8BIT));


> +}
> +
> +/*
> + * Special case: there are a number of places where we need to test
> + * both the borgbit and the utf8bit, and take the same action if
> + * either of those is set.
> + */
> +static inline int xfs_sb_version_hasci(xfs_sb_t *sbp)
> +{

bool, no typedefs, and probably should be a separate patch.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
