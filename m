Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE1EC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C052070A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KpPC6eKC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCXUla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:41:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgCXUla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:41:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKd7CC077906;
        Tue, 24 Mar 2020 20:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1zYztVq+KPRE5cr/WHQnX9+JG3aQTk4FY31QWOu1tYE=;
 b=KpPC6eKCQipuRwnfT5JE0bO3TizzLy3IDPQEHFcx+/JUXnTdWHW/TzpI/tvEbmX69jdg
 MPr5DN02LYNqCATPJq/bmB84U4j9FQVNMDNex+mQInU4SW8s0nZIVfOLHdJCFyUdwm31
 u8WCuUNY+yranuaPo+Y8wEXVBAxb6eQrlTKXbuK/S9zX5/NSDJSNWFyCe1bJThv/YUzd
 vSGWYPiHax1zag29do1bZ3d36MrkH5xyaoa/psPhfgDwqTGKD8cht+BVUhSEqtgd0wPy
 fIM2Vr2kSx9WSyvz+6dsBZS96In5ez6hcpLChekJaGRgsRb6x4AAWagFdf3njGgRadmD zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ywavm6k1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKblj6094188;
        Tue, 24 Mar 2020 20:41:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yxw939sm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:23 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKfMPj031664;
        Tue, 24 Mar 2020 20:41:22 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:41:22 -0700
Date:   Tue, 24 Mar 2020 13:41:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: merge xlog_commit_record with xlog_write_done()
Message-ID: <20200324204120.GM29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:57PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_write_done() is just a thin wrapper around
> xlog_commit_record(), so they can be merged together easily. Convert
> all the xlog_commit_record() callers to use xlog_write_done() and
> merge the implementations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 44 +++++++++++---------------------------------
>  1 file changed, 11 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9a26ee8db238..a173b5925d1b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -24,13 +24,6 @@
>  kmem_zone_t	*xfs_log_ticket_zone;
>  
>  /* Local miscellaneous function prototypes */
> -STATIC int
> -xlog_commit_record(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*commitlsnp);
> -
>  STATIC struct xlog *
>  xlog_alloc_log(
>  	struct xfs_mount	*mp,
> @@ -478,22 +471,6 @@ xfs_log_reserve(
>   *		marked as with WANT_SYNC.
>   */
>  
> -/*
> - * Write a commit record to the log to close off a running log write.
> - */
> -int
> -xlog_write_done(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*lsn)
> -{
> -	if (XLOG_FORCED_SHUTDOWN(log))
> -		return -EIO;
> -
> -	return xlog_commit_record(log, ticket, iclog, lsn);
> -}
> -
>  static bool
>  __xlog_state_release_iclog(
>  	struct xlog		*log,
> @@ -1463,20 +1440,17 @@ xlog_alloc_log(
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
>  
> -
>  /*
>   * Write out the commit record of a transaction associated with the given
> - * ticket.  Return the lsn of the commit record.
> + * ticket to close off a running log write. Return the lsn of the commit record.
>   */
> -STATIC int
> -xlog_commit_record(
> +int
> +xlog_write_done(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket,
>  	struct xlog_in_core	**iclog,
> -	xfs_lsn_t		*commitlsnp)
> +	xfs_lsn_t		*lsn)
>  {
> -	struct xfs_mount *mp = log->l_mp;
> -	int	error;
>  	struct xfs_log_iovec reg = {
>  		.i_addr = NULL,
>  		.i_len = 0,
> @@ -1486,12 +1460,16 @@ xlog_commit_record(
>  		.lv_niovecs = 1,
>  		.lv_iovecp = &reg,
>  	};
> +	int	error;
>  
>  	ASSERT_ALWAYS(iclog);
> -	error = xlog_write(log, &vec, ticket, commitlsnp, iclog,
> -					XLOG_COMMIT_TRANS);
> +
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return -EIO;
> +
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
>  	if (error)
> -		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
>  }
>  
> -- 
> 2.25.1
> 
