Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14682C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 23:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDC62077D
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 23:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5bGi9Hm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731481AbgGUXjO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 19:39:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39946 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGUXjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 19:39:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNXEqL096923
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xNq6v4T5GokuNXxZKG2JTH/1HsIS7WQ6fsSxOx4OLys=;
 b=m5bGi9HmQMSNYiUfPjbW0hCSPHDQla7R6kPIcduSh4OvcfYgwoCWzAjhGBqbI8rzFLp4
 BHSGPuLWbKnaNXqmDkE8lE2VCVxMl8r+w8vb7UUQMaJiBiUADwBk/EEkb+a6lZz4HQq1
 0GRVqxBehvPA03rgsq7mBu60mlHdIc/TliO3KuJ+feUPqetI+lAYxcORGEPG7fnZw0qZ
 XODJK9kOEZ+gNfxNKOuAiqBtizOr18c8beie1PAivya0I/sqI5QArb5BCl+mdeUApgrR
 iWDyaDeUQqdJqxakQFJqYR0J8fHtsfACd5NlzjrmXKXwIHjNrbWxlnSVfQzH2on5GEEX 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32brgrg7dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:39:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNc602116741
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:39:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32e9us8m5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:39:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06LNdBEh024458
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:39:11 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 23:39:11 +0000
Date:   Tue, 21 Jul 2020 16:39:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 20/25] xfs: Simplify xfs_attr_leaf_addname
Message-ID: <20200721233910.GK3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-21-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-21-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:16:01PM -0700, Allison Collins wrote:
> Invert the rename logic in xfs_attr_leaf_addname to simplify the
> delayed attr logic later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++-----------------------
>  1 file changed, 55 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f993af5..ca1e851 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -695,68 +695,71 @@ xfs_attr_leaf_addname(
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
> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		/*
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> +		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			return error;
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
>  
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> -		 * a "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> +		return error;
> +	}
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
>  
> -			error = xfs_attr_rmtval_remove(args);
> -			if (error)
> -				return error;
> -		}
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		return error;
> +	/*
> +	 * Commit the flag value change and start the next trans in series.
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		return error;
>  
> -		/*
> -		 * Read in the block containing the "old" attr, then
> -		 * remove the "old" attr from that block (neat, huh!)
> -		 */
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -					   &bp);
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
> +
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
>  
> -		xfs_attr3_leaf_remove(bp, args);
> -
> -		/*
> -		 * If the result is small enough, shrink it all into the inode.
> -		 */
> -		forkoff = xfs_attr_shortform_allfit(bp, dp);
> -		if (forkoff)
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			return error;
>  	}
> +
> +	/*
> +	 * Read in the block containing the "old" attr, then remove the "old"
> +	 * attr from that block (neat, huh!)
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +				   &bp);
> +	if (error)
> +		return error;
> +
> +	xfs_attr3_leaf_remove(bp, args);
> +
> +	/*
> +	 * If the result is small enough, shrink it all into the inode.
> +	 */
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
