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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197F3C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9E460F25
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbhHaSNR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:13:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39560 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234154AbhHaSNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:13:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFfSBQ001700;
        Tue, 31 Aug 2021 18:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TN2Gkfivk3qRqfTajpOzhlrlhV7jJ4tGaunWBfeXjTM=;
 b=rTsJgDRn9EIH2ItAMIpQLrSZHFCNupdhO9d9rpjxTcL9o0fZMkOTuIl3gT+0nphIml/B
 +MAa4jJHrpEoCwANLNFVmlUa+MLRVXQPjNmtrgVusys4U5NrKhiLYsnoBXjv39hoCy/p
 eUsJMxFIfq2s1HSuKB7ITh/wdjA9up3g7MKtsvXUuINAO0DsJEcx3dqrsq+fdtYsqnPR
 Exzx8wzlBZvOf9d4j5FqagDRv1aC0YTvHS8bidKvQvyIZJATPALxIGZ64GqiY+HEIobo
 Rodjcu/AvRrllcdxpqn3Jj4DL5ntFNGltMA7HwVRyjPQhWWF2ubwHrlodSJkyO8wt++p mQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TN2Gkfivk3qRqfTajpOzhlrlhV7jJ4tGaunWBfeXjTM=;
 b=c/QJdoKnsbRvqa6vELHNb6tN8gsHfrYAHNUtio0ML1GE0Q1sGhK+6FfGzKPxpPV3yTJH
 VdnviJ+l43c/B38ML3QqB36rHqHonnlH9KfSJQjN6Jmzb8vBvUtS2TEvSQqQLp3g9tWr
 Q4S17H2jkqXEr5P0zxdk3LJFaIiJc0/YKGilm0jlG1/CTtc+8G+p9L2AJfmvbVeUmzwp
 6ubo8GcrXL38aBIfZRstiholMijocT9QxbTxPbKU+IqYkrKt4f3HpxbTUl68si2b3j5n
 6ZRTD/ZOeiR5AxFaAYlygHfhs9HzpEOFGk59qOGZalLnFXXmIUxNgWq7wRNIKOXB6Doa Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedj0jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:12:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VI9qTP092390;
        Tue, 31 Aug 2021 18:12:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3aqxwu0hwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:12:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TywIgeLWhtdJNzgbRHQYlvB7b+BVRc31mhZeVygJAlivNUMiW2uPMt+Nkv7mpRq4iUHVVj3bC8k7gzJd2+Mozc5Eshkqc7d8zugLXYqJt9D10a+jY52N9F3Wy6mw6bZsMuA9WEm992c5h8ChiOv0ZbeJijGdGNRoqH26Yqgw9jIfnnI55r55V9WwEJcbn9m/nZ5pg3lTOFPD3UL8N7zomqabGcMfF1V8Ekckn6gQ/KgqsaSJd6wL73iC9VcLr8EJa9QvjvbVFNEf+uBRRL0Zf7LCRtTf/5INuhOQ2KIPR7KTnhCvc6bYpJi5w18srgPpFt+AQtwgvUF3fEIymSG5og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN2Gkfivk3qRqfTajpOzhlrlhV7jJ4tGaunWBfeXjTM=;
 b=KfxAVcuPiITFEJA4+EWjpggsMeeuqVKbmWhjk+XKRe/pM8NEPovy0M6nxF+b9nn9r9lmaFmiuvZlECwY9til5hnVNqde4VXHVIyrlmYTDqbqFWTAtZGg7ZBLdiI52Pbl8RQsSQ/3/WJOBehA+Nq7wKeb6vPeRpFP0FYB17SM2DLBovZskObTbDYFArMiAWRrAvswSGY9HF0kISGevF5ABc6o0b7C5git4Wa8Ysr1jEnx3oVq8TXTE99V+MPejpqCIZaBTob/ovrTzsNM+ReRBJJHui+fMaeJH0/hWj2XSVmyWzq90gD34l3BFqnc9bPDn8t3J1/bNBjVqrLddo13kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TN2Gkfivk3qRqfTajpOzhlrlhV7jJ4tGaunWBfeXjTM=;
 b=RE7NYqRdH/mzujB5SogH1P0Q4IwiIAjHN5mIHEZ4if7VtjaK8HDkAggf1n2V88FkQyaFW8vJFDHjLufSMJBGOTSZKbN+FUNJoPOJjQ+Jl4zq3SD92W12wSVSMWdb2wyq077cJq9LmYG2gqQ6RJE7Dm0HmmHts/X9T5IB3X9kdS0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2566.namprd10.prod.outlook.com (2603:10b6:a02:b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 18:12:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:12:16 +0000
Subject: Re: [PATCH v24 06/11] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-7-allison.henderson@oracle.com>
 <878s0j9qhp.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <cf95e485-34ce-c6d1-6e60-90e981c607f7@oracle.com>
Date:   Tue, 31 Aug 2021 11:12:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <878s0j9qhp.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0144.namprd13.prod.outlook.com (2603:10b6:a03:2c6::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Tue, 31 Aug 2021 18:12:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13e5724e-dcd4-46d1-5a48-08d96caadd15
X-MS-TrafficTypeDiagnostic: BYAPR10MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR10MB256666B05B110C91805EEA8A95CC9@BYAPR10MB2566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:390;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnKP5K6eN+Zn80z6juPLMLCnbC5OHkUJBUHZ6lWMznJRKnWWVc6qubTUI80rgkDJ/SK5sOh6m0hdVvUpPDyXfNWH0djiziZWrdxvVcjBJ2Og0KnkrcLEyUiAa6jDXxcJVek5RnouVr57/Jkuz6Us0XJuRsTayVlkXUlJctJYUb9sTQAdC+pv4hHsipdZ8jrAOqhcx363rZD7P8SOx/kLNmebO/yWnUXU3qHNL+S1O+BMsCh7oIXLuDKCaBvcxpLopM7+eD3f20rRWlf5KJZwbl+JQiSYQi1ST5ZjiecNPGiAGL1vJqZUNyCbiOsr4hfxPltdgVz5p7mIo4HCm9pN6wcelfOXLzsUycE4ycC5w7HFLov+t4HwDDi33CczxGkhEPEz6t1/r/lICL5AhAnp2SmMV0rdwI1e6nFSD77BTHgkiFoAGeJU+Uvsd1gwb+MET2uzQJvCBh5PZWjY0Zyyt586SSH5bD/mcKuQReVbq6aXhwx9whff8TtWfaAzkw8VIBxuOl2Lty0SKH4sFWa8JulZhE3teFZiML2shluhITn/rzbFHp8bWl044zScanpMfIt+h5T/t1cC6LYnbtNaEwtI2zU2cWnY5LBqTSdx5cuhLvNS7sUu0dTaLKOsAOEmoRToSEQ0qAiv/U1Y4+XIZH/ZP9d5QDt6VlJCcf6qryAtq/zBpqe/07G9VoWqUWsipJKQgdHXnT+eeGdJss1IvyD/gmmfcMsxJelEwFhJmtlD54jgBK/A133MDBca5UUTL2Ml08J73651oB4Kxe5nTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39860400002)(346002)(478600001)(36756003)(86362001)(8676002)(6916009)(6486002)(38100700002)(38350700002)(16576012)(44832011)(956004)(66946007)(2906002)(31686004)(52116002)(83380400001)(26005)(2616005)(31696002)(66556008)(186003)(316002)(53546011)(5660300002)(8936002)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z284YUpwUmxST3h0cWpMWTA4bXVrSTRGM3dZQkpMWlJEckJFSTY5SVhGQUFO?=
 =?utf-8?B?dUFHTlIxbWhlQzlLWmZZWmlvL0NYWXpJUFN4QzhBREpjSkgzOHJLVEJ1dW5Q?=
 =?utf-8?B?ZVpPQS9tdjlwTXA0VCtDcjZWcS9tdVFXZGhKRElGTVQrZ3FDNUx4NkR5TjdO?=
 =?utf-8?B?V2VPUVl0WWQ3VlQxWG9LOEp5eFNMUk9vUzlHN2d4eVduKzlvVEZtUERGZ3Rs?=
 =?utf-8?B?NVJXR1VZblVzWXBlOTBKSytnbDB3dFpHVTdiYy9tT0VrbG01NUhzZDlETVNK?=
 =?utf-8?B?K1pMV2ZjTXU1aVFEYytvR2xqalRva04wdVB0TW9rcndmbXowNkpaVGpDWkQ3?=
 =?utf-8?B?U25WV1NHRjN0M1kxS2sxSEhZd1J2MHlBU2k0NXhyaUZVcElleU1kZFJJamN1?=
 =?utf-8?B?WnBjcVFpY1ZCYnorM3FPcTd4ZjcrMG02RVBWVGVtbmxJQ3hRQmZVS3UrYzRt?=
 =?utf-8?B?RFU0aC9ISkpWMVRJRFA1aXYxNTJ1TTJhaW9Wazc2QmVWLzVkN1hwazA4dTc3?=
 =?utf-8?B?WmQ3VDNIY2tWZ1d4NXpWOUZMbVMweHZyTkhqRVIydlZQN3FmUlFaZ1kzRzBo?=
 =?utf-8?B?VDVmQmswTWhzNnpxNXlhUm4ya2RwYktMdmRLcUJUQnBNNTFmRnpNU2wrQjRQ?=
 =?utf-8?B?bmtXcC9LNkc4MzFBRC8vbVpuRU5NZDlLVUVVRGFFZ3l5cVB1RlJnTjN6cDJi?=
 =?utf-8?B?RVBaV3VQSWxDYUVITm9IU25tTHVVSy9FeHhvMGk1SlgrOWxCTTJlbXdwVEpG?=
 =?utf-8?B?cHl3d1ZCWGVHeDZtMGRVYXNVQ3dPaXRqQUg5dWU0V2Foc1hwOHJKMU1TSXN2?=
 =?utf-8?B?dEF6N1JLU0QvNER2QjlxRHY5RDRxWFVrSmJvSlVucjR6clFoeEdVZUM4eEtx?=
 =?utf-8?B?OGVxdExwaTE5WFdMTkZmTnZrMXFwN21rcUFRWWVjamQvVWtRNHpCWGp0VUVT?=
 =?utf-8?B?dWx3RFo2elU1elcxY3BuVVFtT1d6dHNVdC9TVTMvU1p1U2NzaThNbnM3UGhO?=
 =?utf-8?B?MU54bk51WS9BdCsrL1NjTEVoYTdHMFhyRFEwZk1kUFJuQ3l4UE5jVlVBVk5E?=
 =?utf-8?B?REN2bm42L21xOVVYSy9wbThScjBwUmx6SG1QcUZVbmJSaFJVQ0N6YzFEM1Vp?=
 =?utf-8?B?Rmxxa3hCSlB1THRuNC9Pb09iMHhKZzNqV01FZWNRbWhhdHRxUkdibHI1WTZo?=
 =?utf-8?B?MWczbWJzQlAvNENNQ2RZUkdlYmpPLzkxanRES2Z2VitpbkxxTWwrRFVrQ3JN?=
 =?utf-8?B?OUF4RUprSDdoVEFCUGoxTnlNbzVtZDNOMUQ2S29jTTVvRXNLZVpmRlFscDRF?=
 =?utf-8?B?bWNGYzIyRHZzaENDcnNybm9Sczd0Ymtqc2JmZGZoR2xlTm1MVTFQS2ZHU1I4?=
 =?utf-8?B?cHFaUkNmeGQ1UjhZOEs3clZQcTRDeW9BUU9IUm9WNGwrbjRwODFPb3Yrc3ZC?=
 =?utf-8?B?Q1B3V1FvUEYvOWFoOW9oQWxwNWVKNCszSTlnNTdSV3FYUjh5dFlsV3lCZExV?=
 =?utf-8?B?OGVkb2NtVnE2cVJRKzZzdkxvQXBBK0Q4bG9LTnJxNWdJbExrVFkxSExYYWEx?=
 =?utf-8?B?STVTTm5TaGhGbTNmQ1dkWGkvUHM0Smdybkw2Wm82YW9HREd4UE8zM005ODEz?=
 =?utf-8?B?SXM0dDlvazFJZHNQalU4WTZPWUwyc1JPVDZhLy9QM1J2V1IvUmtCV2g3VVkr?=
 =?utf-8?B?UmpZclJmTWtBZ1pIeXRPQ0JDcEs0ZDFualNjN3FXeThsMjNhRkQxWjRENHBY?=
 =?utf-8?Q?DRS65bAJfW4R3kiR1TVvC1hLxJKg/+GlN9eR8GE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e5724e-dcd4-46d1-5a48-08d96caadd15
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:12:16.0503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYb1qoMbDCFTrEuDKbwFJULjkIXNOvHKBdzMzZ32ng921BFUnZsmpslh4G25gwLp5/nj1rnlfcim8542n3uF3K8mNC/sfk+HxeGygVsPPpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2566
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-ORIG-GUID: 7CKz9jDjH35V8RtgtUu3dEQkNAO3RnNW
X-Proofpoint-GUID: 7CKz9jDjH35V8RtgtUu3dEQkNAO3RnNW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 3:27 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines set up and queue a new deferred attribute operations.
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Thank you!

Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++++++++++++--
>>   fs/xfs/libxfs/xfs_attr.h |  2 ++
>>   fs/xfs/xfs_log.c         | 41 +++++++++++++++++++++++
>>   fs/xfs/xfs_log.h         |  1 +
>>   4 files changed, 112 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fce67c717be2..6877683e2e35 100644
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
>> @@ -726,6 +728,7 @@ xfs_attr_set(
>>   	int			error, local;
>>   	int			rmt_blks = 0;
>>   	unsigned int		total;
>> +	int			delayed = xfs_has_larp(mp);
>>   
>>   	if (xfs_is_shutdown(dp->i_mount))
>>   		return -EIO;
>> @@ -782,13 +785,19 @@ xfs_attr_set(
>>   		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>>   	}
>>   
>> +	if (delayed) {
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
>> @@ -806,9 +815,10 @@ xfs_attr_set(
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
>> @@ -816,7 +826,7 @@ xfs_attr_set(
>>   		if (error != -EEXIST)
>>   			goto out_trans_cancel;
>>   
>> -		error = xfs_attr_remove_args(args);
>> +		error = xfs_attr_remove_deferred(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>>   	}
>> @@ -838,6 +848,9 @@ xfs_attr_set(
>>   	error = xfs_trans_commit(args->trans);
>>   out_unlock:
>>   	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> +drop_incompat:
>> +	if (delayed)
>> +		xlog_drop_incompat_feat(mp->m_log);
>>   	return error;
>>   
>>   out_trans_cancel:
>> @@ -846,6 +859,58 @@ xfs_attr_set(
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
>> index aa33cdcf26b8..0f326c28ab7c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -526,5 +526,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_da_args *args);
>> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 4402c5d09269..0d0afa1aae59 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -3993,3 +3993,44 @@ xlog_drop_incompat_feat(
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
>> +	if (sb_version_haslogxattrs(&mp->m_sb))
>> +		return 0;
>> +
>> +	/* Enable log-assisted xattrs. */
>> +	error = xfs_add_incompat_log_feature(mp,
>> +			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
>> +	if (error)
>> +		goto drop_incompat;
>> +
>> +	xfs_warn_once(mp,
>> +"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
>> +
>> +	return 0;
>> +drop_incompat:
>> +	xlog_drop_incompat_feat(mp->m_log);
>> +	return error;
>> +}
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index dc1b77b92fc1..4504ab60ac85 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -144,5 +144,6 @@ bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
>>   
>>   void xlog_use_incompat_feat(struct xlog *log);
>>   void xlog_drop_incompat_feat(struct xlog *log);
>> +int xfs_attr_use_log_assist(struct xfs_mount *mp);
>>   
>>   #endif	/* __XFS_LOG_H__ */
> 
> 
