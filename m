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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F2AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0190B6018A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhHBIdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5442 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhHBIdt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:49 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728R7oW008459;
        Mon, 2 Aug 2021 08:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=H+9u57YwTwltmTiUtKFdVKUZ3DGGMhT9RcSy4XEB2fg=;
 b=CDBbfNFjxX6XXqhvyfLejMqVUlIP2ugdnYXhy4/jJMUvLsrjAxkliHGGG5pH+0uszjfG
 dj0olPETnoBX7xO3WYHV02ETeAZgR1QVTAkIkwGUaiesnfiIlgJzGaTPSgOlSs9Dt/L9
 QncH4tfWRZPiSxgWO5G/YjZpi5FHJtC52chZjwPGYyjhgyL34Ap1Zg5VpDChwiJbr59+
 qpCNs1s8PNhiXero6yh7OZSNOet9yXx3YmE4TeX+16tTw9vXiaGjt34QWuyRidEosRzT
 HTLOm5gsP43o1HziQUZ6okb8kjMIr7rJMFdmvqfZQMgv9mLHBcBvBQyr7iUDT2P0cAYk 6A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=H+9u57YwTwltmTiUtKFdVKUZ3DGGMhT9RcSy4XEB2fg=;
 b=RWiaEpCeLPgcvJ0ybD8zcaKOKSU4ZKiZbCiGsN+X3escbk4ywndXEbyR8bfS2O7tEJ2B
 SbJHT6AF1FK1hINDwpX67/6uKDkvRt/67h+wCgztI5guQXlnh/nVo2xqGIFp6cZNVzOb
 s59sEvpKBTRDto9G0ZKnctqlK+MF/nWwBnTgO40GUwmZUwUR0Thkh8psp1yzd1t9ho1m
 jGzS3ZUsOq1YXLwr387qRr22qQEmviu+28uytRHuro4Tf4PaVS02jVj9DUT9Lt1CJtno
 8ysyGqb9h925f4t5HtmUgCXGqk5xoRHm1C9reB7ObQ8vOkwRM2GPnU/eFEIhiLAr+/rX dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a65vd8mk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728PI3S035939;
        Mon, 2 Aug 2021 08:33:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3030.oracle.com with ESMTP id 3a4umw8p0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laexm5L2Pc8TU8Jtsx2lM+I8G4dxP8RiuILlLcz35jA86a7Csnf6X/2TSWfWtBZM8oTboKlu+lqDEl5CT9FK0rEgsmXXb1Ov7ks2pj1t6v0E1qL9zXphGP4TsTPlGytb7BBMMiuCMtsXUyq187ueY+PE1Vkf7M2jWDnq17JeXdmsTKpQiPL/8SNC0x4wPuFUlwuSbIStX9SwwpbyPi53xTuplwBl/1FwlLf+ryK/a0UbgMODBdDLzocUGGuEM0CbWBbupnxC1hnE8ls3t+oOJsDOSXXIt82+kz5EvItVCoNICKtT2xPY5rsizGqySMTQlwkR0A4bhX6G3ifBQb2Pdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+9u57YwTwltmTiUtKFdVKUZ3DGGMhT9RcSy4XEB2fg=;
 b=RuqlPHefz9q/hUQIj+XJAha4A8JEOA++fRRDlXEEW3FMBRbgIxu5n+lxnzZjDUhfuYJnDI21HS7GGbGGFSP1qPrQyijC7pUVtQiziGNIN5pa3/52ZL+83L6VymBPxBXXaXLgZ8YvLrspk35d7Wb7wi3Bh61sDItnwc7AakPhSIg9nrqFGCvN4SecnTwMUlMVs0ufSMNxt4y7teKej4bu9Up6YGDVWQ+zLYwQYY1rpZwB//7fl0f0yzNbdNvONkdlLyxvslB7DYX1BxkNBu5nTtjQOUDOOdYPLD0EHX7bDC1P9aIyvgyy1ugXHeUDZ9vv7k0xETGylnQOlEeeEjYzjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+9u57YwTwltmTiUtKFdVKUZ3DGGMhT9RcSy4XEB2fg=;
 b=NraCnVDn5AWxA9Z01KHhfIdFXDGVH/RoYGc2XicaKTaYUfxFkk3q+LNFeaxHUo5ELJLpV8oHYpxf2HGttTj+rp7HYcrUhahWlABkMVItKjrZLgEKaSWFxJKud031P0OZKE/5fO1kUKJZ6b7SnysvMJ+Cudwp4zKjLukKa3IRxYc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:36 +0000
