Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DB5C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 10:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C8D520787
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 10:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896375AbgDOKOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 06:14:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2896365AbgDOKNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 06:13:43 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FA3MdL093223
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2020 06:13:38 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30du1b8y8g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2020 06:13:38 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 15 Apr 2020 11:13:01 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Apr 2020 11:13:00 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03FADYl255443568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 10:13:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B5D942042;
        Wed, 15 Apr 2020 10:13:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79A044204B;
        Wed, 15 Apr 2020 10:13:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.79.180.162])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Apr 2020 10:13:33 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 11/20] xfs: Add helper function xfs_attr_node_shrink
Date:   Wed, 15 Apr 2020 15:46:38 +0530
Organization: IBM
In-Reply-To: <20200403221229.4995-12-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com> <20200403221229.4995-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20041510-4275-0000-0000-000003C03CCF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041510-4276-0000-0000-000038D5B33B
Message-Id: <2127078.fSUztT9pNN@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_01:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=7
 impostorscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday, April 4, 2020 3:42 AM Allison Collins wrote: 
> This patch adds a new helper function xfs_attr_node_shrink used to
> shrink an attr name into an inode if it is small enough.  This helps to
> modularize the greater calling function xfs_attr_node_removename.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 42 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index db5a99c..27a9bb5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1103,6 +1103,45 @@ xfs_attr_node_addname(
>  }
>  
>  /*
> + * Shrink an attribute from leaf to shortform
> + */
> +STATIC int
> +xfs_attr_node_shrink(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state     *state)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	int			error, forkoff;
> +	struct xfs_buf		*bp;
> +
> +	/*
> +	 * Have to get rid of the copy of this dabuf in the state.
> +	 */
> +	ASSERT(state->path.active == 1);
> +	ASSERT(state->path.blk[0].bp);
> +	state->path.blk[0].bp = NULL;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> +	if (error)
> +		return error;
> +
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff) {
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +		if (error)
> +			return error;
> +
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +	} else
> +		xfs_trans_brelse(args->trans, bp);
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1115,8 +1154,7 @@ xfs_attr_node_removename(
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1197,31 +1235,10 @@ xfs_attr_node_removename(
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		/*
> -		 * Have to get rid of the copy of this dabuf in the state.
> -		 */
> -		ASSERT(state->path.active == 1);
> -		ASSERT(state->path.blk[0].bp);
> -		state->path.blk[0].bp = NULL;
> -
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -		if (error)
> -			goto out;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error = xfs_attr_node_shrink(args, state);

If a non-zero error value is returned by the above statement, the following
statement i.e. "error = 0" will overwrite it.
Apart from that everything else looks fine.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

>  
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
> -		} else
> -			xfs_trans_brelse(args->trans, bp);
> -	}
>  	error = 0;
> -
>  out:
>  	if (state)
>  		xfs_da_state_free(state);
> 


-- 
chandan



