Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BF6FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 20:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D577F2178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 20:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKU5i1St"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKHU7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 15:59:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHU7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 15:59:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8KsGTk180063
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 20:59:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gi/PQy/dRNEMDcNBw4UCPCY6AmUnnmpODWFJpnaug2c=;
 b=jKU5i1St/1yWEFcBWVoHmej1czMqgUmm3TMM7UxrCORkHQN21Mb7TQsJhOVWrlthZdwE
 4KB5MokXDdDIu+Qxm6++caVLmNC8yYbKhRqjZZq/rBBUuLDx6aREk4+4IYHRBuPx9EqB
 fm6DXuOSgabRajR1NRy/h7Cgng8Ri0m1dOMYU7kZVVB0hS4ONTfgr0ywj2Zcj58j39zb
 VfFkHDrL93lNpwhdYgV+NoJ8BwHFSRmsoz1Yq9ZaIYhBWeyMM+qQMldtgYomii3z/I9V
 1AHsOeXwa3aE8xJ2z8ZiHfswHcyLi8OCcPL9elqPMT1HJhUAq8JrcuFjsZpn0QxdIqL1 Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w1fptc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 20:59:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Kx4HA072805
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 20:59:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w5cxkcrqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 20:59:04 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8KvovP012493
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 20:57:50 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 12:57:49 -0800
Date:   Fri, 8 Nov 2019 12:57:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 08/17] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20191108205748.GZ6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-9-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:52PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add.
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_leaf_addname that we can use.  This will help
> to reduce repetitive code later when we introduce
> delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 84 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 51 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 212995f..dda2eba 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -305,10 +305,33 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> +		if (error == -ENOSPC) {
> +			/*
> +			 * Commit that transaction so that the node_addname()
> +			 * call can manage its own transactions.
> +			 */
> +			error = xfs_defer_finish(&args->trans);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Commit the current trans (including the inode) and
> +			 * start a new one.
> +			 */
> +			error = xfs_trans_roll_inode(&args->trans, dp);
> +			if (error)
> +				return error;
> +
> +			/*
> +			 * Fob the rest of the problem off on the Btree code.
> +			 */
> +			error = xfs_attr_node_addname(args);
> +		}
> +	} else {
>  		error = xfs_attr_node_addname(args);
> +	}
>  	return error;


>  }
>  
> @@ -601,21 +624,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(

(total stream of consciousness here...)

AFAICT the old _addname function's responsibilities were:

1 Try to add a new attr key entry to the leaf block, with INCOMPLETE set
  if it's a rename op or we need to set a remote value.
2 If there wasn't space in the leaf block, convert to node format, call
  the node version of this function, and exit.
3 Allocating blocks for the remote attr value and writing them, if
  applicable
4 If it's a rename operation, clearing the INCOMPLETE flag on the new
  entry; setting it on the old entry; and then removing the old entry.
5 Clearing the INCOMPLETE flag on the new entry when we're done writing
  a remote value (if applicable)

I think we arrive at this split so that we don't have a transaction roll
in the middle of the function, right?  And also to make the "convert to
node format and roll" bits go elsewhere?

The way I'm thinking about how to accomplish this is...

xfs_attr_leaf_addname should be renamed xfs_attr_leaf_setname, and then
hoist (1) into a separate function, move (2) into xfs_attr_set_args, and
hoist (4) into a separate function.

...ok, so let's test how closely my understanding fits the changes made
in this patch:

_try_add is basically (1).

Most of (2) happened, though the call to xfs_attr3_leaf_to_node ought to
go into the caller so that the conversion stays with the defer_finish
and roll.

(4) could still be done, maybe as a separate prep patch.

Hm, ok, I think I understand what this patch does.  The call site in
xfs_attr_set_args would be clearer (and less indenty) if it looked like:

	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
		error = xfs_attr_leaf_addname(args);
		if (error == 0 || error != -ENOSPC)
			return error;

		/* Promote the attribute list to node format. */
		error = xfs_attr3_leaf_to_node(args);
		if (error)
			return error;

		/*
		 * Commit that transaction so that the node_addname()
		 * call can manage its own transactions.
		 */
		error = xfs_defer_finish(&args->trans);
		if (error)
			return error;

		/*
		 * Commit the current trans (including the inode) and
		 * start a new one.
		 */
		error = xfs_trans_roll_inode(&args->trans, dp);
		if (error)
			return error;
	}

	return xfs_attr_node_addname(args);

But otherwise it looks decent, assuming I understood any of it. :)

--D

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
> @@ -661,31 +675,35 @@ xfs_attr_leaf_addname(
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
