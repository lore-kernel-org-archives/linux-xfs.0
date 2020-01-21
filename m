Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83B0C2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F42224125
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S6H2vmL+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgAUXbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:31:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAUXbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:31:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNSbTm022580
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=g9Uvc0px9rk9bugzsV/3b5DfBzvDWRCRBWykLRS3gko=;
 b=S6H2vmL+XyUIGPv0t4UeOv2O8I3/KxCeP4Hjb5uHgesz/a4S+o313Cgw5wmCM9hww6XI
 7uFCEVidVFXLm9oyGvbh1poDAMF6lNg1mGGuvHSbtpJLn3JBgODAJhCFF9qk0cQscOQ7
 SNM/TcbC7q12vNXIl2E47RfsRClrPPS6ijIlvxTs9R0dnOjk7RO4we/nNmyzZd9Z8mHs
 hLkH4U6aZmoxq/9K0XQc7oKnElEfvAV75e8WR2sUMsKsEOpAfMpIRbTcFPtkpC9RgAzk
 NSTW3++HA9cldKjTxpBAPLUwqTuJkHUCjkjAhX/XV1dlG3Hc0pUrHI4V9YIqWxbe035v eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xksyq8cm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:31:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LNSTrU047560
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:31:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xnsa9nm5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:31:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LNVnij002896
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:31:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:31:48 -0800
Date:   Tue, 21 Jan 2020 15:31:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 14/16] xfs: Simplify xfs_attr_set_args
Message-ID: <20200121233147.GN8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-15-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:33PM -0700, Allison Collins wrote:
> Delayed attribute mechanics make frequent use of goto statements.  We
> can use this to further simplify xfs_attr_set_args.  In this patch we
> introduce one of the gotos now to help pre-simplify the routine.  This
> will help make proceeding patches in this area easier to read.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 71 +++++++++++++++++++++++++-----------------------
>  1 file changed, 37 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 453ea59..90e0b2d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -264,47 +264,50 @@ xfs_attr_set_args(
>  	int			error, error2 = 0;
>  
>  	/*
> -	 * If the attribute list is non-existent or a shortform list,
> -	 * upgrade it to a single-leaf-block attribute list.
> +	 * If the attribute list is non-existent or a shortform list, proceed to
> +	 * upgrade it to a single-leaf-block attribute list.  Otherwise jump
> +	 * straight to leaf handling

We don't jump to "upgrade it to a single leaf block attr list" quite
that soon.

"If the attribute list is already in leaf format, jump straight to leaf
handling.  Otherwise, try to add the attribute to the shortform list; if
there's no room then convert the list to leaf format and try again." ?

>  	 */
> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	if (!(dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>  	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> +	     dp->i_d.di_anextents == 0)))

Also... maybe this should just be a separate predicate?

static inline bool
xfs_attr_is_leaf_format(
	struct xfs_inode	*dp)
{
	return dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
		dp->i_d.di_anextents > 0;
}


if (xfs_attr_is_leaf_format(dp))
	goto add_leaf;

> +		goto sf_to_leaf;
>  
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
>  
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> -			return error;
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	if (error)
> +		return error;
>  
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf
> -		 * buffer and run into problems with the write verifier.
> -		 * Once we're done rolling the transaction we can release
> -		 * the hold and add the attr to the leaf.
> -		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> -			return error;
> -		}
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf
> +	 * buffer and run into problems with the write verifier.
> +	 * Once we're done rolling the transaction we can release
> +	 * the hold and add the attr to the leaf.
> +	 */
> +	xfs_trans_bhold(args->trans, leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, leaf_bp);
> +	if (error) {
> +		xfs_trans_brelse(args->trans, leaf_bp);
> +		return error;
>  	}
>  
> +sf_to_leaf:

The attr list already has to be in list format by the time it gets here,
which means that the label name is misleading.  How about "add_leaf" ?

--D

>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
>  		if (error != -ENOSPC)
> -- 
> 2.7.4
> 
