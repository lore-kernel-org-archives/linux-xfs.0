Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B80C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5017820659
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WlP1G6Dy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgFCQ1H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 12:27:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37354 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgFCQ1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 12:27:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GI2gS193450;
        Wed, 3 Jun 2020 16:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FEiXZ6/Qhn4G0P2rQp5P3+kAxGftVnFrnRAG0wneIw0=;
 b=WlP1G6DyVeO/jgOTJ/7fVztE3FeVU41h45IG2RMadceUApQyscs5yHZTUsxiukVdnNbm
 1eOpjPp4QYy3COXzRduidHMLf2RlgkUmuPVAeImwIqbHVm6W9StimgezyePuYs1q001W
 ExOxG2VbuoG9HzbaJdi2gZDYDJSGTXMR7dE//aA580GoAKUq+BrHm0FFa2NyK0QIQa/5
 Q3E2sixf99qlNWhbmJfB2dg+bGdX8S4ME96kGuvrm+WXDffHF8BdAJN+S5dbZPtvOUNI
 reNit9d3DERBM65eIX8dt14SVeo08AmHF2PrLoEKNht/oacx5FnxdVHsjs1qke0Q1gzj Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31bewr2am0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 16:27:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053GJSt3142693;
        Wed, 3 Jun 2020 16:27:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31c12r4qsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 16:27:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 053GR18d006218;
        Wed, 3 Jun 2020 16:27:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 09:27:00 -0700
Date:   Wed, 3 Jun 2020 09:26:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Add the missed xfs_perag_put() for
 xfs_ifree_cluster()
Message-ID: <20200603162659.GA8230@magnolia>
References: <20200603092707.1424619-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603092707.1424619-1-hslester96@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9641 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 05:27:07PM +0800, Chuhong Yuan wrote:
> xfs_ifree_cluster() calls xfs_perag_get() at the beginning, but forgets to
> call xfs_perag_put() in one failed path.
> Add the missed function call to fix it.
> 
> Fixes: ce92464c180b ("xfs: make xfs_trans_get_buf return an error code")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Yeah, that looks like a bug, will test.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d1772786af29..8845faa8161a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2639,8 +2639,10 @@ xfs_ifree_cluster(
>  		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
>  				mp->m_bsize * igeo->blocks_per_cluster,
>  				XBF_UNMAPPED, &bp);
> -		if (error)
> +		if (error) {
> +			xfs_perag_put(pag);
>  			return error;
> +		}
>  
>  		/*
>  		 * This buffer may not have been correctly initialised as we
> -- 
> 2.26.2
> 
