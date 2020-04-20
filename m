Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB215C3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 05:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94B8C206F6
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 05:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgDTF17 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 01:27:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgDTF16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 01:27:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03K52dfE161141
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 01:27:58 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghmamw4e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2020 01:27:57 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 20 Apr 2020 06:27:14 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Apr 2020 06:27:12 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03K5RrGp18415742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 05:27:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1515542041;
        Mon, 20 Apr 2020 05:27:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521964203F;
        Mon, 20 Apr 2020 05:27:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.68.184])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 05:27:52 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
Date:   Mon, 20 Apr 2020 11:00:57 +0530
Organization: IBM
In-Reply-To: <20200403221229.4995-14-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com> <20200403221229.4995-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20042005-4275-0000-0000-000003C30E62
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042005-4276-0000-0000-000038D88EE2
Message-Id: <1908499.KaWVsrpO4C@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_01:2020-04-17,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
> In this patch, we hoist code from xfs_attr_set_args into two new helpers
> xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
> to simplify xfs_attr_set_args when we get into delayed attrs later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 72 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4225a94..ba26ffe 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
>  }
>  
>  /*
> + * Check to see if the attr should be upgraded from non-existent or shortform to
> + * single-leaf-block attribute list.
> + */
> +static inline bool
> +xfs_attr_is_shortform(
> +	struct xfs_inode    *ip)
> +{
> +	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> +	      (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> +	      ip->i_d.di_anextents == 0);
> +}
> +
> +/*
> + * Attempts to set an attr in shortform, or converts the tree to leaf form if

I think you meant to say "converts short form to leaf form".

The functional changes look logically correct,

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> + * there is not enough room.  If the attr is set, the transaction is committed
> + * and set to NULL.
> + */
> +STATIC int
> +xfs_attr_set_shortform(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		**leaf_bp)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, error2 = 0;
> +
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> +	 * another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> +	 * push cannot grab the half-baked leaf buffer and run into problems
> +	 * with the write verifier. Once we're done rolling the transaction we
> +	 * can release the hold and add the attr to the leaf.
> +	 */
> +	xfs_trans_bhold(args->trans, *leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, *leaf_bp);
> +	if (error) {
> +		xfs_trans_brelse(args->trans, *leaf_bp);
> +		return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Set the attribute specified in @args.
>   */
>  int
> @@ -212,48 +272,25 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error, error2 = 0;
> +	int			error = 0;
>  
>  	/*
> -	 * If the attribute list is non-existent or a shortform list,
> -	 * upgrade it to a single-leaf-block attribute list.
> +	 * If the attribute list is already in leaf format, jump straight to
> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
> +	 * list; if there's no room then convert the list to leaf format and try
> +	 * again.
>  	 */
> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> -	     dp->i_d.di_anextents == 0)) {
> -
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> -
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> -			return error;
> +	if (xfs_attr_is_shortform(dp)) {
>  
>  		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf
> -		 * buffer and run into problems with the write verifier.
> -		 * Once we're done rolling the transaction we can release
> -		 * the hold and add the attr to the leaf.
> +		 * If the attr was successfully set in shortform, the
> +		 * transaction is committed and set to NULL.  Otherwise, is it
> +		 * converted from shortform to leaf, and the transaction is
> +		 * retained.
>  		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> +		error = xfs_attr_set_shortform(args, &leaf_bp);
> +		if (error || !args->trans)
>  			return error;
> -		}
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> 


-- 
chandan



