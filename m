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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DB2C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC30610A8
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhHBILm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:11:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65394 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232632AbhHBILm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:11:42 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17282BPH017019;
        Mon, 2 Aug 2021 08:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6579KM68SuCDdU1CwxJgQUUO1Xx3i03WyWv8Kodq5/w=;
 b=kO/wHcu772oka4+UUPiJBzISml2sSrYueqc/hde1uGdIX8SFPAFfmv36+ULD2uSMDSaY
 swBsacwz3cS8WhbZ+7+0LEmaSYwHBml12F8h3JmfN2K/m53CmaCLE1sC9omy6137VEM0
 PGoaVcomForA2yZvf2jKo6YsMktMUOurojM6rAogvS59BSY52omEkQn8reWXmO7ecx3E
 2Brt8jFdEMJNLEmZMGMX3NOQCavNJ9wKBEkOgDoTgdHCBCzaBda5kc+I64pLO4YwTL/Y
 S4dXDy2ZdLpOYC2tRHXf9K7HgGdhuR/HUACwKFcxSKyB0/AemCyaIH9d6janft6Js0Jy yg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6579KM68SuCDdU1CwxJgQUUO1Xx3i03WyWv8Kodq5/w=;
 b=O9pRlhSLDT8pj+1Xj2/N2dpyZETBZH5d0EfakdelMJmTmTovHOLdYWJB5Ic35FEUcG2k
 YWIUBfN+yJ3YIURVnhbTDHnJFibUUpJjwi5x34EscQct2dXM5GRijOzsdc1Cz/oUjzwE
 HUUTs8aHMfa2ZnKVMELr39HmG8+TrqgPvDzKPKqiHGoiX1RLD6gQNd+ra9CezhI2JJB3
 +AA2SLcYNBTwVK2TFVGKsY91snLy5JMnyq25JYW11FeYX8PAticTdABAz7hQ3jZRy8cq
 ntL/8EhZUHgSsxEi7Ezq9CoVxzSJMJdhtVB5UVz4mIGjVVmac+s4AS+pI8QJixozRi4y Iw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4x4s2fs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:11:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 172800vS145840;
        Mon, 2 Aug 2021 08:11:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 3a4vjbks4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKC0YgMF9t0ybFCK187MALyajsKsqbhqQnKg+qDNzKgu1nNEsjBk7ZAaQNO0W0kg0MDVMUb8CPRwk4PEZUtNbnDCJgjbTrF8Lqf4SyHFwlA36iFbmXJkMFNpjpXUm8J/EvBja0QIjTfpl3diSaJckv1dYmxn4DoDgy0vNGE82kjyNeQuQCTiMxpoGUzWFHSuMsE4ka0vP3U6UAfiSpg5zAL7Z7TYoQHjtO2c8Z7+bj/vMeaS58N6Duf66ybaOglp1Mh6PnnZparCOV/FiT5ZeiquJdfEWT5ziZGRbaQ0Bs1+SV3NMe2bgnGs+Rnh7Tp+jNUFd03MoaIN1TE5hbQI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6579KM68SuCDdU1CwxJgQUUO1Xx3i03WyWv8Kodq5/w=;
 b=V/mrtpwCBAKdF4W9vIMd1FNMlPuvLn7rQUoLV56h9mQEhnQ7azV20mkh9r87bKfaWGp4u58tIZ8QMk205cxAJnBnOnC7q2WN9MhBWR02yMeemM1KhweizGXPU+XnpydG5AzFcHeYa/K5NGazHvJhTODieySaLEbay3OCMFeARPG4odn5aI0K8nb/yzkvPGLwRPhKpLJERNnKohsIaXP4UIh01j4gk4m251rqR7Ffwb/n3vWwRcPLHqGC9VQqr5OQXQpmikiOnHwQkylE8B9uH6HiuWwAFov9aYdUXpXVxJ3nVxWvTCJP/6+Gg+eEIfLRiHDDrjqYceyVbUxOxtf7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6579KM68SuCDdU1CwxJgQUUO1Xx3i03WyWv8Kodq5/w=;
 b=g8h6U5TSiRqAg/zLrDuesYRPol1TW1Kr4o42wT90bl4rpWm6pWja37ULBj7CkT18uGoPPk/49jIgPd1nNLSylYi3+Q0Njh9v+XB1YQeUhXwyM3xONaKFslRZjNxGgT7Uh4ekorAK6/Q211J02CAHDiB1ZcalTcJYyV7UtMoGXwQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4816.namprd10.prod.outlook.com (2603:10b6:a03:2d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:11:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:11:28 +0000
Subject: Re: [PATCH v22 12/16] xfs: Remove unused xfs_attr_*_args
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-13-allison.henderson@oracle.com>
 <20210728193126.GB3601466@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5e9634f8-41f2-e623-f962-493e1631b16d@oracle.com>
Date:   Mon, 2 Aug 2021 01:11:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728193126.GB3601466@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0232.namprd13.prod.outlook.com (2603:10b6:a03:2c1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Mon, 2 Aug 2021 08:11:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f5cb6f-75f2-45fc-03cc-08d9558d211a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4816:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4816D35026FA521E750F4E6295EF9@SJ0PR10MB4816.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6qQFiktfoaz4PWfCX4B0q88WJ9MAFqvquA+3l8leOsYsakyX3nHHXcw1BswRZLVDAD8zrkXWa2GxKxEQ+bLzqNrYosXbS9jq+UG+BNBcDuJkmNYkEyYmts+V1Y7JVPpOH/UUwXsm40HPl/+AGKV5xcFLUjcW8xNqRh5YDSZiQnnWwiyLJzYguJscY6gzQrdNesVuKXfKwV/lfs+PnpwLyWpReyIrY11aKDRyILDFsH3PTki51LYSOCWKgVMgq4omoCC6hyWBX3XChp2KlUgbUY5MiJNjKMaB4cd6+R4k5kyOASmlFyOgoIqm84UYX1Rjn823qPrQwcTlP6NnUdcq9wRWVgDJ3hpAonK6os6SxrMtLXsINMl/2nDfjQmXCdj7kuVuceJw4UQ56hdx1xbyjcz/ylyAqz3+dBckcJLY1HM91g/PHo1fEap18G4Mlpom+ARp9yTCNDJEZm5VsxzhaUrZbCNtyyP/oB1deyixqGTiCxkvFf1hJPUJM7I5K+Qcc+cQD60jydcIrg1er4iRHuBycKs+CKIKDPgGKm8VXbgMrkCpA9/+aXwTQUfyXmMmgZg6lKes7wbIDoyfDF+Fy07H7ETs4vgUZ6BPLQ4EiLjiFv9AWpuE0WYa0mvyuzK+IUsfjRA6ouDBHOPcaCV8XnZlpo25Op1gkXr/YZ/yTot8jRsVcP0VRwHl8mtJIJCsyf8JiWOJOIRFr20yDu5UhJQ4B1JdTP5rlnzDhwkgc1uxOD9L3U8a5+alRJtok3A/GoaMGwloxvEtBB0PDX/hIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(26005)(38100700002)(44832011)(36756003)(4326008)(86362001)(52116002)(16576012)(38350700002)(66556008)(66476007)(6486002)(53546011)(31686004)(66946007)(31696002)(2906002)(956004)(316002)(8676002)(2616005)(8936002)(508600001)(186003)(83380400001)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHpCQUpDYjNNRG1TVlVIaWp3aDBLY05yTktYMTl2aWVpcllGUnJBVnJKYWZW?=
 =?utf-8?B?WEdxMHVvME9DRzJ5UHFaaFk1MjF6U0tQRnhwSEdDa2dzRTR3dTR4ZzNPanJl?=
 =?utf-8?B?aTJIcUt3Q1dZRjNuRkozSUttdEJ1WmxLUUpvbVNEQmxBMzBGLzNHQmhEWjY0?=
 =?utf-8?B?STZCb2RsTEZ4NnZSWFpKUDhCR0phYUhuOTJlZkZQcUZRdCs1cEg4ZUZBb1pZ?=
 =?utf-8?B?ZWFRcGtob3FNYmZHZ0l2N1RuMFZuMWdXNHYrWDhRY2xJbWNFeDhzcXl0SHhU?=
 =?utf-8?B?TDFpVlVtcmJwZms5VStrYlJvM0QyU1dVQjJNUDFKeVdoL04xRHFHM1BhUE1h?=
 =?utf-8?B?YUxLdlh2NktDUlEyNHFIL0JYRmFpZjB3UExIV1FFMEhEN1NCbUVIT3g5NUJ6?=
 =?utf-8?B?NjhDTEJFbHhHNWtUZkh1ZGYyclRSWVNnSDdDSU1XVitRd2JEMVo3eTRCRkdx?=
 =?utf-8?B?cDlvdXFlUlZQRldZRzZneUZ3V0FiazBXUmFFUytrdmtEM3cxNnFvV0x0Q3hH?=
 =?utf-8?B?WmF3NFBCZXVLMDEyZTB1bnZSaHZxTU8wTzd2MVNKR0lwV3BQakdvMWNoK01J?=
 =?utf-8?B?a0R2d1hRR3JkOVlxUVFINFJyV0FvaXZqa05VWXlVa1V6UXh0ZW82NFhCVXZs?=
 =?utf-8?B?cEswWGUxS1p0UkJvalVCdGh5Z0hsa1FINEZSN0dSc1NoZDNoS2IweFcxRDdo?=
 =?utf-8?B?Y1BFYStpeWZWbnBUYzVRdGlKT0hGK0xIZjhGSWhPeHIya0VtV2xZeCtCZmNs?=
 =?utf-8?B?cit1Z2Z5N1dabi9wcEM2aUxDVVhFaFdsYzZ5NGJrR3MxTXFLSjc5YzR4Rmh5?=
 =?utf-8?B?eUhvZTJ2eG11RXJ6VmN6eU1FbWlhZWVrL0Z5b21uMGFqUWx2TElFZCtIVE4v?=
 =?utf-8?B?MEU2NVVEZlIvMmJsWVlRaWYvK3R3azlsMXBNYU9hN2FWTy9TUjEwOXpqd0Rk?=
 =?utf-8?B?d0V6QUJQUzd0N3dRWnVGeHJXNjNTZ2tOMlcrMXJNeVU2dlhYRUt1WjYrUEdx?=
 =?utf-8?B?ZTNqQ29DOUNCK09nRGo2Nm9KWGNFejVqeXBRTE1LcUJibGVYckZqbWRJNndP?=
 =?utf-8?B?NDVhZWk5OUNIeE9YYVMvOTBjeC9UUHRnQmRzMy9ZWUNlVzBLcmRNSzVRM3Fy?=
 =?utf-8?B?Z2VSV3JDVndzV3Q0NTR5VE9hN2RSTTc0SGNwSWZVUk5kRjErcWViOS9hN3Zo?=
 =?utf-8?B?TUhEam01MmcwRUplQW12bTJVTFBLNElMSkt6aDdqWWlCcG05cWlOQnNXQm5T?=
 =?utf-8?B?K21UT2FaRWhMWXhWNFpMbFlxcFVhTklZTGFBaXZpazI5YXd4UkticWs5eDc3?=
 =?utf-8?B?YnhHQ3MwSGZMQVFLK2dTOHFjQmU1ZlQ5UmVaUHkxckhGTmlGdjFldzlKUSty?=
 =?utf-8?B?cDJhazlOZFlZZWhDWmpVUEZ3YjN1R2F2bFdZTzFZL2YySkRCSkNrNVdFTndS?=
 =?utf-8?B?UVdkMkptSSs1T2EvYTkxMldDck52Kzc0Qk5zOEw3T2g0TFJrSTVwS0xkSWxj?=
 =?utf-8?B?ZG1sZlo3SU9YdFVZNVRpVjlySU5ZcVEvaVBabFdIclJiQ2VZek9RS0xEYURj?=
 =?utf-8?B?cEtuc2xUK2pGMDZRV3J2QTV1bzlBblhJTHRPWFJ1dGNQbkhGT1JQYUxUN3Fh?=
 =?utf-8?B?YU5mWEFxbks2dUZvaFdrQ1c4bURDQ3JzOEhHUVBFc2c0UmNpcDQ4ZW9wSDJ5?=
 =?utf-8?B?TWFYSEgwK2N0QXBXQWNnRk5UdnFPdlFaWHR4cDUzcjF3VkgvaU9NREI0YjhK?=
 =?utf-8?Q?sGXiJqJhuFSr8HLdDRtaNnTiVr170EHnRr5xY+y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f5cb6f-75f2-45fc-03cc-08d9558d211a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:11:28.5092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Bjlsc721gbE20ZtgTgcYNowH6Yk6B3vJKpqm3Y0GyXRoaIBpfbscHUnyUNEdUMkGDmISFO3XG1KKvuAd2uWZ043/MvnyssNAjQG56Wmlco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4816
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108020057
X-Proofpoint-GUID: 224VIjK-6Fm910WqpXkqehTj22wrxcvd
X-Proofpoint-ORIG-GUID: 224VIjK-6Fm910WqpXkqehTj22wrxcvd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 12:31 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:49PM -0700, Allison Henderson wrote:
>> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
>> These high level loops are now driven by the delayed operations code,
>> and can be removed.
>>
>> Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
>> since we only have one caller that passes dac->leaf_bp
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> More random ideas for cleanups, sorry...
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 96 +++--------------------------------------
>>   fs/xfs/libxfs/xfs_attr.h        | 10 ++---
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>>   fs/xfs/xfs_attr_item.c          |  6 +--
>>   4 files changed, 10 insertions(+), 103 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c447c21..ec03a7b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -244,67 +244,13 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> -/*
>> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> - * transaction is finished or rolled as needed.
>> - */
>> -STATIC int
>> -xfs_attr_trans_roll(
>> -	struct xfs_delattr_context	*dac)
>> -{
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	int				error;
>> -
>> -	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> -		/*
>> -		 * The caller wants us to finish all the deferred ops so that we
>> -		 * avoid pinning the log tail with a large number of deferred
>> -		 * ops.
>> -		 */
>> -		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> -		error = xfs_defer_finish(&args->trans);
>> -	} else
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>> - * Set the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_set_args(
>> -	struct xfs_da_args		*args)
>> -{
>> -	struct xfs_buf			*leaf_bp = NULL;
>> -	int				error = 0;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_set_iter(&dac, &leaf_bp);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error) {
>> -			if (leaf_bp)
>> -				xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>>   STATIC int
>>   xfs_attr_sf_addname(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>>   	struct xfs_inode		*dp = args->dp;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
> 
> Can you remove this local variable from this function completely?
> 
>>   	int				error = 0;
>>   
>>   	/*
>> @@ -337,7 +283,6 @@ xfs_attr_sf_addname(
>>   	 * add.
>>   	 */
>>   	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
>> -	dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	return -EAGAIN;
>>   }
>>   
>> @@ -350,10 +295,10 @@ xfs_attr_sf_addname(
>>    */
>>   int
>>   xfs_attr_set_iter(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args              *args = dac->da_args;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
> 
> And here too?  It's easier to figure out what the code is doing if I
> don't have to reparse through a double pointer.
> 
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>> @@ -370,7 +315,7 @@ xfs_attr_set_iter(
>>   		 * release the hold once we return with a clean transaction.
>>   		 */
>>   		if (xfs_attr_is_shortform(dp))
>> -			return xfs_attr_sf_addname(dac, leaf_bp);
>> +			return xfs_attr_sf_addname(dac);
>>   		if (*leaf_bp != NULL) {
>>   			xfs_trans_bhold_release(args->trans, *leaf_bp);
>>   			*leaf_bp = NULL;
> 
> 	if (dac->leaf_bp != NULL) {
> 		xfs_trans_bhold_release(args->trans,  dac->leaf_bp);
> 		dac->leaf_bp = NULL;
> 	}
> 
> etc.
Sure, I will go through this patch and clear out the leaf_bp variables.

Allison

> 
> --D
> 
>> @@ -396,7 +341,6 @@ xfs_attr_set_iter(
>>   				 * be a node, so we'll fall down into the node
>>   				 * handling code below
>>   				 */
>> -				dac->flags |= XFS_DAC_DEFER_FINISH;
>>   				trace_xfs_attr_set_iter_return(
>>   					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>> @@ -685,32 +629,6 @@ xfs_has_attr(
>>   }
>>   
>>   /*
>> - * Remove the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_remove_args(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int				error;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_remove_iter(&dac);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error)
>> -			return error;
>> -
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>>    * Note: If args->value is NULL the attribute will be removed, just like the
>>    * Linux ->setattr API.
>>    */
>> @@ -1272,7 +1190,6 @@ xfs_attr_node_addname(
>>   			 * this. dela_state is still unset by this function at
>>   			 * this point.
>>   			 */
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			trace_xfs_attr_node_addname_return(
>>   					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>> @@ -1287,7 +1204,6 @@ xfs_attr_node_addname(
>>   		error = xfs_da3_split(state);
>>   		if (error)
>>   			goto out;
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	} else {
>>   		/*
>>   		 * Addition succeeded, update Btree hashvals.
>> @@ -1538,7 +1454,6 @@ xfs_attr_remove_iter(
>>   			if (error)
>>   				goto out;
>>   			dac->dela_state = XFS_DAS_RM_NAME;
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1565,7 +1480,6 @@ xfs_attr_remove_iter(
>>   			if (error)
>>   				goto out;
>>   
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>>   			trace_xfs_attr_remove_iter_return(
>>   					dac->dela_state, args->dp);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 72b0ea5..c0c92bd3 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -457,9 +457,8 @@ enum xfs_delattr_state {
>>   /*
>>    * Defines for xfs_delattr_context.flags
>>    */
>> -#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> -#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>> -int xfs_attr_set_args(struct xfs_da_args *args);
>> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -		      struct xfs_buf **leaf_bp);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac);
>>   int xfs_has_attr(struct xfs_da_args *args);
>> -int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 1669043..e29c2b9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
>>   	 * the parent
>>   	 */
>>   	if (!done) {
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	}
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 44c44d9..12a0151 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -285,7 +285,6 @@ STATIC int
>>   xfs_trans_attr_finish_update(
>>   	struct xfs_delattr_context	*dac,
>>   	struct xfs_attrd_log_item	*attrdp,
>> -	struct xfs_buf			**leaf_bp,
>>   	uint32_t			op_flags)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>> @@ -300,7 +299,7 @@ xfs_trans_attr_finish_update(
>>   	switch (op) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> -		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		error = xfs_attr_set_iter(dac);
>>   		break;
>>   	case XFS_ATTR_OP_FLAGS_REMOVE:
>>   		ASSERT(XFS_IFORK_Q(args->dp));
>> @@ -424,7 +423,7 @@ xfs_attr_finish_item(
>>   	 */
>>   	dac->da_args->trans = tp;
>>   
>> -	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +	error = xfs_trans_attr_finish_update(dac, done_item,
>>   					     attr->xattri_op_flags);
>>   	if (error != -EAGAIN)
>>   		kmem_free(attr);
>> @@ -640,7 +639,6 @@ xfs_attri_item_recover(
>>   	xfs_trans_ijoin(tp, ip, 0);
>>   
>>   	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> -					   &attr->xattri_dac.leaf_bp,
>>   					   attrp->alfi_op_flags);
>>   	if (ret == -EAGAIN) {
>>   		/* There's more work to do, so add it to this transaction */
>> -- 
>> 2.7.4
>>
