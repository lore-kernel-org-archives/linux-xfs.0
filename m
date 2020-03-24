Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725EAC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4567C2074D
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:40:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YKi0mCOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCXUk0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:40:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53026 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgCXUk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:40:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKeKoT038431;
        Tue, 24 Mar 2020 20:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ANaQMszsznak47Q7v9YOIgcKA0XtC+a3YThUtuifA6k=;
 b=YKi0mCODbtqr6TQckVo3NG4bb+W1wpCaQ7W/0DImXZoAO7TmHI5MlkhPfNMbGoMN3xCu
 bw9wQLpdLRfp0ucWPPA+72/K8sI6UnWEbdkvd6HijdKyp17ISeG/GhdFbk268I4UkUbt
 wr3RwBQz8ShN/i0HIRJm8GfOkOCylAa0/DwP4Qf/BAC+ZkN7MrMP9WyUzM9bsiXLsLsA
 QFmADzvev3KL1UvYhwzKPHMvMGw8RlE5dSdgJ6XX3+AOV2WD6MnnF1vG9G4Xff9fAOTt
 AKsq288/Bg+byQ6iHcqNoTAWALhPe9ApAJ2EQjyY24vhuYWJqoBKCT/RR4I0z2wF/C+y Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yx8ac3hvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:40:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKaSLD089327;
        Tue, 24 Mar 2020 20:40:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yymbubc67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:40:14 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKeDnM022402;
        Tue, 24 Mar 2020 20:40:13 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:40:13 -0700
Date:   Tue, 24 Mar 2020 13:40:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: kill XLOG_TIC_INITED
Message-ID: <20200324204011.GK29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Tue, Mar 24, 2020 at 06:44:55PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is not longer used or checked by anything, so remove the last
> traces from the log ticket code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c      | 4 ----
>  fs/xfs/xfs_log_priv.h | 6 ++----
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 528ace7a6bb9..b30bb6452494 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2346,9 +2346,6 @@ xlog_write(
>  	 * to account for an extra xlog_op_header here.
>  	 */
>  	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> -		ticket->t_flags &= ~XLOG_TIC_INITED;
> -
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -3488,7 +3485,6 @@ xlog_ticket_alloc(
>  	tic->t_ocnt		= cnt;
>  	tic->t_tid		= prandom_u32();
>  	tic->t_clientid		= client;
> -	tic->t_flags		= XLOG_TIC_INITED;
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 32bb6856e69d..cfe5295ef4e3 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -51,13 +51,11 @@ enum xlog_iclog_state {
>  };
>  
>  /*
> - * Flags to log ticket
> + * Log ticket flags
>   */
> -#define XLOG_TIC_INITED		0x1	/* has been initialized */
> -#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
> +#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
>  
>  #define XLOG_TIC_FLAGS \
> -	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
>  	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
>  
>  /*
> -- 
> 2.25.1
> 
