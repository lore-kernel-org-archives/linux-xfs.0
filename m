Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 115BD7F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 02:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94C90AC004
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:52:00 -0700 (PDT)
Received: from mail-ia0-f169.google.com (mail-ia0-f169.google.com
	[209.85.210.169]) by cuda.sgi.com with ESMTP id
	Ar2xMOKPrIO4YLAf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 00:51:58 -0700 (PDT)
Received: by mail-ia0-f169.google.com with SMTP id k38so4650637iah.0
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:51:58 -0700 (PDT)
Message-ID: <5195E18D.50905@gmail.com>
Date: Fri, 17 May 2013 03:51:41 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 7/8] xfs: Add xfs_log_rlimit.[c|h]
References: <5195C279.3060502@oracle.com>
In-Reply-To: <5195C279.3060502@oracle.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

How do I get this to build?  With gcc-4.8.0, the kernel build ends like 
this:

   LINK    vmlinux
   LD      vmlinux.o
   MODPOST vmlinux.o
   GEN     .version
   CHK     include/generated/compile.h
   UPD     include/generated/compile.h
   CC      init/version.o
   LD      init/built-in.o
fs/built-in.o: In function `xfs_log_validate_logspace':
/usr/src/kernel-git/linux/fs/xfs/xfs_log_rlimit.c:130: undefined 
reference to `__udivdi3'
make: *** [vmlinux] Error 1

The fs/xfs section of the kernel did build without errors, though.

Thanks!

Michael

