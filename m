Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 22:17:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAG6Gnip016490
	for <xfs@oss.sgi.com>; Thu, 15 Nov 2007 22:16:54 -0800
Message-ID: <473D3577.5080409@sgi.com>
Date: Fri, 16 Nov 2007 17:15:19 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [xfs-masters] [PATCH] remove BPCSHIFT and NB?P? macros - was
 fs/xfs: remove duplicated defines
References: <473796EF.6050104@sandeen.net> <473799A9.9000200@sgi.com> <47379E42.2030006@sgi.com> <47379F5A.20107@sgi.com> <20071112020445.GY995458@sgi.com> <473937AC.2080901@sgi.com> <20071113213013.GZ995458@sgi.com> <473A619C.8040206@sgi.com> <20071114054100.GJ995458@sgi.com> <473B98AC.2000600@sgi.com> <20071115062728.GH66820511@sgi.com> <473D2BFB.6040702@sgi.com>
In-Reply-To: <473D2BFB.6040702@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, kernel-janitors@vger.kernel.org

Looks good Tim.  Nice work.

Timothy Shimmin wrote:
> David Chinner wrote:
>>> While here, looking at a few others...
>>> #define NBPP            PAGE_SIZE
>>> #define NDPP            (1 << (PAGE_SHIFT - 9)) <--- not used - another to nuke
>>> #define NBPC            PAGE_SIZE <----- used once
>>>
>>> grep -Ir 'NBPC' . | egrep -v 'tag|anot|diff'
>>> ./linux-2.6/xfs_linux.h:#define NBPC            PAGE_SIZE       /* Number of bytes per click */
>>> ./xfs_itable.c: irbuf = kmem_zalloc_greedy(&irbsize, NBPC, NBPC * 4,
>>>
>>>  > grep -Ir 'NBPP' . | egrep -v 'tag|anot|diff|NBPPR'
>>> ./linux-2.6/xfs_linux.h:#define NBPP            PAGE_SIZE
>>> ./quota/xfs_qm.h:#define XFS_QM_HASHSIZE_LOW            (NBPP / sizeof(xfs_dqhash_t))
>>> ./quota/xfs_qm.h:#define XFS_QM_HASHSIZE_HIGH           ((NBPP * 4) / sizeof(xfs_dqhash_t))
>> PAGE_SIZE
>>
>>> ./xfs_bmap.c:   } else if (mp->m_sb.sb_blocksize >= NBPP) {
>>> ./xfs_bmap.c:           args.prod = NBPP >> mp->m_sb.sb_blocklog;
>> PAGE_CACHE_SIZE
>>
>>> ./xfs_itable.c: bcount = MIN(left, (int)(NBPP / sizeof(*buffer)));
>> PAGE_SIZE
>>
>>> ./xfs_log.c:                    kmem_free(tic, NBPP);
>>> ./xfs_log.c:    uint            i = (NBPP / sizeof(xlog_ticket_t)) - 2;
>>> ./xfs_log.c:    buf = (xfs_caddr_t) kmem_zalloc(NBPP, KM_SLEEP);
>> We should replace that hand rolled ticket allocator with a slab cache.
>>
> In another patch though.
> 
>>> ./xfs_vnodeops.c:       rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, NBPP);
>> PAGE_CACHE_SIZE. (as suggested ;)
>>
>>> Might as well get rid of NBPC and replace by NBPP.
>>>
>>> Is it just worth s/NBPC/PAGE_SIZE/g ?
>> yup.
>>
> Thanks.
> 
> Patch:
> -------------
> 
> Remove the BPCSHIFT and NB* based macros from XFS.
> 
> The BPCSHIFT based macros, btoc*, ctob*, offtoc* and ctooff
> are either not used or don't need to be used.
> The NDPP, NDPP, NBBY macros don't need to be used but instead
> are replaced directly by PAGE_SIZE and PAGE_CACHE_SIZE
> where appropriate.
> Initial patch and motivation from Nicolas Kaiser.
> 
> Signed-Off-By: Tim Shimmin <tes@sgi.com>
> ---
>   b/fs/xfs/linux-2.6/xfs_linux.h |   28 +---------------------------
>   b/fs/xfs/linux-2.6/xfs_lrw.c   |    9 ++++-----
>   b/fs/xfs/quota/xfs_qm.h        |    4 ++--
>   b/fs/xfs/xfs_bmap.c            |    4 ++--
>   b/fs/xfs/xfs_itable.c          |    4 ++--
>   b/fs/xfs/xfs_log.c             |    6 +++---
>   b/fs/xfs/xfs_vnodeops.c        |    9 +++------
>   7 files changed, 17 insertions(+), 47 deletions(-)
> 
> ===========================================================================
> Index: fs/xfs/linux-2.6/xfs_linux.h
> ===========================================================================
> 
> --- a/fs/xfs/linux-2.6/xfs_linux.h	2007-11-16 16:22:40.000000000 +1100
> +++ b/fs/xfs/linux-2.6/xfs_linux.h	2007-11-16 15:59:22.299466117 +1100
> @@ -143,43 +143,17 @@
> 
>   #define spinlock_destroy(lock)
> 
> -#define NBPP		PAGE_SIZE
> -#define NDPP		(1 << (PAGE_SHIFT - 9))
> -
>   #define NBBY		8		/* number of bits per byte */
> -#define	NBPC		PAGE_SIZE	/* Number of bytes per click */
> -#define	BPCSHIFT	PAGE_SHIFT	/* LOG2(NBPC) if exact */
> 
>   /*
>    * Size of block device i/o is parameterized here.
>    * Currently the system supports page-sized i/o.
>    */
> -#define	BLKDEV_IOSHIFT		BPCSHIFT
> +#define	BLKDEV_IOSHIFT		PAGE_CACHE_SHIFT
>   #define	BLKDEV_IOSIZE		(1<<BLKDEV_IOSHIFT)
>   /* number of BB's per block device block */
>   #define	BLKDEV_BB		BTOBB(BLKDEV_IOSIZE)
> 
> -/* bytes to clicks */
> -#define	btoc(x)		(((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
> -#define	btoct(x)	((__psunsigned_t)(x)>>BPCSHIFT)
> -#define	btoc64(x)	(((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
> -#define	btoct64(x)	((__uint64_t)(x)>>BPCSHIFT)
> -
> -/* off_t bytes to clicks */
> -#define offtoc(x)       (((__uint64_t)(x)+(NBPC-1))>>BPCSHIFT)
> -#define offtoct(x)      ((xfs_off_t)(x)>>BPCSHIFT)
> -
> -/* clicks to off_t bytes */
> -#define	ctooff(x)	((xfs_off_t)(x)<<BPCSHIFT)
> -
> -/* clicks to bytes */
> -#define	ctob(x)		((__psunsigned_t)(x)<<BPCSHIFT)
> -#define btoct(x)        ((__psunsigned_t)(x)>>BPCSHIFT)
> -#define	ctob64(x)	((__uint64_t)(x)<<BPCSHIFT)
> -
> -/* bytes to clicks */
> -#define btoc(x)         (((__psunsigned_t)(x)+(NBPC-1))>>BPCSHIFT)
> -
>   #define ENOATTR		ENODATA		/* Attribute not found */
>   #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>   #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> 
> ===========================================================================
> Index: fs/xfs/linux-2.6/xfs_lrw.c
> ===========================================================================
> 
> --- a/fs/xfs/linux-2.6/xfs_lrw.c	2007-11-16 16:22:40.000000000 +1100
> +++ b/fs/xfs/linux-2.6/xfs_lrw.c	2007-11-15 11:32:12.451249159 +1100
> @@ -254,9 +254,8 @@ xfs_read(
> 
>   	if (unlikely(ioflags & IO_ISDIRECT)) {
>   		if (VN_CACHED(vp))
> -			ret = xfs_flushinval_pages(ip,
> -					ctooff(offtoct(*offset)),
> -					-1, FI_REMAPF_LOCKED);
> +			ret = xfs_flushinval_pages(ip, (*offset & PAGE_CACHE_MASK),
> +						    -1, FI_REMAPF_LOCKED);
>   		mutex_unlock(&inode->i_mutex);
>   		if (ret) {
>   			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> @@ -742,9 +741,9 @@ retry:
>   		if (VN_CACHED(vp)) {
>   			WARN_ON(need_i_mutex == 0);
>   			xfs_inval_cached_trace(xip, pos, -1,
> -					ctooff(offtoct(pos)), -1);
> +					(pos & PAGE_CACHE_MASK), -1);
>   			error = xfs_flushinval_pages(xip,
> -					ctooff(offtoct(pos)),
> +					(pos & PAGE_CACHE_MASK),
>   					-1, FI_REMAPF_LOCKED);
>   			if (error)
>   				goto out_unlock_internal;
> 
> ===========================================================================
> Index: fs/xfs/quota/xfs_qm.h
> ===========================================================================
> 
> --- a/fs/xfs/quota/xfs_qm.h	2007-11-16 16:22:40.000000000 +1100
> +++ b/fs/xfs/quota/xfs_qm.h	2007-11-16 15:39:53.373375739 +1100
> @@ -52,8 +52,8 @@ extern kmem_zone_t	*qm_dqtrxzone;
>   /*
>    * Dquot hashtable constants/threshold values.
>    */
> -#define XFS_QM_HASHSIZE_LOW		(NBPP / sizeof(xfs_dqhash_t))
> -#define XFS_QM_HASHSIZE_HIGH		((NBPP * 4) / sizeof(xfs_dqhash_t))
> +#define XFS_QM_HASHSIZE_LOW		(PAGE_SIZE / sizeof(xfs_dqhash_t))
> +#define XFS_QM_HASHSIZE_HIGH		((PAGE_SIZE * 4) / sizeof(xfs_dqhash_t))
> 
>   /*
>    * This defines the unit of allocation of dquots.
> 
> ===========================================================================
> Index: fs/xfs/xfs_bmap.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_bmap.c	2007-11-16 16:22:41.000000000 +1100
> +++ b/fs/xfs/xfs_bmap.c	2007-11-16 15:40:27.017050666 +1100
> @@ -2830,11 +2830,11 @@ xfs_bmap_btalloc(
>   		args.prod = align;
>   		if ((args.mod = (xfs_extlen_t)do_mod(ap->off, args.prod)))
>   			args.mod = (xfs_extlen_t)(args.prod - args.mod);
> -	} else if (mp->m_sb.sb_blocksize >= NBPP) {
> +	} else if (mp->m_sb.sb_blocksize >= PAGE_CACHE_SIZE) {
>   		args.prod = 1;
>   		args.mod = 0;
>   	} else {
> -		args.prod = NBPP >> mp->m_sb.sb_blocklog;
> +		args.prod = PAGE_CACHE_SIZE >> mp->m_sb.sb_blocklog;
>   		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
>   			args.mod = (xfs_extlen_t)(args.prod - args.mod);
>   	}
> 
> ===========================================================================
> Index: fs/xfs/xfs_itable.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_itable.c	2007-11-16 16:22:40.000000000 +1100
> +++ b/fs/xfs/xfs_itable.c	2007-11-16 16:05:51.381600461 +1100
> @@ -393,7 +393,7 @@ xfs_bulkstat(
>   		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
>   	nimask = ~(nicluster - 1);
>   	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
> -	irbuf = kmem_zalloc_greedy(&irbsize, NBPC, NBPC * 4,
> +	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4,
>   				   KM_SLEEP | KM_MAYFAIL | KM_LARGE);
>   	nirbuf = irbsize / sizeof(*irbuf);
> 
> @@ -815,7 +815,7 @@ xfs_inumbers(
>   	agino = XFS_INO_TO_AGINO(mp, ino);
>   	left = *count;
>   	*count = 0;
> -	bcount = MIN(left, (int)(NBPP / sizeof(*buffer)));
> +	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
>   	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
>   	error = bufidx = 0;
>   	cur = NULL;
> 
> ===========================================================================
> Index: fs/xfs/xfs_log.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_log.c	2007-11-16 16:22:40.000000000 +1100
> +++ b/fs/xfs/xfs_log.c	2007-11-16 15:56:42.615917720 +1100
> @@ -1552,7 +1552,7 @@ xlog_dealloc_log(xlog_t *log)
>   		tic = log->l_unmount_free;
>   		while (tic) {
>   			next_tic = tic->t_next;
> -			kmem_free(tic, NBPP);
> +			kmem_free(tic, PAGE_SIZE);
>   			tic = next_tic;
>   		}
>   	}
> @@ -3161,13 +3161,13 @@ xlog_state_ticket_alloc(xlog_t *log)
>   	xlog_ticket_t	*t_list;
>   	xlog_ticket_t	*next;
>   	xfs_caddr_t	buf;
> -	uint		i = (NBPP / sizeof(xlog_ticket_t)) - 2;
> +	uint		i = (PAGE_SIZE / sizeof(xlog_ticket_t)) - 2;
> 
>   	/*
>   	 * The kmem_zalloc may sleep, so we shouldn't be holding the
>   	 * global lock.  XXXmiken: may want to use zone allocator.
>   	 */
> -	buf = (xfs_caddr_t) kmem_zalloc(NBPP, KM_SLEEP);
> +	buf = (xfs_caddr_t) kmem_zalloc(PAGE_SIZE, KM_SLEEP);
> 
>   	spin_lock(&log->l_icloglock);
> 
> 
> ===========================================================================
> Index: fs/xfs/xfs_vnodeops.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_vnodeops.c	2007-11-16 16:22:41.000000000 +1100
> +++ b/fs/xfs/xfs_vnodeops.c	2007-11-16 15:57:01.449505791 +1100
> @@ -4164,15 +4164,12 @@ xfs_free_file_space(
>   		vn_iowait(ip);	/* wait for the completion of any pending DIOs */
>   	}
> 
> -	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, NBPP);
> +	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
>   	ioffset = offset & ~(rounding - 1);
> 
>   	if (VN_CACHED(vp) != 0) {
> -		xfs_inval_cached_trace(ip, ioffset, -1,
> -				ctooff(offtoct(ioffset)), -1);
> -		error = xfs_flushinval_pages(ip,
> -				ctooff(offtoct(ioffset)),
> -				-1, FI_REMAPF_LOCKED);
> +		xfs_inval_cached_trace(ip, ioffset, -1, ioffset, -1);
> +		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
>   		if (error)
>   			goto out_unlock_iolock;
>   	}
> 
> 
> 
> 
