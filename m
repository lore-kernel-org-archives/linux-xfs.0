Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64855C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 10:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345959AbiDKK2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbiDKK1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 06:27:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B6B4505D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 03:24:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BAJ37o032238;
        Mon, 11 Apr 2022 10:24:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C00IzGNOi+OKp+gAuv5X7WBGbrLI+9uGjld4V1KiYe0=;
 b=o6OGjO1BUur/g3g8V8apaxI+EE7QTc6r/V7DMt/Z5/1FA4BXPGQt7086gs0mkh/xHKGs
 VENLQZj51Hox/etkM3cUcmXUc2AKwA3Kdi88I/vhhkK0V3kYAru0N1EX9ENtKyj8NQmJ
 D6Fb3drpQEAyWT/qpqFkjhs5+5P1YA/2/dh4hQO8BTgxZzr4Sym4pwZ5Wvrzy7wTt6C1
 C9EEETFyriw+y3sY20n0+POPRjAW6jyIalMTglk9eaE1qHeYUnkUltYh6ANT8U3HjCe1
 xmYQIp7GmI2x5qT3iwzXkYYcAl3uVyAx42UaypHQE4UeVN5G4AuxOCb5TrXJ8ExmLLnd pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd35xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:24:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BABBv9040207;
        Mon, 11 Apr 2022 10:24:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k1x8at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:24:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFQOm/1Wh/4gAhgfbi9E4Q0xli+gt41BTs7hOaXsJSofGzPWyjSG0V0JV4YcRTEIZ/UrBcSyx2XZg/FtJ58C9NQ4Fbbwih0A0x21haGliCEsylvLBSG5xpjncBQuvswUrK92LBX7OYao9kcUs8qD6uLoaEASF4ZrO7FairZMwpEUCJe8Vs9E7pFT9rGA9go8SlbhZ7SnImcl4D0tK+lkI/O9ajuuNcOWtHF4G4Kv00vvCEHSep2kDNNFOSTPy7Ay3Ie7tx740onGRx2nu+QaNlItgt1HXd7Uf0SW29G1GoCUoZnNAzwmO0h3EmFQO2O4SAvF94OHJswsBjBUfbLGaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C00IzGNOi+OKp+gAuv5X7WBGbrLI+9uGjld4V1KiYe0=;
 b=bLdQYSKq/qiAqNECrDX9iplqtsmD86it2Y8Ib4ej3XpU5YRuPtuES4ThHQPGa19uyLv7/FXZ0+fSIjgPGrzTXBveDVLaLfDjR+6XYg0yKGdYEiYTyH0gkmVW8KYsn61MEE9bJflWmpTkdN6fV7zpFBls8TFZlpImKOrLchqJxhRX0esWDKI6Tq8UireK2aBCFAsyfw6HOpvRowHN9CzJ+xyA2HxGJ0jGi12PmHoabCjKjxZHU4ulrqqE9mRJgd57QH2Kz5Pluk+IKZLtAc21lkxP1vlpn1jPRNIF2KYAYDyL5Q4m/ms6jQS5G6G+urG8gKZ37nidjdgnzdygXlz3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C00IzGNOi+OKp+gAuv5X7WBGbrLI+9uGjld4V1KiYe0=;
 b=QGPn9u3v/R3RjuqHZ2Yui8xi/i8Z1F2CdXJI2fwKrq2PnNt2JrzVnTwhG+c8CJtPHydsNNr2a2i2GD2grOZGEvFV28eIsmIIQCHnQ4WjUeQKuPXokW6cKTj9ULKQE4CEebJZv49NBbYhywoAcwd7Wodq9gKs9F3BAQyHi6l/Ebs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3062.namprd10.prod.outlook.com (2603:10b6:a03:82::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 10:24:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 10:24:00 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-3-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs: convert attr type flags to unsigned.
In-reply-to: <20220411003147.2104423-3-david@fromorbit.com>
Message-ID: <87r163vryf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 15:53:52 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89c5ba5a-d816-4900-3b8a-08da1ba564b5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3062:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3062C67E15A03A00D86874B0F6EA9@BYAPR10MB3062.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ysFRlF9jcdL6RKGMqMMSBq6VXFWEFaaZrmaPa1NHly6qydFYsnZw8So2ZS0enxRS4Pf6/pLH0hheOxijePerKVW0QU9oOUEVm9pTp8HmkbmbzBA9QzOdmTnpkjYqn/LMA8pH0u2+ClYBU729e9B4LbgEMd8Yqh4DPfOyM7c+v6iAh19JwLKph7QzUwq4eIfeFNUl1RpmvoG3tKTsBcHwlPF4ov1Te67T14mJCsUen3xT5M620zeNChmK3m1xOEPkx/+bPsYQF25iHHBFRmRgXJuGqAVdpHikn2JmNiVYjkcGE3b94z/pBVZuooqqZqIvPrGprehZLLGKe7bIVixCXmxGwDOuh+ym1a1kWMK+V5wRQR0H/MAkwh9357xRkNc2p9zFJwAUyLaSFJwBwgJjErl8iBqskRnVRAej2m8LlHtWKufTgteY1HHOUY616w8i1ntdLj5oua2h8vAfA1vdvomgPmHP224ejREzGV4qhJ4L+XO4mxK+CPNH62BqtOW9pVKJ+FuhfpJN6hl2lXvnf/HGsHqi2jwWa5juCcjNfF3CioOQCINOVWcitEpySHu35CK+Y22rWVzimyY8mvrkvrdhs6XSWTV86jCvAf6faIRSoZq/txX2kJjTyDWIUfBLbVhBq8InHN0qr9L6DVK+UxF6GGHP63MGBl0ffLnoeWtdjq893yYLQnUsEMKkmfsKS42elKav9yzrzT6ASnsZVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(83380400001)(6916009)(6486002)(86362001)(38100700002)(38350700002)(66946007)(66556008)(66476007)(4326008)(186003)(8676002)(508600001)(53546011)(316002)(6512007)(9686003)(33716001)(52116002)(6666004)(2906002)(8936002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7MpcaLEpNxdj74qgdhhY96awazWlZUHsXHsRVEM5BGSj84BjcAaZno/Ybj4G?=
 =?us-ascii?Q?r6PctET8HKVQuum/JEFmWgPwgfhRmZaqwQxeQk7vlM7UZOTavQ/mB9qw5yYZ?=
 =?us-ascii?Q?f1bZOgez3mcmsILA/qdlcoZr0w2t50HeuFL+tYPV6uUlrVf7MrCCrkHYzAQp?=
 =?us-ascii?Q?uFojvYaTZwYNw7/QqZ+5kwmxZ44vW+UAepZf0+oWnw0g8wwQheAxlnlvOMfx?=
 =?us-ascii?Q?om9nxCXBiKcotdYrDBZUN5KMK0Um+Ih+zzTMtPUbD2zO3tu+Pjr5tANSkmeq?=
 =?us-ascii?Q?g0hWc5LRHF5Q0zlY08XGM634sceqt/rTbk4TJ/emtnmlX3Qd4djTREoPjQlz?=
 =?us-ascii?Q?S/WUP8kjwuDHvdhzvxPMAC6yqnd+1TZGaUWYkYNtt7i6VxOyJM7DYNziVHfk?=
 =?us-ascii?Q?DC5g/rddegtMxdJsToB/s5WUqSgDqyXV8b2Brmn89rgdu7gN3NPgH9azWPs2?=
 =?us-ascii?Q?jFEmXrCc3NhMruwOw1X0+/QHIsrXnzwlRB3iISH812vfaOD2p6g5+NbnBLqH?=
 =?us-ascii?Q?pX/pmGRj1AyCZ1SkPHE/+bSxtPaS8vGqZ+uhgh8gRwIrcfxyFcR8lUNRBbLJ?=
 =?us-ascii?Q?syMN/EbaMezE00Ey/NTrX90X8PPaREyLDWtRmwLPtTECpP0w8mmMVdEOQO5S?=
 =?us-ascii?Q?5gMC7fO56FyRLTbb4buxSxmdZZbxwR7HSlCp0++V4QZYd+Yalx3zEc6o20O2?=
 =?us-ascii?Q?zr78JvrjF1ZHst6xRdrxut9rIIQqzNTXniQi6+gcYvE4fyAHRh53S+RPDGA1?=
 =?us-ascii?Q?eozwYK9dm2AYX0Af05VBZMHVxoWsyy7P9zKU885f3h+aqOmknJRcVS52rWXd?=
 =?us-ascii?Q?U1Tw114GLakAFdg3KKbTOzCbsO/FGdhMW1kLXpquZ0SvPgae5M8v+IlbbXBs?=
 =?us-ascii?Q?v037umKMyM8jTj+5aplunTX5oSCmaLBfjg59w6H6i3VEUAqQ88UkhlYOe5g/?=
 =?us-ascii?Q?cTdKqqk+absyZ8VCc04BdmTYEqnT4Qhd/fTLjZ9FdxJIQE0Hl3K6xM0pEO6/?=
 =?us-ascii?Q?KVmMGwls+8gSXdbDJD2tQBD7wAYFV5tBrU1V5G/sYppRwt/b4DdhIp17D7pL?=
 =?us-ascii?Q?Jry1zuUxD74+bcYyhjNvg8wqqVcnFURWk1AQdozRvfIhkJuxkHOdygNyYFdf?=
 =?us-ascii?Q?w9qGV/PrZ+OOYMTUXDgE0cvc3/54OaUvT3nLBMCVC00Ep/p/gSAltdHlSN05?=
 =?us-ascii?Q?56BHjV6IllTnoLRpuViBVOYWIEzfJ/TRTkA1uGcRuLysYvH5OdZZGXPvwxHU?=
 =?us-ascii?Q?ADKeiYByhrS6I3vdAkckQb/IyCPy+GQZjKKwYx+br+coXdHLkxQjBf2/pVNd?=
 =?us-ascii?Q?HMP/ezHZ0hdwq8iD/v/Tf902/ua1LOX28FnrF8gqfeegaWoJW4Tuh9JEVpFz?=
 =?us-ascii?Q?08rM5/ddoD6PQ4hRS8mEiYEeQZMcbhmd/EDcEj9d3WZgxUKNRqAfIzKzDGUd?=
 =?us-ascii?Q?zsJZjIXtK7gE142BLuFQfcraqiL8QaINgI/PW6YufKTkw5/RA8vOChR8aL2V?=
 =?us-ascii?Q?vtRgvWds32tGt9PRZg8MHUdXFoAEV7UxQysVUN55vMoEncnky9b3tnJRNXXk?=
 =?us-ascii?Q?MRKWGrfrP9N41JdnsR1lukh3YDE4TO+cafL+tJi1rCiseHiIJnE1EPQAVup4?=
 =?us-ascii?Q?b3b6QvZVCOny1JK3lfxAo7rn3P4wzfMf3kYdqwr+9w8nzM6oh9augy22fB9C?=
 =?us-ascii?Q?BEMah9zSW/Hk9y3nUhCY3YBJQ+AtcSI+4vE0BN25+DH3KiqIGIIP58heMwJH?=
 =?us-ascii?Q?GFMqWIqWTQzwHdYKDzwZ06wSl6epp84=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c5ba5a-d816-4900-3b8a-08da1ba564b5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 10:24:00.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0YCvI222vMd2JhqNjSD/WYo1cHxdZHXxgkEeGHx1ExpJNY8Vo1hY5E9rRHRX+7PPOlq7taTxFs3l+7Kwbc/pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3062
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_03:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110058
X-Proofpoint-ORIG-GUID: ULD3gls36UgeexUN_6AQ3QG17uUgsJvX
X-Proofpoint-GUID: ULD3gls36UgeexUN_6AQ3QG17uUgsJvX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_da_format.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 5a49caa5c9df..4c6561baf9e9 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -688,10 +688,10 @@ struct xfs_attr3_leafblock {
>  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
>  #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
>  #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
> -#define XFS_ATTR_LOCAL		(1 << XFS_ATTR_LOCAL_BIT)
> -#define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
> -#define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
> -#define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
> +#define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
> +#define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
> +#define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
> +#define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
>  #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
>  
>  /*

-- 
chandan
