Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43K1eLn196791 for <xfs@oss.sgi.com>; Thu, 3 May 2012 15:01:40 -0500
Date: Thu, 3 May 2012 15:04:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and
	XFS_OQUOTA_CHKD
Message-ID: <20120503200457.GQ16881@sgi.com>
References: <20120123173243.31735.37262.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173249.31735.17660.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173249.31735.17660.sendpatchset@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:32:49AM -0600, Chandra Seetharaman wrote:
> >From ba28fc49821079a734f24af05671155f6b32b20c Mon Sep 17 00:00:00 2001
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Date: Tue, 13 Dec 2011 15:55:34 -0600
> Subject: [PATCH 1/4] Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
>  start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts.
> 
> No changes is made to the on-disk version of the superblock yet. On-disk
             are						   The 

> copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  db/check.c          |    8 ++++----
>  include/xfs_quota.h |   47 +++++++++++++++++++++++++++++++++--------------
>  include/xfs_sb.h    |   17 ++++++++++++++++-
>  repair/versions.c   |   18 ++++--------------
>  repair/xfs_repair.c |    4 ++--
>  5 files changed, 59 insertions(+), 35 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index e601e0a..f00fae7 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -2883,11 +2883,11 @@ process_inode(
>  			process_quota(IS_USER_QUOTA, id, blkmap);
>  		else if (id->ino == mp->m_sb.sb_gquotino &&
>  			 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
> -			 (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD))
> +			 (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD))
>  			process_quota(IS_GROUP_QUOTA, id, blkmap);
>  		else if (id->ino == mp->m_sb.sb_gquotino &&
>  			 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
> -			 (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD))
> +			 (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD))
>  			process_quota(IS_PROJECT_QUOTA, id, blkmap);
>  	}
>  	if (blkmap)
> @@ -3896,11 +3896,11 @@ quota_init(void)
>  	qgdo = mp->m_sb.sb_gquotino != 0 &&
>  	       mp->m_sb.sb_gquotino != NULLFSINO &&
>  	       (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) &&
> -	       (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
> +	       (mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD);
>  	qpdo = mp->m_sb.sb_gquotino != 0 &&
>  	       mp->m_sb.sb_gquotino != NULLFSINO &&
>  	       (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) &&
> -	       (mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD);
> +	       (mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD);
>  	if (qudo)
>  		qudata = xcalloc(QDATA_HASH_SIZE, sizeof(qdata_t *));
>  	if (qgdo)
> diff --git a/include/xfs_quota.h b/include/xfs_quota.h
> index 5d1f57d..aa583a3 100644
> --- a/include/xfs_quota.h
> +++ b/include/xfs_quota.h
> @@ -154,19 +154,42 @@ typedef struct xfs_qoff_logformat {
>  #define XFS_GQUOTA_ACCT	0x0040  /* group quota accounting ON */
>  
>  /*
> + * Start differentiating group quota and project quota in-core
> + * using distinct flags, instead of using the combined OQUOTA flags.
> + *
> + * Conversion to and from the combined OQUOTA flag (if necessary)
> + * is done only in xfs_sb_{to,from}_disk()
> + */
> +#define XFS_GQUOTA_ENFD 0x0080  /* group quota limits enforced */
> +#define XFS_GQUOTA_CHKD 0x0100  /* quotacheck run on group quotas */
> +#define XFS_PQUOTA_ENFD 0x0200  /* project quota limits enforced */
> +#define XFS_PQUOTA_CHKD 0x0400  /* quotacheck run on project quotas */
> +
> +#define XFS_VALID_QFLAGS(sbp) (xfs_sb_version_hasnooquota(sbp) ? \
> +		(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|XFS_UQUOTA_CHKD| \
> +		 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD| \
> +		 XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD) : \
> +		(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|XFS_UQUOTA_CHKD| \
> +		 XFS_GQUOTA_ACCT|XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD| \
> +		 XFS_PQUOTA_ACCT))
> +
> +/*
>   * Quota Accounting/Enforcement flags
>   */
>  #define XFS_ALL_QUOTA_ACCT	\
>  		(XFS_UQUOTA_ACCT | XFS_GQUOTA_ACCT | XFS_PQUOTA_ACCT)
> -#define XFS_ALL_QUOTA_ENFD	(XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD)
> -#define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
> +#define XFS_ALL_QUOTA_ENFD	\
> +		(XFS_UQUOTA_ENFD | XFS_GQUOTA_ENFD | XFS_PQUOTA_ENFD)
> +#define XFS_ALL_QUOTA_CHKD	\
> +		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
>  
>  #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
>  #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
>  #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
>  #define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
>  #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
> -#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
> +#define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
> +#define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
>  
>  /*
>   * Incore only flags for quotaoff - these bits get cleared when quota(s)
> @@ -184,8 +207,6 @@ typedef struct xfs_qoff_logformat {
>  #define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
>  						   XFS_GQUOTA_ACTIVE | \
>  						   XFS_PQUOTA_ACTIVE))
> -#define XFS_IS_OQUOTA_ON(mp)	((mp)->m_qflags & (XFS_GQUOTA_ACTIVE | \
> -						   XFS_PQUOTA_ACTIVE))
>  #define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
>  #define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
>  #define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
> @@ -260,25 +281,23 @@ typedef struct xfs_qoff_logformat {
>  	((XFS_IS_UQUOTA_ON(mp) && \
>  		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
>  	 (XFS_IS_GQUOTA_ON(mp) && \
> -		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
> -		 (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT))) || \
> +		(mp->m_sb.sb_qflags & XFS_GQUOTA_CHKD) == 0) || \
>  	 (XFS_IS_PQUOTA_ON(mp) && \
> -		((mp->m_sb.sb_qflags & XFS_OQUOTA_CHKD) == 0 || \
> -		 (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT))))
> +		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
>  
>  #define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
>  
>  #define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD)
> +				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
>  
>  #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> -				 XFS_OQUOTA_ENFD|XFS_OQUOTA_CHKD|\
> -				 XFS_GQUOTA_ACCT)
> -
> +				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
> +				 XFS_GQUOTA_ACCT|XFS_GQUOTA_ENFD|\
> +				 XFS_GQUOTA_CHKD)
>  
>  /*
>   * The structure kept inside the xfs_trans_t keep track of dquot changes
> diff --git a/include/xfs_sb.h b/include/xfs_sb.h
> index 5dcc2d7..69c6822 100644
> --- a/include/xfs_sb.h
> +++ b/include/xfs_sb.h
> @@ -81,11 +81,13 @@ struct xfs_mount;
>  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
>  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
>  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
> +#define XFS_SB_VERSION2_NO_OQUOTA	0x00000100	/* sep prj quota inode */
>  
>  #define	XFS_SB_VERSION2_OKREALFBITS	\
>  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
>  	 XFS_SB_VERSION2_ATTR2BIT	| \
> -	 XFS_SB_VERSION2_PROJID32BIT)
> +	 XFS_SB_VERSION2_PROJID32BIT	| \
> +	 XFS_SB_VERSION2_NO_OQUOTA)
>  #define	XFS_SB_VERSION2_OKSASHFBITS	\
>  	(0)
>  #define XFS_SB_VERSION2_OKREALBITS	\
> @@ -510,6 +512,19 @@ static inline void xfs_sb_version_addprojid32bit(xfs_sb_t *sbp)
>  	sbp->sb_bad_features2 |= XFS_SB_VERSION2_PROJID32BIT;
>  }
>  
> +static inline int xfs_sb_version_hasnooquota(xfs_sb_t *sbp)

IIRC, in the kernel you used xfs_sb_version_has_no_oquota.  I think you should
use the same name in xfsprogs.

> +{
> +	return xfs_sb_version_hasmorebits(sbp) &&
> +		(sbp->sb_features2 & XFS_SB_VERSION2_NO_OQUOTA);
> +}
> +
> +static inline void xfs_sb_version_addnooquota(xfs_sb_t *sbp)
> +{
> +	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> +	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;

I'm not sure about this.  I don't think addnooquota necessarily implies a 32
bit project id.  What say you?

Else, the patch looks pretty good.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