On 05/17/2013 01:39 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
>
> Add source files for xfs_log_rlimit.[c|h].
> The new source would be used for the log space validation.
>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>   fs/xfs/Makefile         |    3 +-
>   fs/xfs/xfs_log_rlimit.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_log_rlimit.h |   25 ++++++++
>   fs/xfs/xfs_mount.h      |    3 +
>   4 files changed, 178 insertions(+), 1 deletion(-)
>   create mode 100644 fs/xfs/xfs_log_rlimit.c
>   create mode 100644 fs/xfs/xfs_log_rlimit.h
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 6313b69..7e7a49d 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -75,7 +75,8 @@ xfs-y				+= xfs_alloc.o \
>   				   xfs_log_recover.o \
>   				   xfs_mount.o \
>   				   xfs_symlink.o \
> -				   xfs_trans.o
> +				   xfs_trans.o \
> +				   xfs_log_rlimit.o
>
>   # low-level transaction/log code
>   xfs-y				+= xfs_log.o \
> diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
> new file mode 100644
> index 0000000..3e84d46
> --- /dev/null
> +++ b/fs/xfs/xfs_log_rlimit.c
> @@ -0,0 +1,148 @@
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
> +#include "xfs_sb.h"
> +#include "xfs_mount.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_inode.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr_leaf.h"
> +
> +void
> +xfs_log_adjust_max_attrsetm_res(
> +	struct xfs_mount	*mp)
> +{
> +	int			size;
> +	int			nblks;
> +	int			res;
> +
> +	/*
> +	 * Calculate the maximum length in bytes that would be required
> +	 * for a local attribute value as large attributes out of line
> +	 * are not logged.
> +	 */
> +	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
> +	       MAXNAMELEN - 1;
> +	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	nblks += XFS_B_TO_FSB(mp, size);
> +	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +
> +	res = m_tresp(mp)->tr_attrsetm.tr_logres +
> +	      m_tresp(mp)->tr_attrsetrt.tr_logres * nblks;
> +	mp->m_reservations.tr_attrsetm.tr_logres = res;
> +}
> +
> +/*
> + * Iterate over the log space reservation table to figure out and return
> + * the maximum one in terms of the pre-calculated values which were done
> + * at mount time.
> + */
> +void
> +xfs_log_get_max_trans_res(
> +	struct xfs_mount		*mp,
> +	struct xfs_trans_res		*max_tresp)
> +{
> +	struct xfs_trans_reservations	*mtresp = m_tresp(mp);
> +	struct xfs_trans_res		tres_items[XFS_TRANS_RES_NUM];
> +	struct xfs_trans_res		*tresp;
> +	int				i, logspace  = 0;
> +
> +	xfs_log_adjust_max_attrsetm_res(mp);
> +
> +	memcpy(tres_items, mtresp, sizeof(*mtresp));
> +	for (i = 0; i < ARRAY_SIZE(tres_items); i++) {
> +		struct xfs_trans_res	*p = &tres_items[i];
> +		int			tmp = p->tr_logcount > 1 ?
> +					      p->tr_logres * p->tr_logcount :
> +					      p->tr_logres;
> +		if (logspace < tmp) {
> +			logspace = tmp;
> +			tresp = p;
> +		}
> +	}
> +
> +	*max_tresp = *tresp;
> +}
> +
> +/*
> + * Verify if the configured log space is sufficient or not for the specified
> + * log stripe unit.
> + */
> +void
> +xfs_log_validate_logspace(
> +	struct xfs_mount	*mp)
> +{
> +	struct xlog		*log = mp->m_log;
> +	struct xfs_trans_res	tres;
> +	int			maxlres;
> +	int			minlblks = 0, lsunit = 0;
> +
> +	xfs_log_get_max_trans_res(mp, &tres);
> +
> +	maxlres = xfs_log_calc_unit_res(mp, tres.tr_logres);
> +	maxlres = tres.tr_logcount > 1 ? maxlres * tres.tr_logcount : maxlres;
> +
> +	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> +	    log->l_mp->m_sb.sb_logsunit > 1)
> +		lsunit = BTOBB(log->l_mp->m_sb.sb_logsunit);
> +
> +	/*
> +	 * Two factors should be taken into account for calculating the minimum
> +	 * log space.
> +	 * 1) The fundamental limitation is that no single transaction can be
> +	 *    larger than half size of the log.
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
> +	minlblks = lsunit ? (roundup(BTOBB(maxlres), lsunit) + 2 * lsunit) * 2 :
> +			    BTOBB(maxlres) * 2;
> +
> +	if (log->l_logBBsize < minlblks) {
> +		xfs_crit(mp,
> +		"Log size %d blocks too small, minimu size is %d blocks",
> +			 log->l_logBBsize, minlblks);
> +	}
> +	if (log->l_logBBsize > XFS_MAX_LOG_BLOCKS) {
> +		xfs_crit(mp,
> +		"Log size %d blocks too large, maximum size is %lld blocks",
> +			 log->l_logBBsize, XFS_MAX_LOG_BLOCKS);
> +	}
> +	if (log->l_logsize > XFS_MAX_LOG_BYTES) {
> +		xfs_crit(mp,
> +		"log size %lld bytes too large, maximum size is %lld bytes",
> +			 (long long)(log->l_logsize), XFS_MAX_LOG_BYTES);
> +	}
> +}
> diff --git a/fs/xfs/xfs_log_rlimit.h b/fs/xfs/xfs_log_rlimit.h
> new file mode 100644
> index 0000000..93d8a0e
> --- /dev/null
> +++ b/fs/xfs/xfs_log_rlimit.h
> @@ -0,0 +1,25 @@
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
> +#ifndef	__XFS_LOG_RLIMIT_H__
> +#define __XFS_LOG_RLIMIT_H__
> +
> +void xfs_log_adjust_max_attrsetm_res(struct xfs_mount *);
> +void xfs_log_get_max_trans_res(struct xfs_mount *, struct xfs_trans_res *);
> +void xfs_log_validate_logspace(struct xfs_mount *);
> +
> +#endif	/* __XFS_LOG_PRIV_H__ */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 27ae8a9..2b469a5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -62,6 +62,9 @@ typedef struct xfs_trans_reservations {
>   	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
>   } xfs_trans_reservations_t;
>
> +#define XFS_TRANS_RES_NUM (sizeof(struct xfs_trans_reservations) / \
> +			   sizeof(struct xfs_trans_res))
> +
>   #ifndef __KERNEL__
>
>   #define xfs_daddr_to_agno(mp,d) \
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
