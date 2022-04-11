Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13360C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244718AbiDKFZu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiDKFZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:25:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B6E2BEA
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:23:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23AN6TtP022836;
        Mon, 11 Apr 2022 05:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QAtW2VrHVrnb4yDrDtcuJhuSG7KLFhQQ2VZIHLHHMdc=;
 b=LMziqP6fB8QVyTazGoFDfn9Npfz113gjczi0xD/cd3YfIBd0JCZzKp5NOWKKV2WK6GLr
 yh1nnVa20RSiETALETxpkx9OCEdQzJFk+USZz2inhulNr/TswATFhOk89LKACRhnCZkx
 UhfRdbJlPi+wE2OO025E8NLo4F7pLqc0R6OhUSYiM1WK1uivt4Bhjn0b8uEIl4rTjI7l
 jPTOddJJHbKFdJ0pHwQCAiLVV1geBTQIFmZb/4n3ViWuo1rKAatdeJHlWty3Nyif/lbi
 cLAHowm4iDUUwZkldjM71vWPva3MlAu9SPMUYxHqdVfInQ0T/eLpvV9gb1OcwdV14MMU TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd2cc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:23:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5H6Is030192;
        Mon, 11 Apr 2022 05:23:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k13mfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkTKS0SfwqPSw2FjuNeZ/ta2B/BkCGB0ymQ0inTGycBCwIul3oZwev1N0+si73mZ99sMDJlwgLv/4c+ai6tYmBGBPbtU6pl4JhquhmUwAjxuCe70TbeJtW9XJPih9tiJvm2nKxlYB/hCpjQPUbBNm7mHlHE28BBeLq19mRiN+ccDLHS5c9Rlr+PE4tSfKNBhpFafC79K30iVLdw7XJo8D71dAv9YK9DC8iKlIECPx8eJlTNh0Wj9svbg0x2c8fjdy7N7iF/X9wNhQPFkSc4Ngy6Zt4Qoq6GlC16Vz79Jql1nxFdNOQJOnj6NIVnWD64tsB6uPaffAIws8p9CJKn2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAtW2VrHVrnb4yDrDtcuJhuSG7KLFhQQ2VZIHLHHMdc=;
 b=Jh347uD3leF1v5mdeqLaTZE90pX5676I1C+ty2TewiGKuEW0OBNX9KXsbNkbnGr9CQRXdfwrb+gjdaAAogqCTemBx4D0HqXae4O+A3E7pZGcG9Lj+9iCbxO4jZZ5Uu2xchPHgDRLUmF6FgxWxW7PNvU9FsdH7Ojto3ToZJP+YepNMldLBrDF6AhcfY/g7t0C5uMEAeAmALGHJjA6u4ASUodbgE0SaVOeI0+IfFEq9XyUXzXVVtnf6bdoYPO1/fGr31+EA2KrSbhvz6h4eBOwAkmj7+2f/UkJOU8sCAa/ijiTdhEz5y2BrCCLKosc/F5Ne2lohRqtN+kLsfwlNBTPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAtW2VrHVrnb4yDrDtcuJhuSG7KLFhQQ2VZIHLHHMdc=;
 b=0HNtUVfY8hR50tEhOI9OTSrg2U7iG7auBvXucq+T0v0Ph51LGgceCuU8+UCxL/7uOCE9lB4jMQG73Tsn1VkbkgK+b0sTU1UPwLfNNothuXD94VgmPfg6OlBHf9cf91WzS86wDvn7qX/gg2HMTDhbdCzEscB0NciCOlMbjYhPTTc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:23:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:23:32 +0000
