Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C7DAC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DBD217F4
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 23:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rSxZggcQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgAUXDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:03:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgAUXDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:03:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmgbh033155
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2n50beqjdLQawuPuqowd/JH1ZD9T1PDg/LNCrUpZg/o=;
 b=rSxZggcQ1Z8SSaNNySey2pGwunzV+IwZHcAae2YGV9kJsvrRaDHEpZd7TcU561I4IiLj
 rs0tvk/Thfb1gV3pKfGHz2z97kQDtBF9wRXLyfsljdDoFFyEERJZByjttxE3nUXq3OJr
 0zlLmRpP1MIQg3zze8xSRP1sfeW8AxrT3TweeYUzW9iK4PQDz+ArRX91Yd1dbkEMXZLw
 m/h5nEP8jDULxLgTQJHgiTm594oYWVDf1hakMznq0pcIlJ8wZkydl0VHmt34K2v7xHF1
 RxIXJPCrSMnQ6n0aTc/FEf7/SH0qj98GgUQs06py8vI7Duu8FJ3dGGcqFJF6ZwZH30kT ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseugf45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:03:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmZdX034569
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:01:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xnsj5jrey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:01:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LN1qhG020821
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:01:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:01:52 -0800
Date:   Tue, 21 Jan 2020 15:01:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 06/16] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20200121230151.GI8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-7-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:25PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add. Because new
> delayed attribute routines cannot roll transactions, we carve off the
> parts of xfs_attr_leaf_addname that we can use, and move the commit into
> the calling function.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 83 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b0ec25b..9ed7e94 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -305,10 +305,30 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> -		error = xfs_attr_node_addname(args);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * Commit that transaction so that the node_addname()
> +		 * call can manage its own transactions.
> +		 */
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the current trans (including the inode) and
> +		 * start a new one.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +
> +	}
> +
> +	error = xfs_attr_node_addname(args);
>  	return error;
>  }
>  
> @@ -607,21 +627,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */

These functions are complicated enough as they are now, please make sure
they all have comments laying out the expected input metadata states and
what output states result from them.

I /think/ this function takes an inode whose attr data is in leaf
format, and tries to add a new entry.  If that succeeds then we exit
with dirty inode and transaction.  If ENOSPC then we convert the attr
data to node format and exit w/ dirty inode + transaction, presuming
that the caller will try again with xfs_attr_node_addname?

>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> +	int			retval, error;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -667,31 +678,35 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format.
> +		 * Unless an error occurs, retain the -ENOSPC retval
>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	}
> +	return retval;
> +}
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Fob the whole rest of the problem off on the Btree code.
> -		 */
> -		error = xfs_attr_node_addname(args);
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(struct xfs_da_args	*args)

STATIC int
xfs_attr_leaf_addname(
	struct xfs_da_args	*args)
{

Please fix the inconsistent style things as you touch them.

--D

> +{
> +	int			error, forkoff;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_leaf_addname(args);
> +
> +	error = xfs_attr_leaf_try_add(args, bp);
> +	if (error)
>  		return error;
> -	}
>  
>  	/*
>  	 * Commit the transaction that added the attr name so that
> -- 
> 2.7.4
> 
