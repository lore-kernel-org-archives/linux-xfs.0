Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835A2C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB3F20768
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HLPlFHak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgF3STt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:19:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387890AbgF3STs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 14:19:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UII9ap081102;
        Tue, 30 Jun 2020 18:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=J2PgDM/shtRWOB77KeVrwiL+Phby/1fr8i6UR1Ea9t0=;
 b=HLPlFHakhnwu3nNTOIRLjwbFAriERFKaAXRncT9ldZ4puGApBs07Z4sG0rYOBcDQB1iQ
 Wg0O9s9SDBZavzk/UgJ0K5m+S78rFSyGvMqUotcHyliXfb8MskbuWTgrk9I1TTHrJxRB
 00RPHYdFE3ETZ1UM5MdS2MDUTI3KJ/4u1WX36MnDk67AEzAzj6cGUWcrYygTXgU2ZLSG
 UXrsWm1IZhwrFuivfqgSfldjTYJsoLJ/HMTGurpCPlGacij7NDRQ9+JPfgz8j12qddPh
 q4nCIiJ5LNVr9ReU3YF2EYZjUyLx8u8676fhlXNuMYKSODXEehCUSkUPQ+rYXAH71skm ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrn65jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 18:19:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UIIXWq060309;
        Tue, 30 Jun 2020 18:19:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvsu507-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 18:19:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UIJh6T017252;
        Tue, 30 Jun 2020 18:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 18:19:43 +0000
Date:   Tue, 30 Jun 2020 11:19:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: introduce inode unlink log item
Message-ID: <20200630181942.GP7606@magnolia>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=5 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Tracking dirty inodes via cluster buffers creates lock ordering
> issues with logging unlinked inode updates direct to the cluster
> buffer. The unlinked inode list is unordered, so we can lock cluster
> buffers in random orders and that causes deadlocks.
> 
> To solve this problem, we really want to dealy locking the cluster

"delay"

> buffers until the pre-commit phase where we can order the buffers
> correctly along with all the other inode cluster buffers that are
> locked by the transaction. However, to do this we need to be able to
> tell the transaction which inodes need to have there unlinked list

"their"

> updated and what it should be updated to.
> 
> We can delay the buffer update to the pre-commit phase based on the
> fact taht all unlinked inode list updates are serialised by the AGI

"that"

> buffer. It will be locked into the transaction before the list
> update starts, and will remain locked until the transaction commits.
> Hence we can lock and update the cluster buffers safely any time
> during the transaction and we are still safe from other racing
> unlinked list updates.
> 
> The iunlink log item currently only exists in memory. we need a log
> item to attach information to the transaction, but it's context

"its"

> is completely owned by the transaction. Hence it is never formatted
> or inserted into the CIL, nor is it seen by the journal, the AIL or
> log recovery.
> 
> This makes it a very simple log item, and the changes makes results
> in adding addition buffer log items to the transaction. Hence once
> the iunlink log item has run it's pre-commit operation, it can be

"its"

> dropped by the transaction and released.
> 
> The creation of this in-memory intent does not prevent us from
> extending it in future to the journal to replace buffer based
> logging of the unlinked list. Changing the format of the items we
> write to the on disk journal is beyond the scope of this patchset,
> hence we limit it to being in-memory only.

