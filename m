Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbeAENIZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:08:25 -0500
Date: Fri, 5 Jan 2018 08:08:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: trace log reservations at mount time
Message-ID: <20180105130822.GA27973@bfoster.bfoster>
References: <151512356118.14363.7797314285394643799.stgit@magnolia>
 <151512356737.14363.9190260401902946215.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151512356737.14363.9190260401902946215.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 04, 2018 at 07:39:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> At each mount, emit the transaction reservation type information via
> tracepoints.  This makes it easier to compare the log reservation info
> calculated by the kernel and xfsprogs so that we can more easily diagnose
> minimum log size failures on freshly formatted filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_log_rlimit.c |    2 +-
>  fs/xfs/libxfs/xfs_shared.h     |    3 +++
>  fs/xfs/xfs_trace.h             |   26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.c             |   22 ++++++++++++++++++++++
>  4 files changed, 52 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index c105979..cc4cbe2 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -55,7 +55,7 @@ xfs_log_calc_max_attrsetm_res(
>   * the maximum one in terms of the pre-calculated values which were done
>   * at mount time.
>   */
> -STATIC void
> +void
>  xfs_log_get_max_trans_res(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_res	*max_resp)
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 67ccb1a..d0b84da 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -76,6 +76,9 @@ struct xfs_log_item_desc {
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
>  int	xfs_log_calc_minimum_size(struct xfs_mount *);
>  
> +struct xfs_trans_res;
> +void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
> +				  struct xfs_trans_res *max_resp);
>  
>  /*
>   * Values for t_flags.
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9235b2c..b6251f8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3313,6 +3313,32 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
>  DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
>  DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  
> +TRACE_EVENT(xfs_trans_resv_calc,
> +	TP_PROTO(struct xfs_mount *mp, unsigned int type,
> +		 struct xfs_trans_res *res),
> +	TP_ARGS(mp, type, res),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, type)
> +		__field(uint, logres)
> +		__field(int, logcount)
> +		__field(int, logflags)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->type = type;
> +		__entry->logres = res->tr_logres;
> +		__entry->logcount = res->tr_logcount;
> +		__entry->logflags = res->tr_logflags;
> +	),
> +	TP_printk("dev %d:%d type %d logres %u logcount %d flags 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->type,
> +		  __entry->logres,
> +		  __entry->logcount,
> +		  __entry->logflags)
> +);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index a87f657..86f92df 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -35,6 +35,27 @@
>  kmem_zone_t	*xfs_trans_zone;
>  kmem_zone_t	*xfs_log_item_desc_zone;
>  
> +#if defined(CONFIG_TRACEPOINTS)
> +static void
> +xfs_trans_trace_reservations(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_trans_res	resv;
> +	struct xfs_trans_res	*res;
> +	struct xfs_trans_res	*end_res;
> +	int			i;
> +
> +	res = (struct xfs_trans_res *)M_RES(mp);
> +	end_res = (struct xfs_trans_res *)(M_RES(mp) + 1);
> +	for (i = 0; res < end_res; i++, res++)
> +		trace_xfs_trans_resv_calc(mp, i, res);
> +	xfs_log_get_max_trans_res(mp, &resv);
> +	trace_xfs_trans_resv_calc(mp, -1, &resv);
> +}
> +#else
> +# define xfs_trans_trace_reservations(mp)
> +#endif
> +
>  /*
>   * Initialize the precomputed transaction reservation values
>   * in the mount structure.
> @@ -44,6 +65,7 @@ xfs_trans_init(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_trans_resv_calc(mp, M_RES(mp));
> +	xfs_trans_trace_reservations(mp);
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
