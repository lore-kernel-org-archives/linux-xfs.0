Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CAA8C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5228860F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhITKKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:10:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50078 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhITKKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:10:30 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18K9qF1a028218;
        Mon, 20 Sep 2021 10:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IgYGjuj1LhpsgH1nUxJpKRzDgLHRlK4420yEM7tzAQ0=;
 b=T6SAtMJLcwA8whUbm3D40yvSaCVVgfNRPHj3j8Y0A2C9p8b1q9MwV1M4TfQqBZZ1cI9m
 jjLS73T9nePpp/moU2JOMksz2H2VuU+oShFAGyRUl8o2GyrLb5fX4/R7vJwJEc5YeC2v
 hdwcCv8qMizROSHKksqCJ4SsHJq3E5EmLWWy09k6jztKOs5gqtj4lw2vC1Fkm8Xkakza
 0IxxWVjEgFrLzei82koYkwFgYY4HqxvpJjdxLOqlq+fZ00KoUks+EtUCeCcd404PHyWq
 EbiDhzQ94fcILAnBrmuSLC/RbexCWEa/JBWoDMUg4jA/mu4XdN9kIvfaxQokZTykQw7p tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IgYGjuj1LhpsgH1nUxJpKRzDgLHRlK4420yEM7tzAQ0=;
 b=YG7BlZRgiX5rULj8LTWTWPwEdjZOAxrGIJM+OmFfdFQ56nG//qqsQtlVdkcl26mm0h4y
 JayK+qmShgtTFox4HX7AwcagV0K2/5FY9jw486wVuNNPGwiErQBskY7j9cB1XOBSnsHM
 5IfVk54Wm7TbSli4vsxELW5uEvyqo2J7Kwq3BXav8VOKmfsiRwkKxOl+tyyUlcoiQWyJ
 z5McZUP/ooNvvFBxydByrvPoqjmYSR/IVPhraT2t0m7vvOdgiW2pGM6QRcsUIYX2eef/
 GurGH2nHk7tnnTaLGXXmRgHsP+pd7T7lY/+pPWc69Rc2UGdx5+UDn6gx4j1w7MmP+gpq 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66wn1ss2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:08:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KA4iCM096548;
        Mon, 20 Sep 2021 10:08:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3b57x3twgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LiqiMuArSTO3ubtfesAbGdysSJf1Ne3Fl0nvAWPHVr0mNxgGXkg6sf4ni7Fg5f9p13WJYTHbYi4ncWWNouoTzaE1OoivDq2CrKF4/aR+Wpueu4uhWa5yYEUPszrHwR3h0foVGhmcuQWtce2ZLGBsz6z5/OjX7fcDTvh/LhF86hLSnOmjLvRRQnX0botX2uMbSw06VqPOxMesmEItI0NE+D5+lH7TmUTof6zYv64oQ9Du8dNhRIjmmz3BRxjh8cLMrJO/w26QddrfW7n4zfypfR1v6TJL1dd9dUPQFQzDFfiWL+M9xSwmVkbFuecqGvm5W7fam0hTS5a3wn391Ydk6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IgYGjuj1LhpsgH1nUxJpKRzDgLHRlK4420yEM7tzAQ0=;
 b=b32IlAAfeiHUt/pWLNWBjQyUvauvpntrxe3GKn79iqouG57/PU0Yx3QOELgYf78uEYuN63u2/dBFAeK24W15SpDnazXUoHOe5/7ghBmqoBTJkz1Vjd50o88dOpyvk5ZRpQcRtHTzIoY8x3u/lz2pF6e75+Us78oLKGfDDQZkycKzkEfjUwbILQb7MiAFDwJYxr/hXap21eS+xf11fNBPbskQRQQchSnjy7Z40kqq3vHiWTSG7mWNFMNRwpwFXyDrLMPq18tC0Qd+k5c+6OrphmNSeY3tvViHqGTdCiizfoP2KyuZ7s9Z3gum1918G4/TBbmm9vf9xQquS/9dnGIBBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgYGjuj1LhpsgH1nUxJpKRzDgLHRlK4420yEM7tzAQ0=;
 b=M8s2KgtHMSRqisBHvXVGZS4/HBiEIL0F9mQWXM36b2YQQM4GaspDy0w0H67URmBf5tcFi/wqs0IjjyZzXmnudzQgPCAp6y3IAmvpMv6g300/eEJqkwab0njJPryK5to/huBwqu6UHT2jj04sEmx+lm7i8Tyz2QE6xcuz2UTorKU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4410.namprd10.prod.outlook.com (2603:10b6:806:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 10:08:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:08:54 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192855540.416199.17796390757325316141.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: remove xfs_btree_cur_t typedef
Message-ID: <87tuifopdt.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <163192855540.416199.17796390757325316141.stgit@magnolia>
Date:   Mon, 20 Sep 2021 15:23:14 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0034.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::20) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MAXPR0101CA0034.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:08:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc5ea219-cbbe-4f19-8e99-08d97c1ea6a8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4410:
X-Microsoft-Antispam-PRVS: <SA2PR10MB441064035C50ADC62968C404F6A09@SA2PR10MB4410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSPYdOERF/uvffA0dW6Q+C2myXcQ901X+XAu1/T3W9zkvgFOiwatxr91pL7qM9OlFkM/kTHpuMgx6N29KDIK5qNUe9KQvRMksrPOGeCXCj5uTMrc7INLY80kE/PQqfyhoOo3yi9oNTwquueJmb+AmTDYh9rgrKrkSDy4AfUSdXyURGQO1AdSUgk+q2dNYxCpE4xdmorJyBA4R1YLlh/7qrrQo+5WrT2NmZP+gYm6CrpYlX+jjlAZ9L62aRUsYbDZaa5oMYwnc1mkH9F/mG51jgwWz7Tm3awUV6GtQ2WXvbYovyMqXfPSKgQBpP7JLr7E+GGccBiMiWXVSXa4Ix3umjm4uFA7htWtD6gwp6pNbZrVCBP5na46tZNYfNG1DzhBWd9F9Dj3fGiO3D9bpp+22cJVZS7kphVr52EuT1rZkMGzuKW+LP4uwQHI9KFyfyScDursGAKF2FjG7bwWKjlSjcjwJF8IIoKrZIbNxWShQdFGsQrnswL0eUWUJCgrZc4VFmY0YxOS76l7AbkBoyyvqGDrtHEugdd0oStXvF9Hh44O+/mAPleS72E1FGMdz+9hsYDg4g7oqHLXh2Tum33zi9+4eKaCPfay6zVQWnW9RNINtHTisig10CKSHBcMPxm2ccomvBo9loPsgjiEbQw9IUEoI/8NLZQcsHh4Qs79r/E09QE0O4uH3dpVNCtoTMLnwdKYx7joD3pBVXN2T8u1DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(9686003)(83380400001)(186003)(26005)(6486002)(53546011)(66476007)(66556008)(6496006)(38100700002)(38350700002)(6666004)(52116002)(956004)(8936002)(4326008)(66946007)(2906002)(508600001)(316002)(5660300002)(6916009)(8676002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTeCUVby2V2b4PJCazQIRqcYzmKO4wHqYKUfQdohpXkbEmKsSFoRZuQ02LyI?=
 =?us-ascii?Q?nFUAxpvrP++rKXRTeD8BUDgFtrvngn4uMROjk5cMuzRZtEGz+rcgucyiPXiI?=
 =?us-ascii?Q?4ob6MtZYneC5L4jEVW60IHTEoyHndlPmyrlaBKouHYjcdy9MRa5Fd0hq+LMS?=
 =?us-ascii?Q?ayq12cTJXMz36WL7L/njO7axZBkZ5dOXlrCcrErs/PDrNGmpkYVFPehKYN+P?=
 =?us-ascii?Q?gH1G6gPP+mAu+8u8/pJMyqsz6kmUFxQpUzcbBwWIZEwks8aeI/Qy0NqBhRX1?=
 =?us-ascii?Q?p6QlnMlicwSnBdmeYKy3SaDjxCu52ZxU+CicG+AOckGCM4IhNMlkifYY9B1E?=
 =?us-ascii?Q?hQuXai8Hw7ln3EgQsPWBINUXQPPV65m6v0eB6FDcOM26QzHmaNYN9MSflq/e?=
 =?us-ascii?Q?buAs8lmr2GvSPJYDnykbbaA0QAiArJPQT8pSsbz/BsOuiepUuK4x6jB/QVSq?=
 =?us-ascii?Q?wJKuzv5Ur3tucLNxa6IB9XM/toNqKSbRB6YthLWxgrteH500EPffwf/KUkWG?=
 =?us-ascii?Q?kuQqdEozvMRuoxx1tNlj0LAB3xtNkszr5d1BjeQXc3vht4y+A/YgVPlvtYHd?=
 =?us-ascii?Q?yeW3HhCT4MkLwc2N2v+wnGTiJJ5G6Wi9OLZfQpzNuksswHMKx5i0NZFGmWWf?=
 =?us-ascii?Q?0fjyHyDM3wMZm9o4Yf4JioXgY91j5L8IIQQiOZeUouz2Kmbv91SWFWGMKJnB?=
 =?us-ascii?Q?I7m/vsQia6GPZB3Clm+dl3vruHmdJPOt1paa+bRvN7hwm9gRid+1oQBYjtqY?=
 =?us-ascii?Q?BCfAQQ3+pz0E9+jjlxcGC34vnIH8kEiZKEtOW7CCPSMRP0+XOO0EXs1KBgUJ?=
 =?us-ascii?Q?UXBal/NrMvx/JHIZ2l6srW/926XCD8P8imxQPWHrl6i61kPnyfMTIf7qtqc4?=
 =?us-ascii?Q?jvtfserT0T29KeHCXR6k2wqU7WOa7bep6P/nqkJX7t66iWhf05mkyJQV7geb?=
 =?us-ascii?Q?7vxTCKWbmEBhNj6k6fQcdktyTSmT8zCso3vaXkTrCkbGfMy75XFb+avFcRxy?=
 =?us-ascii?Q?nvBryEqd/mlKucVZw0OJRJjSVbipP17ttwwWXnnx59AOAinwm64Fb2kROEjB?=
 =?us-ascii?Q?YRMgm10fLUKXjywjJlXBNhH0JYso1OarCc1zjCu3VmF7RoYxSmscYdaJt+Ft?=
 =?us-ascii?Q?QxQX3QFboYloEaBVm/Fbd/Fjy4Sd9ZmoHtnyUSE3727MAv6932KNwXMKLXFt?=
 =?us-ascii?Q?n4YlW7m8Rx46BHkRhombvJ54EOFrHBYRI3NLJVks8AvAze9yB4ECP7+6FGEf?=
 =?us-ascii?Q?chB10GpImJSL/QlSZujTnvoJ0e+48AMmgRRe2ho/mLxCoP4DJ5uAG0UFeZoX?=
 =?us-ascii?Q?CfZ2+OB9UqfwrnwBRvqT7aJU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5ea219-cbbe-4f19-8e99-08d97c1ea6a8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:08:53.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGKGduXLwlh2iky4bZDg3ZuGElZHluuOydPFi7JAJTf8wiSgMHkHNCNajuxri19BIj6DPDZfD04HT8ZWq4DocA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200062
X-Proofpoint-GUID: 6cizObsKLf23hwVpxMps87xPDogWLEn0
X-Proofpoint-ORIG-GUID: 6cizObsKLf23hwVpxMps87xPDogWLEn0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>

The changes are straightforward replacements.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   12 ++++++------
>  fs/xfs/libxfs/xfs_bmap.c  |   12 ++++++------
>  fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
>  fs/xfs/libxfs/xfs_btree.h |   12 ++++++------
>  4 files changed, 24 insertions(+), 24 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 95157f5a5a6c..35fb1dd3be95 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -426,8 +426,8 @@ xfs_alloc_fix_len(
>   */
>  STATIC int				/* error code */
>  xfs_alloc_fixup_trees(
> -	xfs_btree_cur_t	*cnt_cur,	/* cursor for by-size btree */
> -	xfs_btree_cur_t	*bno_cur,	/* cursor for by-block btree */
> +	struct xfs_btree_cur *cnt_cur,	/* cursor for by-size btree */
> +	struct xfs_btree_cur *bno_cur,	/* cursor for by-block btree */
>  	xfs_agblock_t	fbno,		/* starting block of free extent */
>  	xfs_extlen_t	flen,		/* length of free extent */
>  	xfs_agblock_t	rbno,		/* starting block of returned extent */
> @@ -1200,8 +1200,8 @@ xfs_alloc_ag_vextent_exact(
>  	xfs_alloc_arg_t	*args)	/* allocation argument structure */
>  {
>  	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
> -	xfs_btree_cur_t	*bno_cur;/* by block-number btree cursor */
> -	xfs_btree_cur_t	*cnt_cur;/* by count btree cursor */
> +	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
> +	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
>  	int		error;
>  	xfs_agblock_t	fbno;	/* start block of found extent */
>  	xfs_extlen_t	flen;	/* length of found extent */
> @@ -1658,8 +1658,8 @@ xfs_alloc_ag_vextent_size(
>  	xfs_alloc_arg_t	*args)		/* allocation argument structure */
>  {
>  	struct xfs_agf	*agf = args->agbp->b_addr;
> -	xfs_btree_cur_t	*bno_cur;	/* cursor for bno btree */
> -	xfs_btree_cur_t	*cnt_cur;	/* cursor for cnt btree */
> +	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
> +	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
>  	int		error;		/* error result */
>  	xfs_agblock_t	fbno;		/* start of found freespace */
>  	xfs_extlen_t	flen;		/* length of found freespace */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b48230f1a361..499c977cbf56 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -316,7 +316,7 @@ xfs_check_block(
>   */
>  STATIC void
>  xfs_bmap_check_leaf_extents(
> -	xfs_btree_cur_t		*cur,	/* btree cursor or null */
> +	struct xfs_btree_cur	*cur,	/* btree cursor or null */
>  	xfs_inode_t		*ip,		/* incore inode pointer */
>  	int			whichfork)	/* data or attr fork */
>  {
> @@ -925,7 +925,7 @@ xfs_bmap_add_attrfork_btree(
>  	int			*flags)		/* inode logging flags */
>  {
>  	struct xfs_btree_block	*block = ip->i_df.if_broot;
> -	xfs_btree_cur_t		*cur;		/* btree cursor */
> +	struct xfs_btree_cur	*cur;		/* btree cursor */
>  	int			error;		/* error return value */
>  	xfs_mount_t		*mp;		/* file system mount struct */
>  	int			stat;		/* newroot status */
> @@ -968,7 +968,7 @@ xfs_bmap_add_attrfork_extents(
>  	struct xfs_inode	*ip,		/* incore inode pointer */
>  	int			*flags)		/* inode logging flags */
>  {
> -	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
> +	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
>  	int			error;		/* error return value */
>  
>  	if (ip->i_df.if_nextents * sizeof(struct xfs_bmbt_rec) <=
> @@ -1988,11 +1988,11 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	int			whichfork,
>  	struct xfs_iext_cursor	*icur,
> -	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
> +	struct xfs_btree_cur	**curp,	/* if *curp is null, not a btree */
>  	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
>  	int			*logflagsp) /* inode logging flags */
>  {
> -	xfs_btree_cur_t		*cur;	/* btree cursor */
> +	struct xfs_btree_cur	*cur;	/* btree cursor */
>  	int			error;	/* error return value */
>  	int			i;	/* temp state */
>  	struct xfs_ifork	*ifp;	/* inode fork pointer */
> @@ -5045,7 +5045,7 @@ xfs_bmap_del_extent_real(
>  	xfs_inode_t		*ip,	/* incore inode pointer */
>  	xfs_trans_t		*tp,	/* current transaction pointer */
>  	struct xfs_iext_cursor	*icur,
> -	xfs_btree_cur_t		*cur,	/* if null, not a btree */
> +	struct xfs_btree_cur	*cur,	/* if null, not a btree */
>  	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
>  	int			*logflagsp, /* inode logging flags */
>  	int			whichfork, /* data or attr fork */
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 298395481713..b0cce0932f02 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -388,14 +388,14 @@ xfs_btree_del_cursor(
>   */
>  int					/* error */
>  xfs_btree_dup_cursor(
> -	xfs_btree_cur_t	*cur,		/* input cursor */
> -	xfs_btree_cur_t	**ncur)		/* output cursor */
> +	struct xfs_btree_cur *cur,		/* input cursor */
> +	struct xfs_btree_cur **ncur)		/* output cursor */
>  {
>  	struct xfs_buf	*bp;		/* btree block's buffer pointer */
>  	int		error;		/* error return value */
>  	int		i;		/* level number of btree block */
>  	xfs_mount_t	*mp;		/* mount structure for filesystem */
> -	xfs_btree_cur_t	*new;		/* new cursor value */
> +	struct xfs_btree_cur *new;		/* new cursor value */
>  	xfs_trans_t	*tp;		/* transaction pointer, can be NULL */
>  
>  	tp = cur->bc_tp;
> @@ -691,7 +691,7 @@ xfs_btree_get_block(
>   */
>  STATIC int				/* success=1, failure=0 */
>  xfs_btree_firstrec(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	int			level)	/* level to change */
>  {
>  	struct xfs_btree_block	*block;	/* generic btree block pointer */
> @@ -721,7 +721,7 @@ xfs_btree_firstrec(
>   */
>  STATIC int				/* success=1, failure=0 */
>  xfs_btree_lastrec(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	int			level)	/* level to change */
>  {
>  	struct xfs_btree_block	*block;	/* generic btree block pointer */
> @@ -985,7 +985,7 @@ xfs_btree_readahead_ptr(
>   */
>  STATIC void
>  xfs_btree_setbuf(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	int			lev,	/* level in btree */
>  	struct xfs_buf		*bp)	/* new buffer to set */
>  {
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 4eaf8517f850..513ade4a89f8 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -216,7 +216,7 @@ struct xfs_btree_cur_ino {
>   * Btree cursor structure.
>   * This collects all information needed by the btree code in one place.
>   */
> -typedef struct xfs_btree_cur
> +struct xfs_btree_cur
>  {
>  	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
>  	struct xfs_mount	*bc_mp;	/* file system mount struct */
> @@ -243,7 +243,7 @@ typedef struct xfs_btree_cur
>  		struct xfs_btree_cur_ag	bc_ag;
>  		struct xfs_btree_cur_ino bc_ino;
>  	};
> -} xfs_btree_cur_t;
> +};
>  
>  /* cursor flags */
>  #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
> @@ -309,7 +309,7 @@ xfs_btree_check_sptr(
>   */
>  void
>  xfs_btree_del_cursor(
> -	xfs_btree_cur_t		*cur,	/* btree cursor */
> +	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	int			error);	/* del because of error */
>  
>  /*
> @@ -318,8 +318,8 @@ xfs_btree_del_cursor(
>   */
>  int					/* error */
>  xfs_btree_dup_cursor(
> -	xfs_btree_cur_t		*cur,	/* input cursor */
> -	xfs_btree_cur_t		**ncur);/* output cursor */
> +	struct xfs_btree_cur		*cur,	/* input cursor */
> +	struct xfs_btree_cur		**ncur);/* output cursor */
>  
>  /*
>   * Compute first and last byte offsets for the fields given.
> @@ -527,7 +527,7 @@ struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
>  /* Does this cursor point to the last block in the given level? */
>  static inline bool
>  xfs_btree_islastblock(
> -	xfs_btree_cur_t		*cur,
> +	struct xfs_btree_cur	*cur,
>  	int			level)
>  {
>  	struct xfs_btree_block	*block;


-- 
chandan
