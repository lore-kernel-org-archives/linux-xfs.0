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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE4AC433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE0661107
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Sep 2021 21:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhICVKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:10:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11990 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235926AbhICVKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Sep 2021 17:10:36 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 183Ix2g1008042;
        Fri, 3 Sep 2021 21:09:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=geNYbnNdDHpQ1M25y6Z1ZELPc7XuIaXbl54FxEpteV0=;
 b=vtSUXfR8jVTAlVLMK7RKqhSUMymzuRIb+Nnff349GpuvN/hBxTqSbrzHUW0rtWNqRm/2
 ykP4uCaXvSLQmtloMI3tU/2QPm7iR1/6BjcYhw32MgOX2hSMwa2xjzr8D43iw3YRrpVT
 eXpJbybQDRgxGlXxLiwfNwhRNqtOb68WoPkiAj9vCbf3LtZcGDBMah8KBB6CphO15VdK
 BdRm33U+MKJBXejmVvMW6sIDTxGScCq1tlxmiXzqPSwjujvrksWRIz8e6qtR/FS4ba6d
 WDOnk7HamM9Awe59kEt79Se5Zak6ftZ1P+ZB89rjzfLwqx0TmtEvXlyMxfeVO9cknGlW 5g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=geNYbnNdDHpQ1M25y6Z1ZELPc7XuIaXbl54FxEpteV0=;
 b=EhKlAE2Q8OLTlIJEx2xsBM9xaSVR7Obr8H/729oBFP11d20cxAA5q+A+kDmGc/a8xyXv
 KdOdbOuKlKKyUJj6X0ANHhCyl4XTv3wh48uprmHiPhqoyybUF0N2dKNooV5TdMhyKsxr
 HIoTAtjtI6LNoee4b4HLAJFgVoD/3a8OitpMMvL0yz61Gai3Z6jmDcMawfF7BxQ/C6xC
 eOr9GCxkS1a9qmBjrwRsv4agIp4dndnyEDokqlUbJFp5sMepu6aeFFS9vo9qzno5RbmK
 xh211RYVF0H3YgFG9iqE/A24b3nxZUhHm91G64B3exueVauhSQLgHkTuiLmNY9dix5PN 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aue9ft7tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 183L61ni097836;
        Fri, 3 Sep 2021 21:09:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3020.oracle.com with ESMTP id 3ate022qx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 21:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtvTopHQ1X641m69Yy9dLMW6yBfjRPbXHpmZHbNUGthKrOyWc8avUQ9xR2du5pBDzeXU1R8f2vaDsdzBPV1s6O6Lk4+bofobkC5FZDqA1419L6ZCBsrmB3ldy76ORMFd7yQiYpyXC/uzknit/1sOZ1495yGqJT95z9ddXqOACvIUk/cpHU+cl+bqnysxpLIVBtMoNcL0mxWDJmYzlNrSu7PLI9wN0k75kEcD+FeeYQWxdpN18566fgat43SM+LDgjhSbVpwNs2uS71jInawnSorrX4GFoYG7Z/GpN5AKGZwNgg1BScfjlf5LFlBoO4DJIxMVVLQfv8sK8XMBCa1OLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=geNYbnNdDHpQ1M25y6Z1ZELPc7XuIaXbl54FxEpteV0=;
 b=WD2ivMM8GTIw0o9aRaThsH0A1PetZiZ5zugr4OtZ2KwNcls5e3Eagpshh9b8oluFboeIY2pp9Jf2BIDx9MJPHEDVtI4ddSPg23nFC82qC7p/n3vzs4Vt3W1sMvZAMM6kN1w4HPhJsvC5mB9KaVm7/CdLTrQBN0m+sYeB+tVRTwv+/WstfQQc3tDdxb/EENT1m2jBL7tgGMJRAxifRx3BOfEqHTODURT6yvhbTgAWQquFbC0smtaYEJ4wC+kNI4kX1YCYIQ0gnp1Al1VaZgEkJpS/ijNN7QFqbiEWU6F2mUHlennfkcOKqgSAp88zcTkmLF8+GS8308hAkuq3P4PlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geNYbnNdDHpQ1M25y6Z1ZELPc7XuIaXbl54FxEpteV0=;
 b=vZ5sQem87iR/q1FLm4d+sLUm1oTx6AnSqpGf+swQGlNdakc6dMVT/7EN7SmTSooLTsYemeYqw/49HS8xk3O7NoGgS25tXHBWUUF64LJdUm/nXJch9E0pg83+1GQi8YSMrGUbIgSiBd5BOWxyJELvnJ+7fqX3FJoW8RP/+56eQL0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 21:09:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 21:09:32 +0000
