Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7982C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0CA60F91
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhG1JBm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:01:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13630 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhG1JBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:01:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S8qAaE021762;
        Wed, 28 Jul 2021 09:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IeS4kLv2QWCAw5VDQyC0mRUBYZyR8i+io759U0mFbS4=;
 b=daKRRJr6XUAcJBZr73es8gwbHpenoGqY76X4A0Q2uA56pLm844eOJLiPnSe/Q3afApBt
 22Taj255wgpR3OrarbJc3lHsef8Mm0x5FVcUtF2jdIsHnKs+RdaeqkzkGQYcOME/cBiK
 gBxDLSh25g60nTfIIWaqWgIZ0zJzNPTa2WppSt6YXlPDKPidABgANcwykjhFpzIlqe3F
 SNB2tXIx3GlLDEpD0RTatK73PGocIJInr9XSPKUd5GNvlUN2OrN7qtASqmAYmjOZQQqo
 52+w7g9uv2gbrRwiHGsqJbh3Pt6EWln9+uVzAK95HUe9zgN4ftzZuhsLR2tSBBvtUYPQ mA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IeS4kLv2QWCAw5VDQyC0mRUBYZyR8i+io759U0mFbS4=;
 b=Id7m60JDW0LEXQieEx971O3wM/eGhIReB4Fdx7PVff3WHeJJTVSEg1m6zNxS2fFqBuck
 AeH4LjSTjRFlgoqwDDYzHDzDFceHCptPPYpZ9ONPNtH6DNtAZskiozqABt6zWwU0rcOR
 hGBND8gXcbuwLLhx3h217ftCq+iXYUk/J3T/29ufrLZbT3EY3KsZoV4fCjOpM8N6nCTo
 bIdKMXBKRjanzZA55HDe0rvG2arOrepZ/Y39iCj/3mX/1+LvJopRL8YKgR9SLB3RpQ4V
 FhbloXiRiw+2hq1F7TGqXo5OcdPNSXlu6p5PeSryXo65KVKx060eLxifMyT8a8JOqpvu 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2358bxur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S90oY3137123;
        Wed, 28 Jul 2021 09:01:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3020.oracle.com with ESMTP id 3a234x86r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:01:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ymhig7V+YFqCXhc76nnv3hd6EJepJF0MneomaJDpusbHK9f5mexAPuNE4w7xobq0qSTTx8Gsvom7Np1EDhhLLV6LoIQ6s1QyzTgesRJZv55GiQvj8y6880rBKKyhdk1oqoGkbozscoUlvCe4BJj8i0Ix9i5VJj7pHDzKOJ95aYk2A0yvVyYKX+/6VHYIPdQKGTtsPPngk3sRFQr3UnPJej1q8v5clfV/OKvFigx9nRZSauT0cvNobN/+7tFonu4iOmC5Yhlo6jZGF3eTIIgRC6Ve0a08FbacZp8mkrz63OBtJuEM0V/PlEdGs0WW1Cc4H2CZUqql9sm0xa0oSzfuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IeS4kLv2QWCAw5VDQyC0mRUBYZyR8i+io759U0mFbS4=;
 b=crZzBDsJJI8qSeh/iRQSH9b8VaSI+asT2qoNwITUrJzLIdNWuNY9cEMHzYwgWsgRAiKRDOFP9Fp+W86su/yZdZSRrWrKl8bXtz8oL9UVpk34JBy+j0H2uMaG1YtaJtWMA6qXKoT4ju2rb0Pf5uLdE2EZ9VraGWMW45AvIGTZjz5ywgRVPy+LaW4Sxqah8gkVEJmfOQzdgf6LN6FV/VIf83m4LM0IMxWEyckzy2Y6GeEpZNrdLQOifrv4YHE0lqpJbFjdsDMCcOhnFU3maKtRbuOSuIVji0JNdQz7ZwA8R2sQFssQrE2f2LQBhRp/wzgMFzunyeHdtvH1pUqsv2bhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IeS4kLv2QWCAw5VDQyC0mRUBYZyR8i+io759U0mFbS4=;
 b=oMvTQAoPa5GRJ/5S9/yDd10Q/UI/sqCNWPf0cdNb18siqSEPYBZQCTljv0EPRdgWZKVkFeafeORbk1WhRQSeGBIX4uSA9Cp28dcA78NEk+5CDmaHqAYN/REvPzzBoCXNs9iIzHT9QS4N7OYOny12a877kuDQVjyAx+0+wFLHFI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2792.namprd10.prod.outlook.com (2603:10b6:a03:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:01:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:01:35 +0000
Subject: Re: [PATCH v22 09/16] xfs: Implement attr logging and replay
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-10-allison.henderson@oracle.com>
 <87czr4f66b.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d93f7b4e-eee6-4e02-e59f-cdf10d143b32@oracle.com>
Date:   Wed, 28 Jul 2021 02:01:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87czr4f66b.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BY5PR17CA0005.namprd17.prod.outlook.com (2603:10b6:a03:1b8::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 09:01:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77fd6237-2581-42af-fb01-08d951a64d84
X-MS-TrafficTypeDiagnostic: BYAPR10MB2792:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27920C1C6F53370BF5D12CE295EA9@BYAPR10MB2792.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaiJ20fDEfs/zqoFtCe6fOTA9RAOToAic0TWhjjGMAruApNc2GkIODqQnX5UCerqPPwtdaUwVXRbYJauI9gX3pZE6cZd7j3+YDweJtDDdi+TDunbHOnU7RzoxTokwzun3OPHgeqwFY2i1Z3bozr3chvkEue53/dSYY2smBz3oAUImcbC6CFpc6c39DwQNI/qAOpzY+Mhb9xKV8EXOSLXOZ6ncri7CnbkgsEzoUUAmjjdO1R18esqeAoqjbRTQ3Xv3sTbS/iRT30/UipFjHehHtS2ypndymVBKqycCR/SionvDvSEuHDNZdSpNAKS6ITheox0vKYK0CfqCmks3Pbx4B6SxB0IxXMBZ/ZpWQRJDphgoqgYzEfFzkflstfFX6mqD40hEvBfGTTe00CmM8adPs0DgSDtqy6DLOtR96BaQcncPlLHmwzFROMjXgos3DPuyZTg/Y+lC6iwrbGQGHgJgfv4+qxco+IPmQ2q2+3CDjMU/gCbNLA3yDxchlTJvtT8SupQI1OxGC3YIj5Csmhfua/BxlVf406DRFlz8coHmz3X9g7t30Ts3ZKJR/2T9Z50C1VeFRyYqflFmxCnPwTLm7tBi394hNkEtRvT9c9hQEbpK02W7lylQohMcmXNGy0ZG6wMALSrR+yjnrgl68PbKrvHOBjQm+z5hwPXFh+N3e2rrly6skXo5e/haTB7LAs63muGu+Z49SCMsscZocYVkBeS7bInA7uxQJwNRMkRY+SJGFhVZB95/mGcQqSujvWlvbWkI/mBbd2u2xgTnpCFUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(66946007)(36756003)(31686004)(66556008)(66476007)(16576012)(6486002)(316002)(44832011)(4326008)(6916009)(2616005)(956004)(8676002)(478600001)(8936002)(2906002)(5660300002)(26005)(83380400001)(31696002)(53546011)(186003)(86362001)(38350700002)(52116002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWNhLytGdWt3VkVpQ29PSVJPNVhrWFdTM3RvcFlqcXF3NURhaGtmcFFjSmcw?=
 =?utf-8?B?a2ttTHRhSjdxa3Jzc05nZmJLZFN3QnUzZEdpaFo0WVppUWltdGZER3RjMWds?=
 =?utf-8?B?N3FpK25pN3dEZFB2ZW9TSVZBdFVqeVZTbmNRanlJM0xJNmhlTERxeVpoZjhq?=
 =?utf-8?B?Q21CNFhMaFFIeWx1QjdXSWpDUmlHQTl1eHJ2OEpMSDhSZlNTd05jMWwzaldl?=
 =?utf-8?B?b1VwMS8wQUZZdjFFdm9IRjhxdGJuT0FocWxCUHVrMnhKaFVVWGpaa1N1RzdO?=
 =?utf-8?B?VFFvSnZIbzQySXUzZ2hjTWZCMzh6eTNoTkZXRzJkY2lPUkFqU0gyMnBNbTRm?=
 =?utf-8?B?aTQ0ZWo0U1ptbWZMZWtRVnl6SkVIMFl1S3VGREtSb1dGcWhoTmhZcnMxRlFH?=
 =?utf-8?B?MTRoRldaak5OWUdOWGJ0Y3pHdElMZWs4clJqR254UDFWVWhoWm52dEV6TzUx?=
 =?utf-8?B?ZW50aHhDMk5kL0lyeUh0ejRJTlZkNS8yK1VBdGdEY0lYQ0pZakFpTGNPVEky?=
 =?utf-8?B?anVHSW9ob2w2KzRad1hUWFVIOVV1Snd5Y3VzY3hFcjFiVittWktOODhwTFNN?=
 =?utf-8?B?bTROdG5kdDdZcys0VGJnTVpnRXNwNnBOejMzc3V2SkJtRldyR1h1SHhLNWdq?=
 =?utf-8?B?UytZcWMrQVBvVjAyNDlqQk8rWXZ6TnJ2TEVxZ25QT2tzTHovQWsycEdhbVA1?=
 =?utf-8?B?dGRqWHgwNTdOMjU1NGVKODhTS1lSWEtxZ2hWUkR1NmVvVmtiVVBuZ1RpdGRy?=
 =?utf-8?B?cTNpLzBnN0M1cURZSTRNQXY4SkxwTFB2NGMzdjhsdms1Y3AyOGZXYWZHWmhj?=
 =?utf-8?B?bTAvZFN1Y2laSjc5YXdYT3NwMjlGTms0NFVBZU9KUGNjVVRxeFFWMEd1dVc2?=
 =?utf-8?B?d21jR2dCeDQwaFhzdlNLM004NHVEdHA1dng2RXBTcitVKzI4Uk5GSVN1Ukkw?=
 =?utf-8?B?d3lzY2RlNjJaTXlDYzJEY0JwNHNTcmNoSC8xSWExc1ZlZ3hWRmsxZjBpcmF3?=
 =?utf-8?B?MGdBQnN4ZjRoZHJjT0xLTkQva2tWMzBoMkRiRDc3WmFxVkJ4MERMeUR6ZldJ?=
 =?utf-8?B?Q0RCa3oxdzQ0KzFHMnBwNGNPcGFGK0h5UTRmeWFGSC83VDBhNjBsdTd3UFVs?=
 =?utf-8?B?MG5YdUpZVnUzZGVPSXpSeTlFb2JaSTh1VWVxNklHanFXSDhpRmc5UGMwOUlQ?=
 =?utf-8?B?VDB2OENBSnFzOXNiQk41amhhU0dYTjF3czZuWmVic0JJM3grbzlIUEhIN0Rt?=
 =?utf-8?B?cXJuMDZZOEMrMzdIaU9xdCtVMjhydnpiaE9UYlZtUjJuN3g1ZU5raVRJeFpT?=
 =?utf-8?B?bVBWVU5WQ1hhR01Pa3o1TnhUWTRHWWtwWHYvQ2RJU2toZ2RHVXVuWklkeFJt?=
 =?utf-8?B?WHd0YTl6alM0RUJBWUUxdHpKdm9BZTA0b0ExTmRLL0ZERm8vSmlGWE1MTEV3?=
 =?utf-8?B?cUZmb0dqaU5RVnhFbnFvWll1eDhpUW85bnFUOUNYRGVSWFNwWHVFRWkzWFdm?=
 =?utf-8?B?dkpYcDJpVkc5ejJYNlZsN1dJYjIvTUZBTVAvR3hMcVpLTXFYY1FkRy9GV2F3?=
 =?utf-8?B?bEZXajdTOTN4V2R4ellrRVVXYVZBK29VTi9WUUV3eHFrME83S0x3cDBhWFFW?=
 =?utf-8?B?Zy9DOUpiU0RKNVpzbkp3Z2E1RHRiSzNKOUFNZFZrai9LY016dWhBdFkwUHNB?=
 =?utf-8?B?V2FnUEhlWVRUWmx1RFFIL3RMNnRmY2VNVTdQOENQZGt5SWNxUitrUU0zTjBz?=
 =?utf-8?Q?0Paug5ntrn3EnGlDHSrD4Eo8Xc6ZbzAHCVLdd1O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fd6237-2581-42af-fb01-08d951a64d84
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:01:35.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CilDYe19ahgd9s/ZbulGoKOMytbqp+G9D1Mm3giMCDsKfKxRBmPETuK2+tA6n0l0oME2djY8my52Uu0FC2TmnypkhSIdF18AVvsoQs+cmNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2792
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280051
X-Proofpoint-GUID: JN845HLr4nrablpDhRg1CbWHfIBR1PXP
X-Proofpoint-ORIG-GUID: JN845HLr4nrablpDhRg1CbWHfIBR1PXP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 2:38 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |  10 +-
>>   fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 388 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 0ed9dfa..72a5789 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 3a4da111..93c1263 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
>>   		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
>>   }
>>
>> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
>> +{
>> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
> 
> The above should have been sbp->sb_features_log_incompat instead of
> sbp->sb_features_incompat.
> 
> I found this when trying to understand sb_features_log_incompat's behaviour. I
> will do a thorough review soon.

Alrighty, will fix.  Thanks!
Allison

> 
> --
> chandan
> 
