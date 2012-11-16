Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG94f1H083810 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 03:04:41 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id c5WRRUYhHqaXB7ye (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Nov 2012 01:06:46 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG96gf5021662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 09:06:45 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG96gj0011883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 09:06:42 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG96gMu027768 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 03:06:42 -0600
Message-ID: <50A6021B.2000101@oracle.com>
Date: Fri, 16 Nov 2012 17:06:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/15] xfs: Introduce a new ioctl(2) to set AG state
References: <50A5E0FB.5060201@oracle.com>
In-Reply-To: <50A5E0FB.5060201@oracle.com>
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
To: xfs@oss.sgi.com
Cc: jeff.liu@oracle.com

On 11/16/2012 02:45 PM, Jeff Liu wrote:
> Introduce a new ioctl(2) for setting a.g. state.
> 
> - Add a new structure xfs_ioc_agstate.
> - Add a macro to indicate an a.g. is offline.
> - Add XFS_IOC_SET_AGSTATE for ioctl(2).
> - Teach xfs_alloc_log_agf() aware of agf_state.
> 
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_ag.h    |   17 ++++++++++++
>  fs/xfs/xfs_alloc.c |    1 +
>  fs/xfs/xfs_fs.h    |    1 +
>  fs/xfs/xfs_fsops.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_ioctl.c |   13 +++++++++
>  fs/xfs/xfs_trans.h |    2 +-
>  6 files changed, 104 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index fd578e6..e2588d9 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h
> @@ -235,6 +235,23 @@ typedef struct xfs_perag {
>  } xfs_perag_t;
>  
>  /*
> + * Structure for ioctl per a.g. state get/set.
> + */
> +typedef struct xfs_ioc_agstate {
> +	xfs_agnumber_t	agno;
> +	__uint32_t	state;
> +} xfs_ioc_agstate_t;
> +
> +/*
> + * Skip an AG with below state for inodes/blocks allocation.
> + */
> +#define XFS_AG_STATE_ALLOC_DENY		(1 << 0)
> +#define XFS_AG_ALL_STATE		(XFS_AG_STATE_ALLOC_DENY)
> +
> +extern int xfs_set_agstate(struct xfs_mount *mp,
> +			   struct xfs_ioc_agstate *agstate);
> +
> +/*
>   * tags for inode radix tree
>   */
>  #define XFS_ICI_NO_TAG		(-1)	/* special flag for an untagged lookup
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 4f33c32..bd9cc41 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2005,6 +2005,7 @@ xfs_alloc_log_agf(
>  		offsetof(xfs_agf_t, agf_freeblks),
>  		offsetof(xfs_agf_t, agf_longest),
>  		offsetof(xfs_agf_t, agf_btreeblks),
> +		offsetof(xfs_agf_t, agf_state),
>  		sizeof(xfs_agf_t)
>  	};
>  
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index c13fed8..991c09e 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -486,6 +486,7 @@ typedef struct xfs_handle {
>  #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
> +#define XFS_IOC_SET_AGSTATE	     _IOW('X', 126, struct xfs_ioc_agstate)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index c25b094..3742511 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -112,10 +112,79 @@ xfs_fs_geometry(
>  	return 0;
>  }
>  
> +/*
> + * Setting a.g. persistent state as well as perag incore state.
> + */
> +static void
> +xfs_set_agstate_private(
> +	xfs_trans_t	*tp,	/* transaction pointer */
> +	xfs_buf_t	*agbp,	/* buffer for a.g. freelist header */
> +	xfs_perag_t	*pag,	/* incore perag structure */
> +	__uint32_t	state)  /* a.g. state to be set */
> +{
> +	xfs_agf_t	*agf;	/* a.g. free space */
> +
> +	agf = XFS_BUF_TO_AGF(agbp);
> +	agf->agf_state |= cpu_to_be32(state);
> +	pag->pag_state |= state;
> +
> +	xfs_alloc_log_agf(tp, agbp, XFS_AGF_STATE);
> +}
> +
> +/*
> + * Setting the state of the given AG.
> + *
> + * For now, we can set a given AG to be offline or online, and
> + * allocaters will skip an AG being offline to allocate inodes
> + * or free space.
> + */
> +int
> +xfs_set_agstate(
> +	xfs_mount_t		*mp,
> +	xfs_ioc_agstate_t	*agstate)
> +{
> +	xfs_agnumber_t		agno;
> +	xfs_perag_t		*pag;
> +	xfs_trans_t		*tp;
> +	xfs_buf_t		*bp;
> +	int			error;
> +
> +	agno = agstate->agno;
> +	if (agno >= mp->m_sb.sb_agcount)
> +		return XFS_ERROR(EINVAL);
> +
> +	if ((agstate->state & XFS_AG_ALL_STATE) != agstate->state)
> +		return XFS_ERROR(EINVAL);
Maybe it's better to rename XFS_AG_ALL_STATE to XFS_AG_STATS_VALID, and
do this check as below:
	if (agstate->state &~ XFS_AG_STATES_VALID)
		return XFS_ERROR(EINVAL);
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_AGSTATE);
> +	error = xfs_trans_reserve(tp, 0, XFS_SETAGSTATE_LOG_RES(mp), 0, 0,
> +				  XFS_DEFAULT_LOG_COUNT);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		return error;
> +	}
> +
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &bp);
> +	if (error)
> +		goto error0;
> +
> +	pag = xfs_perag_get(mp, agno);
> +	xfs_set_agstate_private(tp, bp, pag, agstate->state);
> +	xfs_perag_put(pag);
> +
> +	xfs_trans_set_sync(tp);
> +	xfs_trans_commit(tp, 0);
> +	return error;
> +
> +error0:
> +	xfs_trans_cancel(tp, XFS_TRANS_ABORT);
> +	return error;
> +}
> +
>  static int
>  xfs_growfs_data_private(
> -	xfs_mount_t		*mp,		/* mount point for filesystem */
> -	xfs_growfs_data_t	*in)		/* growfs data input struct */
> +	xfs_mount_t		*mp,	/* mount point for filesystem */
> +	xfs_growfs_data_t	*in)	/* growfs data input struct */
>  {
>  	xfs_agf_t		*agf;
>  	xfs_agi_t		*agi;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8305f2a..efe39ef 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1602,6 +1602,19 @@ xfs_file_ioctl(
>  		error = xfs_errortag_clearall(mp, 1);
>  		return -error;
>  
> +	case XFS_IOC_SET_AGSTATE: {
> +		xfs_ioc_agstate_t in;
> +
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (copy_from_user(&in, arg, sizeof(in)))
> +			return -XFS_ERROR(EFAULT);
> +
> +		error = xfs_set_agstate(mp, &in);
> +		return -error;
> +	}
> +
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a4f4092..14f897d 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -264,7 +264,7 @@ struct xfs_log_item_desc {
>  	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
>  #define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
>  #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
> -#define XFS_SETAGSTATE_LOG_RES ((mp)->m_reservations.tr_setagstate)
> +#define XFS_SETAGSTATE_LOG_RES(mp) ((mp)->m_reservations.tr_setagstate)
>  
>  /*
>   * Various log count values.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
