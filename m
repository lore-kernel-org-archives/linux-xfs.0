Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92075C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 03:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF2D610F7
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 03:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIXDEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 23:04:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5006 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230123AbhIXDEf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Sep 2021 23:04:35 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18O1d0YI010241;
        Fri, 24 Sep 2021 03:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mwrvwpwhFiMpEA5gSizmV3H2sDQaemKMBQii9hJO1Yk=;
 b=pxxPelQ5aTYw3oDR7znY2k3I0sdfiGNU21DNubtTRuL48BVwZ0KL215sievB7Goduc5H
 U8K1+beE3ALD4wiwyjbjzYZV3J1TRmUSQomMUBh4di5GxTzrjk8vbGWqluoDiUktqcDg
 0ufVs/rTHcbKONo6dmeGEohBNS/ztsx69R/zRPmBIUqU/Y2mU8mDJhKYuC3k8CQXZfRL
 rZBHZ8eepVnbtEu26HFgB1UerfV1nTgp5bJowkrJKNI7KHnMQS62cudIFeBwbNuWoPu3
 eL5hSJejBskyBtjfr00d5VURGfW0mllMxEX/YbEU8Qr/1GE3uQjqBgDSQGjOr6l4GLvc 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93esrpah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 03:03:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18O2st10018916;
        Fri, 24 Sep 2021 03:03:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3020.oracle.com with ESMTP id 3b93fq5nff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 03:02:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePshdmn94Jsl0QqM3ryde3u3fmLbQIg+2wGGKmhN1wOw5B8Uvhw4KxVWqQVFuiqenjl3fuyrxLtCiZGaQ0Wwa4hMz9EmSj4XBV4gVHU8y/wd/OMfy206qx/NgWd08+UudYXkC+e8mgWzhMcjqT3zdiL7HMWx2xGLLMBB6AtIqrGUcXZAnFxD6rfmnI/F1tSYD++X/6xa6zwHlvnmh2P6yrCkVDbDWh04Sw5Gjjb1e1SixPLrW7vsg5LrMCswD3mifT6esI+2qSGJ6sFUzRQVRlu8UvZQCd0tzsfERv06v3sBUq/OB1kf7Ed73azaVr2LhzbeEy/1AYR7Agd6BnF6bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mwrvwpwhFiMpEA5gSizmV3H2sDQaemKMBQii9hJO1Yk=;
 b=mTY7SZi0U9nhIAveV08OWKbER7nyCc7O52hbttnuaD89tE1wSmcgrVAXPmaZUHuQP65fgYfP0yh+S8ndBxgUF9W2DThhaDrg5BpNTAjHWdPw+d3Kf1KyCkbuF63Jzoqe5lfk+PCja/OI38MzElBYv67Q5Z4C3j7C+AU2J9W7IjFCrLQipAZx4UDdV7dGd10RvpynSS5iXeFrfbAp/la5H3ZES0eCFWs+itZLQ/6ZbZDZHFfJUyOvgrF3DY9ZNu7A9fTIweHUkbQRZhmKJxdNZTkngx7aaaIx0oNfXz8SSIWkJ5MvC56bnGv3dyXUW88zIVW7q2DBdbmdMzcr+NmVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwrvwpwhFiMpEA5gSizmV3H2sDQaemKMBQii9hJO1Yk=;
 b=UHHg2330hVcyUrhtlTBV6WBWcUIQwJFrYIC1J/pKXwiJhuCYKbTBGBzAArIq4IUIrbyaE8BRrkRrFD0twk1qmQURM4BZ8SvRhVdWnJ2RLVXiRzj6hSEvUHouMIfG0XvIS6pNgRMH2C+JEaqBSy0esZNBsUyd98YcoBTGCQOFsB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4555.namprd10.prod.outlook.com (2603:10b6:806:115::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Fri, 24 Sep
 2021 03:02:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.015; Fri, 24 Sep 2021
 03:02:58 +0000
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
 <20210916014649.1835564-2-david@fromorbit.com>
 <5ca04624-581d-23da-ff18-a7e6c908efa1@sandeen.net>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfsprogs: introduce liburcu support
In-reply-to: <5ca04624-581d-23da-ff18-a7e6c908efa1@sandeen.net>
Message-ID: <87ee9ezne1.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 24 Sep 2021 08:32:46 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0083.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::23)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.179.80.2) by MA1PR01CA0083.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 03:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daaffbf0-2860-45f1-d2e9-08d97f07cfe8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4555:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4555F4395B611F8A18BE6AA5F6A49@SA2PR10MB4555.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pV0cE8MFYKeZ1enKTGAnH77GnYyivHivRxGSQXV70Ay1z3YCfHTuEtuu26tV2/rz37P812vfatX+BiorhEI34kO9a0jrrAaXrZA/kJAsY078dpJuyp8BhibQDl1x0Li/V131IODHnCranudAuiXjEtXW7ikdGyPf2osaa6xhwZtutN1xWknOHvAGePBJCFWz7kl12sR4RPdBaMWyEkAXEQVcKYMnCJW2y/kvC6sJPGcBKqfLyy7iy5mOlbZ+8alDajvL1oc/z3FbTxCWFxnaj9Ov9+YPkzNVRDzcB0RUknpO0h7oMxykFA3onOTmDwjyVqcUGkIrs8yulbu7WT4rQZgzUnvx3sQknGQZP4IHiK5yf7kj2jkpaApMzIpz24oXsmy8+1wVPLBmhxRytZ1dRyPQkgCdRK2+C1Z/DlIkuSQ142u2CWnhqX4lDLIRoNLZCu3ayFxw+R+vMpo+JtrTiAGVTPQZZa59Nx1P+wvW2f6ns3tegkQ0s0gVvFg6sG1N3A/5NTCEEXPAfzU+bJRfl49TaMDCGBt9hLyNM24SoAblt8Cn7OVgQXVA8AXOBZWKRsPdL9JbNFzhQPNeebi2cTrarQDjNcVy9Xn3XJRmbTKDzk9DqNe4zTWOiDJNPb2voYmscIrnFcm1U8JNayoeb0eCmwgL5tXyExcoBrnLx68/mVM4CqSSfJq9WOZQMyrHT+raMTQuCkQcU8KnHPRMEK+IlvDqBD13gk5bcCvnyxfD5A1fPnpEa/WnBniFBGT0xQCV4jBYvOycfBWSiprVFhGjC9gVfZC5WiaMZw3R1aU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(86362001)(6916009)(66476007)(316002)(508600001)(186003)(83380400001)(4326008)(9686003)(53546011)(2906002)(33716001)(66556008)(8676002)(38100700002)(6666004)(26005)(956004)(52116002)(38350700002)(8936002)(5660300002)(6486002)(66946007)(966005)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?se9QGpGgBYrtsqWwngcVgKvjj6aaXT++8yBqbVFIkai8MKerKgAUyArZhDYr?=
 =?us-ascii?Q?sBvOmnT6SOvCAGssR1FanxL3nIQoxTcoyvRaQF6ydZm/B3GUJ+sFSyiSukdJ?=
 =?us-ascii?Q?fRMzMxMYLKyUukBdrnl+Sq4yha4G2A4teBCH1zSOHMjOd3Q53ACxYxuDrFHr?=
 =?us-ascii?Q?Tzr+m/QKKvufDWVSOzkN6/tlUOI5wz0ibTy1z5j4bNYpTw4sRYT7J1Y4vpwv?=
 =?us-ascii?Q?PYU1omC5few71ijcDRf6B59AGRpyTAvlB7oMk2kvw/436F57SKFdRlolhHX1?=
 =?us-ascii?Q?MpCk08UuQ/iIxk1weBTHVDDkOtfhFG5XNceE1OH2j21esepXJen4ZUQ5vvp9?=
 =?us-ascii?Q?r6NKbkgZ8Oak7SJhePPt9AOeJmddxUNXvqEv5M3K92WtkjVnXe7ASyvC27vg?=
 =?us-ascii?Q?Su7KpwUvRD9eQ/mffA0thkstmUVNhLhbDIAJmYdFyoZ4tQfLeFbGvx4EyMbf?=
 =?us-ascii?Q?WTL43BYS/OUtLZkMtlmG9eUvDUI0iZQXMkud8BtzrfpsiB8yPR7jEYGtrLgN?=
 =?us-ascii?Q?QCMnxNoPk/+ul8B3pp5BfiFfN3Z99i4zaT/OvzOCIGI8HjJRQIJZMeKNsxbE?=
 =?us-ascii?Q?gh2YNMXjA7hB1KtarfXva/1QpCFldzRjLAaGejuX4tzCajEW3pZ4LFglH8iZ?=
 =?us-ascii?Q?J2warUP5CbgPUyHVu0Sh6ynmMwljo6S/FcgY4PoGuA3gZJaeT5jkUH2fg6/s?=
 =?us-ascii?Q?stU+88zuIOWBQ+VSYmkqyzv149W45SRMi0hux1wQBatX6tqG4zaCpnGbmWJS?=
 =?us-ascii?Q?Yw5mym+hHfIIGPB0XmYIM/TqHe8s2fWgKaoHrE7meh2j7kjW35xdzQyOh7kT?=
 =?us-ascii?Q?nEDCOneo4aCl9Zx3G0koumidVsD5lwyB0hr5+bzujs+tQphVX1qAp0zSyMjk?=
 =?us-ascii?Q?WzBxeD5YKlgnwNaJ0a3H2K8ERwP/ckZHGGcyf7xyeIgvhgmbITr0IqOmXzg8?=
 =?us-ascii?Q?a8WJHHdmph1WXUdSwCUjim/G+LtaDx0Zce5569qCW6j8V+rUaBZW/+z6fTgK?=
 =?us-ascii?Q?NwgeJLMqMJSTeb80mBpaSwkJUPxdD9V4S9W9+6TFdSEm4ZJIK0/e9ROIYe25?=
 =?us-ascii?Q?TW3SabIq2hdtrXFfEhskIXWnAllKa420tQcKf0YaGod6W+Fjae/YAWoQZxFT?=
 =?us-ascii?Q?xkUw0L+rm98x3TPA6xLCPA9dCwGs7lA39FZ/0ajGvLPyEwgyb9c/sCPUYZAE?=
 =?us-ascii?Q?1YhvcSXX2rLFKMLwS6vkfSjmEqqdPiC1Afc77BjHJMMBt0JazRWvcF+3mNjT?=
 =?us-ascii?Q?uKHfvM5Qb3miXWzaYFL3w5C3h5bZoCV01StXILiKwm8y+VYFSMlXLhXj94v9?=
 =?us-ascii?Q?CuzT5zG7onn2imcSDFX6t/LI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daaffbf0-2860-45f1-d2e9-08d97f07cfe8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 03:02:58.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utJJdYEk6L61dERNpxWE+KcV1gGAaGNDPFYEv9qBJSlDO82xB3px/C1OfZStdNpqyfqUzbA2rlj8t1WGDk1skQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4555
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240014
X-Proofpoint-ORIG-GUID: kptW60JclNY4g7Mfw8El_rIFWl0urpa1
X-Proofpoint-GUID: kptW60JclNY4g7Mfw8El_rIFWl0urpa1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Sep 2021 at 06:11, Eric Sandeen wrote:
> On 9/15/21 8:46 PM, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
> ..
>
>> Hence kernel code written with RCU algorithms and atomic variables
>> will just slot straight into the userspace xfsprogs code without us
>> having to think about whether the lockless algorithms will work in
>> userspace or not. This reduces glue and hoop jumping, and gets us
>> a step closer to having the entire userspace libxfs code MT safe.
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>
> ...
>
>> diff --git a/m4/Makefile b/m4/Makefile
>> index c6c73dc9bbee..7312053039f4 100644
>> --- a/m4/Makefile
>> +++ b/m4/Makefile
>> @@ -24,6 +24,7 @@ LSRCFILES = \
>>   	package_services.m4 \
>>   	package_types.m4 \
>>   	package_icu.m4 \
>> +	package_urcu.m4 \
>
> This new m4 file is missing from the patchset, I think?
>

urcu.h maps rcu_init()/rcu_[un]register_thread() to one of the userspace
variants e.g. rcu_init() may be mapped to urcu_mb_init(). The configure script
generated by autoconf does not include urcu.h in the code snippet it generates
to detect availability of rcu_init(). Hence the linker complains about not
finding rcu_init() causing configure script to declare that liburcu is not
present on the system.

After finding the root cause, I searched through configure.ac scripts of Knot
DNS (https://www.knot-dns.cz/) and found that the project was using
rcu_set_pointer_sym() as the function in their m4 macros.

The changes can be obtained from
https://github.com/chandanr/xfsprogs-dev/commit/d227e8aac894ffe1d688c6c658b445ca56a173fb

-- 
chandan
