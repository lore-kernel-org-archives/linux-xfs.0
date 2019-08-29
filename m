Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3CFC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CDF233FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:07:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FRvmTRns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfH2VHo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:07:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfH2VHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:07:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TL4dX1150871;
        Thu, 29 Aug 2019 21:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ENk7YUR7+wVSNtoTb80SDpczWuwlaV8l8UoJGOGxcKQ=;
 b=FRvmTRns+IQBOKCOtIbDcB2r/hYjpRXuo5qrh9bNjrAOlZKQgdBMmTfPoyvw1ndmkDhr
 nGOwvS60H9ZGo2WVWbbNPRpURZ2x4/cdaigeuaFmuSUj+LCJWwj9ILl3Scw7SBL5WwQ8
 Vc6/B6lUHzEgIV7t1ZfdgAIJEFzWm4aObwLZ+uXiYgxfFfabgWfFCABeJ/T1y1jtsuBd
 S49w86+ivwH/w9+2oQIwXwuuTBC8j5tfbAtyfpqhUfr+ww8YZoPSQQbMTV3B9gRFddcG
 2PoXsHet5SHcEaoVn+eHmdjsep7fiGQaFZwDxNuZX7ZY3GhQj0MaGPmXlreCsZXrvAV+ EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uppa1g0pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:07:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TL46jX061055;
        Thu, 29 Aug 2019 21:07:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uphauahtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:07:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TL7efc007668;
        Thu, 29 Aug 2019 21:07:40 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:07:40 -0700
Date:   Thu, 29 Aug 2019 14:07:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: factor free block index lookup from
 xfs_dir2_node_addname_int()
