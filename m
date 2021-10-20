Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3CFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2157611B0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJTKsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:48:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31794 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTKsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 06:48:25 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9te0t002151;
        Wed, 20 Oct 2021 10:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Mltc0EkIm4XJeeoGPv2tzZRcM0hDoBjw61s6mFK72JU=;
 b=yAEK3xwIql5HwLOrd2aMYxqBy1kYdBscKSQxUUcsCJxcKjliHjYgPypteW9f0B1Q/4dA
 l481nmzWvBffy2xFCqSfbD2cxEFUSmHbz2srZQ/jNTdnEvtntBMfQMa53A/eAbqr7FL8
 rjQFoExri2p+M/UL3BwTIb9yUNkp30DlQLCL4g2YnC7r4cKZNaCEeQu3bVSBPIpkWN/F
 9gsuX/vk574BmiNaj7Duq12Ur3tYTVdF0qE50G3rFiWGxL7mcngyponIWPfBBAV21kxE
 1IBt/Wg0kj2c8Vy2P0xxc9IwpT3NBNIhsmS+YBhzMXXg+Qz3laXGC8SRTGb9P18FGdPO NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsnjhyr15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KAjZnR030538;
        Wed, 20 Oct 2021 10:46:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3br8gtx8yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bibkwevAnwT/cqqoO7uvbeQ8A/+NcQb/bODXIIU2k/+df3A5XaMts+gKhk0pA5BMpWRet27T1+KIHclCD5YWbQ9Qp/o3xvO6MrBjMDIrZh7wvRGDjQUv9GHuksAdjo9N6mM55zVyNcetPT3xs3XM3+D+WXjYizqkKyUp0CewdnjhEvHIJUh2hah0VTUAjO2RXKWBOPVOwPvkUolayugWw9AWb5mnw+ITSUCDBWq+QupermHsCvFhihnrKbXaiMFW5/+jOljZJlzdPmjN0lZpRZ/0HcpS3OmtfrMtc9p0pp6RMn1PJvYDhtGEr5gUEs+Uq7SIUnmYQm/dzcOJloIUBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mltc0EkIm4XJeeoGPv2tzZRcM0hDoBjw61s6mFK72JU=;
 b=njSHzSn2fJ35gqAxiyLpPILl0FJ8/X3MLg8bQG/mWXiDqBcsmCg5XTEH+YMc58zWqCqpOS1YG4xHH1+YxeeSjzUPHY1NPNJhFEgsIdoA5m44Yw57BYwrzKnWYVrIXeya0v6kgjubRlpZNcYYN/ECmRy+2tidFQ9cDzda/sSRkp/80TxKAkHbllKQbYOWZTy5uP/BahX03z8+lYlXWfgZw+2Az3votvqyEk+Va98mLYziCtkoTD0rr62MMU3w6I+AYzj1Lir/RZ59fZkX1Vja9h3HOM/oh2Ge6azIpE6CV6DSuCwvXR/sSQ+Xmvd+V3k+8K+7KJT8aDJGqNlInnh/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mltc0EkIm4XJeeoGPv2tzZRcM0hDoBjw61s6mFK72JU=;
 b=EguHuBnwdCoSVYoUxb/6SFCMOHKhiXYUHihsErzA/2/ERXTVNxlaR+JUnU2aKzwu1r+MJP3EBKIl26lrkFIGeqwSIuuKxu4rtq6Yka9xJguIsg9VK95Fz6h19Eb1SydOMWDGtlLW2R5JZTPEOP5MPhfjvK25NIlvzDelZeWuwyQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 10:46:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:46:06 +0000
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466954368.2235671.8432324789208917382.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rename xfs_bmap_add_free to xfs_free_extent_later
In-reply-to: <163466954368.2235671.8432324789208917382.stgit@magnolia>
Message-ID: <871r4ght3x.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 20 Oct 2021 16:15:54 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by SI2PR02CA0015.apcprd02.prod.outlook.com (2603:1096:4:194::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 10:46:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3172630b-f1ec-4adc-2148-08d993b6d165
X-MS-TrafficTypeDiagnostic: SA2PR10MB4731:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4731E020322FF5A2858F86B1F6BE9@SA2PR10MB4731.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LAlRt81e3jiZ6uIs0IOTH3U3rUwannab7CQc556xOQzKq//bvqhKe/1mWDWFoldUKke3JbpERE0wi4jWjgUu3guMVoKdX1Ynpvcup+7Nxzccwj++WEG4i/6hWHITVPgLyuu6chca5hik4Y1ggiDj8eTLzTH1nFc4AEQNpxVKZIWHMjDrJpU10pIn+wOlAUpxL4LzVZxpn6gBG+cZ2vbcLY4cVjFMGz9wAFJOOIQhlQoieGUFDHh0TSS9XdKaNWIZA0Vv7M86bjDX4BgfQbIZihFlX5mbDM2s++oG5fGbWZWqhKSVCYO5dWh0C2ud21jGGARnJyhtJIoJqnedfJvCwAyVW2/LsKKiC6zkChvo/j4s2rOulqvoQmehR1LkYPZXGLCpGnkBiKCvIgXeRjYgzrEdFVR3bOchUPPkzk21prSrBaiHhONtCqXwxTyAiDq/5HDf2R7OvPb+ckY5TgTragpqmoeswv2GOFmC98NqnmvBVGhWVx1Jufq43ME5OBgKqyunq1GCq5BndJsI4NM/k6cEKUApQDopstVGKtKNAH1AKx7yDW0KhAN3okZ3JRKYCcp2iFGfHh/UoWbY0COJUpt1GDlWiKjj8Mztm8csn73LG7rtTVKu4iDytCTBGEGMfQYRc7xH8QYBG96Gsvc9G1806jQ9LlD+m5SItUB8sPisCuxIVWXUg9FODoO8020U2I/gU0dP+y9n6HZ7tXiLsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(2906002)(30864003)(8676002)(6496006)(66476007)(66556008)(4326008)(83380400001)(5660300002)(52116002)(6666004)(66946007)(6916009)(38350700002)(38100700002)(26005)(33716001)(6486002)(186003)(53546011)(956004)(86362001)(9686003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d6Ox/oKAvccWRNH3P15ClTbhmEb5HUpg/PGO+ufdyb6iUDMPJy8yBvTF35DF?=
 =?us-ascii?Q?krI5BGNNW5AHL8ZIBbfD9CE0Fu8X8QtAnCjeUVqq7ppfIwJBf8XreGI9q181?=
 =?us-ascii?Q?2tWMOdg3TlfwcQuecVafLA29W5NoVtvxN6JtleudXzFcFkiFKvZQoV6F9DHm?=
 =?us-ascii?Q?ny/L/Cpjlf/FZNN/mIRsxPgXiogIpa7iV9AwNnV8WcucdCv/pWE2t1gJKsFi?=
 =?us-ascii?Q?SQUz7ZZvmm/7K7A/bSJcWjuBE0eXk2f6hjNMXt+Q2dqyn5vc4vYt182sDuQp?=
 =?us-ascii?Q?ocaKEZCfpa7PlZoiJWNyGk69choZaOlMsHXGb8NZAnk1g/XLGIQcEstu2Muc?=
 =?us-ascii?Q?MXqevO4On6dYpUa9IKAJHxuvrvTOBQ1WX9WLOAKS9Bx/Hpj7HPA2soW4l8XR?=
 =?us-ascii?Q?dC0C8dQnx9uP/2eDlrBUocnZfLj5dXEJndIA9DVqCrX+CZc7GhjEGIoBkWED?=
 =?us-ascii?Q?T7Mba0XS0Nwdxbx9FEYMCOoUNdP7uyNvqTQ4bNb9ltQd0PYRe8q4IPf2X5CX?=
 =?us-ascii?Q?3t39IOd075TO+R7MjOA00jeVeEtCwmGrke4pTkcHi9lTD2g8gmxcGbeBPoBW?=
 =?us-ascii?Q?yw3Lhyg2eSlKGnyjyrhStVAn+DSNwjb9sJdOfn3gsM5goKpVlcUNrtFPu4ey?=
 =?us-ascii?Q?y0H9af0C31GjlgBtstcwbY1ehZam5KXzSR95SgKIgN4sZySUV1qz1ebt7Jz/?=
 =?us-ascii?Q?bmDs6+0wJMkeq324Zc6RGW6hKa0tDUQb3sRlyJSxUPpHP5U5XUHxsMcokUV7?=
 =?us-ascii?Q?6xk0Ca5t171x2mBidfB0/By/84KMfm70VR2IRt69ZF0yNQJsM7VOyU64i/mr?=
 =?us-ascii?Q?olIKENVgBSHcq0S3hGlOZe9SLX6PSuiVUpr0b2VzbURe2wKaqLkzBkbszJCf?=
 =?us-ascii?Q?Qpl8+07RYEqbnbOeFNMeGJLkbExnd4IrB4reOHOoczgLld0dzhheL351Bu2Y?=
 =?us-ascii?Q?efXupbzTzvIVGSIvZC+AFkzTmQvD9F+siZ2ulDvl8zm0MHtKQ4G9u45IdFdi?=
 =?us-ascii?Q?dFER3ecTx3G/T6gisjj3Rtp0IJTPyCW/Yq/P2ynu0+O5nMIUApL67vKOs3Hv?=
 =?us-ascii?Q?tVyQf1DOdYflbVit5vB+ui8KXeltbhMaUus/Y1PinQVqceEBzLtzOYvSs5mZ?=
 =?us-ascii?Q?EH6br8PpizWud/cG6pY8zQsEzWnSyWMoBzw3Zk6DlwZcdfdT73oR/wyelOiL?=
 =?us-ascii?Q?5DMZlOTwtYu5MuRJOCZA6DaPInQqHT7vD5eYX6r6ATz4oWV+x7FXlM7Rw7Sr?=
 =?us-ascii?Q?DX7VDhyhrgNjWVfL6CerOFGBgfp0EF4ZwZmegGZtVbTTU2F/75fD39wsheSb?=
 =?us-ascii?Q?SXjLDSEgUvKqDk3v1mOQFqN7kpdqt4momIDDm+ylB05O68hIqEQkxcrvHM0u?=
 =?us-ascii?Q?ZEuDYELsEuDd4+VxIBjrTCzuNBLvKh/nZQ6jEoMKPcxlSStsY2k9KYS/pd91?=
 =?us-ascii?Q?zZxmmSwAPIpEvxbppzcXPkUN8L5svOebbvtH7gUMTYWIzg/POKk7oFXczuBY?=
 =?us-ascii?Q?TJNOdPyDMZfJVQ+31bkOun5UgLuPASShQtwmFhDQJjcSNEVWS8zzCp4oPWcL?=
 =?us-ascii?Q?ATdVIMY/W0WJNe+ALXR8scNgYRS1Dm33fcpoA2CV30wXVWLyicP8jdE+/jry?=
 =?us-ascii?Q?/uQK1PZ6LTQsIpLTcmF8gYs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3172630b-f1ec-4adc-2148-08d993b6d165
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:46:06.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n82rB1pz8/OdgmK3yoHpK9wjiKSuDH7J6bF+GZGcvwVvGqEhLB+0TxzT+D7Vz0XR1qYw0oJz7KEnFKktV4y7KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200061
X-Proofpoint-ORIG-GUID: Wg3-uzRHNO4Ep3IjYp_90Q_4ZURbyxF2
X-Proofpoint-GUID: Wg3-uzRHNO4Ep3IjYp_90Q_4ZURbyxF2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> xfs_bmap_add_free isn't a block mapping function; it schedules deferred
> freeing operations for a later point in a compound transaction chain.
> While it's primarily used by bunmapi, its use has expanded beyond that.
> Move it to xfs_alloc.c and rename the function since it's now general
> freeing functionality.  Bring the slab cache bits in line with the
> way we handle the other intent items.

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c         |    2 +
>  fs/xfs/libxfs/xfs_alloc.c      |   71 ++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_alloc.h      |   32 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_bmap.c       |   55 +------------------------------
>  fs/xfs/libxfs/xfs_bmap.h       |   28 ----------------
>  fs/xfs/libxfs/xfs_bmap_btree.c |    2 +
>  fs/xfs/libxfs/xfs_defer.c      |    5 +++
>  fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
>  fs/xfs/libxfs/xfs_refcount.c   |    6 ++-
>  fs/xfs/xfs_extfree_item.c      |    6 ++-
>  fs/xfs/xfs_reflink.c           |    2 +
>  fs/xfs/xfs_super.c             |   11 +-----
>  12 files changed, 118 insertions(+), 106 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 005abfd9fd34..d7d875cef07a 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -850,7 +850,7 @@ xfs_ag_shrink_space(
>  		if (err2 != -ENOSPC)
>  			goto resv_err;
>  
> -		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
> +		__xfs_free_extent_later(*tpp, args.fsbno, delta, NULL, true);
>  
>  		/*
>  		 * Roll the transaction before trying to re-init the per-ag
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ccfe66df3e62..9bc1a03a8167 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -27,7 +27,7 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
>  
> -extern struct kmem_cache	*xfs_bmap_free_item_cache;
> +struct kmem_cache	*xfs_extfree_item_cache;
>  
>  struct workqueue_struct *xfs_alloc_wq;
>  
> @@ -2440,7 +2440,7 @@ xfs_agfl_reset(
>  
>  /*
>   * Defer an AGFL block free. This is effectively equivalent to
> - * xfs_bmap_add_free() with some special handling particular to AGFL blocks.
> + * xfs_free_extent_later() with some special handling particular to AGFL blocks.
>   *
>   * Deferring AGFL frees helps prevent log reservation overruns due to too many
>   * allocation operations in a transaction. AGFL frees are prone to this problem
> @@ -2459,10 +2459,10 @@ xfs_defer_agfl_block(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_extent_free_item	*new;		/* new element */
>  
> -	ASSERT(xfs_bmap_free_item_cache != NULL);
> +	ASSERT(xfs_extfree_item_cache != NULL);
>  	ASSERT(oinfo != NULL);
>  
> -	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
> +	new = kmem_cache_alloc(xfs_extfree_item_cache,
>  			       GFP_KERNEL | __GFP_NOFAIL);
>  	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
>  	new->xefi_blockcount = 1;
> @@ -2474,6 +2474,52 @@ xfs_defer_agfl_block(
>  	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>  }
>  
> +/*
> + * Add the extent to the list of extents to be free at transaction end.
> + * The list is maintained sorted (by block number).
> + */
> +void
> +__xfs_free_extent_later(
> +	struct xfs_trans		*tp,
> +	xfs_fsblock_t			bno,
> +	xfs_filblks_t			len,
> +	const struct xfs_owner_info	*oinfo,
> +	bool				skip_discard)
> +{
> +	struct xfs_extent_free_item	*new;		/* new element */
> +#ifdef DEBUG
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +
> +	ASSERT(bno != NULLFSBLOCK);
> +	ASSERT(len > 0);
> +	ASSERT(len <= MAXEXTLEN);
> +	ASSERT(!isnullstartblock(bno));
> +	agno = XFS_FSB_TO_AGNO(mp, bno);
> +	agbno = XFS_FSB_TO_AGBNO(mp, bno);
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(agbno < mp->m_sb.sb_agblocks);
> +	ASSERT(len < mp->m_sb.sb_agblocks);
> +	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
> +#endif
> +	ASSERT(xfs_extfree_item_cache != NULL);
> +
> +	new = kmem_cache_alloc(xfs_extfree_item_cache,
> +			       GFP_KERNEL | __GFP_NOFAIL);
> +	new->xefi_startblock = bno;
> +	new->xefi_blockcount = (xfs_extlen_t)len;
> +	if (oinfo)
> +		new->xefi_oinfo = *oinfo;
> +	else
> +		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> +	new->xefi_skip_discard = skip_discard;
> +	trace_xfs_bmap_free_defer(tp->t_mountp,
> +			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
> +			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> +}
> +
>  #ifdef DEBUG
>  /*
>   * Check if an AGF has a free extent record whose length is equal to
> @@ -3499,3 +3545,20 @@ xfs_agfl_walk(
>  
>  	return 0;
>  }
> +
> +int __init
> +xfs_extfree_intent_init_cache(void)
> +{
> +	xfs_extfree_item_cache = kmem_cache_create("xfs_extfree_intent",
> +			sizeof(struct xfs_extent_free_item),
> +			0, 0, NULL);
> +
> +	return xfs_extfree_item_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_extfree_intent_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_extfree_item_cache);
> +	xfs_extfree_item_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 2f3f8c2e0860..b61aeb6fbe32 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -248,4 +248,36 @@ xfs_buf_to_agfl_bno(
>  	return bp->b_addr;
>  }
>  
> +void __xfs_free_extent_later(struct xfs_trans *tp, xfs_fsblock_t bno,
> +		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
> +		bool skip_discard);
> +
> +/*
> + * List of extents to be free "later".
> + * The list is kept sorted on xbf_startblock.
> + */
> +struct xfs_extent_free_item {
> +	struct list_head	xefi_list;
> +	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
> +	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> +	bool			xefi_skip_discard;
> +	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
> +};
> +
> +static inline void
> +xfs_free_extent_later(
> +	struct xfs_trans		*tp,
> +	xfs_fsblock_t			bno,
> +	xfs_filblks_t			len,
> +	const struct xfs_owner_info	*oinfo)
> +{
> +	__xfs_free_extent_later(tp, bno, len, oinfo, false);
> +}
> +
> +
> +extern struct kmem_cache	*xfs_extfree_item_cache;
> +
> +int __init xfs_extfree_intent_init_cache(void);
> +void xfs_extfree_intent_destroy_cache(void);
> +
>  #endif	/* __XFS_ALLOC_H__ */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ef2ac0ecaed9..4dccd4d90622 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -38,7 +38,6 @@
>  #include "xfs_iomap.h"
>  
>  struct kmem_cache		*xfs_bmap_intent_cache;
> -struct kmem_cache		*xfs_bmap_free_item_cache;
>  
>  /*
>   * Miscellaneous helper functions
> @@ -522,56 +521,6 @@ xfs_bmap_validate_ret(
>  #define	xfs_bmap_validate_ret(bno,len,flags,mval,onmap,nmap)	do { } while (0)
>  #endif /* DEBUG */
>  
> -/*
> - * bmap free list manipulation functions
> - */
> -
> -/*
> - * Add the extent to the list of extents to be free at transaction end.
> - * The list is maintained sorted (by block number).
> - */
> -void
> -__xfs_bmap_add_free(
> -	struct xfs_trans		*tp,
> -	xfs_fsblock_t			bno,
> -	xfs_filblks_t			len,
> -	const struct xfs_owner_info	*oinfo,
> -	bool				skip_discard)
> -{
> -	struct xfs_extent_free_item	*new;		/* new element */
> -#ifdef DEBUG
> -	struct xfs_mount		*mp = tp->t_mountp;
> -	xfs_agnumber_t			agno;
> -	xfs_agblock_t			agbno;
> -
> -	ASSERT(bno != NULLFSBLOCK);
> -	ASSERT(len > 0);
> -	ASSERT(len <= MAXEXTLEN);
> -	ASSERT(!isnullstartblock(bno));
> -	agno = XFS_FSB_TO_AGNO(mp, bno);
> -	agbno = XFS_FSB_TO_AGBNO(mp, bno);
> -	ASSERT(agno < mp->m_sb.sb_agcount);
> -	ASSERT(agbno < mp->m_sb.sb_agblocks);
> -	ASSERT(len < mp->m_sb.sb_agblocks);
> -	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
> -#endif
> -	ASSERT(xfs_bmap_free_item_cache != NULL);
> -
> -	new = kmem_cache_alloc(xfs_bmap_free_item_cache,
> -			       GFP_KERNEL | __GFP_NOFAIL);
> -	new->xefi_startblock = bno;
> -	new->xefi_blockcount = (xfs_extlen_t)len;
> -	if (oinfo)
> -		new->xefi_oinfo = *oinfo;
> -	else
> -		new->xefi_oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> -	new->xefi_skip_discard = skip_discard;
> -	trace_xfs_bmap_free_defer(tp->t_mountp,
> -			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
> -			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
> -	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
> -}
> -
>  /*
>   * Inode fork format manipulation functions
>   */
> @@ -626,7 +575,7 @@ xfs_bmap_btree_to_extents(
>  	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
>  		return error;
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
> -	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
> +	xfs_free_extent_later(cur->bc_tp, cbno, 1, &oinfo);
>  	ip->i_nblocks--;
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
>  	xfs_trans_binval(tp, cbp);
> @@ -5297,7 +5246,7 @@ xfs_bmap_del_extent_real(
>  		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
>  			xfs_refcount_decrease_extent(tp, del);
>  		} else {
> -			__xfs_bmap_add_free(tp, del->br_startblock,
> +			__xfs_free_extent_later(tp, del->br_startblock,
>  					del->br_blockcount, NULL,
>  					(bflags & XFS_BMAPI_NODISCARD) ||
>  					del->br_state == XFS_EXT_UNWRITTEN);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index fa73a56827b1..03d9aaf87413 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -13,8 +13,6 @@ struct xfs_inode;
>  struct xfs_mount;
>  struct xfs_trans;
>  
> -extern struct kmem_cache	*xfs_bmap_free_item_cache;
> -
>  /*
>   * Argument structure for xfs_bmap_alloc.
>   */
> @@ -44,19 +42,6 @@ struct xfs_bmalloca {
>  	int			flags;
>  };
>  
> -/*
> - * List of extents to be free "later".
> - * The list is kept sorted on xbf_startblock.
> - */
> -struct xfs_extent_free_item
> -{
> -	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
> -	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> -	bool			xefi_skip_discard;
> -	struct list_head	xefi_list;
> -	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
> -};
> -
>  #define	XFS_BMAP_MAX_NMAP	4
>  
>  /*
> @@ -189,9 +174,6 @@ unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int whichfork);
> -void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
> -		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
> -		bool skip_discard);
>  void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
>  int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
>  		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
> @@ -239,16 +221,6 @@ int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
>  		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
>  		struct xfs_bmbt_irec *new, int *logflagsp);
>  
> -static inline void
> -xfs_bmap_add_free(
> -	struct xfs_trans		*tp,
> -	xfs_fsblock_t			bno,
> -	xfs_filblks_t			len,
> -	const struct xfs_owner_info	*oinfo)
> -{
> -	__xfs_bmap_add_free(tp, bno, len, oinfo, false);
> -}
> -
>  enum xfs_bmap_intent_type {
>  	XFS_BMAP_MAP = 1,
>  	XFS_BMAP_UNMAP,
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 3c9a45233e60..453309fc85f2 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -288,7 +288,7 @@ xfs_bmbt_free_block(
>  	struct xfs_owner_info	oinfo;
>  
>  	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
> -	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
> +	xfs_free_extent_later(cur->bc_tp, fsbno, 1, &oinfo);
>  	ip->i_nblocks--;
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 641a5dee4ffc..3c43e5c93e7b 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -21,6 +21,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
>  #include "xfs_bmap.h"
> +#include "xfs_alloc.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
>  
> @@ -848,6 +849,9 @@ xfs_defer_init_item_caches(void)
>  	if (error)
>  		return error;
>  	error = xfs_bmap_intent_init_cache();
> +	if (error)
> +		return error;
> +	error = xfs_extfree_intent_init_cache();
>  	if (error)
>  		return error;
>  
> @@ -858,6 +862,7 @@ xfs_defer_init_item_caches(void)
>  void
>  xfs_defer_destroy_item_caches(void)
>  {
> +	xfs_extfree_intent_destroy_cache();
>  	xfs_bmap_intent_destroy_cache();
>  	xfs_refcount_intent_destroy_cache();
>  	xfs_rmap_intent_destroy_cache();
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f78a600ca73f..b418fe0c0679 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1827,7 +1827,7 @@ xfs_difree_inode_chunk(
>  
>  	if (!xfs_inobt_issparse(rec->ir_holemask)) {
>  		/* not sparse, calculate extent info directly */
> -		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
> +		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, sagbno),
>  				  M_IGEO(mp)->ialloc_blks,
>  				  &XFS_RMAP_OINFO_INODES);
>  		return;
> @@ -1872,7 +1872,7 @@ xfs_difree_inode_chunk(
>  
>  		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
>  		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
> -		xfs_bmap_add_free(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
> +		xfs_free_extent_later(tp, XFS_AGB_TO_FSB(mp, agno, agbno),
>  				  contigblk, &XFS_RMAP_OINFO_INODES);
>  
>  		/* reset range to current bit and carry on... */
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 2c03df715d4f..bb9e256f4970 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -976,7 +976,7 @@ xfs_refcount_adjust_extents(
>  				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  						cur->bc_ag.pag->pag_agno,
>  						tmp.rc_startblock);
> -				xfs_bmap_add_free(cur->bc_tp, fsbno,
> +				xfs_free_extent_later(cur->bc_tp, fsbno,
>  						  tmp.rc_blockcount, oinfo);
>  			}
>  
> @@ -1021,7 +1021,7 @@ xfs_refcount_adjust_extents(
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  					cur->bc_ag.pag->pag_agno,
>  					ext.rc_startblock);
> -			xfs_bmap_add_free(cur->bc_tp, fsbno, ext.rc_blockcount,
> +			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
>  					  oinfo);
>  		}
>  
> @@ -1744,7 +1744,7 @@ xfs_refcount_recover_cow_leftovers(
>  				rr->rr_rrec.rc_blockcount);
>  
>  		/* Free the block. */
> -		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
> +		xfs_free_extent_later(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
>  
>  		error = xfs_trans_commit(tp);
>  		if (error)
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 26ac5048ce76..eb378e345f13 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
>  			free->xefi_startblock,
>  			free->xefi_blockcount,
>  			&free->xefi_oinfo, free->xefi_skip_discard);
> -	kmem_cache_free(xfs_bmap_free_item_cache, free);
> +	kmem_cache_free(xfs_extfree_item_cache, free);
>  	return error;
>  }
>  
> @@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
>  	struct xfs_extent_free_item	*free;
>  
>  	free = container_of(item, struct xfs_extent_free_item, xefi_list);
> -	kmem_cache_free(xfs_bmap_free_item_cache, free);
> +	kmem_cache_free(xfs_extfree_item_cache, free);
>  }
>  
>  const struct xfs_defer_op_type xfs_extent_free_defer_type = {
> @@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
>  	extp->ext_len = free->xefi_blockcount;
>  	efdp->efd_next_extent++;
>  
> -	kmem_cache_free(xfs_bmap_free_item_cache, free);
> +	kmem_cache_free(xfs_extfree_item_cache, free);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 76355f293488..cb0edb1d68ef 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -484,7 +484,7 @@ xfs_reflink_cancel_cow_blocks(
>  			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
>  					del.br_blockcount);
>  
> -			xfs_bmap_add_free(*tpp, del.br_startblock,
> +			xfs_free_extent_later(*tpp, del.br_startblock,
>  					  del.br_blockcount, NULL);
>  
>  			/* Roll the transaction */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8909e08cbf77..daa6d76b8dd0 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1963,15 +1963,9 @@ xfs_init_caches(void)
>  	if (!xfs_log_ticket_cache)
>  		goto out;
>  
> -	xfs_bmap_free_item_cache = kmem_cache_create("xfs_bmap_free_item",
> -					sizeof(struct xfs_extent_free_item),
> -					0, 0, NULL);
> -	if (!xfs_bmap_free_item_cache)
> -		goto out_destroy_log_ticket_cache;
> -
>  	error = xfs_btree_init_cur_caches();
>  	if (error)
> -		goto out_destroy_bmap_free_item_cache;
> +		goto out_destroy_log_ticket_cache;
>  
>  	error = xfs_defer_init_item_caches();
>  	if (error)
> @@ -2115,8 +2109,6 @@ xfs_init_caches(void)
>  	xfs_defer_destroy_item_caches();
>   out_destroy_btree_cur_cache:
>  	xfs_btree_destroy_cur_caches();
> - out_destroy_bmap_free_item_cache:
> -	kmem_cache_destroy(xfs_bmap_free_item_cache);
>   out_destroy_log_ticket_cache:
>  	kmem_cache_destroy(xfs_log_ticket_cache);
>   out:
> @@ -2148,7 +2140,6 @@ xfs_destroy_caches(void)
>  	kmem_cache_destroy(xfs_da_state_cache);
>  	xfs_btree_destroy_cur_caches();
>  	xfs_defer_destroy_item_caches();
> -	kmem_cache_destroy(xfs_bmap_free_item_cache);
>  	kmem_cache_destroy(xfs_log_ticket_cache);
>  }
>  


-- 
chandan
