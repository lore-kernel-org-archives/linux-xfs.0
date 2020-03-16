Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78A6C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78BEF20658
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yC85Wnu4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgCPUVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 16:21:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPUVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 16:21:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKIjlr178904;
        Mon, 16 Mar 2020 20:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4993K+1OY87JAPYzEzEnSwRbc3gWOiFiyJNPsJzSwSI=;
 b=yC85Wnu4HQiie84UrAP4roBoUYy3o9200semTdRMge9o7KEp5TFXbpIG/VHLM7bv43jV
 Wg/XfGERBtBW7zNOeyNaIDT4U3fkFY0QSG1QpvDIipBBVzRf/xueOpU14LDj7c07Xmle
 U/4o8j1HueLapGdrEQnrkyry7JfMA2nLqu7vbSCa2DK8q2heF+rz/oGUuI46FUHtI5kR
 2wNEsE/Z40+WInOlG6Z7CU8nHs5EN/AKrGkDB/yMdSrANI07XHmAwME7TvKqXz9hbS9k
 +KQok50vROl5yow0oVERIj3lyDSHkZY6Y5QG+iaZBUw+pDS8lwZgLqZ3J9BuU+a06K6V /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppr165t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:21:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKKVH5098750;
        Mon, 16 Mar 2020 20:21:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ys8ywhjfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:21:39 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GKLbfI018067;
        Mon, 16 Mar 2020 20:21:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 13:21:37 -0700
Date:   Mon, 16 Mar 2020 13:21:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfs: simplify the xfs_log_release_iclog calling
 convention
Message-ID: <20200316202135.GI256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160085
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:22PM +0100, Christoph Hellwig wrote:
> The only caller of xfs_log_release_iclog doesn't care about the return
> value, so remove it.  Also don't bother passing the mount pointer,
> given that we can trivially derive it from the iclog.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c     | 10 ++++------
>  fs/xfs/xfs_log.h     |  3 +--
>  fs/xfs/xfs_log_cil.c |  2 +-
>  3 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 955df2902c2c..17ba92b115ea 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -597,12 +597,11 @@ xlog_state_release_iclog(
>  	return 0;
>  }
>  
> -int
> +void
>  xfs_log_release_iclog(
> -	struct xfs_mount        *mp,
>  	struct xlog_in_core	*iclog)
>  {
> -	struct xlog		*log = mp->m_log;
> +	struct xlog		*log = iclog->ic_log;
>  	bool			sync;
>  
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> @@ -618,10 +617,9 @@ xfs_log_release_iclog(
>  		if (sync)
>  			xlog_sync(log, iclog);
>  	}
> -	return 0;
> +	return;
>  error:
> -	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> -	return -EIO;
> +	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 84e06805160f..b38602216c5a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -121,8 +121,7 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
>  void	  xfs_log_space_wake(struct xfs_mount *mp);
> -int	  xfs_log_release_iclog(struct xfs_mount *mp,
> -			 struct xlog_in_core	 *iclog);
> +void	  xfs_log_release_iclog(struct xlog_in_core *iclog);
>  int	  xfs_log_reserve(struct xfs_mount *mp,
>  			  int		   length,
>  			  int		   count,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 6a6278b8eb2d..047ac253edfe 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -866,7 +866,7 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/* release the hounds! */
> -	xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	xfs_log_release_iclog(commit_iclog);
>  	return;
>  
>  out_skip:
> -- 
> 2.24.1
> 
