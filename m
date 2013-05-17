Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 168067F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:10:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE53B8F80C4
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:10:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PVH6FIJHD5c4QhGq for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:10:03 -0700 (PDT)
Date: Fri, 17 May 2013 15:10:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 4/5] xfs: Add proper versioning support to fs_quota_stat
Message-ID: <20130517051001.GP24635@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-5-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1368220889-25188-5-git-send-email-sekharan@us.ibm.com>
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

On Fri, May 10, 2013 at 04:21:28PM -0500, Chandra Seetharaman wrote:
> Added appropriate pads and code for backward compatibility.
> 
> Copied over the old version as it is different from the newer padded
> version.
> 
> New callers of the system call have to just set the version of the data
> structure being passed, and kernel will fill as much data as requested.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

This needs to be cc'd to Steve Whitehouse so he's aware that we are
changing the quota interface...

> ---
>  fs/gfs2/quota.c                |    3 ---
>  fs/quota/quota.c               |   40 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_qm_syscalls.c       |    4 ----
>  include/uapi/linux/dqblk_xfs.h |   38 ++++++++++++++++++++++++++++++++++++--
>  4 files changed, 74 insertions(+), 11 deletions(-)
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
> index c7314f1..510464e 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -207,12 +207,48 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
>  static int quota_getxstate(struct super_block *sb, void __user *addr)
>  {
>  	struct fs_quota_stat fqs;
> -	int ret;
> +	struct fs_quota_stat_v1 fqs_v1;
> +	int ret, size;
> +	void *cp = &fqs;

What's "cp" mean? Wouldn't fqsp be a better name? And initialise it
just before it gets used makes more sense, too.

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
> +		cp = &fqs_v1;
> +	}

Missing a break on the last case there.

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
> +		fqs_v1.qs_uquota = fqs.qs_uquota;
> +		fqs_v1.qs_gquota = fqs.qs_gquota;
> +		fqs_v1.qs_incoredqs = fqs.qs_incoredqs;
> +		fqs_v1.qs_btimelimit = fqs.qs_btimelimit;
> +		fqs_v1.qs_itimelimit = fqs.qs_itimelimit;
> +		fqs_v1.qs_rtbtimelimit = fqs.qs_rtbtimelimit;
> +		fqs_v1.qs_bwarnlimit = fqs.qs_bwarnlimit;
> +		fqs_v1.qs_iwarnlimit = fqs.qs_iwarnlimit;

		fsqp = &fsq_v1;
	} else {
		fsqp = &fsq_v2;
	}

> +
> +	if (copy_to_user(addr, &cp, size))
>  		return -EFAULT;
>  	return ret;
>  }
> diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
> index f17e3bb..d9629c1 100644
> --- a/include/uapi/linux/dqblk_xfs.h
> +++ b/include/uapi/linux/dqblk_xfs.h
> @@ -18,6 +18,7 @@
>  #define _LINUX_DQBLK_XFS_H
>  
>  #include <linux/types.h>
> +#include <linux/stddef.h>

Really? What's new that requires this include?

>  
>  /*
>   * Disk quota - quotactl(2) commands for the XFS Quota Manager (XQM).
> @@ -137,8 +138,12 @@ typedef struct fs_disk_quota {
>   * Provides a centralized way to get meta information about the quota subsystem.
>   * eg. space taken up for user and group quotas, number of dquots currently
>   * incore.
> + * User space caller should set qs_version to the appropriate version
> + * of the fs_quota_stat data structure they are providing. Not providing
> + * a version will be treated as FS_QSTAT_VERSION.
>   */
>  #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
> +#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota */
>  
>  /*
>   * Some basic information about 'quota files'.
> @@ -149,19 +154,48 @@ typedef struct fs_qfilestat {
>  	__u32		qfs_nextents;	/* number of extents */
>  } fs_qfilestat_t;
>  
> +typedef struct fs_quota_stat_v1 {

Kill the typedef. Add a comment stating that this structure is
likely to have compatibility problems across architectures due to
implicit padding and offset alignment in the structure definition
and that the v2 structure should be used if these problems are being
seen.

> +	__s8		qs_version;	/* version number for future changes */
> +	__u16		qs_flags;	/* FS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
> +	__u8		qs_pad;		/* unused */
> +	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
> +	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> +	__u32		qs_incoredqs;	/* number of dquots incore */
> +	__s32		qs_btimelimit;  /* limit for blks timer */	
> +	__s32		qs_itimelimit;  /* limit for inodes timer */	
> +	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
> +	__u16		qs_bwarnlimit;	/* limit for num warnings */
> +	__u16		qs_iwarnlimit;	/* limit for num warnings */
> +} fs_quota_stat_v1_t;
> +
>  typedef struct fs_quota_stat {

Kill the typedef.

>  	__s8		qs_version;	/* version number for future changes */
> +	__u8		qs_pad1;	/* unused */
>  	__u16		qs_flags;	/* FS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
> -	__s8		qs_pad;		/* unused */
> +	__u8		qs_pad2[4];	/* unused */
>  	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
>  	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> -#define qs_pquota	qs_gquota
>  	__u32		qs_incoredqs;	/* number of dquots incore */
>  	__s32		qs_btimelimit;  /* limit for blks timer */	
>  	__s32		qs_itimelimit;  /* limit for inodes timer */	
>  	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
>  	__u16		qs_bwarnlimit;	/* limit for num warnings */
>  	__u16		qs_iwarnlimit;	/* limit for num warnings */
> +	__u8		qs_pad3[4];	/* unused */
> +	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
> +	/* End of Data structure for FS_QSTAT_VERSION_2 */

No need for that comment.

>  } fs_quota_stat_t;

Use pahole on the built object file to determine if the end ofthe
structure is 64 bit aligned. If it isn't, please pad it to 64 bit
alignment.

Um. fs_qfilestat_t is { u64, u64, u32 }, and so there's going to be
alignment problems with that. We need a fs_qfilestat_v1 definition
and add padding to fs_qfilestat_t so that it is 64 bit aligned.....


>  
> +/*
> + * Since Version 1 did not have padding at appropriate places,
> + * a new data structure has been defined for the older version to
> + * provide backward compatibility.
> + * Future extentions of this data structure won't require new
> + * data structure definitions as the current one can be extended
> + * with the logic and padding in place now.
> + */
> +#define FS_QSTAT_V1_SIZE	(sizeof(struct fs_quota_stat_v1))
> +#define FS_QSTAT_V2_SIZE	(offsetof(struct fs_quota_stat, qs_pquota) + \
> +					sizeof(fs_qfilestat_t))

Just use sizeof(struct fs_quota_stat) as the size. Indeed, for
future enhancements, maybe we should add 64 bytes of empty space at
the end of the structure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
