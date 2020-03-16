Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB69C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2966205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJAv8ZiI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgCPVJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:09:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:09:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8s7k049908;
        Mon, 16 Mar 2020 21:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OoRGFynakrTDGNw+F7x7jeVTkLOA02I2wvUqil0f3Pk=;
 b=OJAv8ZiIcncBQdXH+rpyG+wjZ+LAklskNg8HxFDTwfyK8O7wypFSGktN6W9ZSxZbdFY6
 0WWXLCZ6S/L0eO3jbNSTGFyCamhqLxR55Scj1vLtb0F0yoEFSW6B5f8hmzA30pP6T9Hi
 94qY4cYdmm6EuyWll7916r8E7QjWnNjIES1nashwHHHc2WgtdClA510CX1lYDbN9+kbL
 MPMC/l0+F3AzxqhmZIHYknbNWezI4ao8nkZuoYrKq4CazbnNEEYXPbfdqjsRj1i/GyJl
 EjT5tJasGd3Y/bIy+JWvV1oLoDu5E+KctuuHhhtitVVQQNYUFkx6Elgi4ELjHFdehOwN IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yrppr1d39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:09:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8RbH044215;
        Mon, 16 Mar 2020 21:09:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ys8rd83cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:09:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GL9gsI005874;
        Mon, 16 Mar 2020 21:09:42 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:09:42 -0700
Date:   Mon, 16 Mar 2020 14:09:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/14] xfs: merge xlog_state_clean_iclog into
 xlog_state_iodone_process_iclog
Message-ID: <20200316210941.GP256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-12-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:30PM +0100, Christoph Hellwig wrote:
> Merge xlog_state_clean_iclog into its only caller, which makes the iclog
> I/O completion handling a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a38d495b6e81..899c324d07e2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2625,22 +2625,6 @@ xlog_covered_state(
>  	return XLOG_STATE_COVER_NEED;
>  }
>  
> -STATIC void
> -xlog_state_clean_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*dirty_iclog)
> -{
> -	int			iclogs_changed = 0;
> -
> -	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> -
> -	xlog_state_activate_iclogs(log, &iclogs_changed);
> -	wake_up_all(&dirty_iclog->ic_force_wait);
> -
> -	if (iclogs_changed)
> -		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
> -}
> -
>  STATIC xfs_lsn_t
>  xlog_get_lowest_lsn(
>  	struct xlog		*log)
> @@ -2744,6 +2728,7 @@ xlog_state_iodone_process_iclog(
>  	struct xlog_in_core	*iclog)
>  {
>  	xfs_lsn_t		header_lsn, lowest_lsn;
> +	int			iclogs_changed = 0;
>  
>  	/*
>  	 * Now that we have an iclog that is in the DONE_SYNC state, do one more
> @@ -2758,7 +2743,13 @@ xlog_state_iodone_process_iclog(
>  
>  	xlog_state_set_callback(log, iclog, header_lsn);
>  	xlog_state_do_iclog_callbacks(log, iclog);
> -	xlog_state_clean_iclog(log, iclog);
> +
> +	iclog->ic_state = XLOG_STATE_DIRTY;
> +	xlog_state_activate_iclogs(log, &iclogs_changed);
> +
> +	wake_up_all(&iclog->ic_force_wait);
> +	if (iclogs_changed)
> +		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
>  	return true;
>  }
>  
> -- 
> 2.24.1
> 
