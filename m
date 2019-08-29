Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07533C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 23:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB48F21670
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 23:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iKJhTV18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfH2XRC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 19:17:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfH2XRC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 19:17:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TNDpAs063081;
        Thu, 29 Aug 2019 23:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Fsi1NTnWYKXABsrq350OCzIKrr2Pdqwc15ulcM0xUjA=;
 b=iKJhTV18SQW77jrwRfzXfGKjs2gMcpG3tsLLZQCBR6AuF6u211tVLeKw+PYK3S++EyWb
 DfFG+PpZMVfFxODOXGaeDyy2Lh0R3dvVVmNMczE3OnfRSS0v3/vE4RLXdWB92GdvHSRh
 t0ro5EafHFz4WvcQYWLoWdvjtxJjRMsdssrGjk0W5AZMzSc/n9kAwfslo1405qf1uv1U
 dTLIbJYpxvA1G1m/02wuXc8khNBVHtq8VndKdiY0BMQNGJx4CENc3CXwMu5TCR089eBD
 kUBFOfSLLsD4tacqqwPrWyp943g6dJ45Gnm3rlPs9QSr98V6nIWWt5wQqjFPyKzfJ62V Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2upqyn82b3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 23:16:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TKxGxV191161;
        Thu, 29 Aug 2019 21:02:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2upc8v4r13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:02:26 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TL2PW0004607;
        Thu, 29 Aug 2019 21:02:26 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:02:25 -0700
