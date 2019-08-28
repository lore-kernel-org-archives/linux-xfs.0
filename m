Return-Path: <SRS0=H+3G=WY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6549BC3A5A1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F6F22CED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Aug 2019 22:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FoktzlUo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfH1WDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:03:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfH1WDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 18:03:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SLwmEQ108958;
        Wed, 28 Aug 2019 22:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=T/XWcFEutJ+PGw77k2QmI0bY2BZU+1Nt8JkfJQlO+jw=;
 b=FoktzlUoloNNr9ukJBxtztHMHUsmpLMsYSZQz/sWH456+OkDOKs+f3FdBMWqFZTfjnfN
 ILz1whd2P9pLvY5JxahSCRq46lEX1ZxqtSGtKIHUzgTIRv6r6ygW5bEqL/gUM5OvXaHK
 pPQtFxiJLIXv/kmFhGFzLW8L2u/lcVpgR/4JXNfh8ci0WtfV+/kslMsZjIbaiNt7Kf+C
 uMCAMvFGYXU5gLumlIcz2kQ5vtGS1zNp8fDR5QbviHhn11ZcsyVptRMQPNy5ZBMitNGq
 bqVpysS2wK9bjbpG0j7tYHUJ8umrRGAjySuc9LqsxtfhgH5K9lddBybNYZWd1aCHrneE 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2up1yqr133-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:03:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SM3T5m020735;
        Wed, 28 Aug 2019 22:03:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2undw7xh4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:03:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7SM39rO016328;
        Wed, 28 Aug 2019 22:03:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:03:09 -0700
