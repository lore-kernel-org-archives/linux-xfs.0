Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8D5A7F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 13:30:34 -0500 (CDT)
Date: Fri, 12 Jul 2013 13:30:30 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Start using pquotaino from the superblock.
Message-ID: <20130712183030.GE20932@sgi.com>
References: <1373593707.20769.11.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373593707.20769.11.camel@chandra-dt.ibm.com>
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
Cc: Jan Kara <jack@suse.cz>, adas@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, XFS mailing list <xfs@oss.sgi.com>

Hey Chandra,

On Thu, Jul 11, 2013 at 08:48:27PM -0500, Chandra Seetharaman wrote:
> Changes from version v11:
>  - Moved code as suggested by Dave
>  - Replaced the parameter to xfs_sb_quota_from_disk from
>    xfs_mount to xfs_sb as suggester by Dave.
>    This lead to additional changes to xfs_qm_qino_alloc() to
>    handle the reuse of pquotino/gquotino if it was switched by
>    user between mounts.
>  - Addressed all of Ben's concerns
>  - removed the changes need for fs_quota_stat changes as that 
>    change is being delayed.
> ----------------------
> 
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
>

Cc: Jan Kara <jack@suse.cz>

> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Comments below.

> ---
>  fs/xfs/xfs_mount.c       |   59 ++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_qm.c          |   72 ++++++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_qm_syscalls.c |   30 ++++++++++++++++++-
>  fs/xfs/xfs_sb.h          |   13 ++++++--
>  fs/xfs/xfs_super.c       |   19 ++++++------
>  5 files changed, 154 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 8b95933..e177511 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -336,14 +336,6 @@ xfs_mount_validate_sb(
>  		return XFS_ERROR(EWRONGFS);
>  	}
>  
> -	if ((sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) &&
> -			(sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> -				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))) {
> -		xfs_notice(mp,
> -"Super block has XFS_OQUOTA bits along with XFS_PQUOTA and/or XFS_GQUOTA bits.\n");
> -		return XFS_ERROR(EFSCORRUPTED);
> -	}
> -
>  	/*
>  	 * Version 5 superblock feature mask validation. Reject combinations the
>  	 * kernel cannot support up front before checking anything else. For
> @@ -387,6 +379,19 @@ xfs_mount_validate_sb(
>  		}
>  	}
>  
> +	if (xfs_sb_version_has_pquotino(sbp)) {
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
> +	}
> +
>  	if (unlikely(
>  	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
>  		xfs_warn(mp,
> @@ -584,6 +589,9 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  	if (sbp->sb_pquotino == 0)
>  		sbp->sb_pquotino = NULLFSINO;
>  
> +	if (xfs_sb_version_has_pquotino(sbp))
> +		return;
> +
>  	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
>  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
>  					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> @@ -591,6 +599,19 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
>  					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
>  	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +
> +	if ((sbp->sb_qflags & XFS_PQUOTA_ACCT) &&
> +			(sbp->sb_gquotino != NULLFSINO)) {

If project quota accounting bit is set in the super block 
and 
the group quot ino is not nullfsino..

That's weird.  I would have expected to be able to assume that sb_gquotino is
not NULLFSINO if project quota accounting is on.  Why was the check necessary?

> +		/*
> +		 * On disk superblock only has sb_gquotino, and incore
> +		 * superblock has both sb_gquotino and sb_pquotino.
> +		 * But, only one of them is supported at any point of time.
> +		 * So, if PQUOTA is set in disk superblock, copy over
> +		 * sb_gquotino to sb_pquotino.
> +		 */
> +		sbp->sb_pquotino = sbp->sb_gquotino;
> +		sbp->sb_gquotino = NULLFSINO;
> +	}
>  }
>  
>  void
> @@ -662,6 +683,13 @@ xfs_sb_quota_to_disk(
>  {
>  	__uint16_t	qflags = from->sb_qflags;
>  
> +	/*
> +	 * We need to do these manipilations only if we are working
> +	 * with an older version of on-disk superblock.
> +	 */
> +	if (xfs_sb_version_has_pquotino(from))
> +		return;
> +
>  	if (*fields & XFS_SB_QFLAGS) {
>  		/*
>  		 * The in-core version of sb_qflags do not have
> @@ -681,6 +709,21 @@ xfs_sb_quota_to_disk(
>  		to->sb_qflags = cpu_to_be16(qflags);
>  		*fields &= ~XFS_SB_QFLAGS;
>  	}
> +
> +	/*
> +	 * GQUOTINO and PQUOTINO cannot be used together in versions
> +	 * of superblock that do not have pquotino. from->sb_flags
> +	 * tells us which quota is active and should be copied to
> +	 * disk.
> +	 */
> +	if ((*fields & XFS_SB_GQUOTINO) &&
> +				(from->sb_qflags & XFS_GQUOTA_ACCT))
> +		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> +	else if ((*fields & XFS_SB_PQUOTINO) &&
> +				(from->sb_qflags & XFS_PQUOTA_ACCT))
> +		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> +
> +	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d320794..1e2361d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -834,6 +834,36 @@ xfs_qm_qino_alloc(
>  	int		error;
>  	int		committed;
>  
> +	*ip = NULL;
> +	/*
> +	 * With superblock that doesn't have separate pquotino, we
> +	 * share an inode between gquota and pquota. If the on-disk
> +	 * superblock has GQUOTA and the filesystem is now mounted
> +	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
> +	 * vice-versa.
> +	 */
> +	if (!xfs_sb_version_has_pquotino(&mp->m_sb) &&
> +			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
> +		xfs_ino_t ino = NULLFSINO;
> +
> +		if ((flags & XFS_QMOPT_PQUOTA) &&
> +			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
> +			ino = mp->m_sb.sb_gquotino;
> +			ASSERT(mp->m_sb.sb_pquotino == NULLFSINO);
> +		} else if ((flags & XFS_QMOPT_GQUOTA) &&
> +			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
> +			ino = mp->m_sb.sb_pquotino;
> +			ASSERT(mp->m_sb.sb_gquotino == NULLFSINO);
> +		}
> +		if (ino != NULLFSINO) {
> +			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
> +			if (error)
> +				return error;
> +			mp->m_sb.sb_gquotino = NULLFSINO;
> +			mp->m_sb.sb_pquotino = NULLFSINO;
> +		}
> +	}

Looks like this is a new addition.  I'm not completely clear on why you
needed to add it.  Maybe if the user had switched from using project
quotas to group quotas there would be an old inode left out there from
the project quotas?  Is that why you added this?  If so, wouldn't you
want to truncate the old contents away before using it?

> +
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
>  	if ((error = xfs_trans_reserve(tp,
>  				      XFS_QM_QINOCREATE_SPACE_RES(mp),
> @@ -844,11 +874,14 @@ xfs_qm_qino_alloc(
>  		return error;
>  	}
>  
> -	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
> -	if (error) {
> -		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
> -				 XFS_TRANS_ABORT);
> -		return error;
> +	if (!*ip) {
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
> +								&committed);
> +		if (error) {
> +			xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
> +					 XFS_TRANS_ABORT);
> +			return error;
> +		}
>  	}
>  
>  	/*
> @@ -860,21 +893,25 @@ xfs_qm_qino_alloc(
>  	if (flags & XFS_QMOPT_SBVERSION) {
>  		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
>  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
> -		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
> +				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> +				 XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> +				 XFS_SB_QFLAGS));
>  
>  		xfs_sb_version_addquota(&mp->m_sb);
>  		mp->m_sb.sb_uquotino = NULLFSINO;
>  		mp->m_sb.sb_gquotino = NULLFSINO;
> +		mp->m_sb.sb_pquotino = NULLFSINO;
>  
> -		/* qflags will get updated _after_ quotacheck */
> -		mp->m_sb.sb_qflags = 0;
> +		/* qflags will get updated fully _after_ quotacheck */
> +		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
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
> @@ -1484,11 +1521,10 @@ xfs_qm_init_quotainos(
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
> @@ -1496,7 +1532,8 @@ xfs_qm_init_quotainos(
>  	} else {
>  		flags |= XFS_QMOPT_SBVERSION;
>  		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			    XFS_SB_GQUOTINO | XFS_SB_QFLAGS);
> +			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> +			    XFS_SB_QFLAGS);
>  	}
>  
>  	/*
> @@ -1524,9 +1561,8 @@ xfs_qm_init_quotainos(
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
> index e4f8b2d..8f4b8bc 100644
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
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_inode	*uip = NULL;
>  	struct xfs_inode	*gip = NULL;
> +	struct xfs_inode	*pip = NULL;
>  	bool                    tempuqip = false;
>  	bool                    tempgqip = false;
> +	bool                    temppqip = false;
>  
>  	memset(out, 0, sizeof(fs_quota_stat_t));
>  
> @@ -424,6 +428,12 @@ xfs_qm_scall_getqstat(
>  		out->qs_gquota.qfs_ino = NULLFSINO;
>  		return (0);
>  	}
> +
> +	/* Q_XGETQSTAT doesn't have room for both group and project quotas */
> +	if ((mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_GQUOTA_ACCT)) ==
> +					(XFS_PQUOTA_ACCT | XFS_GQUOTA_ACCT))
> +		return -EINVAL;
> +

Lets keep the rest of the crew in the loop with what we do on the
quotactls.

On our call, I found myself in agreement that the idea of returning
-EINVAL in the old interface when user, group, and project quotas are
turned on simultaneously would be ok.  But today I'm not so sure.
Classic bpm waffling...  ;)

The quota rpm is separate from xfsprogs and could be much older; I think
that there are those who will consider returning EINVAL here to be an
API breakage.

Maybe there are other options?
- A sysctl to control which quota you get through the old group
interface, when all three are turned on.
- Only report user and qroup quotas through the old interface, even when
all three are turned on. 

Probably the old interface should still work in some fashion with a
newer filesystem, but there don't seem to be many wonderful solutions.

Anyway, I'd like to have Dave's reviewed-by and Jan's ack at a minimum
before pulling in these -EINVAL bits.  If this really is ok, lets have
everybodys sig to make it official.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
