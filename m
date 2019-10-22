Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BC2CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8D7214B2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 16:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lwiyla5I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfJVQzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:55:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730432AbfJVQzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 12:55:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGrvoO012012;
        Tue, 22 Oct 2019 16:55:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+cQ9RpD4BAvPYsLJOcSiQr8i14t6jR/ke1WaSaa4pV0=;
 b=Lwiyla5IuB5kI1E0lurTBpq1/VcwbZr3ZqKwqg9YvaD6k9S+8sJIPJiGpZfl8LLOJ2gX
 JGz6vx8nsxkhzQ6ScaM20wxrO7LMhSD2HmSwIsDYdmaQJyheST5/Vk+3nCYxVQsNEBzi
 y/iHrW8bcMj4ttVhCwiCpwguq8+1/YzxwEmVXO7umrsmRg5jnOnyYxSPkawpu8QYNiBq
 +3HB7Y5HDcj6UO0A4F7Z5mW/g3liiv0e42qu3fXFBkH/+IGHnzL3GQ573PQwmECn+GR/
 t1nOBs2CbBqKm4niI7f6TLbOOfjLGTMd+r2tfBm/IXOpZGW9gR2lX1kfZ8gkHDhyxpOa PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswtg7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:55:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MGmNoF117667;
        Tue, 22 Oct 2019 16:55:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vt2hdd1qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 16:55:36 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MGtYdU007768;
        Tue, 22 Oct 2019 16:55:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 09:55:33 -0700
Date:   Tue, 22 Oct 2019 09:55:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: add mising include of xfs_pnfs.h for missing
 declarations
Message-ID: <20191022165532.GM913374@magnolia>
References: <20191022153247.10286-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022153247.10286-1-ben.dooks@codethink.co.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 04:32:47PM +0100, Ben Dooks (Codethink) wrote:
> The xfs_pnfs.c file is missing an include of xfs_pnfs.h to
> add the prototypes of the functions it exports. Include this
> file to fix the following sparse warnings:
> 
> fs/xfs/xfs_pnfs.c:27:1: warning: symbol 'xfs_break_leased_layouts' was not declared. Should it be static?
> fs/xfs/xfs_pnfs.c:52:1: warning: symbol 'xfs_fs_get_uuid' was not declared. Should it be static?
> fs/xfs/xfs_pnfs.c:77:1: warning: symbol 'xfs_fs_map_blocks' was not declared. Should it be static?
> fs/xfs/xfs_pnfs.c:226:1: warning: symbol 'xfs_fs_commit_blocks' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/xfs/xfs_pnfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index a339bd5fa260..b2f6f1e3d9c4 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -12,6 +12,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
>  #include "xfs_iomap.h"
> +#include "xfs_pnfs.h"
>  
>  /*
>   * Ensure that we do not have any outstanding pNFS layouts that can be used by
> -- 
> 2.23.0
> 
