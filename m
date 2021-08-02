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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E53C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526A5610A2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhHBITJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:19:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13850 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232632AbhHBIS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:18:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728BgYv031877;
        Mon, 2 Aug 2021 08:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Jk8HmYnFVS8UgGEALWE5Hb6hfMUZtZM/IA5wIGkaDXc=;
 b=r2Ni+gW9Wq8KeHrKYHFZBtYIMBOlffejGJ6dKaUmpnifAIq6VJwyikgO4wVjWQbw3mEQ
 0tUIqzI8qBrS/uvIjyRuuTV7IbQTBAw5mavDLYC/8g5JbxL1h1zsSpj6Q2cA0/Pr5XlJ
 I0H/9gHB1bnY9hgmuoDGZ7i9awUF9hujQn6CpSeIcIB5Ui03gtnSXzi3/QH49p+ZCx7c
 dn5cDYsqMGmQsBanxGOtOw4AVIQKyRbOUOylpvnfAvnSqu8p9rI4Or6FycvOJVt8Ik2Y
 yCcAVywomSSJY4o/S79BcQs6m99Lc5w66Lp6f6nzNI1urWmCEN3ceIMbo3eu/8/36IkC 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Jk8HmYnFVS8UgGEALWE5Hb6hfMUZtZM/IA5wIGkaDXc=;
 b=pKHBH7qARZ9tAy44r5Zqgb+LBoAnulXtPeBnJ1CVaT1b9npwc0cvCZOqNBB4J1iQOKXI
 IbT8CYigxBJly6Dn9azMXJUof5Bf0L/HJnONimo2rUG6qLN6Pq9emhrDdliGQVWhHl/c
 LpX4VLTmNz3F3L70hlDB3sfp3bJ0gAAoaPsEGTGAOODiqd8ew9Lmb8dbIqVwLOWQu4cG
 cCdCFAFAn7FfNR3Nkln9c6pZ1D20BBd6fsHF8ZW9IsKO4QdIorxm1PMuMvKsscNBzdOI
 I9POzswcYbThQLmdP2mKe/62/71nwthO2V0VZtcke6nYwgob2HGD5VGxjVz/KDqMHTuQ tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1gvuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:18:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728BC0w193538;
        Mon, 2 Aug 2021 08:18:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 3a5g9snra1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:18:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdN9zScsCYW30wWw+VSIbFGjV7Agm8e2Lym6bLC4+8TvhZ/UJMaXDwCZqB6X0m9SGbID3S3L2bYGskmCbUcpgmrZAwrIUNuABG0r9hk+81iL5QqSZgLKmWbtgKYxEyqMYpAm1T5X8ADETjtLedTNqsZbis4lb028gahvS7DNCzYZqbQbNw8VrIMpAisvOIv8WHs8dR4D/gyPOLHCABbm2Fi2FOyzssy21lCKy5hupWwgP6CeG4PZ9BXI/silBwUcH3WEAng4idkM2zMQ34/Ef6P8CER8fy6O51OHREkcYRq3icu0YpT0RTgGOiv8u7d2FczrR1LjSRrFMLNQhzXS/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk8HmYnFVS8UgGEALWE5Hb6hfMUZtZM/IA5wIGkaDXc=;
 b=JRRjYbwXzkwrJ0OQlvHcyw5eH/t299JqPivkcvWSlz3/wCSEOEEDFlnaMesbFxU1tU/qtuQb6npnRYiLtkZAptfwMlwTxOUryCHf4MGVcrseuDTRQ4txx4Vo+QVr3YXijaM3jsOnHZD2IZvbX72cct/Jv0rdf9Vh5qVFRjBmRDWMaGTyRA67H+YtBvPwT1PqGjEuPXpSMh3somur7pxRCErcgMsiKEv9UCb3FO2WIAsAzV00iBgqi3iJyXEXEeLkjzqdUYQbwhiaiaLPOqu4jrQ/+sOkiNXf+D8K9Xt8SMEi/QGYINsMJhG352duq+T9y9qk+JlA166gfM80mDVEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk8HmYnFVS8UgGEALWE5Hb6hfMUZtZM/IA5wIGkaDXc=;
 b=BnIo5Iv9G1qSIPuya5Rjz5H9tMrKPAbqKv9DqCMj770vH2ui9jWnTbhwFKt6QHw2hcsclBf5Fb1wIbg3Wbw4YKvG4pqjFWNQ7b3ZASgxF/y1yj47CJS2NiuVvkPHSu7tjdFYPisWeoP7a4kIc2PzXY10dlVdneN+xGdhV6lVuhM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:18:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:18:42 +0000
