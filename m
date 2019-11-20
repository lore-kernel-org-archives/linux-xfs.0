Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D51C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B8F206DA
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 18:24:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BdP0ZfR+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfKTSYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:24:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfKTSYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 13:24:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIL13P193950;
        Wed, 20 Nov 2019 18:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pzr33FnmFgeJ9lZRFXJ8HHS4EW568kcnBIomKbw1GEw=;
 b=BdP0ZfR+7HHOhZZ1YFeknMpGgDpTCMXIs5oS8t3Fq1Gg8TyxL+eyC2gN3a7QsOy87t8Y
 14rXhHgsoXyb30l2kRCts/l7JP/FyMcME8n4WZ0tE5vT7aRzIWiJ4Y6zHPD/4m6gdH/G
 rbqxiYqzbRHDIVY0cwsEjmCNkTfyqQ629CUdnvlUVfUoSFS9Xb1z7L+5cSk5ir8p7ZPe
 Js2ORStuXzb8X4oQGODdEfkzY6sDO8XIZBHFQvVx1+9ASvPAiYrwJyMaJvar+LQ/Ku/z
 PQrqovpaM6M2kgITZoQJ/h4c1u8XxX9r5OfbudqV15VCMmho1/UGsjuPlvTYm7hGdWlE hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htyd9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:24:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIKfCr056548;
        Wed, 20 Nov 2019 18:24:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2wd47vk717-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:24:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIOYJg026332;
        Wed, 20 Nov 2019 18:24:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:24:33 -0800
Date:   Wed, 20 Nov 2019 10:24:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 02/10] xfs: refactor xfs_dabuf_map
Message-ID: <20191120182432.GN6219@magnolia>
References: <20191120111727.16119-1-hch@lst.de>
 <20191120111727.16119-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120111727.16119-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 12:17:19PM +0100, Christoph Hellwig wrote:
