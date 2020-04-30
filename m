Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9384AC47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB0E2070B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ym6Pk4zW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgD3Sn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:43:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3SnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:43:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIg2dK136208;
        Thu, 30 Apr 2020 18:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=z5DNoSICtRVrl9SNP69EGauu24fK1l2RJi385Pl4j90=;
 b=Ym6Pk4zWo/wjs0RTRthVhE0HzVQP8h0D5k5ldyL8yYceFIZLD7+VzxQwNuAFC40PNZxC
 Tms+ElUqxzvyVqRj5O9Ize2KGQCxwA68QglfH286qlPflIGkUoAGXJVSIiPu7QxGyqpv
 /a/8NpUbYwSChXR2McZATdrc88u+125hzQM9hFYJSjTv/hyg0vwCACXoey8trmvvNlma
 99I/z44a2hOiq4M/wa+do0IUWnVQKiAIwpC0zQ+F8jLNqD/JmL23Sk62fvXCHBOl7l5M
 H5mnKJDnm0mgISFi8RjsFi+S8QN/7cEWTtipnSlCKX3gL7mrDuReSqM569GGgEDRWyd1 FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucgd783-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:43:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIZW6R149958;
        Thu, 30 Apr 2020 18:43:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30qtjxvx87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:43:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UIhLSH018355;
        Thu, 30 Apr 2020 18:43:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:43:20 -0700
Date:   Thu, 30 Apr 2020 11:43:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/17] xfs: ratelimit unmount time per-buffer I/O
 error alert
Message-ID: <20200430184319.GH6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-8-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:43PM -0400, Brian Foster wrote:
> At unmount time, XFS emits an alert for every in-core buffer that
> might have undergone a write error. In practice this behavior is
> probably reasonable given that the filesystem is likely short lived
> once I/O errors begin to occur consistently. Under certain test or
> otherwise expected error conditions, this can spam the logs and slow
> down the unmount.
> 
> Now that we have a ratelimit mechanism specifically for buffer
> alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
> Also lift the final repair message out of the loop so it always
> prints and assert that the metadata error handling code has shut
> down the fs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

LOL, this question answered my question from the previous patch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 594d5e1df6f8..8f0f605de579 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1657,7 +1657,8 @@ xfs_wait_buftarg(
>  	struct xfs_buftarg	*btp)
>  {
>  	LIST_HEAD(dispose);
> -	int loop = 0;
> +	int			loop = 0;
> +	bool			write_fail = false;
>  
>  	/*
>  	 * First wait on the buftarg I/O count for all in-flight buffers to be
> @@ -1685,17 +1686,23 @@ xfs_wait_buftarg(
>  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>  			list_del_init(&bp->b_lru);
>  			if (bp->b_flags & XBF_WRITE_FAIL) {
> -				xfs_alert(btp->bt_mount,
> +				write_fail = true;
> +				xfs_buf_alert_ratelimited(bp,
> +					"XFS: Corruption Alert",
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
>  					(long long)bp->b_bn);
> -				xfs_alert(btp->bt_mount,
> -"Please run xfs_repair to determine the extent of the problem.");
>  			}
>  			xfs_buf_rele(bp);
>  		}
>  		if (loop++ != 0)
>  			delay(100);
>  	}
> +
> +	if (write_fail) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));
> +		xfs_alert(btp->bt_mount,
> +	      "Please run xfs_repair to determine the extent of the problem.");
> +	}
>  }
>  
>  static enum lru_status
> -- 
> 2.21.1
> 
