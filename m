Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3331FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhKVLm1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:42:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31860 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234364AbhKVLm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:42:27 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMAAw91006223;
        Mon, 22 Nov 2021 11:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8NgnrU4ZA5piS2P8T4UC75yMUVWs8BfPR10NRjNvEio=;
 b=DZcpifrZlm74tng628n9QLpkzliAQlypikW7aRf/kTQBXgmO6d5UW1fjxds0sEUGSPvQ
 V26rlMudRmWQOiEs99kONE9jgzbRcyyFfjgcFNzMa86pAdIwxLPMVmilGY+FQQRp0teS
 57UApqmloW0Nw5I9k+R3bht2mkTBNFb9x6506L8Nc+Ao5CWhTnJ8A/UbyiY16hB1pWCf
 WyeThumAAZ+32nOR1WIUDZEqYHNf6d5mzt+SkHhFuuODPOl3tSD23H3hxGy6nYgekmfA
 X1sLr3wxTKV2HUHJ0XpF3j/h/JREZV9j/FN5EVzOUCIvxAFuxlhhQtw6HNEatEvS4eTx NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg3051r7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBUiGQ114695;
        Mon, 22 Nov 2021 11:39:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3030.oracle.com with ESMTP id 3ceq2cf2t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K376YG4epWMnr2u+FMGDvrDnG9h3IsSxvat5KTqC98wLYNS3iLMLw9/AMiVqfq8UtkcqOFfvklnELRBzKHKNBlz/sBFhR3yiFg0oUGW5xy5lSlAqig7WnhrtGus/Vx2Q8JYx9BanC53VWMhcTf+rb90PAeBzcOoQ5LDdkzBJHAW7/WUhPOMGFF3K6IzeONW0QjAU7IMr0iqR4x6EJJxYSL412xpKZ7rhMDFod3lvHo7Y1ux+IP5bFLt75maluX4cixFkc52htsxxJYcohzuKrBT+r5d3Da1b529t61Yr9UYd9hpMAPPBESMNtdVVBqA/Wqyd8qlxLKcpeXhEUSmI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NgnrU4ZA5piS2P8T4UC75yMUVWs8BfPR10NRjNvEio=;
 b=hYvl9zHhBdbMY+SYivGvmA9FG96zJ6FYtWsK1Kc5NX7ZYVBVPnW+V6MyRoTuHfl1PsDHBkfg/de+0dCgI1Xn8jfh1e8ekMsnjfY7THnSsffOG96bKrS0Itkju1b97kd8GR4u2slkwLhXBitRG3hw3w5WATaB9313r5CyUbmr73Z2kTL84TazXrWGSLagyCrBp3cgsFfmNMnmQxuk9BEW222WYLv/Pi6G+bQ6slTpkyu0/SqGGhFWJWLGmxqRBauv92ZTzN1hTmuFAxZF1zha4+jip1Ma/Jnfur2Mi900Sjhs4qjJypWZlVXfFYhqWsNkQHpROSxNnWus1Jj1fzDb8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NgnrU4ZA5piS2P8T4UC75yMUVWs8BfPR10NRjNvEio=;
 b=I/qozT6K2GotatgW6w9FLqGJX3VclobduAEZCeecdQPRQuS2I5RsvudQDDjf/RGKY/4KlcgdJHr6TwFJTfdu7gu8rCdMd3+ePWB7feWe6/dnP5CDREP/7k1mww9tBBGB/SWQQu0KxPwuJp2aU5fjoXG4mOX6fXQVeqN1+zGUFPo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:39:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:39:16 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-8-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/16] xfs: reserve space and initialise xlog_op_header
 in item formatting