Message-ID: <20190829210740.GK5354@magnolia>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-4-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290213
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Simplify the logic in xfs_dir2_node_addname_int() by factoring out
> the free block index lookup code that finds a block with enough free
> space for the entry to be added. The code that is moved gets a major
> cleanup at the same time, but there is no algorithm change here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 194 ++++++++++++++++++----------------
>  1 file changed, 102 insertions(+), 92 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index cc1f1c505a2b..93254f45a5f9 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1635,7 +1635,7 @@ xfs_dir2_node_add_datablk(
>  	int			error;
>  
>  	/* Not allowed to allocate, return failure. */
> -	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> +	if (args->total == 0)
>  		return -ENOSPC;
>  
>  	/* Allocate and initialize the new data block.  */
> @@ -1731,43 +1731,29 @@ xfs_dir2_node_add_datablk(
>  	return 0;
>  }
>  
> -/*
> - * Add the data entry for a node-format directory name addition.
> - * The leaf entry is added in xfs_dir2_leafn_add.
> - * We may enter with a freespace block that the lookup found.
> - */
> -static int					/* error */
> -xfs_dir2_node_addname_int(
> -	xfs_da_args_t		*args,		/* operation arguments */
> -	xfs_da_state_blk_t	*fblk)		/* optional freespace block */
> +static int
> +xfs_dir2_node_find_freeblk(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state_blk	*fblk,
> +	xfs_dir2_db_t		*dbnop,
> +	struct xfs_buf		**fbpp,
> +	int			*findexp,
> +	int			length)
>  {
> -	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> -	xfs_dir2_db_t		dbno;		/* data block number */
> -	struct xfs_buf		*dbp;		/* data block buffer */
> -	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
> -	xfs_inode_t		*dp;		/* incore directory inode */
> -	xfs_dir2_data_unused_t	*dup;		/* data unused entry pointer */
> -	int			error;		/* error return value */
> -	xfs_dir2_db_t		fbno;		/* freespace block number */
> -	struct xfs_buf		*fbp;		/* freespace buffer */
> -	int			findex;		/* freespace entry index */
> -	xfs_dir2_free_t		*free=NULL;	/* freespace block structure */
> -	xfs_dir2_db_t		ifbno;		/* initial freespace block no */
> -	xfs_dir2_db_t		lastfbno=0;	/* highest freespace block no */
> -	int			length;		/* length of the new entry */
> -	int			logfree = 0;	/* need to log free entry */
> -	int			needlog = 0;	/* need to log data header */
> -	int			needscan = 0;	/* need to rescan data frees */
> -	__be16			*tagp;		/* data entry tag pointer */
> -	xfs_trans_t		*tp;		/* transaction pointer */
> -	__be16			*bests;
>  	struct xfs_dir3_icfree_hdr freehdr;
> -	struct xfs_dir2_data_free *bf;
> -	xfs_dir2_data_aoff_t	aoff;
> +	struct xfs_dir2_free	*free = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_trans	*tp = args->trans;
> +	struct xfs_buf		*fbp = NULL;
> +	xfs_dir2_db_t		lastfbno;
> +	xfs_dir2_db_t		ifbno = -1;
> +	xfs_dir2_db_t		dbno = -1;
> +	xfs_dir2_db_t		fbno = -1;
> +	xfs_fileoff_t		fo;
> +	__be16			*bests;
> +	int			findex;
> +	int			error;
>  
> -	dp = args->dp;
> -	tp = args->trans;
> -	length = dp->d_ops->data_entsize(args->namelen);
>  	/*
>  	 * If we came in with a freespace block that means that lookup
>  	 * found an entry with our hash value.  This is the freespace
> @@ -1775,56 +1761,44 @@ xfs_dir2_node_addname_int(
>  	 */
>  	if (fblk) {
>  		fbp = fblk->bp;
> -		/*
> -		 * Remember initial freespace block number.
> -		 */
> -		ifbno = fblk->blkno;
>  		free = fbp->b_addr;
>  		findex = fblk->index;
> -		bests = dp->d_ops->free_bests_p(free);
> -		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -
> -		/*
> -		 * This means the free entry showed that the data block had
> -		 * space for our entry, so we remembered it.
> -		 * Use that data block.
> -		 */
>  		if (findex >= 0) {
> +			/* caller already found the freespace for us. */
> +			bests = dp->d_ops->free_bests_p(free);
> +			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +
>  			ASSERT(findex < freehdr.nvalid);
>  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
>  			ASSERT(be16_to_cpu(bests[findex]) >= length);
>  			dbno = freehdr.firstdb + findex;
>  			goto found_block;
> -		} else {
> -			/*
> -			 * The data block looked at didn't have enough room.
> -			 * We'll start at the beginning of the freespace entries.
> -			 */
> -			dbno = -1;
> -			findex = 0;
>  		}
> -	} else {
> +
>  		/*
> -		 * Didn't come in with a freespace block, so no data block.
> +		 * The data block looked at didn't have enough room.
> +		 * We'll start at the beginning of the freespace entries.
>  		 */
> -		ifbno = dbno = -1;
> -		fbp = NULL;
> -		findex = 0;
> +		ifbno = fblk->blkno;
> +		fbno = ifbno;
>  	}
> +	ASSERT(dbno == -1);
> +	findex = 0;
>  
>  	/*
> -	 * If we don't have a data block yet, we're going to scan the
> -	 * freespace blocks looking for one.  Figure out what the
> -	 * highest freespace block number is.
> +	 * If we don't have a data block yet, we're going to scan the freespace
> +	 * blocks looking for one.  Figure out what the highest freespace block
> +	 * number is.
>  	 */
> -	if (dbno == -1) {
> -		xfs_fileoff_t	fo;		/* freespace block number */
> +	error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK);
> +	if (error)
> +		return error;
> +	lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
> +
> +	/* If we haven't get a search start block, set it now */
> +	if (fbno == -1)
> +		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
>  
> -		if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK)))
> -			return error;
> -		lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
> -		fbno = ifbno;
> -	}
>  	/*
>  	 * While we haven't identified a data block, search the freeblock
>  	 * data for a good data block.  If we find a null freeblock entry,
> @@ -1835,17 +1809,10 @@ xfs_dir2_node_addname_int(
>  		 * If we don't have a freeblock in hand, get the next one.
>  		 */
>  		if (fbp == NULL) {
> -			/*
> -			 * Happens the first time through unless lookup gave
> -			 * us a freespace block to start with.
> -			 */
> -			if (++fbno == 0)
> -				fbno = xfs_dir2_byte_to_db(args->geo,
> -							XFS_DIR2_FREE_OFFSET);
>  			/*
>  			 * If it's ifbno we already looked at it.
>  			 */
> -			if (fbno == ifbno)
> +			if (++fbno == ifbno)
>  				fbno++;
>  			/*
>  			 * If it's off the end we're done.
> @@ -1896,35 +1863,77 @@ xfs_dir2_node_addname_int(
>  			}
>  		}
>  	}
> +found_block:
> +	*dbnop = dbno;
> +	*fbpp = fbp;
> +	*findexp = findex;
> +	return 0;
> +}
> +
> +
> +/*
> + * Add the data entry for a node-format directory name addition.
> + * The leaf entry is added in xfs_dir2_leafn_add.
> + * We may enter with a freespace block that the lookup found.
> + */
> +static int
> +xfs_dir2_node_addname_int(
> +	struct xfs_da_args	*args,		/* operation arguments */
> +	struct xfs_da_state_blk	*fblk)		/* optional freespace block */
> +{
> +	struct xfs_dir2_data_unused *dup;	/* data unused entry pointer */
> +	struct xfs_dir2_data_entry *dep;	/* data entry pointer */
> +	struct xfs_dir2_data_hdr *hdr;		/* data block header */
> +	struct xfs_dir2_data_free *bf;
> +	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
> +	struct xfs_trans	*tp = args->trans;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_buf		*dbp;		/* data block buffer */
> +	struct xfs_buf		*fbp;		/* freespace buffer */
> +	xfs_dir2_data_aoff_t	aoff;
> +	xfs_dir2_db_t		dbno;		/* data block number */
> +	int			error;		/* error return value */
> +	int			findex;		/* freespace entry index */
> +	int			length;		/* length of the new entry */
> +	int			logfree = 0;	/* need to log free entry */
> +	int			needlog = 0;	/* need to log data header */
> +	int			needscan = 0;	/* need to rescan data frees */
> +	__be16			*tagp;		/* data entry tag pointer */
> +	__be16			*bests;
> +
> +	length = dp->d_ops->data_entsize(args->namelen);
> +	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
> +					   length);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Now we know if we must allocate blocks, so if we are checking whether
> +	 * we can insert without allocation then we can return now.
> +	 */
> +	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
> +		if (dbno == -1)
> +			return -ENOSPC;
> +		return 0;
> +	}
>  
>  	/*
>  	 * If we don't have a data block, we need to allocate one and make
>  	 * the freespace entries refer to it.
>  	 */
>  	if (dbno == -1) {
> -		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
> -						  &findex);
> -		if (error)
> -			return error;
> -
> -		/* setup current free block buffer */
> -		free = fbp->b_addr;
> -
>  		/* we're going to have to log the free block index later */
>  		logfree = 1;
> +		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
> +						  &findex);
>  	} else {
> -found_block:
> -		/* If just checking, we succeeded. */
> -		if (args->op_flags & XFS_DA_OP_JUSTCHECK)
> -			return 0;
> -
>  		/* Read the data block in. */
>  		error = xfs_dir3_data_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, dbno),
>  					   -1, &dbp);
> -		if (error)
> -			return error;
>  	}
> +	if (error)
> +		return error;
>  
>  	/* setup for data block up now */
>  	hdr = dbp->b_addr;
> @@ -1961,6 +1970,7 @@ xfs_dir2_node_addname_int(
>  		xfs_dir2_data_log_header(args, dbp);
>  
>  	/* If the freespace block entry is now wrong, update it. */
> +	free = fbp->b_addr;
>  	bests = dp->d_ops->free_bests_p(free);
>  	if (bests[findex] != bf[0].length) {
>  		bests[findex] = bf[0].length;
> -- 
> 2.23.0.rc1
> 
