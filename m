Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92F3C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 11:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355266AbiCPLNg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355270AbiCPLNf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 07:13:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3626665781
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 04:12:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GB0EGx011440;
        Wed, 16 Mar 2022 11:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=l6eGXSVyNWvtX8VnrqJRjGN10xBneCMiVPLuITgCaoM=;
 b=WgUPoLDSH6tOfgY/Ok5o7BlL1Vv0ZcP74imM8Z6JW/fq2dCORyqQGqc3hDFOeSkQ1Agt
 iyOWg9iMgC7qzylK+kY1cuWTllHHUuqs0AeJn+E/oRpJfNFq2LE/df07hij83IwFrPkY
 idlI6bVZOgzood9wH/n+i/H+Oo3tqvZw50OSCjOmKx4s9NtdwEsahlZb8SyNZuQA6Ti9
 xHSaRu8QQZwZMN/qNwplpJu/ahS5oZh+5t+/CC4PmyHLXbAgS/TJoP7ZlKmS/VNOsgDs
 FwoKUBzqAJW3bwYzOKxiysdhyAralssQIFCOmY/Aqj4888dcDCv5b8xIJyYRBPIrt/Cg kg== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6nue5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 11:12:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GBAVA4148711;
        Wed, 16 Mar 2022 11:12:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 3et64tx45c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 11:12:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgoHsEShvpvRVdSguUEh6JLOyMAkZT2OjeGnwV/c1HC8i6hT6HrzoSI8FV3corOKbqTD9tMVhBEBEx0C2ZTXTeyb3VsMo/aVM2dz9PxCi2/c9qGP1twYTnXZsxY+RL7cUv76wUiVwx+nplZZaGpWY9FmgWxQaHFcD/xVfTJZXKZrIMnpSNiwszDtyDgnSLqNkVLJfMm2pcSWSldh5P6vs/2C/KsvVY8Q3DwW5gDZc/lFXgY1Y01Vc1LGr7aIaNyljvIR1MpFinz60ayqDnwQHI11f+a9Tg+zQ42LriB2NV427ZF5y1lB6iihqOqeGOWPEPaJV1z5LreCF1rSHw4wSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6eGXSVyNWvtX8VnrqJRjGN10xBneCMiVPLuITgCaoM=;
 b=T1zRD/6iusxjp48X8XDl0EVlk3rLL7Ferumdt02tEZldAj7ccpEy5Wc9x1Y8pqAHp/jlmpjSpUQiCtYvwK8Cb6LpTSs9Zh0I2M3Ei5yGLW/xH72zSlywrcLo81V5N4tvOqThSNQfH1rEIYFd4z6bzOIiE3odKqivUMVDxI672IDGzM7aU/qGE9QGzM+3UGf4HesA7ii8suL1R8XTrVYUl7qQZycZIMwMZjfPyAvswSEI4oSTEQ8IMm4p0BKgnoZtRu3bbTLRMuk+sRkY3W9qsQqLhZzsMCrECukip2Wc/b2wswra7IU+v1xEGKqU9hO9KQS8HHq9s0MDlk7wNWfrow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6eGXSVyNWvtX8VnrqJRjGN10xBneCMiVPLuITgCaoM=;
 b=Z4ka6OEvml9gIS1Q3Gu/nyv3lsoqyY6VZsJQkFFUHF1SJDND7NoU57dAJPay44xcM0oG13jHo8Wq41B5vx+a92zD4VshIqiiHGZOAqv+XnVhidm7ICXUPahiFVgLOEatOIEjS9IPTjVdZ7HBigjWkbn+hJAuShhX8hs0neusw20=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB2850.namprd10.prod.outlook.com (2603:10b6:208:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 11:12:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 11:12:16 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-7-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: AIL should be log centric
In-reply-to: <20220315064241.3133751-7-david@fromorbit.com>
Message-ID: <87v8wecfsm.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Mar 2022 16:42:09 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0040.jpnprd01.prod.outlook.com
 (2603:1096:405:1::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f32c2d57-f0ca-4f81-0cb6-08da073dd46a
X-MS-TrafficTypeDiagnostic: BL0PR10MB2850:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB285080699E7F37791A197546F6119@BL0PR10MB2850.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9f1vEo0iT2SvOUi5o3KUvAw8JMh1p21ukeM9Zgtk3S1w8bTnJCymgWSYIfbu69PZ6y3wzVk9/rwJ31V8UqPovYwyRw6hkLUcDstAP4vBnSYG6VpC2Kkh1ev9OCGgUBETr62Kudz0pyo8fan3pS5sL8kZ2ZFoWx+IzRw3Iz7vuRMPaWWN/UNUibQt66K9gQpOnSRqsnPkQtxONtxj1thhvcS4WJSEozEN5pKxKsAvdbKW+OZAN4a7vBW++IhlZGullILH8DBYBNUvaNcWO+z22u1+CBe5AJWjnWXPXROA2MFnqWPikt5QFoWRLrb090XtYfUYnOLQjR7OZV2FKhwXnIdFWwRVCKAP/doLvnI9cYWcOGlf0DR120mFNXRFALetaOxRuuArJk6Q2lUpYkOdAo5odfaGbSdId0ErsJQxf1BJB7KasoxjRpwbIMcqA02EPzci2Bg3Y+YiZ5mmH/dAOKV0uiT1WD+vyn+KOR/dfxRmEd/2SOPIoR+83TbnThAw6pPKGPfKJrUmJgOX/sMsfF/pCqe5MDNWOg2h4u1koJRWYt3RX9PF7RShwWyMCgFPknpfX0vxnczHxNFLa6U51jNN2ezOfcs+lPKRFAU8ADwW7Eh5tIVu4CNCHBIXNndhxS2pwVCdaa5R/mnn7LtLSrt7zUpsmzr50dOxSFm+JxVENKB91CDuoMPDdvMxzzOgSpYW3uqH1ZwDxSF2ZiMlhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(186003)(83380400001)(86362001)(38100700002)(38350700002)(33716001)(8936002)(66946007)(6486002)(6666004)(4326008)(316002)(8676002)(52116002)(53546011)(6506007)(508600001)(66476007)(66556008)(5660300002)(2906002)(9686003)(6512007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2KlNu9RbXX7e56jOg7b647Ayx5dRUgsPJ8lQWlxfy9dVoWCYkjmecUkx/b/f?=
 =?us-ascii?Q?W8bGNEPwCgKPG9/I3cQJM8+vRWZ8O0ZB43jhm0No0HrhjqIEYmW+6bkG+A24?=
 =?us-ascii?Q?oWdCht8WcezqCr0uLhqTg5wpJeYSdSkD2/arvON9B/LYlJprajuy4/xq9KbH?=
 =?us-ascii?Q?zi6iGKoKH1uEymQemiQPkHPPTb2/E+eV417OQO2QuXr6dB5pVHQldivORXUl?=
 =?us-ascii?Q?0Xt0YkOUh9fl8yzkZQv75zxjdtwjRH60OjvArM90X98At7PrqEcuqUFhcvKF?=
 =?us-ascii?Q?7J1Vgeucbzce8j/5XDYbiGycSHReVzCfsaLFcVq+hzvc4E2B8hYptsmn0m8K?=
 =?us-ascii?Q?qW/FyVxkE4VYDuaQdJ/HfUSY+5b5st7fokplsZx92K6ZrIQt5QDpOhoiBZ69?=
 =?us-ascii?Q?D4Or1RENM2D1J9vA/fH/TU8BWYRQX/2NAUdgxsgRU0F09VojHiTn5yoiTt8Y?=
 =?us-ascii?Q?izCdAeDQffLoGzU+6UQFm6gX8w5Ve4Itr4CR+5m4xtiCh8nsBQi0twZMrtBu?=
 =?us-ascii?Q?AxFtwE16VP0zo730sjOo1GCwzTeNWql9T7L90H7HrnKyrzqRkVRhu4uBnNyR?=
 =?us-ascii?Q?71gI5cR7DcwJJR4gspvyDhU0bf9VqZKiXusWUUDIU/oky08U6yk9Kv/JJmOp?=
 =?us-ascii?Q?ufsJA0AvGR5tK2b7stTCTAZMzXQak8mZ6Z0LNE4q6rjRChKlcfvnfrwtlNwV?=
 =?us-ascii?Q?db4FQdEiH2IZmeepbDFpZlD8cbhRO9HzmGDQJhVcYDveF+cIEmrlqM7ThnnX?=
 =?us-ascii?Q?I0dWr2daMqpsYznW8PEV5GQv6KnU0IHnAVcqqVcjAfCnanVlN0p4m/wVPDQ7?=
 =?us-ascii?Q?f9QGJlIteqckp1RsVQkF3Cu9slzihCKCFQ9Urgj9YSVzEKpzO4XGgwWR6xYm?=
 =?us-ascii?Q?j0bVLJJex6usUcWI1eCmh23/T1AC3guzGb8XekJhxEzUg1NEFRRzMUjR7sC7?=
 =?us-ascii?Q?9Gg2Jj9nK6QfwB9lQ8UQUQOHJNRuPwfbTx2q0ah0NthV8CWi8U7EqxAHAGTZ?=
 =?us-ascii?Q?RrFv05kXW3pQgqrZPSfLf/guos5GOEuoFNhOHEt+mnriQ7GVHNV3B5K0bIZQ?=
 =?us-ascii?Q?dhF9z5MheiqiJ4BmhdhK/nSnzo1RIFIegNrRaB37zH6F9b9K0alabHvMmz7n?=
 =?us-ascii?Q?33uvJhVYW/CMKe7S0Q4wqHGXsMOTTWDolxBZ8Oo0ZeJ728m7lzgsb3OZk1aY?=
 =?us-ascii?Q?C0DpJvCyz1k6kfdEqWVgbL8M7Xx/MSF2TBqHRTZBJP9u93wAR3BuVG9PWq+r?=
 =?us-ascii?Q?OttUf7UzVdsUDUjjkEHK8XnGeCmOsKgMloIv0srinh/9y2AKPFqQSjW4oT+F?=
 =?us-ascii?Q?+bO+72ANrl+gbicAjkllqW9+LcRBi6eWBl/Pd8HVdpMXtpKSukZALQxfWSAd?=
 =?us-ascii?Q?L2KjYUfktahsbRtscYhpoEzmUNA+SnoanRDl+o1jIZE97SHWfSV7yXJ+iNFd?=
 =?us-ascii?Q?K8E3rv3wRqmsjlq1NUmIRwO+NIKi8lJgIZpW+QFyVGSPQvB/AZEd3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32c2d57-f0ca-4f81-0cb6-08da073dd46a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 11:12:16.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VsdJAL79gR4IFI6bEvstM1XBO6j7D/1DraIFr9Fhr0nAmfVmUBB/tmCkH1+GHD+yYjM5dnwz7ijkzkiTYObVyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2850
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10287 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203160069
X-Proofpoint-GUID: 2Poh_kHhsz9u8Hfu3QOGrdqw-Ub_T-QX
X-Proofpoint-ORIG-GUID: 2Poh_kHhsz9u8Hfu3QOGrdqw-Ub_T-QX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> The AIL operates purely on log items, so it is a log centric
> subsystem. Divorce it from the xfs_mount and instead have it pass
> around xlog pointers.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans.c      |  2 +-
>  fs/xfs/xfs_trans_ail.c  | 26 +++++++++++++-------------
>  fs/xfs/xfs_trans_priv.h |  3 ++-
>  3 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index de87fb136b51..831d355c3258 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -773,7 +773,7 @@ xfs_trans_committed_bulk(
>  		 * object into the AIL as we are in a shutdown situation.
>  		 */
>  		if (aborted) {
> -			ASSERT(xfs_is_shutdown(ailp->ail_mount));
> +			ASSERT(xlog_is_shutdown(ailp->ail_log));
>  			if (lip->li_ops->iop_unpin)
>  				lip->li_ops->iop_unpin(lip, 1);
>  			continue;
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 1b52952097c1..c2ccb98c7bcd 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -398,7 +398,7 @@ xfsaild_push_item(
>  	 * If log item pinning is enabled, skip the push and track the item as
>  	 * pinned. This can help induce head-behind-tail conditions.
>  	 */
> -	if (XFS_TEST_ERROR(false, ailp->ail_mount, XFS_ERRTAG_LOG_ITEM_PIN))
> +	if (XFS_TEST_ERROR(false, ailp->ail_log->l_mp, XFS_ERRTAG_LOG_ITEM_PIN))
>  		return XFS_ITEM_PINNED;
>  
>  	/*
> @@ -418,7 +418,7 @@ static long
>  xfsaild_push(
>  	struct xfs_ail		*ailp)
>  {
> -	xfs_mount_t		*mp = ailp->ail_mount;
> +	struct xfs_mount	*mp = ailp->ail_log->l_mp;
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	xfs_lsn_t		lsn;
> @@ -443,7 +443,7 @@ xfsaild_push(
>  		ailp->ail_log_flush = 0;
>  
>  		XFS_STATS_INC(mp, xs_push_ail_flush);
> -		xlog_cil_flush(mp->m_log);
> +		xlog_cil_flush(ailp->ail_log);
>  	}
>  
>  	spin_lock(&ailp->ail_lock);
> @@ -632,7 +632,7 @@ xfsaild(
>  			 * opportunity to release such buffers from the queue.
>  			 */
>  			ASSERT(list_empty(&ailp->ail_buf_list) ||
> -			       xfs_is_shutdown(ailp->ail_mount));
> +			       xlog_is_shutdown(ailp->ail_log));
>  			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
>  			break;
>  		}
> @@ -695,7 +695,7 @@ xfs_ail_push(
>  	struct xfs_log_item	*lip;
>  
>  	lip = xfs_ail_min(ailp);
> -	if (!lip || xfs_is_shutdown(ailp->ail_mount) ||
> +	if (!lip || xlog_is_shutdown(ailp->ail_log) ||
>  	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
>  		return;
>  
> @@ -751,7 +751,7 @@ xfs_ail_update_finish(
>  	struct xfs_ail		*ailp,
>  	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
>  {
> -	struct xfs_mount	*mp = ailp->ail_mount;
> +	struct xlog		*log = ailp->ail_log;
>  
>  	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
>  	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
> @@ -759,13 +759,13 @@ xfs_ail_update_finish(
>  		return;
>  	}
>  
> -	if (!xfs_is_shutdown(mp))
> -		xlog_assign_tail_lsn_locked(mp);
> +	if (!xlog_is_shutdown(log))
> +		xlog_assign_tail_lsn_locked(log->l_mp);
>  
>  	if (list_empty(&ailp->ail_head))
>  		wake_up_all(&ailp->ail_empty);
>  	spin_unlock(&ailp->ail_lock);
> -	xfs_log_space_wake(mp);
> +	xfs_log_space_wake(log->l_mp);
>  }
>  
>  /*
> @@ -873,13 +873,13 @@ xfs_trans_ail_delete(
>  	int			shutdown_type)
>  {
>  	struct xfs_ail		*ailp = lip->li_ailp;
> -	struct xfs_mount	*mp = ailp->ail_mount;
> +	struct xfs_mount	*mp = ailp->ail_log->l_mp;
>  	xfs_lsn_t		tail_lsn;
>  
>  	spin_lock(&ailp->ail_lock);
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> -		if (shutdown_type && !xfs_is_shutdown(mp)) {
> +		if (shutdown_type && !xlog_is_shutdown(ailp->ail_log)) {
>  			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
>  	"%s: attempting to delete a log item that is not in the AIL",
>  					__func__);
> @@ -904,7 +904,7 @@ xfs_trans_ail_init(
>  	if (!ailp)
>  		return -ENOMEM;
>  
> -	ailp->ail_mount = mp;
> +	ailp->ail_log = mp->m_log;
>  	INIT_LIST_HEAD(&ailp->ail_head);
>  	INIT_LIST_HEAD(&ailp->ail_cursors);
>  	spin_lock_init(&ailp->ail_lock);
> @@ -912,7 +912,7 @@ xfs_trans_ail_init(
>  	init_waitqueue_head(&ailp->ail_empty);
>  
>  	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
> -			ailp->ail_mount->m_super->s_id);
> +				mp->m_super->s_id);
>  	if (IS_ERR(ailp->ail_task))
>  		goto out_free_ailp;
>  
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 3004aeac9110..f0d79a9050ba 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -6,6 +6,7 @@
>  #ifndef __XFS_TRANS_PRIV_H__
>  #define	__XFS_TRANS_PRIV_H__
>  
> +struct xlog;
>  struct xfs_log_item;
>  struct xfs_mount;
>  struct xfs_trans;
> @@ -50,7 +51,7 @@ struct xfs_ail_cursor {
>   * Eventually we need to drive the locking in here as well.
>   */
>  struct xfs_ail {
> -	struct xfs_mount	*ail_mount;
> +	struct xlog		*ail_log;
>  	struct task_struct	*ail_task;
>  	struct list_head	ail_head;
>  	xfs_lsn_t		ail_target;


-- 
chandan
