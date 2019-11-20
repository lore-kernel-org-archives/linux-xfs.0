Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD287C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1442208A1
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DjZOnLQQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfKTSRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:17:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbfKTSRQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 13:17:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKI9Pf4173489;
        Wed, 20 Nov 2019 18:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XKG/UD0BPFJWaiDaSuuNubRVRnwLTwICqIhPkkHLbtE=;
 b=DjZOnLQQkX4oDM+hkK77XXhAGb+DkotaWIK1Vq0L1r89O7iPuEStOaT/we0WSEXgajz2
 VLtr9iUMWy81J80M4ZvOW+aXGKYDJB0XXZ630PyxtwoDDA2HB+ZxaczwA2Ul9zR8zVlI
 L0jr8/mZmGaiH3/WDMVSHt2Eob/DjECc3e4eIXVa9L2oTxEcIhuQ9bAw04bHtmlmeYXS
 1DEzMjRQNSSaGnXudJWy7qkyrpFiSp09FHa9FFa6o6P9EqemND45NK3zXtEAbmwlL9Yd
 e9wWpJy07BKtuPe7wKR9h/S54F6JmRwWSLnSiV8R3KE0C5RahtOUCuL/TnIR9LeaHwZ2 Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wa92pyaq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:17:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKI8OZf021008;
        Wed, 20 Nov 2019 18:17:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47vjxpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:17:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIH9vM020801;
        Wed, 20 Nov 2019 18:17:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:17:09 -0800
Date:   Wed, 20 Nov 2019 10:17:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191120181708.GM6219@magnolia>
References: <20191120111727.16119-1-hch@lst.de>
 <20191120111727.16119-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120111727.16119-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 12:17:20PM +0100, Christoph Hellwig wrote:
> Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
> a hole is okay and not corruption, and return 0 with *nmap set to 0 to
> signal that case in the return value instead of a nameless -1 return
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 39 +++++++++++++-----------------------
>  fs/xfs/libxfs/xfs_da_btree.h |  3 +++
>  2 files changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e078817fc26c..d85dd99d28a3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2460,19 +2460,11 @@ xfs_da_shrink_inode(
>  	return error;
>  }
>  
> -/*
> - * Map the block we are given ready for reading. There are three possible return
> - * values:
> - *	-1 - will be returned if we land in a hole and mappedbno == -2 so the
> - *	     caller knows not to execute a subsequent read.
> - *	 0 - if we mapped the block successfully
> - *	>0 - positive error number if there was an error.
> - */
>  static int
>  xfs_dabuf_map(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
> +	unsigned int		flags,
>  	int			whichfork,
>  	struct xfs_buf_map	**mapp,
>  	int			*nmaps)
> @@ -2527,7 +2519,7 @@ xfs_dabuf_map(
>  
>  invalid_mapping:
>  	/* Caller ok with no mapping. */
> -	if (XFS_IS_CORRUPT(mp, mappedbno != -2)) {
> +	if (XFS_IS_CORRUPT(mp, !flags & XFS_DABUF_MAP_HOLE_OK)) {
>  		error = -EFSCORRUPTED;
>  		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
>  			xfs_alert(mp, "%s: bno %u inode %llu",
> @@ -2575,13 +2567,11 @@ xfs_da_get_buf(
>  		goto done;
>  	}
>  
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
> -	if (error) {
> -		/* mapping a hole is not an error, but we don't continue */
> -		if (error == -1)
> -			error = 0;
> +	error = xfs_dabuf_map(dp, bno,
> +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> +			whichfork, &mapp, &nmap);
> +	if (error || nmap == 0)
>  		goto out_free;
> -	}
>  
>  	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
>  done:
> @@ -2630,13 +2620,11 @@ xfs_da_read_buf(
>  		goto done;
>  	}
>  
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
> -	if (error) {
> -		/* mapping a hole is not an error, but we don't continue */
> -		if (error == -1)
> -			error = 0;
> +	error = xfs_dabuf_map(dp, bno,
> +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> +			whichfork, &mapp, &nmap);
> +	if (error || !nmap)
>  		goto out_free;
> -	}
>  
>  	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
>  			&bp, ops);
> @@ -2677,11 +2665,12 @@ xfs_da_reada_buf(
>  
>  	mapp = &map;
>  	nmap = 1;
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> -				&mapp, &nmap);
> +	error = xfs_dabuf_map(dp, bno,
> +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> +			whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
> -		if (error == -1)
> +		if (error == -ENOENT)

Shouldn't this turn into:

if (error || !nmap)
	goto out_free;

Otherwise looks ok to me.

--D

>  			error = 0;
>  		goto out_free;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index ed3b558a9c1a..64624d5717c9 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -194,6 +194,9 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  /*
>   * Utility routines.
>   */
> +
> +#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
> +
>  int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
>  int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
>  			      int count);
> -- 
> 2.20.1
> 
