Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3C5D7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 16:16:14 -0500 (CDT)
Date: Thu, 11 Jul 2013 16:16:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v11 2/4] xfs: Start using pquotaino from the superblock.
Message-ID: <20130711211610.GC20932@sgi.com>
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

Hey Chandra,

On Thu, Jul 11, 2013 at 12:00:41AM -0500, Chandra Seetharaman wrote:
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Here are a few notes from my review.

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

xfs_sb_version_has_pquotino might be a better name for this.

> +		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> +			xfs_notice(mp,
> +			   "Version 5 of Super block has XFS_OQUOTA bits.\n");
> +			return XFS_ERROR(EFSCORRUPTED);
> +		}

If I'm reading that right... Now if you had a v5 super block with oquota
bits it will become unmountable.  Could that happen if you were using
crcs and quotas with a 3.10 kernel and then upgrade?

> +	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> +			xfs_notice(mp,
> +"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.\n");
> +			return XFS_ERROR(EFSCORRUPTED);
>  	}
>  
>  	/*
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
	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think you already checked for that up above.

> +		/*
> +		 * On disk superblock only has sb_gquotino, and incore
> +		 * superblock has both sb_gquotino and sb_pquotino.
> +		 * But, only one them is supported at any point of time.
			only one of them 

> +		 * So, if PQUOTA is set in disk superblock, copy over
> +		 * sb_gquotino to sb_pquotino.
> +		 */
> +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +		mp->m_sb.sb_gquotino = NULLFSINO;
> +	}
>  }
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
>  }
>  
>  /*
> @@ -885,7 +931,7 @@ reread:
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
>  
> -	xfs_sb_quota_from_disk(&mp->m_sb);
> +	xfs_sb_quota_from_disk(mp);
>  	/*
>  	 * We must be able to do sector-sized and sector-aligned IO.
>  	 */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d320794..ba12dc4 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -860,21 +860,24 @@ xfs_qm_qino_alloc(
>  	if (flags & XFS_QMOPT_SBVERSION) {
>  		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
>  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> -		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
> +				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> +                        XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));
	^^^^^^^^^^^^^^^^
Looks like some unwanted spaces in there.

>  		xfs_sb_version_addquota(&mp->m_sb);
>  		mp->m_sb.sb_uquotino = NULLFSINO;
>  		mp->m_sb.sb_gquotino = NULLFSINO;
> +		mp->m_sb.sb_pquotino = NULLFSINO;
>  
> -		/* qflags will get updated _after_ quotacheck */
> -		mp->m_sb.sb_qflags = 0;
> +		/* qflags will get updated fully _after_ quotacheck */
> +		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;

I didn't quite catch why you changed from 0 to ALL_QUOTA_ACCT here, will
take another look.

>  	}
>  	if (flags & XFS_QMOPT_UQUOTA)
>  		mp->m_sb.sb_uquotino = (*ip)->i_ino;
> -	else
> +	else if (flags & XFS_QMOPT_GQUOTA)
>  		mp->m_sb.sb_gquotino = (*ip)->i_ino;
> +	else
> +		mp->m_sb.sb_pquotino = (*ip)->i_ino;
>  	spin_unlock(&mp->m_sb_lock);
>  	xfs_mod_sb(tp, sbfields);
>  
> @@ -1484,11 +1487,10 @@ xfs_qm_init_quotainos(
>  			if (error)
>  				goto error_rele;
>  		}
> -		/* XXX: Use gquotino for now */
>  		if (XFS_IS_PQUOTA_ON(mp) &&
> -		    mp->m_sb.sb_gquotino != NULLFSINO) {
> -			ASSERT(mp->m_sb.sb_gquotino > 0);
> -			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> +		    mp->m_sb.sb_pquotino != NULLFSINO) {
> +			ASSERT(mp->m_sb.sb_pquotino > 0);
> +			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
>  					     0, 0, &pip);
>  			if (error)
>  				goto error_rele;
> @@ -1496,7 +1498,8 @@ xfs_qm_init_quotainos(
>  	} else {
>  		flags |= XFS_QMOPT_SBVERSION;
>  		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
> +			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> +			    XFS_SB_QFLAGS);
>  	}
>  
>  	/*
> @@ -1524,9 +1527,8 @@ xfs_qm_init_quotainos(
>  		flags &= ~XFS_QMOPT_SBVERSION;
>  	}
>  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> -		/* XXX: Use XFS_SB_GQUOTINO for now */
>  		error = xfs_qm_qino_alloc(mp, &pip,
> -					  sbflags | XFS_SB_GQUOTINO,
> +					  sbflags | XFS_SB_PQUOTINO,
>  					  flags | XFS_QMOPT_PQUOTA);
>  		if (error)
>  			goto error_rele;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e4f8b2d..132e811 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -296,8 +296,10 @@ xfs_qm_scall_trunc_qfiles(
>  
>  	if (flags & XFS_DQ_USER)
>  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
> -	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
> +	if (flags & XFS_DQ_GROUP)
>  		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
> +	if (flags & XFS_DQ_PROJ)
> +		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
>  
>  	return error ? error : error2;
>  }
> @@ -413,8 +415,10 @@ xfs_qm_scall_getqstat(

As we discussed on the call:  Now that you've decided to write a new
interface for this, you can be really light touch here in
xfs_qm_scall_getqstat().  The new macro in dqblk_xfs.h can also go away.

Looking good.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
