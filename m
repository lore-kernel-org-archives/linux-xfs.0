Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A0A07F95
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:05:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3952E304089
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 01:05:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UBW0GKSVly05ML1M for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 01:05:39 -0700 (PDT)
Date: Thu, 11 Jul 2013 18:05:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v11 3/4] xfs: Add proper versioning support to
	fs_quota_stat
Message-ID: <20130711080537.GC3438@dastard>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-4-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373518843-1492-4-git-send-email-sekharan@us.ibm.com>
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
Cc: jack@suse.cz, swhiteho@redhat.com, xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 12:00:42AM -0500, Chandra Seetharaman wrote:
> Added appropriate pads and code for backward compatibility.
> 
> Copied over the old version as it is different from the newer padded
> version.
> 
> New callers of the system call have to set the version of the data
> structure being passed, and kernel will fill as much data as requested.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/gfs2/quota.c                |    3 --
>  fs/quota/quota.c               |   67 +++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_qm_syscalls.c       |    4 --
>  include/uapi/linux/dqblk_xfs.h |   60 +++++++++++++++++++++++++++++++----
>  4 files changed, 116 insertions(+), 18 deletions(-)
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
> index c7314f1..ac5dd3a 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -204,15 +204,72 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
>  	return sb->s_qcop->set_xstate(sb, flags, cmd);
>  }
>  
> -static int quota_getxstate(struct super_block *sb, void __user *addr)
> +static int quota_getxstate(struct super_block *sb, void __user *addr,
> +			   bool older_version)

I'd suggest that the two API calls should be handled by separate
functions so there are no overlapping, dependent branches in the
code.

>  {
>  	struct fs_quota_stat fqs;
> -	int ret;
> +	struct fs_quota_stat_v1 fqs_v1;
> +	int ret, size;
> +	void *fqsp;
>  
>  	if (!sb->s_qcop->get_xstate)
>  		return -ENOSYS;

I'd also suggest that a sb->s_qcop->get_xstatev vector is added
so that filesystems keep the separate as well.

And that means we don't need to play the fs_quota_stat and
conversion-to-fs_quota_stat_v1 games. i.e. the existing
quota_getxstate() remains and uses the existing struct
fs_quota_stat, and the new Q_XGETQSTATV calls quota_getxstatev() and
uses the newly defined struct fs_quota_statv and ->get_xstatev()
call....

> @@ -137,31 +139,75 @@ typedef struct fs_disk_quota {
>   * Provides a centralized way to get meta information about the quota subsystem.
>   * eg. space taken up for user and group quotas, number of dquots currently
>   * incore.
> + * With version FS_QSTAT_VERSION, user space can send in an uninitialized
> + * buffer and data will be filled by the kernel.
> + * Starting FS_QSTAT_VERSION_2, to be used with Q_XGETQSTATV, user space
> + * caller should set qs_version to the appropriate version of the
> + * fs_quota_stat data structure they are providing. On return, user
> + * space should check qs_version and use appropriate fields supported by
> + * that version.
>   */
>  #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
> +#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota; realignment */

As per above, this reasoning and logic is all invalid now because we
aren't trying to maintain compatibility between users of the same
quotactl.

We are using a new quotactl, so we do not need to overload the
existing structure or versions.

> +/*
> + * Some basic information about 'quota files'. Version 2.
> + */
> +struct fs_qfilestat {
> +	__u64		qfs_ino;	/* inode number */
> +	__u64		qfs_nblks;	/* number of BBs 512-byte-blks */
> +	__u32		qfs_nextents;	/* number of extents */
> +	__u32		qfs_pad;	/* pad for 8-byte alignment */
> +};
> +
> +struct fs_quota_stat {
> +	__s8			qs_version;	/* version for future changes */
> +	__u8			qs_pad1;	/* pad for 16bit alignment */
> +	__u16			qs_flags;	/* FS_QUOTA_.* flags */
> +	__u32			qs_incoredqs;	/* number of dquots incore */
> +	struct fs_qfilestat	qs_uquota;	/* user quota information */
> +	struct fs_qfilestat	qs_gquota;	/* group quota information */
> +	struct fs_qfilestat	qs_pquota;	/* project quota information */
> +	__s32			qs_btimelimit;  /* limit for blks timer */
> +	__s32			qs_itimelimit;  /* limit for inodes timer */
> +	__s32			qs_rtbtimelimit;/* limit for rt blks timer */
> +	__u16			qs_bwarnlimit;	/* limit for num warnings */
> +	__u16			qs_iwarnlimit;	/* limit for num warnings */
> +	__u64			qs_pad2[8];	/* for future proofing */
> +};

these are what become fs_quota_statv and fs_qfilestatv structures
for the new quotactl.

> +/*
> + * Since Version 1 did not have padding at appropriate places,
> + * a new data structure has been defined for the older version to
> + * provide backward compatibility.
> + * Future extentions of this data structure won't require new
> + * data structure definitions as the current one can be extended
> + * with the logic and padding in place now.
> + */
> +#define FS_QSTAT_V1_SIZE	(sizeof(struct fs_quota_stat_v1))
> +#define FS_QSTAT_V2_SIZE	(sizeof(struct fs_quota_stat))

And these can go away completely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