<nod> Looks pretty straightforward...

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/xfs_inode.c        |  70 +++----------------
>  fs/xfs/xfs_inode_item.c   |   3 +-
>  fs/xfs/xfs_iunlink_item.c | 141 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iunlink_item.h |  24 +++++++
>  fs/xfs/xfs_super.c        |  10 +++
>  6 files changed, 189 insertions(+), 60 deletions(-)
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
> index 1f1c8819330b..ab288424764c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -35,6 +35,7 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_iunlink_item.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> @@ -1945,56 +1946,6 @@ xfs_iunlink_lookup_next(
>  	return next_ip;
>  }
>  
> -/* Set an on-disk inode's next_unlinked pointer. */
> -STATIC void
> -xfs_iunlink_update_dinode(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_buf		*ibp,
> -	struct xfs_dinode	*dip,
> -	struct xfs_imap		*imap,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			offset;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
> -
> -	trace_xfs_iunlink_update_dinode(mp, agno, agino,
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = imap->im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	/* need to recalc the inode CRC if appropriate */
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -}
> -
> -/* Set an in-core inode's unlinked pointer and return the old value. */
> -static int
> -xfs_iunlink_update_inode(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> -	struct xfs_dinode	*dip;
> -	struct xfs_buf		*ibp;
> -	int			error;
> -
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
> -	if (error)
> -		return error;
> -
> -	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			ibp, dip, &ip->i_imap, ip->i_next_unlinked);
> -	return 0;
> -}
> -
>  /*
>   * Point the AGI unlinked bucket at an inode and log the results.  The caller
>   * is responsible for validating the old value.
> @@ -2051,7 +2002,6 @@ xfs_iunlink_insert_inode(
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> -	int			error;
>  
>  	/*
>  	 * Get the index into the agi hash table for the list this inode will
> @@ -2082,9 +2032,7 @@ xfs_iunlink_insert_inode(
>  		nip->i_prev_unlinked = agino;
>  
>  		/* update the on disk inode now */
> -		error = xfs_iunlink_update_inode(tp, ip);
> -		if (error)
> -			return error;
> +		xfs_iunlink_log(tp, ip);
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2140,9 +2088,7 @@ xfs_iunlink_remove_inode(
>  
>  		/* update the on disk inode now */
>  		pip->i_next_unlinked = next_agino;
> -		error = xfs_iunlink_update_inode(tp, pip);
> -		if (error)
> -			return error;
> +		xfs_iunlink_log(tp, pip);
>  	}
>  
>  	/* lookup the next inode and update to point at prev */
> @@ -2162,10 +2108,15 @@ xfs_iunlink_remove_inode(
>  		nip->i_prev_unlinked = ip->i_prev_unlinked;
>  	}
>  
> -	/* now clear prev/next from this inode and update on disk */
> +	/*
> +	 * Now clear prev/next from this inode and update on disk if we
> +	 * need to clear the on-disk link.
> +	 */
>  	ip->i_prev_unlinked = NULLAGINO;
>  	ip->i_next_unlinked = NULLAGINO;
> -	return xfs_iunlink_update_inode(tp, ip);
> +	if (next_agino != NULLAGINO)
> +		xfs_iunlink_log(tp, ip);
> +	return 0;
>  }
>  
>  /*
> @@ -2185,6 +2136,7 @@ xfs_iunlink(
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	int			error;
>  
> +	ASSERT(ip->i_next_unlinked == NULLAGINO);
>  	ASSERT(VFS_I(ip)->i_nlink == 0);
>  	ASSERT(VFS_I(ip)->i_mode != 0);
>  	trace_xfs_iunlink(ip);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0494b907c63d..bc1970c37edc 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -488,8 +488,9 @@ xfs_inode_item_push(
>  	ASSERT(iip->ili_item.li_buf);
>  
>  	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> -	    (ip->i_flags & XFS_ISTALE))
> +	    (ip->i_flags & XFS_ISTALE)) {
>  		return XFS_ITEM_PINNED;
> +	}
>  
>  	/* If the inode is already flush locked, we're already flushing. */
>  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> new file mode 100644
> index 000000000000..83f1dc81133b
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -0,0 +1,141 @@
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
> +
> +kmem_zone_t	*xfs_iunlink_zone;
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
> +	return IUL_ITEM(lip)->iu_ino;
> +}

Oh, I see, ->iop_sort is supposed to return a sorting key for each log
item so that we can reorder the iunlink items to take locks in the
correct order.

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
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, iup->iu_ino);
> +	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, iup->iu_ino);
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*bp;
> +	int			offset;
> +	int			error;
> +
> +	error = xfs_imap_to_bp(mp, tp, &iup->iu_imap, &dip, &bp, 0);
> +	if (error)
> +		goto out_remove;
> +
> +	trace_xfs_iunlink_update_dinode(mp, agno, agino,
> +			be32_to_cpu(dip->di_next_unlinked),
> +			iup->iu_next_unlinked);
> +
> +	/*
> +	 * Don't bother updating the unlinked field on stale buffers as
> +	 * it will never get to disk anyway.
> +	 */
> +	if (bp->b_flags & XBF_STALE)
> +		goto out_remove;
> +
> +	dip->di_next_unlinked = cpu_to_be32(iup->iu_next_unlinked);
> +	offset = iup->iu_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	/* need to recalc the inode CRC if appropriate */
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, bp);
> +	xfs_trans_log_buf(tp, bp, offset, offset + sizeof(xfs_agino_t) - 1);
> +
> +out_remove:
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
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.iop_release	= xfs_iunlink_item_release,
> +	.iop_sort	= xfs_iunlink_item_sort,
> +	.iop_precommit	= xfs_iunlink_item_precommit,
> +};
> +
> +

Hm, ok, I see how these pieces fit together. This looks like a clever
combination of the incore inode prev_unlinked field and log items, and I
agree that it's less messy than the backref hashtable.

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
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_iunlink_item	*iup;
> +
> +	iup = kmem_zone_zalloc(xfs_iunlink_zone, 0);
> +
> +	xfs_log_item_init(tp->t_mountp, &iup->iu_item, XFS_LI_IUNLINK,
> +			  &xfs_iunlink_item_ops);
> +
> +	iup->iu_ino = ip->i_ino;
> +	iup->iu_next_unlinked = ip->i_next_unlinked;
> +	iup->iu_imap = ip->i_imap;
> +
> +	xfs_trans_add_item(tp, &iup->iu_item);
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &iup->iu_item.li_flags);
> +}
> diff --git a/fs/xfs/xfs_iunlink_item.h b/fs/xfs/xfs_iunlink_item.h
> new file mode 100644
> index 000000000000..c9e58acf4ccf
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.h
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0

Nitpick: Insane SPDX rules say that this should be a C-style comment
because it's a header file (whereas C++ style comments are fine for C
source files because IDFGI.

--D

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
> +	struct xfs_imap		iu_imap;
> +	xfs_ino_t		iu_ino;
> +	xfs_agino_t		iu_next_unlinked;
> +};
> +
> +extern kmem_zone_t *xfs_iunlink_zone;
> +
> +void xfs_iunlink_log(struct xfs_trans *tp, struct xfs_inode *ip);
> +
> +#endif	/* XFS_IUNLINK_ITEM_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a5d9453cf51..a36dfb0e7e5b 100644
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
> @@ -1955,8 +1956,16 @@ xfs_init_zones(void)
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
> @@ -2003,6 +2012,7 @@ xfs_destroy_zones(void)
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
