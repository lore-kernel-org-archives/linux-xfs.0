Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B149FC388F7
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BA120731
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 20:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D+P2AuvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJUP2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 15:15:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKJUP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 15:15:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAKA0qa175592
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:15:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sNuaZs4jeB2IiESlXSuaN8ZCP3LrdpaqS2W8qZ2MdY0=;
 b=D+P2AuvEVCdFiFGmtwJShydsElkYRQ3iiM0reXlT5AiYG5+XEd2sNhEQmgMXsWyD/zjD
 bL4iHIpwXnTk0EvVt3RX+rErpFEcEiPRPCEMlJYu2GYEr9rNG7LENiPveFSTLllzmrHg
 bIFN3+nlbHl6lll7nbi/vRv0mFUoTRytuFo0bIRjYrJC6Vpf3tP28K5ZdaxJ3wgXEr5e
 Bzq/4Q6pgFpY6vWPQwBtV69aLWqugxwFSgy2cSJBbC/3FL+bRJ1N42Vvh6Go/2moNMIV
 HZOtz4mPNYKNUlXUuyy/3j3SzxeOuUXHQRsZG1DL9w75/oEEP1i6/RQRabC6FwPg9+2O 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkwn5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:15:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAKBDFc068330
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:15:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34p55p37q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:15:26 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAKFP2Q030780
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 20:15:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 12:15:24 -0800
Date:   Tue, 10 Nov 2020 12:15:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 06/10] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20201110201523.GF9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023063435.7510-7-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100137
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:34:31PM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> These routines to set up and start a new deferred attribute operations.
> These functions are meant to be called by any routine needing to
> initiate a deferred attribute operation as opposed to the existing
> inline operations. New helper function xfs_attr_item_init also added.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr.h |  2 ++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 760383c..7fe5554 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -25,6 +25,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_item.h"
> +#include "xfs_attr.h"
>  
>  /*
>   * xfs_attr.c
> @@ -643,6 +644,59 @@ xfs_attr_set(
>  	goto out_unlock;
>  }
>  
> +STATIC int
> +xfs_attr_item_init(
> +	struct xfs_da_args	*args,
> +	unsigned int		op_flags,	/* op flag (set or remove) */
> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
> +{
> +
> +	struct xfs_attr_item	*new;
> +
> +	new = kmem_alloc_large(sizeof(struct xfs_attr_item), KM_NOFS);

I don't think we need _large allocations for struct xfs_attr_item, right?

> +	memset(new, 0, sizeof(struct xfs_attr_item));

Use kmem_zalloc and you won't have to memset.  Better yet, zalloc will
get you memory that's been pre-zeroed in the background.

> +	new->xattri_op_flags = op_flags;
> +	new->xattri_dac.da_args = args;
> +
> +	*attr = new;
> +	return 0;
> +}
> +
> +/* Sets an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_set_deferred(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_attr_item	*new;
> +	int			error = 0;
> +
> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
> +	if (error)
> +		return error;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}

The changes in "xfs: enable delayed attributes" should be moved to this
patch so that these new functions immediately have callers.

(Also see the reply I sent to the next patch, which will avoid weird
regressions if someone's bisect lands in the middle of this series...)

--D

> +
> +/* Removes an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_remove_deferred(
> +	struct xfs_da_args	*args)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	int			error;
> +
> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
> +	if (error)
> +		return error;
> +
> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 5b4a1ca..8a08411 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -307,5 +307,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_da_args *args);
> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
