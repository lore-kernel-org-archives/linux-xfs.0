Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 78F5E7F4E
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 14:35:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1B0D5304051
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:35:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BSHEnMJuhiM6CDOZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Jan 2015 12:35:08 -0800 (PST)
Date: Fri, 9 Jan 2015 15:35:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: remove bitfield based superblock updates
Message-ID: <20150109203501.GA2233@laptop.bfoster>
References: <1420667465-7453-1-git-send-email-david@fromorbit.com>
	<1420667465-7453-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420667465-7453-2-git-send-email-david@fromorbit.com>
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

On Thu, Jan 08, 2015 at 08:51:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we log changes to the superblock, we first have to write them
> to the on-disk buffer, and then log that. Right now we have a
> complex bitfield based arrangement to only write the modified field
> to the buffer before we log it.
> 
> This used to be necessary as a performance optimisation because we
> logged the superblock buffer in every extent or inode allocation or
> freeing, and so performance was extremely important. We haven't done
> this for years, however, ever since the lazy superblock counters
> pulled the superblock logging out of the transaction commit
> fast path.
> 
> Hence we have a bunch of complexity that is not necessary that makes
> writing the in-core superblock to disk much more complex than it
> needs to be. We only need to log the superblock now during
> management operations (e.g. during mount, unmount or quota control
> operations) so it is not a performance critical path anymore.
> 
> As such, remove the complex field based logging mechanism and
> replace it with a simple conversion function similar to what we use
> for all other on-disk structures.
> 
> This means we always log the entirity of the superblock, but again
> because we rarely modify the superblock this is not an issue for log
> bandwidth or CPU time. Indeed, if we do log the superblock
> frequently, delayed logging will minimise the impact of this
> overhead.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   2 +-
>  fs/xfs/libxfs/xfs_bmap.c      |  14 +-
>  fs/xfs/libxfs/xfs_sb.c        | 290 ++++++++++++++----------------------------
>  fs/xfs/libxfs/xfs_sb.h        |  10 +-
>  fs/xfs/xfs_fsops.c            |   6 +-
>  fs/xfs/xfs_mount.c            |  21 ++-
>  fs/xfs/xfs_mount.h            |   2 +-
>  fs/xfs/xfs_qm.c               |  26 +---
>  fs/xfs/xfs_qm.h               |   2 +-
>  fs/xfs/xfs_qm_syscalls.c      |  13 +-
>  fs/xfs/xfs_super.c            |   2 +-
>  11 files changed, 132 insertions(+), 256 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 5d38e8b..c914422 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -403,7 +403,7 @@ xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
>  		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
>  			xfs_sb_version_addattr2(&mp->m_sb);
>  			spin_unlock(&mp->m_sb_lock);
> -			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
> +			xfs_mod_sb(tp);
>  		} else
>  			spin_unlock(&mp->m_sb_lock);
>  	}
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b5eb474..8c39cc8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1221,22 +1221,20 @@ xfs_bmap_add_attrfork(
>  		goto bmap_cancel;
>  	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
>  	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
> -		__int64_t sbfields = 0;
> +		bool mod_sb = false;
>  
>  		spin_lock(&mp->m_sb_lock);
>  		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
>  			xfs_sb_version_addattr(&mp->m_sb);
> -			sbfields |= XFS_SB_VERSIONNUM;
> +			mod_sb = true;
>  		}
>  		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
>  			xfs_sb_version_addattr2(&mp->m_sb);
> -			sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
> +			mod_sb = true;
>  		}
> -		if (sbfields) {
> -			spin_unlock(&mp->m_sb_lock);
> -			xfs_mod_sb(tp, sbfields);
> -		} else
> -			spin_unlock(&mp->m_sb_lock);
> +		spin_unlock(&mp->m_sb_lock);
> +		if (mod_sb)
> +			xfs_mod_sb(tp);
>  	}
>  
>  	error = xfs_bmap_finish(&tp, &flist, &committed);
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 752915f..4afbbce 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -40,69 +40,6 @@
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
>   */
>  
> -static const struct {
> -	short offset;
> -	short type;	/* 0 = integer
> -			 * 1 = binary / string (no translation)
> -			 */
> -} xfs_sb_info[] = {
> -	{ offsetof(xfs_sb_t, sb_magicnum),	0 },
> -	{ offsetof(xfs_sb_t, sb_blocksize),	0 },
> -	{ offsetof(xfs_sb_t, sb_dblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_rblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_rextents),	0 },
> -	{ offsetof(xfs_sb_t, sb_uuid),		1 },
> -	{ offsetof(xfs_sb_t, sb_logstart),	0 },
> -	{ offsetof(xfs_sb_t, sb_rootino),	0 },
> -	{ offsetof(xfs_sb_t, sb_rbmino),	0 },
> -	{ offsetof(xfs_sb_t, sb_rsumino),	0 },
> -	{ offsetof(xfs_sb_t, sb_rextsize),	0 },
> -	{ offsetof(xfs_sb_t, sb_agblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_agcount),	0 },
> -	{ offsetof(xfs_sb_t, sb_rbmblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_logblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_versionnum),	0 },
> -	{ offsetof(xfs_sb_t, sb_sectsize),	0 },
> -	{ offsetof(xfs_sb_t, sb_inodesize),	0 },
> -	{ offsetof(xfs_sb_t, sb_inopblock),	0 },
> -	{ offsetof(xfs_sb_t, sb_fname[0]),	1 },
> -	{ offsetof(xfs_sb_t, sb_blocklog),	0 },
> -	{ offsetof(xfs_sb_t, sb_sectlog),	0 },
> -	{ offsetof(xfs_sb_t, sb_inodelog),	0 },
> -	{ offsetof(xfs_sb_t, sb_inopblog),	0 },
> -	{ offsetof(xfs_sb_t, sb_agblklog),	0 },
> -	{ offsetof(xfs_sb_t, sb_rextslog),	0 },
> -	{ offsetof(xfs_sb_t, sb_inprogress),	0 },
> -	{ offsetof(xfs_sb_t, sb_imax_pct),	0 },
> -	{ offsetof(xfs_sb_t, sb_icount),	0 },
> -	{ offsetof(xfs_sb_t, sb_ifree),		0 },
> -	{ offsetof(xfs_sb_t, sb_fdblocks),	0 },
> -	{ offsetof(xfs_sb_t, sb_frextents),	0 },
> -	{ offsetof(xfs_sb_t, sb_uquotino),	0 },
> -	{ offsetof(xfs_sb_t, sb_gquotino),	0 },
> -	{ offsetof(xfs_sb_t, sb_qflags),	0 },
> -	{ offsetof(xfs_sb_t, sb_flags),		0 },
> -	{ offsetof(xfs_sb_t, sb_shared_vn),	0 },
> -	{ offsetof(xfs_sb_t, sb_inoalignmt),	0 },
> -	{ offsetof(xfs_sb_t, sb_unit),		0 },
> -	{ offsetof(xfs_sb_t, sb_width),		0 },
> -	{ offsetof(xfs_sb_t, sb_dirblklog),	0 },
> -	{ offsetof(xfs_sb_t, sb_logsectlog),	0 },
> -	{ offsetof(xfs_sb_t, sb_logsectsize),	0 },
> -	{ offsetof(xfs_sb_t, sb_logsunit),	0 },
> -	{ offsetof(xfs_sb_t, sb_features2),	0 },
> -	{ offsetof(xfs_sb_t, sb_bad_features2),	0 },
> -	{ offsetof(xfs_sb_t, sb_features_compat),	0 },
> -	{ offsetof(xfs_sb_t, sb_features_ro_compat),	0 },
> -	{ offsetof(xfs_sb_t, sb_features_incompat),	0 },
> -	{ offsetof(xfs_sb_t, sb_features_log_incompat),	0 },
> -	{ offsetof(xfs_sb_t, sb_crc),		0 },
> -	{ offsetof(xfs_sb_t, sb_pad),		0 },
> -	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
> -	{ offsetof(xfs_sb_t, sb_lsn),		0 },
> -	{ sizeof(xfs_sb_t),			0 }
> -};
> -
>  /*
>   * Reference counting access wrappers to the perag structures.
>   * Because we never free per-ag structures, the only thing we
> @@ -461,128 +398,119 @@ xfs_sb_from_disk(
>  	__xfs_sb_from_disk(to, from, true);
>  }
>  
> -static inline void
> +static void
>  xfs_sb_quota_to_disk(
> -	xfs_dsb_t	*to,
> -	xfs_sb_t	*from,
> -	__int64_t	*fields)
> +	struct xfs_dsb	*to,
> +	struct xfs_sb	*from)
>  {
>  	__uint16_t	qflags = from->sb_qflags;
>  
> +	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
> +	if (xfs_sb_version_has_pquotino(from)) {
> +		to->sb_qflags = cpu_to_be16(from->sb_qflags);
> +		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> +		to->sb_pquotino = cpu_to_be64(from->sb_pquotino);
> +		return;
> +	}
> +
>  	/*
> -	 * We need to do these manipilations only if we are working
> -	 * with an older version of on-disk superblock.
> +	 * The in-core version of sb_qflags do not have XFS_OQUOTA_*
> +	 * flags, whereas the on-disk version does.  So, convert incore
> +	 * XFS_{PG}QUOTA_* flags to on-disk XFS_OQUOTA_* flags.
>  	 */
> -	if (xfs_sb_version_has_pquotino(from))
> -		return;
> +	qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +			XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
>  
> -	if (*fields & XFS_SB_QFLAGS) {
> -		/*
> -		 * The in-core version of sb_qflags do not have
> -		 * XFS_OQUOTA_* flags, whereas the on-disk version
> -		 * does.  So, convert incore XFS_{PG}QUOTA_* flags
> -		 * to on-disk XFS_OQUOTA_* flags.
> -		 */
> -		qflags &= ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> -				XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> -
> -		if (from->sb_qflags &
> -				(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> -			qflags |= XFS_OQUOTA_ENFD;
> -		if (from->sb_qflags &
> -				(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> -			qflags |= XFS_OQUOTA_CHKD;
> -		to->sb_qflags = cpu_to_be16(qflags);
> -		*fields &= ~XFS_SB_QFLAGS;
> -	}
> +	if (from->sb_qflags &
> +			(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +		qflags |= XFS_OQUOTA_ENFD;
> +	if (from->sb_qflags &
> +			(XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +		qflags |= XFS_OQUOTA_CHKD;
> +	to->sb_qflags = cpu_to_be16(qflags);
>  
>  	/*
> -	 * GQUOTINO and PQUOTINO cannot be used together in versions of
> -	 * superblock that do not have pquotino. from->sb_flags tells us which
> -	 * quota is active and should be copied to disk. If neither are active,
> -	 * make sure we write NULLFSINO to the sb_gquotino field as a quota
> -	 * inode value of "0" is invalid when the XFS_SB_VERSION_QUOTA feature
> -	 * bit is set.
> +	 * GQUOTINO and PQUOTINO cannot be used together in versions
> +	 * of superblock that do not have pquotino. from->sb_flags
> +	 * tells us which quota is active and should be copied to
> +	 * disk. If neither are active, we should NULL the inode.
>  	 *
> -	 * Note that we don't need to handle the sb_uquotino or sb_pquotino here
> -	 * as they do not require any translation. Hence the main sb field loop
> -	 * will write them appropriately from the in-core superblock.
> +	 * In all cases, the separate pquotino must remain 0 because it
> +	 * it beyond the "end" of the valid non-pquotino superblock.
>  	 */
> -	if ((*fields & XFS_SB_GQUOTINO) &&
> -				(from->sb_qflags & XFS_GQUOTA_ACCT))
> +	if (from->sb_qflags & XFS_GQUOTA_ACCT)
>  		to->sb_gquotino = cpu_to_be64(from->sb_gquotino);
> -	else if ((*fields & XFS_SB_PQUOTINO) &&
> -				(from->sb_qflags & XFS_PQUOTA_ACCT))
> +	else if (from->sb_qflags & XFS_PQUOTA_ACCT)
>  		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> -	else {
> -		/*
> -		 * We can't rely on just the fields being logged to tell us
> -		 * that it is safe to write NULLFSINO - we should only do that
> -		 * if quotas are not actually enabled. Hence only write
> -		 * NULLFSINO if both in-core quota inodes are NULL.
> -		 */
> -		if (from->sb_gquotino == NULLFSINO &&
> -		    from->sb_pquotino == NULLFSINO)
> -			to->sb_gquotino = cpu_to_be64(NULLFSINO);
> -	}
> +	else
> +		to->sb_gquotino = cpu_to_be64(NULLFSINO);

FYI... it looks like the above hunk causes a regression due to resetting
sb_gquotaino when one of the in-core inodes is set. I'm seeing
disconnected quota inode messages on some xfstests (e.g., xfs/108) on v4
filesystems. I'm about to put a patch on the list to go back to the
original logic...

Brian

>  
> -	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
> +	to->sb_pquotino = 0;
>  }
>  
> -/*
> - * Copy in core superblock to ondisk one.
> - *
> - * The fields argument is mask of superblock fields to copy.
> - */
>  void
>  xfs_sb_to_disk(
> -	xfs_dsb_t	*to,
> -	xfs_sb_t	*from,
> -	__int64_t	fields)
> +	struct xfs_dsb	*to,
> +	struct xfs_sb	*from)
>  {
> -	xfs_caddr_t	to_ptr = (xfs_caddr_t)to;
> -	xfs_caddr_t	from_ptr = (xfs_caddr_t)from;
> -	xfs_sb_field_t	f;
> -	int		first;
> -	int		size;
> -
> -	ASSERT(fields);
> -	if (!fields)
> -		return;
> +	xfs_sb_quota_to_disk(to, from);
>  
> -	/* We should never write the crc here, it's updated in the IO path */
> -	fields &= ~XFS_SB_CRC;
> -
> -	xfs_sb_quota_to_disk(to, from, &fields);
> -	while (fields) {
> -		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> -		first = xfs_sb_info[f].offset;
> -		size = xfs_sb_info[f + 1].offset - first;
> -
> -		ASSERT(xfs_sb_info[f].type == 0 || xfs_sb_info[f].type == 1);
> -
> -		if (size == 1 || xfs_sb_info[f].type == 1) {
> -			memcpy(to_ptr + first, from_ptr + first, size);
> -		} else {
> -			switch (size) {
> -			case 2:
> -				*(__be16 *)(to_ptr + first) =
> -				      cpu_to_be16(*(__u16 *)(from_ptr + first));
> -				break;
> -			case 4:
> -				*(__be32 *)(to_ptr + first) =
> -				      cpu_to_be32(*(__u32 *)(from_ptr + first));
> -				break;
> -			case 8:
> -				*(__be64 *)(to_ptr + first) =
> -				      cpu_to_be64(*(__u64 *)(from_ptr + first));
> -				break;
> -			default:
> -				ASSERT(0);
> -			}
> -		}
> +	to->sb_magicnum = cpu_to_be32(from->sb_magicnum);
> +	to->sb_blocksize = cpu_to_be32(from->sb_blocksize);
> +	to->sb_dblocks = cpu_to_be64(from->sb_dblocks);
> +	to->sb_rblocks = cpu_to_be64(from->sb_rblocks);
> +	to->sb_rextents = cpu_to_be64(from->sb_rextents);
> +	memcpy(&to->sb_uuid, &from->sb_uuid, sizeof(to->sb_uuid));
> +	to->sb_logstart = cpu_to_be64(from->sb_logstart);
> +	to->sb_rootino = cpu_to_be64(from->sb_rootino);
> +	to->sb_rbmino = cpu_to_be64(from->sb_rbmino);
> +	to->sb_rsumino = cpu_to_be64(from->sb_rsumino);
> +	to->sb_rextsize = cpu_to_be32(from->sb_rextsize);
> +	to->sb_agblocks = cpu_to_be32(from->sb_agblocks);
> +	to->sb_agcount = cpu_to_be32(from->sb_agcount);
> +	to->sb_rbmblocks = cpu_to_be32(from->sb_rbmblocks);
> +	to->sb_logblocks = cpu_to_be32(from->sb_logblocks);
> +	to->sb_versionnum = cpu_to_be16(from->sb_versionnum);
> +	to->sb_sectsize = cpu_to_be16(from->sb_sectsize);
> +	to->sb_inodesize = cpu_to_be16(from->sb_inodesize);
> +	to->sb_inopblock = cpu_to_be16(from->sb_inopblock);
> +	memcpy(&to->sb_fname, &from->sb_fname, sizeof(to->sb_fname));
> +	to->sb_blocklog = from->sb_blocklog;
> +	to->sb_sectlog = from->sb_sectlog;
> +	to->sb_inodelog = from->sb_inodelog;
> +	to->sb_inopblog = from->sb_inopblog;
> +	to->sb_agblklog = from->sb_agblklog;
> +	to->sb_rextslog = from->sb_rextslog;
> +	to->sb_inprogress = from->sb_inprogress;
> +	to->sb_imax_pct = from->sb_imax_pct;
> +	to->sb_icount = cpu_to_be64(from->sb_icount);
> +	to->sb_ifree = cpu_to_be64(from->sb_ifree);
> +	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
> +	to->sb_frextents = cpu_to_be64(from->sb_frextents);
>  
> -		fields &= ~(1LL << f);
> +
> +	to->sb_flags = from->sb_flags;
> +	to->sb_shared_vn = from->sb_shared_vn;
> +	to->sb_inoalignmt = cpu_to_be32(from->sb_inoalignmt);
> +	to->sb_unit = cpu_to_be32(from->sb_unit);
> +	to->sb_width = cpu_to_be32(from->sb_width);
> +	to->sb_dirblklog = from->sb_dirblklog;
> +	to->sb_logsectlog = from->sb_logsectlog;
> +	to->sb_logsectsize = cpu_to_be16(from->sb_logsectsize);
> +	to->sb_logsunit = cpu_to_be32(from->sb_logsunit);
> +	to->sb_features2 = cpu_to_be32(from->sb_features2);
> +	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
> +
> +	if (xfs_sb_version_hascrc(from)) {
> +		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
> +		to->sb_features_ro_compat =
> +				cpu_to_be32(from->sb_features_ro_compat);
> +		to->sb_features_incompat =
> +				cpu_to_be32(from->sb_features_incompat);
> +		to->sb_features_log_incompat =
> +				cpu_to_be32(from->sb_features_log_incompat);
> +		to->sb_pad = 0;
> +		to->sb_lsn = cpu_to_be64(from->sb_lsn);
>  	}
>  }
>  
> @@ -823,35 +751,13 @@ xfs_initialize_perag_data(
>   * access.
>   */
>  void
> -xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
> +xfs_mod_sb(
> +	struct xfs_trans	*tp)
>  {
> -	xfs_buf_t	*bp;
> -	int		first;
> -	int		last;
> -	xfs_mount_t	*mp;
> -	xfs_sb_field_t	f;
> -
> -	ASSERT(fields);
> -	if (!fields)
> -		return;
> -	mp = tp->t_mountp;
> -	bp = xfs_trans_getsb(tp, mp, 0);
> -	first = sizeof(xfs_sb_t);
> -	last = 0;
> -
> -	/* translate/copy */
> -
> -	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, fields);
> -
> -	/* find modified range */
> -	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
> -	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
> -	last = xfs_sb_info[f + 1].offset - 1;
> -
> -	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> -	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
> -	first = xfs_sb_info[f].offset;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
>  
> +	xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> -	xfs_trans_log_buf(tp, bp, first, last);
> +	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb));
>  }
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 8eb1c54..e193caa 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -27,11 +27,11 @@ extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
>  extern void	xfs_perag_put(struct xfs_perag *pag);
>  extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
>  
> -extern void	xfs_sb_calc_crc(struct xfs_buf	*);
> -extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
> -extern void	xfs_sb_mount_common(struct xfs_mount *, struct xfs_sb *);
> -extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
> -extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
> +extern void	xfs_sb_calc_crc(struct xfs_buf *bp);
> +extern void	xfs_mod_sb(struct xfs_trans *tp);
> +extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
> +extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
> +extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
>  
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index fdc6422..82af857 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -541,7 +541,7 @@ xfs_growfs_data_private(
>  			saved_error = error;
>  			continue;
>  		}
> -		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb, XFS_SB_ALL_BITS);
> +		xfs_sb_to_disk(XFS_BUF_TO_SBP(bp), &mp->m_sb);
>  
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
> @@ -780,9 +780,7 @@ xfs_fs_log_dummy(
>  		xfs_trans_cancel(tp, 0);
>  		return error;
>  	}
> -
> -	/* log the UUID because it is an unchanging field */
> -	xfs_mod_sb(tp, XFS_SB_UUID);
> +	xfs_mod_sb(tp);
>  	xfs_trans_set_sync(tp);
>  	return xfs_trans_commit(tp, 0);
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 71d2c97..defcf69 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -613,7 +613,7 @@ xfs_mount_reset_sbqflags(
>  		return error;
>  	}
>  
> -	xfs_mod_sb(tp, XFS_SB_QFLAGS);
> +	xfs_mod_sb(tp);
>  	return xfs_trans_commit(tp, 0);
>  }
>  
> @@ -896,7 +896,7 @@ xfs_mountfs(
>  	 * perform the update e.g. for the root filesystem.
>  	 */
>  	if (mp->m_update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> -		error = xfs_mount_log_sb(mp, mp->m_update_flags);
> +		error = xfs_mount_log_sb(mp);
>  		if (error) {
>  			xfs_warn(mp, "failed to write sb changes");
>  			goto out_rtunmount;
> @@ -1126,7 +1126,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
>  		return error;
>  	}
>  
> -	xfs_mod_sb(tp, XFS_SB_IFREE | XFS_SB_ICOUNT | XFS_SB_FDBLOCKS);
> +	xfs_mod_sb(tp);
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp, 0);
>  	return error;
> @@ -1429,14 +1429,10 @@ xfs_freesb(
>   */
>  int
>  xfs_mount_log_sb(
> -	xfs_mount_t	*mp,
> -	__int64_t	fields)
> +	struct xfs_mount	*mp)
>  {
> -	xfs_trans_t	*tp;
> -	int		error;
> -
> -	ASSERT(fields & (XFS_SB_UNIT | XFS_SB_WIDTH | XFS_SB_UUID |
> -			 XFS_SB_FEATURES2 | XFS_SB_VERSIONNUM));
> +	struct xfs_trans	*tp;
> +	int			error;
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SB_UNIT);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
> @@ -1444,9 +1440,8 @@ xfs_mount_log_sb(
>  		xfs_trans_cancel(tp, 0);
>  		return error;
>  	}
> -	xfs_mod_sb(tp, fields);
> -	error = xfs_trans_commit(tp, 0);
> -	return error;
> +	xfs_mod_sb(tp);
> +	return xfs_trans_commit(tp, 0);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 22ccf69..28b341b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -378,7 +378,7 @@ extern void	xfs_unmountfs(xfs_mount_t *);
>  extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
>  extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
>  			uint, int);
> -extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
> +extern int	xfs_mount_log_sb(xfs_mount_t *);
>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>  extern int	xfs_readsb(xfs_mount_t *, int);
>  extern void	xfs_freesb(xfs_mount_t *);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 79fb19d..c815a80 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -714,7 +714,6 @@ STATIC int
>  xfs_qm_qino_alloc(
>  	xfs_mount_t	*mp,
>  	xfs_inode_t	**ip,
> -	__int64_t	sbfields,
>  	uint		flags)
>  {
>  	xfs_trans_t	*tp;
> @@ -777,11 +776,6 @@ xfs_qm_qino_alloc(
>  	spin_lock(&mp->m_sb_lock);
>  	if (flags & XFS_QMOPT_SBVERSION) {
>  		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
> -		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS)) ==
> -				(XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -				 XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> -				 XFS_SB_QFLAGS));
>  
>  		xfs_sb_version_addquota(&mp->m_sb);
>  		mp->m_sb.sb_uquotino = NULLFSINO;
> @@ -798,7 +792,7 @@ xfs_qm_qino_alloc(
>  	else
>  		mp->m_sb.sb_pquotino = (*ip)->i_ino;
>  	spin_unlock(&mp->m_sb_lock);
> -	xfs_mod_sb(tp, sbfields);
> +	xfs_mod_sb(tp);
>  
>  	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
>  		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
> @@ -1451,7 +1445,7 @@ xfs_qm_mount_quotas(
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
> -		if (xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)) {
> +		if (xfs_qm_write_sb_changes(mp)) {
>  			/*
>  			 * We could only have been turning quotas off.
>  			 * We aren't in very good shape actually because
> @@ -1482,7 +1476,6 @@ xfs_qm_init_quotainos(
>  	struct xfs_inode	*gip = NULL;
>  	struct xfs_inode	*pip = NULL;
>  	int			error;
> -	__int64_t		sbflags = 0;
>  	uint			flags = 0;
>  
>  	ASSERT(mp->m_quotainfo);
> @@ -1517,9 +1510,6 @@ xfs_qm_init_quotainos(
>  		}
>  	} else {
>  		flags |= XFS_QMOPT_SBVERSION;
> -		sbflags |= (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			    XFS_SB_GQUOTINO | XFS_SB_PQUOTINO |
> -			    XFS_SB_QFLAGS);
>  	}
>  
>  	/*
> @@ -1530,7 +1520,6 @@ xfs_qm_init_quotainos(
>  	 */
>  	if (XFS_IS_UQUOTA_ON(mp) && uip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &uip,
> -					      sbflags | XFS_SB_UQUOTINO,
>  					      flags | XFS_QMOPT_UQUOTA);
>  		if (error)
>  			goto error_rele;
> @@ -1539,7 +1528,6 @@ xfs_qm_init_quotainos(
>  	}
>  	if (XFS_IS_GQUOTA_ON(mp) && gip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &gip,
> -					  sbflags | XFS_SB_GQUOTINO,
>  					  flags | XFS_QMOPT_GQUOTA);
>  		if (error)
>  			goto error_rele;
> @@ -1548,7 +1536,6 @@ xfs_qm_init_quotainos(
>  	}
>  	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
>  		error = xfs_qm_qino_alloc(mp, &pip,
> -					  sbflags | XFS_SB_PQUOTINO,
>  					  flags | XFS_QMOPT_PQUOTA);
>  		if (error)
>  			goto error_rele;
> @@ -1593,8 +1580,7 @@ xfs_qm_dqfree_one(
>   */
>  int
>  xfs_qm_write_sb_changes(
> -	xfs_mount_t	*mp,
> -	__int64_t	flags)
> +	struct xfs_mount *mp)
>  {
>  	xfs_trans_t	*tp;
>  	int		error;
> @@ -1606,10 +1592,8 @@ xfs_qm_write_sb_changes(
>  		return error;
>  	}
>  
> -	xfs_mod_sb(tp, flags);
> -	error = xfs_trans_commit(tp, 0);
> -
> -	return error;
> +	xfs_mod_sb(tp);
> +	return xfs_trans_commit(tp, 0);
>  }
>  
>  
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 3a07a93..bddd23f 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -157,7 +157,7 @@ struct xfs_dquot_acct {
>  #define XFS_QM_RTBWARNLIMIT	5
>  
>  extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
> -extern int		xfs_qm_write_sb_changes(struct xfs_mount *, __int64_t);
> +extern int		xfs_qm_write_sb_changes(struct xfs_mount *);
>  
>  /* dquot stuff */
>  extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 74fca68..8d7e5f0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -92,8 +92,7 @@ xfs_qm_scall_quotaoff(
>  		mutex_unlock(&q->qi_quotaofflock);
>  
>  		/* XXX what to do if error ? Revert back to old vals incore ? */
> -		error = xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS);
> -		return error;
> +		return xfs_qm_write_sb_changes(mp);
>  	}
>  
>  	dqtype = 0;
> @@ -314,7 +313,6 @@ xfs_qm_scall_quotaon(
>  {
>  	int		error;
>  	uint		qf;
> -	__int64_t	sbflags;
>  
>  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>  	/*
> @@ -322,8 +320,6 @@ xfs_qm_scall_quotaon(
>  	 */
>  	flags &= ~(XFS_ALL_QUOTA_ACCT);
>  
> -	sbflags = 0;
> -
>  	if (flags == 0) {
>  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
>  			__func__, mp->m_qflags);
> @@ -370,11 +366,10 @@ xfs_qm_scall_quotaon(
>  	/*
>  	 * There's nothing to change if it's the same.
>  	 */
> -	if ((qf & flags) == flags && sbflags == 0)
> +	if ((qf & flags) == flags)
>  		return -EEXIST;
> -	sbflags |= XFS_SB_QFLAGS;
>  
> -	if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
> +	if ((error = xfs_qm_write_sb_changes(mp)))
>  		return error;
>  	/*
>  	 * If we aren't trying to switch on quota enforcement, we are done.
> @@ -801,7 +796,7 @@ xfs_qm_log_quotaoff(
>  	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
>  	spin_unlock(&mp->m_sb_lock);
>  
> -	xfs_mod_sb(tp, XFS_SB_QFLAGS);
> +	xfs_mod_sb(tp);
>  
>  	/*
>  	 * We have to make sure that the transaction is secure on disk before we
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 40bad75..3797a03 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1258,7 +1258,7 @@ xfs_fs_remount(
>  		 * might have some superblock changes to update.
>  		 */
>  		if (mp->m_update_flags) {
> -			error = xfs_mount_log_sb(mp, mp->m_update_flags);
> +			error = xfs_mount_log_sb(mp);
>  			if (error) {
>  				xfs_warn(mp, "failed to write sb changes");
>  				return error;
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
