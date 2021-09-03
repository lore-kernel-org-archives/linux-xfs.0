Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4511C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE45F60FD7
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhICVoD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:44:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35178 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhICVoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:44:02 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183IxdWT016547;
        Fri, 3 Sep 2021 21:43:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zTDU4tdMcIgYCPCCXLzyPQVtr6oGfVzqWcQzcrv6rR0=;
 b=zuml8+zlBUtXTCLW21BPCXd6jeCdTYpXax87YB0MVLCMnNTFDex4JXu9DN2W6JkBUOnn
 ZYfdri6CUFjIJKX361OxiWn3ZWMUDTYxMjbzsNj7gMm4FzYHd/Dqlv4i+gjwzdJ0uA9y
 50383vWdWTaYRyH5LUYbz3/uBIb6aDJIIYIy/4vFlZC4iN3MaTYr/9RM22zE5Bhm7zCj
 CR3cBKcy/z+uj6eD+7lbd0okPPKyDExBr5CdHe4ea1Gs0PHLdlAIZgjzJQgTC3P8kVfW
 rd0eZ1/U3+XHmYlJ30lTa1WZAEQ8WfU/MmoDFAOPNWnjsrpLG1bQ0+06axJgDEVABrUg vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zTDU4tdMcIgYCPCCXLzyPQVtr6oGfVzqWcQzcrv6rR0=;
 b=sWdT64eKarUVfHcmd4F/L6xRIuoBBMAW0zVceBJSTgy6YXThsDiEWr215DaW0VX5SHrM
 ZtwqIDSyJqFhvfgzeHz//bioW/iPTLkBDoRq3nLnKWVxgIe3CT3Gm87WvK9JQAo2OINd
 aIVzSJ1wFZ8ER/Xuq+QOvRDdqH0LoRFm/8IwAOTZQt1PlwmsZDP+ya8vJTLX5Y+6+5hn
 HdBJxCxhsMjCwoG4QiROVaVkonJA4UWu725cmCG3SnsiY+SBGMwTUGsgNQjkYPKCL6EL
 jlwX9a2XhazuIWFUYtx2z2/sgNiWFD3cC3mP+lCp3iVwtJIGahV/Yo1IfLJFfMWV8b7V Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3auh1r1qrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:43:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L61pk097875;
        Fri, 3 Sep 2021 21:08:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 3ate022qeh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUHkKDcbR1g1OCrYfr+MjONObT1OF4CYZWrDlYBqkLLknbkUETxgrJpHKfitI+ASQAp07VYhvqz0Cl9GhAdF7gMTaWeDVrP0RUEwZGdE92ThmpxITFUbilJCI8ueVPUzsKtl4kgI81Z96ZXUYMFoLVFDDVUnlB/gOUzR9yp3ewTLp6/GGXQvDjFQLxJM1/s09iIYTSfZRNhH74TL3ddoXRAvnKJJhxN0UTtseYzq3xF7LehGtKVESupBlo6tWaIywhOm7p2la7bdcx8RCUth0fRszR4HAAEwKG0QKOH0mu+66cg9H4NcLN6H9OtjOSLBpX3M65oILir0ZELzXwYycQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zTDU4tdMcIgYCPCCXLzyPQVtr6oGfVzqWcQzcrv6rR0=;
 b=OURGCiXUSJoRRSYusAzV88irQR+OCfgCxEAIRcaaLj0HDrLFS7fGMW4lxpeRVCMmeS60LaNaBW7lOVJ69W7uvSecaNK6LeotTqCSBO7eecEebIBTYeBtyAkKkdu+Rxz4I/LPsjOhY2Mua6MGTYpgxgNLG8MQtRwxNP+jcLYf26pfBBgutrrJ9zUqUsXMJ0FQGvbEPgxjGVijDV5OkdFp5j4UalSmXIU5cTLgzGhZNMjXxEAWF3/o1E92Ti3/lBYgX684loZjLyF+zmyjICiZxWueN7Yv8/qAXd5PNo4rlsvAj9mEV7W4MDI8LSpcDT/Pr3G975CvMHnUHRedEZNQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTDU4tdMcIgYCPCCXLzyPQVtr6oGfVzqWcQzcrv6rR0=;
 b=EcobICA+G2mPF0+xh1LlxBTtxFRAob5Oxrx/8CZmCuxvp12Dj+EKcb+kVrjnVodIRmCl1JMAQ5r6mk+jMxlox2WKllBf7lts3wv7695lDHIvE2Bnx2+oYbsacUWgTdVJ2rfmB6cfCmKKIbo02+Fhd4p8qvy/uhD/NlYWDtcRwys=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4765.namprd10.prod.outlook.com (2603:10b6:a03:2af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:08:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:08:50 +0000
Subject: Re: [PATCH 1/7] xfs: add log item flags to indicate intents
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-2-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c5cb2c14-8409-e18d-5154-1c09aa48b004@oracle.com>
Date:   Fri, 3 Sep 2021 14:08:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0026.namprd03.prod.outlook.com (2603:10b6:a02:a8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Fri, 3 Sep 2021 21:08:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 748dd300-6be9-449f-625b-08d96f1f072e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4765:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4765C86A5DFC30AEF3A14FA195CF9@SJ0PR10MB4765.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFKgFM1rW8/Y+uYJ+TNBm/QJ88w+AkDenUAPg1cnmGkoIVDuXgYPLOatDIYpaemL/ogRHWoBm3ITRm8AsSxzQEVtbUNduBctC6Ut/LKqa7s/eJ9n43ftj1uMpb4vFebCMU3z8aICQRIZ1CUZvrUsKNyN76/sUZzLgGSHpCcDGOcqIDmdWAiUgm+Vh2BWtu219fvxjIT4NktkqClS9dSUcxXMwcWcdoUnh6X4gIX//jkJYi7fRoYyaytsBYfEtdXM2US/zUpGOr66WhcSH842ZBiTWiuLqIxWVqJPO2f/fJkWFNc4kl7hKJXd8yJi6BYa6xOI1sUjMxB+bSVJUJWPfIc/cOf3NMA09IhV1X361QDrRRyXKALeuXa7d3Ibd01i5e1WzWlAnK2MAx4IFSN4Io3XJOy/nDm3txIVO5hQZ6K6SpIKo9JOFRrcZ3zrVPajyNWQeYvgsfNnXJ69T4smf0bdAl7iLiFOfc7INAuA5ow2/+p8iXlVPZUVdIavrnklzTtpiLaJWGP4XZSbHPOBTqV3YxfEFOWXQVo2kV7D5sAeKOVJCivcEU7zWZMOy7gIXaEpE5bY20iy5ZHcEDDBUB8h5o6hF72PPAgpUMQw0s2QdhKjIl04m9Z6ZI7QQ4GKrjGpVLN41zJ+OvKtChF5BNUMXXG3jkMO+Aj90k9sBYbODR+viSU+MtalssewlJh7aGNyq6mSNagp0JV8bSwjbrxIItWczn75E93wclzJgTMTh0WcnfruDUTKsG1r+5/6NWLabSrZq896iUZG1/BuRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2616005)(5660300002)(66946007)(66476007)(86362001)(6486002)(44832011)(52116002)(36756003)(38350700002)(38100700002)(316002)(16576012)(53546011)(956004)(26005)(83380400001)(8676002)(31696002)(2906002)(31686004)(8936002)(66556008)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q29OaEs0MVhsdUZrT2FaeEc5eHRzbklUZXFZU01pZ1NuVUVUNTJ5ektlQ09a?=
 =?utf-8?B?TGVsWFZpZ0QzeXR5enpYVDhmQW02TVowQnRIMzNoNCt3VGJIZE9xZ0d0WVo5?=
 =?utf-8?B?NDZyL1RwdEp3b0VjQ0FOdkR4ekl2QnlVL3hiMFpTYWFWekRTaXRWYnNXZ3F6?=
 =?utf-8?B?MlM5VnVBbm5hM3BxQmFZSzRKUWRRVk1FSXlGMG05dFZ3c2JheW5TL24vd2VT?=
 =?utf-8?B?NUFjSFk0RndCWHYwcjFLRVRERm40ZUxZZmJZKzY2WTdNQUZab3NmRnlqMm9i?=
 =?utf-8?B?bno4MVE2OUdrYXlYb0paSDZ4VTcrN2lIRXdublpLSTlDUHRVRjVaTzRPNzNq?=
 =?utf-8?B?Skh0MWFjaHIxeTdYQXVBTWJzcnQrK2RpWkFNTlhKS2NNRDd3WFY3eWlyaGJR?=
 =?utf-8?B?YmFrUkh2RWpGa0hTd1BwSzQvWS94Ykx3YWlHMlVMUytZZjVyQ1IzRGNkZUpI?=
 =?utf-8?B?aDhLSVZXZ0NYeFcyVTlhMXZjZlBMTFRWWWdVTzhCR3hoL0hxVlMxc1E3T1lj?=
 =?utf-8?B?cmNGOHdGaW1VZEl2ZmRONGY5WFFHMXBna01Sc283bHFQa1FUV2F3S0o4cFF0?=
 =?utf-8?B?eXpPRU9aM21INTRPR1hZdmVYTmVCR2c4VnBPdW1vZkFaekIxWmIrTm9LRjk3?=
 =?utf-8?B?djRoaUpQNUcwZER6blJ0cHVmUnpZeWdWM09BRFlYbVhmMjcxSS96Z1FmR1l2?=
 =?utf-8?B?V3Z1Y3hmaWNhRGtnRFJBMVdwS3FUTDFhRk9IMldHeHNEWEMvemx6L2N3cTZT?=
 =?utf-8?B?bkhOL1VMZ1A5bmJwaDZZOWJXYTA5WURlYU1Ec05GbXQ4M3RpR3F1b1gxMUdn?=
 =?utf-8?B?L2hTay8vZm5QaG15RU8zK21JMXhBT3M3NVd3QkljQlkxdXplajZFMkJRSDV0?=
 =?utf-8?B?Z09za2FCbkFjSDBZbWpEY2lCM1hlS1FlR0NLY1hpUGxFakovSCtGRlY4Ri9T?=
 =?utf-8?B?K0cvSWVzOUQ3dkNHbER3ZVN3SmdFU202YkxJZGtXaVppNVIvRkQ4TnBMeklq?=
 =?utf-8?B?UEVXQXBkTXh1S1U0UmNPZnh2azJUUTFxSDBNeWZvTlVBVFR6UmZmdG5vSUV2?=
 =?utf-8?B?amFIOVhEVFlxTTBXcUJ6akM0MnhtZFNNYTNqTEV3YzFFZktDa3pacHc1Zyts?=
 =?utf-8?B?RnNmdWxwelhaL24wWEZWUit4MGFvVkVYZi9wakh6OXVxQkRDaXFwRG5kcTZw?=
 =?utf-8?B?VHk3YmtSeXMvUjM1d0JyNlg3c3MxREZtUVVSRWFlUlY2a1pQQlY5dnN5c3pH?=
 =?utf-8?B?cGVydzdqRU1UaVBhTWQzVkRkdTg0YVF4dkVZR3VaZjFRYkJnU0FNZzBVYWoz?=
 =?utf-8?B?Rkc4QUEvaXY1QWsrVUl3dGZkcEFZRElFWlQycmhvQm9LZ3ZBeEZyVms5L1Za?=
 =?utf-8?B?aEtKVFF0UUg4RDZKNnhCeUVWZit4czZZZkZhSmhvRUt3cGZIWS9wVm53YkpT?=
 =?utf-8?B?UzN3RitSNGR2RVprM3FOdGIrYzFIcHVJaHdoNWtoQmlneDlNWHF3QlB4ZXhK?=
 =?utf-8?B?N0o2MkhseXRpZ01ZR1p6RDZ1OFhNdWh1aDJQVmZMbzlubG9MWk5pY2o3cGRX?=
 =?utf-8?B?cEJHN2R2NVdkK0dZdzVnSnBIZ1NIcFBtTzFGZHFLOE9rbXIzMllQUWllbGJv?=
 =?utf-8?B?ZTdvek1GeDFDc0w0dXhFQjlTYzZTckFwQ1FpckNTNzZZRTRSU1ZvTlBiTDZs?=
 =?utf-8?B?dVh0ZjdOeGxvK0h5NlVnaE4rcVdKcDBxRjVHYjM5bW5YK09ZeGRsT2szNndw?=
 =?utf-8?Q?y2Q7DGpzZiqgOTnFpnbwuPkeyquvNd+KH3hvh16?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 748dd300-6be9-449f-625b-08d96f1f072e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:08:50.6079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9fgakzmxF0NoMskSf42kfMvD6ARtPfwTh+ohmzocnAYdw2VKc0v5fuebz616dksWVOwPeRS97wa0Ei1Qso6Kfi8lBEE992U36CrjHvyJoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4765
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030123
X-Proofpoint-GUID: n7aKdytj0QUWjLgO_DFDH95BRoY9nhEj
X-Proofpoint-ORIG-GUID: n7aKdytj0QUWjLgO_DFDH95BRoY9nhEj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently have a couple of helper functions that try to infer
> whether the log item is an intent or intent done item from the
> combinations of operations it supports.  This is incredibly fragile
> and not very efficient as it requires checking specific combinations
> of ops.
> 
> We need to be able to identify intent and intent done items quickly
> and easily in upcoming patches, so simply add intent and intent done
> type flags to the log item ops flags. These are static flags to
> begin with, so intent items should have been typed like this from
> the start.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, this is pretty straight forward and makes a lot of sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_attr_item.c     |  4 +++-
>   fs/xfs/xfs_bmap_item.c     |  4 +++-
>   fs/xfs/xfs_extfree_item.c  |  4 +++-
>   fs/xfs/xfs_refcount_item.c |  4 +++-
>   fs/xfs/xfs_rmap_item.c     |  4 +++-
>   fs/xfs/xfs_trans.h         | 25 +++++++++++++------------
>   6 files changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index bd4089eb8087..f900001e8f3a 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -479,7 +479,8 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
>   }
>   
>   static const struct xfs_item_ops xfs_attrd_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_attrd_item_size,
>   	.iop_format	= xfs_attrd_item_format,
>   	.iop_release    = xfs_attrd_item_release,
> @@ -684,6 +685,7 @@ xfs_attri_item_relog(
>   }
>   
>   static const struct xfs_item_ops xfs_attri_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>   	.iop_size	= xfs_attri_item_size,
>   	.iop_format	= xfs_attri_item_format,
>   	.iop_unpin	= xfs_attri_item_unpin,
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 51ba8ee368ca..8de644a343b5 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -202,7 +202,8 @@ xfs_bud_item_release(
>   }
>   
>   static const struct xfs_item_ops xfs_bud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_bud_item_size,
>   	.iop_format	= xfs_bud_item_format,
>   	.iop_release	= xfs_bud_item_release,
> @@ -584,6 +585,7 @@ xfs_bui_item_relog(
>   }
>   
>   static const struct xfs_item_ops xfs_bui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>   	.iop_size	= xfs_bui_item_size,
>   	.iop_format	= xfs_bui_item_format,
>   	.iop_unpin	= xfs_bui_item_unpin,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 046f21338c48..952a46477907 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -307,7 +307,8 @@ xfs_efd_item_release(
>   }
>   
>   static const struct xfs_item_ops xfs_efd_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_efd_item_size,
>   	.iop_format	= xfs_efd_item_format,
>   	.iop_release	= xfs_efd_item_release,
> @@ -681,6 +682,7 @@ xfs_efi_item_relog(
>   }
>   
>   static const struct xfs_item_ops xfs_efi_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>   	.iop_size	= xfs_efi_item_size,
>   	.iop_format	= xfs_efi_item_format,
>   	.iop_unpin	= xfs_efi_item_unpin,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index a6e7351ca4f9..38b38a734fd6 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -208,7 +208,8 @@ xfs_cud_item_release(
>   }
>   
>   static const struct xfs_item_ops xfs_cud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_cud_item_size,
>   	.iop_format	= xfs_cud_item_format,
>   	.iop_release	= xfs_cud_item_release,
> @@ -600,6 +601,7 @@ xfs_cui_item_relog(
>   }
>   
>   static const struct xfs_item_ops xfs_cui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>   	.iop_size	= xfs_cui_item_size,
>   	.iop_format	= xfs_cui_item_format,
>   	.iop_unpin	= xfs_cui_item_unpin,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 8c70a4af80a9..1b3655090113 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -231,7 +231,8 @@ xfs_rud_item_release(
>   }
>   
>   static const struct xfs_item_ops xfs_rud_item_ops = {
> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
> +			  XFS_ITEM_INTENT_DONE,
>   	.iop_size	= xfs_rud_item_size,
>   	.iop_format	= xfs_rud_item_format,
>   	.iop_release	= xfs_rud_item_release,
> @@ -630,6 +631,7 @@ xfs_rui_item_relog(
>   }
>   
>   static const struct xfs_item_ops xfs_rui_item_ops = {
> +	.flags		= XFS_ITEM_INTENT,
>   	.iop_size	= xfs_rui_item_size,
>   	.iop_format	= xfs_rui_item_format,
>   	.iop_unpin	= xfs_rui_item_unpin,
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 2d1cc1ff93c7..ab6e0bc1df1a 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -80,28 +80,29 @@ struct xfs_item_ops {
>   			struct xfs_trans *tp);
>   };
>   
> -/* Is this log item a deferred action intent? */
> +/*
> + * Log item ops flags
> + */
> +/*
> + * Release the log item when the journal commits instead of inserting into the
> + * AIL for writeback tracking and/or log tail pinning.
> + */
> +#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +#define XFS_ITEM_INTENT			(1 << 1)
> +#define XFS_ITEM_INTENT_DONE		(1 << 2)
> +
>   static inline bool
>   xlog_item_is_intent(struct xfs_log_item *lip)
>   {
> -	return lip->li_ops->iop_recover != NULL &&
> -	       lip->li_ops->iop_match != NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT;
>   }
>   
> -/* Is this a log intent-done item? */
>   static inline bool
>   xlog_item_is_intent_done(struct xfs_log_item *lip)
>   {
> -	return lip->li_ops->iop_unpin == NULL &&
> -	       lip->li_ops->iop_push == NULL;
> +	return lip->li_ops->flags & XFS_ITEM_INTENT_DONE;
>   }
>   
> -/*
> - * Release the log item as soon as committed.  This is for items just logging
> - * intents that never need to be written back in place.
> - */
> -#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> -
>   void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>   			  int type, const struct xfs_item_ops *ops);
>   
> 
