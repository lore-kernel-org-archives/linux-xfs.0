Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBFACA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 983AC20869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GMzMWG4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKDUvW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:51:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfKDUvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:51:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KmuuS121154;
        Mon, 4 Nov 2019 20:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RbeG6JUtLEtiZhf3gSM7efvi9vHFsEVv+Nl7seQkE2k=;
 b=GMzMWG4TOWGHOjOoXHPp2+WMQ0iJ1y2T1Uf7xQTUpAex9cuWaHTfIC9HSFzGchghq1Na
 XPkQ1l7pjQPZzooUxBucwxyq1suJbv9sF3DTLcc7e5XFbhGReMIZ1GBoBA160OQvaxIB
 JYhIWwxHui4iYxZhlTY2awM0y8TJJonSmOq4W7BljfmfbdaUwHaVfBmGAo0CjFbZa/s2
 BQgko73TQH/5kTJnuznXPIxXTa+gzPeNh35pf32XtP4VYf4qQlPg1Ee5O+1/bNrcIwuY
 9ADISC4JJleQ/dwGGePREZZbA4flMaLNNPeqYQmPCmX3qRFXFl6YtKVoXqCJMnoWfSn4 Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12er1u8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:51:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnW8R190705;
        Mon, 4 Nov 2019 20:51:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w1kacb2rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:51:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KpF4O019246;
        Mon, 4 Nov 2019 20:51:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:51:14 -0800
Date:   Mon, 4 Nov 2019 12:51:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/34] xfs: merge xfs_dir2_data_freescan and
 xfs_dir2_data_freescan_int
Message-ID: <20191104205113.GI4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-34-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-34-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:18PM -0700, Christoph Hellwig wrote:
> There is no real need for xfs_dir2_data_freescan wrapper, so rename
> xfs_dir2_data_freescan_int to xfs_dir2_data_freescan and let the
> callers dereference the mount pointer from the inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.h       |  4 +---
>  fs/xfs/libxfs/xfs_dir2_block.c | 10 +++++-----
>  fs/xfs/libxfs/xfs_dir2_data.c  | 11 +----------
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_node.c  |  4 ++--
>  5 files changed, 12 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index ccdbc612fb76..8bf4cf227740 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -66,9 +66,7 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
>  extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
>  				struct xfs_buf *bp);
>  
> -extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
> -		struct xfs_dir2_data_hdr *hdr, int *loghead);
> -extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
> +extern void xfs_dir2_data_freescan(struct xfs_mount *mp,
>  		struct xfs_dir2_data_hdr *hdr, int *loghead);
>  extern void xfs_dir2_data_log_entry(struct xfs_da_args *args,
>  		struct xfs_buf *bp, struct xfs_dir2_data_entry *dep);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 94d32e515478..4b3ea6730775 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -311,7 +311,7 @@ xfs_dir2_block_compact(
>  	 * This needs to happen before the next call to use_free.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(args->dp, hdr, needlog);
> +		xfs_dir2_data_freescan(args->dp->i_mount, hdr, needlog);
>  }
>  
>  /*
> @@ -458,7 +458,7 @@ xfs_dir2_block_addname(
>  		 * This needs to happen before the next call to use_free.
>  		 */
>  		if (needscan) {
> -			xfs_dir2_data_freescan(dp, hdr, &needlog);
> +			xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  			needscan = 0;
>  		}
>  		/*
> @@ -548,7 +548,7 @@ xfs_dir2_block_addname(
>  	 * Clean up the bestfree array and log the header, tail, and entry.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, bp);
>  	xfs_dir2_block_log_tail(tp, bp);
> @@ -807,7 +807,7 @@ xfs_dir2_block_removename(
>  	 * Fix up bestfree, log the header if necessary.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, bp);
>  	xfs_dir3_data_check(dp, bp);
> @@ -1014,7 +1014,7 @@ xfs_dir2_leaf_to_block(
>  	 * Scan the bestfree if we need it and log the data block header.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, dbp);
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 9752a0da5b95..4304c62796dd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -615,7 +615,7 @@ xfs_dir2_data_freeremove(
>   * Given a data block, reconstruct its bestfree map.
>   */
>  void
> -xfs_dir2_data_freescan_int(
> +xfs_dir2_data_freescan(
>  	struct xfs_mount	*mp,
>  	struct xfs_dir2_data_hdr *hdr,
>  	int			*loghead)
> @@ -670,15 +670,6 @@ xfs_dir2_data_freescan_int(
>  	}
>  }
>  
> -void
> -xfs_dir2_data_freescan(
> -	struct xfs_inode	*dp,
> -	struct xfs_dir2_data_hdr *hdr,
> -	int			*loghead)
> -{
> -	return xfs_dir2_data_freescan_int(dp->i_mount, hdr, loghead);
> -}
> -
>  /*
>   * Initialize a data block at the given block number in the directory.
>   * Give back the buffer for the created block.
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index ff54c8f08ded..6912264e081e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -465,7 +465,7 @@ xfs_dir2_block_to_leaf(
>  		hdr->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
>  
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	/*
>  	 * Set up leaf tail and bests table.
>  	 */
> @@ -872,7 +872,7 @@ xfs_dir2_leaf_addname(
>  	 * Need to scan fix up the bestfree table.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	/*
>  	 * Need to log the data block's header.
>  	 */
> @@ -1413,7 +1413,7 @@ xfs_dir2_leaf_removename(
>  	 * log the data block header if necessary.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, dbp);
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index e51b103fd429..a131ed5e5f3b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1322,7 +1322,7 @@ xfs_dir2_leafn_remove(
>  	 * Log the data block header if needed.
>  	 */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, dbp);
>  	xfs_dir3_data_check(dp, dbp);
> @@ -1970,7 +1970,7 @@ xfs_dir2_node_addname_int(
>  
>  	/* Rescan the freespace and log the data block if needed. */
>  	if (needscan)
> -		xfs_dir2_data_freescan(dp, hdr, &needlog);
> +		xfs_dir2_data_freescan(dp->i_mount, hdr, &needlog);
>  	if (needlog)
>  		xfs_dir2_data_log_header(args, dbp);
>  
> -- 
> 2.20.1
> 
