Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8844D7F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 10:18:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A623304066
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 08:18:47 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Bg2HzIdcfbk59eOd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 08:18:45 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4HFIgb9032290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:18:43 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4HFIgO6019734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:18:43 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4HFIgOQ011707 for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:18:42 GMT
Message-ID: <51964A4F.3070405@oracle.com>
Date: Fri, 17 May 2013 23:18:39 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/8] xfs: Introduce a new structure to hold transaction
	reservation items
References: <5195C23F.3040406@oracle.com>
In-Reply-To: <5195C23F.3040406@oracle.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/17/2013 01:38 PM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce a new structure xfs_trans_res to hold transaction reservation
> item info per log ticket.
> 
> We also need to improve xfs_trans_init() by initializing the log count
> as well as log flags for permanent log reservation.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/xfs/xfs_mount.h |   68 +++++++++++++++++------------
>  fs/xfs/xfs_trans.c |  121 ++++++++++++++++++++++++++++++++++++++++------------
>  fs/xfs/xfs_trans.h |   67 ++++++++++++++++-------------
>  3 files changed, 171 insertions(+), 85 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index b004cec..474826e 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -18,35 +18,47 @@
>  #ifndef __XFS_MOUNT_H__
>  #define	__XFS_MOUNT_H__
>  
> +struct xfs_trans_res {
> +	uint	tr_logres;	/* log space unit in bytes per log ticket */
> +	int	tr_logcount;	/* number of log operations per log ticket */
> +	int	tr_logflags;	/* log flags, currently only used for indicating
> +				 * a reservation request is permanent or not */
> +};
> +
>  typedef struct xfs_trans_reservations {
BTW, I'll remove "typedef xfs_trans_reservations_t" in next round post
as it is only defined and used in this file.

Thanks,
-Jeff
> -	uint	tr_write;	/* extent alloc trans */
> -	uint	tr_itruncate;	/* truncate trans */
> -	uint	tr_rename;	/* rename trans */
> -	uint	tr_link;	/* link trans */
> -	uint	tr_remove;	/* unlink trans */
> -	uint	tr_symlink;	/* symlink trans */
> -	uint	tr_create;	/* create trans */
> -	uint	tr_mkdir;	/* mkdir trans */
> -	uint	tr_ifree;	/* inode free trans */
> -	uint	tr_ichange;	/* inode update trans */
> -	uint	tr_growdata;	/* fs data section grow trans */
> -	uint	tr_swrite;	/* sync write inode trans */
> -	uint	tr_addafork;	/* cvt inode to attributed trans */
> -	uint	tr_writeid;	/* write setuid/setgid file */
> -	uint	tr_attrinval;	/* attr fork buffer invalidation */
> -	uint	tr_attrsetm;	/* set/create an attribute at mount time */
> -	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
> -	uint	tr_attrrm;	/* remove an attribute */
> -	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
> -	uint	tr_growrtalloc;	/* grow realtime allocations */
> -	uint	tr_growrtzero;	/* grow realtime zeroing */
> -	uint	tr_growrtfree;	/* grow realtime freeing */
> -	uint	tr_qm_sbchange;	/* change quota flags */
> -	uint	tr_qm_setqlim;	/* adjust quota limits */
> -	uint	tr_qm_dqalloc;	/* allocate quota on disk */
> -	uint	tr_qm_quotaoff;	/* turn quota off */
> -	uint	tr_qm_equotaoff;/* end of turn quota off */
> -	uint	tr_sb;		/* modify superblock */
> +	struct xfs_trans_res	tr_write;	/* extent alloc trans */
> +	struct xfs_trans_res	tr_itruncate;	/* truncate trans */
> +	struct xfs_trans_res	tr_rename;	/* rename trans */
> +	struct xfs_trans_res	tr_link;	/* link trans */
> +	struct xfs_trans_res	tr_remove;	/* unlink trans */
> +	struct xfs_trans_res	tr_symlink;	/* symlink trans */
> +	struct xfs_trans_res	tr_create;	/* create trans */
> +	struct xfs_trans_res	tr_mkdir;	/* mkdir trans */
> +	struct xfs_trans_res	tr_ifree;	/* inode free trans */
> +	struct xfs_trans_res	tr_ichange;	/* inode update trans */
> +	struct xfs_trans_res	tr_growdata;	/* fs data section grow trans */
> +	struct xfs_trans_res	tr_swrite;	/* sync write inode trans */
> +	struct xfs_trans_res	tr_addafork;	/* cvt inode to attributed
> +						 * trans */
> +	struct xfs_trans_res	tr_writeid;	/* write setuid/setgid file */
> +	struct xfs_trans_res	tr_attrinval;	/* attr fork buffer
> +						 * invalidation */
> +	struct xfs_trans_res	tr_attrsetm;	/* set/create an attribute at
> +						 * mount time */
> +	struct xfs_trans_res	tr_attrsetrt;	/* set/create an attribute at
> +						 * runtime */
> +	struct xfs_trans_res	tr_attrrm;	/* remove an attribute */
> +	struct xfs_trans_res	tr_clearagi;	/* clear bad agi unlinked ino
> +						 * bucket */
> +	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
> +	struct xfs_trans_res	tr_growrtzero;	/* grow realtime zeroing */
> +	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
> +	struct xfs_trans_res	tr_qm_sbchange;	/* change quota flags */
> +	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
> +	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
> +	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
> +	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
> +	struct xfs_trans_res	tr_sb;		/* modify superblock */
>  } xfs_trans_reservations_t;
>  
>  #ifndef __KERNEL__
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 2fd7c1f..8f38901 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -645,34 +645,99 @@ xfs_trans_init(
>  {
>  	struct xfs_trans_reservations *resp = &mp->m_reservations;
>  
> -	resp->tr_write = xfs_calc_write_reservation(mp);
> -	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
> -	resp->tr_rename = xfs_calc_rename_reservation(mp);
> -	resp->tr_link = xfs_calc_link_reservation(mp);
> -	resp->tr_remove = xfs_calc_remove_reservation(mp);
> -	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
> -	resp->tr_create = xfs_calc_create_reservation(mp);
> -	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
> -	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
> -	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
> -	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
> -	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
> -	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
> -	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
> -	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
> -	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
> -	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
> -	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
> -	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
> -	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
> -	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
> -	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
> -	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
> -	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
> -	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
> -	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
> -	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
> -	resp->tr_sb = xfs_calc_sb_reservation(mp);
> +	/*
> +	 * The following transactions are logged in physical format and
> +	 * require a permanent reservation on space.
> +	 */
> +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
> +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
> +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> +	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> +	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
> +	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
> +	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
> +	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
> +	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
> +	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
> +	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_create.tr_logres = xfs_calc_create_reservation(mp);
> +	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
> +	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> +	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
> +	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
> +	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_addafork.tr_logres = xfs_calc_addafork_reservation(mp);
> +	resp->tr_addafork.tr_logcount = XFS_ADDAFORK_LOG_COUNT;
> +	resp->tr_addafork.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_attrinval.tr_logres = xfs_calc_attrinval_reservation(mp);
> +	resp->tr_attrinval.tr_logcount = XFS_ATTRINVAL_LOG_COUNT;
> +	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_attrsetm.tr_logres = xfs_calc_attrsetm_reservation(mp);
> +	resp->tr_attrsetm.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_attrrm.tr_logres = xfs_calc_attrrm_reservation(mp);
> +	resp->tr_attrrm.tr_logcount = XFS_ATTRRM_LOG_COUNT;
> +	resp->tr_attrrm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_growrtalloc.tr_logres = xfs_calc_growrtalloc_reservation(mp);
> +	resp->tr_growrtalloc.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> +	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
> +	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	/*
> +	 * The following transactions are logged in logical format with
> +	 * a default log count.
> +	 */
> +	resp->tr_qm_sbchange.tr_logres = xfs_calc_qm_sbchange_reservation(mp);
> +	resp->tr_qm_sbchange.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> +
> +	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation(mp);
> +	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> +
> +	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
> +	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> +
> +	resp->tr_qm_equotaoff.tr_logres =
> +		xfs_calc_qm_quotaoff_end_reservation(mp);
> +	resp->tr_qm_equotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> +
> +	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
> +	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
> +
> +	/* The following transaction are logged in logical format */
> +	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
> +	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
> +	resp->tr_swrite.tr_logres = xfs_calc_swrite_reservation(mp);
> +	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> +	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> +	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
> +	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
> +	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a44dba5..15a6031 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -232,39 +232,48 @@ struct xfs_log_item_desc {
>  	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
>  
>  
> -#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
> -#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
> -#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
> -#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
> -#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
> -#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
> -#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
> -#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
> -#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
> -#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
> -#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
> -#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
> -#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
> -#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
> -#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
> +#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write.tr_logres)
> +#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename.tr_logres)
> +#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link.tr_logres)
> +#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove.tr_logres)
> +#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink.tr_logres)
> +#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create.tr_logres)
> +#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir.tr_logres)
> +#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree.tr_logres)
> +#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange.tr_logres)
> +#define	XFS_GROWDATA_LOG_RES(mp)  ((mp)->m_reservations.tr_growdata.tr_logres)
> +#define	XFS_ITRUNCATE_LOG_RES(mp) ((mp)->m_reservations.tr_itruncate.tr_logres)
> +#define	XFS_GROWRTALLOC_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_growrtalloc.tr_logres)
> +#define	XFS_GROWRTZERO_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_growrtzero.tr_logres)
> +#define	XFS_GROWRTFREE_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_growrtfree.tr_logres)
> +#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite.tr_logres)
>  /*
>   * Logging the inode timestamps on an fsync -- same as SWRITE
>   * as long as SWRITE logs the entire inode core
>   */
> -#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
> -#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
> -#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
> -#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
> -#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
> -#define XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
> -#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
> -#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
> -#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
> -#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
> -#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
> -#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
> -#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
> -#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
> +#define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_reservations.tr_swrite.tr_logres)
> +#define	XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_reservations.tr_swrite.tr_logres)
> +#define	XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_reservations.tr_addafork.tr_logres)
> +#define	XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_reservations.tr_attrsetm.tr_logres)
> +#define	XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_reservations.tr_attrinval.tr_logres)
> +#define XFS_ATTRSETRT_LOG_RES(mp) ((mp)->m_reservations.tr_attrsetrt.tr_logres)
> +#define	XFS_ATTRRM_LOG_RES(mp)	  ((mp)->m_reservations.tr_attrrm.tr_logres)
> +#define XFS_SB_LOG_RES(mp)	  ((mp)->m_reservations.tr_sb.tr_logres)
> +#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)\
> +	((mp)->m_reservations.tr_clearagi.tr_logres)
> +#define XFS_QM_SBCHANGE_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_qm_sbchange.tr_logres)
> +#define XFS_QM_SETQLIM_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_qm_setqlim.tr_logres)
> +#define XFS_QM_DQALLOC_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_qm_dqalloc.tr_logres)
> +#define XFS_QM_QUOTAOFF_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_qm_quotaoff.tr_logres)
> +#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	\
> +	((mp)->m_reservations.tr_qm_equotaoff.tr_logres)
>  
>  /*
>   * Various log count values.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
