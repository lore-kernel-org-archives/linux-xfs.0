Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99220C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 817C860E9C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbhITKNm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:13:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26058 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233135AbhITKNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:13:39 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA0AUS005962;
        Mon, 20 Sep 2021 10:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=M/mJHBd/GdHa3l7bwdzOmwtttkXd9tErCEi3YleAGZo=;
 b=qVHAs1L0wqMkmhqGv8Ah5HP830K3U69uRvPZ5bFVlPpFn9PzTfG101h/OGW3dFpU/Lp+
 YSe3LpVBjddDUNiQwWbwyRC6K9mLV95DPBtkaIJjYRgvCI4EWlWQit5WYJC2CjbKVw85
 Zjgw7PYUKa2V5Gajkei3jVqV1QAJ2+zbbGvwDx2HL7IU2qqZFSuD3b0jicZGICfpum7B
 FwGzdnFJR7FI5yjnl1BJ0jZFYdaCriq3hldYmiSdBeXtdNguT3CxPKMxKC8XYigx8any
 qLZxbAQ9sUclLcdP+nvbhniSibVplZ65ru4+ydE97GziOoMcDwJmjU8jumFHmVEOAY/Q mw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=M/mJHBd/GdHa3l7bwdzOmwtttkXd9tErCEi3YleAGZo=;
 b=kQAPF7kYJs45e/3tRbdOEtwTOEbGYDBQ5hMPCzJ7W9sfTPjl6xJiNWoXGo4UsK77Yenh
 EI03HxucjzD2PUneHm0typXfNsfS8KUhr3UnK22MZOv8DRuP9nNAJDVD395Ip3bGqAvQ
 2iHxcPuFzhbm0VMOET3BRQAOLBdcU3UjKW0tkeyZsOJQy47iHwa8WvMpDNwrBG04Ng9Z
 cWkvfU1Esdh/z+XBpH4oefRDp3Bz8g3kcqIYIDY7TDEdErb9CGVvIEA3ilJSTgO/y1K0
 0A9J04a1h/vEiKZLRvjMkAxkk09fUB9TzxWnbixWnX+l2TQwakyKCoXgwo6cWQJe5ram eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b6426a07d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA9tgU085268;
        Mon, 20 Sep 2021 10:12:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3b5svqfv3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:12:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QihIDSaxu0DaebguPpnj0kGsC51OSGl13pqoDQYcWXwy94O1aeUmoMTWDZ6U9vuiuNgik1HlMWPuDbqGzHO78OIKGXiNs8V/EyM6Yvy3FOafGFaSZpwam0AsJjzp2mfsYziyubupSqclfZ2LogO/yv5GQgRDIXaz6Dsqo5AB1Kp6pcrDti/MK391TsmBzmf4tYxzvRsjMeS/we5sL6PO5ZIkS/R3PJ+JnDG4eyhUy5uadX9pRWki1xlhEbMpyGySz72ZA/t8oawkOxDPgLVFzVKJuGpv9YWslvFhBJkJCKp0n6JLGg8hhbiHqO1AMVjtTInqEon4SV8MaEEqfgXYXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M/mJHBd/GdHa3l7bwdzOmwtttkXd9tErCEi3YleAGZo=;
 b=KW+PzlpaEiqWV4MC5PvRZdgGv4v9HqxcjFpuDyXTTlj3AyXLZbfKRZdiv1UMNCeoQEj/Ci1OJ4dUolvnzTIupJj7AmJbCOdrXyo9McStSUvPZfe0W8eooGYP3KCEZkrURr1Qt0hfnQD67M9XKKAYYTp78fKCVxFP1YSac3RwyfRxu3+CdBI4cUphAAOxAOwtv268lBkYlhSenzsbbt1BKAK3ocTQiM3VAZOXxshnPBv63+9HB1kjL/0zjcl3HgfomdemluaZcPboltoylJ4Qsph5VZcL171Np5lFM6V+T6nMe6578sKLI8xcdjmR2PFu0hpJQv67WtCLmM2ylB1idA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/mJHBd/GdHa3l7bwdzOmwtttkXd9tErCEi3YleAGZo=;
 b=yiZcjTwYR3Rj0jBZVpou9r8htOA2O06FpDXZ1b15Fa+TSTDMpr4pwPhEIEgN/4NHBp24hXdG2/kR9ZhroB9tpQcrWSu3uOh98NP6SUdoWFhtmV8GFqNpqSjrr39fG+bGJMADGr2MZmwhx3jqlI8RVnj7iWweTlsUgFohMILXuzg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:12:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:12:07 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192861564.416199.12921575958749918045.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: compute actual maximum btree height for
 critical reservation calculation
