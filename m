Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016D7C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19602070A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MnXjToz1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgCXUmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:42:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54200 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgCXUmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:42:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKeNm8038544;
        Tue, 24 Mar 2020 20:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uzcZVYiLVFNRAW665Lkka6r0oT6MPakJmKD30oemIec=;
 b=MnXjToz1AncAlV0iX9MCtnQ0/g4l56OpGNNesAscukJRMe8COUp5xZU3+0kiJ8Rj7uar
 iVCqeHMZcTDuINHbHohj9niPXAeFY+wUGGqM4cPOPBRmjN89th1CL87yW6eQwGLMGpOw
 bTDBoV/BoNtlhVytOcmEFWddL5rufwdTUYSsu4e/Elyeli0jvqQ5II7wcQ8AlFAve8TN
 //dg3M2tMKbor7cerjsSqMHc8uaJKg4xs5akHYT0Ixu6qJqJkFbhMGlKUVBhYCttoe8b
 FxT4q9lalJ7TY2sTh6PzJzssTBWnUYX7ooFrDqLB04KkOxj5n9h3cngUwOwj+KQ0kJcL DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac3j5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKcN4s037702;
        Tue, 24 Mar 2020 20:41:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yxw4q0u2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKfqQ3031941;
        Tue, 24 Mar 2020 20:41:52 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:41:51 -0700
Date:   Tue, 24 Mar 2020 13:41:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: refactor unmount record writing
Message-ID: <20200324204150.GN29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-8-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:58PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Separate out the unmount record writing from the rest of the
> ticket and log state futzing necessary to make it work. This is
> a no-op, just makes the code cleaner and places the unmount record
> formatting and writing alongside the commit record formatting and
> writing code.
> 
> We can also get rid of the ticket flag clearing before the
> xlog_write() call because it no longer cares about the state of
> XLOG_TIC_INITED.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 65 +++++++++++++++++++++++++++---------------------
>  1 file changed, 37 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a173b5925d1b..1d6ed696f717 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -471,6 +471,36 @@ xfs_log_reserve(
>   *		marked as with WANT_SYNC.
>   */
>  
> +/*
> + * Write out an unmount record using the ticket provided. We have to account for
> + * the data space used in the unmount ticket as this write is not done from a
> + * transaction context that has already done the accounting for us.
> + */
> +static int
> +xlog_write_unmount_record(
> +	struct xlog		*log,
> +	struct xlog_ticket	*ticket,
> +	xfs_lsn_t		*lsn,
> +	uint			flags)
> +{
> +	struct xfs_unmount_log_format ulf = {
> +		.magic = XLOG_UNMOUNT_TYPE,
> +	};
> +	struct xfs_log_iovec reg = {
> +		.i_addr = &ulf,
> +		.i_len = sizeof(ulf),
> +		.i_type = XLOG_REG_TYPE_UNMOUNT,
> +	};
> +	struct xfs_log_vec vec = {
> +		.lv_niovecs = 1,
> +		.lv_iovecp = &reg,
> +	};
> +
> +	/* account for space used by record data */
> +	ticket->t_curr_res -= sizeof(ulf);
> +	return xlog_write(log, &vec, ticket, lsn, NULL, flags);
> +}
> +
>  static bool
>  __xlog_state_release_iclog(
>  	struct xlog		*log,
> @@ -795,32 +825,14 @@ xlog_wait_on_iclog(
>  }
>  
>  /*
> - * Final log writes as part of unmount.
> - *
> - * Mark the filesystem clean as unmount happens.  Note that during relocation
> - * this routine needs to be executed as part of source-bag while the
> - * deallocation must not be done until source-end.
> + * Mark the filesystem clean by writing an unmount record to the head of the
> + * log.
>   */
> -
> -/* Actually write the unmount record to disk. */
>  static void
> -xfs_log_write_unmount_record(
> -	struct xfs_mount	*mp)
> +xlog_unmount_write(
> +	struct xlog		*log)
>  {
> -	/* the data section must be 32 bit size aligned */
> -	struct xfs_unmount_log_format magic = {
> -		.magic = XLOG_UNMOUNT_TYPE,
> -	};
> -	struct xfs_log_iovec reg = {
> -		.i_addr = &magic,
> -		.i_len = sizeof(magic),
> -		.i_type = XLOG_REG_TYPE_UNMOUNT,
> -	};
> -	struct xfs_log_vec vec = {
> -		.lv_niovecs = 1,
> -		.lv_iovecp = &reg,
> -	};
> -	struct xlog		*log = mp->m_log;
> +	struct xfs_mount	*mp = log->l_mp;
>  	struct xlog_in_core	*iclog;
>  	struct xlog_ticket	*tic = NULL;
>  	xfs_lsn_t		lsn;
> @@ -844,10 +856,7 @@ xfs_log_write_unmount_record(
>  		flags &= ~XLOG_UNMOUNT_TRANS;
>  	}
>  
> -	/* remove inited flag, and account for space used */
> -	tic->t_flags = 0;
> -	tic->t_curr_res -= sizeof(magic);
> -	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
> +	error = xlog_write_unmount_record(log, tic, &lsn, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
>  	 * transitioning log state to IOERROR. Just continue...
> @@ -913,7 +922,7 @@ xfs_log_unmount_write(
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return;
>  	xfs_log_unmount_verify_iclog(log);
> -	xfs_log_write_unmount_record(mp);
> +	xlog_unmount_write(log);
>  }
>  
>  /*
> -- 
> 2.25.1
> 
