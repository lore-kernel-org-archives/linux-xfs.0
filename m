Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E17C18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 884A620674
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:25:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MC5u412m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbgCPVZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:25:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732621AbgCPVZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:25:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8mNh051091;
        Mon, 16 Mar 2020 21:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MUgdG6TJiui9W71zTeVwyhVObBt1TJ8NQfjpgk2VSqQ=;
 b=MC5u412mxf/mqbVpVXwRYDpk2N3CNXxb/W3l5IyeePgNEh97mcPAjrE3AwYsxlyfPRx5
 jrNcWcmEPF09RKHUOBVVm+hTxrYzSNMp8MnJZn5M1bf7K/ijk8tSp7lQ9gPARMHOqpvv
 In25gZS2s9L7yJgIpSFhQRDirz71E5NF8oDN9kDHFaYtJjgnHv/BFLvRvHzRAbMbiV1P
 a3JcQDJheTZpM8aF9y6E2bDvdfvEAwS29qUJsxm8kYosJQ/55P8qmQnsQZNHVP4yUSCv
 sKUEh8Xb39Y8BPXdZnrIc2Bs2FR7ZvVceHFeYTUPNmI2FEpVLv3gE7ErSoHKR9Ddgaia Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7ksc9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:25:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLJqvb153064;
        Mon, 16 Mar 2020 21:23:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ys92as5qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:23:48 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GLNl96007345;
        Mon, 16 Mar 2020 21:23:47 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:23:46 -0700
Date:   Mon, 16 Mar 2020 14:23:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/14] xfs: remove xlog_state_want_sync
Message-ID: <20200316212345.GR256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-14-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:32PM +0100, Christoph Hellwig wrote:
> Open code the xlog_state_want_sync logic in its two callers given that
> this function is a trivial wrapper around xlog_state_switch_iclogs.
> 
> Move the lockdep assert into xlog_state_switch_iclogs to not lose this
> debugging aid, and improve the comment that documents
> xlog_state_switch_iclogs as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 50 +++++++++++++++++-------------------------------
>  1 file changed, 18 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 865dd1e08679..761b138d97ec 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -62,11 +62,6 @@ xlog_state_switch_iclogs(
>  	struct xlog_in_core	*iclog,
>  	int			eventual_size);
>  STATIC void
> -xlog_state_want_sync(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog);
> -
> -STATIC void
>  xlog_grant_push_ail(
>  	struct xlog		*log,
>  	int			need_bytes);
> @@ -938,7 +933,11 @@ xfs_log_write_unmount_record(
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
>  	atomic_inc(&iclog->ic_refcnt);
> -	xlog_state_want_sync(log, iclog);
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(log, iclog, 0);
> +	else
> +		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +		       iclog->ic_state == XLOG_STATE_IOERROR);
>  	error = xlog_state_release_iclog(log, iclog);
>  	xlog_wait_on_iclog(iclog);
>  
> @@ -2293,7 +2292,11 @@ xlog_write_copy_finish(
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  
> -		xlog_state_want_sync(log, iclog);
> +		if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +			xlog_state_switch_iclogs(log, iclog, 0);
> +		else
> +			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +			       iclog->ic_state == XLOG_STATE_IOERROR);
>  		if (!commit_iclog)
>  			goto release_iclog;
>  		spin_unlock(&log->l_icloglock);
> @@ -3069,11 +3072,12 @@ xlog_ungrant_log_space(
>  }
>  
>  /*
> - * This routine will mark the current iclog in the ring as WANT_SYNC
> - * and move the current iclog pointer to the next iclog in the ring.
> - * When this routine is called from xlog_state_get_iclog_space(), the
> - * exact size of the iclog has not yet been determined.  All we know is
> - * that every data block.  We have run out of space in this log record.
> + * Mark the current iclog in the ring as WANT_SYNC and move the current iclog
> + * pointer to the next iclog in the ring.
> + *
> + * When called from xlog_state_get_iclog_space(), the exact size of the iclog
> + * has not yet been determined, all we know is that we have run out of space in
> + * the current iclog.
>   */
>  STATIC void
>  xlog_state_switch_iclogs(
> @@ -3082,6 +3086,8 @@ xlog_state_switch_iclogs(
>  	int			eventual_size)
>  {
>  	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +	assert_spin_locked(&log->l_icloglock);
> +
>  	if (!eventual_size)
>  		eventual_size = iclog->ic_offset;
>  	iclog->ic_state = XLOG_STATE_WANT_SYNC;
> @@ -3323,26 +3329,6 @@ xfs_log_force_lsn(
>  	return ret;
>  }
>  
> -/*
> - * Called when we want to mark the current iclog as being ready to sync to
> - * disk.
> - */
> -STATIC void
> -xlog_state_want_sync(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -{
> -	assert_spin_locked(&log->l_icloglock);
> -
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -	} else {
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> -	}
> -}
> -
> -
>  /*****************************************************************************
>   *
>   *		TICKET functions
> -- 
> 2.24.1
> 
