Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A975CC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 23:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82792206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 23:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T4vg9CLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgGOXzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 19:55:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58106 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOXzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 19:55:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FNg0xW015675;
        Wed, 15 Jul 2020 23:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=grmgd9YcY0TmHc52gWARWJYj/C2KpRrVT1PnUey1vn4=;
 b=T4vg9CLtaDybKMvFQrLR1vFN9a8b1HWLKs58Cn+7y432PVlyjIMOggsJrK35Y2ao97Oz
 UwUwNfOCUaBZs26VcURfs5+YpuoLDdorcbauT3KbQlAHqqmVZdgttbKjGShVFfU/3Cdn
 NJcgTThOJXvUEZnFwlTOsYyNTZXAOLolrQGnwOenX0x4A7DXKIpc/OW6ZSZ228VvyuqY
 W1v9J5Og0jIQ4+HKCtXOdjkTrdrM2b16XTHt60ourKYjbV+hfa+3qJofPV6HN86uczys
 B/s9eZT0P/4gP6s7FKOwGOfUMibkz0X/oWqaU+WKGNWfWUEonmz6hdh2ign4bCEYSknu iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 327s65mka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 23:55:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FNbfvN020241;
        Wed, 15 Jul 2020 23:55:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0s8beq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 23:55:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FNtF0b016227;
        Wed, 15 Jul 2020 23:55:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 16:55:15 -0700
Date:   Wed, 15 Jul 2020 16:55:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: simplify bmap_next_offset
Message-ID: <20200715235514.GG3151642@magnolia>
References: <20200715183417.79701-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715183417.79701-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 08:34:17PM +0200, Christoph Hellwig wrote:
> The tp argument is always NULL, and the whichfork argument is always
> XFS_DATA_FORK, so simplify and cleanup the function based on those
> assumptions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me has nearly the same code change in his 5.8 sync branch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  repair/phase6.c | 51 +++++++++++++++++++++++--------------------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 446bcfcb7..952af590f 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -406,46 +406,43 @@ dir_hash_dup_names(dir_hash_tab_t *hashtab)
>  }
>  
>  /*
> - * Given a block number in a fork, return the next valid block number
> - * (not a hole).
> - * If this is the last block number then NULLFILEOFF is returned.
> - *
> - * This was originally in the kernel, but only used in xfs_repair.
> + * Given a block number in a fork, return the next valid block number (not a
> + * hole).  If this is the last block number then NULLFILEOFF is returned.
>   */
>  static int
>  bmap_next_offset(
> -	xfs_trans_t	*tp,			/* transaction pointer */
> -	xfs_inode_t	*ip,			/* incore inode */
> -	xfs_fileoff_t	*bnop,			/* current block */
> -	int		whichfork)		/* data or attr fork */
> +	struct xfs_inode	*ip,
> +	xfs_fileoff_t		*bnop)
>  {
> -	xfs_fileoff_t	bno;			/* current block */
> -	int		error;			/* error return value */
> -	xfs_bmbt_irec_t got;			/* current extent value */
> -	struct xfs_ifork	*ifp;		/* inode fork pointer */
> +	xfs_fileoff_t		bno;
> +	int			error;
> +	struct xfs_bmbt_irec	got;	
>  	struct xfs_iext_cursor	icur;
>  
> -	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> -	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> -	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> -	       return EIO;
> -	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
> +	switch (ip->i_d.di_format) {
> +	case XFS_DINODE_FMT_LOCAL:
>  		*bnop = NULLFILEOFF;
>  		return 0;
> +	case XFS_DINODE_FMT_BTREE:
> +	case XFS_DINODE_FMT_EXTENTS:
> +		break;
> +	default:
> +		return EIO;
> +	}
> +
> +	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
> +		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error)
> +			return error;
>  	}
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
> -	    (error = -libxfs_iread_extents(tp, ip, whichfork)))
> -		return error;
>  	bno = *bnop + 1;
> -	if (!libxfs_iext_lookup_extent(ip, ifp, bno, &icur, &got))
> +	if (!libxfs_iext_lookup_extent(ip, &ip->i_df, bno, &icur, &got))
>  		*bnop = NULLFILEOFF;
>  	else
>  		*bnop = got.br_startoff < bno ? bno : got.br_startoff;
>  	return 0;
>  }
>  
> -
>  static void
>  res_failed(
>  	int	err)
> @@ -2054,7 +2051,7 @@ longform_dir2_check_node(
>  			next_da_bno != NULLFILEOFF && da_bno < mp->m_dir_geo->freeblk;
>  			da_bno = (xfs_dablk_t)next_da_bno) {
>  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> -		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> +		if (bmap_next_offset(ip, &next_da_bno))
>  			break;
>  
>  		/*
> @@ -2129,7 +2126,7 @@ longform_dir2_check_node(
>  	     next_da_bno != NULLFILEOFF;
>  	     da_bno = (xfs_dablk_t)next_da_bno) {
>  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> -		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
> +		if (bmap_next_offset(ip, &next_da_bno))
>  			break;
>  
>  		error = dir_read_buf(ip, da_bno, &bp, &xfs_dir3_free_buf_ops,
> @@ -2261,7 +2258,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  		struct xfs_dir2_data_hdr *d;
>  
>  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> -		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) {
> +		if (bmap_next_offset(ip, &next_da_bno)) {
>  			/*
>  			 * if this is the first block, there isn't anything we
>  			 * can recover so we just trash it.
> -- 
> 2.27.0
> 
