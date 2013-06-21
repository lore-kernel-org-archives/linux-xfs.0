Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B41E7F37
	for <xfs@oss.sgi.com>; Fri, 21 Jun 2013 01:11:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5DF1C304043
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 23:11:00 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	1ABTUfj1x3BtGq8V (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Jun 2013 23:10:55 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id n1so4320626qcw.16
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 23:10:55 -0700 (PDT)
Message-ID: <51C3EE6A.5030909@gmail.com>
Date: Fri, 21 Jun 2013 02:10:50 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 59/60] xfs: Add xfs_log_rlimit.c
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-60-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-60-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I'm still looking for Jeff's input on this particular patch.  However, I 
did want to report success on xfs/297.  The Pentium 4 test PC was left to 
rest for a few hours, then it was started again.  The latest xfsprogs 
patchset was applied to xfsprogs.

512b blocks, internal logdev, no CRC, projid32bit=1, tracers on: PASS
512b blocks, internal logdev, no CRC, projid32bit=0, tracers on: PASS
512b blocks, internal logdev, no CRC, projid32bit=0, tracers off: PASS
1k blocks, internal logdev, no CRC, tracers off: PASS
...rebooted to avoid RT throttling slowing things down...
1k blocks, internal logdev, CRC, tracers off: PASS
2k blocks, internal logdev, CRC, tracers off: PASS
2k blocks, external logdev, CRC, rtdev, tracers off: PASS
4k blocks, default mkfs.xfs: PASS

Something was fixed between the new xfsprogs and the PC's chance to reset 
100%.  What?  I really don't know!  But there is success.

Great job, Dave and Jeff!

Michael

