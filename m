Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97D517F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 09:57:10 -0600 (CST)
Message-ID: <51069FD6.7030203@sgi.com>
Date: Mon, 28 Jan 2013 09:57:10 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfsprogs: sync transaction log spaces changes
	to the user space
References: <51067F51.7040904@oracle.com>
In-Reply-To: <51067F51.7040904@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On 01/28/13 07:38, Jeff Liu wrote:
> Sync the kernel codes changes regarding transaction log space reservations
> to the user space.
>
> As we have splitted the calculation of attrset log space reservations into mount
> time and runtime in kernel code, here we need to fix max_attrset_trans_res_adjust()
> to reflect this change.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   include/xfs_mount.h |    3 +-
>   include/xfs_trans.h |    9 +-
>   libxfs/xfs_attr.c   |    9 +-
>   libxfs/xfs_trans.c  |  265 ++++++++++++++++++++++++++-------------------------
>   mkfs/maxtrres.c     |    9 +-
>   5 files changed, 147 insertions(+), 148 deletions(-)
>

For anyone else looking at this. This is basically kernel log 
reservation patch 2 and 13 combined.


> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index c2042b7..2870308 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -254,12 +254,9 @@ struct xfs_log_item_desc {
>   #define	XFS_WRITEID_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
>   #define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
>   #define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
> -#define	XFS_ATTRSET_LOG_RES(mp, ext)	\
> -	((mp)->m_reservations.tr_attrset + \
> -	 (ext * (mp)->m_sb.sb_sectsize) + \
> -	 (ext * XFS_FSB_TO_B((mp), XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK))) + \
> -	 (128 * (ext + (ext * XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)))))
> -#define	XFS_ATTRRM_LOG_RES(mp)	((mp)->m_reservations.tr_attrrm)
> +#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
> +#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
> +#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
>   #define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)

  ...

> index 33dee52..bf8a2c5 100644
> --- a/mkfs/maxtrres.c
> +++ b/mkfs/maxtrres.c
> @@ -34,7 +34,6 @@ max_attrset_trans_res_adjust(
>   	int				local;
>   	int				size;
>   	int				nblks;
> -	int				res;
>
>   	/*
>   	 * Determine space the maximal sized attribute will use,
> @@ -46,13 +45,9 @@ max_attrset_trans_res_adjust(
>   	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
>   	nblks += XFS_B_TO_FSB(mp, size);
>   	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> -	res = XFS_ATTRSET_LOG_RES(mp, nblks);
>
> -#if 0
> -	printf("size = %d nblks = %d res = %d\n", size, nblks, res);
> -#endif
> -
> -	mp->m_reservations.tr_attrset = res;

   This number used to be the mount portion of constant that was
   multiplied times args.total.

   Isn't this value (res) what we want to place into tr_attrsetm
   like before?

   and then tr_attrsetrt is from xfs_calc_attrsetrt_reservation()?

> +	mp->m_reservations.tr_attrsetm = XFS_ATTRSETM_LOG_RES(mp);
> +	mp->m_reservations.tr_attrsetrt = XFS_ATTRSETRT_LOG_RES(mp) * nblks;
>   }
>
>   static int

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