Message-ID: <064521b37753a99bbda8ed38f94c4fb1048dc80d.camel@oracle.com>
Subject: Re: [PATCH 3/8] xfs: add log item flags to indicate intents
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:23:30 -0700
In-Reply-To: <20220314220631.3093283-4-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-4-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11aa8210-a038-4ad2-f8ba-08da1b7b6b7c
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB49481329B2273805F1885EE895EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: onz8XnxcLxRCiSHnBQAy2hXfUtIXCuDvFG6zkUuKEKR6by98dU1TR1Hu7Dc3sUOv+sdf1beIxkcWYjN/bOc9KdHX7dB8sBHqvXnbEnkUtzXWzV9AHrKCjnscESo3MBESW7S1Mw7t7i15GkuKG0E8+ZC97BALA0uMyeFnb1+J4Mivg0rwa2pijvGbAVIYfdbqXZKafrsrUxN3NHrX4B75tU3horO0Zn8hrghFuZiYSJkxhmKbyaYFozCraNVpa54mF4P51FGg7nIYS2OW0okzSQlcZV5H4B+5tSTOyE42kNfPHgWVtIKTbnLGJdUqQ9LLjrF71rQV1m3/YZa/qOlGWkr6mLMK+9DT84pcXfQJzYvr1wtyGfP5GIc3mcbdIDN34jvE9DmcQSVhQJld4bA2vXUveRvy6sWDpxDw6S3BwvLFmp9mZicbU9opDt90SlYAwP5hwnOdihEEknvs+AS5rdnhCSG8wIMPh9QRulo4sNFyKHW3NJc9F2LTb9w2hxCVFNT/EoDEL34KwuKpiPdm2Kp1zDBjTbsGOd+7Le5pGoSsePj15PuGMUegXDnB+7CC48g6oHcm+tddmBQVDADG9yNlys9yfdg1ZFPfF+Io/uvYzB5KuJY+/LpuQRf7BflhJVqxGp0q+gm8v/43m6iAA8gA+HTacKG3rN01AQW7vl8lkK0QjUXDZWH64VgCh800OCdplnd2+TMDu/otWPmDxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG02ak4yY0NiUDA2TmI4OFpsQVFtRUIzNSsycEtadzV1amFpTW5uWDJITWtH?=
 =?utf-8?B?QjVYSnVseENMbkEyTk10Um9pU3BCQ0p2ZGJ5R3JoU3UrUlpOOWZ2TnUwVGc4?=
 =?utf-8?B?VnRVeEJQNXprSTZDam04cWNHSitZQ05rMnpQMmUraEsyTXoxVmtwSk9rYWY1?=
 =?utf-8?B?d2JzYlhHSHdoWXZuL0pRNkdjdWdVT0xCUDNUOEJZRHBGTzlhb1hUY0EvK2xG?=
 =?utf-8?B?NXRNZFRSZ3FzVE5ucldCSEpCZGxnYU5wVUpJV1FMQW1uY1g1OWpvbFhGVzlT?=
 =?utf-8?B?dksvL1c4ZjVTRXdIU1Jlc1dqdzhsdmpRNXlnV2hRN3g1Q1krRlNLQnBXajgw?=
 =?utf-8?B?TDExNkVZTkZlaG5oWGxpUGp6Qmcra1loTFZRMWNoZ3NFRDljMXpaYXJMOVpV?=
 =?utf-8?B?TGNmck01bnBoTGJCOVBkTGRkMTc5Y1ovaUxXdE0rYWpDSEdLdVlQRlpVbDJH?=
 =?utf-8?B?SGhWdnRtKzk4MmtnN1lzNHdvWHBJazFYNEFiRUZXd3YyMUFWZFdHQlFYSlpD?=
 =?utf-8?B?cXA4QlJ1RmRpL2FNSFhHSHFWVzUvNG5oaUxNa2hMeCsvYnFjeWUvM3lWOTlR?=
 =?utf-8?B?ckxvSlNvVzhDclJMNDkyMzdrVEJLaFNjR1NFV2piV1QxVGJqS25FdEhaYnZ5?=
 =?utf-8?B?NmtodWQxOFhRK1NYQWN0d25ReFFraWJhL1BiaHdkNTRzeVpSbFhCbFRzbDc3?=
 =?utf-8?B?YnQ0SkhMaHRUQU0xWmUxZndNellOSkgyaTd0My9QNWwvYjNLa001OThUUmtR?=
 =?utf-8?B?emR4R3BRS2orRE5TTGtleGJyVnArY2lwQ1k3WkxuWCsrbmFTdDFIUVRReUxs?=
 =?utf-8?B?bUo2Z1ZNUWoybm1DbTZzTkNYVHROenZIYXJRdDQvaTI2aFdidmRFa1AyV2hF?=
 =?utf-8?B?c1diUUxxL1MxbU1YSk42MUtGUnhaTzM0QlpPMkZKU08rdTZQVHczY2dWQUZj?=
 =?utf-8?B?RXA2d1JzNjJuTDZMVnFXd1FCdXhUQndKSHp3clU5Mjl4TE8vcU9tRFAxTVVz?=
 =?utf-8?B?cXBsWlVzVXQ2YzVoclFhNFR5ZExlay93cXk2NUoyeTh0MFJOTVpSTkNsc3Yw?=
 =?utf-8?B?Y3dGQm5LdVJ5MmkrbnZ4UXpWcytiU3dUU3RBdnNYNFYxalFseEY5bWlBK1Vj?=
 =?utf-8?B?Si9ObTlyMzR0aDJ3b1h5aXdadWlheXdUNjJuTVVrMUFRSDBKbkZhbFlZeU8v?=
 =?utf-8?B?eWFWeVVETGtrUm84VEhrNFdvOTJRdUhCbWxZR203N1lCVTl2WEo3eXZ5cVI2?=
 =?utf-8?B?RXFqZTNNeExpUTAreHZrK0wwU0JvOStzSyttQlE2SElPcC9XUk1UVjJOaWR2?=
 =?utf-8?B?ckZFUE9rc2Q2TDIwaVl6OVZVa0pPTFZhMm5DU0k1RW9qSDd2ejdmK0VyV1Ix?=
 =?utf-8?B?TUxXdzAraVlzdDhBU0lqQ1B4NjI4d0FpV1ZqTTZUWnRwNWQxeDVEalZpN0c4?=
 =?utf-8?B?TVNVU25ISU4yQWE4djloSkVmZVJpcUJzL1FYL3ZyTTdGRlFPclRuUzZyWjg3?=
 =?utf-8?B?S1Z1aFBTbGdVZlJOTHR6OWtmMWMyWU5XM1hjU3BrOFZCbTFwdThCOHA0SHpG?=
 =?utf-8?B?QUJqYmliMnFzeGlObGxiMmRQdWJOeGJwckJkYUw0NkRxWVFFZzFiU3pIeS9T?=
 =?utf-8?B?RGk0L1g4SjVSUFgzQmtOZHNrc3pMVFlLZ200ZzdBakh1VUora3RmalB3aHRD?=
 =?utf-8?B?N3dMY1RVejZxVldhQjdkZTcwUVdoWTJDZjcvbGd4L3NsejA4T3lZZUsvbzNT?=
 =?utf-8?B?b2Z0UEt4QjR3RnlSK1pXTmZ1dVJ0U1ljWnc3dEdqSVdTUXI1R2lpeTZUeXRp?=
 =?utf-8?B?eU1uZzFPakdOdkRLK2t0dFJHYU9mU0c2b1RZZXdBMlBkcjF3VGFsalRoNUpm?=
 =?utf-8?B?UEl0NmN2V3pKMW14QzdzeU5tUExXVGxoQnFnaDBpQkkxcGdZWlB2ak1mekta?=
 =?utf-8?B?NjFabUxuR2dKZHJyMGwyaDBuM21uOUFOVmx2ai9ySWUvT1ZYVlU4blVsbzhh?=
 =?utf-8?B?dlRvejRNb0xneHBPOWpZTzRMUGh5bEE0d3VpaTltaGZHdDFYMUQzQ2xzVjhS?=
 =?utf-8?B?NmFXaXpBWXhjdlVlVzUwSXZJeGV5cjMwNkxEdSsvNFJSOTRBWmJjL0NhaGk3?=
 =?utf-8?B?aFk4RUUrTWg5QnpOWDhic1BBVEZFL2hsMk5aMnBvNUoxWlJwYXFsSE56emlP?=
 =?utf-8?B?dVJwZkJMZFBWRkdscFhDcVdSTTBsWk9wME4zSGRCWTIrV1pxZm1QTS9laTli?=
 =?utf-8?B?YVVYUytPYkxCcUVIWTJLUGVneHZqeVpDbHpVektBbjBXOExWUzl1MEdTRlVz?=
 =?utf-8?B?M2NoejZlWnFDZXdZY1dEV1FBOFdGZG5qZjFHR2x1U1BCWGFtLytKMHRGR3Yy?=
 =?utf-8?Q?HoLmhiOG3dyVD2iU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11aa8210-a038-4ad2-f8ba-08da1b7b6b7c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:23:32.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaV99QrqkyHH3nXoCVrnJWwAPIAOZSE1uQ6BJGowr+oxeOLJp6AJpY/9ZtxRCOpCe4z6NRja9s8Zeh8OrKQc3hQURaoMUOEHRsMGB/psOXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-ORIG-GUID: skAmpGo5fbk8x2AD2sRhO0Nb7w0s0O6n
