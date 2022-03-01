Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668B6C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 20:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiCAUrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238368AbiCAUri (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 15:47:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E9D6A037;
        Tue,  1 Mar 2022 12:46:56 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221JA4u1021769;
        Tue, 1 Mar 2022 20:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1V41krKIU3SM3RzoDe7q/JNOhGX9DTp6NbBS+Zgnh2E=;
 b=mj4lV3fECif0RpFPtMw4Lu5I3OCHSLc09Q6RFmEkvPsEOf6APihGFNoQ+ZtpPNO6IC3n
 O6l1c5ozGvUl+YjMnyEEbC32X0XXqWbGkkHMIRx2k3wPHxwjcXO2bA2xSJj3GKBJB1GS
 3sF7kUreoq8mwxQFAgpIoWFNU2OJEETJRMsCHC9+uch+cWRnOSIJ/iJXb2M72Nde9c1Q
 N173QHUt19QW2w9zRZHo2WI7kWHboClToqf2YOKT0UHITnJQQYLrAe3/56qPzcwz/4no
 vOvrpkkpcU0ePfgjIWr5b1CF1NHCILLOgUme9va2NHS5ZJlXK5K+4fSgv23oAbZcWbAc /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehdayt9d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 20:46:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Kk2un108414;
        Tue, 1 Mar 2022 20:46:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3ef9ay6nmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 20:46:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klnctrH/Ymz9vNdpQ2v1ExYjwUGBZ+KvZ0JzMmehyEDXBV17YiWGWri7IZ6Z/w9LHMAf7xDdU2fL3srKzN4EDv2gNyhTwi4JPnTHBOf/4IZLktR2nj9MPQlMCACmwcbADmA8/JQHBuxJ52iCGeGOKjdR3fYvta8T4Ng9Bi8PyS6KthuISecY5LgTLmbVbBwwB1X5wtaCBrNl/HWQb/8Cx3oa1UR9ZlkDrpqLDizEaHsG2rWzF1QeCXCOiloGbEzxcxmOXQFjblrEuGp7MKklvUNVqxJVqWSsvM1+mUTbGy0Q5kbohCTUFLcfNk3ZKkEwXAsQ4XisfhsKhXcFYz0gRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1V41krKIU3SM3RzoDe7q/JNOhGX9DTp6NbBS+Zgnh2E=;
 b=Rrhsxz5uuPDbDvH4uth+aDKuSjcgznTPIIJ34fIfy5ZnBJkiLccE/KEkILewVLZoEgGP3vw66/jC6FYMSD/fOTrSsBo/TvkqJNGQg4bIX7wg/1+xWZKjK6ts4Uo/1Lk98+bk/iEeHtBWeu1vnrAJ+bmGJV07xI4grECNtrbREQHIxnC4X537j+xcDDBaKy+kkVFJ2rrTsZRk1yMryXSaI+I8XCzR8iYV4/TpEZrNZn8aX27I9z0pECShbUZj0oeIA5rY+dGNiqa/p+4Nsv5UcZWADrrj79WzIFOLEpTc/MU631CBiYIfi4s+zflwfVCbX24D4uPPQbgpMR9Nk35LlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1V41krKIU3SM3RzoDe7q/JNOhGX9DTp6NbBS+Zgnh2E=;
 b=YNSnKTBHnUsgPYll9CHBtyZ+L5aiQWVwZIbc0nGSKw32sBjEeNb63eidhRjilHbGKOHVRYKuR7+7WNZo/VjspKeold39Zndvu/Y1hUzwGtsg64f/A4tMoGHqUexVXipbWoRz5A6EO+ltlvI0RGco0aKbA6ocjCxfLpQvvPLbDvQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN7PR10MB2723.namprd10.prod.outlook.com (2603:10b6:406:c7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Tue, 1 Mar
 2022 20:46:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 20:46:51 +0000
Message-ID: <12804da9-f777-0cc9-de19-e494b1d3726f@oracle.com>
Date:   Tue, 1 Mar 2022 13:46:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v7 1/1] xfstests: Add Log Attribute Replay test
Content-Language: en-US
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220223033751.97913-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2479650-1488-4688-bb6f-08d9fbc49c5e
X-MS-TrafficTypeDiagnostic: BN7PR10MB2723:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2723EE1BD381CD9FDF1DEC7695029@BN7PR10MB2723.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VCxSaaNqRI9V+BvkXy4JLLKNVQEBG15m17levYI4568E2YlKRA1x9vJYeg21LwL8qag2Nz+XvHeCbuC9T27ui7VNjA9HZ5qAN2yK7rvh7o9CCQM9dG40PB5vvGxiJQnqivCD7YXa75txX3Wo0L/Db0gNsp2UlMdFf4OsSl0VliyqN9ySaINfoKYei8sSdJBCeIM57bBnBuwCDEN77ZKBrmWENWf1MaOT/rSbfaMOc11QkzKrvOIuvg+OiVTBHCCPh5z2cdMULTnd/fDqXSoZUvto4nGD4X0aUCMohui4Z1QkREh/0bzGybnjlQ9wG05337IiXMfl8Fn68ZhSLjsM7Hjq9DuPm6d0YskrMwH0zB7MkLrlQioYluYN7dgAtlzdIi9FyBb61S52Gq8aOA3ARGCajhiVbBY3C0Ui1gdDP6yJKlNkvE5S0drPGd0rDCBo4lzawlFCohDUiS7K0q8233HPYuhedTksv4O04E2GXkF2M0udv4sHMKvpJXuM7E1lUVOVh+JVRuDSo3OpTW3aEuqFYT+65CHGdrsrJySVYLxjA7plvNAKqwcBLp+KV06YC00JfZggXSM79P/hkJGziIAPHcves2tcaMKzjU7XvNJwyKhzXS1C4+r01hOqjcWkUzWT4SLqMGLECK8oPi8p011iMvxZHWBt26Z9+WhXsJfRSKLjFaC3pfc4NRYqfa6bzbifiOOYszJtiuB5WqaUJEjh8pk8a84YWx2cjxakLfNrcC0W0X/mMLr7XKBGEjGiTaLPHqQRitUE/e/OYsHN4V9RYFLa4LIhbgnzfilPsyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(66556008)(6486002)(5660300002)(36756003)(38350700002)(38100700002)(2616005)(316002)(186003)(6506007)(8676002)(31686004)(86362001)(31696002)(26005)(450100002)(52116002)(8936002)(508600001)(83380400001)(44832011)(6512007)(6666004)(30864003)(2906002)(53546011)(45980500001)(43740500002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFdyR2hRQks3bGxFeUVpbzEzOEFsMjdhMVN5WGxpU1VSL3JaaTFhVDRPVFpW?=
 =?utf-8?B?YjRSM08wbXovQ0pKMytYcHZYZGwyWHlXQWkvQjk1aXFvenFGUWFXaEpiMTYx?=
 =?utf-8?B?ZVZSWjBFMHNNVmRWbVFXc2Q2U3JlbzBsMzlKMUowZUVHUi9GMCs3eHdYeGx5?=
 =?utf-8?B?UWtNV2EzWDBZSWhQekNuSk4vZ1ROWmtubGNBYjVYK3FmSmliV1l5V1FFY3dG?=
 =?utf-8?B?VzN4Q1ZuU0UzVWFjL1BGMWdhR3VBb3Rzd0tRNnQzT0h4NHF3d0ZvQ0JIWW8z?=
 =?utf-8?B?bTVoczd0SWx4VzBOYVJ2Nm50bWhiemIvWWNTeXh2UzlIWmdQUFBPZ25PY3dL?=
 =?utf-8?B?WWpTNTZkOEdWNXcyR2ZGdFNCbDlwUTh4OXQ2bW9OREc2MXMvUTFESVZ5dlNv?=
 =?utf-8?B?UmY0czVFM2VqckxLVDZ3am5oSWRTT2w1cGdpMW9wQUFrODh0alo1UGpVei9t?=
 =?utf-8?B?djlJNHo2YTZONHVyMld5VTVYdkM1cFBJTGc0a1hUeGlHMnRORFA3eHVrNGw3?=
 =?utf-8?B?ZW8vRjFCKzFnMmRBQ0NBRUIyVlkwVnIzWkFSVzVSL2Z4ckFlSm5YUzRoVjJj?=
 =?utf-8?B?VXhFaXNwYkJ0emxBL21POE4wVXlwOGdkdlpTS3hBOXhCWTRINld1aWNyNUEx?=
 =?utf-8?B?YkxENSt2RFY2Y0pxZzEwK0lkUUpkOGJLK3k4T3hBV1pFd0NiUjQwTTBMM3dw?=
 =?utf-8?B?RTNvNzBDdStKTmNCbDZ4aUFFenlJVUxhMlR3T3RFQUM3ZnJXM2xPYnl5T0Fo?=
 =?utf-8?B?UEJPMnpFWXQ2RnFVRGFlZlNmRytQQnUyTDBtSUJwMkJ0c0duMURscDQxbXZv?=
 =?utf-8?B?OERQUTBpZkdqdFZZZ04xQ3BiNkxHWnJFeUNvUkJjLzJIdGRQZ3o4dlY3RzEx?=
 =?utf-8?B?OEI5Z2RGeXM2eFRMRG1Lc2RwZnhQM0tGcElXdWtNNnNJZzNPTy9ZeitFU1RC?=
 =?utf-8?B?TEIxR0xwejM4dU5pT3NZUlQwbnRtM3lrbnV4LzlkYVhTSm9mdjJzQmxvQkRv?=
 =?utf-8?B?MDM3RzBucUJjeCtxWWUxQlJ2N0pJU1craXkxMDBLaHp5NndSbEVxZkJ0RXdF?=
 =?utf-8?B?R1JDT1VvV0NTQ0NnRk5DZFN3ZlVaZ1NBNjg0aXNCL2l3aGwxZ3Ixd0g1RlAw?=
 =?utf-8?B?YUE0bnk0Sm0vcEdScE5uYXZWNjVNc05yMUdnakIxajRoTnp2Zk5iUjhHajlw?=
 =?utf-8?B?U3NBSkVjSUU1dU95MzI2TnNTU29LWkFjcXhGd3hodVgvWVpaOERUd0syQ0NU?=
 =?utf-8?B?RWIxdjJjYkJYRTNuUzRXRTZUTUpDNmhRaFVyNklua2xaYnk0MjhGV1dZV3Zw?=
 =?utf-8?B?R1hPT3ppM2FBNzRJWmIxRDcrcGVjUm1wQmFLM2xGL1I2N3VobDZXVUxiV3Y5?=
 =?utf-8?B?ZVNJK0VxV0dwdit0aVFSRGZoN0xNMVJVTmVOeGt1VkVLNFB2RTkvbTl0RWxS?=
 =?utf-8?B?NnFDakV6MjJLUGlOYWRVRjdrek5kNFZEdWgzWi9HN0V6WnlRYmRlcWMwOXJp?=
 =?utf-8?B?L3gyNTNLOU5rZEFydzI3QjdsdHduTUZvek1qejRzcXdvUW4zS0taeDc2elpB?=
 =?utf-8?B?V0F5UDlVNFhUUkRMZ3g3bmxlUW5kczVrdU05aGM1SUM0cTZIOG1sRUptN1hG?=
 =?utf-8?B?ZCtOeGNhbWdJZGxxd1owaFMxTU9WUHlOQTR0OEJueU8xTE8xNlNyNXRITzJn?=
 =?utf-8?B?L0tPMFYvQkZYTHA3ek5YK1NnWkhzcDNWZkVaYjNTUHhtbzdPclNFbEZiSUZL?=
 =?utf-8?B?d1ZzUHkwazk1bTA2dWIrbGV3TWhZMEVwTm1aQzlselJIb3FWV3pXNHpoV2J1?=
 =?utf-8?B?OUtnUFR5eUVwMUJ4M2hWVkczajVXZ1VnWWR2OVpFdUREY0pUN1NRNkhURk9x?=
 =?utf-8?B?dU9LVjBvKzhYSUxQY3hoVEZBQVRoZzJRcktwZTg5VHZ5UC8rck5rNDdjWjU5?=
 =?utf-8?B?dUNjTjV2eXg3MFRJSTdmRjNmY1I1QmtMcWkzZldub0pGdzhXY0JIUEZPbFRP?=
 =?utf-8?B?RFMyNVJtb1FwNHBMdnI5aGFEQWFNWkdaeE1NWjhOYk15K204eDlYR3cxMG9r?=
 =?utf-8?B?SzhKUEo0elUzU3B6Ujk2Qlh0ZXhGSG5iaG5HQWJvdFpRdEdublN3M0RGdEV5?=
 =?utf-8?B?c2ZqS3kyckFxSHZ3WkpDVWM1UHVDVC9kTmQ2aUVwcmZxTGNTTU5UWi8zcVB6?=
 =?utf-8?B?MThBaTVTb2IvejJsRjRseEorWWU3a0FHcGNvWlh4VVZrMmhGWGYyMGpjQzFp?=
 =?utf-8?B?MDMxWEQrdVdFS0N2RnBvVXpuUGhBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2479650-1488-4688-bb6f-08d9fbc49c5e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 20:46:51.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6edE2AQaT8/xXcjByvSwma/KXp2uqpTT9cyjXFrEM7js+Ko46VetufM/NHRaLeX9CoZ+QFxDjrl6E0qnEdS7ZlOEyLo68tEdNIDI3P9EV9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2723
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010104
X-Proofpoint-GUID: 3zWij6n44MBByrsKZmSnwLTAW4246Cgk
X-Proofpoint-ORIG-GUID: 3zWij6n44MBByrsKZmSnwLTAW4246Cgk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/22 8:37 PM, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds tests to exercise the log attribute error
> inject and log replay. These tests aim to cover cases where attributes
> are added, removed, and overwritten in each format (shortform, leaf,
> node). Error inject is used to replay these operations from the log.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

This looks good to me, though I can't give an rvb as a co-author.  We'll 
need to get the kernel/user space features merged before the test can 
run though.  It seems Darrick has found a bug in generic/467, so we'll 
need to get that weeded out before the rest can follow.  We'll chat more 
in our meeting today.

In the meantime, I encourgage reviews for the testcase since we will 
eventually need it.

Thanks all!
Allison

> ---
>   tests/xfs/543     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/543.out | 149 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 325 insertions(+)
>   create mode 100755 tests/xfs/543
>   create mode 100644 tests/xfs/543.out
> 
> diff --git a/tests/xfs/543 b/tests/xfs/543
> new file mode 100755
> index 00000000..06f16f21
> --- /dev/null
> +++ b/tests/xfs/543
> @@ -0,0 +1,176 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 543
> +#
> +# Log attribute replay test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick attr
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +
> +_cleanup()
> +{
> +	rm -rf $tmp.* $testdir
> +	test -w /sys/fs/xfs/debug/larp && \
> +		echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +test_attr_replay()
> +{
> +	testfile=$testdir/$1
> +	attr_name=$2
> +	attr_value=$3
> +	flag=$4
> +	error_tag=$5
> +
> +	# Inject error
> +	_scratch_inject_error $error_tag
> +
> +	# Set attribute
> +	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
> +			    _filter_scratch
> +
> +	# FS should be shut down, touch will fail
> +	touch $testfile 2>&1 | _filter_scratch
> +
> +	# Remount to replay log
> +	_scratch_remount_dump_log >> $seqres.full
> +
> +	# FS should be online, touch should succeed
> +	touch $testfile
> +
> +	# Verify attr recovery
> +	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
> +
> +	echo ""
> +}
> +
> +create_test_file()
> +{
> +	filename=$testdir/$1
> +	count=$2
> +	attr_value=$3
> +
> +	touch $filename
> +
> +	for i in `seq $count`
> +	do
> +		$ATTR_PROG -s "attr_name$i" -V $attr_value $filename >> \
> +			$seqres.full
> +	done
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_io_error_injection "da_leaf_split"
> +_require_xfs_io_error_injection "attr_leaf_to_node"
> +_require_xfs_sysfs debug/larp
> +test -w /sys/fs/xfs/debug/larp || _notrun "larp knob not writable"
> +
> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +attr16="0123456789ABCDEF"
> +attr64="$attr16$attr16$attr16$attr16"
> +attr256="$attr64$attr64$attr64$attr64"
> +attr1k="$attr256$attr256$attr256$attr256"
> +attr4k="$attr1k$attr1k$attr1k$attr1k"
> +attr8k="$attr4k$attr4k"
> +attr16k="$attr8k$attr8k"
> +attr32k="$attr16k$attr16k"
> +attr64k="$attr32k$attr32k"
> +
> +echo "*** mkfs"
> +_scratch_mkfs >/dev/null
> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +# empty, inline
> +create_test_file empty_file1 0
> +test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
> +test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
> +
> +# empty, internal
> +create_test_file empty_file2 0
> +test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
> +test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
> +
> +# empty, remote
> +create_test_file empty_file3 0
> +test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
> +test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
> +
> +# inline, inline
> +create_test_file inline_file1 1 $attr16
> +test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
> +test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
> +
> +# inline, internal
> +create_test_file inline_file2 1 $attr16
> +test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
> +
> +# inline, remote
> +create_test_file inline_file3 1 $attr16
> +test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
> +
> +# extent, internal
> +create_test_file extent_file1 1 $attr1k
> +test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# extent, inject error on split
> +create_test_file extent_file2 3 $attr1k
> +test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
> +
> +# extent, inject error on fork transition
> +create_test_file extent_file3 3 $attr1k
> +test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
> +
> +# extent, remote
> +create_test_file extent_file4 1 $attr1k
> +test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
> +
> +# remote, internal
> +create_test_file remote_file1 1 $attr64k
> +test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# remote, remote
> +create_test_file remote_file2 1 $attr64k
> +test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
> +
> +# replace shortform
> +create_test_file sf_file 2 $attr64
> +test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> +
> +# replace leaf
> +create_test_file leaf_file 2 $attr1k
> +test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> +
> +# replace node
> +create_test_file node_file 1 $attr64k
> +$ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
> +		>> $seqres.full
> +test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/543.out b/tests/xfs/543.out
> new file mode 100644
> index 00000000..1c74e795
> --- /dev/null
> +++ b/tests/xfs/543.out
> @@ -0,0 +1,149 @@
> +QA output created by 543
> +*** mkfs
> +*** mount FS
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> +21d850f99c43cc13abbe34838a8a3c8a  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> +2ff89c2935debc431745ec791be5421a  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> +5d24b314242c52176c98ac4bd685da8b  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file3
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file3
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> +5a7b559a70d8e92b4f3c6f7158eead08  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> +5717d5e66c70be6bdb00ecbaca0b7749  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> +5c929964efd1b243aa8cceb6524f4810  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> +touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/inline_file3
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> +51ccb5cdfc9082060f0f94a8a108fea0  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
> +8d530bbe852d8bca83b131d5b3e497f5  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
> +5d77c4d3831a35bcbbd6e7677119ce9a  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> +6707ec2431e4dbea20e17da0816520bb  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> +touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> +767ebca3e4a6d24170857364f2bf2a3c  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> +fd84ddec89237e6d34a1703639efaebf  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> +touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/testdir/remote_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
> +touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
> +34aaa49662bafb46c76e377454685071  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
> +touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
> +664e95ec28830ffb367c0950026e0d21  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
> +touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
> +bb37a78ce26472eeb711e3559933db42  -
> +
> +*** done
