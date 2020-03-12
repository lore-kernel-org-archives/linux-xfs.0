Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EFBC10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96A0220716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 23:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cAfzXShm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgCLXvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 19:51:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCLXvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 19:51:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNhYt2115149;
        Thu, 12 Mar 2020 23:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SX14kyTVG5I8H7bSohozbphk/4lR1vUAmHuJuqpru9k=;
 b=cAfzXShmlruNe6JERkLjtAzZO66eCAwpuG02LgCBFjGk99hVJR/YKJ4p2HZJK3Y0ym+N
 q7E2Gs8KXhum0FZSNrGY1DfFil73NRcjlZi2m2813X+T/DpIX862DGBAHE+FV7gZVyym
 I2i435RJSw078Tkcgli0xPWAvO9OFdxSPUjOfVimelXvkQEZmEovxpnd0Zi3IsbFw/FW
 wMFxyQ++WlhyIhfdTznEcSalGavwCAmcNHPLAD0J1JSHctDu7dnZXcIy1zVlazBwEL+w
 pNvkAOnNL+asJMPpdvKHhalw3b+jxIOg23RirQlGEKCpM67G4edeOnxgRtUOgVG94z2s iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yqtavh5d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:51:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CNnxlI031991;
        Thu, 12 Mar 2020 23:51:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yqtaty572-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 23:51:24 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CNpMbA014504;
        Thu, 12 Mar 2020 23:51:23 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 16:51:22 -0700
Date:   Thu, 12 Mar 2020 16:51:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: remove dead code from xfs_log_unmount_write
Message-ID: <20200312235121.GV8045@magnolia>
References: <20200312143959.583781-1-hch@lst.de>
 <20200312143959.583781-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312143959.583781-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003120117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003120117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:39:58PM +0100, Christoph Hellwig wrote:
> When the log is shut down all iclogs are in the XLOG_STATE_IOERROR state,
> which means that xlog_state_want_sync and xlog_state_release_iclog are
> no-ops.  Remove the whole section of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 35 +++--------------------------------
>  1 file changed, 3 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa499ddedb94..b56432d4a9b8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -984,38 +984,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		iclog = iclog->ic_next;
>  	} while (iclog != first_iclog);
>  #endif
> -	if (! (XLOG_FORCED_SHUTDOWN(log))) {
> -		xfs_log_write_unmount_record(mp);
> -	} else {
> -		/*
> -		 * We're already in forced_shutdown mode, couldn't
> -		 * even attempt to write out the unmount transaction.
> -		 *
> -		 * Go through the motions of sync'ing and releasing
> -		 * the iclog, even though no I/O will actually happen,
> -		 * we need to wait for other log I/Os that may already
> -		 * be in progress.  Do this as a separate section of
> -		 * code so we'll know if we ever get stuck here that
> -		 * we're in this odd situation of trying to unmount
> -		 * a file system that went into forced_shutdown as
> -		 * the result of an unmount..
> -		 */
> -		spin_lock(&log->l_icloglock);
> -		iclog = log->l_iclog;
> -		atomic_inc(&iclog->ic_refcnt);
> -		xlog_state_want_sync(log, iclog);
> -		xlog_state_release_iclog(log, iclog);
> -		switch (iclog->ic_state) {
> -		case XLOG_STATE_ACTIVE:
> -		case XLOG_STATE_DIRTY:
> -		case XLOG_STATE_IOERROR:
> -			spin_unlock(&log->l_icloglock);
> -			break;
> -		default:
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -	}
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return;
> +	xfs_log_write_unmount_record(mp);
>  }
>  
>  /*
> -- 
> 2.24.1
> 
