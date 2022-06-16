Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFECC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 06:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350832AbiFPGDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 02:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358882AbiFPGDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 02:03:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23C2014080
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 23:03:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 301495ECA28;
        Thu, 16 Jun 2022 16:03:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1ib0-007EGI-FI; Thu, 16 Jun 2022 16:03:10 +1000
Date:   Thu, 16 Jun 2022 16:03:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 14/17] xfs: Add the parent pointer support to the
  superblock version 5.
Message-ID: <20220616060310.GE227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-15-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62aac7a0
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=eJfxgxciAAAA:8 a=20KFwNOVAAAA:8
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=JQU8rhjtgctiLvxI8rIA:9
        a=CjuIK1q_8ugA:10 a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:57AM -0700, Allison Henderson wrote:
> [dchinner: forward ported and cleaned up]
> [achender: rebased and added parent pointer attribute to
>            compatible attributes mask]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 14 +++++++++-----
>  fs/xfs/libxfs/xfs_fs.h     |  1 +
>  fs/xfs/libxfs/xfs_sb.c     |  2 ++
>  fs/xfs/xfs_super.c         |  4 ++++
>  4 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 96976497306c..e85d6b643622 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -83,6 +83,7 @@ struct xfs_ifork;
>  #define	XFS_SB_VERSION2_OKBITS		\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
> +	 XFS_SB_VERSION2_PARENTBIT	| \
>  	 XFS_SB_VERSION2_PROJID32BIT	| \
>  	 XFS_SB_VERSION2_FTYPE)

No need for a v4 filesystem format feature bit - this is v4 only.

>  
> @@ -353,11 +354,13 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 4)		/* parent inode ptr */
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> -		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> +		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
> +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> +		 XFS_SB_FEAT_RO_COMPAT_PARENT)

I'm not sure this is a RO Compat feature - we added an attribute
namespace flag on disk, and the older kernels do not know about
that (i.e. we changed XFS_ATTR_NSP_ONDISK_MASK). This may result in
parent pointer attrs being exposed as user attrs rather than being
hidden, or maybe parent pointer attrs being seen as corrupt because
they have a flag that isn't defined set, etc.

Hence I'm not sure that this classification is correct.

>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> @@ -392,7 +395,8 @@ xfs_sb_has_incompat_feature(
>  
>  static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
>  {
> -	return false; /* We'll enable this at the end of the set */
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_PARENT));
>  }

This should go away and the feature bit in the mount get set by
xfs_sb_version_to_features().

>  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 1cfd5bc6520a..b0b4d7a3aa15 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
>  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
>  #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
> +#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
>  
>  /*
>   * Minimum and maximum sizes need for growth checks.
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a20cade590e9..d90b05456dba 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1187,6 +1187,8 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
>  	if (xfs_has_inobtcounts(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
> +	if(xfs_sb_version_hasparent(sbp))

	if (xfs_has_parent_pointers(mp))

> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
>  	if (xfs_has_sector(mp)) {
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
>  		geo->logsectsize = sbp->sb_logsectsize;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a6e7b4176faf..cbb492fea4a5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1655,6 +1655,10 @@ xfs_fs_fill_super(
>  		xfs_warn(mp,
>  	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
>  
> +	if (xfs_sb_version_hasparent(&mp->m_sb))

	if (xfs_has_parent_pointers(mp))

> +		xfs_alert(mp,
> +	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> -- 
> 2.25.1
> 
> 

-- 
Dave Chinner
david@fromorbit.com
