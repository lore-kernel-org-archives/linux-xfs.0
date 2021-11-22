Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA01C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 10:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbhKVKvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 05:51:54 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55418 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239381AbhKVKvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 05:51:53 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AM9aTeU019952;
        Mon, 22 Nov 2021 10:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Yu7uR/ggKbAoMrf2upDw6ZUL4qikhrsfmFAryBvvX1c=;
 b=xBzb73EnZpxHA35tuzsgiyXi0cuYeb0eUy9GIyerceWcs34zXPaLea8uVRD48gNrD9Rm
 T8RCi266MWatxh/3tKr/3DSb38XUfdltWOBSIM4VCMyWXXXn+RlHb0spKwkc5olj3r67
 xlrmBuPQkC6CWmZnWz69TyHq1G5o9y/49lKxeWg14am66B0qfPOuM6KxCIB5j27sitFM
 3AJGAAmlstNL9gDvgFT045nQPE4pmCc8y6tHow3U75hO4ZOVLGYRCtrY4O94XoV/HCJg
 +6ESxiuqSUVZ6xKzUSoEiBJ8Jy5+Pk9oB7R5YRXV73vXOdep8Ppt7T1B5wG66gu3qFzI gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55fs99p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 10:48:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMAiwp3065462;
        Mon, 22 Nov 2021 10:48:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3020.oracle.com with ESMTP id 3ceru3ap5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 10:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyPOxe/t8XwzD9eYirjkcS+wRiBUGd0yphSatOey2DCBc625zjS31fRxTBP5RvT0Ejs2YhHS2BraO2FJN7v/v1nQLaU5A8VSpeR0+3Aba9u8PPf6c3bIGYIYg8s+OLgjiTOnCez7juHSk8S2rpq9HkFFZUWLSXQHX8XbjivjPAuMNU1CU3egxswWOzJnMZaA6MxJVuLDu1JbIiapeXQfJ/UGy4cQIdQzp44mNhxtkcylF2P6pl/0bOHKcSWas/AMoOeIZmdVhPOvNqMnBCqtinmIPPh/f/wYdmAQ6pKbSHouZ98dBgnOguzFM6vBjhyopZvi/Son0UPTbfB+DKyZcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yu7uR/ggKbAoMrf2upDw6ZUL4qikhrsfmFAryBvvX1c=;
 b=iwZ64Zd4cXwEWl4rniAshb3xyVh2HkfvLi0Kl+1V5O+3ml5/L+6HjAwJqmt0onEQ88hz0uI+ruy31EuAlyTM8ve6vxrqz/Tp95vt4OqYDJzXsCfiMk1EeYG4mAYmuoTKSA1/oZkojzeXKI2DMIoHSzt/vKIstUUHfux/WSFqndNaqbUDgxX4lvYIZHMAXwEX65hCZFg1rMQlGR5olp7/kllblSMWIuzW9tLkwO1wmMs89uWGrywpiNJ/KV+zArnXh16fwwVCZer6Tp9n1XdgAlSKYxFKpWV5loqtGq6ONzXqJcrU4IGixkJ8aQ8jRSuUr5gl/sVoLUTJPbzIHYrmVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu7uR/ggKbAoMrf2upDw6ZUL4qikhrsfmFAryBvvX1c=;
 b=KpwveJ/+zP+SvyFCqL1+hOxEbJE64wASwRVAqdtuK1t/YIpy4FwwlxyartOmgGgNDlcvj2Q4BauTc7S52XvpYA9lqjsCcyTy7+tY8A1rOrPexulv3binMUjFbeHlAHyEu8Zlc7M+JzsVT3knyb5cbwNBBvn8T4EKb8AG7vgLWZo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4460.namprd10.prod.outlook.com (2603:10b6:806:118::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 10:48:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 10:48:43 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-2-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/16] xfs: factor out the CIL transaction header building
