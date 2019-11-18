Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E396C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED6A222DD
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q7eCDlzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKRVWe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:22:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRVWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:22:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDuW2151491;
        Mon, 18 Nov 2019 21:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KkwPi1BtWfn7XlI8vMDR0rFTFioXRBRDAdxq+raTb48=;
 b=q7eCDlzhgcqZN1q3doeOvswyObkNsrKnH2Ftv1c+3SqnHVJKoUAZ5XdCDCYyc4C7yCaW
 1NQHtsEM79MnVOQv3pADu3l1kqmSYWKC8WYnbakNDEZBZkYjjlci1ZjHhpDym+kC0XDE
 TXBRG0T+2Hc5CyZvQ59qbEOh9gMmst1+7ps1e/Qqp8xYO060x2Ws/AdHbF7mKLT+5J/T
 zuHLoPM186winw+KLG0wUrcNzp91HXkfZfg0zA045Flie74feob+/J9XGcifjb+T0Qfg
 QFkdZlmuMfuoDCE07ab6B2Wbjwz7H98fMshfZ8r3r7sCV39kWsLv7jSMAa8BCjfqBh8z cQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqaw6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:22:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILE0FN162622;
        Mon, 18 Nov 2019 21:22:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wc0af80dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:22:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILMT91025649;
        Mon, 18 Nov 2019 21:22:29 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:22:28 -0800
Date:   Mon, 18 Nov 2019 13:22:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 3/9] xfs: remove the mappedbno argument to
 xfs_da_reada_buf
Message-ID: <20191118212227.GX6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-4-hch@lst.de>
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

On Sat, Nov 16, 2019 at 07:22:08PM +0100, Christoph Hellwig wrote:
> Replace the mappedbno argument with the simple flags for xfs_da_reada_buf
> and xfs_dir3_data_readahead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c  | 10 ++--------
>  fs/xfs/libxfs/xfs_da_btree.h  |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_data.c |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_priv.h |  4 ++--
>  fs/xfs/scrub/parent.c         |  2 +-
>  fs/xfs/xfs_dir2_readdir.c     |  3 ++-
>  fs/xfs/xfs_file.c             |  2 +-
>  7 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index c26f139bcf00..b1b0b38d7747 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2747,7 +2747,7 @@ int
>  xfs_da_reada_buf(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mappedbno,
> +	unsigned int		flags,
>  	int			whichfork,
>  	const struct xfs_buf_ops *ops)
>  {
> @@ -2756,14 +2756,9 @@ xfs_da_reada_buf(
>  	int			nmap;
>  	int			error;
>  
> -	if (mappedbno >= 0)
> -		return -EINVAL;
> -
>  	mapp = &map;
>  	nmap = 1;
> -	error = xfs_dabuf_map(dp, bno,
> -			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> -			whichfork, &mapp, &nmap);
> +	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
>  	if (error) {
>  		/* mapping a hole is not an error, but we don't continue */
>  		if (error == -ENOENT)
> @@ -2771,7 +2766,6 @@ xfs_da_reada_buf(
>  		goto out_free;
>  	}
>  
> -	mappedbno = mapp[0].bm_bn;
>  	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, ops);
>  
>  out_free:
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 9ec0d0243e96..4ba0ded7b973 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -218,8 +218,8 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
>  			       struct xfs_buf **bpp, int whichfork,
>  			       const struct xfs_buf_ops *ops);
>  int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
> -				xfs_daddr_t mapped_bno, int whichfork,
> -				const struct xfs_buf_ops *ops);
> +		unsigned int flags, int whichfork,
> +		const struct xfs_buf_ops *ops);
>  int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
>  					  struct xfs_buf *dead_buf);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 9e471a28b6c6..10680f6422c2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -417,10 +417,10 @@ int
>  xfs_dir3_data_readahead(
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		bno,
> -	xfs_daddr_t		mapped_bno)
> +	unsigned int		flags)
>  {
> -	return xfs_da_reada_buf(dp, bno, mapped_bno,
> -				XFS_DATA_FORK, &xfs_dir3_data_reada_buf_ops);
> +	return xfs_da_reada_buf(dp, bno, flags, XFS_DATA_FORK,
> +				&xfs_dir3_data_reada_buf_ops);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index a22222df4bf2..a730c5223c64 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -76,8 +76,8 @@ extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
>  		struct xfs_buf *bp);
>  extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
> -extern int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
> -		xfs_daddr_t mapped_bno);
> +int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
> +		unsigned int flags);
>  
>  extern struct xfs_dir2_data_free *
>  xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index c962bd534690..17100a83e23e 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -80,7 +80,7 @@ xchk_parent_count_parent_dentries(
>  	 */
>  	lock_mode = xfs_ilock_data_map_shared(parent);
>  	if (parent->i_d.di_nextents > 0)
> -		error = xfs_dir3_data_readahead(parent, 0, -1);
> +		error = xfs_dir3_data_readahead(parent, 0, 0);
>  	xfs_iunlock(parent, lock_mode);
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index b149cb4a4d86..f23f3b23ec37 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -315,7 +315,8 @@ xfs_dir2_leaf_readbuf(
>  				break;
>  			}
>  			if (next_ra > *ra_blk) {
> -				xfs_dir3_data_readahead(dp, next_ra, -2);
> +				xfs_dir3_data_readahead(dp, next_ra,
> +						        XFS_DABUF_MAP_HOLE_OK);
>  				*ra_blk = next_ra;
>  			}
>  			ra_want -= geo->fsbcount;
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 865543e41fb4..c93250108952 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1104,7 +1104,7 @@ xfs_dir_open(
>  	 */
>  	mode = xfs_ilock_data_map_shared(ip);
>  	if (ip->i_d.di_nextents > 0)
> -		error = xfs_dir3_data_readahead(ip, 0, -1);
> +		error = xfs_dir3_data_readahead(ip, 0, 0);
>  	xfs_iunlock(ip, mode);
>  	return error;
>  }
> -- 
> 2.20.1
> 
