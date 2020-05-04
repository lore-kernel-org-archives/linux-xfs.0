Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4DCC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B2D220705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 19:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DzIkV+hi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEDTgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 15:36:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgEDTgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 15:36:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044JX8b0128451
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D836GOSl9oLV1qk/LHbEmhOgtz4TZERLKKegJiAXgAI=;
 b=DzIkV+higWR7lLtUK4vZNIJXcmqpgCKXfOLokUS/z9WCmK1+s71+2IWdRhi6c0oCSHwV
 PP7PcpT0klJEg4lcCtrzfcamJyhKF1mPEHhs/TjfWFmzFpI32eAK4MsynYkdVMMdMV6b
 uqlMVrCHtWD50i9LLj1lN//3/ILsxbgMS7lcflRkT+kNHaSz1gMkSCYHqLNKubt/zCgW
 s1PjW3n+swrYIC7mHtQAu6ByPdT1vGfbWyouNCawTRBjjUSO3ypPbD3srQK6XvlXt5BY
 gN5L3H5lX5J6VuQguB6vKirC5c5UhjdLfeI//gLG063HP1In2P8jM5FlAbHkw4WykBZb 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tm8xh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:36:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044JWWVB070520
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:34:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjwm0q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 19:34:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044JYBIM021623
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 19:34:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 12:34:11 -0700
Date:   Mon, 4 May 2020 12:34:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 24/24] xfs: Rename __xfs_attr_rmtval_remove
Message-ID: <20200504193410.GJ5703@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-25-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-25-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:16PM -0700, Allison Collins wrote:
> Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
> to xfs_attr_rmtval_remove
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 7 +++----
>  fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
>  fs/xfs/libxfs/xfs_attr_remote.h | 3 +--
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0751231..d76a970 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -874,7 +874,7 @@ xfs_attr_leaf_addname(
>  		return error;
>  das_rm_lblk:
>  	if (args->rmtblkno) {
> -		error = __xfs_attr_rmtval_remove(dac);
> +		error = xfs_attr_rmtval_remove(dac);
>  
>  		if (error == -EAGAIN) {
>  			dac->dela_state = XFS_DAS_RM_LBLK;
> @@ -1244,8 +1244,7 @@ xfs_attr_node_addname(
>  
>  das_rm_nblk:
>  	if (args->rmtblkno) {
> -		error = __xfs_attr_rmtval_remove(dac);
> -
> +		error = xfs_attr_rmtval_remove(dac);
>  		if (error == -EAGAIN) {
>  			dac->dela_state = XFS_DAS_RM_NBLK;
>  			return -EAGAIN;
> @@ -1409,7 +1408,7 @@ xfs_attr_node_removename_rmt (
>  	/*
>  	 * May return -EAGAIN to request that the caller recall this function
>  	 */
> -	error = __xfs_attr_rmtval_remove(dac);
> +	error = xfs_attr_rmtval_remove(dac);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 7a342f1..21c7aa9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -740,7 +740,7 @@ xfs_attr_rmtval_invalidate(
>   * transaction and recall the function
>   */
>  int
> -__xfs_attr_rmtval_remove(
> +xfs_attr_rmtval_remove(
>  	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 51a1c91..09fda56 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -10,11 +10,10 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
> -int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> -- 
> 2.7.4
> 
