Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9379CC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77FAD6140B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFCWbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:31:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhFCWbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 18:31:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MKD9i137358;
        Thu, 3 Jun 2021 22:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=y1MBHSsIZHau6ba8O8UfbjTD72MfL33Bm3PudfO8+rA=;
 b=pO5NM2W460n+QkmUa5ZfkfqS0CiHUL4N+7l4spXU3TIjjFk9OB/Nmvf+847sacj1E+uT
 45iV/66pn0GnXzl34FGMio65aucy2LlblCBj4MExpFzYCvkxiSvEVXDCtvkljcgNStTD
 vJzNMFFdH6shmm50MO8ifPhtF5VPWmnsKZumAv6f5c92roq3EREF7NdqB0avu01GEGde
 +FSsyE/E9EnGgUzuGIZDaJU1g85ThkJ/Ane522KuwxrzqngrWeMhGqqkg6tRxlqI/REJ
 wmGlmzvTV1UPEAgVW0hyHvc5hVLz5B9HvWfzKrSnufa1SfeDZeZvhDwfpleF2AO0mfJl CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38udjmvjjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:30:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153MLVub140506;
        Thu, 3 Jun 2021 22:30:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 38xyn1r60t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 22:30:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3HUiEedtjhDB0blkC8ek2Z1JdXbDmWphlusaFtmdLp5uAhTj1/3miXmnP5GYPyeIKMGPKbbTYxl93F6OUJqlBs8T8fXO85pXZV34q+jncLTBGR9CHZ8hfUkbkzCqhuR5Q5JUFvDyHJ6fi3WgmydB10wx9W1XEWrDyDMMoRLqnlYYdNgMNHqnVIz2vaYeioUMX4fMTtH/o1RKLh2sbLCO4n3QZ8Uve52GsQPXgp1TD93k7vA+FmAuH8p3aPM9u6U9jcCXXVL5PhEbFn3LioGvFj+l1nU52dfF/lY7d5bexEZCkEc0qeDpBIcitxZmeI9nVcLa2GYz7deOMeeGYUZiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1MBHSsIZHau6ba8O8UfbjTD72MfL33Bm3PudfO8+rA=;
 b=ldCavku8bQ6mX1Fwv1K+6INko6LmIVxrWsOfFd3ge5GZDSfKP5Ru31BtZDQ4Tm99tOP+5ccZuwtViXZ4Bn6uODGUXTXcigJ0Uo/nNm17U1e9ARpJbBccbcymAQLlQ7fLtjV9S2+g8L2UizY7Puhaq6+GNJokNbQjbeIpIDSDWvwWXaEjq3UL+tSnUbX0BJBDrs99HAhkqPkjrnXDTev6RdmJT2qQtQB8r0Y+MqfWgMBT/411NnC1/76qpIWm9oEkaXQyRUz911/TZgxbb3rjXgGRJjlsZCwOWVO408TR5wI/uZC51Tnkd50ilJ+xqsLoAcIQy274slrlNLm2pMCMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1MBHSsIZHau6ba8O8UfbjTD72MfL33Bm3PudfO8+rA=;
 b=TKJ3oAZDdbOvlFcQiWHpn4fTBBNAB+UTHsvY+DMunEL3nc756AbyOiPmCxqsEF+p05tH22Yuh8dbtbKK4wmA6r14QwHweLFR1Hl5WyMVzLF0Nu1xDKHW+o1ZX69k9TpEUKoKDCA6sLwhqYxvnByhUrKI9CspWdSvPWtO3W+mQjc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 22:30:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 22:30:00 +0000
Subject: Re: [PATCH 10/39] xfs: AIL needs asynchronous CIL forcing
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210603052240.171998-1-david@fromorbit.com>
 <20210603052240.171998-11-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <67771fd1-543e-552b-63e2-c00edb084c1e@oracle.com>
