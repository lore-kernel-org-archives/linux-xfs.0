Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6A0C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhKVLmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:42:46 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53124 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhKVLmo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:42:44 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMB6A9S019932;
        Mon, 22 Nov 2021 11:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ysTphv5Mr40XeqWko3rzad8p4P8IFeA6KbOSsNnzBJ0=;
 b=qj1qv3Hxf2rO5zfYADTdAIGM3B+/9DnXrm166GiMHfxe5zjh3EfjHvkIokjMDrpQK4iA
 a078aXfpA86c9003C1WrtUtzbQ20mvTp77nEiPUwBaQOXmKXRgWM97sVk0jXC+KmROHr
 QZYFemdr9N3B7NpYcBR5hW+Ho09K/rJc7D0Isfhow/oZO/Ujn1HPVPG/8L4iovZeBdFK
 qP2uh/zFMB92dNng4iwV+/sUZXMkjSw7h2XpPKW9/H8x9Z0jYkO1EWupkZ0mdOm1KzKi
 HgaD2SJjHNvIr1plLjruziB2sDMspfP+b0+1c/M9ll5jCzcJK/wweH4VQPnXXcHJ4m4r Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55fsga3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBUj5Q114763;
        Mon, 22 Nov 2021 11:39:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 3ceq2cf2yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lA9KrK82wiLt8sHvyEaz/i2pA5eWx7HfqYjNiHTTBJVgII36BK9rl1QQstJlrFaikV+vTN8RRktCnVI/YAYyk9+CkY1JRWVKMgi2WnTL6x5xcUJjFk0o+SEmqMcgZybdDgxhdbtucMJ0YaJPdxwwhuDLKTVM2xsbTYXdmFWeoA/qi40dlW9CcjeytfSrxZbzD9seTqVdgf3vfymfBxupu+iQGyUbPW7aRL73P2IWBC8xofKRq+hpew1z/rVSnYUlBibiVGY930mFAjTyNBDsUVJ5Lm0M+byh1KOCPTeZn9KFtIpf18A2T2p0q/cJOjRVPEtsvOcifBhJdGVH+qN1gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysTphv5Mr40XeqWko3rzad8p4P8IFeA6KbOSsNnzBJ0=;
 b=Hab4zqzoINs5INCYLAO2XVNOMvVAq1S3fNac4oB7t+6g2POa7kAYAFBaMNuYfRBwCiAq6MTIVBs+olZ0ilwRfu5kdgHzlU6d/QVgGk9ZLn2hFm8eUYTxOj4amd4k18HeZqjyf04iHcBcFczeGn2IuJ6hUEmCGPzs9WNQXTxV3hTn3j7u/u9qdTsIsqs+GzVo28tnyic34sEh92su2kvyTdL3XWOwBim/FBa/Z2EatFtN+1QIUTrLJUXKmBTsYSrMOIbPpqz0dQ0iass22+A5MxDqy1N/ToH1w0SE2XvJmzNjmRpj1KtKNvzsKd3Wj0FjPGXHg2DBL9qypXEcJooliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysTphv5Mr40XeqWko3rzad8p4P8IFeA6KbOSsNnzBJ0=;
 b=ivKoVh64gMwOIzctYJJ9fPptNZvts0XDG7rXe/0rKIHrd7QCD8MBilZIRUWIWa0PdXZLpMuexBgCzFPXOZ4ji36zIJeTJ91vNyuqzs1iC1aw8NZvddnpKQs/OiwAVcd/mgXEynhj7a3Xi9pK1N0MqBliFGJSnBVFi0NQIl4WcCo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:39:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:39:33 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-9-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/16] xfs: log ticket region debug is largely useless
