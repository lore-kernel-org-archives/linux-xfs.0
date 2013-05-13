Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D84767F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 23:24:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BB0FA8F8037
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 21:24:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id icfMENi9VqW7nJYF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 21:24:42 -0700 (PDT)
Message-ID: <51906AFF.2000306@oracle.com>
Date: Mon, 13 May 2013 12:24:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v8 3/5] xfs: Start using pquotaino from the superblock
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-4-git-send-email-sekharan@us.ibm.com>
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

On 05/11/2013 05:21 AM, Chandra Seetharaman wrote:
> Define a macro to check if the superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> ---
>  fs/xfs/xfs_itable.c            |    3 +-
>  fs/xfs/xfs_mount.c             |  117 ++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_qm.c                |   29 +++++-----
>  fs/xfs/xfs_qm_syscalls.c       |   32 +++++++++---
>  fs/xfs/xfs_quota.h             |    8 ---
>  fs/xfs/xfs_sb.h                |    5 ++
>  fs/xfs/xfs_super.c             |   14 +++--
>  fs/xfs/xfs_trans_dquot.c       |    4 +-
>  include/uapi/linux/dqblk_xfs.h |    1 +
>  9 files changed, 148 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 2ea7d40..d80d58c 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -43,7 +43,8 @@ xfs_internal_inum(
>  {
>  	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
>  		(xfs_sb_version_hasquota(&mp->m_sb) &&
> -		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
> +		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
> +		  ino == mp->m_sb.sb_pquotino)));
>  }
>  
>  /*
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
> +
> +	} else {
> +		/* If any quota inodes are written, write all quota inodes */
> +		if (fields & (XFS_SB_UQUOTINO | XFS_SB_GQUOTINO
> +							| XFS_SB_PQUOTINO))
> +			fields |= (XFS_SB_UQUOTINO | XFS_SB_GQUOTINO
> +							| XFS_SB_PQUOTINO);
>  	}
>  
>  	while (fields) {
> @@ -691,6 +738,8 @@ xfs_sb_to_disk(
>  			memcpy(to_ptr + first, from_ptr + first, size);
>  		} else if (f == XFS_SBS_QFLAGS) {
>  			*(__be16 *)(to_ptr + first) = cpu_to_be16(qflags);
> +		} else if (f == XFS_SBS_GQUOTINO) {
> +			*(__be64 *)(to_ptr + first) = cpu_to_be64(gquotino);
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
> +
>  	/*
>  	 * We must be able to do sector-sized and sector-aligned IO.
>  	 */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 97912cb..41ccc3c 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -516,7 +516,8 @@ xfs_qm_need_dqattach(
>  	if (!XFS_NOT_DQATTACHED(mp, ip))
>  		return false;
>  	if (ip->i_ino == mp->m_sb.sb_uquotino ||
> -	    ip->i_ino == mp->m_sb.sb_gquotino)
> +	    ip->i_ino == mp->m_sb.sb_gquotino ||
> +	    ip->i_ino == mp->m_sb.sb_pquotino)
>  		return false;
>  	return true;
>  }
> @@ -651,6 +652,7 @@ xfs_qm_dqdetach(
>  
>  	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_uquotino);
>  	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_gquotino);
> +	ASSERT(ip->i_ino != ip->i_mount->m_sb.sb_pquotino);
>  	if (ip->i_udquot) {
>  		xfs_qm_dqrele(ip->i_udquot);
>  		ip->i_udquot = NULL;
> @@ -858,22 +860,21 @@ xfs_qm_qino_alloc(
>  	spin_lock(&mp->m_sb_lock);
>  	if (flags & XFS_QMOPT_SBVERSION) {
>  		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
> -		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> -		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
>  
>  		xfs_sb_version_addquota(&mp->m_sb);
>  		mp->m_sb.sb_uquotino = NULLFSINO;
>  		mp->m_sb.sb_gquotino = NULLFSINO;
> +		mp->m_sb.sb_pquotino = NULLFSINO;
>  
>  		/* qflags will get updated _after_ quotacheck */
>  		mp->m_sb.sb_qflags = 0;
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
> @@ -1185,7 +1186,9 @@ xfs_qm_dqusage_adjust(
>  	 * rootino must have its resources accounted for, not so with the quota
>  	 * inodes.
>  	 */
> -	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
> +	if (ino == mp->m_sb.sb_uquotino ||
> +	    ino == mp->m_sb.sb_gquotino ||
> +	    ino == mp->m_sb.sb_pquotino) {
>  		*res = BULKSTAT_RV_NOTHING;
>  		return XFS_ERROR(EINVAL);
>  	}
> @@ -1466,19 +1469,17 @@ xfs_qm_init_quotainos(
>  			if (error)
>  				goto error_rele;
>  		}
> -		/* Use sb_gquotino for now */
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
>  		}
>  	} else {
>  		flags |= XFS_QMOPT_SBVERSION;
> -		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
> +		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_QFLAGS);
>  	}
>  
>  	/*
> @@ -1505,7 +1506,7 @@ xfs_qm_init_quotainos(
>  	}
>  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &pip,
> -					     sbflags | XFS_SB_GQUOTINO,
> +					     sbflags | XFS_SB_PQUOTINO,
>  					     flags | XFS_QMOPT_PQUOTA);
>  		if (error)
>  			goto error_rele;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 9bec772..65c0a7d 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -201,8 +201,7 @@ xfs_qm_scall_quotaoff(
>  	/*
>  	 * If quotas is completely disabled, close shop.
>  	 */
> -	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
> -	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
> +	if ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_ALL) {
>  		mutex_unlock(&q->qi_quotaofflock);
>  		xfs_qm_destroy_quotainfo(mp);
>  		return (0);
> @@ -297,8 +296,10 @@ xfs_qm_scall_trunc_qfiles(
>  
>  	if (flags & XFS_DQ_USER)
>  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
> -	if (flags & (XFS_DQ_GROUP|XFS_DQ_PROJ))
> +	if (flags & XFS_DQ_GROUP)
>  		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
> +	if (flags & XFS_DQ_PROJ)
> +		error2 = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
If remove the space used by both group and project quota all failed, the first
error will be hidden.
Actually, I'm confused to compare the code logical between the kernel and the
user space even without this feature. i.e.  xfsprogs/quota/state.c->remove_extents():

        if (type & XFS_USER_QUOTA) {
                if (remove_qtype_extents(dir, XFS_USER_QUOTA) < 0)
                        return;
		       ^^^^^^^^ <-- So we will return and won't continue to deal with
	other quota types.  However, in kernel part, we deal with those types all at once.
        }
        if (type & XFS_GROUP_QUOTA) {
                if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
                        return;
        } else if (type & XFS_PROJ_QUOTA) {
                if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
                        return;
        }


>  
>  	return error ? error : error2;
>  }
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
>  
> -	uip = gip = NULL;
> -	tempuqip = tempgqip = false;
>  	memset(out, 0, sizeof(fs_quota_stat_t));
>  
>  	out->qs_version = FS_QSTAT_VERSION;
>  	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
>  		out->qs_uquota.qfs_ino = NULLFSINO;
>  		out->qs_gquota.qfs_ino = NULLFSINO;
> +		out->qs_pquota.qfs_ino = NULLFSINO;
>  		return (0);
>  	}
>  	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
> @@ -431,10 +435,13 @@ xfs_qm_scall_getqstat(
>  	out->qs_pad = 0;
>  	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
>  	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
> +	if (&out->qs_gquota != &out->qs_pquota)
> +		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
>  
>  	if (q) {
>  		uip = q->qi_uquotaip;
>  		gip = q->qi_gquotaip;
> +		pip = q->qi_pquotaip;
>  	}
>  	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
>  		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
> @@ -446,6 +453,11 @@ xfs_qm_scall_getqstat(
>  					0, 0, &gip) == 0)
>  			tempgqip = true;
>  	}
> +	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
> +		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> +					0, 0, &pip) == 0)
> +			temppqip = true;
> +	}
>  	if (uip) {
>  		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
>  		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
> @@ -458,6 +470,12 @@ xfs_qm_scall_getqstat(
>  		if (tempgqip)
>  			IRELE(gip);
>  	}
> +	if (pip) {
> +		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> +		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> +		if (temppqip)
> +			IRELE(pip);
> +	}
>  	if (q) {
>  		out->qs_incoredqs = q->qi_dquots;
>  		out->qs_btimelimit = q->qi_btimelimit;
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index fe46c0c..be51581 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -285,14 +285,6 @@ typedef struct xfs_qoff_logformat {
>  	 (XFS_IS_PQUOTA_ON(mp) && \
>  		(mp->m_sb.sb_qflags & XFS_PQUOTA_CHKD) == 0))
>  
> -#define XFS_MOUNT_QUOTA_SET1	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
> -				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
> -				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD)
> -
> -#define XFS_MOUNT_QUOTA_SET2	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
> -				 XFS_UQUOTA_CHKD|XFS_GQUOTA_ACCT|\
> -				 XFS_GQUOTA_ENFD|XFS_GQUOTA_CHKD)
> -
>  #define XFS_MOUNT_QUOTA_ALL	(XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD|\
>  				 XFS_UQUOTA_CHKD|XFS_PQUOTA_ACCT|\
>  				 XFS_PQUOTA_ENFD|XFS_PQUOTA_CHKD|\
> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index 2de58a8..3745b73 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -618,6 +618,11 @@ xfs_sb_has_incompat_log_feature(
>  	return (sbp->sb_features_log_incompat & feature) != 0;
>  }
>  
> +static inline int xfs_sb_version_has_pquota(xfs_sb_t *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5feac04..01019d9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
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
I have been teached by Dave Chinner in another patch recently that it's better
to adjust the warning message to one line if possible.
> +		return XFS_ERROR(EINVAL);
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 2bbad13..fee905b 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -157,7 +157,8 @@ xfs_trans_mod_dquot_byino(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) ||
>  	    !XFS_IS_QUOTA_ON(mp) ||
>  	    ip->i_ino == mp->m_sb.sb_uquotino ||
> -	    ip->i_ino == mp->m_sb.sb_gquotino)
> +	    ip->i_ino == mp->m_sb.sb_gquotino ||
> +	    ip->i_ino == mp->m_sb.sb_pquotino)
>  		return;
>  
>  	if (tp->t_dqinfo == NULL)
> @@ -825,6 +826,7 @@ xfs_trans_reserve_quota_nblks(
>  
>  	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
>  	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
> +	ASSERT(ip->i_ino != mp->m_sb.sb_pquotino);
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
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
> 
Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