X-Proofpoint-GUID: skAmpGo5fbk8x2AD2sRhO0Nb7w0s0O6n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently have a couple of helper functions that try to infer
> whether the log item is an intent or intent done item from the
> combinations of operations it supports.  This is incredibly fragile
> and not very efficient as it requires checking specific combinations
> of ops.
> 
> We need to be able to identify intent and intent done items quickly
> and easily in upcoming patches, so simply add intent and intent done
> type flags to the log item ops flags. These are static flags to
> begin with, so intent items should have been typed like this from
> the start.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, this one looks pretty straight forward.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_bmap_item.c     |  4 +++-
>  fs/xfs/xfs_extfree_item.c  |  4 +++-
>  fs/xfs/xfs_refcount_item.c |  4 +++-
>  fs/xfs/xfs_rmap_item.c     |  4 +++-
>  fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
>  5 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index e1f4d7d5a011..ead27d40ef78 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -202,7 +202,8 @@ xfs_bud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_bud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> @@ -584,6 +585,7 @@ xfs_bui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_bui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
>  	.iop_unpin	= xfs_bui_item_unpin,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 47ef9c9c5c17..6913db61d770 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -307,7 +307,8 @@ xfs_efd_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_efd_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> @@ -688,6 +689,7 @@ xfs_efi_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_efi_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
>  	.iop_unpin	= xfs_efi_item_unpin,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index d3da67772d57..bffde82b109c 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -208,7 +208,8 @@ xfs_cud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_cud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> @@ -600,6 +601,7 @@ xfs_cui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_cui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
>  	.iop_unpin	= xfs_cui_item_unpin,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index c3966b4c58ef..c78e31bc84e1 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -231,7 +231,8 @@ xfs_rud_item_release(
>  }
>  
>  static const struct xfs_item_ops xfs_rud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> @@ -630,6 +631,7 @@ xfs_rui_item_relog(
>  }
>  
>  static const struct xfs_item_ops xfs_rui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
>  	.iop_unpin	= xfs_rui_item_unpin,
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a487b264a9eb..93cb4be33f7a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -79,28 +79,29 @@ struct xfs_item_ops {
>  			struct xfs_trans *tp);
>  };
>  
> -/* Is this log item a deferred action intent? */
> +/*
> + * Log item ops flags
> + */
> +/*
> + * Release the log item when the journal commits instead of
> inserting into the
> + * AIL for writeback tracking and/or log tail pinning.
> + */
> +#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +#define XFS_ITEM_INTENT			(1 << 1)
> +#define XFS_ITEM_INTENT_DONE		(1 << 2)
> +
>  static inline bool
>  xlog_item_is_intent(struct xfs_log_item *lip)
>  {
> -	return lip->li_ops->iop_recover != NULL &&
> -	       lip->li_ops->iop_match != NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT;
>  }
>  
> -/* Is this a log intent-done item? */
>  static inline bool
>  xlog_item_is_intent_done(struct xfs_log_item *lip)
>  {
> -	return lip->li_ops->iop_unpin == NULL &&
> -	       lip->li_ops->iop_push == NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
>  }
>  
> -/*
> - * Release the log item as soon as committed.  This is for items
> just logging
> - * intents that never need to be written back in place.
> - */
> -#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> -
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item
> *item,
>  			  int type, const struct xfs_item_ops *ops);
>  

