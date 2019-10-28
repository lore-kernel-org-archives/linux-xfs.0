Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077A7CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C346921783
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oDeThJfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbfJ1Qbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:31:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbfJ1Qbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:31:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTLqp061591;
        Mon, 28 Oct 2019 16:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=XbN8NOcebqEobfiUwrPgDf/cl3n/NXvEmbyICjBL/Ik=;
 b=oDeThJfjpgkAj+9v8dJ7TeesLRgZm2R8FA7KQJFPcXbdc7SLkq4+ff9FeNOWYjyEroGJ
 aojwnuzIKoMBF+E8GRcGF2vTCIzoyFTKH3G/B3ZG28ECK/ZWhFyzgydpWynuStwJzOIN
 xu8PUopAOwd1r0FgumBP7dLmy78CJy7V5C0LsWTTKTN58rRMX+cOw2jh9S2je1goJGN5
 aTWMGJiUKM3Y/APNNJ0WPSJcFLVbnmcOdLXLAS4ilOarRPtog6Zzyrvw6fH0pO0O8ne1
 U3U6+AvjRZNg3f0aQpkp1zAFUgDix218sgaDTjJsGOaqmKriHIm5FBVyUdTNFTBggiHD yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vvdju3acd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:31:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGSCmM149626;
        Mon, 28 Oct 2019 16:31:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vwaky9s01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:31:41 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SGVdHL018072;
        Mon, 28 Oct 2019 16:31:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:31:39 -0700
Date:   Mon, 28 Oct 2019 09:31:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: move extent zeroing to xfs_bmapi_allocate
Message-ID: <20191028163136.GG15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-8-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 05:03:35PM +0200, Christoph Hellwig wrote:
> Move the extent zeroing case there for the XFS_BMAPI_ZERO flag outside
> the low-level allocator and into xfs_bmapi_allocate, where is still
> is in transaction context, but outside the very lowlevel code where
> it doesn't belong.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c |  7 -------
>  fs/xfs/libxfs/xfs_alloc.h |  4 +---
>  fs/xfs/libxfs/xfs_bmap.c  | 10 ++++++----
>  fs/xfs/xfs_bmap_util.c    |  7 -------
>  4 files changed, 7 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 925eba9489d5..ff6454887ff3 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3083,13 +3083,6 @@ xfs_alloc_vextent(
>  			args->len);
>  #endif
>  
> -		/* Zero the extent if we were asked to do so */
> -		if (args->datatype & XFS_ALLOC_USERDATA_ZERO) {
> -			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
> -			if (error)
> -				goto error0;
> -		}
> -
>  	}
>  	xfs_perag_put(args->pag);
>  	return 0;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index d6ed5d2c07c2..626384d75c9c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -54,7 +54,6 @@ typedef struct xfs_alloc_arg {
>  	struct xfs_mount *mp;		/* file system mount point */
>  	struct xfs_buf	*agbp;		/* buffer for a.g. freelist header */
>  	struct xfs_perag *pag;		/* per-ag struct for this agno */
> -	struct xfs_inode *ip;		/* for userdata zeroing method */
>  	xfs_fsblock_t	fsbno;		/* file system block number */
>  	xfs_agnumber_t	agno;		/* allocation group number */
>  	xfs_agblock_t	agbno;		/* allocation group-relative block # */
> @@ -83,8 +82,7 @@ typedef struct xfs_alloc_arg {
>   */
>  #define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
>  #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
> -#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
> -#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
> +#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
>  
>  static inline bool
>  xfs_alloc_is_userdata(int datatype)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c278eff29e82..6ec3c48abc1b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3555,8 +3555,6 @@ xfs_bmap_btalloc(
>  	args.wasdel = ap->wasdel;
>  	args.resv = XFS_AG_RESV_NONE;
>  	args.datatype = ap->datatype;
> -	if (ap->datatype & XFS_ALLOC_USERDATA_ZERO)
> -		args.ip = ap->ip;
>  
>  	error = xfs_alloc_vextent(&args);
>  	if (error)
> @@ -4011,8 +4009,6 @@ xfs_bmap_alloc_userdata(
>  	 * the busy list.
>  	 */
>  	bma->datatype = XFS_ALLOC_NOBUSY;
> -	if (bma->flags & XFS_BMAPI_ZERO)
> -		bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
>  	if (whichfork == XFS_DATA_FORK) {
>  		if (bma->offset == 0)
>  			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> @@ -4071,6 +4067,12 @@ xfs_bmapi_allocate(
>  	if (error || bma->blkno == NULLFSBLOCK)
>  		return error;
>  
> +	if (bma->flags & XFS_BMAPI_ZERO) {
> +		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
> +		if (error)
> +			return error;
> +	}
> +
>  	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
>  		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
>  	/*
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 44d6b6469303..e418f9922bb1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -165,13 +165,6 @@ xfs_bmap_rtalloc(
>  		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
>  			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
>  					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
> -
> -		/* Zero the extent if we were asked to do so */
> -		if (ap->datatype & XFS_ALLOC_USERDATA_ZERO) {
> -			error = xfs_zero_extent(ap->ip, ap->blkno, ap->length);
> -			if (error)
> -				return error;
> -		}
>  	} else {
>  		ap->length = 0;
>  	}
> -- 
> 2.20.1
> 
