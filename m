Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfFNOGd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:06:33 -0400
Date: Fri, 14 Jun 2019 10:06:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 13/14] xfs: multithreaded iwalk implementation
Message-ID: <20190614140630.GE26586@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032213550.3774243.7211431131768873383.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032213550.3774243.7211431131768873383.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a parallel iwalk implementation and switch quotacheck to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

The mechanism bits all look pretty good to me. A couple quick nits
below. Otherwise I'll reserve further comment until we work out the
whole heuristic bit.

>  fs/xfs/Makefile      |    1 
>  fs/xfs/xfs_globals.c |    3 +
>  fs/xfs/xfs_iwalk.c   |   82 +++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iwalk.h   |    2 +
>  fs/xfs/xfs_pwork.c   |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_pwork.h   |   58 +++++++++++++++++++++++
>  fs/xfs/xfs_qm.c      |    2 -
>  fs/xfs/xfs_sysctl.h  |    6 ++
>  fs/xfs/xfs_sysfs.c   |   40 ++++++++++++++++
>  fs/xfs/xfs_trace.h   |   18 +++++++
>  10 files changed, 337 insertions(+), 1 deletion(-)
>  create mode 100644 fs/xfs/xfs_pwork.c
>  create mode 100644 fs/xfs/xfs_pwork.h
> 
> 
...
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index def37347a362..0fe740298981 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
...
> @@ -528,6 +541,74 @@ xfs_iwalk(
>  	return error;
>  }
>  
> +/* Run per-thread iwalk work. */
> +static int
> +xfs_iwalk_ag_work(
> +	struct xfs_mount	*mp,
> +	struct xfs_pwork	*pwork)
> +{
> +	struct xfs_iwalk_ag	*iwag;
> +	int			error;
> +
> +	iwag = container_of(pwork, struct xfs_iwalk_ag, pwork);
> +	if (xfs_pwork_want_abort(pwork))
> +		goto out;

Warning here for unitialized use of error.

> +
> +	error = xfs_iwalk_alloc(iwag);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_iwalk_ag(iwag);
> +	xfs_iwalk_free(iwag);
> +out:
> +	kmem_free(iwag);
> +	return error;
> +}
> +
...
> diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> new file mode 100644
> index 000000000000..8d0d5f130252
> --- /dev/null
> +++ b/fs/xfs/xfs_pwork.c
> @@ -0,0 +1,126 @@
...
> +int
> +xfs_pwork_init(
> +	struct xfs_mount	*mp,
> +	struct xfs_pwork_ctl	*pctl,
> +	xfs_pwork_work_fn	work_fn,
> +	const char		*tag,
> +	unsigned int		nr_threads)
> +{
> +#ifdef DEBUG
> +	if (xfs_globals.pwork_threads > 0)
> +		nr_threads = xfs_globals.pwork_threads;
> +	else if (xfs_globals.pwork_threads < 0)
> +		nr_threads = 0;

Can we not just have pwork_threads >= 0 means nr_threads =
pwork_threads, else we rely on the heuristic?

Brian

> +#endif
> +	trace_xfs_pwork_init(mp, nr_threads, current->pid);
> +
> +	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
> +			current->pid);
> +	if (!pctl->wq)
> +		return -ENOMEM;
> +	pctl->work_fn = work_fn;
> +	pctl->error = 0;
> +	pctl->mp = mp;
> +
> +	return 0;
> +}
> +
> +/* Queue some parallel work. */
> +void
> +xfs_pwork_queue(
> +	struct xfs_pwork_ctl	*pctl,
> +	struct xfs_pwork	*pwork)
> +{
> +	INIT_WORK(&pwork->work, xfs_pwork_work);
> +	pwork->pctl = pctl;
> +	queue_work(pctl->wq, &pwork->work);
> +}
> +
> +/* Wait for the work to finish and tear down the control structure. */
> +int
> +xfs_pwork_destroy(
> +	struct xfs_pwork_ctl	*pctl)
> +{
> +	destroy_workqueue(pctl->wq);
> +	pctl->wq = NULL;
> +	return pctl->error;
> +}
> +
> +/*
> + * Return the amount of parallelism that the data device can handle, or 0 for
> + * no limit.
> + */
> +unsigned int
> +xfs_pwork_guess_datadev_parallelism(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buftarg	*btp = mp->m_ddev_targp;
> +	int			iomin;
> +	int			ioopt;
> +
> +	if (blk_queue_nonrot(btp->bt_bdev->bd_queue))
> +		return num_online_cpus();
> +	if (mp->m_sb.sb_width && mp->m_sb.sb_unit)
> +		return mp->m_sb.sb_width / mp->m_sb.sb_unit;
> +	iomin = bdev_io_min(btp->bt_bdev);
> +	ioopt = bdev_io_opt(btp->bt_bdev);
> +	if (iomin && ioopt)
> +		return ioopt / iomin;
> +
> +	return 1;
> +}
> diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
> new file mode 100644
> index 000000000000..4cf1a6f48237
> --- /dev/null
> +++ b/fs/xfs/xfs_pwork.h
> @@ -0,0 +1,58 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_PWORK_H__
> +#define __XFS_PWORK_H__
> +
> +struct xfs_pwork;
> +struct xfs_mount;
> +
> +typedef int (*xfs_pwork_work_fn)(struct xfs_mount *mp, struct xfs_pwork *pwork);
> +
> +/*
> + * Parallel work coordination structure.
> + */
> +struct xfs_pwork_ctl {
> +	struct workqueue_struct	*wq;
> +	struct xfs_mount	*mp;
> +	xfs_pwork_work_fn	work_fn;
> +	int			error;
> +};
> +
> +/*
> + * Embed this parallel work control item inside your own work structure,
> + * then queue work with it.
> + */
> +struct xfs_pwork {
> +	struct work_struct	work;
> +	struct xfs_pwork_ctl	*pctl;
> +};
> +
> +#define XFS_PWORK_SINGLE_THREADED	{ .pctl = NULL }
> +
> +/* Have we been told to abort? */
> +static inline bool
> +xfs_pwork_ctl_want_abort(
> +	struct xfs_pwork_ctl	*pctl)
> +{
> +	return pctl && pctl->error;
> +}
> +
> +/* Have we been told to abort? */
> +static inline bool
> +xfs_pwork_want_abort(
> +	struct xfs_pwork	*pwork)
> +{
> +	return xfs_pwork_ctl_want_abort(pwork->pctl);
> +}
> +
> +int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
> +		xfs_pwork_work_fn work_fn, const char *tag,
> +		unsigned int nr_threads);
> +void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
> +int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
> +unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
> +
> +#endif /* __XFS_PWORK_H__ */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 52e8ec0aa064..8004c931c86e 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1304,7 +1304,7 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> -	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
> +	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
>  	if (error)
>  		goto error_return;
>  
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index ad7f9be13087..b555e045e2f4 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -37,6 +37,9 @@ typedef struct xfs_param {
>  	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
>  	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
>  	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
> +#ifdef DEBUG
> +	xfs_sysctl_val_t pwork_threads;	/* Parallel workqueue thread count */
> +#endif
>  } xfs_param_t;
>  
>  /*
> @@ -82,6 +85,9 @@ enum {
>  extern xfs_param_t	xfs_params;
>  
>  struct xfs_globals {
> +#ifdef DEBUG
> +	int	pwork_threads;		/* parallel workqueue threads */
> +#endif
>  	int	log_recovery_delay;	/* log recovery delay (secs) */
>  	int	mount_delay;		/* mount setup delay (secs) */
>  	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index cabda13f3c64..910e6b9cb1a7 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -206,11 +206,51 @@ always_cow_show(
>  }
>  XFS_SYSFS_ATTR_RW(always_cow);
>  
> +#ifdef DEBUG
> +/*
> + * Override how many threads the parallel work queue is allowed to create.
> + * This has to be a debug-only global (instead of an errortag) because one of
> + * the main users of parallel workqueues is mount time quotacheck.
> + */
> +STATIC ssize_t
> +pwork_threads_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	int		ret;
> +	int		val;
> +
> +	ret = kstrtoint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val < 0 || val > NR_CPUS)
> +		return -EINVAL;
> +
> +	xfs_globals.pwork_threads = val;
> +
> +	return count;
> +}
> +
> +STATIC ssize_t
> +pwork_threads_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
> +}
> +XFS_SYSFS_ATTR_RW(pwork_threads);
> +#endif /* DEBUG */
> +
>  static struct attribute *xfs_dbg_attrs[] = {
>  	ATTR_LIST(bug_on_assert),
>  	ATTR_LIST(log_recovery_delay),
>  	ATTR_LIST(mount_delay),
>  	ATTR_LIST(always_cow),
> +#ifdef DEBUG
> +	ATTR_LIST(pwork_threads),
> +#endif
>  	NULL,
>  };
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index f9bb1d50bc0e..658cbade1998 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3556,6 +3556,24 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
>  		  __entry->startino, __entry->freemask)
>  )
>  
> +TRACE_EVENT(xfs_pwork_init,
> +	TP_PROTO(struct xfs_mount *mp, unsigned int nr_threads, pid_t pid),
> +	TP_ARGS(mp, nr_threads, pid),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, nr_threads)
> +		__field(pid_t, pid)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->nr_threads = nr_threads;
> +		__entry->pid = pid;
> +	),
> +	TP_printk("dev %d:%d nr_threads %u pid %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->nr_threads, __entry->pid)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
