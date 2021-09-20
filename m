Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A0BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83EB060F25
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Sep 2021 10:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhITKM1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Sep 2021 06:12:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235683AbhITKM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Sep 2021 06:12:26 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KA718u008283;
        Mon, 20 Sep 2021 10:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zaMvu25blGHvb7X0XFK8JWCJoL356tHbAcvesszZMsw=;
 b=TNmR+DZA1raz63GdP+9zLGg+WMgGpZwg/YEnAAp5ZnTnL2Febc7GFYBed85Ce30J64nn
 cZlnPE5YiXaMTkvceadSINEJ7jSJYzYqu1MLK9P9ESl92hu4bOLgvBRlnigKEantEhrJ
 vOXidanSGudJLOh5kMHDdNT9FLscDFJRVG0koOJeddzf8bmRunEKrlMsyHHJzYX+grhl
 U58gPS4wLGdYEx39VkW7ldRuq0G3a1ex7LuHsT7RRGsccIc5RtPtbmGXWm+hlSVOLAvg
 NFRvAZuxhGx3N71Wndk4iOFQPee5xTWiB3I+RlSOBtbX7S8+VE6HvAdrkS2k3amtXu+B WQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zaMvu25blGHvb7X0XFK8JWCJoL356tHbAcvesszZMsw=;
 b=VROSP3BMy/f3aqCrqJID0LQasFMJ0Ze4XN1Q8JOuIoXggAaBIPqkLJ4VvUx2L2hfQPgK
 YB/htDjrm4XoG67oM8IS74q8kZ2HEQXu4s1J4ghD1l/BIGSSKcegtEZliSfDw0VfeTVN
 uKnI4UBPfb2VQ7tWU1jdF77Z+FPpBFLHxb2A3S6CCT9R28Sm3wqlUNR4xAxqzhG8p4/2
 J4D/YrvlW2KyUNGPzGcTItV/JA17JCymrj/7sYMd+rvJFc+lQFRLC1z7a85e6iK59vx2
 8mBBDvm21djZVRm+f0aAOC7SkQw+M/RtM+RQITxVfNPntJjFNIVl2JLVG4sOo6WIYXnt rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b66hnhscn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KAAjuB116189;
        Mon, 20 Sep 2021 10:10:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3b57x3tyha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 10:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6hgL8IsnOsNIDOrfiAxpoRPtfVXieX0tTGxNqEmrh6OCOaVtXF69SyTMp2S9u4v5RxnvHKzj6oCg+5WL+vJX6oXl4WBwQSuxf4FvLaA8rZN+n2hAxEgwW8cnqBt1IbgDTLQsXpAmsBvT6T/m+51KZGexRooLxPJVNoi2040O9p4o0oTrrAW9hrSwG5nJXtK4PkzDOg/3HyHh6vtJmvh7Sn/AgpfkpSTbzQAmFkAHG+RKs/Aw9rTjX3A0incobysFHzwPmJOf3K0baBoapldifJZbJoIfk1YKiCRoVPMNjKdQn4H62mtzbkE6fC0DNfmpS8ZNhic8Bjhnqh/Nrar7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zaMvu25blGHvb7X0XFK8JWCJoL356tHbAcvesszZMsw=;
 b=eEVgjZo4en7L80gq2a55qUWywgehUH6jT4qOZGkVmauQsLoBFS5pTil1h4AIWkZ0UHZ2lGnU1stjlZmnOHHecnRU/tvgvMth0LQjUwlPvrlFZVh7ud+Ne469lfGBBp+I9EgDmCUDo7ocNnANKpYPL2pcuv5m917twbCbM78T7qmrBVRRy0NmbnJGjsp5PHpR3gLmK1h2YzEVlNLP+txh619v68qh1CDa5fC9Z+cai59rEo21YzobVxTbgyLeJcmkiXg/1Hx6Qhvh4rcyyw3gxr2157tZMZgoyh2yfVB5ePjKnxuguLGW7NE0wqd7FSo3Jy0cUCGcISYZypPaf9OaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaMvu25blGHvb7X0XFK8JWCJoL356tHbAcvesszZMsw=;
 b=C34AkxVsT7ecULahPsP/XS5HCVV05d9L9SUQv2L1emDJxZhc1WTTBqp1FG3BSsCakNUD9YDpbnYbFuRVem3Dm7EfMV30eLkjLp9ckthr4hFuOe/eqUxT0IU9R7B2xQJR92QlNf7MLQivoM30DVl1vZYs2YEI2i0NzWK/wbpT4rQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4540.namprd10.prod.outlook.com (2603:10b6:806:110::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 10:10:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 10:10:56 +0000
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192859374.416199.6462613685926781959.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandanrlinux@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: refactor btree cursor allocation function
In-reply-to: <163192859374.416199.6462613685926781959.stgit@magnolia>
Message-ID: <87h7ef7ere.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 20 Sep 2021 15:25:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (223.182.249.90) by MA1PR01CA0164.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Mon, 20 Sep 2021 10:10:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f8066ee-0d10-489f-f2d2-08d97c1eef5a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4540:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4540ED8202A530404D01CDEFF6A09@SA2PR10MB4540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:111;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOtr7on5qkoiB0rVb0hXINjCgMIq3GJPpHW0jnT0i6BlonLvCIB1LpJzndYJoU8s8dUwCkMfMeijIrqHAZeO3LgHHtfv+t2ZqVXGVYCmbWA7lLKckiGmXhTS9uBnbm7J5c84a910V40WiRUrb4oNe45vTKSdh77HgekxKNpP3cSGWSyU3Ux4aiNMA6OaUzOi3xbBirfHRiXBdkMJd17ayA+Ji7/lt5K3Hsl7t+PzbCYCheL1R0PaaP+QXbmRt5ZuEdrR/aKO1N/VvGc4up7Ow4habTX8Vf8ASYPn3CUn37sKUtB0BuEOK3Tnl5bnoka4ALDWec1ujV2zd34PM7uSBZXVJIBhmBT+YYs1dG1fVVrswxjljLfREHWYuFszDOIFi8ejCfPxMVwobWA6ZORyVaxhquW9pmHcpnXbOA4eBeFPfnvwINE8D+ARQ1jFCPW9itp7drdjVRnVqp++sIbDnjgxYycbQhqZDjvSJl7Sc2fpxEz3Dv3HCSakeExExOfdB60ABJb4lTvkhKOIAEKI2YnyTcTBp1Z8vszV/9fVOqpre0mQyw2GDzW4d6mKXCqdZIcJr670uJ06h0TZXEicZNbDnTdKYempWlv/HfbeRMPNqAEBkJUb6x0A7NW1tZFm2Kga1B1Y+a4VSDNsUsZJTMwmkkW97Q3aWIWYxFINgm0Fiva1Vb5GuoNWydK2CxtE7rmNoC9yIV9cta5AjkqvKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(4326008)(33716001)(26005)(52116002)(53546011)(6916009)(86362001)(6496006)(38100700002)(8676002)(6486002)(508600001)(5660300002)(38350700002)(66946007)(956004)(186003)(66476007)(83380400001)(9686003)(66556008)(2906002)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y4Laj+vGZpt3BnZB5VMdQHugo6aVlDYpqqcduzA7odH6vTiPAD6S7Rl9l1z2?=
 =?us-ascii?Q?UW0u4k09FnIw+mxZsJ/yXyeYhht65ihd66UTcnqWLgsWYj1mkpckedrMvRo2?=
 =?us-ascii?Q?R8fNt1dFsRiWzZ35UWQkjqQXgIw7pRde3KPRcimZvKpvTSA1ixQMknXzY2Ug?=
 =?us-ascii?Q?IjNIUnS0ZCgyhB2GDrhUJml23HsdoNhVUe3Qdr9kFRT7XmeS2aLoen/jgWrd?=
 =?us-ascii?Q?ma7En9YPG5DmuSE/e9JFRNeXlPS823704N4MblqPSNtS0SSSuDYgspJ45X/+?=
 =?us-ascii?Q?2DvGaIS1Catf9NWRN1Z0TqAtqiHY/RgUQCM22pdR3RpI9yGUx6N9mgFIy9eH?=
 =?us-ascii?Q?MRdKIntnL35grXHJLeXxiaDJywR2CUY/9DPC+cQKeODbGhD+vrdcv35alosv?=
 =?us-ascii?Q?2eEoqSJoKyN1uKeRIYC8APJpL4Jk0zHBuy965rbsjVR33kfzI06Ndw/NLG6N?=
 =?us-ascii?Q?7DKdmv/DScM+J88OX0LcyeKJMoGmUYgfmX76TrWJ+QJA+qk+PhSyDxe4W4S4?=
 =?us-ascii?Q?Dwuo1qn9CDR0+FOs2Obabc7fSmz9vw5sfNMfSWr7+i3Jy8e6BRQCwIe3i41W?=
 =?us-ascii?Q?jKnbJkfq3YJ5W8m0FrtbEVBgRw+3yFNw95k1LkwMMcAONmGPyFvqB8hEjGxU?=
 =?us-ascii?Q?YJoMCsV9wvy97DZfmbfsAzhz+WGVxSe45BMePeNY9VI9YnWaJzaXK0qY7utH?=
 =?us-ascii?Q?JsZSgnn/A4oe8kOSzCZKEHpA7nufPByN3CzYbnPPrmT9sLXag+w0JnS3oHwE?=
 =?us-ascii?Q?T51mnMUc/heAx3vpqk2IZ0USSLv5gH0kfXbBpDmSm+kNrGtJ0jYYlekShze6?=
 =?us-ascii?Q?3HAUtVqNQICL9f1ALPeIe1e2j/67rbUQQgk+tt/Gu7cfVk8FtWPCNjonwhDR?=
 =?us-ascii?Q?Nfwrbmjo4bY/U0o6Qq4Zhs7j3DaGL0osHuXcFMRdLu4xhpwprgpjqHd70IYo?=
 =?us-ascii?Q?oiqh9XMdjaW2cUEh6fpzywuLDtN0OgV/wKKUem6WtscOYtwxCijn8FmNpAWR?=
 =?us-ascii?Q?Xry6vS2kkPN6ZpNZAPJgHqD94iBTHXwHBfb3GiaW8F8pjijLkmeml1IQe+Et?=
 =?us-ascii?Q?lrES3SabbYiYKFScJvNKI9EWAVHNoHuz4DOMm2Qoz0hRmIdmentj2WGttgb/?=
 =?us-ascii?Q?f2M+JBYzmptSZq5FJ0yneU/VvEL8fHOm4JLIVJqSeTrp+NmuqIrS2ooqz5ve?=
 =?us-ascii?Q?+fe/QfCKVVj5uAkXUAWa0nJ+k7Nx5EDuaFoky8/5j5js5Ll83NN97r6J9pwM?=
 =?us-ascii?Q?GEAb1GohmMYn4Yo9RRPCOsDzSlUf6MwDRxcL4N8N74a4TM3kcqJDI7OgBvgD?=
 =?us-ascii?Q?wCN5agT1LvLLmMHoF9L/V10M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8066ee-0d10-489f-f2d2-08d97c1eef5a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 10:10:55.9270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OiNM0bS2aWNOiCRYfQd27QI5BQy9tkx37SfKNWBqbSXoDnEF/SCDMivG/3Jqv+0884Nj4wp2/8xxMx5ExVGsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4540
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10112 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200063
X-Proofpoint-GUID: bEWV8oaVDLjiAyEgtU5K7ooDsikIWhbQ
X-Proofpoint-ORIG-GUID: bEWV8oaVDLjiAyEgtU5K7ooDsikIWhbQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18 Sep 2021 at 06:59, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Refactor btree allocation to a common helper.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    7 +------
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    7 +------
>  fs/xfs/libxfs/xfs_btree.c          |   18 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h          |    2 ++
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 +------
>  fs/xfs/libxfs/xfs_refcount_btree.c |    6 +-----
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    6 +-----
>  7 files changed, 25 insertions(+), 28 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6746fd735550..c644b11132f6 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -477,12 +477,7 @@ xfs_allocbt_init_common(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> -
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
> -	cur->bc_btnum = btnum;
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
>  	cur->bc_ag.abt.active = false;
>  
>  	if (btnum == XFS_BTNUM_CNT) {
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 72444b8b38a6..a06987e36db5 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -552,13 +552,8 @@ xfs_bmbt_init_cursor(
>  	struct xfs_btree_cur	*cur;
>  	ASSERT(whichfork != XFS_COW_FORK);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> -
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
> +	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
>  	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
> -	cur->bc_btnum = XFS_BTNUM_BMAP;
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
>  
>  	cur->bc_ops = &xfs_bmbt_ops;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 93fb50516bc2..70785004414e 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4926,3 +4926,21 @@ xfs_btree_has_more_records(
>  	else
>  		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
>  }
> +
> +/* Allocate a new btree cursor of the appropriate size. */
> +struct xfs_btree_cur *
> +xfs_btree_alloc_cursor(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_btnum_t		btnum)
> +{
> +	struct xfs_btree_cur	*cur;
> +
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur->bc_tp = tp;
> +	cur->bc_mp = mp;
> +	cur->bc_btnum = btnum;
> +	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +
> +	return cur;
> +}
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 827c44bf24dc..6540c4957c36 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -573,5 +573,7 @@ void xfs_btree_copy_ptrs(struct xfs_btree_cur *cur,
>  void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
>  		union xfs_btree_key *dst_key,
>  		const union xfs_btree_key *src_key, int numkeys);
> +struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
> +		struct xfs_trans *tp, xfs_btnum_t btnum);
>  
>  #endif	/* __XFS_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 27190840c5d8..c8fea6a464d5 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -432,10 +432,7 @@ xfs_inobt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
> -	cur->bc_btnum = btnum;
> +	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
>  	if (btnum == XFS_BTNUM_INO) {
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
>  		cur->bc_ops = &xfs_inobt_ops;
> @@ -444,8 +441,6 @@ xfs_inobt_init_common(
>  		cur->bc_ops = &xfs_finobt_ops;
>  	}
>  
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> -
>  	if (xfs_has_crc(mp))
>  		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
>  
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 1ef9b99962ab..48c45e31d897 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -322,11 +322,7 @@ xfs_refcountbt_init_common(
>  
>  	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
> -	cur->bc_btnum = XFS_BTNUM_REFC;
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
> +	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
>  
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index b7dbbfb3aeed..f3c4d0965cc9 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -451,13 +451,9 @@ xfs_rmapbt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> -	cur->bc_tp = tp;
> -	cur->bc_mp = mp;
>  	/* Overlapping btree; 2 keys per pointer. */
> -	cur->bc_btnum = XFS_BTNUM_RMAP;
> +	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
> -	cur->bc_blocklog = mp->m_sb.sb_blocklog;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
>  	cur->bc_ops = &xfs_rmapbt_ops;
>  


-- 
chandan
