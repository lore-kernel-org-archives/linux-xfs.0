Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3588C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5926101C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbhG3JSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:18:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23124 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237992AbhG3JSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 05:18:00 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U9CHX8011967;
        Fri, 30 Jul 2021 09:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LadEnHvZ8xSeY1xT34UVZJQryOBJaTjnZ0Aj2W9Ue7w=;
 b=LS2npwXUIV0cc4+zBMArZthrTafte+zF3jDOHy43QprxmudbMCU/DqTHVe+l1Kc814q1
 Sfy7xk1Cc8YSChAwGPyUJtVoXcKMLtYwV2f1w7/jRcnX64gwgqkZVilxspJ4qBmVcdi9
 1EqwqM7UNJ6aUYB111yQ1//oO1xHMB5Xstx5zMoKeqkD+v9rEImdkhHaklzO0l9JZWeL
 0xvkOOB69SqBbQFrdlsHYxi4gW9oKUzOtxDMITWqx1n5NPWMpHs/cSy+zFeTnTn1sXci
 RZxVQhezsUrjEhQqT3Wq+Q896UQEpfC7GkOx7V0me7YtXBiJ/hA2GHhVM8nyjA+YqgJt ZQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LadEnHvZ8xSeY1xT34UVZJQryOBJaTjnZ0Aj2W9Ue7w=;
 b=HVypqWxUun0DHO4/OViclVT/JlFrl0BM5TofQzaI7d1c5Y5dk4vHlqjCoK4qMEaUo2aB
 rD+Vx56F2LpK4tuXHpk75FUQpLf8xOc8Ww90YZbaEOPVq75qG8ilXWHncz3rRs1SQWdg
 wqBo6YHWQ1Rs6/5zkDDSRxPXsgQgTMZ2ucq2/MGcXNVTSkVMzPryD/v3XeyIzNfdTDK3
 nehAYLjnwQNTSB9U0GE+5WO5tbnATVcm7fXKqCEVmf/uW4eOcG4WjPKyF7OmovGSA5Nz
 cIXfQDhchvGK4uBvlfwXzJ26pnXhide5/uR6DfgJW/37d/qhOJzRftW52s7DQ9qzmeDr qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a488d8nwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U9FYbd071221;
        Fri, 30 Jul 2021 09:17:54 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3a23596up1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAV0ODlbsaDqt7tUxnIXSDo44p571Fl5l26Qle/+sJxbG9bZXunzeYvJmK/1NabZRxofmax6m1EscE/oJwBCqS00lCepHZaZFtE4va94YKgOMHysAyWqJAKYGKixA0SF7vDzEpMD24VrGvNrkHBpeAlDerdvuL6BfGP08iuWJ2n1mEAUfNAZOXgwZS5pwnF4Qbfga0WISe1I8tz4cxmCfYcgenfyZNCDvqK4Je3hlpTmsmLHkOIS37QUI6S7Auh8W3csonz+hfoL+0bXyJgU8bdVOvj9fIZeP3MEMAv8IcG8+DHVINBEi44HiaPDxi1EFwVCyI7TgjLJIShp45lbxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LadEnHvZ8xSeY1xT34UVZJQryOBJaTjnZ0Aj2W9Ue7w=;
 b=PtebjegGtInn/FLkX4Xs39J+lRZ7z4CqDwoBGeOBXkRRJYFkeOj8IyrN7hr66CxajoNN4cFawoQ5Wc9IPnkAZI55qiBEitL+pxXt9L1aTYbS15d4Uq57xXW8Hw43iVA9bFbe93kfl7oA5EdILUqWR/+eOpbHRIZuEyOznnCGdzfU9PAwGMH5oM6ZOzA44C2P9IQ4f0h0YCT0VjPUDn58+4HjOSjl/bxOziW9YPeCicveagJZpYDyq4JdHdj3wQalPjq1ZhRFiHLXcuzo10dU6DExcQEQv4anGVjon4hRDoIE1KObenByvYv2hYCHyOlZkYfOFofkRWzbGD7bVZpj/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LadEnHvZ8xSeY1xT34UVZJQryOBJaTjnZ0Aj2W9Ue7w=;
 b=Okbs2CXfI6wYrGTV1PV1dVDKa8IeSrXTqeP6vTUyWb2aU4WxPWBTK5EhbkyJc/7wKDXMe+/YmvpZZXE83S52bPU4MwqzzTkAzITlOYtZznM8GOCkr6E67wq0Ve1Z477KOYzhU8HUGHkpwByAUg/9ka+u1koTmWsQOHmWr5/0M54=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3384.namprd10.prod.outlook.com (2603:10b6:a03:14e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Fri, 30 Jul
 2021 09:17:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 09:17:52 +0000
Subject: Re: [PATCH v22 05/16] xfs: Add state machine tracepoints
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-6-allison.henderson@oracle.com> <87v94uv9kj.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <3abcc9aa-14d3-5a6c-de4a-d84cb10dfbdf@oracle.com>
Date:   Fri, 30 Jul 2021 02:17:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87v94uv9kj.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0058.namprd08.prod.outlook.com
 (2603:10b6:a03:117::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BYAPR08CA0058.namprd08.prod.outlook.com (2603:10b6:a03:117::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Fri, 30 Jul 2021 09:17:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2340992-95c1-43ea-d048-08d9533ae833
X-MS-TrafficTypeDiagnostic: BYAPR10MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR10MB33849918CEB66DEA741FCA6195EC9@BYAPR10MB3384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKYcR2KeN2nsec6JSciu8mZtvs6nZ1jfCWZZD0sIYP+5tI8TdWToMN7ZX8a+Or0hDsuSSSoP04SX7UwYqtibu3wVHRFSC5tEDfN5wJlQvku+WKXViPYW1/8UWSHESPV1XmkNZ7tAZFUaRAMIWmYfmGAe8dBQcrLPAlefRfxSBXWcOBHEc4AEor9H/goRyZIscHdUSPA8RLif7+jwyrW2MDoBB4kuhSZRI7UPKy3R9N8PNawlb/PoGBGMj67x+VNasLugJKPFH//5XJwsgD/xZmAnqrwqq0URhLx5DO1hvXJ65ZjWMUwxXFzahBV3hMNSs0dLpg7tDQQEYSiYrWbLCxpKTRYYO6oPWYsfT2kTUlWlLmEmAPRzEo8mc5EVGppHVbBFUcqbkBCX4IwR6P9APdINr7hZtFHIaQk7KHDTAFqFKMkc9lwXNZP43pcx02Qdu/E9xZ09Ps/CULmfte9A67joimc9tPrMsE2EzOY1DCuGC2LywnMwdGk/dKmq0U57sqIWpM94ZCWl704zkOzTVSg03iYgNUO1BTc+DujFnFShR28iAeaAXDbVnkQ6pleqAEAiHho+1NbwrMWLT39veOQVWt4DDI5zDVGJWt33lxP+3exD6t/iTUaEjDyKy8EwBb7XEy3/SFMRAveQp8lQilkvIh+mk/SXbMOim+eohPXJ+L1o7KRvr2XzWYG0J7+Q/OAM9TWG2hiOMEJaGmTTROXbMf+4tf0E7hqNPw7yacthBEMymodykUYxp1TM0AcZINp+2fZyloCVMxRBJTfKBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(316002)(36756003)(4326008)(16576012)(8676002)(186003)(31696002)(66476007)(31686004)(478600001)(26005)(66556008)(8936002)(52116002)(66946007)(86362001)(44832011)(5660300002)(2906002)(6916009)(53546011)(38350700002)(38100700002)(2616005)(83380400001)(956004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWFrdjJqZWt4RzJ3NDVDb2RxZkk0V2tYMmpWKzdNa251b3I2YUtJRGJTallX?=
 =?utf-8?B?VHNuT1R4a2VCNmVnSEF3NXV1c1VqcU9DSnZ4UkdZNk1uRDJwMWw0VUFGenRi?=
 =?utf-8?B?Z1VOeEtQS2tVVm9HQ2ZyeGhobVlaS1hkV3B0VFRNSFBSOVYxbzc1Y1I3T1cr?=
 =?utf-8?B?YXA5Mk9PZ2NYNHF5V1h3Mlh5K0lRMGdpa29OQlc0UUZYOXU3U21UNVZnelZJ?=
 =?utf-8?B?NTd1UzZnSVlzb2xoOWpaZnZLYVMreC91YXQ4Ymc3Q043UlpRVFB6TE85TmZP?=
 =?utf-8?B?WWFla1lBZ0l0TlBvWFpybkhnU3dTckgrVGg2cnA0Q1AyYjB4VHZHd3cyelZ6?=
 =?utf-8?B?dzJHdEtiNGVrbW1KTHl2S25PVTltSUlzTXV5S0pZZXVGbzNhRlpQRTNGOWNl?=
 =?utf-8?B?T3VaQVFxVm9kbEVzZ2M0SjViWTgxV0RyUVExdGx1Z1JtZUFZVXdzTE5WK2Q2?=
 =?utf-8?B?Y3J3aERLRnUrNnhDSVlQSWY0V2UyWmV2cjQ0K0pPaTZCYmhPeWZ6eWlnNWRl?=
 =?utf-8?B?N3hKTEZTSUt5cmJnNnBmZHoyNlQxVmR6REtkejdEVlVJclBKSkJPaW5kZDBH?=
 =?utf-8?B?Ykh0d0lwT0pydEo5N1Rvb1NwbUFwSEdmMjh4ZWcvMCt4Z1Z2c1hCaVU3VmZI?=
 =?utf-8?B?YmNJeEFqZG5jZzl6NVhjSTdlM21La0JSRTBuODc1dHJac2hRQVp5UWtObmxq?=
 =?utf-8?B?ekkrWkRmZE1KTS8yZXFqdGplLzZFS1Q2QnpVRXA3WkNneTNmcm85c0o3WTFt?=
 =?utf-8?B?RmduOWFvWHlHQ24xMGN5a2FPV2dRTHRBUkhlcEFhb1E0UXY4N1ZFYk92Z3lU?=
 =?utf-8?B?Um9zTlpScmFhM0RZYnRidm83aVBVUHZPczRZRElGbjJ4c00zUVZKT2xKalNE?=
 =?utf-8?B?TTFmRytpSGRWUDlidk45cVhDTFdPYzNybFp6RmQwZUJMRmlyVDltQTNJamF1?=
 =?utf-8?B?V3BlNGtIZ1NYcjFsY2dtYUhVamRvOWVNekF3ckRsRXpRdWpZR1JNcFQ0cHNL?=
 =?utf-8?B?ZTRWM2Z3MlBhOU83cVB1MFN3UmYwMFk3Qm55R3dWcXNqSDBhWmpjeWJLaWUx?=
 =?utf-8?B?NXlVc2N5bGJZRllabmZaZTh1Ty96MDJ5RGE4VStYcmpoYWhxN3BYOFZaRm9n?=
 =?utf-8?B?VksrSk1Nc09SSmdsUzBpZW4rNURGcVR1U3ZwNVk2YSsyMEh2SCt3cUVBK2ZP?=
 =?utf-8?B?a2wyOHVyK3MybmJEd05pQ29jS0pwY29nOEdvUDdjUWV5dERaVFo3TkFBRU1x?=
 =?utf-8?B?TGdWTnlLQk1GN1Q0bGp2ZVkxVUFrWDVFUGdwYXZPbGIra0hZRlppYnc5THcv?=
 =?utf-8?B?VDA2d3oyeVRxV3JRdVZ5R1NBOEVnVUtVdmQ5YUc3bWw1azZzUEVYeEhFZzRZ?=
 =?utf-8?B?ZXZaVWR5bUdPcXE4dmY3TDZGT0lBLzdvOVdOc0ZxeDRoTE1LWVNWZysxeHpv?=
 =?utf-8?B?c2VFN2hjZTM5U1llNFpobGJsT3ZwUTlSWm5iOUZLU3BCdHRaQVQzUXFocU00?=
 =?utf-8?B?Nnd4Tk1CQ0xKNTlhSWFOSHNURjVTT3RtdEJxODU5azBOaHA3c2NrYnZBTXFV?=
 =?utf-8?B?QTRTMzJSa0RlSjd2TFMrQ2NlU29XeU0vd2ZOWG5BZEhOYVlQWXFQY0FrSWVQ?=
 =?utf-8?B?QzY3RElMUisybzB4VWF5Tnc0em4vY1p6ajNQTEtLU0c3cXBCZmw4MVR4MGVy?=
 =?utf-8?B?d3dKa3dKbWVSVjhlM2VHYXV1TXgwYWJrTS81VEdFVjdGMGtBRElLdEV4cDJh?=
 =?utf-8?Q?k2Qsf/T8tlA+M2kE/zuiC0+o7P45DnJvZlv1K/8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2340992-95c1-43ea-d048-08d9533ae833
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:17:51.9858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmmacRZHx874d+sweBPxW28OgatZcovTXfiwdTTtv5UbX8xLO042kMAC8kMJwJeoWGkPcu6xfT1mgleNOcBNH5gvTenZo/bOBvQoxsAzOx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300056
X-Proofpoint-GUID: zfY98-FAIpNMM8VoGsU7PKOIwGIrMxzz
X-Proofpoint-ORIG-GUID: zfY98-FAIpNMM8VoGsU7PKOIwGIrMxzz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 6:42 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This is a quick patch to add a new xfs_attr_*_return tracepoints.  We
>> use these to track when ever a new state is set or -EAGAIN is returned
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 28 ++++++++++++++++++++++++++--
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>>   fs/xfs/xfs_trace.h              | 24 ++++++++++++++++++++++++
>>   3 files changed, 51 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5040fc1..b0c6c62 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -335,6 +335,7 @@ xfs_attr_sf_addname(
>>   	 * the attr fork to leaf format and will restart with the leaf
>>   	 * add.
>>   	 */
>> +	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
>>   	dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	return -EAGAIN;
>>   }
>> @@ -394,6 +395,8 @@ xfs_attr_set_iter(
>>   				 * handling code below
>>   				 */
>>   				dac->flags |= XFS_DAC_DEFER_FINISH;
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>>   			} else if (error) {
>>   				return error;
>> @@ -418,6 +421,7 @@ xfs_attr_set_iter(
>>   
>>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
>>   		}
>> +		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
>>   		return -EAGAIN;
>>   	case XFS_DAS_FOUND_LBLK:
>>   		/*
>> @@ -445,6 +449,8 @@ xfs_attr_set_iter(
>>   			error = xfs_attr_rmtval_set_blk(dac);
>>   			if (error)
>>   				return error;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -479,6 +485,7 @@ xfs_attr_set_iter(
>>   		 * series.
>>   		 */
>>   		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	case XFS_DAS_FLIP_LFLAG:
>>   		/*
>> @@ -496,6 +503,9 @@ xfs_attr_set_iter(
>>   		dac->dela_state = XFS_DAS_RM_LBLK;
>>   		if (args->rmtblkno) {
>>   			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   			if (error)
>>   				return error;
> 
> if __xfs_attr_rmtval_remove() successfully removes all the remote blocks, we
> transition over to XFS_DAS_RD_LEAF state and return -EAGAIN. A tracepoint
> is probably required for this as well?
> 
>>   
>> @@ -549,6 +559,8 @@ xfs_attr_set_iter(
>>   				error = xfs_attr_rmtval_set_blk(dac);
>>   				if (error)
>>   					return error;
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>>   			}
>>   
>> @@ -584,6 +596,7 @@ xfs_attr_set_iter(
>>   		 * series
>>   		 */
>>   		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   
>>   	case XFS_DAS_FLIP_NFLAG:
>> @@ -603,6 +616,10 @@ xfs_attr_set_iter(
>>   		dac->dela_state = XFS_DAS_RM_NBLK;
>>   		if (args->rmtblkno) {
>>   			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>> +
>>   			if (error)
>>   				return error;
> 
> A transition to XFS_DAS_CLR_FLAG state probably requires a tracepoint call.
> 
>>   
>> @@ -1183,6 +1200,8 @@ xfs_attr_node_addname(
>>   			 * this point.
>>   			 */
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			trace_xfs_attr_node_addname_return(
>> +					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1429,10 +1448,13 @@ xfs_attr_remove_iter(
>>   			 * blocks are removed.
>>   			 */
>>   			error = __xfs_attr_rmtval_remove(dac);
>> -			if (error == -EAGAIN)
>> +			if (error == -EAGAIN) {
>> +				trace_xfs_attr_remove_iter_return(
>> +						dac->dela_state, args->dp);
>>   				return error;
>> -			else if (error)
>> +			} else if (error) {
>>   				goto out;
>> +			}
>>
> 
> if the call to __xfs_attr_rmtval_remove() is successful, we transition over to
> XFS_DAS_RM_NAME state and return -EAGAIN. Maybe tracepoint is required here as
> well?
Yes, I think these three are good additions.  I think this patch was 
written before those extra states were added, and likley forgot to add 
the corresponding traces.  Will update.  Thanks for the review!

Allison

> 
>>   			/*
>>   			 * Refill the state structure with buffers (the prior
>> @@ -1473,6 +1495,8 @@ xfs_attr_remove_iter(
>>   
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			trace_xfs_attr_remove_iter_return(
>> +					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 0c8bee3..70f880d 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -696,6 +696,7 @@ __xfs_attr_rmtval_remove(
>>   	 */
>>   	if (!done) {
>>   		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	}
>>   
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index f9d8d60..f9840dd 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -3987,6 +3987,30 @@ DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
>>   DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
>>   DEFINE_ICLOG_EVENT(xlog_iclog_write);
>>   
>> +DECLARE_EVENT_CLASS(xfs_das_state_class,
>> +	TP_PROTO(int das, struct xfs_inode *ip),
>> +	TP_ARGS(das, ip),
>> +	TP_STRUCT__entry(
>> +		__field(int, das)
>> +		__field(xfs_ino_t, ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->das = das;
>> +		__entry->ino = ip->i_ino;
>> +	),
>> +	TP_printk("state change %d ino 0x%llx",
>> +		  __entry->das, __entry->ino)
>> +)
>> +
>> +#define DEFINE_DAS_STATE_EVENT(name) \
>> +DEFINE_EVENT(xfs_das_state_class, name, \
>> +	TP_PROTO(int das, struct xfs_inode *ip), \
>> +	TP_ARGS(das, ip))
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>>   #endif /* _TRACE_XFS_H */
>>   
>>   #undef TRACE_INCLUDE_PATH
> 
> 
