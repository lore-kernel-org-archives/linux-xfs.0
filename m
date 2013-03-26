Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F3D87CBF
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 15:59:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CEF630407A
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 13:59:03 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id zOF4fwjj6DEpQucz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 13:58:59 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 26 Mar 2013 14:58:58 -0600
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 0E0D46E8040
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 16:58:53 -0400 (EDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2QKwoLR338494 for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 16:58:52 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2QKwobo030588
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 14:58:50 -0600
Subject: Re: [PATCH 21/21] xfs: add CRC checks to the superblock
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1363091454-8852-22-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-22-git-send-email-david@fromorbit.com>
Date: Tue, 26 Mar 2013 15:58:47 -0500
Message-ID: <1364331527.32345.135.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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

On Tue, 2013-03-12 at 23:30 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the addition of CRCs, there is such a wide and varied change to
> the on disk format that it makes sense to bump the superblock
> version number rather than try to use feature bits for all the new
> functionality.
> 
> This commit introduces all the new superblock fields needed for all
> the new functionality: feature masks similar to ext4, separate
> project quota inodes, a LSN field for recovery and the CRC field.
> 
> This commit does not bump the superblock version number, however.
> That will be done as a separate commit at the end of the series
> after all the new functionality is present so we switch it all on in
> one commit. This means that we can slowly introduce the changes
> without them being active and hence maintain bisectability of the
> tree.
> 
> This patch is based on a patch originally written by myself back
> from SGI days, which was subsequently modified by Christoph Hellwig.
> There is relatively little of that patch remaining, but the history
> of the patch still should be acknowledged here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_log_recover.c |    8 ++++
>  fs/xfs/xfs_mount.c       |   97 ++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_mount.h       |    1 +
>  fs/xfs/xfs_sb.h          |  100 ++++++++++++++++++++++++++++++++--------------
>  5 files changed, 164 insertions(+), 46 deletions(-)

<snip>

> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index a05b451..457fefa 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -32,6 +32,7 @@ struct xfs_mount;
>  #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
>  #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
>  #define	XFS_SB_VERSION_4	4		/* 6.2+ - bitmask version */
> +#define	XFS_SB_VERSION_5	5		/* CRC enabled filesystem */
>  #define	XFS_SB_VERSION_NUMBITS		0x000f
>  #define	XFS_SB_VERSION_ALLFBITS		0xfff0
>  #define	XFS_SB_VERSION_SASHFBITS	0xf000
> @@ -161,6 +162,18 @@ typedef struct xfs_sb {
>  	 */
>  	__uint32_t	sb_bad_features2;
> 
> +	/* version 5 superblock fields start here */
> +
> +	/* feature masks */
> +	__uint32_t	sb_features_compat;
> +	__uint32_t	sb_features_ro_compat;
> +	__uint32_t	sb_features_incompat;
> +
> +	__uint32_t	sb_crc;		/* superblock crc */
> +
> +	xfs_ino_t	sb_pquotino;	/* project quota inode */
> +	xfs_lsn_t	sb_lsn;		/* last write sequence */
> +
>  	/* must be padded to 64 bit alignment */
>  } xfs_sb_t;
> 
> @@ -229,7 +242,19 @@ typedef struct xfs_dsb {
>  	 * for features2 bits. Easiest just to mark it bad and not use
>  	 * it for anything else.
>  	 */
> -	__be32	sb_bad_features2;
> +	__be32		sb_bad_features2;
> +
> +	/* version 5 superblock fields start here */
> +
> +	/* feature masks */
> +	__be32		sb_features_compat;
> +	__be32		sb_features_ro_compat;
> +	__be32		sb_features_incompat;
> +
> +	__le32		sb_crc;		/* superblock crc */
> +
> +	__be64		sb_pquotino;	/* project quota inode */
> +	__be64		sb_lsn;		/* last write sequence */
> 
>  	/* must be padded to 64 bit alignment */
>  } xfs_dsb_t;
> @@ -250,7 +275,9 @@ typedef enum {
>  	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
>  	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
>  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
> -	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
> +	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
> +	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT, XFS_SBS_CRC,
> +	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
>  	XFS_SBS_FIELDCOUNT
>  } xfs_sb_field_t;
> 
> @@ -276,6 +303,11 @@ typedef enum {
>  #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
>  #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
>  #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
> +#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
> +#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
> +#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
> +#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
> +#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)

missing define for XFS_SB_LSN ?!

>  #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
>  #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
>  #define	XFS_SB_MOD_BITS		\
> @@ -283,7 +315,8 @@ typedef enum {
>  	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
>  	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
>  	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
> -	 XFS_SB_BAD_FEATURES2)
> +	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
> +	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | XFS_SB_PQUOTINO)

missing XFS_SB_LSN ?!
> 
> 
>  /*
> @@ -325,6 +358,8 @@ static inline int xfs_sb_good_version(xfs_sb_t *sbp)
> 
>  		return 1;
>  	}
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> +		return 1;
> 
>  	return 0;
>  }
> @@ -365,7 +400,7 @@ static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
>  {
>  	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
>  		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> -		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
>  }

Do you expect version 5 and later have this bit to be exclusively set to
use attribues ? (i.e can't we just assume version 5 and later would have
attributes ?)

Since we are changing the version, can't we get rid of some on these
bits (i.e slowly deprecate them) ? 

> 
> @@ -373,7 +408,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
>  {
>  	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
>  		sbp->sb_versionnum = XFS_SB_VERSION_2;
> -	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> +	else if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
>  		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
>  	else
>  		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
> @@ -382,7 +417,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
>  static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
>  {
>  	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
> -		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));

Same here
>  }
> 
> @@ -396,13 +431,13 @@ static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
> 
>  static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);

same here

>  }
> 
>  static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
>  {
> -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> +	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
>  		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
>  	else
>  		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
> @@ -411,13 +446,14 @@ static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
> 
>  static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> +		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
>  }

same here
> 
>  static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
>  }

same here

> 
> @@ -429,38 +465,42 @@ static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
> 
>  static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||

Why some places we have version == 5 and others (version == 5 && (XXX))


> +	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT));
>  }
> 
>  static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
> +		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT));
>  }
> 
>  static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT));
>  }
> 
>  static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
>  }
> 
>  static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
>  		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
>  }

same here ?!
> 
>  static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
>  {
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> -		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
> +		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT));

Gets more confusing here. version 5 means it has more bits ? (even if
the MOREBITSBIT is not set ?

May be we shouldn't add version 5 check here ?!
>  }
> 
>  /*
> @@ -475,14 +515,16 @@ static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
> 
>  static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
>  {
> -	return xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
>  }

If we remove the version 5 check in xfs_sb_hasmorebits(), then this
change is correct. Otherwise, this change is not needed.

> 
>  static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
>  {
> -	return xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
>  }

If we remove the version 5 check in xfs_sb_hasmorebits(), then this
change is correct. Otherwise, this change is not needed.

> 
>  static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
> @@ -500,14 +542,14 @@ static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
> 
>  static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
>  {
> -	return xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> +	       (xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
>  }
If we remove the version 5 check in xfs_sb_hasmorebits(), then this
change is correct. Otherwise, this change is not needed.

> 
>  static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
>  {
> -	return (xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;

what happens to the superblocks that already have version 4 and this bit
set ?


Also don't xfs_sb_version_toold() and xfs_sb_version_tonew() need
changes ?

I see that xfs_sb_version_toold() is not used anywhere, can we remove
it ?
>  }
> 
>  /*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
