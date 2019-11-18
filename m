Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F412C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 349EE222DD
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZzlWzsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfKRVXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:23:38 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKRVXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:23:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDtdF151467;
        Mon, 18 Nov 2019 21:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=/BpDGEzAqEWJLJIjppyjE4OoKmT86ygsE8cjKlNugn0=;
 b=aZzlWzspqD+qf9ndty4x367Us/9kqV6kGcwJzHTf2zV4w02KcSFHrS40U+8p0RaADKll
 hlIuds/HFh578DhuNiQ+1//u55JCBpaRYiSP4RaSE2cUy4X8AtSwIsnVmrPbmaNpst1A
 81m1T0VSQTDxbad/z1RRowYXUh6PwmDoCEdvvW3bBgx86yizGQv1ooaBzxXiIGW3RobG
 LRjdzM0pD/Su1mRWQtMapyGF1pjyGLLolskuvLUotnhWDMwWWdZ7xr2qqjkr3rpoWurT
 HoYsBeaW1hhq2cWBIqd+S450EzLtbIV0NLhGplo9i00fXADV/FM6DUCUlnW0kFR/yMnc GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqawdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDeLg135477;
        Mon, 18 Nov 2019 21:23:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wc09w84px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILNXmJ026244;
        Mon, 18 Nov 2019 21:23:33 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:23:33 -0800
Date:   Mon, 18 Nov 2019 13:23:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 5/9] xfs: remove the mappedbno argument to
 xfs_dir3_leaf_read
Message-ID: <20191118212332.GA6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:10PM +0100, Christoph Hellwig wrote:
> This argument is always hard coded to -1, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 9 ++++-----
>  fs/xfs/libxfs/xfs_dir2_priv.h | 4 ++--
>  fs/xfs/scrub/dir.c            | 2 +-
>  3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index e2e4b2c6d6c2..2eee4e299e19 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -262,13 +262,12 @@ xfs_dir3_leaf_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		fbno,
> -	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp)
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
> -				XFS_DATA_FORK, &xfs_dir3_leaf1_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
> +			&xfs_dir3_leaf1_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAF1_BUF);
>  	return err;
> @@ -639,7 +638,7 @@ xfs_dir2_leaf_addname(
>  
>  	trace_xfs_dir2_leaf_addname(args);
>  
> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
>  	if (error)
>  		return error;
>  
> @@ -1230,7 +1229,7 @@ xfs_dir2_leaf_lookup_int(
>  	tp = args->trans;
>  	mp = dp->i_mount;
>  
> -	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, -1, &lbp);
> +	error = xfs_dir3_leaf_read(tp, dp, args->geo->leafblk, &lbp);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index a730c5223c64..ade41556901a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -91,8 +91,8 @@ void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
>  		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
>  void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
>  		struct xfs_dir3_icleaf_hdr *from);
> -extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
> +int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
> +		xfs_dablk_t fbno, struct xfs_buf **bpp);
>  extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
>  extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 7983ea40668a..910e0bf85bd7 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -497,7 +497,7 @@ xchk_directory_leaf1_bestfree(
>  	int				error;
>  
>  	/* Read the free space block. */
> -	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, &bp);
>  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
>  		goto out;
>  	xchk_buffer_recheck(sc, bp);
> -- 
> 2.20.1
> 