In-reply-to: <20211118231352.2051947-8-david@fromorbit.com>
Message-ID: <87zgpwv2qt.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 22 Nov 2021 17:09:06 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by SI2P153CA0027.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.1 via Frontend Transport; Mon, 22 Nov 2021 11:39:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04dd020c-0d23-4649-aed4-08d9adacb6cc
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2496AEF2E017A2985A886CC1F69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uP/0umOUC9mxS9jYRbQYmGPFPS1+sqjneUmt5ZoYlFSlBZWGcfO7yKtYAEUOa3ROqkZ3H8W1nZ2wFkotNMCj8UPimVr+T7odhlv9KhnKdEmh+aTWH+3t+OJBDHB57IuBiDIh2ZdkIwpjCs5z8t4ARi3Epr19+SgUA7ml+QVzAp7JJKKFKNRl1n3JyDwDiyjF1ZW3p270qhNXsb2LRqCdVROMgp2jOBTQc2PmL+H0l/SfM1sYxY7fsr0RVNLWhZ28d+RduuynADu9cHZfJIin9THAXigWMYnruzrrTZOSY09WnbkW020tGoaDcbGOY01yxCi2K80KRuymJpYBymbk9yYTq/vTfRORLaO6tKQvyAP9ns0WfYd/3HZYGq8AV2PnFs0t0CSyA4Odp7hA6jnSR8yTGjROzKNznHDUtWdeZ8CQxwsllx66RK9+c55EdKKgswGkzrjjQppwVta2PN9Inzsuw9mQBMUqAnjXjmijjZI+O/qYCTBKHUgWYoLGARTWXnXkFmQINeRf8IIoh1GKMgTZOdQmPlcmcRYltFAnu8ON3D5oQH1g+pSMAdkN1gY3BwczFUpEHIZh3Cc2LlAw1QVjHInovSUT6KTlaZQmTJ2hjVp3a4YjOaAnJIAtgo4nR6zwZSL9Mh6E0oHO2vyYYSHNhXRQARShz8dw69SRCUJmK3Mp0n4ldo9o6sEZ9RY2VTr30FgdPT03fRWcyPAVlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RB1/KcBFsKRwP+FXWjdRnXqBUfUBKXAhrIQMhMfzSLysU7U/aYGt5duyvEdW?=
 =?us-ascii?Q?eSyHFfqcdspKBlgEmCH15nX29sLzwud5kuCwY+ERHt8R5e940aNs92LX/pfN?=
 =?us-ascii?Q?0pWitbPRA95/OjknZ9ko+n25HcQ/VeAK+9ap0SCeXw7s1Xa2gLajOMkug7m/?=
 =?us-ascii?Q?NVF9hYqbLSi/nO6/ITbD5w2WWd0ZHVmZZo8BQlTts4+onRnq6n629POfM4lE?=
 =?us-ascii?Q?ivCoLcOE+WkarA4tkr6jxrFhrxTDfBvOpur+PYYR5lLgxrZ4YZvJK7oPzW/e?=
 =?us-ascii?Q?itPBXfF3yXDCYlpHLWwUVuJEdQh8RuC6gg9qV6dXGj9g59L0sRNbOyQPidaP?=
 =?us-ascii?Q?qjXc/t/rskNDg1AspCuSYes/uyq1mAOmXz8q9n0HiXIVdFh97jADD4B0JlzS?=
 =?us-ascii?Q?6gbK2VT85xBqE2NjNknE8I/IPla3TNpBXeGG9IDXp5ZCXxcek7mYoo5HAx0t?=
 =?us-ascii?Q?oegL4ikWM2OJWCvc8PBskIoyPdZnEfc4QVYq0lRgP1qDViHx1SpSpPMbJBdk?=
 =?us-ascii?Q?YH5pdMF3UxfqPYLTpizEKaFvbBNOAPQKHq2gxhwmy79xyCYPEw9iFh3rfAZl?=
 =?us-ascii?Q?4/NzV3au8p1Qz3PAjW3G1ZQQqqCf4PUB+va0DMqVAC1TI5/kapQ8fjX1HzjU?=
 =?us-ascii?Q?Mb0GnxCRUyDNMsNk/yGaZPmazVlm4VVWYahSBbFJQbV85o+zn12zxqlpHtkd?=
 =?us-ascii?Q?2ElXmnKUF8HwJr9vKkoR9dEP6YtChNPTzcddHdJACQtYWCLV1fbnQFYycZou?=
 =?us-ascii?Q?CS3TBbN+ylJ61nlfK8LYg+6s331JNZFjeY36bFkcce04CmilT12hU+ipqO8q?=
 =?us-ascii?Q?769WJu3DUsSvtmPvAWScsg7t964Z8fiZqlGhs9bG7Ny2ijJbfQ+dnMgELs37?=
 =?us-ascii?Q?UX+fDhxV6CwMNfbfVuivAYcVH7Lq/Q6x7rSmYGAeGnRxmNIfckTuzBgI3SYu?=
 =?us-ascii?Q?/WM7IbjGlAeT0m00389tCFUaYSKNM0OWv6XSNGcDRL1E7VaJXGMiV9r2eZOi?=
 =?us-ascii?Q?0joRjw1U0m4q9dDpGE80P2C97kwtLiGPC2a39o/8bW/pTzxcG4yDPFa4Bd04?=
 =?us-ascii?Q?Ze1vSmZiDZ0rNsiP1wELLzQWyVUXqdwPKRDc7WuvmzpRd+LC0MvhxYavtLTn?=
 =?us-ascii?Q?CambTQGf/pePvg/P99g2SL1BNQEo4/t5INIKEt8po7IvfYQEvXQwHPXRoaUZ?=
 =?us-ascii?Q?eUUjSFEBbZ6lPyPLG4EJbPf/oDh3OsBBjAzKzxQLG83EQU9mgw1Tl4SuXQ8k?=
 =?us-ascii?Q?mqN75xuMnLshoUW3dgA7sBu6edyprjFFyZVrImqxLHjMQR0SehrxQIdBIKVV?=
 =?us-ascii?Q?p5i1sGDbSdwL9E8AYCVub0BQEQFGzsfJ6iCrajHra8t0/3fsRnqFONRqJ1uF?=
 =?us-ascii?Q?j3cB9Bd4Pb9UAoUUneYcWmvXDrZ1+2n+BPJ5yq5SRzBFdWhOBEIKtIDtUcvC?=
 =?us-ascii?Q?rEIAn9BHimSlof14aA9iSYbybiccIGFRerb/ggvWz5PqQ48Y7bocBX9tgM7T?=
 =?us-ascii?Q?8BBTJylE7eVa/hKxPw+umLl8jENkx5j2WOPY73DC7vX459AqAzxPVbDeVnPo?=
 =?us-ascii?Q?zk05Dzb18+HCc/3PsjSx6UUPoHLO/Eg6eEIhzlf48cj982y1gAxJDs28w2rB?=
 =?us-ascii?Q?bPNG1FdncQXSYAWCR8Of3s0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04dd020c-0d23-4649-aed4-08d9adacb6cc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:39:16.8337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7hW+PJH+shJkc26KlyPLzON7LjPD0Z7krLxGJVFhoFhDb3Q6ZHIsv1u927y+yq49VzOgY0qewI54YSSxpI7P/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: LQ6KOe7QLPbrFn1vU_PXfGfWYYFSjU1t
