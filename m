Return-Path: <SRS0=rRn/=BB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F9AC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CBF620714
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jul 2020 00:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x6hRc1+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgGVAFn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 20:05:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44188 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGVAFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 20:05:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNaABg041528
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CGRseomCc7OFRj/QCdqPoJGUuqTx6GgGTgpB69s3tOI=;
 b=x6hRc1+fd/yJeCP4STc0Mf1KbKh0Zjb4vmCjSMSeE7S9khCuRjdlvGnXTPkXtCdHjnGX
 xtl0s+hxt8L/LNoOIG6wTFuMYIJ21o4HnZPykKtD6/1A2pUO0L1c0DprVuZJeyr7jPvy
 1CYdrQkRgcEFI7/ssDBauUajoWDMewyAe6fks8azefX9gGU8ByhwGV0RysmO5mh+xNuB
 7pcBaUmggoWQ62b3efL1HL8ezXvjtUvKBsays+xrtNo9VPoeUNKrQzw8R687/2M7CZaz
 b277cYmMG5YnecPYl7UfFSoLbijc9OHOLzsf2siTihng2qQVNCBLXlLuesV26ErPKl+c Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32bs1mg5h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:36:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNY1kF178376
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:34:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32e9dhsega-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:34:51 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06LNYpvi016895
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:34:51 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 23:34:50 +0000
Date:   Tue, 21 Jul 2020 16:34:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 13/25] xfs: Remove unneeded xfs_trans_roll_inode calls
Message-ID: <20200721233449.GI3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-14-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:15:54PM -0700, Allison Collins wrote:
> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
> needed. If they are the last operations executed in these functions, and
> no further changes are made, then higher level routines will roll or
> commit the transactions.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks decent,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 61 ++++++------------------------------------------
>  1 file changed, 7 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4eff875..1a78023 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -693,34 +693,15 @@ xfs_attr_leaf_addname(
>  		/*
>  		 * If the result is small enough, shrink it all into the inode.
>  		 */
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
>  			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				return error;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				return error;
> -		}
> -
> -		/*
> -		 * Commit the remove and start the next trans in series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -
>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
>  		error = xfs_attr3_leaf_clearflag(args);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  	}
>  	return error;
>  }
> @@ -780,15 +761,11 @@ xfs_attr_leaf_removename(
>  	/*
>  	 * If the result is small enough, shrink it all into the inode.
>  	 */
> -	if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		return xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -	}
> +
>  	return 0;
>  }
>  
> @@ -1070,18 +1047,8 @@ xfs_attr_node_addname(
>  			error = xfs_da3_join(state);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  		}
>  
> -		/*
> -		 * Commit and start the next trans in the chain.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			goto out;
> -
>  	} else if (args->rmtblkno > 0) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -1089,14 +1056,6 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  		if (error)
>  			goto out;
> -
> -		 /*
> -		  * Commit the flag value change and start the next trans in
> -		  * series.
> -		  */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
>  	}
>  	retval = error = 0;
>  
> @@ -1135,16 +1094,10 @@ xfs_attr_node_shrink(
>  	if (forkoff) {
>  		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>  		/* bp is gone due to xfs_da_shrink_inode */
> -		if (error)
> -			return error;
> -
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
>  	} else
>  		xfs_trans_brelse(args->trans, bp);
>  
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