Date:   Thu, 3 Jun 2021 15:29:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210603052240.171998-11-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BY5PR17CA0070.namprd17.prod.outlook.com
 (2603:10b6:a03:167::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BY5PR17CA0070.namprd17.prod.outlook.com (2603:10b6:a03:167::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Thu, 3 Jun 2021 22:29:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2770e19-82e2-4227-37a5-08d926df1fb9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2712:
X-Microsoft-Antispam-PRVS: <BYAPR10MB271247207FFF07A4276745D7953C9@BYAPR10MB2712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKPgJ5jVBlT8RpNrOWoLMg8IrB5Bg9Vo36PIZlkVYrU/jee1Gr2LLUCXsyKAo4evRFUr899St4Pd0XdyUdNtftIM+kVyTouDUA609bOYq6Q5eXbaOxQ5DnEpjZe7aMcWXnOWKandAQNvp6TBuRCV4W6V+EOHAdXiE3cOBGd1AF/8FmwmLsVEqsaJ1mtiugcsMSpvOL47C3rpXnLSRhVGU7VaGayGPHPy+HVWwSDjmvkm2q2wW0SvjXHY2d+DYYnewkXkdcGrhUn1ogQH94MM8ZC6wPMd0wf5u7ZrzzV1p7EclmTBnxp59uHJygIyLTTunIonNlfSJo8WQUHwVK5N8nESYrLoS+RGi73tN88046u8bwBLVPMFqnm9ubUeOnz531L2gkgB4W/rVIV5m0kxeYtQk4LHtvRBK5CCcxFEj01BFffl91acXk5NXqgPRZsMxIJkbHK3W7KG4oq4KFj/TzbcDC5cQpZ9bhsAHor6pwjoGgsNYcsALKnZ667ENB/7vjZghDXrZmZpHS1es9b3ytR1qDIlNAhLtC7hYcnEzJWq5dqwPFSAC8rZaEp4qSiKyXB6azkryHGY/jgDguU7joSqw4v7cl1B9ZSSWdrBGhpVUjzg6wRDpatuB0xpMvMYpR6EdKshQP08HOM9VVSmacE9naxsOyYbiJpujy3SO3X+VSkdFLuZ7Nic4B3qiH1mEJ5qrsnppSDERBwnuna1PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(136003)(346002)(16576012)(316002)(30864003)(66946007)(36756003)(44832011)(8676002)(31686004)(83380400001)(66476007)(5660300002)(66556008)(186003)(26005)(16526019)(38100700002)(38350700002)(956004)(86362001)(31696002)(2616005)(8936002)(478600001)(2906002)(6486002)(52116002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3NYdTZjVXg0eUprNm9vYlZkcjFzUmJveWM3Uy9EOUhLVGhTYVJJK3IyTEw0?=
 =?utf-8?B?QUM5NExNRE9aa1VtOEVGMW5DUkFQOU93NXNUZTcwLytXUCt6VFJtMHFDM3Vt?=
 =?utf-8?B?UVpiNUE5blRMb3RFUVBJaXFOMmRNWXl2WnhtOTVjT3N4dVVhb0wrVFpJQkwv?=
 =?utf-8?B?ZlpTdmJUczJLRWxlS0Ryam5pcDJZSUdYbTJwM0hMOFlJcjBMWlRxNGN0OU96?=
 =?utf-8?B?K3VtcTBNUkIraFpoUnRNbGloVXhZdTNLamF2allDSFlKUmo0R0pSMTNOVUZu?=
 =?utf-8?B?ZnJUWXhKZ3NzR2pLUWxKUG1PZGxweW1LckIzWldWV2wzdXdZK1Yzd2F5M2xO?=
 =?utf-8?B?emU2OWsxbXlLc0JURFlNYnVZWllBUTEyN0FXd0Q2MExlS2dNd0cxaXJYR0k3?=
 =?utf-8?B?ZkhCZlZBVmFlVnFPNmFXZkp1V2lwYk9yelRjMkMwT2gxaDZqdWRrUWRqakgz?=
 =?utf-8?B?cXFtRmVJbVM3TEVyQ1Irb1E2bFlXQThCb2FRMXpuWE1uak9NMkt1RkxOZVMy?=
 =?utf-8?B?NnkzaVMzeHR1VU5rc2JtMUN4eDFoYytlRUJjYzlLM1lwaVRQTXgxRXhrbUxa?=
 =?utf-8?B?S0h5c1ZxaDEwbWVycDNxUmhjam9VeUdOdThLNGFRcnFveGlaREFVcnhSQVhY?=
 =?utf-8?B?K25JWVIrbjQwZ2dhZ1JMQlpxV0dOdWNMREhLem55a2dnaVJoSXYzK1FDY0Fv?=
 =?utf-8?B?amdVTHYyK2RzTmhoUVZTQk5leHRtbFdmU2lvUzNIQ1cwUUdqY3Z3Ni9NNGxY?=
 =?utf-8?B?Y3lHV25zRE5jT01kQnZGdHRZRXd6UUJ4NW1zS3RqVjU5R0doeWw3bjNPUW9O?=
 =?utf-8?B?WkpPZTdGalF5cmZURm1yL0VWbFlZMWpDd3VpSzlvYVRZSHZyNFBkeWpPN2kr?=
 =?utf-8?B?WmcwNXowRjJXeVI0aEFNWSt0L3FLRDNJWHN5YzE4cUlaeFRHdnlSTGhpT0lM?=
 =?utf-8?B?TGdZNXhxTWhvWmRhYTBTaGs3L1Q0Q3RnVXUwVTIvQThWNEtzdjJ2aitUV050?=
 =?utf-8?B?d2t1TjNmWjg5T1ZhWEZxRFlGSkZqSGIwUDFjY3B1YkhVTFNia0hwMTYrUkVS?=
 =?utf-8?B?TjVvV3B1T0JwdlhLK0FaOXFEclF5aU5SZXAzSU9oNEtGVUFvcDhiQmdXOFM1?=
 =?utf-8?B?cTc5d0VxZ1pVNUZRZzA3aDYzclkxN3hucTBBYjdXQXFNWERtdU9MZUtFcjcw?=
 =?utf-8?B?TU5henF0UHRpV3MvRWJqY09CWDNsVVBpNUhkWlNQSWgwRis5akM4RzNYdEFU?=
 =?utf-8?B?YjJKMUZZOUkrT25DTlhiSUpUaWZ4MnFlU0Rra0F4dHhEY3RSZzE3VG5LNjFz?=
 =?utf-8?B?ZkFPVk1tazkrMjFWUmM4R3Q1VTBTME5XZyt4Zjhrb3VpUUQvNEhkMHZQQmV2?=
 =?utf-8?B?bVFsSnk0bUZXRTVja1lUWk9xQ3k5WVp5NWFTTnlqWFNuSmlSNklEdHpmOVpI?=
 =?utf-8?B?TS9Ya29vbXg3NDhkaHlrNzFFaU8ybmxhcHArMmM4RVNFcTUwSlVxa0tyTVQr?=
 =?utf-8?B?M1pNYms0YmI2SkIzMDczQ2FmdWZRSU92QlF3UFk2YTBkR2k5Z2hkWjRBS2Q1?=
 =?utf-8?B?VjF3dUVKRnRCRmVxVFpHaFgvdzJCa3JoWDdqdmRpbEpTUFFDOHQzdzNjRWVV?=
 =?utf-8?B?cmdkenJtWnplTWNNMk05UWM3Rk13am5nKzNiS29qaXpEZ2hUR3dQVDFCZG9t?=
 =?utf-8?B?RThrbE55QXQ3T0tuWHBWejQ1QmZsYVpJbkxFYzVyL3JYbHZhK0RhZ3lNMENa?=
 =?utf-8?Q?o1AGwKa3yTw7vqfTjHzxkRk4JYmP55IFQt5lHUb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2770e19-82e2-4227-37a5-08d926df1fb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 22:30:00.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cy7AZzDtKtCQnVjBIukJIcw4Sv6lQucfe/GoZjXGVH6q1BQsaM+I8AdWHt8TXZBjYswgUWg7TfAg+oFnt+Ohmm/zcFU3JWaGY1c2CDggB8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030148
X-Proofpoint-GUID: A46SLfR9jZ6q_QTOkwcXml2zjfNyoAQk
X-Proofpoint-ORIG-GUID: A46SLfR9jZ6q_QTOkwcXml2zjfNyoAQk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/2/21 10:22 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The AIL pushing is stalling on log forces when it comes across
> pinned items. This is happening on removal workloads where the AIL
> is dominated by stale items that are removed from AIL when the
> checkpoint that marks the items stale is committed to the journal.
> This results is relatively few items in the AIL, but those that are
> are often pinned as directories items are being removed from are
> still being logged.
> 
> As a result, many push cycles through the CIL will first issue a
> blocking log force to unpin the items. This can take some time to
> complete, with tracing regularly showing push delays of half a
> second and sometimes up into the range of several seconds. Sequences
> like this aren't uncommon:
> 
> ....
>   399.829437:  xfsaild: last lsn 0x11002dd000 count 101 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 270ms delay>
>   400.099622:  xfsaild: target 0x11002f3600, prev 0x11002f3600, last lsn 0x0
>   400.099623:  xfsaild: first lsn 0x11002f3600
>   400.099679:  xfsaild: last lsn 0x1100305000 count 16 stuck 11 flushing 0 tout 50
> <wanted 50ms, got 500ms delay>
>   400.589348:  xfsaild: target 0x110032e600, prev 0x11002f3600, last lsn 0x0
>   400.589349:  xfsaild: first lsn 0x1100305000
>   400.589595:  xfsaild: last lsn 0x110032e600 count 156 stuck 101 flushing 30 tout 50
> <wanted 50ms, got 460ms delay>
>   400.950341:  xfsaild: target 0x1100353000, prev 0x110032e600, last lsn 0x0
>   400.950343:  xfsaild: first lsn 0x1100317c00
>   400.950436:  xfsaild: last lsn 0x110033d200 count 105 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 200ms delay>
>   401.142333:  xfsaild: target 0x1100361600, prev 0x1100353000, last lsn 0x0
>   401.142334:  xfsaild: first lsn 0x110032e600
>   401.142535:  xfsaild: last lsn 0x1100353000 count 122 stuck 101 flushing 8 tout 10
> <wanted 10ms, got 10ms delay>
>   401.154323:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x1100353000
>   401.154328:  xfsaild: first lsn 0x1100353000
>   401.154389:  xfsaild: last lsn 0x1100353000 count 101 stuck 101 flushing 0 tout 20
> <wanted 20ms, got 300ms delay>
>   401.451525:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
>   401.451526:  xfsaild: first lsn 0x1100353000
>   401.451804:  xfsaild: last lsn 0x1100377200 count 170 stuck 22 flushing 122 tout 50
> <wanted 50ms, got 500ms delay>
>   401.933581:  xfsaild: target 0x1100361600, prev 0x1100361600, last lsn 0x0
> ....
> 
> In each of these cases, every AIL pass saw 101 log items stuck on
> the AIL (pinned) with very few other items being found. Each pass, a
> log force was issued, and delay between last/first is the sleep time
> + the sync log force time.
> 
> Some of these 101 items pinned the tail of the log. The tail of the
> log does slowly creep forward (first lsn), but the problem is that
> the log is actually out of reservation space because it's been
> running so many transactions that stale items that never reach the
> AIL but consume log space. Hence we have a largely empty AIL, with
> long term pins on items that pin the tail of the log that don't get
> pushed frequently enough to keep log space available.
> 
> The problem is the hundreds of milliseconds that we block in the log
> force pushing the CIL out to disk. The AIL should not be stalled
> like this - it needs to run and flush items that are at the tail of
> the log with minimal latency. What we really need to do is trigger a
> log flush, but then not wait for it at all - we've already done our
> waiting for stuff to complete when we backed off prior to the log
> force being issued.
> 
> Even if we remove the XFS_LOG_SYNC from the xfs_log_force() call, we
> still do a blocking flush of the CIL and that is what is causing the
> issue. Hence we need a new interface for the CIL to trigger an
> immediate background push of the CIL to get it moving faster but not
> to wait on that to occur. While the CIL is pushing, the AIL can also
> be pushing.
> 
> We already have an internal interface to do this -
> xlog_cil_push_now() - but we need a wrapper for it to be used
> externally. xlog_cil_force_seq() can easily be extended to do what
> we need as it already implements the synchronous CIL push via
> xlog_cil_push_now(). Add the necessary flags and "push current
> sequence" semantics to xlog_cil_force_seq() and convert the AIL
> pushing to use it.
> 
> One of the complexities here is that the CIL push does not guarantee
> that the commit record for the CIL checkpoint is written to disk.
> The current log force ensures this by submitting the current ACTIVE
> iclog that the commit record was written to. We need the CIL to
> actually write this commit record to disk for an async push to
> ensure that the checkpoint actually makes it to disk and unpins the
> pinned items in the checkpoint on completion. Hence we need to pass
> down to the CIL push that we are doing an async flush so that it can
> switch out the commit_iclog if necessary to get written to disk when
> the commit iclog is finally released.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_log.c       | 38 ++++++++++++++------------
>   fs/xfs/xfs_log.h       |  1 +
>   fs/xfs/xfs_log_cil.c   | 61 ++++++++++++++++++++++++++++++++++++------
>   fs/xfs/xfs_log_priv.h  |  5 ++++
>   fs/xfs/xfs_sysfs.c     |  1 +
>   fs/xfs/xfs_trace.c     |  1 +
>   fs/xfs/xfs_trans.c     |  2 +-
>   fs/xfs/xfs_trans_ail.c | 11 +++++---
>   8 files changed, 91 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index aa37f4319052..c53644d19dd3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -50,11 +50,6 @@ xlog_state_get_iclog_space(
>   	int			*continued_write,
>   	int			*logoffsetp);
>   STATIC void
> -xlog_state_switch_iclogs(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	int			eventual_size);
> -STATIC void
>   xlog_grant_push_ail(
>   	struct xlog		*log,
>   	int			need_bytes);
> @@ -3104,7 +3099,7 @@ xfs_log_ticket_ungrant(
>    * This routine will mark the current iclog in the ring as WANT_SYNC and move
>    * the current iclog pointer to the next iclog in the ring.
>    */
> -STATIC void
> +void
>   xlog_state_switch_iclogs(
>   	struct xlog		*log,
>   	struct xlog_in_core	*iclog,
> @@ -3251,6 +3246,20 @@ xfs_log_force(
>   	return -EIO;
>   }
>   
> +/*
> + * Force the log to a specific LSN.
> + *
> + * If an iclog with that lsn can be found:
> + *	If it is in the DIRTY state, just return.
> + *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
> + *		state and go to sleep or return.
> + *	If it is in any other state, go to sleep or return.
> + *
> + * Synchronous forces are implemented with a wait queue.  All callers trying
> + * to force a given lsn to disk must wait on the queue attached to the
> + * specific in-core log.  When given in-core log finally completes its write
> + * to disk, that thread will wake up all threads waiting on the queue.
> + */
>   static int
>   xlog_force_lsn(
>   	struct xlog		*log,
> @@ -3314,18 +3323,13 @@ xlog_force_lsn(
>   }
>   
>   /*
> - * Force the in-core log to disk for a specific LSN.
> + * Force the log to a specific checkpoint sequence.
>    *
> - * Find in-core log with lsn.
> - *	If it is in the DIRTY state, just return.
> - *	If it is in the ACTIVE state, move the in-core log into the WANT_SYNC
> - *		state and go to sleep or return.
> - *	If it is in any other state, go to sleep or return.
> - *
> - * Synchronous forces are implemented with a wait queue.  All callers trying
> - * to force a given lsn to disk must wait on the queue attached to the
> - * specific in-core log.  When given in-core log finally completes its write
> - * to disk, that thread will wake up all threads waiting on the queue.
> + * First force the CIL so that all the required changes have been flushed to the
> + * iclogs. If the CIL force completed it will return a commit LSN that indicates
> + * the iclog that needs to be flushed to stable storage. If the caller needs
> + * a synchronous log force, we will wait on the iclog with the LSN returned by
> + * xlog_cil_force_seq() to be completed.
>    */
>   int
>   xfs_log_force_seq(
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 813b972e9788..1bd080ce3a95 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -104,6 +104,7 @@ struct xlog_ticket;
>   struct xfs_log_item;
>   struct xfs_item_ops;
>   struct xfs_trans;
> +struct xlog;
>   
>   int	  xfs_log_force(struct xfs_mount *mp, uint flags);
>   int	  xfs_log_force_seq(struct xfs_mount *mp, xfs_csn_t seq, uint flags,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3c2b1205944d..cb849e67b1c4 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -658,6 +658,7 @@ xlog_cil_push_work(
>   	xfs_lsn_t		push_seq;
>   	struct bio		bio;
>   	DECLARE_COMPLETION_ONSTACK(bdev_flush);
> +	bool			push_commit_stable;
>   
>   	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>   	new_ctx->ticket = xlog_cil_ticket_alloc(log);
> @@ -668,6 +669,8 @@ xlog_cil_push_work(
>   	spin_lock(&cil->xc_push_lock);
>   	push_seq = cil->xc_push_seq;
>   	ASSERT(push_seq <= ctx->sequence);
> +	push_commit_stable = cil->xc_push_commit_stable;
> +	cil->xc_push_commit_stable = false;
>   
>   	/*
>   	 * As we are about to switch to a new, empty CIL context, we no longer
> @@ -910,8 +913,15 @@ xlog_cil_push_work(
>   	 * The commit iclog must be written to stable storage to guarantee
>   	 * journal IO vs metadata writeback IO is correctly ordered on stable
>   	 * storage.
> +	 *
> +	 * If the push caller needs the commit to be immediately stable and the
> +	 * commit_iclog is not yet marked as XLOG_STATE_WANT_SYNC to indicate it
> +	 * will be written when released, switch it's state to WANT_SYNC right
> +	 * now.
>   	 */
>   	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> +	if (push_commit_stable && commit_iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(log, commit_iclog, 0);
>   	xlog_state_release_iclog(log, commit_iclog);
>   	spin_unlock(&log->l_icloglock);
>   	return;
> @@ -996,13 +1006,26 @@ xlog_cil_push_background(
>   /*
>    * xlog_cil_push_now() is used to trigger an immediate CIL push to the sequence
>    * number that is passed. When it returns, the work will be queued for
> - * @push_seq, but it won't be completed. The caller is expected to do any
> - * waiting for push_seq to complete if it is required.
> + * @push_seq, but it won't be completed.
> + *
> + * If the caller is performing a synchronous force, we will flush the workqueue
> + * to get previously queued work moving to minimise the wait time they will
> + * undergo waiting for all outstanding pushes to complete. The caller is
> + * expected to do the required waiting for push_seq to complete.
> + *
> + * If the caller is performing an async push, we need to ensure that the
> + * checkpoint is fully flushed out of the iclogs when we finish the push. If we
> + * don't do this, then the commit record may remain sitting in memory in an
> + * ACTIVE iclog. This then requires another full log force to push to disk,
> + * which defeats the purpose of having an async, non-blocking CIL force
> + * mechanism. Hence in this case we need to pass a flag to the push work to
> + * indicate it needs to flush the commit record itself.
>    */
>   static void
>   xlog_cil_push_now(
>   	struct xlog	*log,
> -	xfs_lsn_t	push_seq)
> +	xfs_lsn_t	push_seq,
> +	bool		async)
>   {
>   	struct xfs_cil	*cil = log->l_cilp;
>   
> @@ -1012,7 +1035,8 @@ xlog_cil_push_now(
>   	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
>   
>   	/* start on any pending background push to minimise wait time on it */
> -	flush_work(&cil->xc_push_work);
> +	if (!async)
> +		flush_work(&cil->xc_push_work);
>   
>   	/*
>   	 * If the CIL is empty or we've already pushed the sequence then
> @@ -1025,6 +1049,7 @@ xlog_cil_push_now(
>   	}
>   
>   	cil->xc_push_seq = push_seq;
> +	cil->xc_push_commit_stable = async;
>   	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
>   	spin_unlock(&cil->xc_push_lock);
>   }
> @@ -1109,12 +1134,27 @@ xlog_cil_commit(
>   	xlog_cil_push_background(log);
>   }
>   
> +/*
> + * Flush the CIL to stable storage but don't wait for it to complete. This
> + * requires the CIL push to ensure the commit record for the push hits the disk,
> + * but otherwise is no different to a push done from a log force.
> + */
> +void
> +xlog_cil_flush(
> +	struct xlog	*log)
> +{
> +	xfs_csn_t	seq = log->l_cilp->xc_current_sequence;
> +
> +	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
> +	xlog_cil_push_now(log, seq, true);
> +}
> +
>   /*
>    * Conditionally push the CIL based on the sequence passed in.
>    *
> - * We only need to push if we haven't already pushed the sequence
> - * number given. Hence the only time we will trigger a push here is
> - * if the push sequence is the same as the current context.
> + * We only need to push if we haven't already pushed the sequence number given.
> + * Hence the only time we will trigger a push here is if the push sequence is
> + * the same as the current context.
>    *
>    * We return the current commit lsn to allow the callers to determine if a
>    * iclog flush is necessary following this call.
> @@ -1130,13 +1170,17 @@ xlog_cil_force_seq(
>   
>   	ASSERT(sequence <= cil->xc_current_sequence);
>   
> +	if (!sequence)
> +		sequence = cil->xc_current_sequence;
> +	trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
> +
>   	/*
>   	 * check to see if we need to force out the current context.
>   	 * xlog_cil_push() handles racing pushes for the same sequence,
>   	 * so no need to deal with it here.
>   	 */
>   restart:
> -	xlog_cil_push_now(log, sequence);
> +	xlog_cil_push_now(log, sequence, false);
>   
>   	/*
>   	 * See if we can find a previous sequence still committing.
> @@ -1160,6 +1204,7 @@ xlog_cil_force_seq(
>   			 * It is still being pushed! Wait for the push to
>   			 * complete, then start again from the beginning.
>   			 */
> +			XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
>   			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
>   			goto restart;
>   		}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2d7e7cbee8b7..a863ccb5ece6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -273,6 +273,7 @@ struct xfs_cil {
>   
>   	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
>   	xfs_csn_t		xc_push_seq;
> +	bool			xc_push_commit_stable;
>   	struct list_head	xc_committing;
>   	wait_queue_head_t	xc_commit_wait;
>   	xfs_csn_t		xc_current_sequence;
> @@ -487,9 +488,12 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>   		struct xlog_in_core **commit_iclog, uint optype);
>   int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>   		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
> +
>   void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>   void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>   
> +void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
> +		int eventual_size);
>   int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
>   
>   /*
> @@ -560,6 +564,7 @@ void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
>   /*
>    * CIL force routines
>    */
> +void xlog_cil_flush(struct xlog *log);
>   xfs_lsn_t xlog_cil_force_seq(struct xlog *log, xfs_csn_t sequence);
>   
>   static inline void
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index f1bc88f4367c..18dc5eca6c04 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -10,6 +10,7 @@
>   #include "xfs_log_format.h"
>   #include "xfs_trans_resv.h"
>   #include "xfs_sysfs.h"
> +#include "xfs_log.h"
>   #include "xfs_log_priv.h"
>   #include "xfs_mount.h"
>   
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 9b8d703dc9fd..d111a994b7b6 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -20,6 +20,7 @@
>   #include "xfs_bmap.h"
>   #include "xfs_attr.h"
>   #include "xfs_trans.h"
> +#include "xfs_log.h"
>   #include "xfs_log_priv.h"
>   #include "xfs_buf_item.h"
>   #include "xfs_quota.h"
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 87bffd12c20c..c214a69b573d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -9,7 +9,6 @@
>   #include "xfs_shared.h"
>   #include "xfs_format.h"
>   #include "xfs_log_format.h"
> -#include "xfs_log_priv.h"
>   #include "xfs_trans_resv.h"
>   #include "xfs_mount.h"
>   #include "xfs_extent_busy.h"
> @@ -17,6 +16,7 @@
>   #include "xfs_trans.h"
>   #include "xfs_trans_priv.h"
>   #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>   #include "xfs_trace.h"
>   #include "xfs_error.h"
>   #include "xfs_defer.h"
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index dbb69b4bf3ed..69aac416e2ce 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -17,6 +17,7 @@
>   #include "xfs_errortag.h"
>   #include "xfs_error.h"
>   #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>   
>   #ifdef DEBUG
>   /*
> @@ -429,8 +430,12 @@ xfsaild_push(
>   
>   	/*
>   	 * If we encountered pinned items or did not finish writing out all
> -	 * buffers the last time we ran, force the log first and wait for it
> -	 * before pushing again.
> +	 * buffers the last time we ran, force a background CIL push to get the
> +	 * items unpinned in the near future. We do not wait on the CIL push as
> +	 * that could stall us for seconds if there is enough background IO
> +	 * load. Stalling for that long when the tail of the log is pinned and
> +	 * needs flushing will hard stop the transaction subsystem when log
> +	 * space runs out.
>   	 */
>   	if (ailp->ail_log_flush && ailp->ail_last_pushed_lsn == 0 &&
>   	    (!list_empty_careful(&ailp->ail_buf_list) ||
> @@ -438,7 +443,7 @@ xfsaild_push(
>   		ailp->ail_log_flush = 0;
>   
>   		XFS_STATS_INC(mp, xs_push_ail_flush);
> -		xfs_log_force(mp, XFS_LOG_SYNC);
> +		xlog_cil_flush(mp->m_log);
>   	}
>   
>   	spin_lock(&ailp->ail_lock);
> 