Date:   Wed, 28 Aug 2019 15:03:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make attr lookup returns consistent
Message-ID: <20190828220308.GK1037350@magnolia>
References: <20190828042350.6062-1-david@fromorbit.com>
 <20190828042350.6062-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828042350.6062-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280211
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 28, 2019 at 02:23:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Shortform, leaf and remote value attr value retrieval return
> different values for success. This makes it more complex to handle
> actual errors xfs_attr_get() as some errors mean success and some
> mean failure. Make the return values consistent for success and
> failure consistent for all attribute formats.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 57 +++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_attr_leaf.c   | 15 ++++++---
>  fs/xfs/libxfs/xfs_attr_remote.c |  2 ++
>  fs/xfs/scrub/attr.c             |  2 --
>  4 files changed, 49 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d48fcf11cc35..776343c4f22b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -97,7 +97,10 @@ xfs_inode_hasattr(
>   * Overall external interface routines.
>   *========================================================================*/
>  
> -/* Retrieve an extended attribute and its value.  Must have ilock. */
> +/*
> + * Retrieve an extended attribute and its value.  Must have ilock.
> + * Returns 0 on successful retrieval, otherwise an error.
> + */
>  int
>  xfs_attr_get_ilocked(
>  	struct xfs_inode	*ip,
> @@ -147,7 +150,7 @@ xfs_attr_get(
>  	xfs_iunlock(ip, lock_mode);
>  
>  	*valuelenp = args.valuelen;
> -	return error == -EEXIST ? 0 : error;
> +	return error;
>  }
>  
>  /*
> @@ -768,6 +771,8 @@ xfs_attr_leaf_removename(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * Returns 0 on successful retrieval, otherwise an error.
>   */
>  STATIC int
>  xfs_attr_leaf_get(xfs_da_args_t *args)
> @@ -789,10 +794,15 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	}
>  	error = xfs_attr3_leaf_getvalue(bp, args);
>  	xfs_trans_brelse(args->trans, bp);
> -	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
> -		error = xfs_attr_rmtval_get(args);
> -	}
> -	return error;
> +	if (error)
> +		return error;
> +
> +	/* check if we have to retrieve a remote attribute to get the value */
> +	if (args->flags & ATTR_KERNOVAL)
> +		return 0;
> +	if (!args->rmtblkno)
> +		return 0;
> +	return xfs_attr_rmtval_get(args);
>  }
>  
>  /*========================================================================
> @@ -1268,11 +1278,13 @@ xfs_attr_refillstate(xfs_da_state_t *state)
>  }
>  
>  /*
> - * Look up a filename in a node attribute list.
> + * Retreive the attribute data from a node attribute list.

"Retrieve"

>   *
>   * This routine gets called for any attribute fork that has more than one
>   * block, ie: both true Btree attr lists and for single-leaf-blocks with
>   * "remote" values taking up more blocks.
> + *
> + * Returns 0 on successful retrieval, otherwise an error.
>   */
>  STATIC int
>  xfs_attr_node_get(xfs_da_args_t *args)
> @@ -1289,29 +1301,32 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	state->mp = args->dp->i_mount;
>  
>  	/*
> -	 * Search to see if name exists, and get back a pointer to it.
> +	  Search to see if name exists, and get back a pointer to it.

Comment damage here?

Meh whatever will just fix it.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	 */
>  	error = xfs_da3_node_lookup_int(state, &retval);
>  	if (error) {
>  		retval = error;
> -	} else if (retval == -EEXIST) {
> -		blk = &state->path.blk[ state->path.active-1 ];
> -		ASSERT(blk->bp != NULL);
> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -
> -		/*
> -		 * Get the value, local or "remote"
> -		 */
> -		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> -		if (!retval && (args->rmtblkno > 0)
> -		    && !(args->flags & ATTR_KERNOVAL)) {
> -			retval = xfs_attr_rmtval_get(args);
> -		}
> +		goto out_release;
>  	}
> +	if (retval != -EEXIST)
> +		goto out_release;
> +
> +	/*
> +	 * Get the value, local or "remote"
> +	 */
> +	blk = &state->path.blk[state->path.active - 1];
> +	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> +	if (retval)
> +		goto out_release;
> +	if (args->flags & ATTR_KERNOVAL)
> +		goto out_release;
> +	if (args->rmtblkno > 0)
> +		retval = xfs_attr_rmtval_get(args);
>  
>  	/*
>  	 * If not in a transaction, we have to release all the buffers.
>  	 */
> +out_release:
>  	for (i = 0; i < state->path.active; i++) {
>  		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>  		state->path.blk[i].bp = NULL;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 70eb941d02e4..d056767b5c53 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -720,9 +720,12 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
>  }
>  
>  /*
> - * Look up a name in a shortform attribute list structure.
> + * Retreive the attribute value and length.
> + *
> + * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> + * Unlike a lookup, we only return an error if the attribute does not
> + * exist or we can't retrieve the value.
>   */
> -/*ARGSUSED*/
>  int
>  xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  {
> @@ -743,7 +746,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  			continue;
>  		if (args->flags & ATTR_KERNOVAL) {
>  			args->valuelen = sfe->valuelen;
> -			return -EEXIST;
> +			return 0;
>  		}
>  		if (args->valuelen < sfe->valuelen) {
>  			args->valuelen = sfe->valuelen;
> @@ -752,7 +755,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>  		args->valuelen = sfe->valuelen;
>  		memcpy(args->value, &sfe->nameval[args->namelen],
>  						    args->valuelen);
> -		return -EEXIST;
> +		return 0;
>  	}
>  	return -ENOATTR;
>  }
> @@ -2350,6 +2353,10 @@ xfs_attr3_leaf_lookup_int(
>  /*
>   * Get the value associated with an attribute name from a leaf attribute
>   * list structure.
> + *
> + * If ATTR_KERNOVAL is specified, only the length needs to be returned.
> + * Unlike a lookup, we only return an error if the attribute does not
> + * exist or we can't retrieve the value.
>   */
>  int
>  xfs_attr3_leaf_getvalue(
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4eb30d357045..3e39b7d40f25 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -358,6 +358,8 @@ xfs_attr_rmtval_copyin(
>  /*
>   * Read the value associated with an attribute from the out-of-line buffer
>   * that we stored it in.
> + *
> + * Returns 0 on successful retrieval, otherwise an error.
>   */
>  int
>  xfs_attr_rmtval_get(
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 1afc58bf71dd..e9248ad4f842 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -163,8 +163,6 @@ xchk_xattr_listent(
>  	args.valuelen = valuelen;
>  
>  	error = xfs_attr_get_ilocked(context->dp, &args);
> -	if (error == -EEXIST)
> -		error = 0;
>  	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
>  			&error))
>  		goto fail_xref;
> -- 
> 2.23.0.rc1
> 
