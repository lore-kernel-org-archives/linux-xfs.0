Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BED9C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96F6222DD
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CItKPpY1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfKRVVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:21:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59558 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKRVVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:21:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILE37Y177938;
        Mon, 18 Nov 2019 21:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pmNRKtWG5HGTnpLirqSpKCpbKfBi+MTmZfsLzamcWf8=;
 b=CItKPpY1hr9gmxKTxBrX1n2P0tjCh+PL5/SL7l8g1uC36/FyMw3jFOTtLabvW9z3jz6Q
 4Y0umNMQQQXxFNkUD9283ow3AXyPDSio85z/pYNmeHlI9zJZ3kSMT2CGAxnMi8AK9khc
 TvG184fqENNGztP6tks+pFzi2H52Bvj7VlqcZX32QNMzDgYUe9KkoIbgVb3wmd1uoqTw
 Pq1nykSLwNn2X2/ZS3AAgFbRcwWM/xL2SjTqTGxXLxgmXl6mEXGH00a8aoWbdIMCnNzP
 PZZrLennvVzmJ0xF8xiqVyy5ZDYZYniyJD2dtk3CnIdt57qR/RG3nd1W1xLWtRpZvsqZ 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8htk1bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:21:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILE3Mq162800;
        Mon, 18 Nov 2019 21:21:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wc0af7y8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:21:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAILLO4N017003;
        Mon, 18 Nov 2019 21:21:24 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:21:23 -0800
Date:   Mon, 18 Nov 2019 13:21:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/9] xfs: simplify mappedbno case from xfs_da_get_buf and
 xfs_da_read_buf
Message-ID: <20191118212122.GW6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:06PM +0100, Christoph Hellwig wrote:
> Shortcut the creation of xfs_bmbt_irec and xfs_buf_map for the case
> where the callers passed an already mapped xfs_daddr_t.  This is in
> preparation for splitting these cases out entirely later.  Also reject
> the mappedbno case for xfs_da_reada_buf as no callers currently uses
> it and it will be removed soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 103 +++++++++++++++++------------------
>  1 file changed, 51 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 46b1c3fb305c..681fba5731c2 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -110,6 +110,13 @@ xfs_da_state_free(xfs_da_state_t *state)
>  	kmem_zone_free(xfs_da_state_zone, state);
>  }
>  
> +static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
> +{
> +	if (whichfork == XFS_DATA_FORK)
> +		return mp->m_dir_geo->fsbcount;
> +	return mp->m_attr_geo->fsbcount;
> +}
> +
>  void
>  xfs_da3_node_hdr_from_disk(
>  	struct xfs_mount		*mp,
> @@ -2570,7 +2577,7 @@ xfs_dabuf_map(
>  	int			*nmaps)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> -	int			nfsb;
> +	int			nfsb = xfs_dabuf_nfsb(mp, whichfork);
>  	int			error = 0;
>  	struct xfs_bmbt_irec	irec;
>  	struct xfs_bmbt_irec	*irecs = &irec;
> @@ -2579,35 +2586,13 @@ xfs_dabuf_map(
>  	ASSERT(map && *map);
>  	ASSERT(*nmaps == 1);
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		nfsb = mp->m_dir_geo->fsbcount;
> -	else
> -		nfsb = mp->m_attr_geo->fsbcount;
> -
> -	/*
> -	 * Caller doesn't have a mapping.  -2 means don't complain
> -	 * if we land in a hole.
> -	 */
> -	if (mappedbno == -1 || mappedbno == -2) {
> -		/*
> -		 * Optimize the one-block case.
> -		 */
> -		if (nfsb != 1)
> -			irecs = kmem_zalloc(sizeof(irec) * nfsb,
> -					    KM_NOFS);
> -
> -		nirecs = nfsb;
> -		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
> -				       &nirecs, xfs_bmapi_aflag(whichfork));
> -		if (error)
> -			goto out;
> -	} else {
> -		irecs->br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno);
> -		irecs->br_startoff = (xfs_fileoff_t)bno;
> -		irecs->br_blockcount = nfsb;
> -		irecs->br_state = 0;
> -		nirecs = 1;
> -	}
> +	if (nfsb != 1)
> +		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
> +	nirecs = nfsb;
> +	error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
> +			       &nirecs, xfs_bmapi_aflag(whichfork));
> +	if (error)
> +		goto out;
>  
>  	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
>  		/* Caller ok with no mapping. */
> @@ -2648,24 +2633,29 @@ xfs_dabuf_map(
>   */
>  int
>  xfs_da_get_buf(
> -	struct xfs_trans	*trans,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
>  	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp,
>  	int			whichfork)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_buf		*bp;
> -	struct xfs_buf_map	map;
> -	struct xfs_buf_map	*mapp;
> -	int			nmap;
> +	struct xfs_buf_map	map, *mapp = &map;
> +	int			nmap = 1;
>  	int			error;
>  
>  	*bpp = NULL;
> -	mapp = &map;
> -	nmap = 1;
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> -				&mapp, &nmap);
> +
> +	if (mappedbno >= 0) {
> +		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, mappedbno,
> +				XFS_FSB_TO_BB(mp,
> +					xfs_dabuf_nfsb(mp, whichfork)), 0);
> +		goto done;
> +	}
> +
> +	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
>  		if (error == -1)
> @@ -2673,12 +2663,12 @@ xfs_da_get_buf(
>  		goto out_free;
>  	}
>  
> -	bp = xfs_trans_get_buf_map(trans, dp->i_mount->m_ddev_targp,
> -				    mapp, nmap, 0);
> +	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
> +done:
>  	error = bp ? bp->b_error : -EIO;
>  	if (error) {
>  		if (bp)
> -			xfs_trans_brelse(trans, bp);
> +			xfs_trans_brelse(tp, bp);
>  		goto out_free;
>  	}
>  
> @@ -2696,7 +2686,7 @@ xfs_da_get_buf(
>   */
>  int
>  xfs_da_read_buf(
> -	struct xfs_trans	*trans,
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
>  	xfs_daddr_t		mappedbno,
> @@ -2704,17 +2694,23 @@ xfs_da_read_buf(
>  	int			whichfork,
>  	const struct xfs_buf_ops *ops)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_buf		*bp;
> -	struct xfs_buf_map	map;
> -	struct xfs_buf_map	*mapp;
> -	int			nmap;
> +	struct xfs_buf_map	map, *mapp = &map;
> +	int			nmap = 1;
>  	int			error;
>  
>  	*bpp = NULL;
> -	mapp = &map;
> -	nmap = 1;
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> -				&mapp, &nmap);
> +
> +	if (mappedbno >= 0) {
> +		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> +				mappedbno, XFS_FSB_TO_BB(mp,
> +					xfs_dabuf_nfsb(mp, whichfork)),
> +				0, &bp, ops);
> +		goto done;
> +	}
> +
> +	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
>  		if (error == -1)
> @@ -2722,9 +2718,9 @@ xfs_da_read_buf(
>  		goto out_free;
>  	}
>  
> -	error = xfs_trans_read_buf_map(dp->i_mount, trans,
> -					dp->i_mount->m_ddev_targp,
> -					mapp, nmap, 0, &bp, ops);
> +	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
> +			&bp, ops);
> +done:
>  	if (error)
>  		goto out_free;
>  
> @@ -2756,6 +2752,9 @@ xfs_da_reada_buf(
>  	int			nmap;
>  	int			error;
>  
> +	if (mappedbno >= 0)
> +		return -EINVAL;
> +
>  	mapp = &map;
>  	nmap = 1;
>  	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> -- 
> 2.20.1
> 