Message-ID: <87czmtvp10.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-2-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 16:18:32 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0022.jpnprd01.prod.outlook.com (2603:1096:405::34)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by TYCPR01CA0022.jpnprd01.prod.outlook.com (2603:1096:405::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 10:48:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e16d8c34-6764-46d2-27a4-08d9ada5a6a2
X-MS-TrafficTypeDiagnostic: SA2PR10MB4460:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4460B33BF4988B1F12E3B518F69F9@SA2PR10MB4460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcyLmBSYS1Ot7B7TWbm/Dik7+0iBKPR2SS/d0pPXqrlxIfOhkSRaPmCEDKqYUolDzL2m+LQ8npgN4emRCVVCV2zvX1ox0032xS5UWnjE1I+sgpzMSWJ6o/agOL+HSh2iQ9tk28umLbKbHGwoBGhF1J8y2OIm2skezHTDlUo4d6Zz/Z9Y1dvkJwloJejTgZhLdPJub6uaK/QEwCb4FnG08eF5JP3kGk16NhsHsTsahRNkRa8YUR3HYdXh0VlGCXsugiO1j27m0CZ9JQ+Wlww2jFvqsnFSTh6MCqeo/4/mBPGJPuUSgJ0xAo9MmyTJTSEpcgXnr08CGvnrfh8vxSIjASu4ppaIW9s1d4BEZI+dx8cCc8slLEIhFxtfijntkTlOUh8FBBxRXiZjLa1io5C+Pl2c0shbLCNZRn4tGfd4KfdZ3MahL9mp+KqYKSsTay//Mq+cpFSHjbyAQKid4llUkRj3eDygZUfZO9oZ1v0LtuxZznY3NtJQ5FWBRzy9Rrrel1OggAmNXmDYvUUbhBFSvwTGO/S4rsyAnf2RHsH8VjGgF7b2TCh2/xuqBOp7MLa+piLib9MmLzPWreOX/OOPLJpprNb1DWjt1a7hIDaD0GGi65gjAjcteL6Po2AuaE/AK2cPSGBfV/9XDeDd4ZfdOAKW0DaPTrMgR0ejSwWhEKbofXNJXUR7rt41yTd11OWB4SuEWElfynIGimq9eZDk8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(53546011)(2906002)(83380400001)(316002)(6486002)(33716001)(66476007)(66556008)(508600001)(66946007)(6666004)(8936002)(6496006)(4326008)(956004)(5660300002)(6916009)(52116002)(9686003)(186003)(38350700002)(38100700002)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9aSYeq2kQSr15cPfSTL1D0bRR0yQsoWUXa7zKy8uF6HAPWpQM0Jgy7iUblM?=
 =?us-ascii?Q?QEMiz0UDfTodQCOM7+vP7tuQwArTqO7j39Wwn/PYN4E0tJSz4NwcNukEoBne?=
 =?us-ascii?Q?YdATBvJfITAhAMToK1memhnHslbVmWIXr93r7exgVEuVpnf01FpdMLPjtBvj?=
 =?us-ascii?Q?7dBAn5gWIQzAdNkiZ7gtRZD2kHHajr6qFNL/nsgkl1TP0rPRkIq0EHzTXMf5?=
 =?us-ascii?Q?Lla97DqtIASUUmjO3+km7GDE2bkZbZ4M/1TPWw1weqkg8j4ZgjCvdv2mYno/?=
 =?us-ascii?Q?YNtTksvwpZiphAc1mzLQ6Z9KShBHxos6GqkGauKKK7esdAVfFiKIPAxRl1rk?=
 =?us-ascii?Q?iQ0ydF4sVAx9+DMbPWP6yeQhkxlCW5j/mOgq56J8Iz9CTeW14Eb6le8xkaC8?=
 =?us-ascii?Q?3ZRFVqdNnPkyRHE1UFcgDbzvH2QM69ymL5zq4vrRUGH92Lrdh5AvQkq8mnFN?=
 =?us-ascii?Q?qT+36UfuvAWI8A9UzrLPtZTxF6VF1bysb2KWvEon+dQm+FywSaT7Yv1uxKsG?=
 =?us-ascii?Q?Wp3xU/x/gXqXPXpgO0sLKjHqUGEcz4a1UHIIKXBJPi4D4e7GYYmgrRt6wdb7?=
 =?us-ascii?Q?MZIk9ZS49WIZMIwzpBmLcQq4a9MMIhfk6EHtE1BJNADB2ArSK9MNStumUM2T?=
 =?us-ascii?Q?6hGG2Tc72+EGeMPPblcea27DZGtPVIYwxrOgwAJADMS8oxjWLBSoYWi5Z3et?=
 =?us-ascii?Q?s5DHDeO2kSb4aJUgxt7GkoAnHCwjooMML5jkJ7LYphs2z/QhZ6LVTWjYfFZM?=
 =?us-ascii?Q?UGAQdnyIbONFXmKnzz5Ipv8P+2PtDJgIiaBs9VwK+69puG+eTgzE9D6G2NFj?=
 =?us-ascii?Q?w7T/NAz39G39VGkRzp0QIGbNJhCH3XrEyxej3lOy6s3Eq9DIwzytrLjbRoRw?=
 =?us-ascii?Q?TgJEAN3ogrbTjBvDT+5qRh2gVl9qzzgW9E0Y5yPBOLejM1mC6HA/2Xg3lSk3?=
 =?us-ascii?Q?Y+L8XsQmP9meh8HfMhn3nr1/ZjyTkRVy53W+d+8cctUpsZpcCrczBFYfipby?=
 =?us-ascii?Q?bw9kNxebR3NapSPPNkrparBQCVQ/qG1PVWXqR5U+d4YIqc0+DknAbnXBlE3j?=
 =?us-ascii?Q?vwAswufyZLpzl0GzcaSaGy4XMcHokmm5JeU6etgv2UbYx8OpKPKCtN7OjJ1V?=
 =?us-ascii?Q?gERjQrsezu12DQpvjvQ1qj7nwch+Ff11dPZLjFtu4lhNiwJshraASGPCeVBI?=
 =?us-ascii?Q?+vfV53zzLTusPV+qRyXaAsgfUDOPn+ICuIXOLfiQOA7J/L35xmA9HuTBa+My?=
 =?us-ascii?Q?f/PitSeeIckdBYGQogRDrMkvb3x5SIiQn3gu2Hpwsq3/G9x8AzhA0uwcx7l3?=
 =?us-ascii?Q?jgpMNn5MNpW3FY4FXQKZ9rbmO86lWR+5tb8XFSCzkSA4p7dul+c6lJMHhg/T?=
 =?us-ascii?Q?or0M/n68vcGVF8xRvoH4rmSWzgc1OSNkE2c3GfldKoYx7/iD6XBAspEB+4Dm?=
 =?us-ascii?Q?cYSC69/krTqReorTAyy9xU3fHT5tK8Rh13W8Y97l6wArs8LlPKKZmpL1BCVx?=
 =?us-ascii?Q?mOhlQ202aBuM4Dkx7k36kKViJUjJi2rNSl5pO8/L5l+RG9pfmE3+i4HGl61Y?=
 =?us-ascii?Q?+eoviGMg0y7k46GJHG8XU4nTb2c6t82KAIuCEUSUMXe20QnnEMeS6vuUUZ/S?=
 =?us-ascii?Q?loFpyFvRKQ0SETUJ6gPtcoU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16d8c34-6764-46d2-27a4-08d9ada5a6a2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 10:48:42.9317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYdncWfScp5T2PJWcKLTbuF9MOP+Ml04HH0DeZk0a+1J+17XEJB/2wncUaUJ7TdozuYklWzqu3QZrepPCOnTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220056
X-Proofpoint-ORIG-GUID: DsKnyO9dzkWtJ3tddxDX6xN8eM3OpnX_
X-Proofpoint-GUID: DsKnyO9dzkWtJ3tddxDX6xN8eM3OpnX_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> It is static code deep in the middle of the CIL push logic. Factor
> it out into a helper so that it is clear and easy to modify
> separately.
>

A straight forward abstraction of existing code into a new helper.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 61 ++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 22 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 6c93c8ada6f3..28f8104fbef1 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -834,6 +834,41 @@ xlog_cil_write_commit_record(
>  	return error;
>  }
>  
> +struct xlog_cil_trans_hdr {
> +	struct xfs_trans_header	thdr;
> +	struct xfs_log_iovec	lhdr;
> +};
> +
> +/*
> + * Build a checkpoint transaction header to begin the journal transaction.  We
> + * need to account for the space used by the transaction header here as it is
> + * not accounted for in xlog_write().
> + */
> +static void
> +xlog_cil_build_trans_hdr(
> +	struct xfs_cil_ctx	*ctx,
> +	struct xlog_cil_trans_hdr *hdr,
> +	struct xfs_log_vec	*lvhdr,
> +	int			num_iovecs)
> +{
> +	struct xlog_ticket	*tic = ctx->ticket;
> +
> +	memset(hdr, 0, sizeof(*hdr));
> +
> +	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
> +	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
> +	hdr->thdr.th_tid = tic->t_tid;
> +	hdr->thdr.th_num_items = num_iovecs;
> +	hdr->lhdr.i_addr = &hdr->thdr;
> +	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
> +	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
> +	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(struct xlog_op_header);
> +
> +	lvhdr->lv_niovecs = 1;
> +	lvhdr->lv_iovecp = &hdr->lhdr;
> +	lvhdr->lv_next = ctx->lv_chain;
> +}
> +
>  /*
>   * Push the Committed Item List to the log.
>   *
> @@ -858,11 +893,9 @@ xlog_cil_push_work(
>  	struct xlog		*log = cil->xc_log;
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
> -	struct xlog_ticket	*tic;
>  	int			num_iovecs;
>  	int			error = 0;
> -	struct xfs_trans_header thdr;
> -	struct xfs_log_iovec	lhdr;
> +	struct xlog_cil_trans_hdr thdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
>  	xfs_lsn_t		preflush_tail_lsn;
>  	xfs_csn_t		push_seq;
> @@ -1011,24 +1044,8 @@ xlog_cil_push_work(
>  	 * Build a checkpoint transaction header and write it to the log to
>  	 * begin the transaction. We need to account for the space used by the
>  	 * transaction header here as it is not accounted for in xlog_write().
> -	 *
> -	 * The LSN we need to pass to the log items on transaction commit is
> -	 * the LSN reported by the first log vector write. If we use the commit
> -	 * record lsn then we can move the tail beyond the grant write head.
>  	 */
> -	tic = ctx->ticket;
> -	thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
> -	thdr.th_type = XFS_TRANS_CHECKPOINT;
> -	thdr.th_tid = tic->t_tid;
> -	thdr.th_num_items = num_iovecs;
> -	lhdr.i_addr = &thdr;
> -	lhdr.i_len = sizeof(xfs_trans_header_t);
> -	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
> -	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
> -
> -	lvhdr.lv_niovecs = 1;
> -	lvhdr.lv_iovecp = &lhdr;
> -	lvhdr.lv_next = ctx->lv_chain;
> +	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
>  
>  	/*
>  	 * Before we format and submit the first iclog, we have to ensure that
> @@ -1044,7 +1061,7 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	xfs_log_ticket_ungrant(log, tic);
> +	xfs_log_ticket_ungrant(log, ctx->ticket);
>  
>  	/*
>  	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> @@ -1108,7 +1125,7 @@ xlog_cil_push_work(
>  	return;
>  
>  out_abort_free_ticket:
> -	xfs_log_ticket_ungrant(log, tic);
> +	xfs_log_ticket_ungrant(log, ctx->ticket);
>  	ASSERT(xlog_is_shutdown(log));
>  	if (!ctx->commit_iclog) {
>  		xlog_cil_committed(ctx);


-- 
chandan