X-Proofpoint-ORIG-GUID: LQ6KOe7QLPbrFn1vU_PXfGfWYYFSjU1t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Current xlog_write() adds op headers to the log manually for every
> log item region that is in the vector passed to it. While
> xlog_write() needs to stamp the transaction ID into the ophdr, we
> already know it's length, flags, clientid, etc at CIL commit time.
>
> This means the only time that xlog write really needs to format and
> reserve space for a new ophdr is when a region is split across two
> iclogs. Adding the opheader and accounting for it as part of the
> normal formatted item region means we simplify the accounting
> of space used by a transaction and we don't have to special case
> reserving of space in for the ophdrs in xlog_write(). It also means
> we can largely initialise the ophdr in transaction commit instead
> of xlog_write, making the xlog_write formatting inner loop much
> tighter.
>
> xlog_prepare_iovec() is now too large to stay as an inline function,
> so we move it out of line and into xfs_log.c.
>
> Object sizes:
> text	   data	    bss	    dec	    hex	filename
> 1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
> 1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after
>
> So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
> out of line, even though it grew in size itself.
>

I verified the following,
1. For embedded op headers, xlog_cil_alloc_shadow_bufs() correctly computes
   the space required to hold a region.
2. The space actually used by each iovec (plus space required
   by an op header) is correctly updated by xlog_finish_iovec().
