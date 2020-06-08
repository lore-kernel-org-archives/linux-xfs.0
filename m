Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C1DC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0CD220760
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 18:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t5huJ7AX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgFHSpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 14:45:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgFHSpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 14:45:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IbFgL087633;
        Mon, 8 Jun 2020 18:45:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=A3uHhDwRvtzeeO9wBhT4gKy+n07IKQFXBJKmb7bDH1A=;
 b=t5huJ7AXPSYfqd6q8EGOlHUwdZZUBHnSJ15PzkiNTnEwEaNS979JqzX43A5G8A7CoCga
 i6KfyK1XI+2x6F9x0IYcUolQsglFwnk9C7tiyPtEuFl2QOf2iZCJuLzwc/lM9GT1KhuE
 jthu+n1gAeW5jd7JFs6jcOMcnBH2cQ30m1GYOgYaEvD2iafkbLzg2AYypm0vPvMVreXO
 yh0OCz10a31YmPX/PrLXENBK9mHcxLRfxQprUgS8vKrvWWzeC8p5HQ/y0uiWyzqbE76W
 KqRsVR56vgNRuglJWGl9rv6gvEPiJQr19I0YVxGYvo318mvtQlUeBkoXeMccMujtup/O eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31g33m0eg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 18:45:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058IcZjT112657;
        Mon, 8 Jun 2020 18:45:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31gmwqaedy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 18:45:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058IjDDB005104;
        Mon, 8 Jun 2020 18:45:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 11:45:12 -0700
Date:   Mon, 8 Jun 2020 11:45:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_copy: flush target devices before exiting
Message-ID: <20200608184510.GK1334206@magnolia>
References: <20200608184400.GJ1334206@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608184400.GJ1334206@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 08, 2020 at 11:44:00AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Flush the devices we're copying to before exiting, so that we can report
> any write errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  copy/xfs_copy.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 2d087f71..45ee2e06 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -12,6 +12,7 @@
>  #include <stdarg.h>
>  #include "xfs_copy.h"
>  #include "libxlog.h"
> +#include "libfrog/platform.h"
>  
>  #define	rounddown(x, y)	(((x)/(y))*(y))
>  #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
> @@ -150,6 +151,9 @@ check_errors(void)
>  			else
>  				do_log(_("lseek error"));
>  			do_log(_(" at offset %lld\n"), target[i].position);
> +		} else if (platform_flush_device(target[i].fd, 0)) {
> +			do_log(_("    %s -- flush error %d"),
> +					target[i].name, errno);

NAK, this should set first_error.  Boooo...

--D

>  		}
>  	}
>  	if (first_error == 0)  {
