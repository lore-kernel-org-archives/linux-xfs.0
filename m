Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41F2C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 23:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC7A20730
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 23:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ScOxhMKP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgDGXEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 19:04:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgDGXEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 19:04:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037MmCAv077488;
        Tue, 7 Apr 2020 23:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FmQYpHdYHtLGLUYVLp0pwwXkVQxx5Xgmqe00c2H1azY=;
 b=ScOxhMKPFBhY+fMz4CAqrUzvktAENb9SCO2s7uC/aGintxytu29uvzXbI7GbDsTfzm51
 dPqNSCnkYnbsrcxWV0JRhjSKMJxeQE++Nf8iARvMCdhPeB9RuVrEzglENiVfkAUZrNdN
 RBYceeXtgt++lN1e3DSoJHQjqYC3slEKv7O+GjVCp2lKUqXp1rvL39a2655wBiLW+SUt
 hwjAqOY9b8iR0dznIStdomHR5DZhKWJKLtgIiakTpWZx+1fyxXQuUH1tvlwJlSAN/QGz
 W8szQui4GDnQkqZbN2+mHUmbu5tBQcPVKQ9tyR1sm7UxjjioSqj4g4Mu/UmY3V/GW+dY 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m388fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 23:04:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037Mlh83117850;
        Tue, 7 Apr 2020 23:04:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3091m1q2ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 23:04:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 037N4i70006395;
        Tue, 7 Apr 2020 23:04:44 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 16:04:43 -0700
Subject: Re: [RFC v6 PATCH 03/10] xfs: extra runtime reservation overhead for
 relog transactions
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200406123632.20873-1-bfoster@redhat.com>
 <20200406123632.20873-4-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <24e8c67b-be11-cd04-81d1-8eeb1122f33e@oracle.com>
Date:   Tue, 7 Apr 2020 16:04:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200406123632.20873-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=2 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 5:36 AM, Brian Foster wrote:
> Every transaction reservation includes runtime overhead on top of
> the reservation calculated in the struct xfs_trans_res. This
> overhead is required for things like the CIL context ticket, log
> headers, etc., that are stolen from individual transactions. Since
> reservation for the relog transaction is entirely contributed by
> regular transactions, this runtime reservation overhead must be
> contributed as well. This means that a transaction that relogs one
> or more items must include overhead for the current transaction as
> well as for the relog transaction.
> 
> Define a new transaction flag to indicate that a transaction is
> relog enabled. Plumb this state down to the log ticket allocation
> and use it to bump the worst case overhead included in the
> transaction. The overhead will eventually be transferred to the
> relog system as needed for individual log items.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_shared.h |  1 +
>   fs/xfs/xfs_log.c           | 12 +++++++++---
>   fs/xfs/xfs_log.h           |  3 ++-
>   fs/xfs/xfs_log_cil.c       |  2 +-
>   fs/xfs/xfs_log_priv.h      |  1 +
>   fs/xfs/xfs_trans.c         |  3 ++-
>   6 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c45acbd3add9..1ede1e720a5c 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>   #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>   #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
> +#define XFS_TRANS_RELOG		0x80	/* requires extra relog overhead */
>   /*
>    * LOWMODE is used by the allocator to activate the lowspace algorithm - when
>    * free space is running low the extent allocator may choose to allocate an
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index d6b63490a78b..b55abde6c142 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -418,7 +418,8 @@ xfs_log_reserve(
>   	int		 	cnt,
>   	struct xlog_ticket	**ticp,
>   	uint8_t		 	client,
> -	bool			permanent)
> +	bool			permanent,
> +	bool			relog)
>   {
>   	struct xlog		*log = mp->m_log;
>   	struct xlog_ticket	*tic;
> @@ -433,7 +434,8 @@ xfs_log_reserve(
>   	XFS_STATS_INC(mp, xs_try_logspace);
>   
>   	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, relog,
> +				0);
>   	*ticp = tic;
>   
>   	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -831,7 +833,7 @@ xlog_unmount_write(
>   	uint			flags = XLOG_UNMOUNT_TRANS;
>   	int			error;
>   
> -	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> +	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, false, false);
>   	if (error)
>   		goto out_err;
>   
> @@ -3421,6 +3423,7 @@ xlog_ticket_alloc(
>   	int			cnt,
>   	char			client,
>   	bool			permanent,
> +	bool			relog,
>   	xfs_km_flags_t		alloc_flags)
I notice this routine already has a flag param.  Wondering if it would 
make sense to have a KM_RELOG flag instead of an extra bool param?  It 
would just be one less thing to pass around.  Other than that, it seems 
straight forward.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

>   {
>   	struct xlog_ticket	*tic;
> @@ -3431,6 +3434,9 @@ xlog_ticket_alloc(
>   		return NULL;
>   
>   	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> +	/* double the overhead for the relog transaction */
> +	if (relog)
> +		unit_res += (unit_res - unit_bytes);
>   
>   	atomic_set(&tic->t_ref, 1);
>   	tic->t_task		= current;
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 6d2f30f42245..f1089a4b299c 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -123,7 +123,8 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>   			  int		   count,
>   			  struct xlog_ticket **ticket,
>   			  uint8_t		   clientid,
> -			  bool		   permanent);
> +			  bool		   permanent,
> +			  bool		   relog);
>   int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
>   void	  xfs_log_ungrant_bytes(struct xfs_mount *mp, int bytes);
>   void      xfs_log_unmount(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b43f0e8f43f2..1c48e95402aa 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
>   {
>   	struct xlog_ticket *tic;
>   
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
> +	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, false, false,
>   				KM_NOFS);
>   
>   	/*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ec22c7a3867f..08d8ff9bce1a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -465,6 +465,7 @@ xlog_ticket_alloc(
>   	int		count,
>   	char		client,
>   	bool		permanent,
> +	bool		relog,
>   	xfs_km_flags_t	alloc_flags);
>   
>   
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4fbe11485bbb..1b25980315bd 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -177,6 +177,7 @@ xfs_trans_reserve(
>   	 */
>   	if (resp->tr_logres > 0) {
>   		bool	permanent = false;
> +		bool	relog	  = (tp->t_flags & XFS_TRANS_RELOG);
>   
>   		ASSERT(tp->t_log_res == 0 ||
>   		       tp->t_log_res == resp->tr_logres);
> @@ -199,7 +200,7 @@ xfs_trans_reserve(
>   						resp->tr_logres,
>   						resp->tr_logcount,
>   						&tp->t_ticket, XFS_TRANSACTION,
> -						permanent);
> +						permanent, relog);
>   		}
>   
>   		if (error)
> 
