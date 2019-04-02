Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17793 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbfDBNYs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 09:24:48 -0400
Date: Tue, 2 Apr 2019 09:24:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/10] xfs: clear BAD_SUMMARY if unmounting an unhealthy
 filesystem
Message-ID: <20190402132442.GE2899@bfoster>
References: <155413860964.4966.6087725033542837255.stgit@magnolia>
 <155413862812.4966.6543791189302248422.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <155413862812.4966.6543791189302248422.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 01, 2019 at 10:10:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we know the filesystem metadata isn't healthy during unmount, we want
> to encourage the administrator to run xfs_repair right away.  We can't
> do this if BAD_SUMMARY will cause an unclean log unmount to force
> summary recalculation, so turn it off if the fs is bad.
> 

Do you mean we don't want to suggest xfs_repair because we intentionally
cause a dirty log and thus xfs_repair will require to zap it? If so, the
wording above and the comment in xfs_health_unmount() could be a bit
more specific on the reasoning.

Also, what exactly is the side effect without this change in place? The
user would have to zap the log from xfs_repair, but the somewhat
artificial unclean unmount doesn't actually require log recovery to fix
up the fs outside of the whole summary counter thing, right? IOW, would
the user zapping the log actually lose anything besides the bad summary
counter indication? I ask just because even though we warn the user to
run repair, that doesn't mean they'll actually do it and so it seems
there is a bit of a tradeoff in that regard.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

BTW, I get the following compiler warning on this patch:

In file included from fs/xfs/xfs_trace.h:12,
                 from fs/xfs/xfs_health.c:19:
fs/xfs/xfs_health.c: In function ‘xfs_health_unmount’:
./include/linux/tracepoint.h:195:6: warning: ‘sick’ may be used uninitialized in this function [-Wmaybe-uninitialized]                                                                                            
     ((void(*)(proto))(it_func))(args); \
      ^
fs/xfs/xfs_health.c:33:16: note: ‘sick’ was declared here
  unsigned int  sick;

Brian

>  fs/xfs/libxfs/xfs_health.h |    2 +
>  fs/xfs/xfs_health.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.c         |    2 +
>  fs/xfs/xfs_trace.h         |    3 ++
>  4 files changed, 66 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
> index 0d51bd2689ea..269b124dc1d7 100644
> --- a/fs/xfs/libxfs/xfs_health.h
> +++ b/fs/xfs/libxfs/xfs_health.h
> @@ -148,6 +148,8 @@ void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
>  void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
>  unsigned int xfs_inode_measure_sickness(struct xfs_inode *ip);
>  
> +void xfs_health_unmount(struct xfs_mount *mp);
> +
>  /* Now some helpers. */
>  
>  static inline bool
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index e9d6859f7501..6e2da858c356 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -19,6 +19,65 @@
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
> +	unsigned int		sick;
> +	bool			warn = false;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return;
> +
> +	/* Measure AG corruption levels. */
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		pag = xfs_perag_get(mp, agno);
> +		spin_lock(&pag->pag_state_lock);
> +		if (pag->pag_sick) {
> +			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
> +			warn = true;
> +		}
> +		spin_unlock(&pag->pag_state_lock);
> +		xfs_perag_put(pag);
> +	}
> +
> +	/* Measure realtime volume corruption levels. */
> +	sick = xfs_rt_measure_sickness(mp);
> +	if (sick) {
> +		trace_xfs_rt_unfixed_corruption(mp, sick);
> +		warn = true;
> +	}
> +
> +	/* Measure fs corruption and keep the sample around for the warning. */
> +	sick = xfs_fs_measure_sickness(mp);
> +	if (sick) {
> +		trace_xfs_fs_unfixed_corruption(mp, sick);
> +		warn = true;
> +	}
> +
> +	if (warn) {
> +		xfs_warn(mp,
> +"Uncorrected metadata errors detected; please run xfs_repair.");
> +
> +		/*
> +		 * If we have unhealthy metadata, we want the admin to run
> +		 * xfs_repair after unmounting.  They can't do that if the log
> +		 * is written out without a clean unmount record (such as when
> +		 * the summary counters are marked unhealthy to force
> +		 * recalculation of the summary counters) so clear it.
> +		 */
> +		if (sick & XFS_HEALTH_FS_COUNTERS)
> +			xfs_fs_mark_healthy(mp, XFS_HEALTH_FS_COUNTERS);
> +	}
> +}
> +
>  /* Mark unhealthy per-fs metadata. */
>  void
>  xfs_fs_mark_sick(
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index a43ca655a431..f0f73d598a0c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1075,6 +1075,7 @@ xfs_mountfs(
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
>  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_health_unmount(mp);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
>  	xfs_log_mount_cancel(mp);
> @@ -1157,6 +1158,7 @@ xfs_unmountfs(
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