Subject: Re: [PATCH 5/7] xfs: whiteouts release intents that are not in the
 AIL
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210902095927.911100-1-david@fromorbit.com>
 <20210902095927.911100-6-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f82fe42b-2459-2d71-64e9-4d3ccaf93446@oracle.com>
Date:   Fri, 3 Sep 2021 14:09:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210902095927.911100-6-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by BYAPR03CA0010.namprd03.prod.outlook.com (2603:10b6:a02:a8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 21:09:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 741a8471-abf5-4041-9ec4-08d96f1f1ff8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4429ECA2D4F94034B6A44A0F95CF9@SJ0PR10MB4429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFJbTJBlDupUPnTDj1Cc4UGM9Wqly+d1Rc1x/5OnIoGF9Flyhz0ukegjz0ljYFJs7oXojrEopqs9W+lARNmqqM2cMAvODcG2A+zKg9fY5iOklm7ChMLX2bMKuYaTz2gK9qHdQ+7jLNJJXGZgmz/3Bbm//BUUq+jnsiZRa2Odlbr5ymCSy+zkW6P5nDbTUtAKZJlF+RVTk5xNF+pJxAGRCxawG6ax2FjB28grxbuwysmOpacwu6Y35bLwzN2kpYF+VmRpqVqnZX3OmMno0e4xshGYZQiOyy9uIHTr6HieDOoW2jt6yHkjP6giZUii2k05pnZ1UcJjTU0DoMmimZ+K/n5jBKMPw83Inxs25JcnfmEJucGauYbt6SIj/AIqnln28hBAsemlCfOdpHcAB8UPtnDVS6O++UlKAzH020yc9xLmjLo2GZmy5nmUhTNAeFe1FZm+S09COZ55niorUfqnnqejX20TrsR/25Dj8w5u4BIZ+7q1m9NP/DbODwp2+tWhw1h2qzXUhoGS7t+ByfWjspUH5x/uBUgDITjqywEajggkQeJkUlpo8uHE6BXmtzaNAh8YQrxV3e+gPTa6R2psaY50YpEyIixmjYBT87Rf7S+PXmdF2/nwEfCDaD1bblxLbnepVWhdnyTEpLEg8MyXmtLvogiCiJiTXCdPtjDLAgY+5dvVxTFINlZuyLZk40u8jQ0NsPNgu1pFXC9auBrBpc2FN8m6V/RCM2PRV0EstdAJZfro9mbS9hCqvEhJkbEK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(956004)(8676002)(31696002)(316002)(8936002)(478600001)(86362001)(186003)(83380400001)(16576012)(36756003)(38100700002)(38350700002)(66946007)(2906002)(66556008)(26005)(31686004)(2616005)(44832011)(66476007)(53546011)(52116002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFNheTBwdit6bGE5cWx0S0kxMDRpb2QxRzV1UXdacjdrRCswdjhMR3I3OXF2?=
 =?utf-8?B?eFQ3b21ZendTKzIrSXQ1bzRobGl5eWlSa003dHR2WmlTcnFwcTNhaGRZSXZS?=
 =?utf-8?B?QWJCeXZaNTBuS2swSWNYQXhjek9nWEdRdVNiMFB3OFExTjVNRGVuRmVsQ0Yz?=
 =?utf-8?B?WkVGZSt0QzQvRlBFeTltZDdjZVFGTGJMendVRWRPbDR6MFMwd0tsYzJ2S2NM?=
 =?utf-8?B?ZmNQOG84RXU4Y202SnY0RjBvODlnc295dWJJTDVmTXUranY5aHp6bURpUUh2?=
 =?utf-8?B?a3V1NWJzbW8rRjYyMnQySld2bGJOQUJuWjE4eVVjY3ZnQkpuckF2KzI5QURW?=
 =?utf-8?B?b3lVV0dJVzNEaEJKMitzWDQvQWViU3NSbEQxNnRuZHNTR0tpbTJFK1hKUWpy?=
 =?utf-8?B?TXlyYzMycyttL045d0hvZ3VZRDlXSkxGcVRsZnVOeTY4M3lKSHlrbXJGNE9S?=
 =?utf-8?B?WS9HaVJOaElHR3l6K3NzQmY0VWVsOWZ4cGdGU1htNzkyRGJKaTZXbHdVQVpB?=
 =?utf-8?B?THY5U0x5ZzJsd0Y1RUtrelR5MnhuM204MXRveFBTa2g3SVJGZHZ1NVNKb1dM?=
 =?utf-8?B?Y2FMVTB4d0t0d0c1NDREZXA5N2Q4Ums1QThEQ1dxaWpWZEJ6aklxaW5zY1Qz?=
 =?utf-8?B?a09oTDZmNWlzRE1HUVlacTNCdnZKTTI1VXN5bXdNckhxZ2o3aDdTZVozVEJY?=
 =?utf-8?B?WUZXRTVwWnZjaTQxdkdVRVY4ZDl2L2lNdGczdDNHQ1c2alpVT1lZVk9yK0x6?=
 =?utf-8?B?R0ZXT3hlUFE3amJNbkJGWTZ6Qnh3UXJpa3J6MUx0R1oxVDJERWwvb0xieVNj?=
 =?utf-8?B?T3Ftc1NqL0UvSzQxSTFkYWFSWVBIM3RyYjFhNWYwWjNRS0FidzVLMmhuUGF1?=
 =?utf-8?B?bWxkaVBMNU5jY2FNNnhOWFRGc3p4bVZ5Nmp2LzhUSEJCd3Bqek9GaDFzcXdi?=
 =?utf-8?B?QzlndFdDbXBsN0tNR0Z6Vk9NdlNFanAyTzJmQ3JqdXd0Q3NIai8wY3VIeGZR?=
 =?utf-8?B?YkdNYWNON0tDd3dwTjgzL1gwS2Q3VjA2bngzY0VGOGNwY2dQTU9BdmxsNERO?=
 =?utf-8?B?RVZTWkZKYXJRbTlkc1MzVzBoYi9uYlRvSEY2dWVEWlQ4NExZS1FoTUFUOEZQ?=
 =?utf-8?B?SGRwNGkveU10R0ZUSStjOTBmc3Vyb1lhUVBOd1JYSTBNb2ZFZG1jUC80YTda?=
 =?utf-8?B?M0piQUpqZEVsSzhaZkRhZURVUWRiWkVBZ204ekpYb3NjWUxLb0h4T21Hb3Bu?=
 =?utf-8?B?MnhYNTh4SGZBMUhJejZNak9qRWtncDNRU3RMNURxUUZzNWk4MTEzNWZpWkxL?=
 =?utf-8?B?KzZQU3o1bUU1UDdXcjlsTUJoZDArTjFKVndzQ3h3V0tjMSsyV2c5amtyWWFE?=
 =?utf-8?B?T2l3Z2tobjRudlhjNUlZOEwySU9mTU9IbkFhWHVxU1dTT0lCNGo3NEpzQ0F4?=
 =?utf-8?B?VTRBZTBPekFvSldiMVhoQ2gvSUZGYUcxZzZRS2RyRzdCaUtvSEY1VTNNRHNq?=
 =?utf-8?B?ZW5uUEdOdlR5bG1DK2I1TkhZeGIrY1BQVlhmUEhaeWpVSk5oMGZQdk1SMkRO?=
 =?utf-8?B?TnBTSk5EWno2SytIL2xTU2dveVkzMFJyUjNkOG5mQ2RFL3BkTVlxMkhNVVhj?=
 =?utf-8?B?cUxDdXEwWG9GNjBFSjhydExTVTcraE9xcU5jSVRSSlA4TDhvKzBBZGYwZWZP?=
 =?utf-8?B?clArZDVVaGhpdjNldHlOTXc1L0NFM0Y3VFBiUmtiaHdDZ1lKVkNabVE5OUZN?=
 =?utf-8?Q?PRIqe5Ro1dOvch6WgQUSRnBF3hsFxIYfITXw/k1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741a8471-abf5-4041-9ec4-08d96f1f1ff8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 21:09:32.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe9Q2mDsVLnridyW+7fS1XR6m/gNqkGrzJmuIvalF38rNL9a93Sh8pWJunpAFlNnnwqrvA7Mo55T5M88rqyCIZq0sxuMQJoGItOxvEij2cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10096 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030123
X-Proofpoint-GUID: enKD9Op3i2AA3RhyXVswOcTyBX1gVPjj
X-Proofpoint-ORIG-GUID: enKD9Op3i2AA3RhyXVswOcTyBX1gVPjj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/2/21 2:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we release an intent that a whiteout applies to, it will not
> have been committed to the journal and so won't be in the AIL. Hence
> when we drop the last reference to the intent, we do not want to try
> to remove it from the AIL as that will trigger a filesystem
> shutdown. Hence make the removal of intents from the AIL conditional
> on them actually being in the AIL so we do the correct thing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_attr_item.c     | 11 ++++++-----
>   fs/xfs/xfs_bmap_item.c     |  8 +++++---
>   fs/xfs/xfs_extfree_item.c  |  8 +++++---
>   fs/xfs/xfs_refcount_item.c |  8 +++++---
>   fs/xfs/xfs_rmap_item.c     |  8 +++++---
>   5 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 86c8d5d08176..11546967a5d7 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -67,11 +67,12 @@ xfs_attri_release(
>   	struct xfs_attri_log_item	*attrip)
>   {
>   	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
> -	if (atomic_dec_and_test(&attrip->attri_refcount)) {
> -		xfs_trans_ail_delete(&attrip->attri_item,
> -				     SHUTDOWN_LOG_IO_ERROR);
> -		xfs_attri_item_free(attrip);
> -	}
> +	if (!atomic_dec_and_test(&attrip->attri_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &attrip->attri_item.li_flags))
> +		xfs_trans_ail_delete(&attrip->attri_item, SHUTDOWN_LOG_IO_ERROR);
> +	xfs_attri_item_free(attrip);
>   }
>   
>   STATIC void
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 0b06159cfd1b..7cabb59138b1 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -54,10 +54,12 @@ xfs_bui_release(
>   	struct xfs_bui_log_item	*buip)
>   {
>   	ASSERT(atomic_read(&buip->bui_refcount) > 0);
> -	if (atomic_dec_and_test(&buip->bui_refcount)) {
> +	if (!atomic_dec_and_test(&buip->bui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &buip->bui_item.li_flags))
>   		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_bui_item_free(buip);
> -	}
> +	xfs_bui_item_free(buip);
>   }
>   
>   
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 87cba4a71883..7032125fe987 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -58,10 +58,12 @@ xfs_efi_release(
>   	struct xfs_efi_log_item	*efip)
>   {
>   	ASSERT(atomic_read(&efip->efi_refcount) > 0);
> -	if (atomic_dec_and_test(&efip->efi_refcount)) {
> +	if (!atomic_dec_and_test(&efip->efi_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &efip->efi_item.li_flags))
>   		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_efi_item_free(efip);
> -	}
> +	xfs_efi_item_free(efip);
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index de739884e857..f62dc5b7af88 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -53,10 +53,12 @@ xfs_cui_release(
>   	struct xfs_cui_log_item	*cuip)
>   {
>   	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
> -	if (atomic_dec_and_test(&cuip->cui_refcount)) {
> +	if (!atomic_dec_and_test(&cuip->cui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &cuip->cui_item.li_flags))
>   		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_cui_item_free(cuip);
> -	}
> +	xfs_cui_item_free(cuip);
>   }
>   
>   
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 8d57529d9ddd..0c67abcd189b 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -53,10 +53,12 @@ xfs_rui_release(
>   	struct xfs_rui_log_item	*ruip)
>   {
>   	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
> -	if (atomic_dec_and_test(&ruip->rui_refcount)) {
> +	if (!atomic_dec_and_test(&ruip->rui_refcount))
> +		return;
> +
> +	if (test_bit(XFS_LI_IN_AIL, &ruip->rui_item.li_flags))
>   		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
> -		xfs_rui_item_free(ruip);
> -	}
> +	xfs_rui_item_free(ruip);
>   }
>   
>   STATIC void
> 
