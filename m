Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 407CC7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 23:46:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E9988F8039
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 21:46:09 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iWCFJy52MTfuz3do for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 21:46:06 -0700 (PDT)
Date: Fri, 17 May 2013 14:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 3/5] xfs: Start using pquotaino from the superblock
Message-ID: <20130517044604.GO24635@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-4-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368220889-25188-4-git-send-email-sekharan@us.ibm.com>
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

On Fri, May 10, 2013 at 04:21:27PM -0500, Chandra Seetharaman wrote:
> Define a macro to check if the superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
....

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1b79906..233f88e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -601,21 +601,6 @@ xfs_sb_from_disk(
>  	to->sb_uquotino = be64_to_cpu(from->sb_uquotino);
>  	to->sb_gquotino = be64_to_cpu(from->sb_gquotino);
>  	to->sb_qflags = be16_to_cpu(from->sb_qflags);
> -	if ((to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> -			(to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> -				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> -		xfs_notice(NULL, "Super block has XFS_OQUOTA bits along with "
> -		    "XFS_PQUOTA and/or XFS_GQUOTA bits. Quota check forced.\n");
> -		force_quota_check = true;
> -	}
> -	if (to->sb_qflags & XFS_OQUOTA_ENFD)
> -		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> -					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> -	if (to->sb_qflags & XFS_OQUOTA_CHKD)
> -		to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> -					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> -	to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> -
>  	to->sb_flags = from->sb_flags;
>  	to->sb_shared_vn = from->sb_shared_vn;
>  	to->sb_inoalignmt = be32_to_cpu(from->sb_inoalignmt);
> @@ -636,6 +621,44 @@ xfs_sb_from_disk(
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
>  
> +	if (xfs_sb_version_has_pquota(to)) {
> +		if (to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> +			xfs_notice(NULL, "Super block has XFS_OQUOTA bits "
> +			"with version PQUOTINO. Quota check forced.\n");
> +			to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +			force_quota_check = true;
> +		}
> +		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
> +	} else {
> +		if (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> +			xfs_notice(NULL, "Super block has XFS_[G|P]UOTA "
> +				"bits in version older than PQUOTINO. "
> +				"Quota check forced.\n");
> +
> +			to->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD);
> +			force_quota_check = true;
> +		}
> +
> +		/*
> +		 * On disk superblock qflags uses XFS_OQUOTA.* to support
> +		 * either PQUOTA or GQUOTA. But, in memory qflags uses
> +		 * XFS_PQUOTA.* or XFS_GQUOTA.* depending on which quota
> +		 * is used.
> +		 * Following block translates XFS_OQUOTA.* to either
> +		 * GQUOTA or PQUOTA.
> +		 */
> +		if (to->sb_qflags & XFS_OQUOTA_ENFD)
> +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> +		if (to->sb_qflags & XFS_OQUOTA_CHKD)
> +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
> +		to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +
> +	}
> +
>  	if (force_quota_check)
>  		to->sb_qflags &= ~(XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD);
>  }

This all gets restructured here - as per my previous comments, this
probably should all be in xfs_readsb(), not here.

> @@ -657,27 +680,51 @@ xfs_sb_to_disk(
>  	int		first;
>  	int		size;
>  	__uint16_t	qflags = from->sb_qflags;
> +	xfs_ino_t	gquotino = from->sb_gquotino;
>  
>  	ASSERT(fields);
>  	if (!fields)
>  		return;
>  
> -	if (fields & XFS_SB_QFLAGS) {
> +	if (!xfs_sb_version_has_pquota(from)) {

This should be moved to a separate function, I think.

> +		if (fields & XFS_SB_QFLAGS) {
> +			/*
> +			 * The in-core version of sb_qflags do not have
> +			 * XFS_OQUOTA_* flags, whereas the on-disk version
> +			 * does.  So, convert incore XFS_{PG}QUOTA_* flags
> +			 * to on-disk XFS_OQUOTA_* flags.
> +			 */
> +			qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +					XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> +
> +			if (from->sb_qflags &
> +					(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +				qflags |= XFS_OQUOTA_ENFD;
> +			if (from->sb_qflags &
> +					(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +				qflags |= XFS_OQUOTA_CHKD;

Now that we have the new flags set correct, write it directly to
to->sb_qflags and clear XFS_SB_QFLAGS from the fields varaible.

> +		}
> +
>  		/*
> -		 * The in-core version of sb_qflags do not have
> -		 * XFS_OQUOTA_* flags, whereas the on-disk version
> -		 * does.  So, convert incore XFS_{PG}QUOTA_* flags 
> -		 * to on-disk XFS_OQUOTA_* flags.
> +		 * On-disk version earlier than pquota doesn't have
> +		 * sb_pquotino. so, we need to copy the value to gquotino.
>  		 */
> -		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> -				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> +		if (fields & XFS_SB_PQUOTINO) {
> +			fields &= (__int64_t)~XFS_SB_PQUOTINO;
> +			fields |= (__int64_t)XFS_SB_GQUOTINO;
> +			gquotino = from->sb_pquotino;
> +		}

Same here - write the inode number directly to the to->sb_gquotino
field and clear the XFS_SB_PQUOTINO flag.

>  
> -		if (from->sb_qflags &
> -				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> -			qflags |= XFS_OQUOTA_ENFD;
> -		if (from->sb_qflags &
> -				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> -			qflags |= XFS_OQUOTA_CHKD;
> +		/* If any quota inodes are written, write all quota inodes */
> +		if (fields & (XFS_SB_UQUOTINO|XFS_SB_GQUOTINO))
> +			fields |= (XFS_SB_UQUOTINO|XFS_SB_GQUOTINO);

Why write things that haven't been modified?

> +
> +	} else {
> +		/* If any quota inodes are written, write all quota inodes */
> +		if (fields & (XFS_SB_UQUOTINO | XFS_SB_GQUOTINO
> +							| XFS_SB_PQUOTINO))
> +			fields |= (XFS_SB_UQUOTINO | XFS_SB_GQUOTINO
> +							| XFS_SB_PQUOTINO);

Same - the flags pssed in are supposed to document everything that
has been modified. If the flags passed in are wrong, then fix the
bad callers.....
>  	}

>  
>  	while (fields) {
> @@ -691,6 +738,8 @@ xfs_sb_to_disk(
>  			memcpy(to_ptr + first, from_ptr + first, size);
>  		} else if (f == XFS_SBS_QFLAGS) {
>  			*(__be16 *)(to_ptr + first) = cpu_to_be16(qflags);
> +		} else if (f == XFS_SBS_GQUOTINO) {
> +			*(__be64 *)(to_ptr + first) = cpu_to_be64(gquotino);

If we clear the XFS_SBS_GQUOTINO/XFS_SBS_QFLAGS flags like I
suggested above, this grot can go away and the loop remain
completely generic.

>  		} else {
>  			switch (size) {
>  			case 2:
> @@ -872,6 +921,18 @@ reread:
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
>  
> +	if (!xfs_sb_version_has_pquota(&mp->m_sb) && XFS_IS_PQUOTA_ON(mp)) {
> +		/*
> +		 * On disk superblock only has sb_gquotino, and in memory
> +		 * superblock has both sb_gquotino and sb_pquotino. But,
> +		 * only one them is supported at any point of time.
> +		 * So, if PQUOTA is set in disk superblock, copy over
> +		 * sb_gquotino to sb_pquotino.
> +		 */
> +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +		mp->m_sb.sb_gquotino = NULLFSINO;
> +	}

Yup, that's the right place for doing all this on-disk->incore
translation stuff at mount time ;)

> -	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
> +	if (ino == mp->m_sb.sb_uquotino ||
> +	    ino == mp->m_sb.sb_gquotino ||
> +	    ino == mp->m_sb.sb_pquotino) {

Seeing how often this is repeated, perhaps we need a helper function
called "xfs_is_quota_inode(mp, ino)"?

> @@ -1505,7 +1506,7 @@ xfs_qm_init_quotainos(
>  	}
>  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &pip,
> -					     sbflags | XFS_SB_GQUOTINO,
> +					     sbflags | XFS_SB_PQUOTINO,
>  					     flags | XFS_QMOPT_PQUOTA);

Isn't that fixing a bug in the previous patch?

> @@ -412,17 +413,20 @@ xfs_qm_scall_getqstat(
>  	struct fs_quota_stat	*out)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	struct xfs_inode	*uip, *gip;
> -	bool                    tempuqip, tempgqip;
> +	struct xfs_inode	*uip = NULL;
> +	struct xfs_inode	*gip = NULL;
> +	struct xfs_inode	*pip = NULL;
> +	bool                    tempuqip = false;
> +	bool                    tempgqip = false;
> +	bool                    temppqip = false;

See my previous comments about naming variables. At least
add an underscore into the name like temp_uqip....

> @@ -420,12 +420,6 @@ xfs_parseargs(
>  	}
>  #endif
>  
> -	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> -	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
> -		xfs_warn(mp, "cannot mount with both project and group quota");
> -		return EINVAL;
> -	}
> -
>  	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
>  		xfs_warn(mp, "sunit and swidth must be specified together");
>  		return EINVAL;
> @@ -1388,6 +1382,14 @@ xfs_finish_flags(
>  		return XFS_ERROR(EROFS);
>  	}
>  
> +	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> +	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
> +	    !xfs_sb_version_has_pquota(&mp->m_sb)) {
> +		xfs_warn(mp, "Super block does not support "
> +				 "project and group quota together");
> +		return XFS_ERROR(EINVAL);
> +	}

Why move this check? just leave it where it is and add the extra
check to it...

> @@ -157,7 +157,8 @@ xfs_trans_mod_dquot_byino(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) ||
>  	    !XFS_IS_QUOTA_ON(mp) ||
>  	    ip->i_ino == mp->m_sb.sb_uquotino ||
> -	    ip->i_ino == mp->m_sb.sb_gquotino)
> +	    ip->i_ino == mp->m_sb.sb_gquotino ||
> +	    ip->i_ino == mp->m_sb.sb_pquotino)
>  		return;

I see a helper....

>  	if (tp->t_dqinfo == NULL)
> @@ -825,6 +826,7 @@ xfs_trans_reserve_quota_nblks(
>  
>  	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
>  	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
> +	ASSERT(ip->i_ino != mp->m_sb.sb_pquotino);

And that becomes ASSERT(!xfs_is_quota_inode(mp, ip->i_ino))....

> diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
> index 8655280..f17e3bb 100644
> --- a/include/uapi/linux/dqblk_xfs.h
> +++ b/include/uapi/linux/dqblk_xfs.h
> @@ -155,6 +155,7 @@ typedef struct fs_quota_stat {
>  	__s8		qs_pad;		/* unused */
>  	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
>  	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> +#define qs_pquota	qs_gquota
>  	__u32		qs_incoredqs;	/* number of dquots incore */
>  	__s32		qs_btimelimit;  /* limit for blks timer */	
>  	__s32		qs_itimelimit;  /* limit for inodes timer */	

Ugly, but will do until the next patch ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
