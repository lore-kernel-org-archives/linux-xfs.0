Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA32C388F9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 16:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708642072C
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 16:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BmcP5zPb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKKQHR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Nov 2020 11:07:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36038 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKQHQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Nov 2020 11:07:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABG3sbh095035;
        Wed, 11 Nov 2020 16:07:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=waaiuNtgFRr9ugHYtNib/vvckyjZK0Sz6dx8wla8VN8=;
 b=BmcP5zPbBwkwN2zJhWCBNlwqzip3AYYlS+8rjpM7ko0GoPo20tNJ4rmHmXRiMx0zzhqZ
 9+1TuuDHNuIuu2JmFUcpT7j+oAv0cUyxzHZ86Mu8kyvhux7RQoa/BZVBr+oxZJD13kDu
 tQRsMZ4+upB9D2OE36HivXQkfgDFlEj7t7NUsg8QG1Q1OYr0/m8nxWTJZIRHBhmnQeVV
 0cgayI+BhuTyQbx7nvExN9KZXmLNsBgLYc1c4Tcq1QOeEnERF3k79Kp77eCiK2vZ7qXM
 qjl3fdow5L45hlLYKedGUNqRHqD3G49csNpZOjzsuNHGiQD6fFXyieHpo+4qLO2HEs2o wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhm1jcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 16:07:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABG6Cke123116;
        Wed, 11 Nov 2020 16:07:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34p5gyjg5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 16:07:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ABG78Ji006487;
        Wed, 11 Nov 2020 16:07:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Nov 2020 08:07:08 -0800
Date:   Wed, 11 Nov 2020 08:07:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a missing unlock on error in xfs_fs_map_blocks
Message-ID: <20201111160709.GQ9695@magnolia>
References: <20201111094326.3513946-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111094326.3513946-1-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110095
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 11, 2020 at 10:43:26AM +0100, Christoph Hellwig wrote:
> We also need to drop the iolock when invalidate_inode_pages2 fails, not
> only on all other error or successful cases.
> 
> Fixes: 527851124d10 ("xfs: implement pNFS export operations")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_pnfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index b101feb2aab452..f3082a957d5e1a 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -134,7 +134,7 @@ xfs_fs_map_blocks(
>  		goto out_unlock;
>  	error = invalidate_inode_pages2(inode->i_mapping);
>  	if (WARN_ON_ONCE(error))
> -		return error;
> +		goto out_unlock;
>  
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> -- 
> 2.28.0
> 
