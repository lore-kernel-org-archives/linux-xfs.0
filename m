Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9821C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhKVLk1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:40:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59078 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234018AbhKVLk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:40:26 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMALqpS024892;
        Mon, 22 Nov 2021 11:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=pOps8GHDWYCobs5DVKRHXEraEZVc6Q2BuzCr4AuATFU=;
 b=JHwbmQChmsTXgW0NJo4I/d1ptThVk8lcbTn/RO0XZbT/p/cod5KWlK/JAwnxmOOqjfH7
 TsK5SLO8sSJfKaVEayIrSqSRYKpQcy3sh3rGsq3DmooGBmrfUxDLnTNC+Rr0ZvGvuNH2
 5/Y2+IaWyz9fUfUNP1YzZjqNTgy6kEZ5LgiaRewvYwVyigL8vR9ijVQNv1AMq/o6R1/t
 sGxZR0HOFniBEoorszHB4TDhuokBnCxkmBseP5XfgXZsMbJFZT74ePwlPNNNqlYSNFKY
 fg8EpXEDWZHCSuoN1ilvL2nYJ60os1jojROdfrAtI9vmU4QLobS2d2hu3P1LGa57tspS /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69m97t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:37:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBUw5C030443;
        Mon, 22 Nov 2021 11:37:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3ceru3cces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpx3Z5NSOffK0focuWnrm7DU96HFqx7SBfn+XRuKZmpIanKKk8KKBepFAoQ6E0kiM3NveBSIq2v1YlGdYPq4vQPWiMUt1AnquugDVTD/WFoE+qB3t9+ZIpNKfDD6dNWPDYZLMel2/GBM+KhyyQ4ZyrQoGQZkXKIXzVqnOmcGLXEr5hOo19aBVS1vHi3AQEgOXn5y04nSnvHtsApSddwhDs5rEaiU6j4y5uipvCHf8BTvFi/GrLtMmov8oA6HCJjkAoLOqXdFN/ePSJWpQ/ST9I0iiFg6l/YLs7mf6pbVoGV7QG9zVJiPGnY2sDJURHh2CeH/G3x0m5CO1Mr6jsGWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOps8GHDWYCobs5DVKRHXEraEZVc6Q2BuzCr4AuATFU=;
 b=eJNdvZqFrHUGaqZigdUV1NJQ+EEOz05NM5o/6sjOpYIfac89tHIXSvlBvRqjVeRvspf9Bmx3pFtymFRVfsXSLqrQMZAOqJfulZt+qSclUeba17z4iMsKqqepc603Lbx02VpllAKwmCFsTGATuaeWTQMxu+VO0kt4pffKML2wVbXjCaUcbtLfFlt8InN/7K+sPK9xQppydcRd6BxyPLNzMO0BozvyyaunT7jA2L9XqDo9KotL2AKC+Kt1rSNU/hEBksnSiY+lexWNntX5hG3YunSVaCDO5+d+tF5Ts274pXAQFwW3VikjUYonikae+wUpH52d0MHuH7Ln45M512WFgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOps8GHDWYCobs5DVKRHXEraEZVc6Q2BuzCr4AuATFU=;
 b=uEpNvKL3M+0RDdTDdtkeTyOimguPn4Sn3nj/q0ey7e2URy/DF4OsNvpUPpfdc9bHGvBbfymHsLd8SmrIIcvdN7halhDu7AIV3yBLbIXsS1r9cw1oFI//6sszR+ajXD4xSttN0aDd+OHuJZMrMQYwC5O8BPe8SCRJkWVfU5FIT9w=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:37:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:37:16 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-6-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs: log tickets don't need log client id
