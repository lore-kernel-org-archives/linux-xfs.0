Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB49C7F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 02:52:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E0F98F80D4
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:52:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UPpl6XKw2zDOqG6Q for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 00:52:22 -0700 (PDT)
Date: Thu, 11 Jul 2013 17:52:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
Message-ID: <20130711075208.GB3438@dastard>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373518843-1492-3-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 12:00:41AM -0500, Chandra Seetharaman wrote:
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_mount.c             |   62 ++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_qm.c                |   28 +++++++++--------
>  fs/xfs/xfs_qm_syscalls.c       |   21 +++++++++++++-
>  fs/xfs/xfs_sb.h                |    9 +++++-
>  fs/xfs/xfs_super.c             |   19 ++++++------
>  include/uapi/linux/dqblk_xfs.h |    1 +
>  6 files changed, 108 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2b0ba35..b8a633b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -336,12 +336,17 @@ xfs_mount_validate_sb(
>  		return XFS_ERROR(EWRONGFS);
>  	}
>  
> -	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> -			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> -				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> -		xfs_notice(mp,
> -"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
> -		return XFS_ERROR(EFSCORRUPTED);
> +	if (xfs_sb_version_has_pquota(sbp)) {
> +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> +			xfs_notice(mp,
> +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> +			return XFS_ERROR(EFSCORRUPTED);
> +		}
> +	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> +			xfs_notice(mp,
> +"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
> +			return XFS_ERROR(EFSCORRUPTED);
>  	}

Can you move this to after we've checked the 5 superblock feature
masks for whether the kernel supports the various features the
superblock defines - feature support checks need to come before
checking superblock fields for validity....

> @@ -570,8 +575,13 @@ out_unwind:
>  }
>  
>  static void
> -xfs_sb_quota_from_disk(struct xfs_sb *sbp)
> +xfs_sb_quota_from_disk(struct xfs_mount *mp)
>  {
> +	struct xfs_sb *sbp = &mp->m_sb;
> +
> +	if (xfs_sb_version_has_pquota(sbp))
> +		return;
> +
>  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
>  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
>  					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> @@ -579,6 +589,18 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +
> +	if (!xfs_sb_version_has_pquota(sbp) && (XFS_IS_PQUOTA_ON(mp))) {
> +		/*
> +		 * On disk superblock only has sb_gquotino, and incore
> +		 * superblock has both sb_gquotino and sb_pquotino.
> +		 * But, only one them is supported at any point of time.
> +		 * So, if PQUOTA is set in disk superblock, copy over
> +		 * sb_gquotino to sb_pquotino.
> +		 */
> +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +		mp->m_sb.sb_gquotino = NULLFSINO;
> +	}
>  }

Why is this using mp rather than sbp? Indeed, this should be passed
the superblock as a parameter (as per the previous version of the
code) as the superblock we are writing into is determined by the
caller. e.g. what if we want to do this conversion in
xfs_sb_verify() and are using the on-stack struct xfs_sb?

Also, why should a mount option determine how we interpret the
on-disk format? i.e. the XFS_IS_PQUOTA_ON() check? The superblock
itself describes which quota the sb_gquotino contains (i.e. what is
in from->sb_qflags) and that alone determines which field the
on-disk inode gets copied into.

If the mount options then don't line up with what is in the
superblock, then the quota mount checks will handle that
appropriately.

>  
>  void
> @@ -650,6 +672,13 @@ xfs_sb_quota_to_disk(
>  {
>  	__uint16_t	qflags = from->sb_qflags;
>  
> +	/*
> +	 * We need to do these manipilations only if we are working
> +	 * with an older version of on-disk superblock.
> +	 */
> +	if (xfs_sb_version_has_pquota(from))
> +		return;
> +
>  	if (*fields & XFS_SB_QFLAGS) {
>  		/*
>  		 * The in-core version of sb_qflags do not have
> @@ -669,6 +698,23 @@ xfs_sb_quota_to_disk(
>  		to->sb_qflags = cpu_to_be16(qflags);
>  		*fields &= ~XFS_SB_QFLAGS;
>  	}
> +
> +	if (*fields & XFS_SB_PQUOTINO && *fields & XFS_SB_GQUOTINO) {

gcc will throw warnings on that code. The normal way of checking
multiple flag fields is:

	if ((*fields & (XFS_SB_PQUOTINO|XFS_SB_GQUOTINO)) ==
		       (XFS_SB_PQUOTINO|XFS_SB_GQUOTINO)) {

> +		/*
> +		 * PQUOTINO and GQUOTINO cannot be used together in versions
> +		 * of superblock that do not have pquotino. If used, use
> +		 * sb_flags to resolve which one should be set.
> +		*/
> +		if (from->sb_qflags & XFS_PQUOTA_ACCT)
> +			*fields &= ~XFS_SB_GQUOTINO;
> +		else
> +			*fields &= ~XFS_SB_PQUOTINO;
> +	}
> +
> +	if (*fields & XFS_SB_PQUOTINO) {
> +		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> +		*fields &= ~XFS_SB_PQUOTINO;
> +	}

Better yet:

	/*
	 * GQUOTINO and PQUOTINO cannot be used together in versions
	 * of superblock that do not have pquotino. from->sb_flags
	 * tells us which quota is active and should be copied to
	 * disk.
	 */
	if ((*fields & XFS_SB_GQUOTINO) && (from->sb_qflags & XFS_GQUOTA_ACCT))
		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
	else if ((*fields & XFS_SB_PQUOTINO) && (from->sb_qflags & XFS_PQUOTA_ACCT))
		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);

	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);

>  }
>  
>  /*
> @@ -885,7 +931,7 @@ reread:
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
>  
> -	xfs_sb_quota_from_disk(&mp->m_sb);
> +	xfs_sb_quota_from_disk(mp);

As I commented above, we need to pass the superblock separately.

> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index 78f9e70..d372fdf 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -621,7 +621,14 @@ xfs_sb_has_incompat_log_feature(
>  static inline bool
>  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  {
> -	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
> +	return (ino == sbp->sb_uquotino ||
> +		ino == sbp->sb_gquotino ||
> +		ino == sbp->sb_pquotino);
> +}

Can you move this function down below the comment in xfs_sb.h that
says:

/*
 * end of superblock version macros
 */

> +
> +static inline int xfs_sb_version_has_pquota(xfs_sb_t *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>  }

And leave this above it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