On 06/19/2013 12:51 AM, Dave Chinner wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Add source files for xfs_log_rlimit.c The new file is used for log
> size calculations and validation shared with userspace.
> 
> [dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
> tr_attrsetm reservation, just calculates the maximum. ]
> 
> [dchinner: rework loop in xfs_log_get_max_trans_res() ]
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile         |    1 +
>  fs/xfs/xfs_log_format.h |    8 ++-
>  fs/xfs/xfs_log_rlimit.c |  145 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 153 insertions(+), 1 deletion(-)
>  create mode 100644 fs/xfs/xfs_log_rlimit.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index c5c38a9..22691eb 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -81,6 +81,7 @@ xfs-y				+= xfs_alloc.o \
>  				   xfs_inode_fork.o \
>  				   xfs_inode_buf.o \
>  				   xfs_log_recover.o \
> +				   xfs_log_rlimit.o \
>  				   xfs_sb.o \
>  				   xfs_symlink_remote.o \
>  				   xfs_trans_resv.o
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index 37a7ff9..8f46b6a 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
> + * Copyright (c) 2013 Jie Liu.
>   * All Rights Reserved.
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -19,6 +20,7 @@
>  #define __XFS_LOG_FORMAT_H__
>  
>  struct xfs_mount;
> +struct xfs_trans_res;
>  
>  typedef __uint32_t xlog_tid_t;
>  
> @@ -41,6 +43,9 @@ typedef __uint32_t xlog_tid_t;
>  
>  #define XLOG_HEADER_SIZE	512
>  
> +/* Minimum number of transactions that must fit in the log (defined by mkfs) */
> +#define XFS_MIN_LOG_FACTOR	3
> +
>  #define XLOG_REC_SHIFT(log) \
>  	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
>  	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
> @@ -125,7 +130,6 @@ typedef struct xlog_op_header {
>  	__u16	   oh_res2;	/* 32 bit align			:  2 b */
>  } xlog_op_header_t;
>  
> -
>  /* valid values for h_fmt */
>  #define XLOG_FMT_UNKNOWN  0
>  #define XLOG_FMT_LINUX_LE 1
> @@ -178,5 +182,7 @@ typedef struct xfs_log_iovec {
>  } xfs_log_iovec_t;
>  
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
> +int	xfs_log_calc_minimum_size(struct xfs_mount *);
> +
>  
>  #endif /* __XFS_LOG_FORMAT_H__ */
> diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
> new file mode 100644
> index 0000000..e3f4b4e
> --- /dev/null
> +++ b/fs/xfs/xfs_log_rlimit.c
> @@ -0,0 +1,145 @@
> +/*
> + * Copyright (c) 2013 Jie Liu.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_ag.h"
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr_leaf.h"
> +
> +/*
> + * Calculate the maximum length in bytes that would be required for a local
> + * attribute value as large attributes out of line are not logged.
> + */
> +STATIC int
> +xfs_log_calc_max_attrsetm_res(
> +	struct xfs_mount	*mp)
> +{
> +	int			size;
> +	int			nblks;
> +
> +	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
> +	       MAXNAMELEN - 1;
> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	nblks += XFS_B_TO_FSB(mp, size);
> +	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +
> +	return  M_RES(mp)->tr_attrsetm.tr_logres +
> +		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> +}
> +
> +/*
> + * Iterate over the log space reservation table to figure out and return
> + * the maximum one in terms of the pre-calculated values which were done
> + * at mount time.
> + */
> +STATIC void
> +xfs_log_get_max_trans_res(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_res	*max_resp)
> +{
> +	struct xfs_trans_res	*resp;
> +	struct xfs_trans_res	*end_resp;
> +	int			log_space = 0;
> +	int			attr_space;
> +
> +	attr_space = xfs_log_calc_max_attrsetm_res(mp);
> +
> +	resp = (struct xfs_trans_res *)M_RES(mp);
> +	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
> +	for (; resp < end_resp; resp++) {
> +		int		tmp = resp->tr_logcount > 1 ?
> +				      resp->tr_logres * resp->tr_logcount :
> +				      resp->tr_logres;
> +		if (log_space < tmp) {
> +			log_space = tmp;
> +			*max_resp = *resp;		/* struct copy */
> +		}
> +	}
> +
> +	if (attr_space > log_space) {
> +		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
> +		max_resp->tr_logres = attr_space;
> +	}
> +}
> +
> +/*
> + * Calculate the minimum valid log size for the given superblock configuration.
> + * Used to calculate the minimum log size at mkfs time, and to determine if
> + * the log is large enough or not at mount time. Returns the minimum size in
> + * filesystem block size units.
> + */
> +int
> +xfs_log_calc_minimum_size(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_trans_res	tres = {0};
> +	int			max_logres;
> +	int			min_logblks = 0;
> +	int			lsunit = 0;
> +
> +	xfs_log_get_max_trans_res(mp, &tres);
> +
> +	max_logres = xfs_log_calc_unit_res(mp, tres.tr_logres);
> +	if (tres.tr_logcount > 1)
> +		max_logres *= tres.tr_logcount;
> +
> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		lsunit = BTOBB(mp->m_sb.sb_logsunit);
> +
> +	/*
> +	 * Two factors should be taken into account for calculating the minimum
> +	 * log space.
> +	 * 1) The fundamental limitation is that no single transaction can be
> +	 *    larger than half size of the log.
> +	 *
> +	 *    From mkfs.xfs, this is considered by the XFS_MIN_LOG_FACTOR
> +	 *    define, which is set to 3. That means we can definitely fit
> +	 *    maximally sized 2 transactions in the log. We'll use this same
> +	 *    value here.
> +	 *
> +	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
> +	 *    for the reservation because there are two log writes that can
> +	 *    require padding - the transaction data and the commit record which
> +	 *    are written separately and both can require padding to the LSU.
> +	 *    Consider that we can have an active CIL reservation holding 2*LSU,
> +	 *    but the CIL is not over a push threshold, in this case, if we
> +	 *    don't have enough log space for at one new transaction, which
> +	 *    includes another 2*LSU in the reservation, we will run into dead
> +	 *    loop situation in log space grant procedure. i.e.
> +	 *    xlog_grant_head_wait().
> +	 *
> +	 *    Hence the log size needs to be able to contain two maximally sized
> +	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
> +	 *
> +	 * Also, the log size should be a multiple of the log stripe unit, round
> +	 * it up to lsunit boundary if lsunit is specified.
> +	 */
> +	if (lsunit)
> +		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
> +	else
> +		min_logblks = BTOBB(max_logres);
> +	min_logblks *= XFS_MIN_LOG_FACTOR;
> +	return XFS_BB_TO_FSB(mp, min_logblks);
> +}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