Message-ID: <8735npvbww.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-6-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 17:07:07 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by SI2PR01CA0036.apcprd01.prod.exchangelabs.com (2603:1096:4:192::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Mon, 22 Nov 2021 11:37:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4fb8da7-142f-4e98-4e69-08d9adac6f05
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB24962D73A0053395F936055DF69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mN2L6xyPmY/PWP8leWelEPyYEBzFxUPQqEUHWeIpipg14kycFrd3qJt29tpBKcfHBmAjWPYXM/oQg1sL5OOPgIzMAdh4Z7AmDOJq3lR7aeOxZ7a/915IkaACOcY5wxKBx0U8hP96FvutnNhU756NpQkD8+MSmoLsv5NJNTkRGVxuzfodij0d1qyA7MRMKHvKNqU9H9+zVjd+ImH2v4Imbwv5BuXj3A2PRML/AyAhJdUsv+HKqy8dxKuhk2B2cXmGvL5hI7GDgYBP6SfbWSaniodkYPs15T6yVRAyHloZG/0L46vsnZOH6/+P2ly838X/VI1u/3Pz38c6spHGjCEE4iY3+xjwo83ngzrD2hYPmFX4MaXTqkmUvxl7lVlTUixykx4VJ95dghGIa0uqS+QjTgf6mIawBxBWxZQH/faTUoRc/+J0opQRYwW44tEzPicTL2prM4YtNbk0nGBxe+SYUtYOGJCwFmI1mQjNdajBtZq9AYyOlsgmr4yodxZkEx11ncdzdDPzBcDm4oPgJnhLv+5w7Rz6RNTZZKOd+NTjjLDTib3t/B5TWhE6rBf945aTlSCMYCp27qETFG0kjAhbJwj2kVwX6/8spPO5wb+QNHdLHEvrCIN3gqmfsAhjuOnUOGDdeFQ7VYil8JkeVVbgFif9jvnv8uhdY4RTuNXT28i7BbWJNP2ysNhoF9onL9PdV/u1M422CyIhWchfItwLrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UCbri/NdPFbDJsi2eT1jaRWyNhTZyyNcUZEvTIq75rV/IKdN6LMxt0fBRFkY?=
 =?us-ascii?Q?Q9OB31pX55y2J4BkbyBOX/1Ea+TujPskHjNv1DEmvbYfp1yZtjSaV/p7dKgC?=
 =?us-ascii?Q?z6HNQmU+V4gXxtASCjcaE8wJ4lx+VionFIXaHlrFr9PohEiH2qKwdoFbqvNA?=
 =?us-ascii?Q?ko2tERuOrCoDqLDMWrOyh5jPtNW422gPTPe6AzrCsUmA2TZeDs+l5wES1I5O?=
 =?us-ascii?Q?vPZUPSrHec6cw6MbcwlrADfYUSuX8UAMfnwFVPZdFR3LNnGvv/UrIgBxul84?=
 =?us-ascii?Q?BlIB4sxa1Ace1RF7nFl1RnIO8fbqJXSgfexQ6MElD2jLqmyCybTkk1XkrLfQ?=
 =?us-ascii?Q?OZECoM7C08txu0j65wng+biq+itr72iCJN2zYdp2b126gQggyt1nM6dSvZrg?=
 =?us-ascii?Q?Pf+NVzBrYSSSqu9tuhk3UzcNhT+NMYKiMh0vzK9KulQcQxSmlIFRF+trEvas?=
 =?us-ascii?Q?2Wb68Sm/7Z6PnA9H96SBtBnk/IsGHxNZ7877ryrMam7WPd7QTwF24JEllZnL?=
 =?us-ascii?Q?K+2rG5Ny3TtJQPbbVVn+u3Siw3strOrazyjWHZUDUK1i7du0pQQ32h373kOH?=
 =?us-ascii?Q?RssWD7Yrz/oEH3grwazkUymtjZ5gG+XuqGi5inqn6jBWNy3ESDMYXIprn/YM?=
 =?us-ascii?Q?ggAokxzlrg17cHUC1H8zSJj7YnSwfKJOdnSqNoRlRovDia4XnGiwg+rA8JkQ?=
 =?us-ascii?Q?KXPBr3/F2jKQY1IL7xs+5RpKC5Vff/zZ6fFgJSd+XlPC7/XIv8EeBBUJKh1f?=
 =?us-ascii?Q?njuJv2FTLQkY2HcCp0/mIqnYF8Cv2jHIuXbu/0awYVL+MY4/smqB+A6hH42d?=
 =?us-ascii?Q?QqssBuADE30YAiyW5czgX61qxvbjxJqnhLfwoun/ttTfDVMGzYo4NMFntY3X?=
 =?us-ascii?Q?lzQ15KLY73lp19gfurjv6te4PfmfiFidCbPm27oqtYjuCytKHQRzIE+C+nai?=
 =?us-ascii?Q?Fby72u94gYpg/DdEc0n+V+CuRndJvcEf2WvHf0FZxwk2O6eQ5/G6NLxdYHx9?=
 =?us-ascii?Q?/GYAhcHZVtArt3j61BXVIKViJnISzyvjD1PCd1qnN2xBsQxAE07R1qqEqBzp?=
 =?us-ascii?Q?rmrYSkC0j4yPz5me+GaPMKg8GtWa7UAk5t3GfKk/lgT4C/BxGk7IIxpkKt5X?=
 =?us-ascii?Q?QiHVdFpbp0y+1n+W1ihPpahu2vJ6Y0OH+FkQnbUiXfLd13YjvUP71q914vBZ?=
 =?us-ascii?Q?NbFC1IR9ey1FhJHGluv6mzWkawrpmuPXwBrHQYnLrWmjqdCqorE9vfgRyoe7?=
 =?us-ascii?Q?0YlxcFUVnOcrArmX5AD7/lxVAfJtvhp0gRrv4eEvQIru1nRz5A7Cmu5mISmO?=
 =?us-ascii?Q?mtGKwtVyQj1CwlTajCBNBaz8104K1/0J1mSEMulCbBewDG/WWl0+fMErxnKB?=
 =?us-ascii?Q?AvWixx8vVm4eIIE9q8fe4Y/lt/B+OzrrfiTMmF6nnmRTz4fct7Rac7N2+jZ9?=
 =?us-ascii?Q?Q3MPPWx+gzIUjg4e4fgbYpA6ZcHVojOQsF9QqXiIysyAVpAeeB3M7wG/CrKn?=
 =?us-ascii?Q?dOziY7qtVQN9BXeDTtNM71tdfFXlrK/6LmXhZE7I3/v/+yd50VzfOct+GJfQ?=
 =?us-ascii?Q?xvFSiQErjRRz7GSsfmgvFxOmKquUjjTCl5F9pIkexAItLD5t34GWeJ5uiLEj?=
 =?us-ascii?Q?LQiyKFe80pzD2Bb7FjB0ayQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4fb8da7-142f-4e98-4e69-08d9adac6f05
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:37:16.2446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae3Ivnuh49JuIXYuIrWOTqVfUM8yfqkO7j9Ytxf0yy6rCYw3sRERYXM0ECvJHUJJvfwhgQnqhPAuEqzle/m5Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: 6NX91x-LKqF-8XYQG4Bhcm_FLXWmj5z3
X-Proofpoint-ORIG-GUID: 6NX91x-LKqF-8XYQG4Bhcm_FLXWmj5z3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> We currently set the log ticket client ID when we reserve a
> transaction. This client ID is only ever written to the log by
> a CIL checkpoint or unmount records, and so anything using a high
> level transaction allocated through xfs_trans_alloc() does not need
> a log ticket client ID to be set.
>
> For the CIL checkpoint, the client ID written to the journal is
> always XFS_TRANSACTION, and for the unmount record it is always
> XFS_LOG, and nothing else writes to the log. All of these operations
> tell xlog_write() exactly what they need to write to the log (the
> optype) and build their own opheaders for start, commit and unmount
> records. Hence we no longer need to set the client id in either the
> log ticket or the xfs_trans.
>

Looks good. Also xlog_op_header->oh_flags being set to 0 inside
xlog_write_setup_ophdr() is correct since optype inside xlog_write() would
have already had the corresponding operation bit (e.g. XLOG_START_TRANS)
removed.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |  1 -
>  fs/xfs/xfs_log.c               | 47 ++++++----------------------------
>  fs/xfs/xfs_log.h               | 14 ++++------
>  fs/xfs/xfs_log_cil.c           |  2 +-
>  fs/xfs/xfs_log_priv.h          | 10 ++------
>  fs/xfs/xfs_trans.c             |  6 ++---
>  6 files changed, 18 insertions(+), 62 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b322db523d65..2b89141ae81a 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -69,7 +69,6 @@ static inline uint xlog_get_cycle(char *ptr)
>  
>  /* Log Clients */
>  #define XFS_TRANSACTION		0x69
> -#define XFS_VOLUME		0x2
>  #define XFS_LOG			0xaa
>  
>  #define XLOG_UNMOUNT_TYPE	0x556e	/* Un for Unmount */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f789acd2f755..f09663d3664b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -434,10 +434,9 @@ xfs_log_regrant(
>  int
>  xfs_log_reserve(
>  	struct xfs_mount	*mp,
> -	int		 	unit_bytes,
> -	int		 	cnt,
> +	int			unit_bytes,
> +	int			cnt,
>  	struct xlog_ticket	**ticp,
> -	uint8_t		 	client,
>  	bool			permanent)
>  {
>  	struct xlog		*log = mp->m_log;
> @@ -445,15 +444,13 @@ xfs_log_reserve(
>  	int			need_bytes;
>  	int			error = 0;
>  
> -	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
> -
>  	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -961,7 +958,7 @@ xlog_unmount_write(
>  	struct xlog_ticket	*tic = NULL;
>  	int			error;
>  
> -	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> +	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
>  	if (error)
>  		goto out_err;
>  
> @@ -2296,35 +2293,13 @@ xlog_write_calc_vec_length(
>  
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
> -	struct xlog		*log,
>  	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>  {
>  	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -	ophdr->oh_clientid = ticket->t_clientid;
> +	ophdr->oh_clientid = XFS_TRANSACTION;
>  	ophdr->oh_res2 = 0;
> -
> -	/* are we copying a commit or unmount record? */
> -	ophdr->oh_flags = flags;
> -
> -	/*
> -	 * We've seen logs corrupted with bad transaction client ids.  This
> -	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
> -	 * and shut down the filesystem.
> -	 */
> -	switch (ophdr->oh_clientid)  {
> -	case XFS_TRANSACTION:
> -	case XFS_VOLUME:
> -	case XFS_LOG:
> -		break;
> -	default:
> -		xfs_warn(log->l_mp,
> -			"Bad XFS transaction clientid 0x%x in ticket "PTR_FMT,
> -			ophdr->oh_clientid, ticket);
> -		return NULL;
> -	}
> -
> +	ophdr->oh_flags = 0;
>  	return ophdr;
>  }
>  
> @@ -2549,11 +2524,7 @@ xlog_write(
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
>  			} else {
> -				ophdr = xlog_write_setup_ophdr(log, ptr,
> -							ticket, optype);
> -				if (!ophdr)
> -					return -EIO;
> -
> +                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
>  				added_ophdr = true;
> @@ -3612,7 +3583,6 @@ xlog_ticket_alloc(
>  	struct xlog		*log,
>  	int			unit_bytes,
>  	int			cnt,
> -	char			client,
>  	bool			permanent)
>  {
>  	struct xlog_ticket	*tic;
> @@ -3630,7 +3600,6 @@ xlog_ticket_alloc(
>  	tic->t_cnt		= cnt;
>  	tic->t_ocnt		= cnt;
>  	tic->t_tid		= prandom_u32();
> -	tic->t_clientid		= client;
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index dc1b77b92fc1..09b8fe9994f2 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -117,15 +117,11 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
>  void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
> -void	  xfs_log_space_wake(struct xfs_mount *mp);
> -int	  xfs_log_reserve(struct xfs_mount *mp,
> -			  int		   length,
> -			  int		   count,
> -			  struct xlog_ticket **ticket,
> -			  uint8_t		   clientid,
> -			  bool		   permanent);
> -int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> -void      xfs_log_unmount(struct xfs_mount *mp);
> +void	xfs_log_space_wake(struct xfs_mount *mp);
> +int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
> +			struct xlog_ticket **ticket, bool permanent);
> +int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> +void	xfs_log_unmount(struct xfs_mount *mp);
>  bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 2c4fb55d4897..29cf2d5d0b96 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
>  {
>  	struct xlog_ticket *tic;
>  
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
> +	tic = xlog_ticket_alloc(log, 0, 1, 0);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 23103d68423c..65fb97d596dd 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -164,7 +164,6 @@ typedef struct xlog_ticket {
>  	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
> -	char		   t_clientid;	 /* who does this belong to;	 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
>  
>          /* reservation array fields */
> @@ -498,13 +497,8 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
>  			    char *dp, int size);
>  
>  extern struct kmem_cache *xfs_log_ticket_cache;
> -struct xlog_ticket *
> -xlog_ticket_alloc(
> -	struct xlog	*log,
> -	int		unit_bytes,
> -	int		count,
> -	char		client,
> -	bool		permanent);
> +struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
> +		int count, bool permanent);
>  
>  static inline void
>  xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 234a9d9c2f43..196ee8aeee35 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -194,11 +194,9 @@ xfs_trans_reserve(
>  			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
>  			error = xfs_log_regrant(mp, tp->t_ticket);
>  		} else {
> -			error = xfs_log_reserve(mp,
> -						resp->tr_logres,
> +			error = xfs_log_reserve(mp, resp->tr_logres,
>  						resp->tr_logcount,
> -						&tp->t_ticket, XFS_TRANSACTION,
> -						permanent);
> +						&tp->t_ticket, permanent);
>  		}
>  
>  		if (error)


-- 
chandan
