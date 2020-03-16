Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD6BC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF930206C0
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o4rzYVxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbgCPVAT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:00:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732571AbgCPVAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:00:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKrhDr132861;
        Mon, 16 Mar 2020 21:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2nz3unhTbCxT/5JAJNpoINdTT7KBBCZR7tEe3jvqmxg=;
 b=o4rzYVxSgSLLS9vTEwjSnzZ4sLv8a7gii/sL9kQU34Bp5GV2f2UQ6Gt+1pWjRzrfPuOI
 GBUsCCrYDQuXbcut6GEaXfJPucBsm3qDSv+Hm/flPAcQzJYWQuBb3iZ4YO8H5zgOnnwE
 ZWGo8sBALD9F7rs8iXBHF07GIVN1FbNPqI/GPPCsYHd4MosTLVWTXr21NzmpTU9+oMJj
 vUYxwtFfSOSWjT4Gx5cqBN5azAnLknlSEj7dMxaziFTaLRd9xY65r7Wmj6Vw2bB8Uuge
 TKS3+Hx7F4d2WvFio+NzB7KW3O+hofqkQL5SGU+rJRYje+61BWG+l7uoAetjeOGDwbwY kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7ks96w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:00:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKqlKV005441;
        Mon, 16 Mar 2020 21:00:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ys8tqe6v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:00:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GL0DOx026286;
        Mon, 16 Mar 2020 21:00:13 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:00:13 -0700
Date:   Mon, 16 Mar 2020 14:00:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/14] xfs: move the ioerror check out of
 xlog_state_clean_iclog
Message-ID: <20200316210012.GL256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-8-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:26PM +0100, Christoph Hellwig wrote:
> Use the shutdown flag in the log to bypass xlog_state_clean_iclog
> entirely in case of a shut down log.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 23979d08a2a3..c490c5b0d8b7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2632,8 +2632,7 @@ xlog_state_clean_iclog(
>  {
>  	int			iclogs_changed = 0;
>  
> -	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> -		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> +	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
>  	xlog_state_activate_iclogs(log, &iclogs_changed);
>  	wake_up_all(&dirty_iclog->ic_force_wait);
> @@ -2836,8 +2835,10 @@ xlog_state_do_callback(
>  			 */
>  			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> -
> -			xlog_state_clean_iclog(log, iclog);
> +			if (XLOG_FORCED_SHUTDOWN(log))
> +				wake_up_all(&iclog->ic_force_wait);
> +			else
> +				xlog_state_clean_iclog(log, iclog);
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> -- 
> 2.24.1
> 
