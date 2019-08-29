Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE40FC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4A9E22CEA
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 21:22:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZMNwbJZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH2VWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:22:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58284 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2VWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 17:22:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLExTU161570;
        Thu, 29 Aug 2019 21:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YCmDkvHRK2H6uwl53GM/Ym/ZWwOlzOXox5M0iq/kVD0=;
 b=ZMNwbJZj2ZgFJpkSXzppb3pQN0+j9sp7OQqD8mosZdeR+OFYr78lpcp8C9RPbdFzfkn5
 vjaj53UuQau76LhMZHq3K67woYQtcO/3uWZXY/IS//siNUeHCAQLAAGl5GzVQN/enIMl
 2o4Sh86v98+IwVs2aKDK7BVx9hx/BCVzpXevVxcbbUf4MHhcK/j5hwGo4wH1WZaLkRv/
 PAiQk1VZUK8Tjcaqym2138yon6AR6ZM5iiqccD3qfWyoI7cMv1eUtVIF4zuuXjZ1QzFm
 i/a0fbiJE1+3FM0amh++wCkDnDfb69KYxkCZ/I4OBc8x5WiUoecXHJcxtj4eP547yEIq 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uppet02ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:22:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE7d3018400;
        Thu, 29 Aug 2019 21:22:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2unvu0m7at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:22:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLMXjb030866;
        Thu, 29 Aug 2019 21:22:33 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:22:33 -0700
Date:   Thu, 29 Aug 2019 14:22:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/11] xfs: remove unlikely() from WARN_ON() condition
Message-ID: <20190829212232.GN5354@magnolia>
References: <20190829165025.15750-1-efremov@linux.com>
 <20190829165025.15750-7-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829165025.15750-7-efremov@linux.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 07:50:21PM +0300, Denis Efremov wrote:
> "unlikely(WARN_ON(x))" is excessive. WARN_ON() already uses unlikely()
> internally.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-xfs@vger.kernel.org

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ca0849043f54..4389d87ff0f0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2096,7 +2096,7 @@ xfs_verify_magic(
>  	int			idx;
>  
>  	idx = xfs_sb_version_hascrc(&mp->m_sb);
> -	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
> +	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx]))
>  		return false;
>  	return dmagic == bp->b_ops->magic[idx];
>  }
> @@ -2114,7 +2114,7 @@ xfs_verify_magic16(
>  	int			idx;
>  
>  	idx = xfs_sb_version_hascrc(&mp->m_sb);
> -	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx])))
> +	if (WARN_ON(!bp->b_ops || !bp->b_ops->magic16[idx]))
>  		return false;
>  	return dmagic == bp->b_ops->magic16[idx];
>  }
> -- 
> 2.21.0
> 
