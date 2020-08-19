Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBB6C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77C3207DE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zZvTR5yJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHSAfe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:35:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40022 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHSAfd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:35:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0XIEq148474;
        Wed, 19 Aug 2020 00:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fLC2Ear5q2+0BWMP7jUQYXnWDheJM/MqiB44wcdtp94=;
 b=zZvTR5yJWZf5fuxDu6pRe3s3G9JhlZ6FpINX5vMzsUs3cV9xPteMSXcEEDzKdI7H+X6r
 csBZu7lKK5LmpirnIvo2zQWRVY8UZKM9BVllDTqm2GFfujJAgJRc54CKaztWccbAY0Lr
 lKTt0b6WVKyeWhD25hykBQlp1yj//kSYYwgweZxwAyOl7iI/5gLzWD4kEJjZasEYgPmh
 O1CmyWre05CxOvi1gVMGXUJKCqtyEkC+7VsobsDSuhAmWR80cZKOVIyC6zG3R/r5oXyQ
 0OnbSEMBbkwmVJ523ITxV/pMTGOiYKQz0cUMmjNiaZuc2hxGlmqIlYP7Jho2JxhLoSBn og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r7xe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 00:35:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07J0SvF1119264;
        Wed, 19 Aug 2020 00:35:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsmxv81g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 00:35:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07J0ZSlQ030981;
        Wed, 19 Aug 2020 00:35:28 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 17:35:27 -0700
