Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfDKM3Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Apr 2019 08:29:16 -0400
Date: Thu, 11 Apr 2019 08:29:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/8] xfs: clear BAD_SUMMARY if unmounting an unhealthy
 filesystem
Message-ID: <20190411122910.GC2888@bfoster>
References: <155494712442.1090518.2784809287026447547.stgit@magnolia>
 <155494714539.1090518.9582107800209578968.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155494714539.1090518.9582107800209578968.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 10, 2019 at 06:45:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we know the filesystem metadata isn't healthy during unmount, we want
> to encourage the administrator to run xfs_repair right away.  We can't
> do this if BAD_SUMMARY will cause an unclean log unmount to force
> summary recalculation, so turn it off if the fs is bad.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_health.h |    2 +
>  fs/xfs/xfs_health.c        |   74 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.c         |    2 +
>  fs/xfs/xfs_trace.h         |    3 ++
>  4 files changed, 81 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 30762a5d4862..a434b47f2aa0 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -110,6 +110,8 @@ void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
>  void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
>  		unsigned int *checked);
>  
> +void xfs_health_unmount(struct xfs_mount *mp);
> +
>  /* Now some helpers. */
>  
>  static inline bool
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 941f33037e2f..21728228e08b 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -19,6 +19,80 @@
>  #include "xfs_trace.h"
>  #include "xfs_health.h"
>  
> +/*
> + * Warn about metadata corruption that we detected but haven't fixed, and
> + * make sure we're not sitting on anything that would get in the way of
> + * recovery.
> + */
> +void
> +xfs_health_unmount(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno;
> +	unsigned int		sick = 0;
> +	unsigned int		checked = 0;
> +	bool			warn = false;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return;
> +
> +	/* Measure AG corruption levels. */
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		pag = xfs_perag_get(mp, agno);
> +		xfs_ag_measure_sickness(pag, &sick, &checked);
> +		if (sick) {
> +			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
> +			warn = true;
> +		}
> +		xfs_perag_put(pag);
> +	}
> +
> +	/* Measure realtime volume corruption levels. */
> +	xfs_rt_measure_sickness(mp, &sick, &checked);
> +	if (sick) {
> +		trace_xfs_rt_unfixed_corruption(mp, sick);
> +		warn = true;
> +	}
> +
> +	/*
> +	 * Measure fs corruption and keep the sample around for the warning.
> +	 * See the note below for why we exempt FS_COUNTERS.
> +	 */
> +	xfs_fs_measure_sickness(mp, &sick, &checked);
> +	if (sick & ~XFS_SICK_FS_COUNTERS) {
> +		trace_xfs_fs_unfixed_corruption(mp, sick);
> +		warn = true;
> +	}
> +
> +	if (warn) {
> +		xfs_warn(mp,
> +"Uncorrected metadata errors detected; please run xfs_repair.");
> +
> +		/*
> +		 * We discovered uncorrected metadata problems at some point
> +		 * during this filesystem mount and have advised the
> +		 * administrator to run repair once the unmount completes.
> +		 *
> +		 * However, we must be careful -- when FSCOUNTERS are flagged
> +		 * unhealthy, the unmount procedure omits writing the clean
> +		 * unmount record to the log so that the next mount will run
> +		 * recovery and recompute the summary counters.  In other
> +		 * words, we leave a dirty log to get the counters fixed.
> +		 *
> +		 * Unfortunately, xfs_repair cannot recover dirty logs, so if
> +		 * there were filesystem problems, FSCOUNTERS was flagged, and
> +		 * the administrator takes our advice to run xfs_repair,
> +		 * they'll have to zap the log before repairing structures.
> +		 * We don't really want to encourage this, so we mark the
> +		 * FSCOUNTERS healthy so that a subsequent repair run won't see
> +		 * a dirty log.
> +		 */
> +		if (sick & XFS_SICK_FS_COUNTERS)
> +			xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
> +	}
> +}
> +
>  /* Mark unhealthy per-fs metadata. */
>  void
>  xfs_fs_mark_sick(
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 14f454e09e6e..eff8b4c3eb3e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1070,6 +1070,7 @@ xfs_mountfs(
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_health_unmount(mp);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  	xfs_log_mount_cancel(mp);
> @@ -1152,6 +1153,7 @@ xfs_unmountfs(
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_health_unmount(mp);
>  
>  	xfs_qm_unmount(mp);
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f079841c7af6..2464ea351f83 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3461,8 +3461,10 @@ DEFINE_EVENT(xfs_fs_corrupt_class, name,	\
>  	TP_ARGS(mp, flags))
>  DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_sick);
>  DEFINE_FS_CORRUPT_EVENT(xfs_fs_mark_healthy);
> +DEFINE_FS_CORRUPT_EVENT(xfs_fs_unfixed_corruption);
>  DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_sick);
>  DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
> +DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
>  
>  DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
> @@ -3488,6 +3490,7 @@ DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
>  	TP_ARGS(mp, agno, flags))
>  DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
>  DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
> +DEFINE_AG_CORRUPT_EVENT(xfs_ag_unfixed_corruption);
>  
>  DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned int flags),
> 
