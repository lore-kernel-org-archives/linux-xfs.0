Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B94C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 23:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF7E2077D
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 23:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o7VJELoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgGUXlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 19:41:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGUXlH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 19:41:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNWSfO096459
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Wgh0iPF21ph0l6GWs8Gk17qdm1musuI0ZxQBOgJM14k=;
 b=o7VJELoAQzamq1sYr48kFtLcRsUWW3JsyJUzRK+BVc2cdQqFZVg6UaLz+M79zIFhSGHq
 wV0Isc+pMMwiYc//Pf46rzb/tszhxpQpHVNAbL9aa7KHGFq8lAuEJDvNzm0tT0Sqbpgn
 BQWW7gYmXioTBh3vEAtW8awslNgHDDcLDS5NTLCxHH7wLG2cMfgPvstcuxfgfd7MSWLZ
 Ug+TdVXD/yM44YLIqHzdsBbOoCm0xO6prPq/4eB/CGHSdvIkUB1+OhGU29qRlnDU1cI2
 dxFpFmxbLgGxldMgO3PRgGbjLHOt3atXnZbxtqJdhuB+z5PFd+Q9ud4wLZPg8AhpYB67 hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgrg7gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:41:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNc6s2116823
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:41:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32e9us8nq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:41:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06LNf4o0013354
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:41:04 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 16:41:04 -0700
Date:   Tue, 21 Jul 2020 16:41:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 21/25] xfs: Simplify xfs_attr_node_addname
Message-ID: <20200721234103.GL3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-22-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-22-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=2 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=2 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:16:02PM -0700, Allison Collins wrote:
> Invert the rename logic in xfs_attr_node_addname to simplify the
> delayed attr logic later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok, diff is dumb :(
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 125 +++++++++++++++++++++++------------------------
>  1 file changed, 61 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ca1e851..e618b09 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1030,80 +1030,77 @@ xfs_attr_node_addname(
>  			return error;
>  	}
>  
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the
> -	 * incomplete flags on the "new" and "old" attribute/value pairs
> -	 * so that one disappears and one appears atomically.  Then we
> -	 * must remove the "old" attribute/value pair.
> -	 */
> -	if (args->op_flags & XFS_DA_OP_RENAME) {
> -		/*
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			goto out;
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series
> +		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
> +		retval = error;
> +		goto out;
> +	}
>  
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> -		 * a "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		goto out;
> +	/*
> +	 * Commit the flag value change and start the next trans in series
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		goto out;
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
>  
> -			error = xfs_attr_rmtval_remove(args);
> -			if (error)
> -				return error;
> -		}
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
>  
> -		/*
> -		 * Re-find the "old" attribute entry after any split ops.
> -		 * The INCOMPLETE flag means that we will find the "old"
> -		 * attr, not the "new" one.
> -		 */
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> -		state = xfs_da_state_alloc();
> -		state->args = args;
> -		state->mp = mp;
> -		state->inleaf = 0;
> -		error = xfs_da3_node_lookup_int(state, &retval);
> +		error = xfs_attr_rmtval_remove(args);
>  		if (error)
> -			goto out;
> +			return error;
> +	}
>  
> -		/*
> -		 * Remove the name and update the hashvals in the tree.
> -		 */
> -		blk = &state->path.blk[ state->path.active-1 ];
> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -		error = xfs_attr3_leaf_remove(blk->bp, args);
> -		xfs_da3_fixhashpath(state, &state->path);
> +	/*
> +	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
> +	 * flag means that we will find the "old" attr, not the "new" one.
> +	 */
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = mp;
> +	state->inleaf = 0;
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error)
> +		goto out;
>  
> -		/*
> -		 * Check to see if the tree needs to be collapsed.
> -		 */
> -		if (retval && (state->path.active > 1)) {
> -			error = xfs_da3_join(state);
> -			if (error)
> -				goto out;
> -		}
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	error = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
>  
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 
