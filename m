Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D032FC2BA19
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 19:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95B57206F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 19:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2nyq5lP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDITLy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 15:11:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgDITLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 15:11:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039J9MKo170475;
        Thu, 9 Apr 2020 19:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Df1u7xrzbduXVmDF22E/iDd6qgkvwuWSdT8ib8D9SAw=;
 b=E2nyq5lPjqhPrNQyMQjm0q4I6H/HzL0A7lMTy9DmRCz7E53fcWQDuwketBRlZUvlZQOe
 QEXIiq2WyHS9XxwElwrc4fKcuIfY3gNnJm1lWICwhcvtw0Xm1+r8RdIhhVWGi79xBOk5
 c+uyFmVJeTx+h8LO4XZ9RlmAVr/0ICyTxjMfy/J7YQuFIQK6yrn6y3tiWDGIh3VJ0JKe
 kd3L7cijc3KBI12v+fYpSSHiEzAHWjdznaXAIlhQQF8kVwGhTMVGXL92Q/3aunMh7YQW
 PHvIqcnt+6ohfCt4IugSBkwhASf50L/GzEcKFYG/vLG0S3u+XmLngtmS8Rm18NfFNEaN 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 309gw4f83v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 19:11:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039J830Q149067;
        Thu, 9 Apr 2020 19:11:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3091m96aq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 19:11:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039JBnaW017594;
        Thu, 9 Apr 2020 19:11:49 GMT
Received: from localhost (/10.159.243.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 12:11:49 -0700
Date:   Thu, 9 Apr 2020 12:11:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: acquire superblock freeze protection on eofblocks
 scans
Message-ID: <20200409191146.GN6742@magnolia>
References: <20200408122119.33869-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408122119.33869-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 08:21:19AM -0400, Brian Foster wrote:
> The filesystem freeze sequence in XFS waits on any background
> eofblocks or cowblocks scans to complete before the filesystem is
> quiesced. At this point, the freezer has already stopped the
> transaction subsystem, however, which means a truncate or cowblock
> cancellation in progress is likely blocked in transaction
> allocation. This results in a deadlock between freeze and the
> associated scanner.
> 
> Fix this problem by holding superblock write protection across calls
> into the block reapers. Since protection for background scans is
> acquired from the workqueue task context, trylock to avoid a similar
> deadlock between freeze and blocking on the write lock.
> 
> Fixes: d6b636ebb1c9f ("xfs: halt auto-reclamation activities while rebuilding rmap")
> Reported-by: Paul Furtado <paulfurtado91@gmail.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, will test and probably queue for 5.7-rc2...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Note that this has the opposite tradeoff as the approach I originally
> posited [1], specifically that the eofblocks ioctl() now always blocks
> on a frozen fs rather than return -EAGAIN. It's worth pointing out that
> the eofb control structure has a sync flag (that is not used for
> background scans), so yet another approach could be to tie the trylock
> to that.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20200407163739.GG28936@bfoster/
> 
>  fs/xfs/xfs_icache.c | 10 ++++++++++
>  fs/xfs/xfs_ioctl.c  |  5 ++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a7be7a9e5c1a..8bf1d15be3f6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -911,7 +911,12 @@ xfs_eofblocks_worker(
>  {
>  	struct xfs_mount *mp = container_of(to_delayed_work(work),
>  				struct xfs_mount, m_eofblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>  	xfs_icache_free_eofblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>  	xfs_queue_eofblocks(mp);
>  }
>  
> @@ -938,7 +943,12 @@ xfs_cowblocks_worker(
>  {
>  	struct xfs_mount *mp = container_of(to_delayed_work(work),
>  				struct xfs_mount, m_cowblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>  	xfs_icache_free_cowblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>  	xfs_queue_cowblocks(mp);
>  }
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cdfb3cd9a25b..309958186d33 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2363,7 +2363,10 @@ xfs_file_ioctl(
>  		if (error)
>  			return error;
>  
> -		return xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_start_write(mp->m_super);
> +		error = xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_end_write(mp->m_super);
> +		return error;
>  	}
>  
>  	default:
> -- 
> 2.21.1
> 
