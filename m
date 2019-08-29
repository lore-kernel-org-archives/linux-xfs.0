Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A93C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C496233FF
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pzwyCTSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfH2VUU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:20:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54690 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2VUT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:20:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLFZjn161975;
        Thu, 29 Aug 2019 21:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PXuA0Jy9N3qYOGHPTEA03srARpHRVh9m5rDAXxwjrVU=;
 b=pzwyCTSXIA/903kqwxDdNZq3N8qE1MlwycSoVYG6s11wo/cztb0RdtesG4iV5JjUeuQ8
 TmLJV8xHgSYapV+KwUJ0KrLRPphIXrpSazRPQRiE5OT9QXxS/WVEXAKRgRmczC1usO82
 qTETRQEAEiAuMxB8rVGcNA7FwEOLvehMSTUlxMMB9ol20kOlsvkbNeeT1VsDI/v4DqDp
 pEySAhK3PSwHbeAJM5RDaHo5kfrTqsMKW9LPNq7IYSUh5Ncq7eMmF6YoDlhi9cbyxqZP
 QFpEu6bdoIQMEbGWPvqsPIUKpkme1sKYPzFoDOtNDE07SFr7OBwxbTiE6DrvQgLfjleX 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uppet01q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:20:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE5JI085138;
        Thu, 29 Aug 2019 21:18:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uphauateg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:18:16 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLIFPI023099;
        Thu, 29 Aug 2019 21:18:15 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:18:15 -0700
Date:   Thu, 29 Aug 2019 14:18:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829211814.GL5354@magnolia>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running a "create millions inodes in a directory" test
> recently, I noticed we were spending a huge amount of time
> converting freespace block headers from disk format to in-memory
> format:
> 
>  31.47%  [kernel]  [k] xfs_dir2_node_addname
>  17.86%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
>   3.55%  [kernel]  [k] xfs_dir3_free_bests_p
> 
> We shouldn't be hitting the best free block scanning code so hard
> when doing sequential directory creates, and it turns out there's
> a highly suboptimal loop searching the the best free array in
> the freespace block - it decodes the block header before checking
> each entry inside a loop, instead of decoding the header once before
> running the entry search loop.
> 
> This makes a massive difference to create rates. Profile now looks
> like this:
> 
>   13.15%  [kernel]  [k] xfs_dir2_node_addname
>    3.52%  [kernel]  [k] xfs_dir3_leaf_check_int
>    3.11%  [kernel]  [k] xfs_log_commit_cil
> 
> And the wall time/average file create rate differences are
> just as stark:
> 
> 		create time(sec) / rate (files/s)
> File count	     vanilla		    patched
>   10k		   0.41 / 24.3k		   0.42 / 23.8k
>   20k		   0.74	/ 27.0k		   0.76 / 26.3k
>  100k		   3.81	/ 26.4k		   3.47 / 28.8k
>  200k		   8.58	/ 23.3k		   7.19 / 27.8k
>    1M		  85.69	/ 11.7k		  48.53 / 20.6k
>    2M		 280.31	/  7.1k		 130.14 / 15.3k
> 
> The larger the directory, the bigger the performance improvement.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

