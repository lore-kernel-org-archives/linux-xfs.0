Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F2WAEj053546 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 21:32:11 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	s5Liwj0tCd26B4Jo for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 19:32:08 -0700 (PDT)
Date: Wed, 15 Aug 2012 12:32:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 4/5] xfs: Add proper versioning support to
	fs_quota_stat
Message-ID: <20120815023206.GT2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230247.20477.68011.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120720230247.20477.68011.sendpatchset@chandra-lucid.austin.ibm.com>
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

On Fri, Jul 20, 2012 at 06:02:47PM -0500, Chandra Seetharaman wrote:
> Add proper versioning support for fs_quota_stat.
> 
> Leave the earlier version as version 1 and add version 2 to add a new
> field "fs_qfilestat_t qs_pquota"
> 
> Callers of the system call have to just set the version of the data
> structure being passed, and kernel will fill as much data as possible.

Userspace Interface Traps for the Unwary 101, below.

>  /*
>   * Disk quota - quotactl(2) commands for the XFS Quota Manager (XQM).
> @@ -139,6 +140,7 @@ typedef struct fs_disk_quota {
>   * incore.
>   */
>  #define FS_QSTAT_VERSION	1	/* fs_quota_stat.qs_version */
> +#define FS_QSTAT_VERSION_2	2	/* new field qs_pquota */
>  
>  /*
>   * Some basic information about 'quota files'.
> @@ -155,13 +157,37 @@ typedef struct fs_quota_stat {
>  	__s8		qs_pad;		/* unused */
>  	fs_qfilestat_t	qs_uquota;	/* user quota storage information */
>  	fs_qfilestat_t	qs_gquota;	/* group quota storage information */
> -#define qs_pquota	qs_gquota
>  	__u32		qs_incoredqs;	/* number of dquots incore */
>  	__s32		qs_btimelimit;  /* limit for blks timer */	
>  	__s32		qs_itimelimit;  /* limit for inodes timer */	
>  	__s32		qs_rtbtimelimit;/* limit for rt blks timer */	
>  	__u16		qs_bwarnlimit;	/* limit for num warnings */
>  	__u16		qs_iwarnlimit;	/* limit for num warnings */
> +	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
>  } fs_quota_stat_t;
>  
> +#define FS_QSTAT_V1_SIZE	(offsetof(fs_quota_stat_t, qs_pquota))
> +#define FS_QSTAT_V2_SIZE	(FS_QSTAT_V1_SIZE + sizeof (fs_qfilestat_t))

I don't expect that will work on all arches. pahole (everyone needs
to know about pahole!) tells me the original structure on x86_64
looks like:

struct fs_quota_stat {
        __s8                       qs_version;           /*     0     1 */

        /* XXX 1 byte hole, try to pack */

        __u16                      qs_flags;             /*     2     2 */
        __s8                       qs_pad;               /*     4     1 */

        /* XXX 3 bytes hole, try to pack */

        fs_qfilestat_t             qs_uquota;            /*     8    24 */
        fs_qfilestat_t             qs_gquota;            /*    32    24 */
        __u32                      qs_incoredqs;         /*    56     4 */
        __s32                      qs_btimelimit;        /*    60     4 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        __s32                      qs_itimelimit;        /*    64     4 */
        __s32                      qs_rtbtimelimit;      /*    68     4 */
        __u16                      qs_bwarnlimit;        /*    72     2 */
        __u16                      qs_iwarnlimit;        /*    74     2 */

        /* size: 80, cachelines: 2, members: 11 */
        /* sum members: 72, holes: 2, sum holes: 4 */
        /* padding: 4 */
        /* last cacheline: 16 bytes */
}

and that qs_iwarnlimit does not end on a 8 byte boundary. If we then
look at fs_qfilestat:

typedef struct fs_qfilestat {
        __u64           qfs_ino;        /* inode number */
        __u64           qfs_nblks;      /* number of BBs 512-byte-blks */
        __u32           qfs_nextents;   /* number of extents */
} fs_qfilestat_t;

it has an 8 byte alignment, so the above FS_QSTAT_V2_SIZE
calculation is wrong because it doesn't take into account holes in
the structure and there is 4 bytes of hole between qs_iwarnlimit and
qs_pquota. It's entirely possible that this might require a compat
handler as some platforms might pack the structure differently in 32
vs 64 bit binaries..

IOWs, you ned to explicitly add padding to thie structure, like
someone tried to do in the past a screwed it up completely.
Basically, the structure needs to be padded like this:

typedef struct fs_quota_stat {
	__s8            qs_version;     /* version number for future changes */
	__u8		qs_pad1;	/* unused */
	__u16           qs_flags;       /* FS_QUOTA_{U,P,G}DQ_{ACCT,ENFD} */
	__u8            qs_pad2[3];     /* unused */
	fs_qfilestat_t  qs_uquota;      /* user quota storage information */
	fs_qfilestat_t  qs_gquota;      /* group quota storage information */
	__u32           qs_incoredqs;   /* number of dquots incore */
	__s32           qs_btimelimit;  /* limit for blks timer */
	__s32           qs_itimelimit;  /* limit for inodes timer */
	__s32           qs_rtbtimelimit;/* limit for rt blks timer */
	__u16           qs_bwarnlimit;  /* limit for num warnings */
	__u16           qs_iwarnlimit;  /* limit for num warnings */
	__u8		qs_pad3[4];	/* unused */
	fs_qfilestat_t	qs_pquota;	/* project quota storage information */
} fs_quota_stat_t;

> +
> +static inline int valid_qstat_version(int version)
> +{
> +	switch (version) {
> +	case FS_QSTAT_VERSION:
> +	case FS_QSTAT_VERSION_2:
> +		return 1;
> +	default:
> +		return 0;
> +	}
> +}
> +static inline int qstatsize(int version)
> +{
> +	switch (version) {
> +	case FS_QSTAT_VERSION_2:
> +		return FS_QSTAT_V2_SIZE;
> +	case FS_QSTAT_VERSION:
> +	default:
> +		return FS_QSTAT_V1_SIZE;
> +	}
> +}

I don't see much point in these helpers - just put them in line in
the quota_getxstate() code. i.e.

	switch (version) {
	case FS_QSTAT_VERSION_2:
		size = FS_QSTAT_V2_SIZE;
		break;
	default:
		version = FS_QSTAT_VERSION;
		/* fallthrough */
	case FS_QSTAT_VERSION:
		size = FS_QSTAT_V1_SIZE;
		break;
	}

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
