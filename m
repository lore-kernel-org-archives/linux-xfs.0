Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67752C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42136206B8
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JwLwmjLP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgEDTFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:05:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46836 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgEDTFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 15:05:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044J0XYl072977
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=J9FS/Xt4fKv3v9tJQejmqUcNuRsz3MExw2D0x53qRCg=;
 b=JwLwmjLPO9mXNW/eM32LqE2gJePPxEAylchKax9/qaN0gfmeQb8+2myJGf9rIoz2YsVZ
 rl9Pj5XQZaFI8GmanIoVyLqop7tZ30bS9oOKV+jxBkvxu6YuSfe5ypwpG30G9GUXahRN
 dPEG4aq83EMrZiIk83ig5E9ZcvvBy/jby7JOg7YFX7Ney07GlfCJP7z1ypnBiJUTCptp
 skAgEIH8YMK/W2jvrpaEPSqakRtNzv9YGfUC3j0binfuTksNpN9EurLYBr2tJh0thjr3
 etLt9SitZI12RKUHWJlIxqXXu9amfVxvaXSwn6q+sOHr2MBeuiW1u0haVVVC8sSGb4X2 DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30s1gn0mjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:05:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044IvfCp033823
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:03:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30t1r2ywmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:03:22 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044J3LCS022083
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:03:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:03:21 -0700
Date:   Mon, 4 May 2020 12:03:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 19/24] xfs: Simplify xfs_attr_leaf_addname
Message-ID: <20200504190320.GF5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-20-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:11PM -0700, Allison Collins wrote:
> Quick patch to unnest the rename logic in the leaf code path.  This will
> help simplify delayed attr logic later.

This isn't really an unnesting, is it?  We're inverting the if logic and
flipping the subordinate blocks.

"Invert the rename logic in xfs_attr_leaf_addname to simplify the
delayed attr logic later."

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 108 +++++++++++++++++++++++------------------------
>  1 file changed, 53 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ab1c9fa..1810f90 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -694,73 +694,71 @@ xfs_attr_leaf_addname(
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
> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {

	if (!(args->op_flags & XFS_DA_OP_RENAME)) {

--D

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
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				return error;
> -		}
> -
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			return error;
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
