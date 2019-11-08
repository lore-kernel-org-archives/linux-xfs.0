Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0410AC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB6221D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="epd3uRcd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKHBI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:08:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHBI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:08:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80xTXX173857;
        Fri, 8 Nov 2019 01:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dvqFpYscd2kDSrMWXdOtkli3Ek9QNlNO2l9lyTdpGPk=;
 b=epd3uRcdQrVPrQK1EZ4340Azh3R9ixMl2haMNuzoDFBbiVhId6nZO9jHX2IUzF6hBKPL
 AJW0tCtNWaq/QEbYAwwdzXc0U1a2N3vHNdPHEvWoaJunKly0TdDLVDaRNh4NrdLu0uH3
 n0hL8Jmotn8xZOmcK8SdJsN/xrzdelGjT5lk1hoMvolcvFOO57Z2ZLiwiuSy4ogYY6vN
 0+c4o7o5wbhWix3/7eSUPMP9EHkK9Os1tD6TV/UgmNoLhjTWa24qIBwLDSli3e7DYhV1
 a4Q8O+mvJPOMNu5VZAwSNS78N0fObAoMEMvmFkOayAf/+DC+asjtfSJi+JThTvKgaG1L Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w11ytq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:08:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA814PA5061470;
        Fri, 8 Nov 2019 01:06:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w41wb8aka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:06:24 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA816N3Z016628;
        Fri, 8 Nov 2019 01:06:23 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:06:23 -0800
Date:   Thu, 7 Nov 2019 17:06:23 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/46] xfs: make the xfs_dir3_icfree_hdr available to
 xfs_dir2_node_addname_int
Message-ID: <20191108010623.GJ6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-16-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:39PM +0100, Christoph Hellwig wrote:
> Return the xfs_dir3_icfree_hdr used by the helpers called from
> xfs_dir2_node_addname_int to the main function to prepare for the
> next round of changes where we'll use the ichdr in xfs_dir3_icfree_hdr
> to avoid extra operations to find the bests pointers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_node.c | 42 +++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 4e49ac64a2ff..6d67ceac48b7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1666,14 +1666,13 @@ xfs_dir2_node_add_datablk(
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
> @@ -1736,25 +1735,25 @@ xfs_dir2_node_add_datablk(
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
> @@ -1763,14 +1762,13 @@ xfs_dir2_node_add_datablk(
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
> @@ -1784,10 +1782,10 @@ xfs_dir2_node_find_freeblk(
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
> @@ -1814,13 +1812,12 @@ xfs_dir2_node_find_freeblk(
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
> @@ -1864,13 +1861,13 @@ xfs_dir2_node_find_freeblk(
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
> @@ -1904,6 +1901,7 @@ xfs_dir2_node_addname_int(
>  	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_buf		*dbp;		/* data block buffer */
>  	struct xfs_buf		*fbp;		/* freespace buffer */
>  	xfs_dir2_data_aoff_t	aoff;
> @@ -1918,8 +1916,8 @@ xfs_dir2_node_addname_int(
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
> @@ -1941,7 +1939,7 @@ xfs_dir2_node_addname_int(
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