Message-ID: <871r39v9sv.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-9-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 17:09:26 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0021.apcprd04.prod.outlook.com
 (2603:1096:404:f6::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by TY2PR04CA0021.apcprd04.prod.outlook.com (2603:1096:404:f6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 11:39:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46ef532e-bbd2-4487-076e-08d9adacc0fb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB24960721247A0F16021546FEF69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76zJ8/QXz2dKcIX4e/KwrlvCh1jFaKtq7ka24e1NBpew9ZsWuYvXyhsDAplHE/9GKGQ4jgbVyRj8Unr48t55O2j7mnHgqbW/qWzdyGV6i60/+QyAiFVg0nndaBGZOa8hQRkexZnPV46IE8oeY2svRdlhIT2807gbM4YEtXQgEab6hdX9rDT826/v9agiTzfdhK/bBX2bjYGbjqVpvF5LwgJbbhv4CBlzbjNa7QNYiA4GmEwTpH/NJn+RquCKVfd4AYiuNzz5B++iP+YuDNuh0T9PL3S2sOyKE3tKA+FMGCZx1Uu3iUnW4FTZ+nZnDmIB2miIsMsByDHWNh2KnCgbzQ0VjNXbAFciSvRTW9vg0aKgBFIVntevb7KptPAga2vqiz7O0qQ8KFaTOYdBM5bBpqmNyqhUcrO0h6jzwbwf3o3Q9ZoH+s93mVZ6pHPm/IE4fW1dKKjnbEWJXdSMBS4bnx4pTIlL/+Wi0QGp9cIqW0op92KYfNkE2e122q52R6HtfDSDN05bGXohKCOaTliZ4l2eNSkHaBRi0NegbihiCC4htYEv7USaz/9Bcu+wnnE3pK5Sx/oqxeGvDFol7MBN5peuBDvvduyqvJlh5tpSqM7lan3GtBcFhy7K9yrBquI12ZzdNMY/pk+sFAeCnFZXiZ74nzG8CXGmp2zPbBkAcPhjfnhfuse/FCuld8xJ37E2GgkXkWfBrYY8sGjXQmgQsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4hxvvtulnzFi0X3+zLf73jwk8IJvqnCnqV37foMmEw/d5f2JfSGfCqD/Q+TP?=
 =?us-ascii?Q?Bep7gQo7yFdguzvEGtb4HI1gD/fkJvg2H+K1GiDLoGXcVfbBXjq5xdiDshFu?=
 =?us-ascii?Q?5Etyi78yApbxsDSJl49NWrtWKWcy/9EVK7c37x4vsoC5nNkl0tEA8qNX4ikh?=
 =?us-ascii?Q?kTS3XNPd6tujVq+y4ZOGlYLzdLKilg7KbJJb8GkQPanZhKtkl9zHG9fFhrDg?=
 =?us-ascii?Q?LA2wIYpT3isMJn7pTmeSeJ/KkjzUW3kPOVVSmIjsGRVhAQsWpgPXOvos575E?=
 =?us-ascii?Q?q6zjW/dbQnIV5Cx+6f4yMYC9z6wOEazTAYLoP3OHpu+AoBDtuVsx8k5xHbJM?=
 =?us-ascii?Q?QAXNTZqVPboRJ5CdtX9Tj52MtT6okY9pO2W/aHUp2by+6q10tMnfYYwk6W+A?=
 =?us-ascii?Q?AKlplFAX1MX0vSuMotUgrAhGPwpgsXd3ppgGlxe5kzy+1vqrhgcXLJ//5K5d?=
 =?us-ascii?Q?wMzUN1N52HT96GmG1MDfVE1b6XKWOJJZCOHsSsCTBASxgifeqqbfFpdRCfQF?=
 =?us-ascii?Q?1NeW1P7oyi344iX7jpvBtwukiLhccCtlNUU43mGDcXb9Qrntcyp2Z20lTFce?=
 =?us-ascii?Q?6XpIU0jgigaKiNpzGo/0uhclLQJPBAHjMnmmTjWOZs3dggWKtBM83bC+87G4?=
 =?us-ascii?Q?cIHyZAslGntYIHdmBi5aiI8kd6ZBPB0d/gQj4/FaokSILr/Jf0vmTSKixzQB?=
 =?us-ascii?Q?iT/wkT3TxyYGqrZV8j9hcy9g1G2OGTDub/klNPhTTWFshvvHpNo0X5K1BGqz?=
 =?us-ascii?Q?xeqSn1i2xwVAfrMOKJN5Z5Fg3rMisu3NJ7bJpvbhXwLgHDOcJDejnnfTJQg+?=
 =?us-ascii?Q?sY4czoCacZe7NXTyH8g0IBX5JDXtWJbuLvr/KHIGHkBwl+cSQ4XSZF4/PuH/?=
 =?us-ascii?Q?5QJniw1Z/eUZpMAEbKOO/sf2tDo6oxYLfvHMUXWXZaqxea1K7etGe1jYhgNv?=
 =?us-ascii?Q?T4t5jVPwAxTPFTWAcJNQ5h16qeTAkqaY8GSTczAuNn9CbJ68NBg4DVFub7KL?=
 =?us-ascii?Q?++BK1BDAp1izRL2lAsC5plQgRN6GO3+AX1fu+/hkdedjv7lpDsoIEcxzQ37o?=
 =?us-ascii?Q?mtmwoUV0MIK7hPJbBDZRMmFUXZrNCWaVbFWqdR0ZTd3BjOVx0GQT8vf/Axu3?=
 =?us-ascii?Q?4nYUFyuUVDo8uSer/kWitduJVh4t3NCLNCJV/PLyIOsp2A2GtkqJg+Ybxv4c?=
 =?us-ascii?Q?EtvCdfmVpXqxCVd7Uw/ZCYvOXBoQRHGxPO9eVyMzZEbSpz/mNBFEkW7LySWR?=
 =?us-ascii?Q?KHeIcJ1TsjzUP4nKFrkMjDnFjPjgET7RjlnzZI7al/9DKbUNcrQVdi7yIs5I?=
 =?us-ascii?Q?S+OMWa4wGcOL9Wk5KY4aJy1MIOEBSGug0NZB6S3UZY66EotLO6yHTECkv5xB?=
 =?us-ascii?Q?ZRZHcJRPuuq/5FwlXhNAIF3JWWssBjwuXKMjh1Z5SsJTKqUMH5zreml5mP0f?=
 =?us-ascii?Q?OnHDJZBzznzQn99C35HrPT5M7BKuS6SoQSeOg3GjAINkLI9FM1GUFlldJipi?=
 =?us-ascii?Q?Vpff5HXZhLwP2cUgCHd0gV/o840eHP0ttCodhPdvchgRCbBXT2cXBgfPTx1S?=
 =?us-ascii?Q?scogOdvft7/nnr316H8wS2VhLx9dQsLOQ6oeho0RJ2VrU1fUqQLgKAaOqNgM?=
 =?us-ascii?Q?DDVJkh9O+1It2IByrhp4A/k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46ef532e-bbd2-4487-076e-08d9adacc0fb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:39:33.7892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6xFSvWKsJA628Nc4TS9uar55PRvXwLAnNTYMCJDumfDRCUrccNcpnJqkS5sbztd5AqvOA2ilBKCccdBTFi0eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-ORIG-GUID: paIPtbj4aXiWjHd9H6oCLGGOuR2D_OUk
X-Proofpoint-GUID: paIPtbj4aXiWjHd9H6oCLGGOuR2D_OUk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> xlog_tic_add_region() is used to trace the regions being added to a
> log ticket to provide information in the situation where a ticket
> reservation overrun occurs. The information gathered is stored int
> the ticket, and dumped if xlog_print_tic_res() is called.
>
> For a front end struct xfs_trans overrun, the ticket only contains
> reservation tracking information - the ticket is never handed to the
> log so has no regions attached to it. The overrun debug information in this
> case comes from xlog_print_trans(), which walks the items attached
> to the transaction and dumps their attached formatted log vectors
> directly. It also dumps the ticket state, but that only contains
> reservation accounting and nothing else. Hence xlog_print_tic_res()
> never dumps region or overrun information from this path.
>
> xlog_tic_add_region() is actually called from xlog_write(), which
> means it is being used to track the regions seen in a
> CIL checkpoint log vector chain. In looking at CIL behaviour
> recently, I've seen 32MB checkpoints regularly exceed 250,000
> regions in the LV chain. The log ticket debug code can track *15*
> regions. IOWs, if there is a ticket overrun in the CIL code, the
> ticket region tracking code is going to be completely useless for
> determining what went wrong. The only thing it can tell us is how
> much of an overrun occurred, and we really don't need extra debug
> information in the log ticket to tell us that.
>
> Indeed, the main place we call xlog_tic_add_region() is also adding
> up the number of regions and the space used so that xlog_write()
> knows how much will be written to the log. This is exactly the same
> information that log ticket is storing once we take away the useless
> region tracking array. Hence xlog_tic_add_region() is not useful,
> but can be called 250,000 times a CIL push...
>
> Just strip all that debug "information" out of the of the log ticket
> and only have it report reservation space information when an
> overrun occurs. This also reduces the size of a log ticket down by
> about 150 bytes...
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c      | 107 +++---------------------------------------
>  fs/xfs/xfs_log_priv.h |  20 --------
>  2 files changed, 6 insertions(+), 121 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0923bee8d4e2..bd2e50804cb4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -378,30 +378,6 @@ xlog_grant_head_check(
>  	return error;
>  }
>  
> -static void
> -xlog_tic_reset_res(xlog_ticket_t *tic)
> -{
> -	tic->t_res_num = 0;
> -	tic->t_res_arr_sum = 0;
> -	tic->t_res_num_ophdrs = 0;
> -}
> -
> -static void
> -xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
> -{
> -	if (tic->t_res_num == XLOG_TIC_LEN_MAX) {
> -		/* add to overflow and start again */
> -		tic->t_res_o_flow += tic->t_res_arr_sum;
> -		tic->t_res_num = 0;
> -		tic->t_res_arr_sum = 0;
> -	}
> -
> -	tic->t_res_arr[tic->t_res_num].r_len = len;
> -	tic->t_res_arr[tic->t_res_num].r_type = type;
> -	tic->t_res_arr_sum += len;
> -	tic->t_res_num++;
> -}
> -
>  bool
>  xfs_log_writable(
>  	struct xfs_mount	*mp)
> @@ -451,8 +427,6 @@ xfs_log_regrant(
>  	xlog_grant_push_ail(log, tic->t_unit_res);
>  
>  	tic->t_curr_res = tic->t_unit_res;
> -	xlog_tic_reset_res(tic);
> -
>  	if (tic->t_cnt > 0)
>  		return 0;
>  
> @@ -2192,63 +2166,11 @@ xlog_print_tic_res(
>  	struct xfs_mount	*mp,
>  	struct xlog_ticket	*ticket)
>  {
> -	uint i;
> -	uint ophdr_spc = ticket->t_res_num_ophdrs * (uint)sizeof(xlog_op_header_t);
> -
> -	/* match with XLOG_REG_TYPE_* in xfs_log.h */
> -#define REG_TYPE_STR(type, str)	[XLOG_REG_TYPE_##type] = str
> -	static char *res_type_str[] = {
> -	    REG_TYPE_STR(BFORMAT, "bformat"),
> -	    REG_TYPE_STR(BCHUNK, "bchunk"),
> -	    REG_TYPE_STR(EFI_FORMAT, "efi_format"),
> -	    REG_TYPE_STR(EFD_FORMAT, "efd_format"),
> -	    REG_TYPE_STR(IFORMAT, "iformat"),
> -	    REG_TYPE_STR(ICORE, "icore"),
> -	    REG_TYPE_STR(IEXT, "iext"),
> -	    REG_TYPE_STR(IBROOT, "ibroot"),
> -	    REG_TYPE_STR(ILOCAL, "ilocal"),
> -	    REG_TYPE_STR(IATTR_EXT, "iattr_ext"),
> -	    REG_TYPE_STR(IATTR_BROOT, "iattr_broot"),
> -	    REG_TYPE_STR(IATTR_LOCAL, "iattr_local"),
> -	    REG_TYPE_STR(QFORMAT, "qformat"),
> -	    REG_TYPE_STR(DQUOT, "dquot"),
> -	    REG_TYPE_STR(QUOTAOFF, "quotaoff"),
> -	    REG_TYPE_STR(LRHEADER, "LR header"),
> -	    REG_TYPE_STR(UNMOUNT, "unmount"),
> -	    REG_TYPE_STR(COMMIT, "commit"),
> -	    REG_TYPE_STR(TRANSHDR, "trans header"),
> -	    REG_TYPE_STR(ICREATE, "inode create"),
> -	    REG_TYPE_STR(RUI_FORMAT, "rui_format"),
> -	    REG_TYPE_STR(RUD_FORMAT, "rud_format"),
> -	    REG_TYPE_STR(CUI_FORMAT, "cui_format"),
> -	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
> -	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
> -	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
> -	};
> -	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
> -#undef REG_TYPE_STR
> -
>  	xfs_warn(mp, "ticket reservation summary:");
> -	xfs_warn(mp, "  unit res    = %d bytes",
> -		 ticket->t_unit_res);
> -	xfs_warn(mp, "  current res = %d bytes",
> -		 ticket->t_curr_res);
> -	xfs_warn(mp, "  total reg   = %u bytes (o/flow = %u bytes)",
> -		 ticket->t_res_arr_sum, ticket->t_res_o_flow);
> -	xfs_warn(mp, "  ophdrs      = %u (ophdr space = %u bytes)",
> -		 ticket->t_res_num_ophdrs, ophdr_spc);
> -	xfs_warn(mp, "  ophdr + reg = %u bytes",
> -		 ticket->t_res_arr_sum + ticket->t_res_o_flow + ophdr_spc);
> -	xfs_warn(mp, "  num regions = %u",
> -		 ticket->t_res_num);
> -
> -	for (i = 0; i < ticket->t_res_num; i++) {
> -		uint r_type = ticket->t_res_arr[i].r_type;
> -		xfs_warn(mp, "region[%u]: %s - %u bytes", i,
> -			    ((r_type <= 0 || r_type > XLOG_REG_TYPE_MAX) ?
> -			    "bad-rtype" : res_type_str[r_type]),
> -			    ticket->t_res_arr[i].r_len);
> -	}
> +	xfs_warn(mp, "  unit res    = %d bytes", ticket->t_unit_res);
> +	xfs_warn(mp, "  current res = %d bytes", ticket->t_curr_res);
> +	xfs_warn(mp, "  original count  = %d", ticket->t_ocnt);
> +	xfs_warn(mp, "  remaining count = %d", ticket->t_cnt);
>  }
>  
>  /*
> @@ -2313,7 +2235,6 @@ xlog_write_calc_vec_length(
>  	uint			optype)
>  {
>  	struct xfs_log_vec	*lv;
> -	int			headers = 0;
>  	int			len = 0;
>  	int			i;
>  
> @@ -2322,17 +2243,9 @@ xlog_write_calc_vec_length(
>  		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
>  			continue;
>  
> -		headers += lv->lv_niovecs;
> -
> -		for (i = 0; i < lv->lv_niovecs; i++) {
> -			struct xfs_log_iovec	*vecp = &lv->lv_iovecp[i];
> -
> -			len += vecp->i_len;
> -			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
> -		}
> +		for (i = 0; i < lv->lv_niovecs; i++)
> +			len += lv->lv_iovecp[i].i_len;
>  	}
> -	ticket->t_res_num_ophdrs += headers;
> -
>  	return len;
>  }
>  
> @@ -2391,7 +2304,6 @@ xlog_write_setup_copy(
>  
>  	/* account for new log op header */
>  	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> -	ticket->t_res_num_ophdrs++;
>  
>  	return sizeof(struct xlog_op_header);
>  }
> @@ -3039,9 +2951,6 @@ xlog_state_get_iclog_space(
>  	 */
>  	if (log_offset == 0) {
>  		ticket->t_curr_res -= log->l_iclog_hsize;
> -		xlog_tic_add_region(ticket,
> -				    log->l_iclog_hsize,
> -				    XLOG_REG_TYPE_LRHEADER);
>  		head->h_cycle = cpu_to_be32(log->l_curr_cycle);
>  		head->h_lsn = cpu_to_be64(
>  			xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block));
> @@ -3121,7 +3030,6 @@ xfs_log_ticket_regrant(
>  	xlog_grant_sub_space(log, &log->l_write_head.grant,
>  					ticket->t_curr_res);
>  	ticket->t_curr_res = ticket->t_unit_res;
> -	xlog_tic_reset_res(ticket);
>  
>  	trace_xfs_log_ticket_regrant_sub(log, ticket);
>  
> @@ -3132,7 +3040,6 @@ xfs_log_ticket_regrant(
>  		trace_xfs_log_ticket_regrant_exit(log, ticket);
>  
>  		ticket->t_curr_res = ticket->t_unit_res;
> -		xlog_tic_reset_res(ticket);
>  	}
>  
>  	xfs_log_ticket_put(ticket);
> @@ -3642,8 +3549,6 @@ xlog_ticket_alloc(
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> -	xlog_tic_reset_res(tic);
> -
>  	return tic;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 65fb97d596dd..47165c4d2a49 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -142,19 +142,6 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> -/* Ticket reservation region accounting */ 
> -#define XLOG_TIC_LEN_MAX	15
> -
> -/*
> - * Reservation region
> - * As would be stored in xfs_log_iovec but without the i_addr which
> - * we don't care about.
> - */
> -typedef struct xlog_res {
> -	uint	r_len;	/* region length		:4 */
> -	uint	r_type;	/* region's transaction type	:4 */
> -} xlog_res_t;
> -
>  typedef struct xlog_ticket {
>  	struct list_head   t_queue;	 /* reserve/write queue */
>  	struct task_struct *t_task;	 /* task that owns this ticket */
> @@ -165,13 +152,6 @@ typedef struct xlog_ticket {
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
> -
> -        /* reservation array fields */
> -	uint		   t_res_num;                    /* num in array : 4 */
> -	uint		   t_res_num_ophdrs;		 /* num op hdrs  : 4 */
> -	uint		   t_res_arr_sum;		 /* array sum    : 4 */
> -	uint		   t_res_o_flow;		 /* sum overflow : 4 */
> -	xlog_res_t	   t_res_arr[XLOG_TIC_LEN_MAX];  /* array of res : 8 * 15 */ 
>  } xlog_ticket_t;
>  
>  /*


-- 
chandan
