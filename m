Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DD7C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 15:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiBPPAy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:00:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiBPPAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 10:00:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AF61F6B9E
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 07:00:40 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GEiMKj030414
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=He+l9pyCGBtHzk22QqNPQUKJYXXcJcpOBMZvLCaZTvw=;
 b=zUKRt32EI40biVvP6UUf9Di+iuTm8Fz61Kf9QkWeZ/rCr1pKEFDXDtd/iOzr7CjeVScP
 kNfZt4zDsYFFn0gEMXLaj5Mx9JhJ+MHYhVzddFKsjFEDLO2bgp06nDG8JCfD1FAJfuAF
 VEJnIOV5zlxmlDd7F7IsAtLWsR1SshPhZDGmUQOMbelW4GPFpIeG9bodbhr7jwgoKBlQ
 85S0uriKbl6c/d0o30oCK2Qg2wqmuDKkhjoIEKMaX0noQtiCfeoxzg5qgS+XZKW7jZ0g
 SHOJ0/k13v2W2ZuN/pxfMVG0R0kE4FqeuoZEKrAJLjwX2JDiWT2KbPo31iUPiewc+GNy 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3j7ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GF0XRK105317
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 3e8ns9482m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 15:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijVDUZXx6yjrZxNBaHTi4YdTjJAdsUIarfOmxWQayUU0DO6I+3H1C9VNGU92NsqnqsaY3dnWFQNlOszwQ8L4Wvc9Dz1teiN8VhO5+OJV5dA8gaZdMTXoIkDpFSEwrXKNYYMsZHh99k+/xBUvYJEN5Km+h2y6XMUd8RdKlb3sgcB9b4ZtarLgFNEs0yA/i2mQLlbz/UZid1KjEgFQhp2uowC1ewFCogVxkQXC1TAxqzQsR4ob30/YhJDIyPXg1wYHi3k85lSbZfSB8rzdSrRRQWXGRvorx8yu86xBwL2nywTetLaQnOPbI5ku3FbXijjHtH3hwY0OjMg+FRRzAOi/Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=He+l9pyCGBtHzk22QqNPQUKJYXXcJcpOBMZvLCaZTvw=;
 b=gk4UEnymkaPSliJGqf0nOi0PV3yHwnOthdhq5D5+nPkfdNIkJLz9gQYmCWgIEaEpkPzjiLOdGqWTVk6HfXC9NIE2wW2wGJ69bV/T0ZQDitrRbfJRFlYRePhobV7spOkg7y/3g0nLnVwZ75b1zj8pWCwf3iVAJR5Pj16xyk5LDab4es8RC3qccspFaQY7NFLeYMTMio7GQVLdzTVQ49DPiJRO+vXATCPYhxbQ47azzgdvcZyi20zKj8iyhI69Dew3pPWk7bp+/4wC6GqKRCtsewa8kYEbAd1+CuMrryk5kAKroz75jWMT66UadjFM1lxg1alkE1kp/2kActCgctV02w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=He+l9pyCGBtHzk22QqNPQUKJYXXcJcpOBMZvLCaZTvw=;
 b=TR8JERop5C9eQGqTHTPv8eiV8pOHFYwRCazOpJ9HzHMB+ticsDi+yhk4GvZk1D/hR/uabib4QDUqqSZOUGKw7TwoyeB7upVh9jsQpw0MB6noDce4c9t8YRsWNH7Bjus4SvdqwT/s8gerFQLCwVW457Y2+f+uJwpHX5+zn+8PPkI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Wed, 16 Feb
 2022 15:00:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 15:00:25 +0000
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-16-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 15/15] xfs: add leaf to node error tag
In-reply-to: <20220216013713.1191082-16-allison.henderson@oracle.com>
Message-ID: <87a6eqj1q6.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 20:30:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37911b40-605f-45d8-1504-08d9f15d0ffc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517077198437ADE5DA45CAAF6359@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIf/6QD3Zn44gU3r7RPzZsh+TLLRoizxKFT8LV37TTul7VkEGl/OSj3VRsTLszI+oVuuoAjEDL5LeL29FyZF11gKXPIt08zOpN6oaIloB9nVkWhMh+dAyro3GhPaERWCsJUcyxFiklvXDwmU22wp6xWLm21AnCMvK7+ubVOQKB1do+1mAUebUzjo3mJ2d7eZoF/vWVjnUT7fU5sbVDy9q8T2MWBWQAn/jBghMs8Nv2LgRb1z5Tk9VuqVo7oU/D8ifCxcEFMMj5e6DP7OozLnoJjtoEztMcemw385dBWsAcKeEFHphnDkIoiYXF0lZRxL6u+uA7Uxm2EUYeD9/SagF8Ood6qAMqSM+AupR1fTrFnxv7xjVXRu6VILBtheRbssTlzMNROBB4oEl5ru39MHISRvGFuSb4x6BQ5/Bl5V49O2nkSjt7i6L9llXTAtszadTNKss2hT/2FK/1ClWdk3iX5fk5EHNS3qUvlSccRXmUlbPutCzks1LLyf2DwumC3XwLqthMxHcvN07WVh9OTpO46GkTIl0+tuT9OqhBUdWmYYvdJO5qPrd6BhhFJMQOjVZN5yvbjfui85tMfeUqWRcWiKAEYjXIaMdKzQTN6GHjD4onRKAZtqvUO5KNoMn/45o5z4NHZjCnhw1d9/ltz4I+XIRsKf9q6iBK8dYJ5zyr6Src55YaB10JJcboyICZYOnaG5DsSGBBqptaWypNFbKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(52116002)(8676002)(66476007)(66946007)(66556008)(53546011)(6512007)(38100700002)(6666004)(33716001)(186003)(38350700002)(316002)(26005)(6636002)(9686003)(6862004)(8936002)(6486002)(508600001)(5660300002)(86362001)(2906002)(83380400001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R4kvsuaV473wLzZZgVZ0/ZIUbFisDHMrsQ+NGNALmGBz54KLdXQUHwUcSp5h?=
 =?us-ascii?Q?MGHTkOdI9RtQi5TXk9B0N6dc+pryURmeEjVRfqc0C/kZoLzwLRgeoMgzEmAK?=
 =?us-ascii?Q?Tad6Y3wRct9tASE9+fEXR1/HffYe5UF8qDNNm65y852yPJkNgwnB9t2W91jF?=
 =?us-ascii?Q?3Mq403yI8nq8wE0R13ii/AUUMAAJyr/Ms3WmEkNy7+lCcOxP7I1GsByrdFLw?=
 =?us-ascii?Q?65M6WO19GpiajBYRQghZmyf6MqOnfbWEWcjbaqaWQIDyNh7UKU5czAeJ5z2N?=
 =?us-ascii?Q?SJbg7BUsixj98YShfFl3TsqNiIMy0uy/ZjJVcxwySXHfFmj3VTxu68rnOQhg?=
 =?us-ascii?Q?hK5yw43iVfvw0ZGWHbo5+KjiVDhXotOrAhudZv1Ac4eKt4XOW/dUbc/QDl4r?=
 =?us-ascii?Q?eKVavJBLOViKDvWL7lq/K7ownWvIdEl8lyzAro7ZVxs8PM0QUjexnhq1ouId?=
 =?us-ascii?Q?Khv5F/Aa5/8HWkhk9OqbkA4BhRPT0msGjAujLe+DR7e/MPUkjiy2f1Ah501O?=
 =?us-ascii?Q?gEvWPe13H82brtb/lWLaEIXqreIBFXEaEyKzlIOrwSUDdHl1mJ3GXL1IRa18?=
 =?us-ascii?Q?mHkJ5Z9sARLJQKQ33qtJ0hYqWhR/owmF9z1+O5mvl5Hp7TKdP7iZp+KH4Xz8?=
 =?us-ascii?Q?soFk/iE6HqMGzH5tlMWkOj7xILIn2ozHf1rjqaxfk7cfsyIi9pWFofSmm0Um?=
 =?us-ascii?Q?mvqZ+URmrfQQpXEH4FzwysSaU+0998+x4IlidxB88RBWx6as2ULajacQhRZn?=
 =?us-ascii?Q?pJacp6boOZG0POERQg45+40FM5pTCot+3XlGsxNyQapLKxdAJu6rCQiqRBQF?=
 =?us-ascii?Q?glcJHk7Cs/ckRiT+H3AL3z8Yc8qgSfoMn6EFMddh0FcFD6JGvQsw8UTX0GTQ?=
 =?us-ascii?Q?5VEzOugB2dcs95ATB7aCivdkdijDLCWW+Kkya3GO8S1gF7WPn1MnYgfRlupf?=
 =?us-ascii?Q?kXVZrrYfR5ZhueG7/jIQ9gFVpVII9RGAK2hvR+s4i0wxa0RmTyl9mrwKJQFL?=
 =?us-ascii?Q?I4uxY80noCBk83TpTGwDbXdzqVCxH4vl1OYIEPxU4PdwfKUKLTPSxaCAdty2?=
 =?us-ascii?Q?Z53MGnIN9DJBVoXEvVQL0c5kR/2cYS6UWOgCgxwZ6DE+3cjrs1YJR2ImC3QW?=
 =?us-ascii?Q?Z63KA/BDd1dAYfaYvSg/uOA/FqD0iDGBkquy+VyP+5w4eoBlbWFCdckES7yQ?=
 =?us-ascii?Q?W0va7hK+I45NQo5lBGlJkO4BSPWQEi/wTnuyEmyKbLn5W+9HhR59uJigroIh?=
 =?us-ascii?Q?tpN/uIGiJo2yOrkeZFQmoKBS5Fj5E6Hd7wJnAmM5DyqY3AF1kPAeZ9qEDiv3?=
 =?us-ascii?Q?iwQiCNZ3kxA2/L1PUdk+yXQCTWC+j0ZjYHU/siCW6PG69wIiFXgOIjG20VXZ?=
 =?us-ascii?Q?WvddhUPwja4I+yL6lBm/oVAuSfE15wrWS6MoGpFaYWYROiBqQ8sjFAVIKEha?=
 =?us-ascii?Q?A8XTsjr4awqW5hBcgOghpdTGZtc7pqafgqy/p0Qa68Bq1LqgSiAcpscou2K4?=
 =?us-ascii?Q?zIHwKXbyBSzKmMQgp6GodvzfRKbMXY7whjfphWS1pb8YNABmcHTJse24tJ3F?=
 =?us-ascii?Q?2umThBjkc9uLt6HWhQRMNxHUjCzuiR71squcTC8q25vp2gIFtAhInSY0gLfJ?=
 =?us-ascii?Q?ijHG4q8S6lDZjug+dU6Lg48=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37911b40-605f-45d8-1504-08d9f15d0ffc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 15:00:25.6909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAlC0Fgq+Zm+ZcWquIzVEvQZXoaXTMAzugRnaCwSbGcEFhYdKvaHLBMq0xX5hAR1qSILQCbNBC8HEVBQBmnIxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160088
X-Proofpoint-GUID: X6AerTwuAt7kD4X_QE1W20S9WlDwjkRf
X-Proofpoint-ORIG-GUID: X6AerTwuAt7kD4X_QE1W20S9WlDwjkRf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 07:07, Allison Henderson wrote:
> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
> recovery and replay.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>  fs/xfs/xfs_error.c            | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 74b76b09509f..e90bfd9d7551 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -28,6 +28,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
> +#include "xfs_errortag.h"
>  
>  
>  /*
> @@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
>  
>  	trace_xfs_attr_leaf_to_node(args);
>  
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_ATTR_LEAF_TO_NODE)) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6d06a502bbdf..5362908164b0 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_DA_LEAF_SPLIT			40
> -#define XFS_ERRTAG_MAX					41
> +#define XFS_ERRTAG_ATTR_LEAF_TO_NODE			41
> +#define XFS_ERRTAG_MAX					42
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -107,5 +108,6 @@
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
>  #define XFS_RANDOM_DA_LEAF_SPLIT			1
> +#define XFS_RANDOM_ATTR_LEAF_TO_NODE			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 2aa5d4d2b30a..296faa41d81d 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
>  	XFS_RANDOM_DA_LEAF_SPLIT,
> +	XFS_RANDOM_ATTR_LEAF_TO_NODE,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
>  XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
> +XFS_ERRORTAG_ATTR_RW(attr_leaf_to_node,	XFS_ERRTAG_ATTR_LEAF_TO_NODE);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
>  	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
> +	XFS_ERRORTAG_ATTR_LIST(attr_leaf_to_node),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(xfs_errortag);


-- 
chandan