Subject: Re: [PATCH v22 11/16] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-12-allison.henderson@oracle.com>
 <87sfzv97ci.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ca1ee88f-28fd-2303-5564-fc36a25fb391@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87sfzv97ci.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:510:e::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0059.namprd07.prod.outlook.com (2603:10b6:510:e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 08:33:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f3f3b40-dc68-452a-55eb-08d9559038d4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54851623EEE791D90379F41895EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcyqjZFV+IgtmZEJ5c3QUcnCXdZfwYdBe1rdesogI075DYHycqXUCiH4m1RDbZmPGbkR7WN6jI9HeexCUeoCeit/dHdBLXNv2X2flDSYMIeTJoBuFLkxuu9uDpzDhdF2jr052ihM3bmOilJwFeCT/FqkEiXFouxcFTC/WDBpT0SSAxreZidQb+3EuZoqqIgV54i6lMxbOYoUnZr6E6JzohBm2z8Og+ARcqV0v3Og5tnMgMTEOwqxKS4WpuDXyoXHyjtRUxTiLGYcjnRyxQCHSdYFElUcns2kp3NoN4RdJoRv9pf5DBUAkafDXaHhDY8v94ph4WGFFwhb2WeanDiI17RXYKxkyKY+7gxu6qQCgLD8QrfUrXDxKQupPU2jfPpkiMa6ZrjxEaFmCdWuAg4nqpM7a8wTinZjEOldPhIGBSYRceABt9XEhq9WlWVJfZFA84i3K6XrtDV8TV41Yg7Xvrc0Cc6iv+UijTeNaS5jvHJ2daMD4aJiBid0ZgLhe1+4aVuWI+vMwF3YwdVCh1yhrwhWAk2ESCpzCDovx/6SKJp3jL1peypuJ7dxbpVvrBCiK07UVFoh41tFpVCSgCT7tDhKJOzUodL4JbkaxQIVm9VvptldNhQhhb+OSogcKrgCzYpjTpjleqpwKKOpf/hSN1sSDSl2EXPCSYIl3L6xWJ6lvxxE9NFL0L1UByqo59/r+mfBFbQPdgIY7VBHjstT87KnrcygnEv3x7ietGG6Mhk2CfNWPsQZ3/VwvGkb0ST6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFM1aGU3ejdxckZKajBNd1hJaFJHU0xCdGs2SmlMdFJTOFN3TFhmVGVrYlZE?=
 =?utf-8?B?OGJkY1o4MkVKbm5yYm9MVy9YZzBMS0t5NmJmL1prUGI4OW80Zm1xWWNyay9V?=
 =?utf-8?B?Qk1MOHVDVmpOQldtcngwem5sYjVBWFdZUzV4U0FreHduWTBQWkJ4TTdJY3Ja?=
 =?utf-8?B?c1VuSTdUTzBZVmo2bDhpdG83bE5NamJEVm1SUDlZV3hLbEZiaGptalpabVB5?=
 =?utf-8?B?OVcwVGF0VU1rZzlObktJL2tYZmpKMDNHcGhFZFIwWXBYeENrWnRpK0JzaHVu?=
 =?utf-8?B?S2RpcmhmVXRlc3M5eUNneDRMWjQvZWF0cXVlSHdQRExFUEF5UEVrSEdERkpK?=
 =?utf-8?B?SFlMN25IL3RlU25hSUJwOEp5d2FjV0Q0WjB5VldVa3BPM28zU1ZUZ2dMdUJi?=
 =?utf-8?B?Z00zRnBKdUxieWVxTk5TR3B3cWtLQXd1OFllakcxZWVzQjU4dVhXSTMwelZO?=
 =?utf-8?B?L2w1WGxldFY2R21JV29nWkpISnVwT0dJOFdVVEtaYXRaazMwOVBZWGYwSS9N?=
 =?utf-8?B?MnQyUjF1Z3lPL09aYjRteURRY3F6VkM4dXpMWVk1MjVEdXpUejdVeEZLUTE4?=
 =?utf-8?B?ak1zVW00RjVmSitEZzF0TURVR3kydjhYRGlxTXA0WU9jd1h6TFRtZ3laNVhU?=
 =?utf-8?B?c09XR0g5YnFFSzZNVG0vSzZTUjhJUzlLbzZhQ2dtRDlJVXJnWVVNT2VtbkZj?=
 =?utf-8?B?dmMwUXRmK0dNZHl3TjlhQTVyMDYzWUV6SXJCMWRCZEhVR091YVlEOWI4Titu?=
 =?utf-8?B?K3dpOHlIODk4MitvazVFek84Mmx2ZngrVU9YWm01QXRQeld1aWgvanpsMU91?=
 =?utf-8?B?QXRUU3JFWnFjV2lsemJQMmZoZWMvTFV5T083VDdkcGs5anp4R0t2R0VzZEZm?=
 =?utf-8?B?OVdoZDlGbFFvVkE4ZzhJUFNPOTdmbkx5a24rdXpXN21CbTJOT3hIZlM5NXNj?=
 =?utf-8?B?ZG95bjR5SDEvZm4zSmJlWThKZDZEUXZIdFJDa0NxMktmc1J4UEJScEZjWTJP?=
 =?utf-8?B?cTF4OHE0OVhVdGJudFRrWEl2bW1iWjZmdjVlODV1UVlnN3Fub1c1ZUhPWGJD?=
 =?utf-8?B?Z3psWVd2aFNWWnZ1MzV5SkcyeVNNcHMwUjBFWnRCRTBlNUQ0REZzcjRKWXRU?=
 =?utf-8?B?eXBsaWs5TGJOQ0oxRlBFMnB1RnRpejJ5R0doTDhxNk8vVCtyMVpad0cvL0ts?=
 =?utf-8?B?ZHdORkRmaFE2eEQ1VFZBZTlUQ3RuR2tGV3luZTNzcVhlcGdnTlQ3MnJZM2JJ?=
 =?utf-8?B?R01WMzNmQmF3azRmdWp2Y0Vad1VzZXlZZHpVMytzSThYc3d3b3Y3ME5SV0N5?=
 =?utf-8?B?YmhpL1o5SVZHcGs3K1hOWnUvZjJ5b3c2aFNZUC9vU25FL29keWRGSzI1RVp5?=
 =?utf-8?B?RmJDRitJYmhWYkNqVk04SHNGTCt5M2s4TktBWUFVZGJOM1B6ZEhUYzgrYXgv?=
 =?utf-8?B?YXR1R0hXVGsxa2RxRmJyZ1EwM2tSQVd0QzlNMnVuWFFKeDBEK0Ztc3pDOE40?=
 =?utf-8?B?NHBqM1dNK2hPRHY0cFdFREZLZHdYc2JTR3I5V0Q1MU11eHhOMzRhWFlaOVZu?=
 =?utf-8?B?TDFjN1VyREkvTE9SbUJ4QVc5YjZrK2FFSTQrNWVRWDg4L3JkL2VNeUw5Ry8r?=
 =?utf-8?B?MFJ4ZG1uSlFucksvZ0tzaDd0TCtwRVdqSEMvTXN5SXl1UFBKQmdTU1hHcVY5?=
 =?utf-8?B?T01rNXZvRUttb0R0YWl2ZHdOU1Mya0FDN09sdEhHN090eHZSUDJ2RVducFVM?=
 =?utf-8?Q?922YCIzmcrq3KvRG3FpNaCDjIUiaySC2OWx1pHc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3f3b40-dc68-452a-55eb-08d9559038d4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:36.7921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXSUW/PBZwUAIZwkxYkRuVPcjpDVC0tk+nZuDa/AitD296qM/Hfr/40xVoB9YakPU2aR9YPu4Cjvm913DZXQWqWy1AwoHET7C2C9OJlmYsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020059
X-Proofpoint-GUID: FFBTRiDVB_ZMAtxs4ddU52YlGzAgkHPj
X-Proofpoint-ORIG-GUID: FFBTRiDVB_ZMAtxs4ddU52YlGzAgkHPj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/30/21 7:58 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines set up and queue a new deferred attribute operations.
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
> 
> Apart from the issues pointed out by Darrick, the remaining changes seem to be
> fine.
Alrighty!  Thanks!

Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
>>   fs/xfs/libxfs/xfs_attr.h |  2 ++
>>   fs/xfs/xfs_log.c         | 41 ++++++++++++++++++++++++++++
>>   fs/xfs/xfs_log.h         |  1 +
>>   4 files changed, 111 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index eee219c6..c447c21 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -25,6 +25,8 @@
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_attr_item.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_log.h"
>>
>>   /*
>>    * xfs_attr.c
>> @@ -779,13 +781,19 @@ xfs_attr_set(
>>   		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>>   	}
>>
>> +	if (xfs_hasdelattr(mp)) {
>> +		error = xfs_attr_use_log_assist(mp);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>>   	/*
>>   	 * Root fork attributes can use reserved data blocks for this
>>   	 * operation if necessary
>>   	 */
>>   	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
>>   	if (error)
>> -		return error;
>> +		goto drop_incompat;
>>
>>   	if (args->value || xfs_inode_hasattr(dp)) {
>>   		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>> @@ -803,9 +811,10 @@ xfs_attr_set(
>>   		if (error != -ENOATTR && error != -EEXIST)
>>   			goto out_trans_cancel;
>>
>> -		error = xfs_attr_set_args(args);
>> +		error = xfs_attr_set_deferred(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>> +
>>   		/* shortform attribute has already been committed */
>>   		if (!args->trans)
>>   			goto out_unlock;
>> @@ -814,7 +823,7 @@ xfs_attr_set(
>>   		if (error != -EEXIST)
>>   			goto out_trans_cancel;
>>
>> -		error = xfs_attr_remove_args(args);
>> +		error = xfs_attr_remove_deferred(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>>   	}
>> @@ -836,6 +845,9 @@ xfs_attr_set(
>>   	error = xfs_trans_commit(args->trans);
>>   out_unlock:
>>   	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> +drop_incompat:
>> +	if (xfs_hasdelattr(mp))
>> +		xlog_drop_incompat_feat(mp->m_log);
>>   	return error;
>>
>>   out_trans_cancel:
>> @@ -844,6 +856,58 @@ xfs_attr_set(
>>   	goto out_unlock;
>>   }
>>
>> +STATIC int
>> +xfs_attr_item_init(
>> +	struct xfs_da_args	*args,
>> +	unsigned int		op_flags,	/* op flag (set or remove) */
>> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +
>> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
>> +	new->xattri_op_flags = op_flags;
>> +	new->xattri_dac.da_args = args;
>> +
>> +	*attr = new;
>> +	return 0;
>> +}
>> +
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_attr_item	*new;
>> +	int			error = 0;
>> +
>> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	int			error;
>> +
>> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 463b2be..72b0ea5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -527,5 +527,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_da_args *args);
>> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>>
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 7c593d9..216de6c 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -3948,3 +3948,44 @@ xlog_drop_incompat_feat(
>>   {
>>   	up_read(&log->l_incompat_users);
>>   }
>> +
>> +/*
>> + * Get permission to use log-assisted atomic exchange of file extents.
>> + *
>> + * Callers must not be running any transactions or hold any inode locks, and
>> + * they must release the permission by calling xlog_drop_incompat_feat
>> + * when they're done.
>> + */
>> +int
>> +xfs_attr_use_log_assist(
>> +	struct xfs_mount	*mp)
>> +{
>> +	int			error = 0;
>> +
>> +	/*
>> +	 * Protect ourselves from an idle log clearing the logged xattrs log
>> +	 * incompat feature bit.
>> +	 */
>> +	xlog_use_incompat_feat(mp->m_log);
>> +
>> +	/*
>> +	 * If log-assisted xattrs are already enabled, the caller can use the
>> +	 * log assisted swap functions with the log-incompat reference we got.
>> +	 */
>> +	if (xfs_sb_version_hasdelattr(&mp->m_sb))
>> +		return 0;
>> +
>> +	/* Enable log-assisted xattrs. */
>> +	xfs_warn_once(mp,
>> +"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
>> +
>> +	error = xfs_add_incompat_log_feature(mp,
>> +			XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
>> +	if (error)
>> +		goto drop_incompat;
>> +
>> +	return 0;
>> +drop_incompat:
>> +	xlog_drop_incompat_feat(mp->m_log);
>> +	return error;
>> +}
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index b274fb9..1e461671 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -144,5 +144,6 @@ xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
>>
>>   void xlog_use_incompat_feat(struct xlog *log);
>>   void xlog_drop_incompat_feat(struct xlog *log);
>> +int xfs_attr_use_log_assist(struct xfs_mount *mp);
>>
>>   #endif	/* __XFS_LOG_H__ */
> 
> 
> --
> chandan
> 
