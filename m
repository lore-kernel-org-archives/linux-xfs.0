Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B6ACA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACC9821721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 16:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XB3V+JtA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfJ1Q3b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:29:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34822 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732565AbfJ1Q3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 12:29:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGTLqg061591;
        Mon, 28 Oct 2019 16:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2rrzCIbD0Ci5QNGMFDlkyOlGc0VjfKuHSQvb49gtf0s=;
 b=XB3V+JtA30IJn4jnkOgllOQqSPICTvS/EHP6jIvDfJ0SxTmGVc9Rb3zEIjQ9Q9EIUeDq
 VBiEMb8fFaO+ItQgQQENDgq1R5GBDy2sl0HHNE4G4jFWzsRZDF04bfWWwOF1uR2k7c/1
 U0MXC9XCX6BMkC6j0It8P0RKGESYrPoA8mdBh5WOZ+T+gfviRUJY5v/oszq5SsOodzdN
 NHDwpQl816ezU2lK5Mk0J29mQfukpdk7BLLqsHAhQBpkiMvOw62QxYEdguT1k3ctRDL6
 Pl2tyJ9Ie7tPVaPyyq54Iu9ZyRdsAEQ00/EXUhG+mc29+kjV3/Vt3J3IlAbFBfDB7y41 Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vvdju39w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:29:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SGSDiD149674;
        Mon, 28 Oct 2019 16:29:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vwaky9muy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 16:29:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SGTOhI016659;
        Mon, 28 Oct 2019 16:29:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 09:29:24 -0700
Date:   Mon, 28 Oct 2019 09:29:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: refactor xfs_bmapi_allocate
Message-ID: <20191028162923.GF15222@magnolia>
References: <20191025150336.19411-1-hch@lst.de>
 <20191025150336.19411-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025150336.19411-7-hch@lst.de>
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

On Fri, Oct 25, 2019 at 05:03:34PM +0200, Christoph Hellwig wrote:
> Avoid duplicate userdata and data fork checks by restructuring the code
> so we only have a helper for userdata allocations that combines these
> checks in a straight foward way.  That also helps to obsoletes the
> comments explaining what the code does as it is now clearly obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 93 +++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ef75e223cb70..c278eff29e82 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3641,20 +3641,6 @@ xfs_bmap_btalloc(
>  	return 0;
>  }
>  
> -/*
> - * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
> - * It figures out where to ask the underlying allocator to put the new extent.
> - */
> -STATIC int
> -xfs_bmap_alloc(
> -	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> -{
> -	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> -	    xfs_alloc_is_userdata(ap->datatype))
> -		return xfs_bmap_rtalloc(ap);
> -	return xfs_bmap_btalloc(ap);
> -}
> -
>  /* Trim extent to fit a logical block range. */
>  void
>  xfs_trim_extent(
> @@ -4010,6 +3996,42 @@ xfs_bmapi_reserve_delalloc(
>  	return error;
>  }
>  
> +static int
> +xfs_bmap_alloc_userdata(
> +	struct xfs_bmalloca	*bma)
> +{
> +	struct xfs_mount	*mp = bma->ip->i_mount;
> +	int			whichfork = xfs_bmapi_whichfork(bma->flags);
> +	int			error;
> +
> +	/*
> +	 * Set the data type being allocated. For the data fork, the first data
> +	 * in the file is treated differently to all other allocations. For the
> +	 * attribute fork, we only need to ensure the allocated range is not on
> +	 * the busy list.
> +	 */
> +	bma->datatype = XFS_ALLOC_NOBUSY;
> +	if (bma->flags & XFS_BMAPI_ZERO)
> +		bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (bma->offset == 0)
> +			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> +		else
> +			bma->datatype |= XFS_ALLOC_USERDATA;
> +
> +		if (mp->m_dalign && bma->length >= mp->m_dalign) {
> +			error = xfs_bmap_isaeof(bma, whichfork);
> +			if (error)
> +				return error;
> +		}
> +
> +		if (XFS_IS_REALTIME_INODE(bma->ip))
> +			return xfs_bmap_rtalloc(bma);
> +	}
> +
> +	return xfs_bmap_btalloc(bma);
> +}
> +
>  static int
>  xfs_bmapi_allocate(
>  	struct xfs_bmalloca	*bma)
> @@ -4037,43 +4059,18 @@ xfs_bmapi_allocate(
>  					bma->got.br_startoff - bma->offset);
>  	}
>  
> -	/*
> -	 * Set the data type being allocated. For the data fork, the first data
> -	 * in the file is treated differently to all other allocations. For the
> -	 * attribute fork, we only need to ensure the allocated range is not on
> -	 * the busy list.
> -	 */
> -	if (!(bma->flags & XFS_BMAPI_METADATA)) {
> -		bma->datatype = XFS_ALLOC_NOBUSY;
> -		if (whichfork == XFS_DATA_FORK) {
> -			if (bma->offset == 0)
> -				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> -			else
> -				bma->datatype |= XFS_ALLOC_USERDATA;
> -		}
> -		if (bma->flags & XFS_BMAPI_ZERO)
> -			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
> -	}
> -
> -	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
> -
> -	/*
> -	 * Only want to do the alignment at the eof if it is userdata and
> -	 * allocation length is larger than a stripe unit.
> -	 */
> -	if (mp->m_dalign && bma->length >= mp->m_dalign &&
> -	    !(bma->flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
> -		error = xfs_bmap_isaeof(bma, whichfork);
> -		if (error)
> -			return error;
> -	}
> +	if (bma->flags & XFS_BMAPI_CONTIG)
> +		bma->minlen = bma->length;
> +	else
> +		bma->minlen = 1;
>  
> -	error = xfs_bmap_alloc(bma);
> -	if (error)
> +	if (bma->flags & XFS_BMAPI_METADATA)
> +		error = xfs_bmap_btalloc(bma);
> +	else
> +		error = xfs_bmap_alloc_userdata(bma);
> +	if (error || bma->blkno == NULLFSBLOCK)
>  		return error;
>  
> -	if (bma->blkno == NULLFSBLOCK)
> -		return 0;
>  	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
>  		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
>  	/*
> -- 
> 2.20.1
> 
