Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723DEC4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 17:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5661660FE8
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 17:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240567AbhHaRv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 13:51:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17214 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240517AbhHaRv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 13:51:56 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFfv0n001697;
        Tue, 31 Aug 2021 17:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5N/qRPs/R9KRXV1mRl3pEeua/SbLfn4G98BakyETNUk=;
 b=YZ0jaKZTVQmPMZukkZfEnQmwx95Il2bnj6+VbXflo5dyePrgh6sHTmOITxqPTeMOTzcc
 qw1zI17l8MpyO7M5FAFnlfyBBXUFk2fxMT+pU03UX6P3KBSLq+rQPn/MR0itDAzsrG7U
 +Pa0KReJtNwUGDVGeS27LzyYn4FOmxKPoFtVowd0CHa84LLGuTXklCcJN93A36amMqeI
 Fan2F/uK5CsyCZcvgJUTi8KEyFpdgSypyUS1c0pK6bbWarKCPE8jjO0fLRw2K3pZtZQW
 MUD9f5Cn1YVTUP6mb6X4Su5AWizutkY9zOTN85B0kmllHDOF3Ke27um1icnO9HazBV4b 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5N/qRPs/R9KRXV1mRl3pEeua/SbLfn4G98BakyETNUk=;
 b=yKavkkHTaHbCdwcuRcWpmAD2T4NFL26eGLIxqRQ5AWNGaqnH6oSvrxzB8vYTZf1bkDvs
 PZONtOKU7tBQS8TlepV7NkoiNnvsYiLHKhvTRC44+7fqfTTGQACYMk7PwdYp5GTg8ahL
 fBeLv5+h4QKOK2/zwjl9iuN5pjUudZe6no6M6lX5WReUCVFzRC710eNJ4nB+h/xlDHaE
 EzzZJo/Af+C5e370nVV/hr+rFJBxX5S/8b7q2C6jIhr+YyQUVTKrO0GtQft/VyXnXYN7
 PV2F0j5TB+Q1oYL5/hTQuBseZhHzl1vxqTS7g6fqRnvu1rJ0Z/cxnbOdjmHxTJGLtkmR Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedhxaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 17:50:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VHoIw8180888;
        Tue, 31 Aug 2021 17:50:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by userp3030.oracle.com with ESMTP id 3arpf4ted3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 17:50:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBVbC/XYNsuUFy9vBUEZQOFLGy/hPxFW9q0x8CtnOsmx51OnQg5SAujYHvxPcq8qbxtdXp7IrEJGuVMtBYBaqG+ne3jlooiKW7BRv26Fi4xlojbZO6WBfTFW13zJcpgLDUrwExbYQgikO7SYhaJuN54LNAa7xnXspMAmYB2fVTx7LCfkqGcXIb0D1U1U73JeEH8WfGF+QigcmPLqeshYKrrxNwoo+QtZPggDhjhN09719/jg/KBARfYcBI5DdXfgTA22Pz3upyAOBj+odo7FG+DwQuika2v1waHYm4n8Co51ia5OHjdRmwFF2Aiq0dwWjvz9LKtEPf8bLUgpNIk1fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N/qRPs/R9KRXV1mRl3pEeua/SbLfn4G98BakyETNUk=;
 b=b6RkRekUJUK5qQUB6ULYY1BoTYBzMLkywouG77oQpFA4G1M1eL6zckkzbc/bkavNkMnu5r5e2CUCj91m1un82F58KIUsQXHU9QZCH8qr8KTuFgzF2OTawdcABPUQs5VL1Iq/u1B8L1AP2V9EKUfClpC7suGKG7ywRsd7DMAwyPBymLxM6140GEJrZ5Gq5pn+dvzLX5HzDVchcMqnMb90WGxs6PmxtfOC5GYCK2DYWPxZ3ceST9z5xoXZnzF9cUzkGKwLoYIEtA9gP+NAb/e0bXi8kkH1Bd2R/azTd/oXrg5Oyh35cGDsDcfKCl6bwER2JlrBHCwsXX0ABgpJW+lcZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N/qRPs/R9KRXV1mRl3pEeua/SbLfn4G98BakyETNUk=;
 b=Woa/hhVe6/IN4huO9tSDaPfTuyKYE3vhFZzmu7si9VK60IKfxOcCb8Aj7fHQkE2BNgEhGfL5QXcY5dmytzc3+Mfa605VujrUGxiDf1UwoapG5zqsQupCM3+vm5ouywJUkMLfwNuc4inbBSLBRn/q7EdHzmfJU1QyBj/L7yry9RA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2869.namprd10.prod.outlook.com (2603:10b6:a03:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 17:50:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 17:50:54 +0000
Subject: Re: [PATCH v24 02/11] xfs: Capture buffers for delayed ops
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-3-allison.henderson@oracle.com>
 <20210830174407.GA9942@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <dce359c9-18d2-ad38-b951-d1cb98d7cc7d@oracle.com>
Date:   Tue, 31 Aug 2021 10:50:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210830174407.GA9942@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::45) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR07CA0032.namprd07.prod.outlook.com (2603:10b6:a02:bc::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Tue, 31 Aug 2021 17:50:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca40cedf-74b4-4b43-275c-08d96ca7e130
X-MS-TrafficTypeDiagnostic: BYAPR10MB2869:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2869C2B0E8F1FEA82FA9E58B95CC9@BYAPR10MB2869.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7AijeqEG+PhieoOpkriB9724rBE+UKyRExnCR3BEs4iLUgruNpPfRql+mJtAyBp7cKEroeOScWZJ1bvhm3HVKP0amypS2ROsroYkLXWeeuTP1hF579TWVrGr8P72hIeZOzZ7iM2cTK2FQH8Qi2M+pyt3AoW93QaBTHmp2BDPZWUly3TEVzgM/0N8GGSGNXbWbsZZWmBLwz/yYYfj6gpz0Q2prYdOk4/qwAZrV+mm8TliFsiz2vyAFjD7YSRilmRwrtc+EI0khH7RV6VJadcwd8BArGSxaSEv+8g5RFCgN63+dhdOEt2q1resUNFqqj27iZpasK/EZ6JYnidF5c70wjXsQUT3ua/2tGQp1BF/VaPVD9dzqzxrkR9cF1EvEoZbZCyZuLrwBM9hunHV+pvebgEIOp6YmJQeXIFQGF3UQhEB0uzTXdTaUj5dVICTIu+9KRThNfiSqv/Z9Vjfj7WLvOuRcyDGaJPxFqDKRq6nurPLf6FA/uEVjc/8wyygXL5FNyY/oh160LXGJLmUuVX8CGT8RFE7AfIqC4shKOifDtcKNCib69P7R6ZAqmUB1Tx1uNbJNHJv5aWAXqSoRqcCuqGGeCn2o/72UZRbSRaCOJDSLQuLZHJQRDg4db/sSdXH8Lh+hy8Fo8dApxzo45qWMNZqPx0mj2a+XspWA/yKfE36SGW0IIHJaY6oViDIKgf8MlBwocgUUuukSO6QhT6aCQIeqgqK9IyBEerRgeHwWrxJJy8go3rJaUMPar4nUwTsCjjq44wvtvjFZXT/xmmqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(66476007)(66556008)(316002)(6916009)(66946007)(2906002)(8936002)(16576012)(31696002)(4326008)(5660300002)(26005)(38350700002)(8676002)(38100700002)(36756003)(186003)(52116002)(86362001)(6486002)(83380400001)(53546011)(956004)(44832011)(2616005)(478600001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3hvd2x4UWpZTmFmSDNLMUZMM05IYkt4VThLY1lzVUducU8rMFdDdGZqVmdE?=
 =?utf-8?B?dDBRVTlvRm9reHVpbUQwcDhiSC9yUUo0bU5sRFJQWDY1VmZMU3lSNGZzcEtH?=
 =?utf-8?B?Sk1wNmRXdThDZnVEdEYyWkV6Vk14SldrUERobFVvTGpwTzF6NWFhSEFIb3Q4?=
 =?utf-8?B?cjJQL01jS2xGNEZXdTQ2RG5LaVEwMHh1OGlPd0YyaFdlaThrYkJIOXYrZnZy?=
 =?utf-8?B?d2htOEpKcUR3QXhxVkdMa2luNGZpeWlNZ1M3WXFxdXZLSk9vTFpTcVd0UkFq?=
 =?utf-8?B?cUt0REJJeS9WUHVWK1plRmpBSWs2RVp6WlNNWnFjcnR1bGZBTXJqR1dEZFRR?=
 =?utf-8?B?QitwaVlwaVMxdTRkY1BmVEFXeENqblgwZGxaaUhSLzArOHZyL0JJeVhYdHdN?=
 =?utf-8?B?YUFLWFF3SEJZRTFCWkQ4VFZXNWtrejdibFJyVEw4ZGx0Z01SUHkyZ2ZZSndW?=
 =?utf-8?B?dzB6MEVFLzkyY2prakx5VUNKcG9ESndiQkUza0RiRlc5MC9kOW1nQ3JxS0dv?=
 =?utf-8?B?WElnUzJLNExSYVZDamN1S3l0a3dZeGJTakF0bytxMm1KYXNnWXZ2Y05LRGRL?=
 =?utf-8?B?NG51UWduRVh5L0YydUZGSFJiSTAxU2VXeGMyZlNYR2pmV2ladklyNUxidEdx?=
 =?utf-8?B?b1JheXRWZ2VzSmFPMFBwc01ZTkY4L2x6NW5nTExZU2Z6a2dSK0JlVExWL1R3?=
 =?utf-8?B?T1RHSlBCY0VRaks5QnZsU1pIaDlqL3NnYmlYV2laWFB5bnYrVzZ0Q3prZTRW?=
 =?utf-8?B?S3FveWdYZW5ZeGZDUmRIM2VKZjZaRkt5cXZyd0xBY2llYUMwTXBMTmEybmgz?=
 =?utf-8?B?RTJpUVZ1NmJhbnNtZDN2SHdGZDN5Q05BMGpKRnEzZjhhdHZlL2pSamlIakpF?=
 =?utf-8?B?WUwzZVN2dk40MFZvU1ZmbmxjVXRKN3U0N1BGd2ZXT3FUdEZxTmFSWEFzNGkx?=
 =?utf-8?B?SnlBU1lvVHp4VGdMalFqWElFNWZ3N2IxMUtwYzd5WHdCS2xNWWh1VW11YnBn?=
 =?utf-8?B?ci9aZUZ3YkN3bklZbk1NOENiR21oeDU0NTQwU0NxZmZ0SkhsRHEvaVFUTXI1?=
 =?utf-8?B?Z1psZWZsYkRXVElFM0lqWHcyZW1NWUxmZVZWNU5IUnB1LzdpN3pEL2V6bTdS?=
 =?utf-8?B?YnZlb2piVlZMYlVHbzJwY1JCQmhJODgwZk5uT01EKzlOays3dU40eHJmRTJr?=
 =?utf-8?B?bVNyQ0N0eXF6V0JiQ1ZDc1l3enJETE5iVzZ0UXBuRTFkUjlQaG0yWmcyM0Vo?=
 =?utf-8?B?M21PSkR1WGw4VEtWamlnMGNIYWFuUmNqN05YZk9HTXZUUzRrTjN3L0lJSjdD?=
 =?utf-8?B?MjlqS2FqQ0FkM0RFamVKalZjbDEyR2dOTnBMT1Rkb29oa2hJUU1zQzc3eld4?=
 =?utf-8?B?V01ubnZ5TmdNZHdNMlhVTmZDdTBCd3dWNE9EbkJVZk1rcDNRSlpjRkRZYjJD?=
 =?utf-8?B?dXVMQmkxU1U5ZEY0Qzh6RklaWFl3TG1sa2grcmg5ZjZISTZQa3k1TWcxWVg1?=
 =?utf-8?B?ZW9ONXJDR0VyaGJLY0g2cVEvamFOSzdtUDlvQ09kK2ZGVWpvbEdId1hEdEp6?=
 =?utf-8?B?SHdWV2p3eVBKbi9Wd2VCcFBXU0M0RllUV0t3cWt1UThkNUN4K2FvdWw5SzFp?=
 =?utf-8?B?aDBCdnZiTXcxSXhrT3l0d29Pamg4ZGZQclErWWgrWVptR012UkJlQnhyM0pP?=
 =?utf-8?B?Q2RodlY5Y0JmTHErRXl1L2lodkxRRTlPRzJpSy93aFAwUFZXVUxjS3QxL0E2?=
 =?utf-8?Q?HvsW58Sa8aXWOBwwWGWVeUa6wXhyJnDERJIpwOw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca40cedf-74b4-4b43-275c-08d96ca7e130
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 17:50:54.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qn5LAgBUejOgEYePYugAqUnSMgiiIGjqvRNzyTL5ZGMPX+O0MLj2jX/5bl9xJT06V4br8keSHyLxrWg9RoRpQyAoor+Z1uvjMP6kHys/YPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2869
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310098
X-Proofpoint-ORIG-GUID: yiabzj7V2CK5EoXpNYCxtNt0dXrNV6sl
X-Proofpoint-GUID: yiabzj7V2CK5EoXpNYCxtNt0dXrNV6sl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 10:44 AM, Darrick J. Wong wrote:
> On Tue, Aug 24, 2021 at 03:44:25PM -0700, Allison Henderson wrote:
>> This patch enables delayed operations to capture held buffers with in
>> the xfs_defer_capture. Buffers are then rejoined to the new
>> transaction in xlog_finish_defer_ops
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  | 7 ++++++-
>>   fs/xfs/libxfs/xfs_defer.h  | 4 +++-
>>   fs/xfs/xfs_bmap_item.c     | 2 +-
>>   fs/xfs/xfs_buf.c           | 1 +
>>   fs/xfs/xfs_buf.h           | 1 +
>>   fs/xfs/xfs_extfree_item.c  | 2 +-
>>   fs/xfs/xfs_log_recover.c   | 7 +++++++
>>   fs/xfs/xfs_refcount_item.c | 2 +-
>>   fs/xfs/xfs_rmap_item.c     | 2 +-
>>   9 files changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a127188e..d1d09b6aca55 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -639,6 +639,7 @@ xfs_defer_ops_capture(
>>   	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
>>   	INIT_LIST_HEAD(&dfc->dfc_list);
>>   	INIT_LIST_HEAD(&dfc->dfc_dfops);
>> +	INIT_LIST_HEAD(&dfc->dfc_buffers);
>>   
>>   	xfs_defer_create_intents(tp);
>>   
>> @@ -690,7 +691,8 @@ int
>>   xfs_defer_ops_capture_and_commit(
>>   	struct xfs_trans		*tp,
>>   	struct xfs_inode		*capture_ip,
>> -	struct list_head		*capture_list)
>> +	struct list_head		*capture_list,
>> +	struct xfs_buf			*bp)
> 
> I wonder if xfs_defer_ops_capture should learn to pick up the inodes and
> buffers to hold automatically from the transaction that's being
> committed?  Seeing as xfs_defer_trans_roll already knows how to do that
> across transaction rolls, and that's more or less the same thing we're
> doing here, but in a much more roundabout way.
I see, I suppose it could?  But it wouldnt be used in this case though, 
at least not yet.  I sort of got the impression that people like to see 
things added as they are needed, and then unused code culled where it 
can be.  I would think that if the need does arise though, b_delay would 
be easy to expand into list of xfs_delay_items or something similar to 
what xfs_defer_trans_roll has.

> 
>>   {
>>   	struct xfs_mount		*mp = tp->t_mountp;
>>   	struct xfs_defer_capture	*dfc;
>> @@ -703,6 +705,9 @@ xfs_defer_ops_capture_and_commit(
>>   	if (!dfc)
>>   		return xfs_trans_commit(tp);
>>   
>> +	if (bp && bp->b_transp == tp)
>> +		list_add_tail(&bp->b_delay, &dfc->dfc_buffers);
>> +
>>   	/* Commit the transaction and add the capture structure to the list. */
>>   	error = xfs_trans_commit(tp);
>>   	if (error) {
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f71fffe..739f70d72fd5 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -74,6 +74,7 @@ struct xfs_defer_capture {
>>   
>>   	/* Deferred ops state saved from the transaction. */
>>   	struct list_head	dfc_dfops;
>> +	struct list_head	dfc_buffers;
>>   	unsigned int		dfc_tpflags;
>>   
>>   	/* Block reservations for the data and rt devices. */
>> @@ -95,7 +96,8 @@ struct xfs_defer_capture {
>>    * This doesn't normally happen except log recovery.
>>    */
>>   int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
>> -		struct xfs_inode *capture_ip, struct list_head *capture_list);
>> +		struct xfs_inode *capture_ip, struct list_head *capture_list,
>> +		struct xfs_buf *bp);
>>   void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
>>   		struct xfs_inode **captured_ipp);
>>   void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
>> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
>> index 03159970133f..51ba8ee368ca 100644
>> --- a/fs/xfs/xfs_bmap_item.c
>> +++ b/fs/xfs/xfs_bmap_item.c
>> @@ -532,7 +532,7 @@ xfs_bui_item_recover(
>>   	 * Commit transaction, which frees the transaction and saves the inode
>>   	 * for later replay activities.
>>   	 */
>> -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
>> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list, NULL);
>>   	if (error)
>>   		goto err_unlock;
>>   
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 047bd6e3f389..29b4655a0a65 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -233,6 +233,7 @@ _xfs_buf_alloc(
>>   	init_completion(&bp->b_iowait);
>>   	INIT_LIST_HEAD(&bp->b_lru);
>>   	INIT_LIST_HEAD(&bp->b_list);
>> +	INIT_LIST_HEAD(&bp->b_delay);
>>   	INIT_LIST_HEAD(&bp->b_li_list);
>>   	sema_init(&bp->b_sema, 0); /* held, no waiters */
>>   	spin_lock_init(&bp->b_lock);
>> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
>> index 6b0200b8007d..c51445705dc6 100644
>> --- a/fs/xfs/xfs_buf.h
>> +++ b/fs/xfs/xfs_buf.h
>> @@ -151,6 +151,7 @@ struct xfs_buf {
>>   	int			b_io_error;	/* internal IO error state */
>>   	wait_queue_head_t	b_waiters;	/* unpin waiters */
>>   	struct list_head	b_list;
>> +	struct list_head	b_delay;	/* delayed operations list */
>>   	struct xfs_perag	*b_pag;		/* contains rbtree root */
>>   	struct xfs_mount	*b_mount;
>>   	struct xfs_buftarg	*b_target;	/* buffer target (device) */
> 
> The bare list-conveyance machinery looks fine to me, but adding 16 bytes
> to struct xfs_buf for something that only happens during log recovery is
> rather expensive.  Can you reuse b_list for this purpose?  I think the
> only user of b_list are the buffer delwri functions, which shouldn't be
> active here since the xattr recovery mechanism (a) holds the buffer lock
> and (b) doesn't itself use delwri buffer lists for xattr leaf blocks.
> 
> (The AIL uses delwri lists, but it won't touch a locked buffer.)
> 
Sure, it sounds like it would work, will try it out.

>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
>> index 3f8a0713573a..046f21338c48 100644
>> --- a/fs/xfs/xfs_extfree_item.c
>> +++ b/fs/xfs/xfs_extfree_item.c
>> @@ -637,7 +637,7 @@ xfs_efi_item_recover(
>>   
>>   	}
>>   
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_trans_cancel(tp);
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 10562ecbd9ea..6a3c0bb16b69 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2465,6 +2465,7 @@ xlog_finish_defer_ops(
>>   	struct list_head	*capture_list)
>>   {
>>   	struct xfs_defer_capture *dfc, *next;
>> +	struct xfs_buf		*bp, *bnext;
>>   	struct xfs_trans	*tp;
>>   	struct xfs_inode	*ip;
>>   	int			error = 0;
>> @@ -2489,6 +2490,12 @@ xlog_finish_defer_ops(
>>   			return error;
>>   		}
>>   
>> +		list_for_each_entry_safe(bp, bnext, &dfc->dfc_buffers, b_delay) {
>> +			xfs_trans_bjoin(tp, bp);
>> +			xfs_trans_bhold(tp, bp);
>> +			list_del_init(&bp->b_delay);
>> +		}
> 
> Why isn't this in xfs_defer_ops_continue, like the code that extracts
> the inodes from the capture struct and hands them back to the caller?
Its just what was discussed in the last review is all.  That does look 
like a better place for it though.  Will move there.

Allison

> 
>> +
>>   		/*
>>   		 * Transfer to this new transaction all the dfops we captured
>>   		 * from recovering a single intent item.
>> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
>> index 46904b793bd4..a6e7351ca4f9 100644
>> --- a/fs/xfs/xfs_refcount_item.c
>> +++ b/fs/xfs/xfs_refcount_item.c
>> @@ -557,7 +557,7 @@ xfs_cui_item_recover(
>>   	}
>>   
>>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
>> index 5f0695980467..8c70a4af80a9 100644
>> --- a/fs/xfs/xfs_rmap_item.c
>> +++ b/fs/xfs/xfs_rmap_item.c
>> @@ -587,7 +587,7 @@ xfs_rui_item_recover(
>>   	}
>>   
>>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
>> -- 
>> 2.25.1
>>
