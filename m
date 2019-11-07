Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1815BC5DF61
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9412187F
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sCnfHUyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfKGWmF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:42:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfKGWmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 17:42:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Mdt4o085297;
        Thu, 7 Nov 2019 22:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PgTlRmB4khjTm5jmQY4Txewmm1w1C33ofMZ8IfUtt98=;
 b=sCnfHUyF5rA6jNLm/XHbxaa13/FG3gfGef5nN0mFwZMKeXUaJWUITSrZZav9pf23kZ/P
 OsxORb1oaKHyKIyY4eCIDpsYxQtb7iAE9YwprD9Ae0CcaVEnUiC9UmzES97BrWe1B4wS
 z4IaRbXDQUliVeGTItfIqZSKwjqBkMQkA8IAsSVkrWU/zlGJJRvNSbu8/Xq13Now6oFv
 bCnqUFDChpki9QRkRhjgA6EGPvJhN4M/xU5opLKgJpc1iYVKSAL0J9aw9ojlh7FJDv/h
 2Cninr7Vv50APjJVaV60QfbHdBbG5Gn9jJ95w4E2FfncD8EvV8aDW5QrxVcUZ8naNOhn bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w19ggr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:42:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Mcb9V104997;
        Thu, 7 Nov 2019 22:42:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w41wayrgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:41:59 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7Mfwkn007041;
        Thu, 7 Nov 2019 22:41:58 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 14:41:57 -0800
Date:   Thu, 7 Nov 2019 14:41:57 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/46] xfs: cleanup xfs_dir2_leaf_getdents
Message-ID: <20191107224157.GL6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-31-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-31-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:54PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_dir2_readdir.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 0d234b649d65..c4314e9e3dd8 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -351,13 +351,13 @@ xfs_dir2_leaf_getdents(
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */

gcc complained about this variable being set but not used.

>  	xfs_dir2_data_entry_t	*dep;		/* data entry */
>  	xfs_dir2_data_unused_t	*dup;		/* unused entry */
> -	char			*ptr = NULL;	/* pointer to current data */
>  	struct xfs_da_geometry	*geo = args->geo;
>  	xfs_dablk_t		rablk = 0;	/* current readahead block */
>  	xfs_dir2_off_t		curoff;		/* current overall offset */
>  	int			length;		/* temporary length value */
>  	int			byteoff;	/* offset in current block */
>  	int			lock_mode;
> +	unsigned int		offset = 0;

This is the offset within the block, right?

>  	int			error = 0;	/* error return value */
>  
>  	/*
> @@ -384,7 +384,7 @@ xfs_dir2_leaf_getdents(
>  		 * If we have no buffer, or we're off the end of the
>  		 * current buffer, need to get another one.
>  		 */
> -		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> +		if (!bp || offset + geo->blksize) {

                           ^^^^^^^^^^^^^^^^^^^^^

In which case, isn't this always true?  Was this supposed to be
offset >= geo->blksize?

--D

>  			if (bp) {
>  				xfs_trans_brelse(args->trans, bp);
>  				bp = NULL;
> @@ -402,7 +402,7 @@ xfs_dir2_leaf_getdents(
>  			/*
>  			 * Find our position in the block.
>  			 */
> -			ptr = (char *)dp->d_ops->data_entry_p(hdr);
> +			offset = dp->d_ops->data_entry_offset;
>  			byteoff = xfs_dir2_byte_to_off(geo, curoff);
>  			/*
>  			 * Skip past the header.
> @@ -413,20 +413,20 @@ xfs_dir2_leaf_getdents(
>  			 * Skip past entries until we reach our offset.
>  			 */
>  			else {
> -				while ((char *)ptr - (char *)hdr < byteoff) {
> -					dup = (xfs_dir2_data_unused_t *)ptr;
> +				while (offset < byteoff) {
> +					dup = bp->b_addr + offset;
>  
>  					if (be16_to_cpu(dup->freetag)
>  						  == XFS_DIR2_DATA_FREE_TAG) {
>  
>  						length = be16_to_cpu(dup->length);
> -						ptr += length;
> +						offset += length;
>  						continue;
>  					}
> -					dep = (xfs_dir2_data_entry_t *)ptr;
> +					dep = bp->b_addr + offset;
>  					length =
>  					   dp->d_ops->data_entsize(dep->namelen);
> -					ptr += length;
> +					offset += length;
>  				}
>  				/*
>  				 * Now set our real offset.
> @@ -434,28 +434,28 @@ xfs_dir2_leaf_getdents(
>  				curoff =
>  					xfs_dir2_db_off_to_byte(geo,
>  					    xfs_dir2_byte_to_db(geo, curoff),
> -					    (char *)ptr - (char *)hdr);
> -				if (ptr >= (char *)hdr + geo->blksize) {
> +					    offset);
> +				if (offset >= geo->blksize)
>  					continue;
> -				}
>  			}
>  		}
> +
>  		/*
> -		 * We have a pointer to an entry.
> -		 * Is it a live one?
> +		 * We have a pointer to an entry.  Is it a live one?
>  		 */
> -		dup = (xfs_dir2_data_unused_t *)ptr;
> +		dup = bp->b_addr + offset;
> +
>  		/*
>  		 * No, it's unused, skip over it.
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
>  			length = be16_to_cpu(dup->length);
> -			ptr += length;
> +			offset += length;
>  			curoff += length;
>  			continue;
>  		}
>  
> -		dep = (xfs_dir2_data_entry_t *)ptr;
> +		dep = bp->b_addr + offset;
>  		length = dp->d_ops->data_entsize(dep->namelen);
>  		filetype = dp->d_ops->data_get_ftype(dep);
>  
> @@ -474,7 +474,7 @@ xfs_dir2_leaf_getdents(
>  		/*
>  		 * Advance to next entry in the block.
>  		 */
> -		ptr += length;
> +		offset += length;
>  		curoff += length;
>  		/* bufsize may have just been a guess; don't go negative */
>  		bufsize = bufsize > length ? bufsize - length : 0;
> -- 
> 2.20.1
> 
