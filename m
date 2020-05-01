Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A864DC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A9320836
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 16:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i3S3r8Po"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgEAQyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 12:54:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgEAQyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 12:54:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041GrUwk107356;
        Fri, 1 May 2020 16:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qemgy9uUB459jv61tctpSa6AiUA8NaB/JChG/vv/3s0=;
 b=i3S3r8PodBNyOnClqOVOqb62URQATa7mG6cbkhbYx8uSq1aUWjwVdP3SwmJRh7TYk5Ss
 i/rLoG0+Mk7Ou2OqD4T3XSqC+4gelyvdCNDU/q8Mcf6c+bIbD4Il4HUF3EKx131jy3ZF
 l+vRe9GSFSRIehCRQrkPasg4Pkd8I5xbY9TNzPgfabVR44rORDDhADVPBd56EnfN4yeA
 iDXomwxmRrNIQ471m10GDmQ40S9ddgej93U1JtyrhJJl2twTLXkPZluZvjVZH3xRmYfL
 QZmbzYi1mbVhqFO0ez5j37Q3Rs/exVTZUmM3wxL8762oL+iFU3sXysnG5/YJ3krFuFEE Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30r7f5u3gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 16:54:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041GqJc5103109;
        Fri, 1 May 2020 16:54:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30rbr5mkbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 16:54:00 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 041GrwTK030538;
        Fri, 1 May 2020 16:53:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 09:53:58 -0700
Date:   Fri, 1 May 2020 09:53:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/21] xfs: refactor log recovery
Message-ID: <20200501165357.GU6742@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <20200501101539.GA21903@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501101539.GA21903@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 03:15:39AM -0700, Christoph Hellwig wrote:
> I've looked a bit over the total diff and finaly result and really like
> it.
> 
> A few comments from that without going into the individual patches:
> 
>  - I don't think the buffer cancellation table should remain in
>    xfs_log_recovery.c.  I can either move them into a new file
>    as part of resending my prep series, or you could move them into
>    xfs_buf_item_recover.c.  Let me know what you prefer.

I'll look into moving it as an addition to this series.

>  - Should the match callback also move into struct xfs_item_ops?  That
>    would also match iop_recover.

Hmm, good idea!

>  - Based on that we could also kill XFS_ITEM_TYPE_IS_INTENT by just
>    checking for iop_recover and/or iop_match.

Yep.

>  - Setting XFS_LI_RECOVERED could also move to common code, basically
>    set it whenever iop_recover returns.  Also we can remove the
>    XFS_LI_RECOVERED asserts in ->iop_recovery when the caller checks
>    it just before.

I've noticed two weird things about the xfs_*_recover functions:

1. We'll set LI_RECOVERED if the intent is corrupt or if the final
commit succeeds (or fails), but we won't set it for other error bailouts
during recovery (e.g. xfs_trans_alloc fails).

2. If the intent is corrupt, iop_recovery also release the intent item,
but we don't do that for any of the other error returns from the
->iop_recovery function.  AFAICT those items (including the one that
failed recovery) are still on the AIL list and get released when we call
cancel_intents, which means that iop_recovery should /not/ be releasing
the item, right?

>  - we are still having a few redundant ri_type checks.
>  - ri_type maybe should be ri_ops?

Yeah.

> 
> See this patch below for my take on cleaning up the recovery ops
> handling a bit:

Looks decent; I was moving towards putting the XFS_LI_ code into the the
xlog_recover_item_ops anyway.

--D

> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index ba172eb454c8f..f97946cf94f11 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -7,7 +7,7 @@
>  #define __XFS_LOG_RECOVER_H__
>  
>  /*
> - * Each log item type (XFS_LI_*) gets its own xlog_recover_item_type to
> + * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
>   * define how recovery should work for that type of log item.
>   */
>  struct xlog_recover_item;
> @@ -20,7 +20,9 @@ enum xlog_recover_reorder {
>  	XLOG_REORDER_CANCEL_LIST,
>  };
>  
> -struct xlog_recover_item_type {
> +struct xlog_recover_item_ops {
> +	uint16_t		item_type;
> +
>  	/*
>  	 * Help sort recovered log items into the order required to replay them
>  	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
> @@ -58,19 +60,19 @@ struct xlog_recover_item_type {
>  			       struct xlog_recover_item *item, xfs_lsn_t lsn);
>  };
>  
> -extern const struct xlog_recover_item_type xlog_icreate_item_type;
> -extern const struct xlog_recover_item_type xlog_buf_item_type;
> -extern const struct xlog_recover_item_type xlog_inode_item_type;
> -extern const struct xlog_recover_item_type xlog_dquot_item_type;
> -extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
> -extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
> -extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
> -extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
> -extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
> -extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
> -extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
> -extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
> -extern const struct xlog_recover_item_type xlog_refcount_done_item_type;
> +extern const struct xlog_recover_item_ops xlog_icreate_item_type;
> +extern const struct xlog_recover_item_ops xlog_buf_item_type;
> +extern const struct xlog_recover_item_ops xlog_inode_item_type;
> +extern const struct xlog_recover_item_ops xlog_dquot_item_type;
> +extern const struct xlog_recover_item_ops xlog_quotaoff_item_type;
> +extern const struct xlog_recover_item_ops xlog_bmap_intent_item_type;
> +extern const struct xlog_recover_item_ops xlog_bmap_done_item_type;
> +extern const struct xlog_recover_item_ops xlog_extfree_intent_item_type;
> +extern const struct xlog_recover_item_ops xlog_extfree_done_item_type;
> +extern const struct xlog_recover_item_ops xlog_rmap_intent_item_type;
> +extern const struct xlog_recover_item_ops xlog_rmap_done_item_type;
> +extern const struct xlog_recover_item_ops xlog_refcount_intent_item_type;
> +extern const struct xlog_recover_item_ops xlog_refcount_done_item_type;
>  
>  /*
>   * Macros, structures, prototypes for internal log manager use.
> @@ -93,7 +95,7 @@ typedef struct xlog_recover_item {
>  	int			ri_cnt;	/* count of regions found */
>  	int			ri_total;	/* total regions */
>  	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> -	const struct xlog_recover_item_type *ri_type;
> +	const struct xlog_recover_item_ops *ri_ops;
>  } xlog_recover_item_t;
>  
>  struct xlog_recover {
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 58f0904e4504d..952b4ce40433e 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -667,10 +667,12 @@ xlog_recover_bmap_done_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_bmap_intent_item_type = {
> +const struct xlog_recover_item_ops xlog_bmap_intent_item_type = {
> +	.item_type		= XFS_LI_BUI,
>  	.commit_pass2_fn	= xlog_recover_bmap_intent_commit_pass2,
>  };
>  
> -const struct xlog_recover_item_type xlog_bmap_done_item_type = {
> +const struct xlog_recover_item_ops xlog_bmap_done_item_type = {
> +	.item_type		= XFS_LI_BUD,
>  	.commit_pass2_fn	= xlog_recover_bmap_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index d324f810819df..954e0e96af5dc 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -857,7 +857,8 @@ xlog_recover_buffer_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_buf_item_type = {
> +const struct xlog_recover_item_ops xlog_buf_item_type = {
> +	.item_type		= XFS_LI_BUF,
>  	.reorder_fn		= xlog_buf_reorder_fn,
>  	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
>  	.commit_pass1_fn	= xlog_recover_buffer_commit_pass1,
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 83bd7ded9185f..6c6216bdc432c 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -527,7 +527,8 @@ xlog_recover_dquot_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_dquot_item_type = {
> +const struct xlog_recover_item_ops xlog_dquot_item_type = {
> +	.item_type		= XFS_LI_DQUOT,
>  	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
>  	.commit_pass2_fn	= xlog_recover_dquot_commit_pass2,
>  };
> @@ -559,6 +560,7 @@ xlog_recover_quotaoff_commit_pass1(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_quotaoff_item_type = {
> +const struct xlog_recover_item_ops xlog_quotaoff_item_type = {
> +	.item_type		= XFS_LI_QUOTAOFF,
>  	.commit_pass1_fn	= xlog_recover_quotaoff_commit_pass1,
>  };
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index d6f2c88570de1..5d1fb5e05b781 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -729,10 +729,12 @@ xlog_recover_extfree_done_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
> +const struct xlog_recover_item_ops xlog_extfree_intent_item_type = {
> +	.item_type		= XFS_LI_EFI,
>  	.commit_pass2_fn	= xlog_recover_extfree_intent_commit_pass2,
>  };
>  
> -const struct xlog_recover_item_type xlog_extfree_done_item_type = {
> +const struct xlog_recover_item_ops xlog_extfree_done_item_type = {
> +	.item_type		= XFS_LI_EFD,
>  	.commit_pass2_fn	= xlog_recover_extfree_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 602a8c91371fe..34805bdbc2e12 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -248,7 +248,8 @@ xlog_recover_do_icreate_commit_pass2(
>  				     length, be32_to_cpu(icl->icl_gen));
>  }
>  
> -const struct xlog_recover_item_type xlog_icreate_item_type = {
> +const struct xlog_recover_item_ops xlog_icreate_item_type = {
> +	.item_type		= XFS_LI_ICREATE,
>  	.reorder_fn		= xlog_icreate_reorder,
>  	.commit_pass2_fn	= xlog_recover_do_icreate_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 46fc8a4b9ac61..9dff80783fe12 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -393,7 +393,8 @@ xlog_recover_inode_commit_pass2(
>  	return error;
>  }
>  
> -const struct xlog_recover_item_type xlog_inode_item_type = {
> +const struct xlog_recover_item_ops xlog_inode_item_type = {
> +	.item_type		= XFS_LI_INODE,
>  	.ra_pass2_fn		= xlog_recover_inode_ra_pass2,
>  	.commit_pass2_fn	= xlog_recover_inode_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09dd514a34980..e3f13866deb08 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1828,55 +1828,35 @@ xlog_recover_insert_ail(
>   ******************************************************************************
>   */
>  
> -static int
> -xlog_set_item_type(
> -	struct xlog_recover_item		*item)
> -{
> -	switch (ITEM_TYPE(item)) {
> -	case XFS_LI_ICREATE:
> -		item->ri_type = &xlog_icreate_item_type;
> -		return 0;
> -	case XFS_LI_BUF:
> -		item->ri_type = &xlog_buf_item_type;
> -		return 0;
> -	case XFS_LI_EFI:
> -		item->ri_type = &xlog_extfree_intent_item_type;
> -		return 0;
> -	case XFS_LI_EFD:
> -		item->ri_type = &xlog_extfree_done_item_type;
> -		return 0;
> -	case XFS_LI_RUI:
> -		item->ri_type = &xlog_rmap_intent_item_type;
> -		return 0;
> -	case XFS_LI_RUD:
> -		item->ri_type = &xlog_rmap_done_item_type;
> -		return 0;
> -	case XFS_LI_CUI:
> -		item->ri_type = &xlog_refcount_intent_item_type;
> -		return 0;
> -	case XFS_LI_CUD:
> -		item->ri_type = &xlog_refcount_done_item_type;
> -		return 0;
> -	case XFS_LI_BUI:
> -		item->ri_type = &xlog_bmap_intent_item_type;
> -		return 0;
> -	case XFS_LI_BUD:
> -		item->ri_type = &xlog_bmap_done_item_type;
> -		return 0;
> -	case XFS_LI_INODE:
> -		item->ri_type = &xlog_inode_item_type;
> -		return 0;
> +static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
> +	&xlog_icreate_item_type,
> +	&xlog_buf_item_type,
> +	&xlog_extfree_intent_item_type,
> +	&xlog_extfree_done_item_type,
> +	&xlog_rmap_intent_item_type,
> +	&xlog_rmap_done_item_type,
> +	&xlog_refcount_intent_item_type,
> +	&xlog_refcount_done_item_type,
> +	&xlog_bmap_intent_item_type,
> +	&xlog_bmap_done_item_type,
> +	&xlog_inode_item_type,
>  #ifdef CONFIG_XFS_QUOTA
> -	case XFS_LI_DQUOT:
> -		item->ri_type = &xlog_dquot_item_type;
> -		return 0;
> -	case XFS_LI_QUOTAOFF:
> -		item->ri_type = &xlog_quotaoff_item_type;
> -		return 0;
> +	&xlog_dquot_item_type,
> +	&xlog_quotaoff_item_type,
>  #endif /* CONFIG_XFS_QUOTA */
> -	default:
> -		return -EFSCORRUPTED;
> -	}
> +};
> +
> +static const struct xlog_recover_item_ops *
> +xlog_find_item_ops(
> +	struct xlog_recover_item	*item)
> +{
> +	int				i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
> +		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
> +			return xlog_recover_item_ops[i];
> +
> +	return NULL;
>  }
>  
>  /*
> @@ -1946,8 +1926,8 @@ xlog_recover_reorder_trans(
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
>  		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
>  
> -		error = xlog_set_item_type(item);
> -		if (error) {
> +		item->ri_ops = xlog_find_item_ops(item);
> +		if (!item->ri_ops) {
>  			xfs_warn(log->l_mp,
>  				"%s: unrecognized type of log operation (%d)",
>  				__func__, ITEM_TYPE(item));
> @@ -1958,11 +1938,12 @@ xlog_recover_reorder_trans(
>  			 */
>  			if (!list_empty(&sort_list))
>  				list_splice_init(&sort_list, &trans->r_itemq);
> +			error = -EFSCORRUPTED;
>  			break;
>  		}
>  
> -		if (item->ri_type->reorder_fn)
> -			fate = item->ri_type->reorder_fn(item);
> +		if (item->ri_ops->reorder_fn)
> +			fate = item->ri_ops->reorder_fn(item);
>  
>  		switch (fate) {
>  		case XLOG_REORDER_BUFFER_LIST:
> @@ -2098,46 +2079,6 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> -STATIC int
> -xlog_recover_commit_pass1(
> -	struct xlog			*log,
> -	struct xlog_recover		*trans,
> -	struct xlog_recover_item	*item)
> -{
> -	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
> -
> -	if (!item->ri_type) {
> -		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> -			__func__, ITEM_TYPE(item));
> -		ASSERT(0);
> -		return -EFSCORRUPTED;
> -	}
> -	if (!item->ri_type->commit_pass1_fn)
> -		return 0;
> -	return item->ri_type->commit_pass1_fn(log, item);
> -}
> -
> -STATIC int
> -xlog_recover_commit_pass2(
> -	struct xlog			*log,
> -	struct xlog_recover		*trans,
> -	struct list_head		*buffer_list,
> -	struct xlog_recover_item	*item)
> -{
> -	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
> -
> -	if (!item->ri_type) {
> -		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> -			__func__, ITEM_TYPE(item));
> -		ASSERT(0);
> -		return -EFSCORRUPTED;
> -	}
> -	if (!item->ri_type->commit_pass2_fn)
> -		return 0;
> -	return item->ri_type->commit_pass2_fn(log, buffer_list, item,
> -			trans->r_lsn);
> -}
> -
>  STATIC int
>  xlog_recover_items_pass2(
>  	struct xlog                     *log,
> @@ -2146,16 +2087,18 @@ xlog_recover_items_pass2(
>  	struct list_head                *item_list)
>  {
>  	struct xlog_recover_item	*item;
> -	int				error = 0;
> +	int				error;
>  
>  	list_for_each_entry(item, item_list, ri_list) {
> -		error = xlog_recover_commit_pass2(log, trans,
> -					  buffer_list, item);
> +		if (!item->ri_ops->commit_pass2_fn)
> +			continue;
> +		error = item->ri_ops->commit_pass2_fn(log, buffer_list, item,
> +				trans->r_lsn);
>  		if (error)
>  			return error;
>  	}
>  
> -	return error;
> +	return 0;
>  }
>  
>  /*
> @@ -2187,13 +2130,16 @@ xlog_recover_commit_trans(
>  		return error;
>  
>  	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
> +		trace_xfs_log_recover_item_recover(log, trans, item, pass);
> +
>  		switch (pass) {
>  		case XLOG_RECOVER_PASS1:
> -			error = xlog_recover_commit_pass1(log, trans, item);
> +			if (item->ri_ops->commit_pass1_fn)
> +				error = item->ri_ops->commit_pass1_fn(log, item);
>  			break;
>  		case XLOG_RECOVER_PASS2:
> -			if (item->ri_type && item->ri_type->ra_pass2_fn)
> -				item->ri_type->ra_pass2_fn(log, item);
> +			if (item->ri_ops->ra_pass2_fn)
> +				item->ri_ops->ra_pass2_fn(log, item);
>  			list_move_tail(&item->ri_list, &ra_list);
>  			items_queued++;
>  			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 53a79dc618f76..5703d5fdf4eeb 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -690,10 +690,12 @@ xlog_recover_refcount_done_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_refcount_intent_item_type = {
> +const struct xlog_recover_item_ops xlog_refcount_intent_item_type = {
> +	.item_type		= XFS_LI_CUI,
>  	.commit_pass2_fn	= xlog_recover_refcount_intent_commit_pass2,
>  };
>  
> -const struct xlog_recover_item_type xlog_refcount_done_item_type = {
> +const struct xlog_recover_item_ops xlog_refcount_done_item_type = {
> +	.item_type		= XFS_LI_CUD,
>  	.commit_pass2_fn	= xlog_recover_refcount_done_commit_pass2,
>  };
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index cee5c61550321..12e035ff7bb2d 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -680,10 +680,12 @@ xlog_recover_rmap_done_commit_pass2(
>  	return 0;
>  }
>  
> -const struct xlog_recover_item_type xlog_rmap_intent_item_type = {
> +const struct xlog_recover_item_ops xlog_rmap_intent_item_type = {
> +	.item_type		= XFS_LI_RUI,
>  	.commit_pass2_fn	= xlog_recover_rmap_intent_commit_pass2,
>  };
>  
> -const struct xlog_recover_item_type xlog_rmap_done_item_type = {
> +const struct xlog_recover_item_ops xlog_rmap_done_item_type = {
> +	.item_type		= XFS_LI_RUD,
>  	.commit_pass2_fn	= xlog_recover_rmap_done_commit_pass2,
>  };