3. op header's oh_len is correctly updated in both partial and non-partial
   writes of a region to an iclog.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
   
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 115 +++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log.h     |  42 +++-------------
>  fs/xfs/xfs_log_cil.c |  25 +++++-----
>  3 files changed, 99 insertions(+), 83 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f09663d3664b..0923bee8d4e2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -90,6 +90,62 @@ xlog_iclogs_empty(
>  static int
>  xfs_log_cover(struct xfs_mount *);
>  
> +/*
> + * We need to make sure the buffer pointer returned is naturally aligned for the
> + * biggest basic data type we put into it. We have already accounted for this
> + * padding when sizing the buffer.
> + *
> + * However, this padding does not get written into the log, and hence we have to
> + * track the space used by the log vectors separately to prevent log space hangs
> + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> + * CIL context ticket.
> + *
> + * We also add space for the xlog_op_header that describes this region in the
> + * log. This prepends the data region we return to the caller to copy their data
> + * into, so do all the static initialisation of the ophdr now. Because the ophdr
> + * is not 8 byte aligned, we have to be careful to ensure that we align the
> + * start of the buffer such that the region we return to the call is 8 byte
> + * aligned and packed against the tail of the ophdr.
> + */
> +void *
> +xlog_prepare_iovec(
> +	struct xfs_log_vec	*lv,
> +	struct xfs_log_iovec	**vecp,
> +	uint			type)
> +{
> +	struct xfs_log_iovec	*vec = *vecp;
> +	struct xlog_op_header	*oph;
> +	uint32_t		len;
> +	void			*buf;
> +
> +	if (vec) {
> +		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> +		vec++;
> +	} else {
> +		vec = &lv->lv_iovecp[0];
> +	}
> +
> +	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> +		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> +					sizeof(struct xlog_op_header);
> +	}
> +
> +	vec->i_type = type;
> +	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> +
> +	oph = vec->i_addr;
> +	oph->oh_clientid = XFS_TRANSACTION;
> +	oph->oh_res2 = 0;
> +	oph->oh_flags = 0;
> +
> +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
> +
> +	*vecp = vec;
> +	return buf;
> +}
> +
>  static void
>  xlog_grant_sub_space(
>  	struct xlog		*log,
> @@ -2246,9 +2302,9 @@ xlog_print_trans(
>  }
>  
>  /*
> - * Calculate the potential space needed by the log vector. If this is a start
> - * transaction, the caller has already accounted for both opheaders in the start
> - * transaction, so we don't need to account for them here.
> + * Calculate the potential space needed by the log vector. All regions contain
> + * their own opheaders and they are accounted for in region space so we don't
> + * need to add them to the vector length here.
>   */
>  static int
>  xlog_write_calc_vec_length(
> @@ -2275,18 +2331,7 @@ xlog_write_calc_vec_length(
>  			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
>  		}
>  	}
> -
> -	/* Don't account for regions with embedded ophdrs */
> -	if (optype && headers > 0) {
> -		headers--;
> -		if (optype & XLOG_START_TRANS) {
> -			ASSERT(headers >= 1);
> -			headers--;
> -		}
> -	}
> -
>  	ticket->t_res_num_ophdrs += headers;
> -	len += headers * sizeof(struct xlog_op_header);
>  
>  	return len;
>  }
> @@ -2296,7 +2341,6 @@ xlog_write_setup_ophdr(
>  	struct xlog_op_header	*ophdr,
>  	struct xlog_ticket	*ticket)
>  {
> -	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
>  	ophdr->oh_clientid = XFS_TRANSACTION;
>  	ophdr->oh_res2 = 0;
>  	ophdr->oh_flags = 0;
> @@ -2514,21 +2558,25 @@ xlog_write(
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
>  			/*
> -			 * The XLOG_START_TRANS has embedded ophdrs for the
> -			 * start record and transaction header. They will always
> -			 * be the first two regions in the lv chain. Commit and
> -			 * unmount records also have embedded ophdrs.
> +			 * Regions always have their ophdr at the start of the
> +			 * region, except for:
> +			 * - a transaction start which has a start record ophdr
> +			 *   before the first region ophdr; and
> +			 * - the previous region didn't fully fit into an iclog
> +			 *   so needs a continuation ophdr to prepend the region
> +			 *   in this new iclog.
>  			 */
> -			if (optype) {
> -				ophdr = reg->i_addr;
> -				if (index)
> -					optype &= ~XLOG_START_TRANS;
> -			} else {
> +			ophdr = reg->i_addr;
> +			if (optype && index) {
> +				optype &= ~XLOG_START_TRANS;
> +			} else if (partial_copy) {
>                                  ophdr = xlog_write_setup_ophdr(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
>  				added_ophdr = true;
>  			}
> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +
>  			len += xlog_write_setup_copy(ticket, ophdr,
>  						     iclog->ic_size-log_offset,
>  						     reg->i_len,
> @@ -2546,20 +2594,11 @@ xlog_write(
>  				ophdr->oh_len = cpu_to_be32(copy_len -
>  						sizeof(struct xlog_op_header));
>  			}
> -			/*
> -			 * Copy region.
> -			 *
> -			 * Commit records just log an opheader, so
> -			 * we can have empty payloads with no data region to
> -			 * copy.  Hence we only copy the payload if the vector
> -			 * says it has data to copy.
> -			 */
> -			ASSERT(copy_len >= 0);
> -			if (copy_len > 0) {
> -				memcpy(ptr, reg->i_addr + copy_off, copy_len);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						   copy_len);
> -			}
> +
> +			ASSERT(copy_len > 0);
> +			memcpy(ptr, reg->i_addr + copy_off, copy_len);
> +			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> +
>  			if (added_ophdr)
>  				copy_len += sizeof(struct xlog_op_header);
>  			record_cnt++;
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index d1fc43476166..816f44d7dc81 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -21,44 +21,18 @@ struct xfs_log_vec {
>  
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
> -/*
> - * We need to make sure the buffer pointer returned is naturally aligned for the
> - * biggest basic data type we put into it. We have already accounted for this
> - * padding when sizing the buffer.
> - *
> - * However, this padding does not get written into the log, and hence we have to
> - * track the space used by the log vectors separately to prevent log space hangs
> - * due to inaccurate accounting (i.e. a leak) of the used log space through the
> - * CIL context ticket.
> - */
> -static inline void *
> -xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> -		uint type)
> -{
> -	struct xfs_log_iovec *vec = *vecp;
> -
> -	if (vec) {
> -		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> -		vec++;
> -	} else {
> -		vec = &lv->lv_iovecp[0];
> -	}
> -
> -	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
> -		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
> -
> -	vec->i_type = type;
> -	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> -
> -	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
> -
> -	*vecp = vec;
> -	return vec->i_addr;
> -}
> +void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> +		uint type);
>  
>  static inline void
>  xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
>  {
> +	struct xlog_op_header	*oph = vec->i_addr;
> +
> +	/* opheader tracks payload length, logvec tracks region length */
> +	oph->oh_len = cpu_to_be32(len);
> +
> +	len += sizeof(struct xlog_op_header);
>  	lv->lv_buf_len += len;
>  	lv->lv_bytes += len;
>  	vec->i_len = len;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 29cf2d5d0b96..90a0e9b9d3e0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -181,13 +181,20 @@ xlog_cil_alloc_shadow_bufs(
>  		}
>  
>  		/*
> -		 * We 64-bit align the length of each iovec so that the start
> -		 * of the next one is naturally aligned.  We'll need to
> -		 * account for that slack space here. Then round nbytes up
> -		 * to 64-bit alignment so that the initial buffer alignment is
> -		 * easy to calculate and verify.
> +		 * We 64-bit align the length of each iovec so that the start of
> +		 * the next one is naturally aligned.  We'll need to account for
> +		 * that slack space here.
> +		 *
> +		 * We also add the xlog_op_header to each region when
> +		 * formatting, but that's not accounted to the size of the item
> +		 * at this point. Hence we'll need an addition number of bytes
> +		 * for each vector to hold an opheader.
> +		 *
> +		 * Then round nbytes up to 64-bit alignment so that the initial
> +		 * buffer alignment is easy to calculate and verify.
>  		 */
> -		nbytes += niovecs * sizeof(uint64_t);
> +		nbytes += niovecs *
> +			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
>  		nbytes = round_up(nbytes, sizeof(uint64_t));
>  
>  		/*
> @@ -441,11 +448,6 @@ xlog_cil_insert_items(
>  
>  	spin_lock(&cil->xc_cil_lock);
>  
> -	/* account for space used by new iovec headers  */
> -	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
> -	len += iovhdr_res;
> -	ctx->nvecs += diff_iovecs;
> -
>  	/* attach the transaction to the CIL if it has any busy extents */
>  	if (!list_empty(&tp->t_busy))
>  		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> @@ -477,6 +479,7 @@ xlog_cil_insert_items(
>  	}
>  	tp->t_ticket->t_curr_res -= len;
>  	ctx->space_used += len;
> +	ctx->nvecs += diff_iovecs;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move


-- 
chandan
