Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56390C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1A120787
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgEAKh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 06:37:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728508AbgEAKh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 06:37:58 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041AX16j118218;
        Fri, 1 May 2020 06:37:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30r81xp1ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 06:37:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 041AYvBb030976;
        Fri, 1 May 2020 10:37:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu74jhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 May 2020 10:37:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 041Abn5u63242250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 May 2020 10:37:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 700C74C04A;
        Fri,  1 May 2020 10:37:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 773544C040;
        Fri,  1 May 2020 10:37:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.72.180])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 May 2020 10:37:48 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/21] xfs: refactor log recovery item sorting into a generic dispatch structure
Date:   Fri, 01 May 2020 16:10:51 +0530
Message-ID: <1615698.eEcKq2KqFK@localhost.localdomain>
Organization: IBM
In-Reply-To: <158820766135.467894.13993542565087629835.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia> <158820766135.467894.13993542565087629835.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_03:2020-04-30,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010078
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, April 30, 2020 6:17 AM Darrick J. Wong wrote: 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic dispatch structure to delegate recovery of different
> log item types into various code modules.  This will enable us to move
> code specific to a particular log item type out of xfs_log_recover.c and
> into the log item source.
> 
> The first operation we virtualize is the log item sorting.

The item sorting is logically the same as before applying the patch. Hence,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile                 |    2 +
>  fs/xfs/libxfs/xfs_log_recover.h |   41 ++++++++++++++
>  fs/xfs/xfs_bmap_item.c          |    7 ++
>  fs/xfs/xfs_buf_item.c           |    1 
>  fs/xfs/xfs_buf_item_recover.c   |   37 +++++++++++++
>  fs/xfs/xfs_dquot_item.c         |    8 +++
>  fs/xfs/xfs_extfree_item.c       |    7 ++
>  fs/xfs/xfs_icreate_item.c       |   13 ++++
>  fs/xfs/xfs_inode_item_recover.c |   25 ++++++++
>  fs/xfs/xfs_log_recover.c        |  115 ++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_refcount_item.c      |    7 ++
>  fs/xfs/xfs_rmap_item.c          |    7 ++
>  12 files changed, 231 insertions(+), 39 deletions(-)
>  create mode 100644 fs/xfs/xfs_buf_item_recover.c
>  create mode 100644 fs/xfs/xfs_inode_item_recover.c
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index ee375b67ac71..5e52c2dc6078 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -120,9 +120,11 @@ xfs-y				+= xfs_log.o \
>  				   xfs_log_cil.o \
>  				   xfs_bmap_item.o \
>  				   xfs_buf_item.o \
> +				   xfs_buf_item_recover.o \
>  				   xfs_extfree_item.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
> +				   xfs_inode_item_recover.o \
>  				   xfs_refcount_item.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 3bf671637a91..38ae9c371edb 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -6,6 +6,45 @@
>  #ifndef	__XFS_LOG_RECOVER_H__
>  #define __XFS_LOG_RECOVER_H__
>  
> +/*
> + * Each log item type (XFS_LI_*) gets its own xlog_recover_item_type to
> + * define how recovery should work for that type of log item.
> + */
> +struct xlog_recover_item;
> +
> +/* Sorting hat for log items as they're read in. */
> +enum xlog_recover_reorder {
> +	XLOG_REORDER_BUFFER_LIST,
> +	XLOG_REORDER_ITEM_LIST,
> +	XLOG_REORDER_INODE_BUFFER_LIST,
> +	XLOG_REORDER_CANCEL_LIST,
> +};
> +
> +struct xlog_recover_item_type {
> +	/*
> +	 * Help sort recovered log items into the order required to replay them
> +	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
> +	 * not have to supply a function here.  See the comment preceding
> +	 * xlog_recover_reorder_trans for more details about what the return
> +	 * values mean.
> +	 */
> +	enum xlog_recover_reorder (*reorder_fn)(struct xlog_recover_item *item);
> +};
> +
> +extern const struct xlog_recover_item_type xlog_icreate_item_type;
> +extern const struct xlog_recover_item_type xlog_buf_item_type;
> +extern const struct xlog_recover_item_type xlog_inode_item_type;
> +extern const struct xlog_recover_item_type xlog_dquot_item_type;
> +extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
> +extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
> +extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
> +extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
> +extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
> +extern const struct xlog_recover_item_type xlog_refcount_done_item_type;
> +
>  /*
>   * Macros, structures, prototypes for internal log manager use.
>   */
> @@ -24,10 +63,10 @@
>   */
>  typedef struct xlog_recover_item {
>  	struct list_head	ri_list;
> -	int			ri_type;
>  	int			ri_cnt;	/* count of regions found */
>  	int			ri_total;	/* total regions */
>  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> +	const struct xlog_recover_item_type *ri_type;
>  } xlog_recover_item_t;
>  
>  struct xlog_recover {
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ee6f4229cebc..a2824013e2cb 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
> @@ -563,3 +564,9 @@ xfs_bui_recover(
>  	}
>  	return error;
>  }
> +
> +const struct xlog_recover_item_type xlog_bmap_intent_item_type = {
> +};
> +
> +const struct xlog_recover_item_type xlog_bmap_done_item_type = {
> +};
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1545657c3ca0..a416fc35e444 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -17,7 +17,6 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  
> -
>  kmem_zone_t	*xfs_buf_item_zone;
>  
>  static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> new file mode 100644
> index 000000000000..07ddf58209c3
> --- /dev/null
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_trace.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +STATIC enum xlog_recover_reorder
> +xlog_buf_reorder_fn(
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> +
> +	if (buf_f->blf_flags & XFS_BLF_CANCEL)
> +		return XLOG_REORDER_CANCEL_LIST;
> +	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> +		return XLOG_REORDER_INODE_BUFFER_LIST;
> +	return XLOG_REORDER_BUFFER_LIST;
> +}
> +
> +const struct xlog_recover_item_type xlog_buf_item_type = {
> +	.reorder_fn		= xlog_buf_reorder_fn,
> +};
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index baad1748d0d1..3bd5b6c7e235 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -17,6 +17,8 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_qm.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
>  
>  static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
>  {
> @@ -383,3 +385,9 @@ xfs_qm_qoff_logitem_init(
>  	qf->qql_flags = flags;
>  	return qf;
>  }
> +
> +const struct xlog_recover_item_type xlog_dquot_item_type = {
> +};
> +
> +const struct xlog_recover_item_type xlog_quotaoff_item_type = {
> +};
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 6ea847f6e298..c53e5f46ee26 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_efi_zone;
>  kmem_zone_t	*xfs_efd_zone;
> @@ -652,3 +653,9 @@ xfs_efi_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
> +};
> +
> +const struct xlog_recover_item_type xlog_extfree_done_item_type = {
> +};
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 490fee22b878..9f38a3c200a3 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -11,6 +11,8 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_icreate_item.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
>  
> @@ -107,3 +109,14 @@ xfs_icreate_log(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
>  }
> +
> +static enum xlog_recover_reorder
> +xlog_icreate_reorder(
> +		struct xlog_recover_item *item)
> +{
> +	return XLOG_REORDER_BUFFER_LIST;
> +}
> +
> +const struct xlog_recover_item_type xlog_icreate_item_type = {
> +	.reorder_fn		= xlog_icreate_reorder,
> +};
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> new file mode 100644
> index 000000000000..478f0a5c08ab
> --- /dev/null
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
> +#include "xfs_inode_item.h"
> +#include "xfs_trace.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_log.h"
> +#include "xfs_error.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +const struct xlog_recover_item_type xlog_inode_item_type = {
> +};
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index db47dfc0cada..8ab107680883 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1786,6 +1786,57 @@ xlog_clear_stale_blocks(
>   ******************************************************************************
>   */
>  
> +static int
> +xlog_set_item_type(
> +	struct xlog_recover_item		*item)
> +{
> +	switch (ITEM_TYPE(item)) {
> +	case XFS_LI_ICREATE:
> +		item->ri_type = &xlog_icreate_item_type;
> +		return 0;
> +	case XFS_LI_BUF:
> +		item->ri_type = &xlog_buf_item_type;
> +		return 0;
> +	case XFS_LI_EFI:
> +		item->ri_type = &xlog_extfree_intent_item_type;
> +		return 0;
> +	case XFS_LI_EFD:
> +		item->ri_type = &xlog_extfree_done_item_type;
> +		return 0;
> +	case XFS_LI_RUI:
> +		item->ri_type = &xlog_rmap_intent_item_type;
> +		return 0;
> +	case XFS_LI_RUD:
> +		item->ri_type = &xlog_rmap_done_item_type;
> +		return 0;
> +	case XFS_LI_CUI:
> +		item->ri_type = &xlog_refcount_intent_item_type;
> +		return 0;
> +	case XFS_LI_CUD:
> +		item->ri_type = &xlog_refcount_done_item_type;
> +		return 0;
> +	case XFS_LI_BUI:
> +		item->ri_type = &xlog_bmap_intent_item_type;
> +		return 0;
> +	case XFS_LI_BUD:
> +		item->ri_type = &xlog_bmap_done_item_type;
> +		return 0;
> +	case XFS_LI_INODE:
> +		item->ri_type = &xlog_inode_item_type;
> +		return 0;
> +#ifdef CONFIG_XFS_QUOTA
> +	case XFS_LI_DQUOT:
> +		item->ri_type = &xlog_dquot_item_type;
> +		return 0;
> +	case XFS_LI_QUOTAOFF:
> +		item->ri_type = &xlog_quotaoff_item_type;
> +		return 0;
> +#endif /* CONFIG_XFS_QUOTA */
> +	default:
> +		return -EFSCORRUPTED;
> +	}
> +}
> +
>  /*
>   * Sort the log items in the transaction.
>   *
> @@ -1851,41 +1902,10 @@ xlog_recover_reorder_trans(
>  
>  	list_splice_init(&trans->r_itemq, &sort_list);
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> -		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
> +		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
>  
> -		switch (ITEM_TYPE(item)) {
> -		case XFS_LI_ICREATE:
> -			list_move_tail(&item->ri_list, &buffer_list);
> -			break;
> -		case XFS_LI_BUF:
> -			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
> -				trace_xfs_log_recover_item_reorder_head(log,
> -							trans, item, pass);
> -				list_move(&item->ri_list, &cancel_list);
> -				break;
> -			}
> -			if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
> -				list_move(&item->ri_list, &inode_buffer_list);
> -				break;
> -			}
> -			list_move_tail(&item->ri_list, &buffer_list);
> -			break;
> -		case XFS_LI_INODE:
> -		case XFS_LI_DQUOT:
> -		case XFS_LI_QUOTAOFF:
> -		case XFS_LI_EFD:
> -		case XFS_LI_EFI:
> -		case XFS_LI_RUI:
> -		case XFS_LI_RUD:
> -		case XFS_LI_CUI:
> -		case XFS_LI_CUD:
> -		case XFS_LI_BUI:
> -		case XFS_LI_BUD:
> -			trace_xfs_log_recover_item_reorder_tail(log,
> -							trans, item, pass);
> -			list_move_tail(&item->ri_list, &item_list);
> -			break;
> -		default:
> +		error = xlog_set_item_type(item);
> +		if (error) {
>  			xfs_warn(log->l_mp,
>  				"%s: unrecognized type of log operation (%d)",
>  				__func__, ITEM_TYPE(item));
> @@ -1896,11 +1916,32 @@ xlog_recover_reorder_trans(
>  			 */
>  			if (!list_empty(&sort_list))
>  				list_splice_init(&sort_list, &trans->r_itemq);
> -			error = -EIO;
> -			goto out;
> +			break;
> +		}
> +
> +		if (item->ri_type->reorder_fn)
> +			fate = item->ri_type->reorder_fn(item);
> +
> +		switch (fate) {
> +		case XLOG_REORDER_BUFFER_LIST:
> +			list_move_tail(&item->ri_list, &buffer_list);
> +			break;
> +		case XLOG_REORDER_CANCEL_LIST:
> +			trace_xfs_log_recover_item_reorder_head(log,
> +					trans, item, pass);
> +			list_move(&item->ri_list, &cancel_list);
> +			break;
> +		case XLOG_REORDER_INODE_BUFFER_LIST:
> +			list_move(&item->ri_list, &inode_buffer_list);
> +			break;
> +		case XLOG_REORDER_ITEM_LIST:
> +			trace_xfs_log_recover_item_reorder_tail(log,
> +							trans, item, pass);
> +			list_move_tail(&item->ri_list, &item_list);
> +			break;
>  		}
>  	}
> -out:
> +
>  	ASSERT(list_empty(&sort_list));
>  	if (!list_empty(&buffer_list))
>  		list_splice(&buffer_list, &trans->r_itemq);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 8eeed73928cd..ddab09385bfb 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_refcount.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_cui_zone;
>  kmem_zone_t	*xfs_cud_zone;
> @@ -590,3 +591,9 @@ xfs_cui_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_type xlog_refcount_intent_item_type = {
> +};
> +
> +const struct xlog_recover_item_type xlog_refcount_done_item_type = {
> +};
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4911b68f95dd..bcad3db1f3a4 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_rui_zone;
>  kmem_zone_t	*xfs_rud_zone;
> @@ -606,3 +607,9 @@ xfs_rui_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_type xlog_rmap_intent_item_type = {
> +};
> +
> +const struct xlog_recover_item_type xlog_rmap_done_item_type = {
> +};
> 
> 


-- 
chandan