Date:   Tue, 18 Aug 2020 17:35:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs: add in-memory iunlink log item
Message-ID: <20200819003525.GZ6096@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-13-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=5 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008190002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have a clean operation to update the di_next_unlinked
> field of inode cluster buffers, we can easily defer this operation
> to transaction commit time so we can order the inode cluster buffer
> locking consistently.
> 
> TO do this, we introduce a new in-memory log item to track the
> unlinked list item modification that we are going to make. This
> follows the same observations as the in-memory double linked list
> used to track unlinked inodes in that the inodes on the list are
> pinned in memory and cannot go away, and hence we can simply
> reference them for the duration of the transaction without needing
> to take active references or pin them or look them up.
> 
> This allows us to pass the xfs_inode to the transaction commit code
> along with the modification to be made, and then order the logged
> modifications via the ->iop_sort and ->iop_precommit operations
> for the new log item type. As this is an in-memory log item, it
> doesn't have formatting, CIL or AIL operational hooks - it exists
> purely to run the inode unlink modifications and is then removed
> from the transaction item list and freed once the precommit
> operation has run.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me would sorta like it if Brian took another look at the patch that
adds the precommit hooks, log item sorting, and whatnot, but this part
at least looks fairly simple.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/xfs_inode.c        |  61 ++------------
>  fs/xfs/xfs_iunlink_item.c | 168 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iunlink_item.h |  25 ++++++
>  fs/xfs/xfs_super.c        |  10 +++
>  5 files changed, 209 insertions(+), 56 deletions(-)
>  create mode 100644 fs/xfs/xfs_iunlink_item.c
>  create mode 100644 fs/xfs/xfs_iunlink_item.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 04611a1068b4..febdf034ca94 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -105,6 +105,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
>  				   xfs_inode_item_recover.o \
> +				   xfs_iunlink_item.o \
>  				   xfs_refcount_item.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 82242d15b1d7..ce128ff12762 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -36,6 +36,7 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_iunlink_item.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> @@ -1972,51 +1973,6 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> -/*
> - * Look up the inode cluster buffer and log the on-disk unlinked inode change
> - * we need to make.
> - */
> -STATIC int
> -xfs_iunlink_log_inode(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		old_agino,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_dinode	*dip;
> -	struct xfs_buf		*ibp;
> -	int			offset;
> -	int			error;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> -
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> -	if (error)
> -		return error;
> -
> -	if (be32_to_cpu(dip->di_next_unlinked) != old_agino) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -					sizeof(*dip), __this_address);
> -		xfs_trans_brelse(tp, ibp);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	trace_xfs_iunlink_update_dinode(mp, agno,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = ip->i_imap.im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -	return 0;
> -}
> -
>  static int
>  xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> @@ -2028,7 +1984,6 @@ xfs_iunlink_insert_inode(
>  	xfs_agino_t		next_agino = NULLAGINO;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	int			error;
>  
>  	nip = list_first_entry_or_null(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink);
> @@ -2039,10 +1994,7 @@ xfs_iunlink_insert_inode(
>  		 * inode to the current head of the list.
>  		 */
>  		next_agino = XFS_INO_TO_AGINO(mp, nip->i_ino);
> -		error = xfs_iunlink_log_inode(tp, ip, agno, NULLAGINO,
> -						 next_agino);
> -		if (error)
> -			return error;
> +		xfs_iunlink_log(tp, ip, NULLAGINO, next_agino);
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2098,7 +2050,6 @@ xfs_iunlink_remove_inode(
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino = NULLAGINO;
> -	int			error;
>  
>  	/*
>  	 * Get the next agino in the list. If we are at the end of the list,
> @@ -2112,16 +2063,14 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/* Clear the on disk next unlinked pointer for this inode. */
> -	error = xfs_iunlink_log_inode(tp, ip, agno, next_agino, NULLAGINO);
> -	if (error)
> -		return error;
> -
> +	xfs_iunlink_log(tp, ip, next_agino, NULLAGINO);
>  
>  	if (ip != list_first_entry(&agibp->b_pag->pag_ici_unlink_list,
>  					struct xfs_inode, i_unlink)) {
>  		struct xfs_inode *pip = list_prev_entry(ip, i_unlink);
>  
> -		return xfs_iunlink_log_inode(tp, pip, agno, agino, next_agino);
> +		xfs_iunlink_log(tp, pip, agino, next_agino);
> +		return 0;
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> new file mode 100644
> index 000000000000..2ee05f98aa97
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -0,0 +1,168 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020, Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_iunlink_item.h"
> +#include "xfs_trace.h"
> +#include "xfs_error.h"
> +
> +struct kmem_cache	*xfs_iunlink_zone;
> +
> +static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_iunlink_item, iu_item);
> +}
> +
> +static void
> +xfs_iunlink_item_release(
> +	struct xfs_log_item	*lip)
> +{
> +	kmem_cache_free(xfs_iunlink_zone, IUL_ITEM(lip));
> +}
> +
> +
> +static uint64_t
> +xfs_iunlink_item_sort(
> +	struct xfs_log_item	*lip)
> +{
> +	return IUL_ITEM(lip)->iu_ip->i_ino;
> +}
> +
> +/*
> + * Look up the inode cluster buffer and log the on-disk unlinked inode change
> + * we need to make.
> + */
> +static int
> +xfs_iunlink_log_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_agino_t		old_agino,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*ibp;
> +	int			offset;
> +	int			error;
> +
> +	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> +
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Don't bother updating the unlinked field on stale buffers as
> +	 * it will never get to disk anyway.
> +	 */
> +	if (ibp->b_flags & XBF_STALE)
> +		return 0;
> +
> +	if (be32_to_cpu(dip->di_next_unlinked) != old_agino) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +					sizeof(*dip), __this_address);
> +		xfs_trans_brelse(tp, ibp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	trace_xfs_iunlink_update_dinode(mp, agno,
> +			XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			be32_to_cpu(dip->di_next_unlinked), next_agino);
> +
> +	dip->di_next_unlinked = cpu_to_be32(next_agino);
> +	offset = ip->i_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> +	return 0;
> +}
> +
> +/*
> + * On precommit, we grab the inode cluster buffer for the inode number
> + * we were passed, then update the next unlinked field for that inode in
> + * the buffer and log the buffer. This ensures that the inode cluster buffer
> + * was logged in the correct order w.r.t. other inode cluster buffers.
> + *
> + * Note: if the inode cluster buffer is marked stale, this transaction is
> + * actually freeing the inode cluster. In that case, do not relog the buffer
> + * as this removes the stale state from it. That then causes the post-commit
> + * processing that is dependent on the cluster buffer being stale to go wrong
> + * and we'll leave stale inodes in the AIL that cannot be removed, hanging the
> + * log.
> + */
> +static int
> +xfs_iunlink_item_precommit(
> +	struct xfs_trans	*tp,
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> +	int			error;
> +
> +	error = xfs_iunlink_log_inode(tp, iup->iu_ip, iup->iu_old_agino,
> +					iup->iu_next_agino);
> +
> +	/*
> +	 * This log item only exists to perform this action. We now remove
> +	 * it from the transaction and free it as it should never reach the
> +	 * CIL.
> +	 */
> +	list_del(&lip->li_trans);
> +	xfs_iunlink_item_release(lip);
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_iunlink_item_ops = {
> +	.iop_release	= xfs_iunlink_item_release,
> +	.iop_sort	= xfs_iunlink_item_sort,
> +	.iop_precommit	= xfs_iunlink_item_precommit,
> +};
> +
> +
> +/*
> + * Initialize the inode log item for a newly allocated (in-core) inode.
> + *
> + * Inode extents can only reside within an AG. Hence specify the starting
> + * block for the inode chunk by offset within an AG as well as the
> + * length of the allocated extent.
> + *
> + * This joins the item to the transaction and marks it dirty so
> + * that we don't need a separate call to do this, nor does the
> + * caller need to know anything about the iunlink item.
> + */
> +void
> +xfs_iunlink_log(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_agino_t		old_agino,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_iunlink_item	*iup;
> +
> +	iup = kmem_cache_zalloc(xfs_iunlink_zone, GFP_KERNEL | __GFP_NOFAIL);
> +
> +	xfs_log_item_init(tp->t_mountp, &iup->iu_item, XFS_LI_IUNLINK,
> +			  &xfs_iunlink_item_ops);
> +
> +	iup->iu_ip = ip;
> +	iup->iu_next_agino = next_agino;
> +	iup->iu_old_agino = old_agino;
> +
> +	xfs_trans_add_item(tp, &iup->iu_item);
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &iup->iu_item.li_flags);
> +}
> +
> diff --git a/fs/xfs/xfs_iunlink_item.h b/fs/xfs/xfs_iunlink_item.h
> new file mode 100644
> index 000000000000..f2b95032cf6b
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.h
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020, Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef XFS_IUNLINK_ITEM_H
> +#define XFS_IUNLINK_ITEM_H	1
> +
> +struct xfs_trans;
> +struct xfs_inode;
> +
> +/* in memory log item structure */
> +struct xfs_iunlink_item {
> +	struct xfs_log_item	iu_item;
> +	struct xfs_inode	*iu_ip;
> +	xfs_agino_t		iu_next_agino;
> +	xfs_agino_t		iu_old_agino;
> +};
> +
> +extern kmem_zone_t *xfs_iunlink_zone;
> +
> +void xfs_iunlink_log(struct xfs_trans *tp, struct xfs_inode *ip,
> +			xfs_agino_t old_agino, xfs_agino_t next_agino);
> +
> +#endif	/* XFS_IUNLINK_ITEM_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 68ec8db12cc7..b8f66ccc7090 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -35,6 +35,7 @@
>  #include "xfs_refcount_item.h"
>  #include "xfs_bmap_item.h"
>  #include "xfs_reflink.h"
> +#include "xfs_iunlink_item.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -1969,8 +1970,16 @@ xfs_init_zones(void)
>  	if (!xfs_bui_zone)
>  		goto out_destroy_bud_zone;
>  
> +	xfs_iunlink_zone = kmem_cache_create("xfs_iul_item",
> +					     sizeof(struct xfs_iunlink_item),
> +					     0, 0, NULL);
> +	if (!xfs_iunlink_zone)
> +		goto out_destroy_bui_zone;
> +
>  	return 0;
>  
> + out_destroy_bui_zone:
> +	kmem_cache_destroy(xfs_bui_zone);
>   out_destroy_bud_zone:
>  	kmem_cache_destroy(xfs_bud_zone);
>   out_destroy_cui_zone:
> @@ -2017,6 +2026,7 @@ xfs_destroy_zones(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_cache_destroy(xfs_iunlink_zone);
>  	kmem_cache_destroy(xfs_bui_zone);
>  	kmem_cache_destroy(xfs_bud_zone);
>  	kmem_cache_destroy(xfs_cui_zone);
> -- 
> 2.26.2.761.g0e0b3e54be
> 
