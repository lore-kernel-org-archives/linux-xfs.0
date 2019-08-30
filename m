Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3825CC3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A9723426
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXd01MTe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfH3Ono (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:43:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbfH3Ono (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 10:43:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UEetbb106335;
        Fri, 30 Aug 2019 14:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=APR31yM5uYQwc17CTUECYABnfMOF4o0cUgW1Hq6tpTo=;
 b=HXd01MTeGbJEMftIpDsJFBGblkkQe+xFRrTr1bQinTJfo/eFIq+nAtrx2iu6G9bG017a
 OOdtscaq3q9KWOaas04XXJsQBo+nzedXczgFsbPg8pbZYZ2sg8YQa2VjVRbekOOXMArg
 dViexJGpJ84IxJzL/GyIswYp8N1+c9rW59v8v3QKTAhPZ4jHEgB6z3VMi6IYOeseDWZe
 NwMmsvUbF6PBqfA/RgVJ78hwEeM6ZSWy0KJbHda+l64YYSUp/7xFqrihfACOitXIKDPg
 WqQCy4WSbvr4lX4EPq7O3XVERwFl7V36vYzHVDhoSMM6peC6K5xEfTlzhuXv9+KV0QD+ Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uq5s600rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 14:43:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UEOZaN176433;
        Fri, 30 Aug 2019 14:43:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrgep8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 14:43:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UEhZVe001960;
        Fri, 30 Aug 2019 14:43:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 07:43:35 -0700
Date:   Fri, 30 Aug 2019 07:43:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190830144335.GZ5354@magnolia>
References: <20190830102227.20932-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830102227.20932-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=919
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=980 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:22:27PM +0200, Christoph Hellwig wrote:
> Add back four typedefs that allow xfsdump to compile against the
> headers from the latests xfsprogs.
> 
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/xfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index f2f675df..9ae067dc 100644
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
> +typedef struct xfs_fsop_geom_v1 xfs_fsop

Missing a semicolon here?

--D

> +typedef struct xfs_inogrp xfs_inogrp_t;
> +
>  #endif	/* __XFS_H__ */
> -- 
> 2.20.1
> 
