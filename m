Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BDDC4BA21
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EFA2072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fzFWgXuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBZUds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:33:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgBZUds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:33:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QKO7Ed168118;
        Wed, 26 Feb 2020 20:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=u9Q86GQOFw35Jv6qyRnv2+brrUyTCxL53/eMkr7JBc0=;
 b=fzFWgXuFtyxMMRnKrGkCwjA8LRwH7dE9/uft3ip3U6bOUtUQ6i76oWyzU8lDX/ePfoZ4
 4A1hrzyT+qVZ1GWYncDwJgmk9vmiYh39a8N75UCT9WeYYHURW/9/OcWgZZLuPUgO/Ulq
 MtfrJ6cwyF/pl+UJYk5PNkDHF57jFMAt7X7ROm06XfFd3Tx7UVSw5ToTwDge3BYI8uEF
 Kar1HbIrNEb5fdi8Bfvj7IvvlUguFdbvoa6GzQa589x7I45vIvXk3BUfQo+7AD+xUXtN
 RZ9HpRxpHvm7NTo9JyUKFL6dCTlRcDAWujnI9jj8IHGMZXLW/NZ0BGg0avLKY5IvCRzM 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ydybcg4pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 20:33:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QKM4Wo176007;
        Wed, 26 Feb 2020 20:33:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ydj4jeb91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 20:33:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QKXcdh024052;
        Wed, 26 Feb 2020 20:33:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 12:33:37 -0800
Date:   Wed, 26 Feb 2020 12:33:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 32/32] xfs: switch xfs_attrmulti_attr_get to lazy attr
 buffer allocation
Message-ID: <20200226203335.GJ8045@magnolia>
References: <20200226202306.871241-1-hch@lst.de>
 <20200226202306.871241-33-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226202306.871241-33-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002260122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 12:23:06PM -0800, Christoph Hellwig wrote:
> Let the low-level attr code only allocate the needed buffer size
> for xfs_attrmulti_attr_get instead of allocating the upper bound
> at the top of the call chain.
> 
> Suggested-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index c805fdf4ea39..47a92400929b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -481,10 +481,6 @@ xfs_attrmulti_attr_get(
>  	if (*len > XFS_XATTR_SIZE_MAX)
>  		return -EINVAL;
>  
> -	args.value = kmem_zalloc_large(*len, 0);
> -	if (!args.value)
> -		return -ENOMEM;
> -
>  	error = xfs_attr_get(&args);
>  	if (error)
>  		goto out_kfree;
> -- 
> 2.24.1
> 
