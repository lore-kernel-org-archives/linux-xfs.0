Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDAFE7F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 01:43:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BAD848F8037
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 23:43:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MndD03fKUWiGoEXB for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 23:43:15 -0700 (PDT)
Date: Tue, 25 Jun 2013 16:43:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 5/6] xfs: Add proper versioning support to fs_quota_stat
Message-ID: <20130625064312.GV29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-6-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372042107-27332-6-git-send-email-sekharan@us.ibm.com>
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

On Sun, Jun 23, 2013 at 09:48:26PM -0500, Chandra Seetharaman wrote:
> Added appropriate pads and code for backward compatibility.
> 
> Copied over the old version as it is different from the newer padded
> version.
> 
> New callers of the system call have to set the version of the data
> structure being passed, and kernel will fill as much data as requested.

Is there are test for this? i.e. that the different version
structures return the same information?

> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/gfs2/quota.c                |    3 --
>  fs/quota/quota.c               |   49 +++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_qm_syscalls.c       |    4 ---
>  fs/xfs/xfs_super.c             |    5 +--
>  include/uapi/linux/dqblk_xfs.h |   57 +++++++++++++++++++++++++++++++++++-----
>  5 files changed, 99 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index c7c840e..ca0dccd 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1443,9 +1443,6 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
>  {
>  	struct gfs2_sbd *sdp = sb->s_fs_info;
>  
> -	memset(fqs, 0, sizeof(struct fs_quota_stat));
> -	fqs->qs_version = FS_QSTAT_VERSION;
> -
>  	switch (sdp->sd_args.ar_quota) {
>  	case GFS2_QUOTA_ON:
>  		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index c7314f1..ae6526e 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
>  static int quota_getxstate(struct super_block *sb, void __user *addr)
>  {
>  	struct fs_quota_stat fqs;
> -	int ret;
> +	struct fs_quota_stat_v1 fqs_v1;
> +	int ret, size;
> +	void *fqsp;
>  
>  	if (!sb->s_qcop->get_xstate)
>  		return -ENOSYS;
> +
> +	memset(&fqs, 0, sizeof(struct fs_quota_stat));
> +	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
> +		return -EFAULT;
> +
> +	switch (fqs.qs_version) {
> +	case FS_QSTAT_VERSION_2:
> +		size = FS_QSTAT_V2_SIZE;
> +		break;
> +	default:
> +		fqs.qs_version = FS_QSTAT_VERSION;
> +		/* fallthrough */
> +	case FS_QSTAT_VERSION:
> +		size = FS_QSTAT_V1_SIZE;
> +		break;
> +	}
> +
>  	ret = sb->s_qcop->get_xstate(sb, &fqs);
> -	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
> +	if (ret)
> +		return ret;
> +
> +	if (fqs.qs_version == FS_QSTAT_VERSION) {
> +		fqs_v1.qs_version = fqs.qs_version;
> +		fqs_v1.qs_flags = fqs.qs_flags;
> +		fqs_v1.qs_pad = 0;
> +
> +		fqs_v1.qs_uquota.qfs_ino = fqs.qs_uquota.qfs_ino;
> +		fqs_v1.qs_uquota.qfs_nblks = fqs.qs_uquota.qfs_nblks;
> +		fqs_v1.qs_uquota.qfs_nextents = fqs.qs_uquota.qfs_nextents;
> +
> +		fqs_v1.qs_gquota.qfs_ino = fqs.qs_gquota.qfs_ino;
> +		fqs_v1.qs_gquota.qfs_nblks = fqs.qs_gquota.qfs_nblks;
> +		fqs_v1.qs_gquota.qfs_nextents = fqs.qs_gquota.qfs_nextents;
> +
> +		fqs_v1.qs_incoredqs = fqs.qs_incoredqs;
> +		fqs_v1.qs_btimelimit = fqs.qs_btimelimit;
> +		fqs_v1.qs_itimelimit = fqs.qs_itimelimit;
> +		fqs_v1.qs_rtbtimelimit = fqs.qs_rtbtimelimit;
> +		fqs_v1.qs_bwarnlimit = fqs.qs_bwarnlimit;
> +		fqs_v1.qs_iwarnlimit = fqs.qs_iwarnlimit;
> +		fqsp = &fqs_v1;
> +	} else
> +		fqsp = &fqs;
> +
> +	if (copy_to_user(addr, fqsp, size))
>  		return -EFAULT;
>  	return ret;
>  }
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index d664a2d..1918f48 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -420,9 +420,6 @@ xfs_qm_scall_getqstat(
>  	bool                    tempgqip = false;
>  	bool                    temppqip = false;
>  
> -	memset(out, 0, sizeof(fs_quota_stat_t));
> -
> -	out->qs_version = FS_QSTAT_VERSION;
>  	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
>  		out->qs_uquota.qfs_ino = NULLFSINO;
>  		out->qs_gquota.qfs_ino = NULLFSINO;
> @@ -432,7 +429,6 @@ xfs_qm_scall_getqstat(
>  	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
>  							(XFS_ALL_QUOTA_ACCT|
>  							 XFS_ALL_QUOTA_ENFD));
> -	out->qs_pad = 0;
>  	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
>  	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
>  	if (&out->qs_gquota != &out->qs_pquota)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1bcc017..ab90539 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -554,14 +554,13 @@ xfs_showargs(
>  	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
>  		seq_puts(m, "," MNTOPT_UQUOTANOENF);
>  
> -	/* Either project or group quotas can be active, not both */
> -
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_PRJQUOTA);
>  		else
>  			seq_puts(m, "," MNTOPT_PQUOTANOENF);
> -	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
> +	}
> +	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_GQUOTA_ENFD)
>  			seq_puts(m, "," MNTOPT_GRPQUOTA);
>  		else
> diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
> index f17e3bb..e8ca23b 100644
> --- a/include/uapi/linux/dqblk_xfs.h
> +++ b/include/uapi/linux/dqblk_xfs.h
> @@ -47,6 +47,7 @@
>   * 512 bytes.
>   */
>  #define FS_DQUOT_VERSION	1	/* fs_disk_quota.d_version */
> +
>  typedef struct fs_disk_quota {
>  	__s8		d_version;	/* version of this structure */
>  	__s8		d_flags;	/* FS_{USER,PROJ,GROUP}_QUOTA */
> @@ -137,31 +138,73 @@ typedef struct fs_disk_quota {
>   * Provides a centralized way to get meta information about the quota subsystem.
>   * eg. space taken up for user and group quotas, number of dquots currently
>   * incore.
> + * User space caller should set qs_version to the appropriate version
> + * of the fs_quota_stat data structure they are providing. Not providing
> + * a version will be treated as FS_QSTAT_VERSION.
>   */
>  #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
> +#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota; realignment */
>  
>  /*
>   * Some basic information about 'quota files'.
>   */
> -typedef struct fs_qfilestat {
> +struct fs_qfilestat_v1 {
>  	__u64		qfs_ino;	/* inode number */
>  	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
>  	__u32		qfs_nextents;	/* number of extents */
> -} fs_qfilestat_t;
> +};
>  
> -typedef struct fs_quota_stat {
> +struct fs_quota_stat_v1 {
>  	__s8		qs_version;	/* version number for future changes */
>  	__u16		qs_flags;	/* FS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
>  	__s8		qs_pad;		/* unused */
> -	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
> -	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> -#define qs_pquota	qs_gquota
> +	struct fs_qfilestat_v1	qs_uquota;	/* user quota information */
> +	struct fs_qfilestat_v1	qs_gquota;	/* group quota information */
>  	__u32		qs_incoredqs;	/* number of dquots incore */
>  	__s32		qs_btimelimit;  /* limit for blks timer */	
>  	__s32		qs_itimelimit;  /* limit for inodes timer */	
>  	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
>  	__u16		qs_bwarnlimit;	/* limit for num warnings */
>  	__u16		qs_iwarnlimit;	/* limit for num warnings */
> -} fs_quota_stat_t;
> +};
> +
> +/*
> + * Some basic information about 'quota files'. Version 2.
> + */
> +struct fs_qfilestat {
> +	__u64		qfs_ino;	/* inode number */
> +	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
> +	__u32		qfs_nextents;	/* number of extents */
> +	__u8		qfs_pad[4];	/* pad for 8-byte alignment */

Just pad it as:

	__u32		qfs_pad;

So the size of the hole being filled is obvious.

> +};
> +
> +struct fs_quota_stat {
> +	__s8			qs_version;	/* version for future changes */
> +	__u8			qs_pad1;	/* pad for 16bit alignment */
> +	__u16			qs_flags;	/* FS_QUOTA_.* flags */
> +	__u8			qs_pad2[4];	/* pad for 8-byte alignment */

Actually, we can reorder this structure so there aren't intermediate
holes like this. The only thing that matters is that the first byte
is the version number. So:

struct fs_quota_stat {
	__s8			qs_version;	/* version for future changes */
	__u8			qs_pad1;	/* pad for 16bit alignment */
	__u16			qs_flags;	/* FS_QUOTA_.* flags */
	__u32			qs_incoredqs;	/* number of dquots incore */
	struct fs_qfilestat	qs_uquota;	/* user quota information */
	struct fs_qfilestat	qs_gquota;	/* group quota information */
	struct fs_qfilestat	qs_pquota;	/* project quota information */
	__s32			qs_btimelimit;  /* limit for blks timer */
	__s32			qs_itimelimit;  /* limit for inodes timer */
	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
	__u16			qs_bwarnlimit;	/* limit for num warnings */
	__u16			qs_iwarnlimit;	/* limit for num warnings */
	__u32			qs_pad2;	/* pad for 8-byte alignment */
	__u64			qs_pad3[8];	/* for future proofing */
};

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
