Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D08C2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0B6320768
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 23:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FIX1vV1Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDFXwL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 19:52:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDFXwL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 19:52:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036NmSKX082764;
        Mon, 6 Apr 2020 23:52:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yHPmJRqwYPOYUKUBvtGRB6BfUK27wkW7l+XFFulXq1c=;
 b=FIX1vV1YE2IVnY2EKNz3/yfa0ASvGApDxFBov5SE1Dt5Nhd46YXFeB6lcxnO8FL7HFOU
 fWnvSTja0qDS4XT7V/AT5kVwtguMW92WVeHP7tYaR2CKJOv0Srjfzql5cRe1ADjaXM7I
 DrrVrDbVyaXog95L/PvhVF2l/hMpuBXE6auM0uk+BKHA7SlrMtW/kTMzI5ZqnkQQ2bkl
 M43Jvnid0EWGe5JOv5A8S/DoLYk0IZ+ecWTVE5eJ28OHWR6J/99FT1EXtLZ7u5DKIANc
 snfkvDeZtmLWcsQbCOeGCQUW6NM5cHgWmZGVIOWbylGA7o1p3RnDHJARewv3NXDXtTOB wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 306hnr1trs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 23:52:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036NmV6S062751;
        Mon, 6 Apr 2020 23:52:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30839rgrf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 23:52:07 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036Nq6Uk009919;
        Mon, 6 Apr 2020 23:52:06 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 16:52:06 -0700
Subject: Re: [RFC v6 PATCH 02/10] xfs: create helper for ticket-less log res
 ungrant
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200406123632.20873-1-bfoster@redhat.com>
 <20200406123632.20873-3-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a617b9a3-95b4-fc9f-7383-bffab3f22c84@oracle.com>
Date:   Mon, 6 Apr 2020 16:52:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200406123632.20873-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 5:36 AM, Brian Foster wrote:
> Log reservation is currently acquired and released via log tickets.
> The relog mechanism introduces behavior where relog reservation is
> transferred between transaction log tickets and an external pool of
> relog reservation for active relog items. Certain contexts will be
> able to release outstanding relog reservation without the need for a
> log ticket. Factor out a helper to allow byte granularity log
> reservation ungrant.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Looks straight forward:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c | 20 ++++++++++++++++----
>   fs/xfs/xfs_log.h |  1 +
>   2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00fda2e8e738..d6b63490a78b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2980,6 +2980,21 @@ xfs_log_ticket_regrant(
>   	xfs_log_ticket_put(ticket);
>   }
>   
> +/*
> + * Restore log reservation directly to the grant heads.
> + */
> +void
> +xfs_log_ungrant_bytes(
> +	struct xfs_mount	*mp,
> +	int			bytes)
> +{
> +	struct xlog		*log = mp->m_log;
> +
> +	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
> +	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
> +	xfs_log_space_wake(mp);
> +}
> +
>   /*
>    * Give back the space left from a reservation.
>    *
> @@ -3018,12 +3033,9 @@ xfs_log_ticket_ungrant(
>   		bytes += ticket->t_unit_res*ticket->t_cnt;
>   	}
>   
> -	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
> -	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
> -
> +	xfs_log_ungrant_bytes(log->l_mp, bytes);
>   	trace_xfs_log_ticket_ungrant_exit(log, ticket);
>   
> -	xfs_log_space_wake(log->l_mp);
>   	xfs_log_ticket_put(ticket);
>   }
>   
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 1412d6993f1e..6d2f30f42245 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -125,6 +125,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>   			  uint8_t		   clientid,
>   			  bool		   permanent);
>   int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> +void	  xfs_log_ungrant_bytes(struct xfs_mount *mp, int bytes);
>   void      xfs_log_unmount(struct xfs_mount *mp);
>   int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
>   
> 
