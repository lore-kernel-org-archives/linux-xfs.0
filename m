Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04A9C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC77206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P+C3GGDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgEEVKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 17:10:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEEVKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 17:10:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L3jdh108654;
        Tue, 5 May 2020 21:10:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gwG8HXCuNpDqIb3B7F1emD6iWM0iD2YH2eOXl/tmGro=;
 b=P+C3GGDgOj8sVQLPrlToDix3rTm2/pZNW+1AnwXpi0QLkqhwYhHeEgRzqWqVI7aMjlvJ
 W/LOhC7xJZkQtdVCjkd7Ql+XRyPt5J1L9DMjYl5RBjX5jzst9upf3YQzOkJPqNKAvnLY
 0rRTKHWG88sdlZSPTf60DRQkXIAwRGK2XwXF5TC7BHOVY6fwaX8+HAnDXM8SQ5z0xqGn
 15s9U7weiQ1fCPXS6Oceh54YfVTlKYioPviUmw6sexcLjxdhYF+R9FmWxskoTHWSi32/
 AhOnJMA4YFASURcgZL8fXkzMXpHlfgQpEzH/lafNP57+Jr4e5USZsD61RghP9v3M6k5k Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn6y6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:10:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045L6j5K080192;
        Tue, 5 May 2020 21:10:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjk0jje2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:10:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045LAjL9030587;
        Tue, 5 May 2020 21:10:45 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 14:10:45 -0700
Subject: Re: [PATCH v4 07/17] xfs: ratelimit unmount time per-buffer I/O error
 alert
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-8-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d353de70-59e4-dd50-13ea-e72daeb14f87@oracle.com>
Date:   Tue, 5 May 2020 14:10:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-8-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
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
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks fine to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 594d5e1df6f8..8f0f605de579 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1657,7 +1657,8 @@ xfs_wait_buftarg(
>   	struct xfs_buftarg	*btp)
>   {
>   	LIST_HEAD(dispose);
> -	int loop = 0;
> +	int			loop = 0;
> +	bool			write_fail = false;
>   
>   	/*
>   	 * First wait on the buftarg I/O count for all in-flight buffers to be
> @@ -1685,17 +1686,23 @@ xfs_wait_buftarg(
>   			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
>   			list_del_init(&bp->b_lru);
>   			if (bp->b_flags & XBF_WRITE_FAIL) {
> -				xfs_alert(btp->bt_mount,
> +				write_fail = true;
> +				xfs_buf_alert_ratelimited(bp,
> +					"XFS: Corruption Alert",
>   "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
>   					(long long)bp->b_bn);
> -				xfs_alert(btp->bt_mount,
> -"Please run xfs_repair to determine the extent of the problem.");
>   			}
>   			xfs_buf_rele(bp);
>   		}
>   		if (loop++ != 0)
>   			delay(100);
>   	}
> +
> +	if (write_fail) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));
> +		xfs_alert(btp->bt_mount,
> +	      "Please run xfs_repair to determine the extent of the problem.");
> +	}
>   }
>   
>   static enum lru_status
> 
