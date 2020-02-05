Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371DEC35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0604021927
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 05:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+d95x8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgBEF3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 00:29:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgBEF3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 00:29:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SnrL122020;
        Wed, 5 Feb 2020 05:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kOPrxQIhCLhFEfI6vTWUDHPrEpUc1Q71MRlqnWIeQQ4=;
 b=e+d95x8ZDU3v9q0e67tgOjgmyt6ndXPYRvI2fRaXVdfWzM15mmaybex+VaRQx3fVAz/3
 iD9ZDjQI7lT0NT3C08o2xY5SjhrTIA9p5YZQcyIunJtyD3yhp2BZGDbS0mQtmarIpx4N
 Oj1goql5L/nLP81Ag8KzHF01Jn764CMlrxTT3EBNQ81NkfS4JEmfSk9y42fyEaJCZXC+
 YCAs5lT6/1GBKHt8SnJmqi4H0kMIupJp7LhSHvMd2JnLNGN4qDKEWvlDDMTSpDH+bvOF
 ypnjQFKa3HLNO8aOjf+ALAA9Ylpx8mF7TU+9AFSpEVA9qB5HX0H09EwONulOivHv915b Tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xykbp0s4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:28:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155SkL2084438;
        Wed, 5 Feb 2020 05:28:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xykc1wue2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 05:28:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0155Ss5q011148;
        Wed, 5 Feb 2020 05:28:54 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 21:28:54 -0800
Subject: Re: [PATCH 2/4] libfrog: remove libxfs.h dependencies in fsgeom.c and
 linux.c
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
 <158086358002.2079557.9233731246621270812.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a6b6bb58-e5c2-eab4-d952-d4b02126fd69@oracle.com>
Date:   Tue, 4 Feb 2020 22:28:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086358002.2079557.9233731246621270812.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/4/20 5:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> libfrog isn't supposed to depend on libxfs, so don't include the header
> file in the libfrog source code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libfrog/fsgeom.c |    4 +++-
>   libfrog/linux.c  |    4 ++--
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 19a4911f..bd93924e 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -2,7 +2,9 @@
>   /*
>    * Copyright (c) 2000-2005 Silicon Graphics, Inc. All Rights Reserved.
>    */
> -#include "libxfs.h"
> +#include "platform_defs.h"
> +#include "xfs.h"
> +#include "bitops.h"
>   #include "fsgeom.h"
>   #include "util.h"
>   
> diff --git a/libfrog/linux.c b/libfrog/linux.c
> index 79bd79eb..41a168b4 100644
> --- a/libfrog/linux.c
> +++ b/libfrog/linux.c
> @@ -9,8 +9,8 @@
>   #include <sys/ioctl.h>
>   #include <sys/sysinfo.h>
>   
> -#include "libxfs_priv.h"
> -#include "xfs_fs.h"
> +#include "platform_defs.h"
> +#include "xfs.h"
>   #include "init.h"
>   
>   extern char *progname;
> 
