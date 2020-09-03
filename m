Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CBD7C433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 22:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35522078E
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 22:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgICWvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 18:51:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51029 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbgICWvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 18:51:50 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 34565823BAE;
        Fri,  4 Sep 2020 08:51:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kDy53-0005ZE-2v; Fri, 04 Sep 2020 08:51:45 +1000
Date:   Fri, 4 Sep 2020 08:51:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: Extend data/attr fork extent counter width
Message-ID: <20200903225145.GG12131@dread.disaster.area>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
 <20200831130010.454-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130010.454-4-chandanrlinux@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=GLYkvaZC_UxQb3cd8-QA:9 a=HZneWTcpzGKC_oNA:21 a=9pUSZsFkhPMksCTZ:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:30:10PM +0530, Chandan Babu R wrote:
> The commit xfs: fix inode fork extent count overflow
> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> data fork extents should be possible to create. However the
> corresponding on-disk field has a signed 32-bit type. Hence this
> commit extends the per-inode data extent counter to 47 bits. The
> length of 47-bits was chosen because,
> Maximum file size = 2^63.
> Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.
> 
> Also, XFS has a per-inode xattr extent counter which is 16 bits
> wide. A workload which
> 1. Creates 1 million 255-byte sized xattrs,
> 2. Deletes 50% of these xattrs in an alternating manner,
> 3. Tries to insert 400,000 new 255-byte sized xattrs
>    causes the xattr extent counter to overflow.
> 
> Dave tells me that there are instances where a single file has more than
> 100 million hardlinks. With parent pointers being stored in xattrs, we
> will overflow the signed 16-bits wide xattr extent counter when large
> number of hardlinks are created. Hence this commit extends the on-disk
> field to 32-bits.
> 
> The following changes are made to accomplish this,
> 
> 1. A new incompat superblock flag to prevent older kernels from mounting
>    the filesystem. This flag has to be set during mkfs time.
> 2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 15 bits of the data extent counter.
> 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 16 bits of the attr extent counter.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c        |  8 ++++---
>  fs/xfs/libxfs/xfs_format.h      | 20 ++++++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c   | 42 ++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_inode_buf.h   |  4 ++--
>  fs/xfs/libxfs/xfs_inode_fork.h  | 17 +++++++++----
>  fs/xfs/libxfs/xfs_log_format.h  |  8 ++++---
>  fs/xfs/libxfs/xfs_types.h       | 10 ++++----
>  fs/xfs/scrub/inode.c            |  2 +-
>  fs/xfs/xfs_inode.c              |  2 +-
>  fs/xfs/xfs_inode_item.c         | 12 ++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 20 ++++++++++++----
>  11 files changed, 105 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 16b983b8977d..8788f47ba59e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	uint		maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -64,7 +64,9 @@ xfs_bmap_compute_maxlevels(
>  	 * The maximum number of extents in a file, hence the maximum number of
>  	 * leaf entries, is controlled by the size of the on-disk extent count,
>  	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> -	 * number for the attr fork.
> +	 * number for the attr fork. With mkfs.xfs' wide-extcount option
> +	 * enabled, the data fork extent count is unsigned 47-bits wide, while
> +	 * the corresponding attr fork extent count is unsigned 32-bits wide.

This doesn't really need to state what the sizes of the on disk
fields are. If anything should state that, it's a description of the
helper function that returns the maximum supported extent count.
Also, it's the maximum extents in a the fork, not the _file_.

i.e. this should probably just read

	 * The maximum number of extents in a fork, hence the maximum number of
	 * leaf entries, is controlled by the size of the on-disk extent count.

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5f41e177dbda..2684cafd0356 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> -#define XFS_SB_FEAT_INCOMPAT_ALL \
> +#define XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT	(1 << 3)	/* Wider data/attr fork extent counters */
> +#define XFS_SB_FEAT_INCOMPAT_ALL		\
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> +		 XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT)

Don't we normally add the feature bit in a standalone patch once all
the infrastructure has already been put in place?

>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -551,6 +553,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
>  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
>  }
>  
> +static inline bool xfs_sb_version_haswideextcnt(struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT);
> +}

I don't really like the name of the feature :/

Precendence in naming feature additions like this is "32 bit project
IDs" - when we extended them from 16 to 32 bits, we didn't call them
"wide project IDs" as "wide" could mean anything. What do we do if
we later need to increase the size of the attribute fork extent
count? :/

xfs_sb_version_hasextcount_64bit() would match the 
xfs_sb_version_hasprojid_32bit() naming internally....