Subject: Re: [PATCH v22 11/16] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-12-allison.henderson@oracle.com>
 <20210728192418.GE3601443@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <21db6139-0599-f0de-2950-5e7b19dfae44@oracle.com>
Date:   Mon, 2 Aug 2021 01:18:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728192418.GE3601443@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0022.namprd13.prod.outlook.com (2603:10b6:a03:2c0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Mon, 2 Aug 2021 08:18:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d962458b-3141-4b4d-ec29-08d9558e2395
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48137E6C2D288292B090E5EF95EF9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Ub2f28dLYlV0qvp7M15Wh5IGyJeK8LvtMnDyww4rlG8D5dAnBpOHlnIS3OtfxQ+z61ucH4cFotj8x8eQCKi74IrNdAerEtHFL1YxD+9AKJM8eQ/afmcHavAserpwxNnR18NfMlnYULlBMZ8hcYFjg6VdIGfOOgouXKuxQmt8Gm/ZBcDtr0v/2qYNCgfF6C7QJwF4quPUf/7xzwKIQsTJUHgP6ajUx8HR869bajDLY0SGHScdLYwjFdKQCn7EORMj1dSZquV2Aj6wg+BPC6IbREAK8TB31+DXWDnigrxA7QEohajpehtk6CndA9toVTmMI+dR/TzlWsr/jt2d1/k6//b5RMYi/pWjssHcoaovCjNh6ekEHlAddySyaqpmyOfNvW9RESvNVTRbFv5kHUfpXi0fVNhFdUsVhyl+c9VISKIIdJ9Q14zwszvrjTSTAyIYdpGN8g7mOrveiY6mjZ7lb3GJIMEYE89P3BVdNlQG5MFkgLqXsmY0qal6ifDQXo9Y/Gs2l1c6IXfrFJKj0zHurDVI+5jOd9nLnevIiGLXqZa6mkSnLRGBUwkhPYr+T+Ch2qVJNth5NP22/mM5rE2LprlFZ/Fbv3Ycl7agkimOb8xtEwxmD/NrvE0BSDlcSuG+Y+0YkHymAm4Oqk/D3spR+9J3vv2fI2kk3hMhsUDrn7VoQr+QNhTzb/5a28aCQVGQxB4fd2resAQgBM+WqnxJC4Hctkm8nVoZU0R9iqIoZE5KNvTGhzibl+3fp+RJLL2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(31686004)(26005)(186003)(8936002)(2616005)(16576012)(66476007)(83380400001)(31696002)(6916009)(66556008)(956004)(4326008)(66946007)(38350700002)(6486002)(2906002)(36756003)(53546011)(52116002)(5660300002)(316002)(8676002)(38100700002)(478600001)(86362001)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlMvTFhaQSs4dkpkVVZMdTNhZk4wU3dIUVdUYzRJZ2hnVFBzc1djT2t3MDUy?=
 =?utf-8?B?OW5Od2tabFd4N3d3bFBzTElVcGNHZUMxTTdkWGU1WFVuV3NYN0JOQnhTektL?=
 =?utf-8?B?L1FBcUZIbU0wM2piTGJZc0JVU3dVUWNuRmFOUGFNQWFFeElYNVlZb1FtZU02?=
 =?utf-8?B?NTNOSTBob3dxbzIwOThES010VWx5eWprOFQ3OWg4S3g4WUVGdkpwNDJXWlZq?=
 =?utf-8?B?WUo5bjUzT0gzVG1FVi95UXRsbGpwZ0l3MTNYblQwWWgrbG9kUW9MUGVjM1Yr?=
 =?utf-8?B?UVVFdzdIL0pQV0dRdGxld2VvZWdPbVUwS0kwaE5lNDdkcFgyY3dXQTI2aDVG?=
 =?utf-8?B?dGtRTnRsK1BTT1ZjblZyWkY0cjRqNisxSkFwMWtIU3ZrZXRpTXVDczhvTXpQ?=
 =?utf-8?B?WmtodmwyVjl1WHRDcVJQWTZRbWp1dGwvNUJCVlNPSEd6WnFacFRYaExIdHJT?=
 =?utf-8?B?SGhsZG4xaEtuT1AvNUlyaHB4Mlh1OXhWUUIwZWt4aGlGZ3NLUUJwcGNDWUdz?=
 =?utf-8?B?TTI3Q3BKYzlKRU5sYVhtR1lLMHljUEh4WXBid0dMQUUwWkxWamdmNGFZcVJC?=
 =?utf-8?B?RjMwdllyemdWWGNFeWVUMG5uTkpYWGR4c1pKS3ZMQ3piUXR5cDZhQnhYRWMw?=
 =?utf-8?B?eitDQlYyNHJlZC9oenBWZ3ZQS0xyUE91UE0xNGR3RlFUczRGbTAzcFlaQS9O?=
 =?utf-8?B?VllqMDlLWnJBcnl1eE5vc1lTcWozRWtCMzJaU0JzMHJFby9MOWZkNXFYM2FU?=
 =?utf-8?B?Mi9xektqZGViOGxvWGkrTlNCK2loYjlnOFV2OTUxNDNHdW5mTldQbFlPb1FM?=
 =?utf-8?B?ZEpiZ3pxb3BPWk12WUFNZzNYc3RkL0krc3RsM3BZYy8zRCtxQ3F0Y3hKL1Ni?=
 =?utf-8?B?OEpEK1VpZ0V6OXZweUxTZGxoRjNsTXdrc3QyT1NPSXdSUXVYeG9OYjY4ZStw?=
 =?utf-8?B?VDdwZlMyMkhieXYwT3Z4amVrL2RPREZUcDI5STV0YURuTVl1RDZydVBQVlhm?=
 =?utf-8?B?TVZMNis2eWFOVGhOa3ljb1kwM0krenppRzgzZ0d3NzVnVnNNYTdXaTFIcU5O?=
 =?utf-8?B?SHNwc3IreHBQVmZOaGdVd24zeTgrTTcyRFJDdUNubVdyRlpXV21iL2tUY1VE?=
 =?utf-8?B?K29pNS9CZWk2SUk2dHR4TzlNUVhrLy9JYUxXVXljZHpxRDRSOWcxTGlRVDlU?=
 =?utf-8?B?YmpMcy8wYTRRZFUwdXFJSFZHSTQwTDMwaUhMVW1peUJRYXd5ZmZITzhOZ0M4?=
 =?utf-8?B?Vlc0MGpCanFwbVRMRUgzaGg1TUUzSXJGbWh3ekFybjdnRG95UzJRSkdFQnF5?=
 =?utf-8?B?eHpoUVdmYWZNMjNoWnlLTDAvdkd1c3NQcUNTdmFOcVFKZzlSTjBOS1Nlc1Ni?=
 =?utf-8?B?a1BnL2MxMkd3MFdEajZVdndLVUNCK20xT20ydUFWdWs4NFowcGcxdldTWEla?=
 =?utf-8?B?SWNrbmRFVFlOUmhyWUFZb3NqcFlNRlhiRUJZQ3ZyeHgzWFpXSDhKaGk4SjhW?=
 =?utf-8?B?ZUpxSWlUcjJhdFJRU1FLNzhJS3p4MDJ2UWt5WmZ3U0JrUE9YODZjcXZhMEZy?=
 =?utf-8?B?dzVkL3gzN2s1cE9oTlNKMEF6U2ErR3ZRMCthVnhNQk5iRVFOcldva1pOc1Zr?=
 =?utf-8?B?WHBXY3V3NnlHc3lZR3pnQXRIa0ZZWFE5Tnk1enROeGlvNENHdG4yZGJZM2hH?=
 =?utf-8?B?NHgrTFpuSTU5T25oTXR0SGFnTHd6Wmg4K3Y1akthSm5iWjJ1TGtsNVdPMkpB?=
 =?utf-8?Q?z3YLB2Ywn6njPlPyhY6ncP2qQnWXT051J7V/xZP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d962458b-3141-4b4d-ec29-08d9558e2395
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:18:42.1615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxA6aVINMUnkgbJa0PHApgh6W5LlPlP9d2JKIihs6DVyOYuJtxUouThBEbk95li9gjNFWNveq+zlVrcMJtjmq/av+lgIuNaNOedKuMp104s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020058
X-Proofpoint-GUID: 72WG2PZNSOFYtPHK1nFC6gG4Z2J61l_w
X-Proofpoint-ORIG-GUID: 72WG2PZNSOFYtPHK1nFC6gG4Z2J61l_w
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 12:24 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:48PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines set up and queue a new deferred attribute operations.
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
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
> 
> Subtle race here: if you turn this into a debug option and someone
> changes the value from 1 to 0 while this function is running, we'll fail
> to call _drop_incompat here.  You should sample the value at the start
> of the function into a local variable and use that throughout.
I see, will be sure to do that in the next revision then.

> 
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
> 
> Minor bug here (and yes, it's also in the swapext code that I pointed
> you to; apologies for that): We shouldn't print the warning unless the
> feature addition actually succeeds.  IOWs, move the xfs_warn_once()
> here.
No worries, will move the warning down here then.

Thanks for the reviews!
Allison

> 
> (That said, if the feature add fails then the fs is probably going to
> crash soon anyway so it probably doesn't matter...)
> 
> --D
> 
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
>> -- 
>> 2.7.4
>>
