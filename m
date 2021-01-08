Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A07C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5272D23A80
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jan 2021 21:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAHVYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 16:24:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35042 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbhAHVYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jan 2021 16:24:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108L97dJ159065;
        Fri, 8 Jan 2021 21:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bCeEmnPWFhuCuqp0ZyOJRSjs2y3oUPaNw58QyDUff/E=;
 b=MOxWhGdMGip4UrXHlj2Kme+Pv2ZoNrAzyWgoJ7rfdrxJJzP7uD+Z5lTAHRXVbOtYN7j8
 UdvwPO+ZFAuiFqCtbH/W20mlXj6GoVgYNZbTuCorgcMWNgs/vpKu+G6mO0JHq4krAVIh
 pYupCPPVpP6BqR/TqAU0xlW/QI6psNCztvww/ulIn2Bi8cGK0jiwy58e68hsrtg58Riq
 TqzESHAumj83kIiP8WZKcUQPwcuSW9xPrv1oC6UPa6/C2rPrpzOWOIg6T8HpARZ5szv1
 47SwT5/3ovIbwgcSN7q6T94IYD/c8SLIa3+osZMU3KgoNdTomGTC/zWB+HY2utLe7TFQ BA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuy3c07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 21:23:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108LBVdc138029;
        Fri, 8 Jan 2021 21:23:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g4xnqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 21:23:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 108LNGhN018755;
        Fri, 8 Jan 2021 21:23:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 13:23:16 -0800
Date:   Fri, 8 Jan 2021 13:23:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 1/4] xfs: rename `new' to `delta' in
 xfs_growfs_data_private()
Message-ID: <20210108212315.GT38809@magnolia>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108190919.623672-2-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 09, 2021 at 03:09:16AM +0800, Gao Xiang wrote:
> It actually means the delta block count of growfs. Rename it in order
> to make it clear.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 5870db855e8b..d254588f6e21 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -33,7 +33,7 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_mod;
> -	xfs_rfsblock_t		new;
> +	xfs_rfsblock_t		delta;
>  	xfs_agnumber_t		oagcount;
>  	xfs_trans_t		*tp;
>  	struct aghdr_init_data	id = {};
> @@ -50,16 +50,16 @@ xfs_growfs_data_private(
>  		return error;
>  	xfs_buf_relse(bp);
>  
> -	new = nb;	/* use new as a temporary here */
> -	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> -	nagcount = new + (nb_mod != 0);
> +	delta = nb;	/* use delta as a temporary here */

Yikes, can ... oh right, I complained about this in patch 4.

delta should probably be an int64_t, and this division/mod should have
its own temporary variable.

--D

> +	nb_mod = do_div(delta, mp->m_sb.sb_agblocks);
> +	nagcount = delta + (nb_mod != 0);
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
>  		if (nb < mp->m_sb.sb_dblocks)
>  			return -EINVAL;
>  	}
> -	new = nb - mp->m_sb.sb_dblocks;
> +	delta = nb - mp->m_sb.sb_dblocks;
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -89,7 +89,7 @@ xfs_growfs_data_private(
>  	INIT_LIST_HEAD(&id.buffer_list);
>  	for (id.agno = nagcount - 1;
>  	     id.agno >= oagcount;
> -	     id.agno--, new -= id.agsize) {
> +	     id.agno--, delta -= id.agsize) {
>  
>  		if (id.agno == nagcount - 1)
>  			id.agsize = nb -
> @@ -110,8 +110,8 @@ xfs_growfs_data_private(
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
>  	/* If there are new blocks in the old last AG, extend it. */
> -	if (new) {
> -		error = xfs_ag_extend_space(mp, tp, &id, new);
> +	if (delta) {
> +		error = xfs_ag_extend_space(mp, tp, &id, delta);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -143,7 +143,7 @@ xfs_growfs_data_private(
>  	 * If we expanded the last AG, free the per-AG reservation
>  	 * so we can reinitialize it with the new size.
>  	 */
> -	if (new) {
> +	if (delta) {
>  		struct xfs_perag	*pag;
>  
>  		pag = xfs_perag_get(mp, id.agno);
> -- 
> 2.27.0
> 