In-reply-to: <163192861564.416199.12921575958749918045.stgit@magnolia>
Message-ID: <875yuv7epf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:26:28 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MAXPR0101CA0023.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:12:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bc675b1-41a4-40b3-6dc0-08d97c1f1a22
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540D06AC156E86CAEA75CA8F6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTrcptIpKHdauYDt1FUnZBo9GMpfIZ0OSqLBp9sQCAIfxM0BSwAAMFkWh5Ulsu5CsAKt7WeJD5JYw9N+MufqLJPP/fO1gvOc8eThhsLLxNW2xEZ/AwgRFsjutwbYtuMMu1l7MtYBcvdIQSi7/MytUL2ASLXLA1BQQVeBB/o2RjRZnKuVc9v4zSORL2kNua07zOtyFdL7rxs/+xW+scjsyDjnoLFTfn8qx6H1jV7JTVqqnMk5RG3nqYQtXkJ0pXiBD4vnIx4aIhGKR3K5HHXoXpbufeFilOgNOh+lMzOv8kMeaecwGS7WKBH2pL60xjGfBb9NXfgt3+EY/E8DzhaAk+cw+9z6vguemh1DP/OG2BwOZTHCrIElg+ORcWn0ppwYX+2oZLizYBDWCUq2AvtEIhRq1pK9D6YX5XdxPf5pRDyVHQtFH6jlx/PeKkd2PTNUGtx+eiLPY+AwrcoCXG541bDRGOfafDf4q1B3Ps/G5O864smmCpX355g7ZgVpGnFly/MbMPoYCHkhDzluzzSsZHvzXYwURmEsaY8Ky8o/CJDn0OzV/OkYYv/zBYnH4ZomWjSI3TY5xEdyqHs7FhylVXh3ItO5Dt3xWgdnCzSwcPFRaCj05myK7OTXxqMWDS8U52N1/BWocBnXjYgzZz0h2XUA+cA/O/LW0aRsbV+5rSkqst2drL5XdOZWxlHykA+7BmaSgW5gUmRrKcKnTfSleg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ISdm2+77hyOj6UINxobThZAUhFgmhiQQVPk43xrjtgmXP8aURtC1wPJEGeMU?=
 =?us-ascii?Q?YVq0ZsBLbuOeXGnnWIWZ+AkjrMMLUShlAGYvb9XMDS1WaLI1bacUyUe/dxis?=
 =?us-ascii?Q?WIWgoi8zZc7dssJRbB2vnXbEVdd7SXesCn9Bf0zH4i65PQPs/yVSwG50uRX6?=
 =?us-ascii?Q?NFyC3kIZSPkr7Bxg/VXr1LfmdGl4cq0rfin8QyZkMiJ4XXoh3hsut1p2nTgW?=
 =?us-ascii?Q?f6nUL2ZZal7c0A3QRfs53Z0Fu+IQ/+0FFxoTT9oPNcuk+BstrBBnMAFFTbso?=
 =?us-ascii?Q?g06HeMIhKgIZ9JWo1p6hoegvqhZqWAUS6jtFQyDqYyPeN6KG5Bp0f+sNmrjK?=
 =?us-ascii?Q?h3JhOurCR0Y7KzhgbmStafzgqYxqT//f68Y771r/y9hXtf/y1ekWldX+/y1H?=
 =?us-ascii?Q?zHudfwntncu9dtZUNkyKNlB4NVTULhP77sYDsrNVL2jZgbd/osucIA+qrBc0?=
 =?us-ascii?Q?dpNouIKLog0EKrRJxv3sWvaxzWCfbd3LiV7ccUCwwMQ8OcBqaY4mv8wKSjWz?=
 =?us-ascii?Q?JnNwxMYRuWQxFOGaRowgk4HbfL15d15RsGq+2IakkzBsAVKE6ieHFoO7agoW?=
 =?us-ascii?Q?9LBa/CoXvjIAVvB3hfUa+OlQhrWcHs1vTZlRck86SLWsJ+6RaZHlaY0APsWv?=
 =?us-ascii?Q?0W0zOQJQ0OpdeemsyIxYucoaEa3za409MD+WHTEQAV5mP0HkKDlzz2KPatCQ?=
 =?us-ascii?Q?1esl7C36LWrijR6SC8r3+zNaSY3HL+PI9BLFUmnn/1bdiMnOmbadb+9VlKGf?=
 =?us-ascii?Q?hnbcZRAuQ9wZW8qQsTQ8OuVoTfjxkekPs6cnphM47znFqcroyjW4eggx/hJI?=
 =?us-ascii?Q?eOkUPGQPDp7pesAeSF0CjuhNlxOKMKeJ89bFyVACF9UxAN8A3shSyS2Ae42m?=
 =?us-ascii?Q?bGDsrKJmKGWdxKtWZ7XaAZj7rMlRZsF60ldxmC2bcn0Rc66eHlL1hpv1qVgi?=
 =?us-ascii?Q?jgK0g1sy3DtGzpt3nFGAvQ58YEvAmjMmCsGGddD1xgYGhr4DmmstW6KevXyO?=
 =?us-ascii?Q?tdTUBHC65G5vZBkVSM0cvgVzIseHnUxvX8Tph8CUYUi2DgDhlMhbE8RO8o05?=
 =?us-ascii?Q?JLPDZHReVQB+317dY5gBonE7Gn+TLBs8JgTx2B22qJ10LcpxahDqiXxIrpBM?=
 =?us-ascii?Q?SlfVchUjci/Yns8fKkD796Ug55PUx7sPB5uGVmIMmOh/NDuIII/z55r78MGf?=
 =?us-ascii?Q?aLtTuTupm+r9FPWFI9t8Np4HyHyeUpkRO37i9p0b4YCJiksOeKr30GLbEELW?=
 =?us-ascii?Q?ndeBKkBWeZcDtQat8Br6+OK6kow2201317UvrGVlXCbtZoanC+CLFRxmLU4y?=
 =?us-ascii?Q?kPQnsUA5BF7XwYnTOija2l+G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc675b1-41a4-40b3-6dc0-08d97c1f1a22
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:12:07.7036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rnGiZA/ljoTDrd5ENgqwxoFJg1tWJDWvy2rQrB3Z8ZHsMJof+ZLZnDxBKYUlLcT+gFavop0hr5GIMSivC2KbfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200063
X-Proofpoint-ORIG-GUID: 64ye_LKYacEAq2vZr4-llc-MeZ1DLTV3
X-Proofpoint-GUID: 64ye_LKYacEAq2vZr4-llc-MeZ1DLTV3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 07:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Compute the actual maximum btree height when deciding if per-AG block
> reservation is critically low.  This only affects the sanity check
> condition, since we /generally/ will trigger on the 10% threshold.
> This is a long-winded way of saying that we're removing one more
> usage of XFS_BTREE_MAXLEVELS.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c |    4 +++-
>  fs/xfs/libxfs/xfs_btree.c   |   19 +++++++++++++++----
>  fs/xfs/libxfs/xfs_btree.h   |    1 +
>  3 files changed, 19 insertions(+), 5 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2aa2b3484c28..931481fbdd72 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -72,6 +72,7 @@ xfs_ag_resv_critical(
>  {
>  	xfs_extlen_t			avail;
>  	xfs_extlen_t			orig;
> +	xfs_extlen_t			btree_maxlevels;
>  
>  	switch (type) {
>  	case XFS_AG_RESV_METADATA:
> @@ -91,7 +92,8 @@ xfs_ag_resv_critical(
>  	trace_xfs_ag_resv_critical(pag, type, avail);
>  
>  	/* Critically low if less than 10% or max btree height remains. */
> -	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
> +	btree_maxlevels = xfs_btree_maxlevels(pag->pag_mount, XFS_BTNUM_MAX);
> +	return XFS_TEST_ERROR(avail < orig / 10 || avail < btree_maxlevels,
>  			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index f9516828a847..6cf49f7e1299 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4922,12 +4922,17 @@ xfs_btree_has_more_records(
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
>  
> -/* Compute the maximum allowed height for a given btree type. */
> -static unsigned int
> +/*
> + * Compute the maximum allowed height for a given btree type.  If XFS_BTNUM_MAX
> + * is passed in, the maximum allowed height for all btree types is returned.
> + */
> +unsigned int
>  xfs_btree_maxlevels(
>  	struct xfs_mount	*mp,
>  	xfs_btnum_t		btnum)
>  {
> +	unsigned int		ret;
> +
>  	switch (btnum) {
>  	case XFS_BTNUM_BNO:
>  	case XFS_BTNUM_CNT:
> @@ -4943,9 +4948,15 @@ xfs_btree_maxlevels(
>  	case XFS_BTNUM_REFC:
>  		return mp->m_refc_maxlevels;
>  	default:
> -		ASSERT(0);
> -		return XFS_BTREE_MAXLEVELS;
> +		break;
>  	}
> +
> +	ret = mp->m_ag_maxlevels;
> +	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
> +	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> +	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
> +	ret = max(ret, mp->m_rmap_maxlevels);
> +	return max(ret, mp->m_refc_maxlevels);
>  }
>  
>  /* Allocate a new btree cursor of the appropriate size. */
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index ae83fbf58c18..106760c540c7 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -574,5 +574,6 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
>  		const union xfs_btree_key *src_key, int numkeys);
>  struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
>  		struct xfs_trans *tp, xfs_btnum_t btnum);
> +unsigned int xfs_btree_maxlevels(struct xfs_mount *mp, xfs_btnum_t btnum);
>  
>  #endif	/* __XFS_BTREE_H__ */


-- 
chandan