Date:   Thu, 29 Aug 2019 14:02:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20190829210224.GJ5354@magnolia>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290232
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor out the code that adds a data block to a directory from
> xfs_dir2_node_addname_int(). This makes the code flow cleaner and
> more obvious and provides clear isolation of upcoming optimsations.
> 
> Signed-off-By: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 324 +++++++++++++++++-----------------
>  1 file changed, 158 insertions(+), 166 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index e40986cc0759..cc1f1c505a2b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1608,6 +1608,129 @@ xfs_dir2_leafn_unbalance(
>  	xfs_dir3_leaf_check(dp, drop_blk->bp);
>  }
>  
> +/*
> + * Add a new data block to the directory at the free space index that the caller
> + * has specified.
> + */
> +static int
> +xfs_dir2_node_add_datablk(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state_blk	*fblk,
> +	xfs_dir2_db_t		*dbno,
> +	struct xfs_buf		**dbpp,
> +	struct xfs_buf		**fbpp,
> +	int			*findex)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_trans	*tp = args->trans;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_dir3_icfree_hdr freehdr;
> +	struct xfs_dir2_data_free *bf;
> +	struct xfs_dir2_data_hdr *hdr;
> +	struct xfs_dir2_free	*free = NULL;
> +	xfs_dir2_db_t		fbno;
> +	struct xfs_buf		*fbp;
> +	struct xfs_buf		*dbp;
> +	__be16			*bests = NULL;
> +	int			error;
> +
> +	/* Not allowed to allocate, return failure. */
> +	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> +		return -ENOSPC;
> +
> +	/* Allocate and initialize the new data block.  */
> +	error = xfs_dir2_grow_inode(args, XFS_DIR2_DATA_SPACE, dbno);
> +	if (error)
> +		return error;
> +	error = xfs_dir3_data_init(args, *dbno, &dbp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Get the freespace block corresponding to the data block
> +	 * that was just allocated.
> +	 */
> +	fbno = dp->d_ops->db_to_fdb(args->geo, *dbno);
> +	error = xfs_dir2_free_try_read(tp, dp,
> +			       xfs_dir2_db_to_da(args->geo, fbno), &fbp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If there wasn't a freespace block, the read will
> +	 * return a NULL fbp.  Allocate and initialize a new one.
> +	 */
> +	if (!fbp) {
> +		error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE, &fbno);
> +		if (error)
> +			return error;
> +
> +		if (dp->d_ops->db_to_fdb(args->geo, *dbno) != fbno) {

As a straight "cut this huge function into smaller pieces, no functional
changes" patch I guess this is fine, but ... when can this happen?

AFAICT the only way that would happen is if either the dir geometry
changes out from under us (??) or if someone messed with *dbno (???)
right?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +			xfs_alert(mp,
> +"%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
> +				__func__, (unsigned long long)dp->i_ino,
> +				(long long)dp->d_ops->db_to_fdb(args->geo, *dbno),
> +				(long long)*dbno, (long long)fbno);
> +			if (fblk) {
> +				xfs_alert(mp,
> +			" fblk "PTR_FMT" blkno %llu index %d magic 0x%x",
> +					fblk, (unsigned long long)fblk->blkno,
> +					fblk->index, fblk->magic);
> +			} else {
> +				xfs_alert(mp, " ... fblk is NULL");
> +			}
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		/* Get a buffer for the new block. */
> +		error = xfs_dir3_free_get_buf(args, fbno, &fbp);
> +		if (error)
> +			return error;
> +		free = fbp->b_addr;
> +		bests = dp->d_ops->free_bests_p(free);
> +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +
> +		/* Remember the first slot as our empty slot. */
> +		freehdr.firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
> +							XFS_DIR2_FREE_OFFSET)) *
> +				dp->d_ops->free_max_bests(args->geo);
> +	} else {
> +		free = fbp->b_addr;
> +		bests = dp->d_ops->free_bests_p(free);
> +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> +	}
> +
> +	/* Set the freespace block index from the data block number. */
> +	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
> +
> +	/* Extend the freespace table if the new data block is off the end. */
> +	if (*findex >= freehdr.nvalid) {
> +		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
> +		freehdr.nvalid = *findex + 1;
> +		bests[*findex] = cpu_to_be16(NULLDATAOFF);
> +	}
> +
> +	/*
> +	 * If this entry was for an empty data block (this should always be
> +	 * true) then update the header.
> +	 */
> +	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
> +		freehdr.nused++;
> +		dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
> +		xfs_dir2_free_log_header(args, fbp);
> +	}
> +
> +	/* Update the freespace value for the new block in the table. */
> +	hdr = dbp->b_addr;
> +	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bests[*findex] = bf[0].length;
> +
> +	*dbpp = dbp;
> +	*fbpp = fbp;
> +	return 0;
> +}
> +
>  /*
>   * Add the data entry for a node-format directory name addition.
>   * The leaf entry is added in xfs_dir2_leafn_add.
> @@ -1632,10 +1755,9 @@ xfs_dir2_node_addname_int(
>  	xfs_dir2_db_t		ifbno;		/* initial freespace block no */
>  	xfs_dir2_db_t		lastfbno=0;	/* highest freespace block no */
>  	int			length;		/* length of the new entry */
> -	int			logfree;	/* need to log free entry */
> -	xfs_mount_t		*mp;		/* filesystem mount point */
> -	int			needlog;	/* need to log data header */
> -	int			needscan;	/* need to rescan data frees */
> +	int			logfree = 0;	/* need to log free entry */
> +	int			needlog = 0;	/* need to log data header */
> +	int			needscan = 0;	/* need to rescan data frees */
>  	__be16			*tagp;		/* data entry tag pointer */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	__be16			*bests;
> @@ -1644,7 +1766,6 @@ xfs_dir2_node_addname_int(
>  	xfs_dir2_data_aoff_t	aoff;
>  
>  	dp = args->dp;
> -	mp = dp->i_mount;
>  	tp = args->trans;
>  	length = dp->d_ops->data_entsize(args->namelen);
>  	/*
> @@ -1673,6 +1794,7 @@ xfs_dir2_node_addname_int(
>  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
>  			ASSERT(be16_to_cpu(bests[findex]) >= length);
>  			dbno = freehdr.firstdb + findex;
> +			goto found_block;
>  		} else {
>  			/*
>  			 * The data block looked at didn't have enough room.
> @@ -1774,168 +1896,46 @@ xfs_dir2_node_addname_int(
>  			}
>  		}
>  	}
> +
>  	/*
>  	 * If we don't have a data block, we need to allocate one and make
>  	 * the freespace entries refer to it.
>  	 */
> -	if (unlikely(dbno == -1)) {
> -		/*
> -		 * Not allowed to allocate, return failure.
> -		 */
> -		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
> -			return -ENOSPC;
> -
> -		/*
> -		 * Allocate and initialize the new data block.
> -		 */
> -		if (unlikely((error = xfs_dir2_grow_inode(args,
> -							 XFS_DIR2_DATA_SPACE,
> -							 &dbno)) ||
> -		    (error = xfs_dir3_data_init(args, dbno, &dbp))))
> -			return error;
> -
> -		/*
> -		 * If (somehow) we have a freespace block, get rid of it.
> -		 */
> -		if (fbp)
> -			xfs_trans_brelse(tp, fbp);
> -		if (fblk && fblk->bp)
> -			fblk->bp = NULL;
> -
> -		/*
> -		 * Get the freespace block corresponding to the data block
> -		 * that was just allocated.
> -		 */
> -		fbno = dp->d_ops->db_to_fdb(args->geo, dbno);
> -		error = xfs_dir2_free_try_read(tp, dp,
> -				       xfs_dir2_db_to_da(args->geo, fbno),
> -				       &fbp);
> +	if (dbno == -1) {
> +		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
> +						  &findex);
>  		if (error)
>  			return error;
>  
> -		/*
> -		 * If there wasn't a freespace block, the read will
> -		 * return a NULL fbp.  Allocate and initialize a new one.
> -		 */
> -		if (!fbp) {
> -			error = xfs_dir2_grow_inode(args, XFS_DIR2_FREE_SPACE,
> -						    &fbno);
> -			if (error)
> -				return error;
> -
> -			if (dp->d_ops->db_to_fdb(args->geo, dbno) != fbno) {
> -				xfs_alert(mp,
> -"%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld ifbno %llu lastfbno %d",
> -					__func__, (unsigned long long)dp->i_ino,
> -					(long long)dp->d_ops->db_to_fdb(
> -								args->geo, dbno),
> -					(long long)dbno, (long long)fbno,
> -					(unsigned long long)ifbno, lastfbno);
> -				if (fblk) {
> -					xfs_alert(mp,
> -				" fblk "PTR_FMT" blkno %llu index %d magic 0x%x",
> -						fblk,
> -						(unsigned long long)fblk->blkno,
> -						fblk->index,
> -						fblk->magic);
> -				} else {
> -					xfs_alert(mp, " ... fblk is NULL");
> -				}
> -				XFS_ERROR_REPORT("xfs_dir2_node_addname_int",
> -						 XFS_ERRLEVEL_LOW, mp);
> -				return -EFSCORRUPTED;
> -			}
> -
> -			/*
> -			 * Get a buffer for the new block.
> -			 */
> -			error = xfs_dir3_free_get_buf(args, fbno, &fbp);
> -			if (error)
> -				return error;
> -			free = fbp->b_addr;
> -			bests = dp->d_ops->free_bests_p(free);
> -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -
> -			/*
> -			 * Remember the first slot as our empty slot.
> -			 */
> -			freehdr.firstdb =
> -				(fbno - xfs_dir2_byte_to_db(args->geo,
> -							XFS_DIR2_FREE_OFFSET)) *
> -					dp->d_ops->free_max_bests(args->geo);
> -		} else {
> -			free = fbp->b_addr;
> -			bests = dp->d_ops->free_bests_p(free);
> -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -		}
> +		/* setup current free block buffer */
> +		free = fbp->b_addr;
>  
> -		/*
> -		 * Set the freespace block index from the data block number.
> -		 */
> -		findex = dp->d_ops->db_to_fdindex(args->geo, dbno);
> -		/*
> -		 * If it's after the end of the current entries in the
> -		 * freespace block, extend that table.
> -		 */
> -		if (findex >= freehdr.nvalid) {
> -			ASSERT(findex < dp->d_ops->free_max_bests(args->geo));
> -			freehdr.nvalid = findex + 1;
> -			/*
> -			 * Tag new entry so nused will go up.
> -			 */
> -			bests[findex] = cpu_to_be16(NULLDATAOFF);
> -		}
> -		/*
> -		 * If this entry was for an empty data block
> -		 * (this should always be true) then update the header.
> -		 */
> -		if (bests[findex] == cpu_to_be16(NULLDATAOFF)) {
> -			freehdr.nused++;
> -			dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
> -			xfs_dir2_free_log_header(args, fbp);
> -		}
> -		/*
> -		 * Update the real value in the table.
> -		 * We haven't allocated the data entry yet so this will
> -		 * change again.
> -		 */
> -		hdr = dbp->b_addr;
> -		bf = dp->d_ops->data_bestfree_p(hdr);
> -		bests[findex] = bf[0].length;
> +		/* we're going to have to log the free block index later */
>  		logfree = 1;
> -	}
> -	/*
> -	 * We had a data block so we don't have to make a new one.
> -	 */
> -	else {
> -		/*
> -		 * If just checking, we succeeded.
> -		 */
> +	} else {
> +found_block:
> +		/* If just checking, we succeeded. */
>  		if (args->op_flags & XFS_DA_OP_JUSTCHECK)
>  			return 0;
>  
> -		/*
> -		 * Read the data block in.
> -		 */
> +		/* Read the data block in. */
>  		error = xfs_dir3_data_read(tp, dp,
>  					   xfs_dir2_db_to_da(args->geo, dbno),
>  					   -1, &dbp);
>  		if (error)
>  			return error;
> -		hdr = dbp->b_addr;
> -		bf = dp->d_ops->data_bestfree_p(hdr);
> -		logfree = 0;
>  	}
> +
> +	/* setup for data block up now */
> +	hdr = dbp->b_addr;
> +	bf = dp->d_ops->data_bestfree_p(hdr);
>  	ASSERT(be16_to_cpu(bf[0].length) >= length);
> -	/*
> -	 * Point to the existing unused space.
> -	 */
> +
> +	/* Point to the existing unused space. */
>  	dup = (xfs_dir2_data_unused_t *)
>  	      ((char *)hdr + be16_to_cpu(bf[0].offset));
> -	needscan = needlog = 0;
> -	/*
> -	 * Mark the first part of the unused space, inuse for us.
> -	 */
> +
> +	/* Mark the first part of the unused space, inuse for us. */
>  	aoff = (xfs_dir2_data_aoff_t)((char *)dup - (char *)hdr);
>  	error = xfs_dir2_data_use_free(args, dbp, dup, aoff, length,
>  			&needlog, &needscan);
> @@ -1943,9 +1943,8 @@ xfs_dir2_node_addname_int(
>  		xfs_trans_brelse(tp, dbp);
>  		return error;
>  	}
> -	/*
> -	 * Fill in the new entry and log it.
> -	 */
> +
> +	/* Fill in the new entry and log it. */
>  	dep = (xfs_dir2_data_entry_t *)dup;
>  	dep->inumber = cpu_to_be64(args->inumber);
>  	dep->namelen = args->namelen;
> @@ -1954,32 +1953,25 @@ xfs_dir2_node_addname_int(
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, dbp, dep);
> -	/*
> -	 * Rescan the block for bestfree if needed.
> -	 */
> +
> +	/* Rescan the freespace and log the data block if needed. */
>  	if (needscan)
>  		xfs_dir2_data_freescan(dp, hdr, &needlog);
> -	/*
> -	 * Log the data block header if needed.
> -	 */
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, dbp);
> -	/*
> -	 * If the freespace entry is now wrong, update it.
> -	 */
> -	bests = dp->d_ops->free_bests_p(free); /* gcc is so stupid */
> -	if (be16_to_cpu(bests[findex]) != be16_to_cpu(bf[0].length)) {
> +
> +	/* If the freespace block entry is now wrong, update it. */
> +	bests = dp->d_ops->free_bests_p(free);
> +	if (bests[findex] != bf[0].length) {
>  		bests[findex] = bf[0].length;
>  		logfree = 1;
>  	}
> -	/*
> -	 * Log the freespace entry if needed.
> -	 */
> +
> +	/* Log the freespace entry if needed. */
>  	if (logfree)
>  		xfs_dir2_free_log_bests(args, fbp, findex, findex);
> -	/*
> -	 * Return the data block and offset in args, then drop the data block.
> -	 */
> +
> +	/* Return the data block and offset in args. */
>  	args->blkno = (xfs_dablk_t)dbno;
>  	args->index = be16_to_cpu(*tagp);
>  	return 0;
> -- 
> 2.23.0.rc1
> 
