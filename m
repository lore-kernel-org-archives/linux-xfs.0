Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A95FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 19:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C982065C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 19:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BAWpw7Ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgG2T7U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 15:59:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49996 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2T7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 15:59:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TJuqT5039939
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QkK1Un+WX5l0Q6vK8rmSrxGLoR2WVv9KGHkhDFU0DN8=;
 b=BAWpw7UbeIZo5/g3ElkzFHj97r34wEMakKMzhd+hNTENokpYX/vHHvAY148Oq1mEzSB0
 oosCnDZY4XIHWSyv2Kpzj5ffzodtv0JGNb/lvaUxYRXokrgsTDJDfHVsPqEuiDQKwxio
 zmYi7sCScsu21Lo2B88PW6aOGeF7aNjN0EwroI5Uv8S3pBt8XUAQAd+PB//FsFNdMfPh
 Sk6C2DcqLiNfTni9LsXHUuejBENcOZHHx5nj5UFUNTIEbD7t7b8Vkw4BvnlAemTSglvq
 AD0HOM0kn4sTs+lekR1zRpka5VlD4vt79l8b7a2qszDu2n0RHqd+IGtw7m/YbwIXJOkg mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32hu1jfsx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:59:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06TJweB9113419
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:59:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32hu5xv0r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:59:18 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06TJxHdQ029630
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 19:59:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jul 2020 12:59:17 -0700
Date:   Wed, 29 Jul 2020 12:59:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
Message-ID: <20200729195916.GF3151642@magnolia>
References: <20200729043747.11164-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729043747.11164-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9697 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=2 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 28, 2020 at 09:37:47PM -0700, Allison Collins wrote:
> Fix warning: variable dereferenced before check 'state' in
> xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
> state.  If state is null, do not release paths or derefrence state
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok, though I folded all these into the for-next rebase (and then
forgot to push send on this...)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e5ec9ed..38fe0d3 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1422,7 +1422,7 @@ xfs_attr_node_get(
>  	 * If not in a transaction, we have to release all the buffers.
>  	 */
>  out_release:
> -	for (i = 0; i < state->path.active; i++) {
> +	for (i = 0; i < state && state->path.active; i++) {
>  		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>  		state->path.blk[i].bp = NULL;
>  	}
> -- 
> 2.7.4
> 
