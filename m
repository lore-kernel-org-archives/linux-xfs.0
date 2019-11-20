Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22636C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89E921826
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 19:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YkvE7XmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKTTCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:02:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42378 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfKTTCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 14:02:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIxJcc030821;
        Wed, 20 Nov 2019 19:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Q8/JIru4OPKN1alCneafvdDzeexSyfe/V4AlaCZyQE0=;
 b=YkvE7XmZt6l0U1vnE+o0g5FGS30G08vRI/q5cOWidpg52su7uJkIDITaBpC9AGyQtVFx
 0uVUZUGwQju9zEdQzxBlTDHkyFG0yMUojHD6T4PCseAFdJKBQbQwffa46D3XuJku9RzU
 j9SJetYDOoXeUEChbAP5G9JhzNneN/+mDWl2kBEFqAXUkdGnXcHtBxfuen9owbhiet4a
 R3G0v8+OQICTRtY+Aw9hHIzlP8vZy6BQkJgC4NM1L5m/dqI9XM/pJNbJHf3UoScB78R3
 8SnqMWcaIPCBpMBuJ6j4r52RbcQ/wKfccIeeIi3O0evSPah0SI/R6GZBPeII3SS0Fl/M Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wa8htykaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:02:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIwso0016091;
        Wed, 20 Nov 2019 19:02:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wd46wx0uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 19:02:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKJ2891016330;
        Wed, 20 Nov 2019 19:02:08 GMT
Received: from localhost (/10.159.246.236)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 11:02:07 -0800
Date:   Wed, 20 Nov 2019 11:02:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191120190206.GS6219@magnolia>
References: <20191120111727.16119-1-hch@lst.de>
 <20191120111727.16119-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120111727.16119-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200157
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

Also I totally forgot to mention this flags test ^^^^^^^^ probably
should have parentheses...

--D

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
