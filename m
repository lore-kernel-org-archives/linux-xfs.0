Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52907CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D68E20B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnM7EADw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDU13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:27:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbfKDU13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:27:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KO4kO116898;
        Mon, 4 Nov 2019 20:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EApgceJE9E1EOBJ9zxmrhjrQ+b9fyEyhwAq4rVh0me4=;
 b=bnM7EADwEuPp+uIbvgFh6R6uTa8wTHOzWWGJegGbAAfxhXS7Kp3puBfyNWzmXS0/tdD5
 0dUf+34XrDFyhzucnaG/02OUkrZtPOUVISLL2M7lMDzw+SArmXuYAlXHJBpqugVYXxLG
 oQyHEwHKYMonOchfviHwaxblhzbxYV0QQVR+n4yyIGtryhphrdT41DaaCnfgZ06fB7od
 NvSVYt2CBOd/6M9eqahBOL5i79PewiTE7Prlh59daOttolLbmXoMspnggNPSBbKu+TGy
 5oSC2fF9zknS3uJJdNIykx6uk6IYftTlWqQsOGJCTeda2J325knbt4uC+qrJ2yhcx/Qn Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpsw79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:27:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KODha129538;
        Mon, 4 Nov 2019 20:25:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w1kxdwpwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:25:24 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KPOcQ003353;
        Mon, 4 Nov 2019 20:25:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:25:23 -0800
Date:   Mon, 4 Nov 2019 12:25:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] xfs: make the xfs_dir3_icfree_hdr available to
 xfs_dir2_node_addname_int
Message-ID: <20191104202523.GS4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-15-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:59PM -0700, Christoph Hellwig wrote:
> Return the xfs_dir3_icfree_hdr used by the helpers called from
> xfs_dir2_node_addname_int to the main function to prepare for the
> next round of changes.

How does this help?  Is this purely to reduce stack usage?  Or will we
use this later to skip some xfs_dir2_free_hdr_from_disk calls?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 42 +++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 26032eba1e32..d400243c9556 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1660,14 +1660,13 @@ xfs_dir2_node_add_datablk(
>  	xfs_dir2_db_t		*dbno,
>  	struct xfs_buf		**dbpp,
>  	struct xfs_buf		**fbpp,
> +	struct xfs_dir3_icfree_hdr *hdr,
>  	int			*findex)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_mount	*mp = dp->i_mount;
> -	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_dir2_data_free *bf;
> -	struct xfs_dir2_data_hdr *hdr;
>  	struct xfs_dir2_free	*free = NULL;
>  	xfs_dir2_db_t		fbno;
>  	struct xfs_buf		*fbp;
> @@ -1730,25 +1729,25 @@ xfs_dir2_node_add_datablk(
>  			return error;
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
>  
>  		/* Remember the first slot as our empty slot. */
> -		freehdr.firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
> +		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
>  							XFS_DIR2_FREE_OFFSET)) *
>  				dp->d_ops->free_max_bests(args->geo);
>  	} else {
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
>  	}
>  
>  	/* Set the freespace block index from the data block number. */
>  	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
>  
>  	/* Extend the freespace table if the new data block is off the end. */
> -	if (*findex >= freehdr.nvalid) {
> +	if (*findex >= hdr->nvalid) {
>  		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
> -		freehdr.nvalid = *findex + 1;
> +		hdr->nvalid = *findex + 1;
>  		bests[*findex] = cpu_to_be16(NULLDATAOFF);
>  	}
>  
> @@ -1757,14 +1756,13 @@ xfs_dir2_node_add_datablk(
>  	 * true) then update the header.
>  	 */
>  	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
> -		freehdr.nused++;
> -		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, &freehdr);
> +		hdr->nused++;
> +		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, hdr);
>  		xfs_dir2_free_log_header(args, fbp);
>  	}
>  
>  	/* Update the freespace value for the new block in the table. */
> -	hdr = dbp->b_addr;
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
>  	bests[*findex] = bf[0].length;
>  
>  	*dbpp = dbp;
> @@ -1778,10 +1776,10 @@ xfs_dir2_node_find_freeblk(
>  	struct xfs_da_state_blk	*fblk,
>  	xfs_dir2_db_t		*dbnop,
>  	struct xfs_buf		**fbpp,
> +	struct xfs_dir3_icfree_hdr *hdr,
>  	int			*findexp,
>  	int			length)
>  {
> -	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_dir2_free	*free = NULL;
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_trans	*tp = args->trans;
> @@ -1808,13 +1806,12 @@ xfs_dir2_node_find_freeblk(
>  		if (findex >= 0) {
>  			/* caller already found the freespace for us. */
>  			bests = dp->d_ops->free_bests_p(free);
> -			xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr,
> -						    free);
> +			xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
>  
> -			ASSERT(findex < freehdr.nvalid);
> +			ASSERT(findex < hdr->nvalid);
>  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
>  			ASSERT(be16_to_cpu(bests[findex]) >= length);
> -			dbno = freehdr.firstdb + findex;
> +			dbno = hdr->firstdb + findex;
>  			goto found_block;
>  		}
>  
> @@ -1858,13 +1855,13 @@ xfs_dir2_node_find_freeblk(
>  
>  		free = fbp->b_addr;
>  		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
> +		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
>  
>  		/* Scan the free entry array for a large enough free space. */
> -		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
> +		for (findex = hdr->nvalid - 1; findex >= 0; findex--) {
>  			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
>  			    be16_to_cpu(bests[findex]) >= length) {
> -				dbno = freehdr.firstdb + findex;
> +				dbno = hdr->firstdb + findex;
>  				goto found_block;
>  			}
>  		}
> @@ -1898,6 +1895,7 @@ xfs_dir2_node_addname_int(
>  	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_buf		*dbp;		/* data block buffer */
>  	struct xfs_buf		*fbp;		/* freespace buffer */
>  	xfs_dir2_data_aoff_t	aoff;
> @@ -1912,8 +1910,8 @@ xfs_dir2_node_addname_int(
>  	__be16			*bests;
>  
>  	length = dp->d_ops->data_entsize(args->namelen);
> -	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
> -					   length);
> +	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
> +					   &findex, length);
>  	if (error)
>  		return error;
>  
> @@ -1935,7 +1933,7 @@ xfs_dir2_node_addname_int(
>  		/* we're going to have to log the free block index later */
>  		logfree = 1;
>  		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
> -						  &findex);
> +						  &freehdr, &findex);
>  	} else {
>  		/* Read the data block in. */
>  		error = xfs_dir3_data_read(tp, dp,
> -- 
> 2.20.1
> 
