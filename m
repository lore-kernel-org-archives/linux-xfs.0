Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40839C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F6A1205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:00:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oRVxpaqH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgCPVAq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:00:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732571AbgCPVAq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:00:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKrml3084523;
        Mon, 16 Mar 2020 21:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dSH8muw6kR9wPpLm56DNffC7cxHzJloXHBuBkcUuJPQ=;
 b=oRVxpaqHQIuIwE5EI7w+njqX8UKOGdLbG5I67rqPY9Ubq22/D34oDUASYi6xmi1A0TpL
 +vvKHc1fMgwqe9c7wOqQ1hiiAkjtH7dvf9thjT1mV3IEVBLOE0aFywGuOMKjHFPxoPfV
 x4Z3eEF8720vIXsEcVqyulmgAygYc03QYRXuORZgp1b9Vq2kg66Tnbh3jaLlWhQ5I3M7
 VaSIyjA2AuW7zaLSWzFAh/y2VYUuCsGII/dUVEgM7CkDPKHETTMOIcHVf2pRYRjWBMsf
 V572pcefk8VBUE9AQQ8Rg8jT6GaPCRrzHqTPHJzHMXlHDgxsnk8MgdcDyX0bCNFzXMRB Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yrqwn16m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:00:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKqvm7006162;
        Mon, 16 Mar 2020 21:00:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ys8tqe7pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:00:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GL0dVb032599;
        Mon, 16 Mar 2020 21:00:39 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:00:39 -0700
Date:   Mon, 16 Mar 2020 14:00:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/14] xfs: move xlog_state_do_iclog_callbacks up
Message-ID: <20200316210038.GM256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160087
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:27PM +0100, Christoph Hellwig wrote:
> Move xlog_state_do_iclog_callbacks a little up, to avoid the need for a
> forward declaration with upcoming changes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 74 ++++++++++++++++++++++++------------------------
>  1 file changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c490c5b0d8b7..c534d7007aa3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2701,6 +2701,43 @@ xlog_state_set_callback(
>  	xlog_grant_push_ail(log, 0);
>  }
>  
> +/*
> + * Keep processing entries in the iclog callback list until we come around and
> + * it is empty.  We need to atomically see that the list is empty and change the
> + * state to DIRTY so that we don't miss any more callbacks being added.
> + *
> + * This function is called with the icloglock held and returns with it held. We
> + * drop it while running callbacks, however, as holding it over thousands of
> + * callbacks is unnecessary and causes excessive contention if we do.
> + */
> +static void
> +xlog_state_do_iclog_callbacks(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +		__releases(&log->l_icloglock)
> +		__acquires(&log->l_icloglock)
> +{
> +	spin_unlock(&log->l_icloglock);
> +	spin_lock(&iclog->ic_callback_lock);
> +	while (!list_empty(&iclog->ic_callbacks)) {
> +		LIST_HEAD(tmp);
> +
> +		list_splice_init(&iclog->ic_callbacks, &tmp);
> +
> +		spin_unlock(&iclog->ic_callback_lock);
> +		xlog_cil_process_committed(&tmp);
> +		spin_lock(&iclog->ic_callback_lock);
> +	}
> +
> +	/*
> +	 * Pick up the icloglock while still holding the callback lock so we
> +	 * serialise against anyone trying to add more callbacks to this iclog
> +	 * now we've finished processing.
> +	 */
> +	spin_lock(&log->l_icloglock);
> +	spin_unlock(&iclog->ic_callback_lock);
> +}
> +
>  /*
>   * Return true if we need to stop processing, false to continue to the next
>   * iclog. The caller will need to run callbacks if the iclog is returned in the
> @@ -2754,43 +2791,6 @@ xlog_state_iodone_process_iclog(
>  	}
>  }
>  
> -/*
> - * Keep processing entries in the iclog callback list until we come around and
> - * it is empty.  We need to atomically see that the list is empty and change the
> - * state to DIRTY so that we don't miss any more callbacks being added.
> - *
> - * This function is called with the icloglock held and returns with it held. We
> - * drop it while running callbacks, however, as holding it over thousands of
> - * callbacks is unnecessary and causes excessive contention if we do.
> - */
> -static void
> -xlog_state_do_iclog_callbacks(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -		__releases(&log->l_icloglock)
> -		__acquires(&log->l_icloglock)
> -{
> -	spin_unlock(&log->l_icloglock);
> -	spin_lock(&iclog->ic_callback_lock);
> -	while (!list_empty(&iclog->ic_callbacks)) {
> -		LIST_HEAD(tmp);
> -
> -		list_splice_init(&iclog->ic_callbacks, &tmp);
> -
> -		spin_unlock(&iclog->ic_callback_lock);
> -		xlog_cil_process_committed(&tmp);
> -		spin_lock(&iclog->ic_callback_lock);
> -	}
> -
> -	/*
> -	 * Pick up the icloglock while still holding the callback lock so we
> -	 * serialise against anyone trying to add more callbacks to this iclog
> -	 * now we've finished processing.
> -	 */
> -	spin_lock(&log->l_icloglock);
> -	spin_unlock(&iclog->ic_callback_lock);
> -}
> -
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log)
> -- 
> 2.24.1
> 
