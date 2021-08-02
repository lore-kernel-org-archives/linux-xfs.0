Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D57C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B257161057
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhHBId6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4254 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232428AbhHBId5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728PiNc020652;
        Mon, 2 Aug 2021 08:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mIB0Nu7Z/KunNXpf1QksQh5Q49dzOVXAhqHUA53mzmM=;
 b=qB5ABsXnjnw49YigblFkYvDMGdYRwXLgHGMHCFVVrnRBog3OsAcNsQMBX95D04IXAyLf
 O4+tNITI0Iq59P5ttZ8APmn+tn6lzmAXeDWf0D3WVSqv1Ole94eUDNu1WzPrknWA8i+c
 7mqLWqX3GzQq9tz1wRnwROWO+O5B0oJLnwjNH8N2bIaDqGqmBelS5wwEdFPMSrFv+tl0
 /KO5PLkZTMfiBgXfsQbeDwRF0Ik7XPEpxBmet+VuxarS/Mq22uioLVdxnKN3AqqbDB1o
 AAFQpdnw2Lt9CMQgbUG6jpdYatua9nkdnYzgluyX3tK+8vlCq2YhNrqOrQK9nhD+dqDx 9w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mIB0Nu7Z/KunNXpf1QksQh5Q49dzOVXAhqHUA53mzmM=;
 b=Plj/fS3ZYKww5vIV7mrMQXOzf1aN9wbQ73QR9XCWE3fEoQoOQCyLFRv+QY42yyVqyV3j
 2eS/rH4VxCWGYEpSJVnTCIsBdi90+fbjp2TLaVdIp+M1HTCY5/dc9gAZUhJ4AJM3eTE/
 /GvEBgahrKjAL8leyDI4HDQ396ZjXmoSuyX3O/7JsaWD64UlsgSEmcVd9vRvPRxbxy/C
 ULPXWFhwVHwAYUalmkfsPvz6RBlLqoiGoZVP4nIJYtjiOYsV4DVfy5rM+OWzpecPD9JV
 pGGDVwwPvmueHQWAwvYuAkjILGpJdXw+ctEx77h4NtFf1hYPXSyL9iT5H4/cYbdRGXUb rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1gwvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728Pp0x149816;
        Mon, 2 Aug 2021 08:33:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by aserp3020.oracle.com with ESMTP id 3a4xb4gay9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXvSLFm8AYJVQdFDIPP2qLvenMgorT3hKqHE4rhvCkcvk+rvJReDw9ijZpIdPmZExQuwz1cDy9FrvTmJYnbLWnK7KFW9JHNqA2ZFpIjn51yxi9ekDiCPUfUxY6jwA/znDWbYBEotyH3ankjR1Yu052BRUq3QFhZi7jJju5XZWs9+3RwzygBxaM8dQjQvTRnDn35GCfXR54pLZ1H1TVq6fIqTmjHah4fwwNb2ECGIr2K2h1BMieIxSgMDHz1O4UmXEmG+X82YAo5lCezGMKbuEekwC/FX/Fw9yT3d3zNOQ9RRJ0ATbE9fNwV/b2rN3fRcx7BZLzcIV3o34UgiRqMyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIB0Nu7Z/KunNXpf1QksQh5Q49dzOVXAhqHUA53mzmM=;
 b=JYvGpVAD+cKK57xXo+XQAhiwQIa1ba8vB8r9gX31eHMQixdteN4gU1wQith9/FTGpbw8v23bqFh2wqe7dK6y5TvJMd3h8JN8VlMtoReQhhsjkSdMwogD71KWg7/vMU1us5sFqueBq0wt8LoRYdRpRkyqHNnXtrwDBz4ou3oEVbc2LEYkS/hxHIO+edHjLsSHRP3KLQhPtPkcYAvwbhE3NfsOzPSC5irn+psr/NWLVusu6SfTvg9LLd5icRzMP1nDE4vBJco8F7Zc7t5Xx8eHdpd+59zTIXLLouNhjb0L5yZyv8Yjsp4CsCjpoewvBjO8CT1Ru2mmGUwyEQKZhgLULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIB0Nu7Z/KunNXpf1QksQh5Q49dzOVXAhqHUA53mzmM=;
 b=QNKqvNS9Fu3NGu8PLCm6JLvSV5fiTi+m4Z1exILfvy9Wq0z4At5o5/UaWRb5GVAR+205EZLWzGhlh0QTIlBRyblkycE309EPnHA9NRdMlsJLOEfPKlzqYFZLdJEi53NBRC87n+na5dvSKTyn9Ji2CCY7mgiqlcCpnkGbpnKkbXo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:44 +0000
