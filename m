Return-Path: <SRS0=Bs8E=ZJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64666C432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 18:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296422068F
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 18:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N/bvU8D+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfKQSff (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 13:35:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfKQSff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Nov 2019 13:35:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHITGXa090539;
        Sun, 17 Nov 2019 18:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Nrh1hvwF+llOPU/mjiUiZwRAC6cvdpP8Rc5rZxu/Fsk=;
 b=N/bvU8D+BvbeMduG1haxS3txJlk+hbqwg2R0fBrPkF36iCgid104dI0moBwpmQ1l+LoG
 ABMbVIxQ6pKSZfVl8s8SkxJYpjuol83zov78y1cPmP1U0ogTjZ67xdw5bidQLPaEnkfB
 UZeOLBSguYdpO0gD/Ai0t5yS5kKREeJRD6UZ0XRiWFRf0WuF+sRpMSe6CSmVfqRRV1JI
 KmvOLMtgkILquov5ap1FmFD+1iLZgEydVRnkcuYiJBletEjbUcbYmviBzHMYHE41VvQg
 xi58JjvPh1AURyJgHR4OqOTYdOXdtavmm0cgkg2ILZOHkMyMGfVHXU3uWknKyO7qfShb zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wa9rq457h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 18:35:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHIT1F5074549;
        Sun, 17 Nov 2019 18:35:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2watmm5ext-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 18:35:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAHIZNtq023790;
        Sun, 17 Nov 2019 18:35:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Nov 2019 10:35:22 -0800
Date:   Sun, 17 Nov 2019 10:35:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/9] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191117183521.GT6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911170176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911170176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:07PM +0100, Christoph Hellwig wrote:
> Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
> a hole is okay and not corruption, and return -ENOENT instead of the
> nameless -1 to signal that case in the return value.

Why not set *nirecs = 0 and return 0 like we sometimes do for bmap
lookups?

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 25 +++++++++++++++----------
>  fs/xfs/libxfs/xfs_da_btree.h |  3 +++
>  2 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 681fba5731c2..c26f139bcf00 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2571,7 +2571,7 @@ static int
>  xfs_dabuf_map(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
> +	unsigned int		flags,
>  	int			whichfork,
>  	struct xfs_buf_map	**map,
>  	int			*nmaps)
> @@ -2596,8 +2596,8 @@ xfs_dabuf_map(
>  
>  	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
>  		/* Caller ok with no mapping. */
> -		if (mappedbno == -2) {
> -			error = -1;
> +		if (flags & XFS_DABUF_MAP_HOLE_OK) {
> +			error = -ENOENT;
>  			goto out;
>  		}
>  
> @@ -2655,10 +2655,12 @@ xfs_da_get_buf(
>  		goto done;
>  	}
>  
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
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
> @@ -2710,10 +2712,12 @@ xfs_da_read_buf(
>  		goto done;
>  	}
>  
> -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
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
> @@ -2757,11 +2761,12 @@ xfs_da_reada_buf(
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
> index 5af4df71e92b..9ec0d0243e96 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -204,6 +204,9 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
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
