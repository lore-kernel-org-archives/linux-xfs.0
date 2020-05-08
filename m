Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6042AC38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC1B21841
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MlGBkQ/I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHPve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:51:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgEHPve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:51:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048FnL0F175351;
        Fri, 8 May 2020 15:51:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mbKpKZFNE+IVTGTdE76Ot/pkQ2pevl8WAyDB8P6MXUo=;
 b=MlGBkQ/I3fOwwh6rwhoY9EfdVkC2pZGG2KlfW2CPtLrepnfn0l0CVZBJXmNP2SMVk2Wp
 epLxsCNe/KFB8Hu4vsjSIEh6FWlMsru/Ys0Rami/CG9/LOQjVmfvV5bo9DLQchYanGyP
 HC+D/waG8YooI1ULei4oslPCI2yXqDT1sxrz27BAZ1WY4T8ea4W1fT537ZhT1Pm0XjVy
 7ZSKaWX5dTnpimy3+Fn6ORGJTNTW5yk+tSNC1bwsMTVIZXAJVeCG/Tose1+LlphjDeCD
 JpyXmLKN0xGakCzdsO/BcO4f/XUeS+qIuIpNg8TGMGa12sRlXXpmVWP6XelvFhwMjRC7 Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30vtepkqhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 15:51:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048FfbAM026017;
        Fri, 8 May 2020 15:51:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30vte0a08u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 15:51:27 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 048FpQhB020330;
        Fri, 8 May 2020 15:51:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 08:51:25 -0700
Date:   Fri, 8 May 2020 08:51:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove duplicate headers
Message-ID: <20200508155124.GM6714@magnolia>
References: <20200508122724.168979-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508122724.168979-1-chenzhou10@huawei.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:27:24PM +0800, Chen Zhou wrote:
> Remove duplicate headers which are included twice.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_xattr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index fc5d7276026e..bca48b308c02 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -12,7 +12,6 @@
>  #include "xfs_inode.h"
>  #include "xfs_attr.h"
>  #include "xfs_acl.h"
> -#include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  
>  #include <linux/posix_acl_xattr.h>
> -- 
> 2.20.1
> 