Subject: Re: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-11-allison.henderson@oracle.com>
 <87tukb986z.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e20341e7-d36f-2043-b665-130a7fd2ecad@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87tukb986z.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:e::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0046.namprd07.prod.outlook.com (2603:10b6:510:e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 08:33:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8781bd9-cbb4-4178-226f-08d955903d23
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB548586B2CAE5C195FD5CB58D95EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoAuy9yhBmleygaUtNoM4KS5XLRAho78BXtRgiLSnw+L0fgHI1BcfTEJ+OuQv3gLfW3wM70MeYu+z3uWGr4Jfte51huyUrDfnbNeWzFLAuPkvIMfOfemM5rjZwTIfaFlakj4UgTr2/+C/6kiW/gxAG3ySZ5SOTTy4av9eKZ7Z5vLqlA0Q3BTAoWpWVbgjp6Hcu67k51MU3yl18Gfnck6vPZSpeMY1Fdt1WHo1C0sqOTO1gHlQ2JycE2Y0JrCEEFBN+p6gv34zKS95gteZ//ABrDUMk5rQRcsgenWlHppnP8SaX0XrpTnJHGWZYZDfZ/kEAXVRDpkzCoLcS7zOZWTncI4AF/VINBbcWs+GrDZsC/6Ymjcd7TbRvrGvR+1YIJsRXuEQLbkaElBt1il+onM7s7wyeqzQdGBv8BJva1EVtC6lE36WZsDckKeow3v5Ccn3hHvIvM4xUHa6Fkt512gTX8OaMbj7cELj1cPJJ45oUilQK/Zmb57po+HRv90jzY6iX1we2EhsA6CYC1bP6sYSc3YuGQbCkMilAemv3JGl4jqGTpcCCPM4+SCXKbOYEnNgnSx5Pa9MwtBfUExMQ3s3DGoiT2VjkZmTK8VnzZA5s/TZXaAbxs8eMq8XyEAAqAJFLKC/CTFfIgP+g0x6BIGG0Dw2cbSGdUS4SzCe6ssq3j6xH2R26jeUdtdkO0szhNa4Yac0N8TcmZnhIEYmi0fu2GWOoO+M5T3RvsoA9UnIZEz8sz8OCvpaa8qHsyyEUUO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnVzUHpYVHV6bDJGK3QrMExKcVBVdDV3eWszYlFlUlV2YndsL081YUNRVDZQ?=
 =?utf-8?B?T2lMTUhCQzF2TElmNnVYSUpZdjZUcWk0YWhKUGZ5WU1VT0Q0MjlhK2gxTHha?=
 =?utf-8?B?OWNZUEpOclJxNXA2OVliZ3QzbmFBandBcGw1S1BsQUNWRWthNnpzQjhqWUNV?=
 =?utf-8?B?YXBKZytkcTdtZG44VlpSWnNaU0QrL0hhcVd0QUVzZ1hOSGZHRGY1Y0lJSUQ1?=
 =?utf-8?B?ZlhVa2dYQWZBZDRMMDQydjRwZkVrWCtkT0R6R2ZSOXcvbXc0Qkx6R2NKK1da?=
 =?utf-8?B?RDAxYWUrQkwvRHdNQnZURkxoY2s5S1dKZVRRR3VaQk0wVVlXZFZVMFhGOU1o?=
 =?utf-8?B?WXVHMWx5Z2puSUhydU9WdkFlYXN0Ni95eXd2RVViU244ckU4OFRHNlc0QWhE?=
 =?utf-8?B?N242SUxvSlFBaUJQYndDMTUvT1dnR0ZFVnlQbCtEc0NvNld2VCthZ0ZiRi9R?=
 =?utf-8?B?T0Nhd1dpeGR4RjlXZUdGVGZmaUczUlFQNDBZbUtWZ0Fpd05kbkh0UFBmVGdq?=
 =?utf-8?B?MitNS1pwVXFId1JMQ0dRTmZwdUs5NStsT3hQYjZjRDFsVjQvT0VpTFA3M3Jz?=
 =?utf-8?B?ZlUxSmNtbFU2RklnVzFtMmthbW1hbWswNGh3U0lobE1LQkxIaS9KWTdDVVFH?=
 =?utf-8?B?Z0JxaVd5cllScHVhaEJRazZVOG5NTHNHUHk1UHozU0R3WWZ3YWtZYURBNjVI?=
 =?utf-8?B?bVZCVysxRGNCbUdmdGc3Zno4aUFmUk9jd2xpMW8rOGVNTnA4TkJzcFpOSGI1?=
 =?utf-8?B?STdqSGxaS0x0UWQrZFByaTFWRHdUVm84RGgxV2JLSW1yQTJsd0kvVmJoWTMw?=
 =?utf-8?B?Y0p2SlFtcmZiZmVyOXBRTHEvUmRqK1AvaE9uQW9EVlFRdTU4Y2NsVlYvVmh4?=
 =?utf-8?B?L0pSbkdvSnRqUkh0Z1Z5MXhFdUxUOXZMNG00RmR1bkNESWNRcitTZHVGREU5?=
 =?utf-8?B?NkpBQmFiUXZraGs3aHRETXNwZDFxYjhFQ3ZLcDhVbWpER255ckhDaUgrMWxC?=
 =?utf-8?B?S3J6ZjJCSTJVajN4UHUvK0MzOVNYc1hrS2dYM0xEbGt2L2hlL0xhWG9MTEJE?=
 =?utf-8?B?SGo3Smd6SFVYd3o2QTBnSnpoU29mS0pSU3pBN0g4Vzk5Q1hWbjNqeGFLL044?=
 =?utf-8?B?eDVJN0wydjBaMmMrNUtxL2VWekVDYWxRQTVFZjFFUU81bXRQeGZxck95aFJw?=
 =?utf-8?B?dVJpWmM2V3JPVDRxK25LT3UzZ05aVENGeklyeWhwYm52dWZVd2FUVDdvc2NE?=
 =?utf-8?B?eGR1THE0MVFRaEp4V0pIVHlXZWk3c29GdjhvaXpObDVIeVlRK00zV0I0NkhF?=
 =?utf-8?B?UkZ1d0lISXVRQUJHaWhTK012OTJJM1YvUW5KODdsUENjOW5oVkxNL3FjVXR3?=
 =?utf-8?B?UEZVbjRaREJDSUxQa0dJdElmMkpJQTFXc3hnMUwvOGdrTGJudVpGRXVkQ2hL?=
 =?utf-8?B?ZG5IcHNTd1dsLzREVlhnL0U0blA4Y1dZcU8rTE5DSFZyN29wcHZCSnR0bUxF?=
 =?utf-8?B?NWx4NDhvUlRYVjlYaVRMWmVLTHVPeXJqSHZ6d2tiYjhRZjZNYmJhelhGa3hJ?=
 =?utf-8?B?dFZzTzY4STMyeXJsSEtVcGtkY0p6eWhsVFRyaFFxK0FpZ2FIbkkvR2J2am1w?=
 =?utf-8?B?dHNreGFBTE5zZCtyTElEYS96TkQyR0kvV2R4WGpzL09sck1IUWNpVDZaSHFN?=
 =?utf-8?B?WG8yY3lmbDJNSFAycEdkc2srNkxiNm9ESnFsK0c5RWxsUmJZUnN2a04rU1J6?=
 =?utf-8?Q?b1IWP7k50XePrBU3fviHo+3a+H0tFV04rjBYwQH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8781bd9-cbb4-4178-226f-08d955903d23
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:44.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjkECHLOoIuqaBcg5CEJDhL1ejoJ9DwNtfnJ6wQ/44cFaJaUVQDnSJm0JfzeIkJpgLcIqVsfX333gC1fl9s+DTnSyy4Nq15yop5R5TCvUcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020059
X-Proofpoint-GUID: nhX0rnFm9pgkpp2m4tM2qoUElAel4VhZ
X-Proofpoint-ORIG-GUID: nhX0rnFm9pgkpp2m4tM2qoUElAel4VhZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/30/21 7:40 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This is a clean up patch that skips the flip flag logic for delayed attr
>> renames.  Since the log replay keeps the inode locked, we do not need to
>> worry about race windows with attr lookups.  So we can skip over
>> flipping the flag and the extra transaction roll for it
>>
>> RFC: In the last review, folks asked for some performance analysis, so I
>> did a few perf captures with and with out this patch.  What I found was
>> that there wasnt very much difference at all between having the patch or
>> not having it.  Of the time we do spend in the affected code, the
>> percentage is small.  Most of the time we spend about %0.03 of the time
>> in this function, with or with out the patch.  Occasionally we get a
>> 0.02%, though not often.  So I think this starts to challenge needing
>> this patch at all. This patch was requested some number of reviews ago,
>> be perhaps in light of the findings, it may no longer be of interest.
>>
>>       0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter
>>
>> Keep it or drop it?
>>
> 
> Apart from the issues pointed out by Darrick, the remaining changes seem to be
> fine.

Alrighty, thx for the reviews!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>>   2 files changed, 32 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 11d8081..eee219c6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>>   	switch (dac->dela_state) {
>> @@ -476,16 +477,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				return error;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series.
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_LFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -587,17 +593,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				goto out;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>>   
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_NFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>>   	 */
>> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>>   	state = xfs_da_state_alloc(args);
>>   	state->inleaf = 0;
>>   	error = xfs_da3_node_lookup_int(state, &retval);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index b910bd2..a9116ee 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
>>   	if (tmp)
>>   		entry->flags |= XFS_ATTR_LOCAL;
>>   	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		entry->flags |= XFS_ATTR_INCOMPLETE;
>> +		if (!xfs_hasdelattr(mp))
>> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>>   		if ((args->blkno2 == args->blkno) &&
>>   		    (args->index2 <= args->index)) {
>>   			args->index2++;
> 
> 
