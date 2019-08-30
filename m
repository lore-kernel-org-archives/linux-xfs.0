Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35124C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05FC023407
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SlmQtY9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfH3PJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:09:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3PJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:09:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF47vf132910;
        Fri, 30 Aug 2019 15:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=plHppXKo679FnaRS3+4w9Z1Q51OBR8emUCnyjSvrKkE=;
 b=SlmQtY9wfWcD6p1jUcxSfRJ3TeEqGOpDTLpYU0kRXL0KCIWfU4okYPZx316foaT7in0F
 lua5EIy4vD/GAcA3t1cct1crnegD41muTiDiKU1/pBXGd5mLhppkI1MTPlWzLFs5xJF9
 OleLgFN8dTfjUpCjbu2wXPJp9Srgn6bxj1yFGzLiWv+jVM9RLrOipSTKxcPKq5Zq6Hij
 S5KLUp0YHJtPOKKhDBwMoJQNuUyWWtva18/vhVAcgndgGW3uUUnvylvmKkbYeb7O5Qvx
 lTwnO9ZtnkAABTV+de2tOysMdIQaEdaI2FPAJtTBmZnYE2+8QShNIQxWSRPNaSNsEK9v 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uq5tx856f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:09:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF8gds075052;
        Fri, 30 Aug 2019 15:09:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2upxabdjvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:09:15 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UF9ELS023184;
        Fri, 30 Aug 2019 15:09:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 08:09:14 -0700
Date:   Fri, 30 Aug 2019 08:09:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v2] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190830150913.GD5354@magnolia>
References: <20190830150327.20874-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830150327.20874-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 05:03:27PM +0200, Christoph Hellwig wrote:
> Add back four typedefs that allow xfsdump to compile against the
> headers from the latests xfsprogs.
> 
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/xfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index f2f675df..35435b18 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #include <xfs/xfs_types.h>
>  #include <xfs/xfs_fs.h>
>  
> +/*
> + * Backards compatibility for users of this header, now that the kernel
> + * removed these typedefs from xfs_fs.h.
> + */
> +typedef struct xfs_bstat xfs_bstat_t;
> +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> +typedef struct xfs_fsop_geom_v1 xfs_fsop;
> +typedef struct xfs_inogrp xfs_inogrp_t;
> +
>  #endif	/* __XFS_H__ */
> -- 
> 2.20.1
> 
