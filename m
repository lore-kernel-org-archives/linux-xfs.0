Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FA7C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66643208C7
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RwySzKR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgJFETC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:19:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFETB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:19:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964Dwm9048628;
        Tue, 6 Oct 2020 04:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KHm2S0PHUDvgKVewvOIvHOzIjjfmN/zwK6otjVQnRkQ=;
 b=RwySzKR6QVQz3gmYKz9DfkI0Aa6X3AGuEm+tr2On3hNH1XXU+fAALid6QxrQfr8nxrBY
 19rV/s+oToYK0DM5lwtbYUF4icgj8LzqQ5G7eiLSxECSVc9u6GkdEu3evpZPh6n7+ozv
 TxfrMO5b7PqbQl4JIWrf9kyqiKAwOAp7SX/CkcXD8s2d/JgTJwlLfP0PNydMk8+vnzyE
 xZMy74aetLkpwCnRIhJlcka9+prCVZ7b8XNIl08LZIRTPj6MCNBp6jD09ALq3JptIdDV
 73jGqkbn3ap1ahHmAAoNp/D82E0gqtwSUuskKPRA29XPAxpMAXwd5UdYA2d3fr4m48kf 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmsppu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:18:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964A7HQ041338;
        Tue, 6 Oct 2020 04:18:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y37wahu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:18:58 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964IvcV004256;
        Tue, 6 Oct 2020 04:18:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:18:57 -0700
Date:   Mon, 5 Oct 2020 21:18:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 03/12] xfs: Check for extent overflow when punching a
 hole
Message-ID: <20201006041856.GM49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-4-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:24AM +0530, Chandan Babu R wrote:
> The extent mapping the file offset at which a hole has to be
> inserted will be split into two extents causing extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>  fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
>  fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
>  3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fc2b129a2e7..bcac769a7df6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -40,6 +40,13 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
>  
> +/*
> + * Punching out an extent from the middle of an existing extent can cause the
> + * extent count to increase by 1.
> + * i.e. | Old extent | Hole | Old extent |
> + */
> +#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 6a7dcea4ad40..323cee00bd45 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -440,6 +440,7 @@ xfs_bui_item_recover(
>  	bool				op_ok;
>  	unsigned int			bui_type;
>  	int				whichfork;
> +	int				iext_delta;
>  	int				error = 0;
>  
>  	/* Only one mapping operation per BUI... */
> @@ -519,12 +520,14 @@ xfs_bui_item_recover(
>  	}
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	if (bui_type == XFS_BMAP_MAP) {
> -		error = xfs_iext_count_may_overflow(ip, whichfork,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
> -		if (error)
> -			goto err_inode;
> -	}
> +	if (bui_type == XFS_BMAP_MAP)
> +		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
> +	else
> +		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
> +	if (error)
> +		goto err_inode;
>  
>  	count = bmap->me_len;
>  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index dcd6e61df711..0776abd0103c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -891,6 +891,11 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -1176,6 +1181,11 @@ xfs_insert_file_space(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * The extent shifting code works on extent granularity. So, if stop_fsb
>  	 * is not the starting block of extent, we need to split the extent at
> -- 
> 2.28.0
> 