It took me a long time to figure out what the old code even did.
It's much easier to figure out what's going on in the new version.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 97 ++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 63 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 93254f45a5f9..a81f56d9e538 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1750,8 +1750,8 @@ xfs_dir2_node_find_freeblk(
>  	xfs_dir2_db_t		dbno = -1;
>  	xfs_dir2_db_t		fbno = -1;
>  	xfs_fileoff_t		fo;
> -	__be16			*bests;
> -	int			findex;
> +	__be16			*bests = NULL;
> +	int			findex = 0;
>  	int			error;
>  
>  	/*
> @@ -1781,14 +1781,14 @@ xfs_dir2_node_find_freeblk(
>  		 */
>  		ifbno = fblk->blkno;
>  		fbno = ifbno;
> +		xfs_trans_brelse(tp, fbp);
> +		fbp = NULL;
> +		fblk->bp = NULL;
>  	}
> -	ASSERT(dbno == -1);
> -	findex = 0;
>  
>  	/*
>  	 * If we don't have a data block yet, we're going to scan the freespace
> -	 * blocks looking for one.  Figure out what the highest freespace block
> -	 * number is.
> +	 * data for a data block with enough free space in it.
>  	 */
>  	error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK);
>  	if (error)
> @@ -1799,70 +1799,41 @@ xfs_dir2_node_find_freeblk(
>  	if (fbno == -1)
>  		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
>  
> -	/*
> -	 * While we haven't identified a data block, search the freeblock
> -	 * data for a good data block.  If we find a null freeblock entry,
> -	 * indicating a hole in the data blocks, remember that.
> -	 */
> -	while (dbno == -1) {
> -		/*
> -		 * If we don't have a freeblock in hand, get the next one.
> -		 */
> -		if (fbp == NULL) {
> -			/*
> -			 * If it's ifbno we already looked at it.
> -			 */
> -			if (++fbno == ifbno)
> -				fbno++;
> -			/*
> -			 * If it's off the end we're done.
> -			 */
> -			if (fbno >= lastfbno)
> -				break;
> -			/*
> -			 * Read the block.  There can be holes in the
> -			 * freespace blocks, so this might not succeed.
> -			 * This should be really rare, so there's no reason
> -			 * to avoid it.
> -			 */
> -			error = xfs_dir2_free_try_read(tp, dp,
> -					xfs_dir2_db_to_da(args->geo, fbno),
> -					&fbp);
> -			if (error)
> -				return error;
> -			if (!fbp)
> -				continue;
> -			free = fbp->b_addr;
> -			findex = 0;
> -		}
> +	for ( ; fbno < lastfbno; fbno++) {
> +		/* If it's ifbno we already looked at it. */
> +		if (fbno == ifbno)
> +			continue;
> +
>  		/*
> -		 * Look at the current free entry.  Is it good enough?
> -		 *
> -		 * The bests initialisation should be where the bufer is read in
> -		 * the above branch. But gcc is too stupid to realise that bests
> -		 * and the freehdr are actually initialised if they are placed
> -		 * there, so we have to do it here to avoid warnings. Blech.
> +		 * Read the block.  There can be holes in the freespace blocks,
> +		 * so this might not succeed.  This should be really rare, so
> +		 * there's no reason to avoid it.
>  		 */
> +		error = xfs_dir2_free_try_read(tp, dp,
> +				xfs_dir2_db_to_da(args->geo, fbno),
> +				&fbp);
> +		if (error)
> +			return error;
> +		if (!fbp)
> +			continue;
> +
> +		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
>  		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> -		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> -		    be16_to_cpu(bests[findex]) >= length)
> -			dbno = freehdr.firstdb + findex;
> -		else {
> -			/*
> -			 * Are we done with the freeblock?
> -			 */
> -			if (++findex == freehdr.nvalid) {
> -				/*
> -				 * Drop the block.
> -				 */
> -				xfs_trans_brelse(tp, fbp);
> -				fbp = NULL;
> -				if (fblk && fblk->bp)
> -					fblk->bp = NULL;
> +
> +		/* Scan the free entry array for a large enough free space. */
> +		for (findex = 0; findex < freehdr.nvalid; findex++) {
> +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> +			    be16_to_cpu(bests[findex]) >= length) {
> +				dbno = freehdr.firstdb + findex;
> +				goto found_block;
>  			}
>  		}
> +
> +		/* Didn't find free space, go on to next free block */
> +		xfs_trans_brelse(tp, fbp);
>  	}
> +
>  found_block:
>  	*dbnop = dbno;
>  	*fbpp = fbp;
> -- 
> 2.23.0.rc1
> 