>  static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
>  {
>  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> @@ -873,8 +881,8 @@ typedef struct xfs_dinode {
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be32		di_nextents_lo;	/* lower part of data fork extent count */
> +	__be16		di_anextents_lo;/* lower part of attr fork extent count */
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> @@ -891,7 +899,9 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__be32		di_nextents_hi; /* higher part of data fork extent count */
> +	__be16		di_anextents_hi;/* higher part of attr fork extent count */
> +	__u8		di_pad2[6];	/* more padding for future expansion */

I think I've mentioned this before - I don't really like extending
inode variables this way. We did it for projid32 because we did not
have any spare space in the v4 inode to do anything else.

I would kinda prefer to do something like this:

-	__be32		di_nextents;	/* number of extents in data fork */
-	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__be32		di_nextents32;	/* 32 bit fork extent count */
+	__be16		di_nextents16;	/* 16 bit fork extent count */
....
-	__u8		di_pad2[12];	/* more padding for future expansion */
+	__u8		di_pad2[4];	/* more padding for future expansion */
+	__be64		di_nextents64;	/* 64 bit fork extent count */


And then depending on the hasextcount_64bit bit is set, we read from
disk like this:

	if (hasextcount_64bit) {
		to->di_nextents = be64_to_cpu(dip->di_nextents64);
		to->di_naextents = be32_to_cpu(dip->di_nextents32);
		if (dip->di_nextents16 != 0)
			return -EFSCORRUPTED;
	} else {
		to->di_nextents = be32_to_cpu(dip->di_nextents32);
		to->di_naextents = be16_to_cpu(dip->di_nextents16);
		if (dip->di_nextents64 != 0)
			return -EFSCORRUPTED;
	}

and the writing to disk is equally simple. There's no bit shifting
or masking, and we still end up with the same amount of unused space
in the inode when hasextcount_64bit is set because di_nextents16 can
be reused by another new feature....

> @@ -408,10 +425,17 @@ xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
>  {
>  	xfs_extnum_t nextents;
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		nextents = be32_to_cpu(dip->di_nextents);
> -	else
> -		nextents = be16_to_cpu(dip->di_anextents);
> +	if (whichfork == XFS_DATA_FORK) {
> +		nextents = be32_to_cpu(dip->di_nextents_lo);
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			nextents |=
> +				((xfs_extnum_t)be32_to_cpu(dip->di_nextents_hi) << 32);
> +	} else {
> +		nextents = be16_to_cpu(dip->di_anextents_lo);
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			nextents |=
> +				((xfs_aextnum_t)be16_to_cpu(dip->di_anextents_hi) << 16);
> +	}

... and we get rid of this bit of messy code :)

> @@ -157,10 +157,17 @@ static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
>  {
>  	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		return MAXEXTNUM;
> -	else
> -		return MAXAEXTNUM;
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			return MAXEXTNUM_HI;
> +		else
> +			return MAXEXTNUM;
> +	} else {
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			return MAXAEXTNUM_HI;
> +		else
> +			return MAXAEXTNUM;
> +	}

I think we should actually rework MAXEXTNUM/MAXAEXTNUM before doing
this. They are defined in xfs_types.h as in-memory limits, while
these are actually returning on-disk format limits which should be
defined in xfs_format.h

e.g:

#define XFS_IFORK_EXTCNT_MAX64	....
#define XFS_IFORK_EXTCNT_MAX32	....
#define XFS_IFORK_EXTCNT_MAX16	....

And in xfs_iext_max() we do:

	bool has64 = xfs_sb_version_haswideextcnt()

	switch (whichfork) {
	case XFS_DATA_FORK:
		return has64 ? XFS_IFORK_EXTCNT_MAX64 : XFS_IFORK_EXTCNT_MAX32;
	case XFS_ATTR_FORK:
		return has64 ? XFS_IFORK_EXTCNT_MAX32 : XFS_IFORK_EXTCNT_MAX16;
	case XFS_COW_FORK:
		return XFS_IFORK_EXTCNT_MAX32;
	default:
		ASSERT(0);
		break;
	}
	return -EFSCORRUPTED;

> @@ -59,8 +59,10 @@ typedef void *		xfs_failaddr_t;
>   * Max values for extlen, extnum, aextnum.
>   */
>  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +#define	MAXEXTNUM	((int32_t)0x7fffffff)		/* signed int */
> +#define	MAXAEXTNUM	((int16_t)0x7fff)		/* signed short */
> +#define MAXEXTNUM_HI	((xfs_extnum_t)0x7fffffffffff)	/* unsigned 47 bits */
> +#define MAXAEXTNUM_HI	((xfs_aextnum_t)0xffffffff)	/* unsigned 32 bits */

Yeah, these on-disk limits need to go into xfs_format.h and not used
directly anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
