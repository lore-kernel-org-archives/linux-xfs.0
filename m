Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8F2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 15:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiBPPAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:00:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBPPAM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 10:00:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC651B8FD4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 07:00:00 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GEifT9025581
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=S9JT9WGnAi8BYKLTY5f5zNX8fYkLJjan+sJ/xfsZwso=;
 b=Opp88IBf2S+iUa1+SfSDw0EuILh7hNoJhDCcellDpgYNL0fTQipjZebG8ZsxjGTxnrLv
 1EpWif0mzxGsMl5jdhOkVKvLZmi/OVsnwP8GkO7v6m8fkLVP3wFxG91cERTJ/zKuoRlC
 o7Av8/t+KYmcapsgOLj633xN71bkfctITZQJ4ndYBtmUAKU+xZ0AX4Hb/RPp4bVTPoCo
 2EaCd8srfwFf7urCNa6GNVyursU9B6etphulTb20I8+hQEaI2PyMeTUjir6/PcCajU+K
 WcmlO5jPQ58tV2SuNrDwrSZ6rCTkBsSyyRUAp+5uqKkOfx3+mEEGsWDM4ktX09Z0DyPr nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nr92dw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GEoYWU078196
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:59:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 3e8ns946th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNeX1oNQ+EukjbZgA8furrh+ZanVVl4KSNu1BVL0ghG5Qd4K60cBo9M8IBMSy9o2qGGat6N2xir9pUPX4TKgEnkN297ky8z+q6EhRGEMiV0w4IfSCdtvxp8DGS+EX/42ze3KRDXmXXpKziweChbI9F2eLKcyL7Cehc6GDiNwd/q0PktvwdC5uZChJ39nbv7GdMxvMUMRSQgKHFHM1zRgrZ0w04FrEZvy2glHxHohQE/wyHqjy2Yo/7S1ENRZ36KkHSbn8BQfTVCmHqi+LDPeUZBjsWdKr/nKqT7/dkyJ0hAbnrX0QsYCOP2ZUd4faukj5duMka1sHBhpX6EvsN6NQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9JT9WGnAi8BYKLTY5f5zNX8fYkLJjan+sJ/xfsZwso=;
 b=ZCYMRbG/uxqD7g+4JSq1pmXqTe0B+Q42du2E9lp1Seq2wvm7amIwMkbJTlKoU7PMT67f58FTiwKXmf67lA1ka5+D5+WrB4x7XB6+YuVfJZSHlwrfRM3Oxp1l9n3FYYLXHkYbJLE2/fMb+nEhi33oggbRfEej8VhfhuMqUjfq9P1MZdvVv/Z04tANa8Rz3rTawxNYplt0TynVbsxF9cIeI/5bkNMCqPwanqLimtaXKh1ZbleDHgIIP3+cDYYUs4SOdUFArwyPzH8BpGW+Jh/yRIKnGm2CMvHh/aWRx+evgp6t2TL2NURufrGY4SaDHkjcQ1d8lt68Or2CW/h2CKq7fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9JT9WGnAi8BYKLTY5f5zNX8fYkLJjan+sJ/xfsZwso=;
 b=HrVwivAsAvNYi8owBgueebhJTxXsU5LkvkIOpvIpLqLlWdxKaIPDlJBMtbK34w9hYpUqx+fvZIczP/RNFAP9zvbvDFYkwKsFcCdOR0IlG2PXrAWsCb3a35b6ol9Jzux8VIR47drxSAB3tE94+y1kXjJ5lDpB29Q2ZhmOw7PRLOQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5425.namprd10.prod.outlook.com (2603:10b6:5:35f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:59:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 14:59:57 +0000
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-15-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 14/15] xfs: add leaf split error tag
In-reply-to: <20220216013713.1191082-15-allison.henderson@oracle.com>
Message-ID: <87czjmj1r0.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 20:29:47 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::25)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c90487e1-e2c1-426b-6fc7-08d9f15cff14
X-MS-TrafficTypeDiagnostic: CO6PR10MB5425:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB54252FE89ABC4B27CC8AECE8F6359@CO6PR10MB5425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SS9mChVWiMcEKo6VbyYcLy+EpquJ/Ld5kFcCTt+h78AIzbusgy8i0wRGSKPa7e3DzOUIRUqG8xkacAgKhcI6qzBYIo8Tr3loBHlpSdIpdcjTfaU3eUgsDqHYNWzVe0mTtnh0AdzJvRjltn3goFfcs8GUBS5Vi5vOr6jwM3Nw1js76WHLMEfd3UOea6aTlp5cn78/lBiet1aFn/l8KHXx5IEokREUgkUSM1RuQKnYxZEvQ2qnSFb/jFxvnVqUdnSHojk/0TolzhjYMJyHD55OSQ8IIX3duLYNztNePkB8BsyotetukvIjjcvHw/1M8TszASqPbK855DMiZ1x6IW9k+nUkC3Ni4JxWEVU3xlohYyc197ia9HqrO3WfV2d9kyi7CiwDICV6IMHj1snlGlAU+d1+/TUjps7StmPNFbpS/XH2SLLKNr7jYeW2ItIKU2bHNlB4l9Ode6QUHURcKiVnxzpJt9q79kzH6+mw8Ws6n5RkQmoP/Fzp/ET9LzTFLkHMNIYGF2eL5jGQACuTDkhJ+ScfbQx/Q82EvMb6zihfLjQzYqEdRMknVtf+BKuu+If5lI8gD9oo6JH1n4/3OMwcFPjVgJ0sHiq+hfKpehgtl2fFZnzWOn8zNJnZr/2P0H56aqeVTmMdQPk0opgBQe1JbZjObVYZgNOWtyg3W3CDu7FPLWSV79rlU2d+/DWI8KhpCfYcV9bJOSR8n9mNKn1igw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(26005)(33716001)(52116002)(53546011)(9686003)(6666004)(6512007)(6506007)(508600001)(316002)(6636002)(6486002)(8936002)(2906002)(83380400001)(86362001)(66476007)(66556008)(66946007)(8676002)(4326008)(38350700002)(5660300002)(6862004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hNhCt4iogkT7N/vPaemhoivEtm8QIJ7LOv2OZ0OprJxRHCleLayIbHIfiuoX?=
 =?us-ascii?Q?r/BLc3GNMed13NIMpk5Rr0H4PGmRfl3wiIu7VqRLgoWhVwMTUr5AYDXT5Pwi?=
 =?us-ascii?Q?6rGpRLkEuMkRfvagFl+W8GYMggetJac5XUZzkQZzFG7x5mn6j1CvgHgKPQZc?=
 =?us-ascii?Q?jafgnFaHAZys8advIwMm865JtmFOZE6rOXMxpSr1nhjsDXPOmn/4aXn7m6i1?=
 =?us-ascii?Q?qOoCqk4+00/kMZ/sZxVI3ADXuXV8mvbbg3CkyUT5FmGvIQy0OiigAtH39KbI?=
 =?us-ascii?Q?xHkSlnmBD7h7YbgopqDyMMWLaYk8YsOFY9P0BEUgm914C3JkiNrMMOnH/AY9?=
 =?us-ascii?Q?JS/rmS6cXjqxuONylIqfuLCApxfW8z4m4663bYv5uJ7aBOXbU65rD/5226Ip?=
 =?us-ascii?Q?3zvCjbfsytftzSATe7EFlA1bXALzmadvoadC6CADsvwvKRY41btzbnvHpUm9?=
 =?us-ascii?Q?W6hG6pDS2PLLN9Bh/zgtba5wchVOBxHFZ/4x9H70QLUQXtR7ANULSv3J7rt7?=
 =?us-ascii?Q?2XZIvfcyy7JKJUiLAir8cQs89Lp/TUKA/3hPj4pB2sfXQXq0gfrFJRq4ZXdN?=
 =?us-ascii?Q?JY9f9KHul0533wsE6ArGJlbtkPRCVVPNqwa92owGQad23Xvoof3V/930LNFr?=
 =?us-ascii?Q?KJbP5fTYlSjye/352ZZWOIgqrY8d9JygNVNjtOecbl/Ss3mmlkX3Ker4PwkS?=
 =?us-ascii?Q?jej5WqRVTzpmgQDLBnCxrGc3d+8cuxxH6leVgfcS2Hrt0wYG39FlnUEvHi72?=
 =?us-ascii?Q?Bz76818fFqVIDt0Q0b1t+izaoSBkLCtT4GCb5w/TF6chFHt+lPR2pcZDXgBo?=
 =?us-ascii?Q?T2S4MTjcHpxwM0vMYaaAgSH/DaiyO9Z91FbwHJmqv43EeFVMUUO17GpDHUrM?=
 =?us-ascii?Q?kpbm9TMSLdsznVoDbhLdvw5lgA4hW9nZIoZxvSBOdhifhQT4DvwS635Kb+k+?=
 =?us-ascii?Q?jvTP7SC4Q1O1OlDMTAyijHPz+35p3pkdri8C5s6KwT6AkQ17rSKOzTyo8Pzk?=
 =?us-ascii?Q?5KRJ35LotSQozdhlVH090JaU+oJuKfIb6Q7489rLJwoU2yLSCcD272r45W19?=
 =?us-ascii?Q?25HB422QV27vpX/pQd1luqcTDwevZ7RL/U9Xn3s967x/NRueJMbNMS6JB6fJ?=
 =?us-ascii?Q?mFvz4+1Gu5hnyyNJa3B8mD3Wb1i+3tccGANdfqTMZusKyk+K74yQo+jKAcdo?=
 =?us-ascii?Q?CB13wmERhOgcOoknBORXttZ/MkfSZZQB26uSGqm+qBNQYitx25nEH3PVe6ku?=
 =?us-ascii?Q?hLttnGoUbMjrUAaxHTTVX/Zey6NfaAiFrdtIdb4V0h2oT/FhYRueOZLp699c?=
 =?us-ascii?Q?w5e0NwgWgmHAOh2ZXBOT0rz2yy5Ak1ckzmYj7U0+p0yTWDydxO7MH+2dLSyZ?=
 =?us-ascii?Q?ctq/5l6p7bUKKUVJtyhpLn6KlTkfMVb+dzCbei+6rwv9R/FldlpwPGQN6mi2?=
 =?us-ascii?Q?qMQ30dYgYvG96k0/ZkweiYLIu8p4sqek1OLZY4fqw0R7VZLpkoRSLCygmjZP?=
 =?us-ascii?Q?lCeUmnW8GkaF8JeTZAIpBWJMtzCYLwtrffBjLbuvVh+ckv4QWcy+jv5JZ0H0?=
 =?us-ascii?Q?23MneHJa9/aRlJrO39UvMw+TvrfBYSAhnhyvnyR1KgZv24GnjXvJ8pQqoeCe?=
 =?us-ascii?Q?5TskS3hoZoJrnSh8ZBIMVhk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90487e1-e2c1-426b-6fc7-08d9f15cff14
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:59:57.2514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOXitx1vg/q+hRgX3mVll83mIQZk7okIaagsBJGF0sK8JSHEGNtppY6r5+EqYBHG1T7Jcg9DOFsrUXFWuElmCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5425
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160087
X-Proofpoint-GUID: UrCggHGU-j7CbZHsJbw9HBFbHkAbQIHt
X-Proofpoint-ORIG-GUID: UrCggHGU-j7CbZHsJbw9HBFbHkAbQIHt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 07:07, Allison Henderson wrote:
> Add an error tag on xfs_da3_split to test log attribute recovery
> and replay.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 4 ++++
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9dc1ecb9713d..aa74f3fdb571 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_errortag.h"
>  
>  /*
>   * xfs_da_btree.c
> @@ -482,6 +483,9 @@ xfs_da3_split(
>  
>  	trace_xfs_da_split(state->args);
>  
> +	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
> +		return -EIO;
> +
>  	/*
>  	 * Walk back up the tree splitting/inserting/adjusting as necessary.
>  	 * If we need to insert and there isn't room, split the node, then
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index c15d2340220c..6d06a502bbdf 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -60,7 +60,8 @@
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
> -#define XFS_ERRTAG_MAX					40
> +#define XFS_ERRTAG_DA_LEAF_SPLIT			40
> +#define XFS_ERRTAG_MAX					41
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -105,5 +106,6 @@
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
> +#define XFS_RANDOM_DA_LEAF_SPLIT			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 666f4837b1e1..2aa5d4d2b30a 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
> +	XFS_RANDOM_DA_LEAF_SPLIT,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
> +XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
> +	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(xfs_errortag);


-- 
chandan
