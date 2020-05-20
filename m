Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403ECC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEF320823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:44:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kl+Wps9y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgETUol (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:44:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETUol (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:44:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKg3Hf038808;
        Wed, 20 May 2020 20:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/POAZxKldOJGPEideVc9QbpLFBV5vkppruxdJXBuCFg=;
 b=kl+Wps9ycU3TUNcjznzpH5ZIyOtkE5S+WCBlDdvt1XB6FMK4GPGQ+qJeaOkZLL7/E8Uq
 w0pw6J3trL8P7+6b9wMMN26ZQe9k83o/XcggA2KtzrTFg78BeKWrYWhFu0Xx7VUyrVr9
 6d8Qb9x63v1+RJMB5IoWqAqp8z475vc/c41jKmMGUIBMUJUr3W8jxPyzAunm+hLjaCLS
 LMAcjc/UQBx9KNod7JXHcpINzoVtrZEISMX17tw8xOkE0jDFHmtbrpvtrd63/TjbocNw
 p9Wer01IC/WVvY0NkdNhHTc/ShtLhONXVEe7hj9dI9QbKwYFGhqjzcpVIrhTrfux3eMv Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rbutu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:44:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKhCZ2138044;
        Wed, 20 May 2020 20:44:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t38rrxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:44:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KKiZ54001481;
        Wed, 20 May 2020 20:44:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:44:35 -0700
Date:   Wed, 20 May 2020 13:44:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200520204434.GE17627@magnolia>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519222310.2576434-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:23:09AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Seeing massive cpu usage from xfs_agino_range() on one machine;
> instruction level profiles look similar to another machine running
> the same workload, only one machien is consuming 10x as much CPU as
> the other and going much slower. The only real difference between
> the two machines is core count per socket. Both are running
> identical 16p/16GB virtual machine configurations
> 
> Machine A:
> 
>   25.83%  [k] xfs_agino_range
>   12.68%  [k] __xfs_dir3_data_check
>    6.95%  [k] xfs_verify_ino
>    6.78%  [k] xfs_dir2_data_entry_tag_p
>    3.56%  [k] xfs_buf_find
>    2.31%  [k] xfs_verify_dir_ino
>    2.02%  [k] xfs_dabuf_map.constprop.0
>    1.65%  [k] xfs_ag_block_count
> 
> And takes around 13 minutes to remove 50 million inodes.
> 
> Machine B:
> 
>   13.90%  [k] __pv_queued_spin_lock_slowpath
>    3.76%  [k] do_raw_spin_lock
>    2.83%  [k] xfs_dir3_leaf_check_int
>    2.75%  [k] xfs_agino_range
>    2.51%  [k] __raw_callee_save___pv_queued_spin_unlock
>    2.18%  [k] __xfs_dir3_data_check
>    2.02%  [k] xfs_log_commit_cil
> 
> And takes around 5m30s to remove 50 million inodes.
> 
> Suspect is cacheline contention on m_sectbb_log which is used in one
> of the macros in xfs_agino_range. This is a read-only variable but
> shares a cacheline with m_active_trans which is a global atomic that
> gets bounced all around the machine.
> 
> The workload is trying to run hundreds of thousands of transactions
> per second and hence cacheline contention will be occuring on this
> atomic counter. Hence xfs_agino_range() is likely just be an
> innocent bystander as the cache coherency protocol fights over the
> cacheline between CPU cores and sockets.
> 
> On machine A, this rearrangement of the struct xfs_mount
> results in the profile changing to:
> 
>    9.77%  [kernel]  [k] xfs_agino_range
>    6.27%  [kernel]  [k] __xfs_dir3_data_check
>    5.31%  [kernel]  [k] __pv_queued_spin_lock_slowpath
>    4.54%  [kernel]  [k] xfs_buf_find
>    3.79%  [kernel]  [k] do_raw_spin_lock
>    3.39%  [kernel]  [k] xfs_verify_ino
>    2.73%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
> 
> Vastly less CPU usage in xfs_agino_range(), but still 3x the amount
> of machine B and still runs substantially slower than it should.
> 
> Current rm -rf of 50 million files:
> 
> 		vanilla		patched
> machine A	13m20s		6m42s
> machine B	5m30s		5m02s
> 
> It's an improvement, hence indicating that separation and further
> optimisation of read-only global filesystem data is worthwhile, but
> it clearly isn't the underlying issue causing this specific
> performance degradation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.h | 148 +++++++++++++++++++++++++--------------------
>  1 file changed, 82 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 4835581f3eb00..c1f92c1847bb2 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -55,61 +55,25 @@ struct xfs_error_cfg {
>  	long		retry_timeout;	/* in jiffies, -1 = infinite */
>  };
>  
> +/*
> + * The struct xfsmount layout is optimised to separate read-mostly variables
> + * from variables that are frequently modified. We put the read-mostly variables
> + * first, then place all the other variables at the end.
> + *
> + * Typically, read-mostly variables are those that are set at mount time and
> + * never changed again, or only change rarely as a result of things like sysfs
> + * knobs being tweaked.
> + */
>  typedef struct xfs_mount {
> +	struct xfs_sb		m_sb;		/* copy of fs superblock */
>  	struct super_block	*m_super;
> -
> -	/*
> -	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> -	 * Callers must hold m_sb_lock to access these two fields.
> -	 */
> -	uint8_t			m_fs_checked;
> -	uint8_t			m_fs_sick;
> -	/*
> -	 * Bitsets of rt metadata that have been checked and/or are sick.
> -	 * Callers must hold m_sb_lock to access this field.
> -	 */
> -	uint8_t			m_rt_checked;
> -	uint8_t			m_rt_sick;
> -
>  	struct xfs_ail		*m_ail;		/* fs active log item list */
> -
> -	struct xfs_sb		m_sb;		/* copy of fs superblock */
> -	spinlock_t		m_sb_lock;	/* sb counter lock */
> -	struct percpu_counter	m_icount;	/* allocated inodes counter */
> -	struct percpu_counter	m_ifree;	/* free inodes counter */
> -	struct percpu_counter	m_fdblocks;	/* free block counter */
> -	/*
> -	 * Count of data device blocks reserved for delayed allocations,
> -	 * including indlen blocks.  Does not include allocated CoW staging
> -	 * extents or anything related to the rt device.
> -	 */
> -	struct percpu_counter	m_delalloc_blks;
> -
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
>  	char			*m_rtname;	/* realtime device name */
>  	char			*m_logname;	/* external log device name */
> -	int			m_bsize;	/* fs logical block size */
> -	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
> -	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
> -	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
> -	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> -	uint			m_allocsize_log;/* min write size log bytes */
> -	uint			m_allocsize_blocks; /* min write size blocks */
>  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
>  	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
>  	struct xlog		*m_log;		/* log specific stuff */
> -	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
> -	int			m_logbufs;	/* number of log buffers */
> -	int			m_logbsize;	/* size of each log buffer */
> -	uint			m_rsumlevels;	/* rt summary levels */
> -	uint			m_rsumsize;	/* size of rt summary, bytes */
> -	/*
> -	 * Optional cache of rt summary level per bitmap block with the
> -	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> -	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
> -	 * inode lock.
> -	 */
> -	uint8_t			*m_rsum_cache;
>  	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
>  	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
>  	struct xfs_inode	*m_rootip;	/* pointer to root directory */
> @@ -117,9 +81,26 @@ typedef struct xfs_mount {
>  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
>  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
>  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
> +	/*
> +	 * Optional cache of rt summary level per bitmap block with the
> +	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> +	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
> +	 * inode lock.
> +	 */
> +	uint8_t			*m_rsum_cache;
> +	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> +	struct workqueue_struct *m_buf_workqueue;
> +	struct workqueue_struct	*m_unwritten_workqueue;
> +	struct workqueue_struct	*m_cil_workqueue;
> +	struct workqueue_struct	*m_reclaim_workqueue;
> +	struct workqueue_struct *m_eofblocks_workqueue;
> +	struct workqueue_struct	*m_sync_workqueue;
> +
> +	int			m_bsize;	/* fs logical block size */
>  	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
>  	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
>  	uint8_t			m_agno_log;	/* log #ag's */
> +	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
>  	uint			m_blockwmask;	/* blockwsize-1 */
> @@ -138,47 +119,83 @@ typedef struct xfs_mount {
>  	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
>  	uint			m_alloc_set_aside; /* space we can't use */
>  	uint			m_ag_max_usable; /* max space per AG */
> -	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> -	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> -	struct mutex		m_growlock;	/* growfs mutex */
> +	int			m_dalign;	/* stripe unit */
> +	int			m_swidth;	/* stripe width */
> +	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> +	uint			m_allocsize_log;/* min write size log bytes */
> +	uint			m_allocsize_blocks; /* min write size blocks */
> +	int			m_logbufs;	/* number of log buffers */
> +	int			m_logbsize;	/* size of each log buffer */
> +	uint			m_rsumlevels;	/* rt summary levels */
> +	uint			m_rsumsize;	/* size of rt summary, bytes */
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
> -	uint64_t		m_flags;	/* global mount flags */
> -	bool			m_finobt_nores; /* no per-AG finobt resv. */
>  	uint			m_qflags;	/* quota status flags */
> +	uint64_t		m_flags;	/* global mount flags */
> +	int64_t			m_low_space[XFS_LOWSP_MAX];
> +	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
>  	struct xfs_trans_resv	m_resv;		/* precomputed res values */
> +						/* low free space thresholds */
> +	bool			m_always_cow;
> +	bool			m_fail_unmount;
> +	bool			m_finobt_nores; /* no per-AG finobt resv. */
> +	bool			m_update_sb;	/* sb needs update in mount */
> +
> +	/*
> +	 * Bitsets of per-fs metadata that have been checked and/or are sick.
> +	 * Callers must hold m_sb_lock to access these two fields.
> +	 */
> +	uint8_t			m_fs_checked;
> +	uint8_t			m_fs_sick;
> +	/*
> +	 * Bitsets of rt metadata that have been checked and/or are sick.
> +	 * Callers must hold m_sb_lock to access this field.
> +	 */
> +	uint8_t			m_rt_checked;
> +	uint8_t			m_rt_sick;
> +
> +	/*
> +	 * End of read-mostly variables. Frequently written variables and locks
> +	 * should be placed below this comment from now on. The first variable
> +	 * here is marked as cacheline aligned so they it is separated from
> +	 * the read-mostly variables.
> +	 */
> +
> +	spinlock_t ____cacheline_aligned m_sb_lock; /* sb counter lock */
> +	struct percpu_counter	m_icount;	/* allocated inodes counter */
> +	struct percpu_counter	m_ifree;	/* free inodes counter */
> +	struct percpu_counter	m_fdblocks;	/* free block counter */
> +	/*
> +	 * Count of data device blocks reserved for delayed allocations,
> +	 * including indlen blocks.  Does not include allocated CoW staging
> +	 * extents or anything related to the rt device.
> +	 */
> +	struct percpu_counter	m_delalloc_blks;
> +
> +	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> +	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
>  	uint64_t		m_resblks;	/* total reserved blocks */
>  	uint64_t		m_resblks_avail;/* available reserved blocks */
>  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> -	int			m_dalign;	/* stripe unit */
> -	int			m_swidth;	/* stripe width */
> -	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	atomic_t		m_active_trans;	/* number trans frozen */
> -	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
>  						     trimming */
>  	struct delayed_work	m_cowblocks_work; /* background cow blocks
>  						     trimming */
> -	bool			m_update_sb;	/* sb needs update in mount */
> -	int64_t			m_low_space[XFS_LOWSP_MAX];
> -						/* low free space thresholds */
>  	struct xfs_kobj		m_kobj;
>  	struct xfs_kobj		m_error_kobj;
>  	struct xfs_kobj		m_error_meta_kobj;
>  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
>  	struct xstats		m_stats;	/* per-fs stats */
> +	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
> +	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
> +	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
>  
>  	/*
>  	 * Workqueue item so that we can coalesce multiple inode flush attempts
>  	 * into a single flush.
>  	 */
>  	struct work_struct	m_flush_inodes_work;
> -	struct workqueue_struct *m_buf_workqueue;
> -	struct workqueue_struct	*m_unwritten_workqueue;
> -	struct workqueue_struct	*m_cil_workqueue;
> -	struct workqueue_struct	*m_reclaim_workqueue;
> -	struct workqueue_struct *m_eofblocks_workqueue;
> -	struct workqueue_struct	*m_sync_workqueue;
>  
>  	/*
>  	 * Generation of the filesysyem layout.  This is incremented by each
> @@ -190,9 +207,8 @@ typedef struct xfs_mount {
>  	 * to various other kinds of pain inflicted on the pNFS server.
>  	 */
>  	uint32_t		m_generation;
> +	struct mutex		m_growlock;	/* growfs mutex */
>  
> -	bool			m_always_cow;
> -	bool			m_fail_unmount;
>  #ifdef DEBUG
>  	/*
>  	 * Frequency with which errors are injected.  Replaces xfs_etest; the
> -- 
> 2.26.2.761.g0e0b3e54be
> 
