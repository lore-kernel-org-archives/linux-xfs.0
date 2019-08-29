Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846E9C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0E8208C2
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l+fCmFXD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfH2VVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:21:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfH2VVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:21:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLEd4i161171;
        Thu, 29 Aug 2019 21:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=yTRpw+PEd1uQIh6cu1nTpdGTcS3ZdT2vi/NyUtOH8JY=;
 b=l+fCmFXDDlW9OcfkNFi9Cj8J72daMTumJLuyNzcNFbvJXyR+cBqSUZFAIFXy/U3iLAzC
 tU+HSTBl9L7omz6YvSjyX9XQLf8Nm0Izd4E5BXXWtSwuHv27jmpaxuIizuxUssMhpiOX
 lc+sRBJoGprhi9sUlP7SEt2/JyaXrbPNJJxzopUosSmFevrimcdAIaP77cld5qFpWVRC
 +Eo/sYF4A46TsIcADmHf9oqPamwLhxOJuloNJX/mqSjHLDXs8IdbI/Bf14nQgR9TI1k0
 6V21fG4+gAamBmapbEyysA/YgqTFKNkpClOGWqob2VFdabo9sdUZvIGM66Nu8iUU1bVz XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uppet0205-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:20:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE22b186921;
        Thu, 29 Aug 2019 21:20:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrffpcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:20:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLKvY6017174;
        Thu, 29 Aug 2019 21:20:57 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:20:57 -0700
Date:   Thu, 29 Aug 2019 14:20:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: reverse search directory freespace indexes
Message-ID: <20190829212056.GM5354@magnolia>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-6-david@fromorbit.com>
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

On Thu, Aug 29, 2019 at 08:47:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a directory is growing rapidly, new blocks tend to get added at
> the end of the directory. These end up at the end of the freespace
> index, and when the directory gets large finding these new
> freespaces gets expensive. The code does a linear search across the
> frespace index from the first block in the directory to the last,
> hence meaning the newly added space is the last index searched.
> 
> Instead, do a reverse order index search, starting from the last
> block and index in the freespace index. This makes most lookups for
> free space on rapidly growing directories O(1) instead of O(N), but
> should not have any impact on random insert workloads because the
> average search length is the same regardless of which end of the
> array we start at.
> 
> The result is a major improvement in large directory grow rates:
> 
> 		create time(sec) / rate (files/s)
>  File count     vanilla             Prev commit		Patched
>   10k	      0.41 / 24.3k	   0.42 / 23.8k       0.41 / 24.3k
>   20k	      0.74 / 27.0k	   0.76 / 26.3k       0.75 / 26.7k
>  100k	      3.81 / 26.4k	   3.47 / 28.8k       3.27 / 30.6k
>  200k	      8.58 / 23.3k	   7.19 / 27.8k       6.71 / 29.8k
>    1M	     85.69 / 11.7k	  48.53 / 20.6k      37.67 / 26.5k
>    2M	    280.31 /  7.1k	 130.14 / 15.3k      79.55 / 25.2k
>   10M	   3913.26 /  2.5k                          552.89 / 18.1k
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Heh, neat.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a81f56d9e538..705c4f562758 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1745,10 +1745,11 @@ xfs_dir2_node_find_freeblk(
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_buf		*fbp = NULL;
> +	xfs_dir2_db_t		firstfbno;
>  	xfs_dir2_db_t		lastfbno;
>  	xfs_dir2_db_t		ifbno = -1;
>  	xfs_dir2_db_t		dbno = -1;
> -	xfs_dir2_db_t		fbno = -1;
> +	xfs_dir2_db_t		fbno;
>  	xfs_fileoff_t		fo;
>  	__be16			*bests = NULL;
>  	int			findex = 0;
> @@ -1780,7 +1781,6 @@ xfs_dir2_node_find_freeblk(
>  		 * We'll start at the beginning of the freespace entries.
>  		 */
>  		ifbno = fblk->blkno;
> -		fbno = ifbno;
>  		xfs_trans_brelse(tp, fbp);
>  		fbp = NULL;
>  		fblk->bp = NULL;
> @@ -1794,12 +1794,9 @@ xfs_dir2_node_find_freeblk(
>  	if (error)
>  		return error;
>  	lastfbno = xfs_dir2_da_to_db(args->geo, (xfs_dablk_t)fo);
> +	firstfbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
>  
> -	/* If we haven't get a search start block, set it now */
> -	if (fbno == -1)
> -		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
> -
> -	for ( ; fbno < lastfbno; fbno++) {
> +	for (fbno = lastfbno - 1; fbno >= firstfbno; fbno--) {
>  		/* If it's ifbno we already looked at it. */
>  		if (fbno == ifbno)
>  			continue;
> @@ -1822,7 +1819,7 @@ xfs_dir2_node_find_freeblk(
>  		dp->d_ops->free_hdr_from_disk(&freehdr, free);
>  
>  		/* Scan the free entry array for a large enough free space. */
> -		for (findex = 0; findex < freehdr.nvalid; findex++) {
> +		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
>  			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
>  			    be16_to_cpu(bests[findex]) >= length) {
>  				dbno = freehdr.firstdb + findex;
> -- 
> 2.23.0.rc1
> 