> Merge xfs_buf_map_from_irec and xfs_da_map_covers_blocks into a single
> loop in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 156 ++++++++++++-----------------------
>  1 file changed, 54 insertions(+), 102 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index f3087f061a48..e078817fc26c 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2460,74 +2460,6 @@ xfs_da_shrink_inode(
>  	return error;
>  }
>  
> -/*
> - * See if the mapping(s) for this btree block are valid, i.e.
> - * don't contain holes, are logically contiguous, and cover the whole range.
> - */
> -STATIC int
> -xfs_da_map_covers_blocks(
> -	int		nmap,
> -	xfs_bmbt_irec_t	*mapp,
> -	xfs_dablk_t	bno,
> -	int		count)
> -{
> -	int		i;
> -	xfs_fileoff_t	off;
> -
> -	for (i = 0, off = bno; i < nmap; i++) {
> -		if (mapp[i].br_startblock == HOLESTARTBLOCK ||
> -		    mapp[i].br_startblock == DELAYSTARTBLOCK) {
> -			return 0;
> -		}
> -		if (off != mapp[i].br_startoff) {
> -			return 0;
> -		}
> -		off += mapp[i].br_blockcount;
> -	}
> -	return off == bno + count;
> -}
> -
> -/*
> - * Convert a struct xfs_bmbt_irec to a struct xfs_buf_map.
> - *
> - * For the single map case, it is assumed that the caller has provided a pointer
> - * to a valid xfs_buf_map.  For the multiple map case, this function will
> - * allocate the xfs_buf_map to hold all the maps and replace the caller's single
> - * map pointer with the allocated map.
> - */
> -static int
> -xfs_buf_map_from_irec(
> -	struct xfs_mount	*mp,
> -	struct xfs_buf_map	**mapp,
> -	int			*nmaps,
> -	struct xfs_bmbt_irec	*irecs,
> -	int			nirecs)
> -{
> -	struct xfs_buf_map	*map;
> -	int			i;
> -
> -	ASSERT(*nmaps == 1);
> -	ASSERT(nirecs >= 1);
> -
> -	if (nirecs > 1) {
> -		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
> -				  KM_NOFS);
> -		if (!map)
> -			return -ENOMEM;
> -		*mapp = map;
> -	}
> -
> -	*nmaps = nirecs;
> -	map = *mapp;
> -	for (i = 0; i < *nmaps; i++) {
> -		ASSERT(irecs[i].br_startblock != DELAYSTARTBLOCK &&
> -		       irecs[i].br_startblock != HOLESTARTBLOCK);
> -		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, irecs[i].br_startblock);
> -		map[i].bm_len = XFS_FSB_TO_BB(mp, irecs[i].br_blockcount);
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Map the block we are given ready for reading. There are three possible return
>   * values:
> @@ -2542,58 +2474,78 @@ xfs_dabuf_map(
>  	xfs_dablk_t		bno,
>  	xfs_daddr_t		mappedbno,
>  	int			whichfork,
> -	struct xfs_buf_map	**map,
> +	struct xfs_buf_map	**mapp,
>  	int			*nmaps)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
>  	int			nfsb = xfs_dabuf_nfsb(mp, whichfork);
> -	int			error = 0;
> -	struct xfs_bmbt_irec	irec;
> -	struct xfs_bmbt_irec	*irecs = &irec;
> -	int			nirecs;
> -
> -	ASSERT(map && *map);
> -	ASSERT(*nmaps == 1);
> +	struct xfs_bmbt_irec	irec, *irecs = &irec;
> +	struct xfs_buf_map	*map = *mapp;
> +	xfs_fileoff_t		off = bno;
> +	int			error = 0, nirecs, i;
>  
> -	if (nfsb != 1)
> +	if (nfsb > 1)
>  		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
> +
>  	nirecs = nfsb;
> -	error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
> -			       &nirecs, xfs_bmapi_aflag(whichfork));
> +	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
> +			xfs_bmapi_aflag(whichfork));
>  	if (error)
> -		goto out;
> +		goto out_free_irecs;
>  
> -	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
> -		/* Caller ok with no mapping. */
> -		if (!XFS_IS_CORRUPT(mp, mappedbno != -2)) {
> -			error = -1;
> -			goto out;
> -		}
> +	/*
> +	 * Use the caller provided map for the single map case, else allocate a
> +	 * larger one that needs to be free by the caller.
> +	 */
> +	if (nirecs > 1) {
> +		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
> +		if (!map)
> +			goto out_free_irecs;
> +		*mapp = map;
> +	}
>  
> -		/* Caller expected a mapping, so abort. */
> +	for (i = 0; i < nirecs; i++) {
> +		if (irecs[i].br_startblock == HOLESTARTBLOCK ||
> +		    irecs[i].br_startblock == DELAYSTARTBLOCK)
> +			goto invalid_mapping;
> +		if (off != irecs[i].br_startoff)
> +			goto invalid_mapping;
> +
> +		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, irecs[i].br_startblock);
> +		map[i].bm_len = XFS_FSB_TO_BB(mp, irecs[i].br_blockcount);
> +		off += irecs[i].br_blockcount;
> +	}
> +
> +	if (off != bno + nfsb)
> +		goto invalid_mapping;
> +
> +	*nmaps = nirecs;
> +out_free_irecs:
> +	if (irecs != &irec)
> +		kmem_free(irecs);
> +	return error;
> +
> +invalid_mapping:
> +	/* Caller ok with no mapping. */
> +	if (XFS_IS_CORRUPT(mp, mappedbno != -2)) {
> +		error = -EFSCORRUPTED;
>  		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
> -			int i;
> +			xfs_alert(mp, "%s: bno %u inode %llu",
> +					__func__, bno, dp->i_ino);
>  
> -			xfs_alert(mp, "%s: bno %lld dir: inode %lld", __func__,
> -					(long long)bno, (long long)dp->i_ino);
> -			for (i = 0; i < *nmaps; i++) {
> +			for (i = 0; i < nirecs; i++) {
>  				xfs_alert(mp,
>  "[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d",
> -					i,
> -					(long long)irecs[i].br_startoff,
> -					(long long)irecs[i].br_startblock,
> -					(long long)irecs[i].br_blockcount,
> +					i, irecs[i].br_startoff,
> +					irecs[i].br_startblock,
> +					irecs[i].br_blockcount,
>  					irecs[i].br_state);
>  			}
>  		}
> -		error = -EFSCORRUPTED;
> -		goto out;
> +	} else {
> +		*nmaps = 0;
>  	}
> -	error = xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);
> -out:
> -	if (irecs != &irec)
> -		kmem_free(irecs);
> -	return error;
> +	goto out_free_irecs;
>  }
>  
>  /*
> -- 
> 2.20.1
> 
