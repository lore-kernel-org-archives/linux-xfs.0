Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E6BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 20:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiCAUkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 15:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbiCAUkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 15:40:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C98E506D8
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 12:39:53 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 221J0e9F032600;
        Tue, 1 Mar 2022 20:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QlJ7SROdRxqFotlHve/dSTOY3XePMeig1jZWponBafw=;
 b=tMGAPfw1JqVMLwT0InilVCGPLh/+jne6ob4hpZv0hnkQn82LhwBASheFcbXcMyUDK9uc
 Vz8M+PRrkvfiosCNRZBMoUBlnP0YJGPO9tYa1RwmxhrAwrt1xAzB+zZ9ifOS/vEEVOXb
 1EuslQZThuCCK8BQwKC4I8RFB/lEPH9MQ5/vhQeywhqGrmCIXOp3NG9nEfEcR7Ux0myV
 ng6E7oSRhCc85wT7mLFT5ipwrzcBlyWkJn1oXhwQpnXk8jSW0Le9QXzaKvoamsgCXxIP
 ZJB2zXXfsHEHwXNX2fq2eCurbnZl2+qCeRvbisdgZXREIrkAmR9OCyP+6St9W7b/Lnfo qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2ehs32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 20:39:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221KZPV2049827;
        Tue, 1 Mar 2022 20:39:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 3efa8eqt5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 20:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THPdCIUf3zVNfWN5pH8XdowMvhilXPUh5LDgBMTaCJiWQQRg+K4TxnTeP7He6kMREdYR20ugVjw9BJuM6axnOPDvRaRnt+Ke+OC8oclTNLiKkzzSFnnDsR1TqzxwQVP8lukvtc/sdE9r9mPU1brZEcEJMNbHLH0xiJlail6LTMWBUUu6SmBLSg7QVGqquTL//fVXKNLSK0MLFs7ODWxVsV5nb2dbQ+x4y8Cwvq0CcWbcVK4mnvik04bRdad/U3yVYNkc2VAGx5rY3V/YCDLFs3xItpO88H/nskf2B/GP6WUbpjRrEWQWEWhNgw7ylH0mJd85OvZfyr8ssZYCiWci2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlJ7SROdRxqFotlHve/dSTOY3XePMeig1jZWponBafw=;
 b=neVNfs6ImOQK6ZKCV+zcc2hOf6+5p4bjXljQzoVBM4+jUOF+yGHmhERcBr67nSQQ8l6u4ZIp11is/zvm37LgHeMplWVoBhyAIeF2Oesut9FlxwnbRTRWO+y0azlQSgzMDnV+A3S8+JRHUGWN//RzcnnEJAFG/tXXZQKy1De7e9LsptdfKhUhFzkDhxtHIM8plBeHLqdp2wH1LX6IjbSmmQAr57QLPgwcdAe7neiyNjcmFAdtb3qbN8PD9X1VoLlmOcQfL30nIprrsl+DZXEFT4bkACR9wTetbkPVfzj+derlfjuF4VoSYWtLm59NaH7+/my5jigLPJk8erNCLjRKyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlJ7SROdRxqFotlHve/dSTOY3XePMeig1jZWponBafw=;
 b=smVkku9Lwg6mjVrE58j58V1H//QvGBOZmGh+vWX4GfO8DVjtIiS5uzVH6oo1FwUTZleJND0HEg0GZFIZZ5z4qogMZ5tyUdEetWcFilmUc+udWGFcL+Uo4lgk2r+jntxqXcmheeG1iCxkOVulB1etr15la+zbbQR8wa7b8batleg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MN2PR10MB3293.namprd10.prod.outlook.com (2603:10b6:208:12b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 20:39:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 20:39:39 +0000
Message-ID: <d93c3a9a-126b-058b-81e2-bdf2e675ad0a@oracle.com>
Date:   Tue, 1 Mar 2022 13:39:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v28 00/15] xfs: Log Attribute Replay
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
 <20220301022920.GC117732@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220301022920.GC117732@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:74::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72802a84-e58f-4c67-e10f-08d9fbc39b03
X-MS-TrafficTypeDiagnostic: MN2PR10MB3293:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3293E46552178CC764AA4C8D95029@MN2PR10MB3293.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rt0QF0++psvvDqKllM0QO3jZZm2TKkzdd8PBcyeJ0XwCUdA6R/VvWmLaKDdMMgCvBbo4PDJfxxc3AaqXJv03akyPTphKrbx2uueiEh1mVz8q9E3UCN/AsXN9Zm2RPaWyzHn5XqWw5TDuUBdITD+/26T9lzVsJfDNkY2SIZkJLnbby9h1B10TrFAKU9W+1aj42GRKro6croBSzgDWfbdhlbZmYfjSp/FGHmDn7MKJpcYpx/64ni634Hi6mNNRo13lIVhTRDVDjtg262a8I18xYXgREOmR+LUQyFf55CWfCLTFz3kqIUpiFEccJyk7NRb0O2LhJPhveJzN4EL3KvlG7t8UZ3ENdsYGG7h+MC9CccmoLuEIkDAV/SbO3TS8/65a5V8kijdN0xUi7lYE7pPcIoWojZ8AdwqannQHMrStcVnJDxK7Mv5C2NpdJBl2m8BZ6rpat6parQ++7fB+hcFsfnJ43mwTfu43DAok/YsS3zsNxgJOPsBcGyWJvQmJnziG8QEOrW/P1x53FzoqOLY04TbASgNt+l8NaaIRNl/U0EeMqxfcTiJa2veJBMLqjs/mMQVHIR0/QbBMzuFht9pH61nF6MbC5PL9W9k7w7+7clTE6FvBsjqU1PEjFQsyupLjjwnpGiSg/nLb271Y2JF1OZ9YzU5M1TTbmEHzpJDMdgJ2Etu4zuWFMVfJwYdtOC8RaJO6e/UHH/Na3aXb1X8C5pSIKFJ2oF1OjyKOdPbYxxJYt86jI7HlrY/Rv5SL4UmBeyM+o7ii/7PfnhSjZ7o1ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(8676002)(36756003)(45080400002)(52116002)(53546011)(6506007)(316002)(6916009)(30864003)(4326008)(8936002)(66476007)(38100700002)(38350700002)(66556008)(66946007)(6512007)(44832011)(186003)(31686004)(6666004)(86362001)(31696002)(2906002)(2616005)(83380400001)(26005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHhJTEZHV05uRGY1blpEclZYRzZmNVFteXB3ekZPejFNMkdVMm5ZSmtsVHJh?=
 =?utf-8?B?dFNQM2Q2MFV1d0JGdGp4WWFVZklTU2hzYUIzT0Npd0JJeXphZWk3YkJreDdq?=
 =?utf-8?B?UVo2VTNrNmdwajBoUUNMUDRpdjRxZFlvaUdhRGZ5VWZPUTdNWHJqeXE5cDE1?=
 =?utf-8?B?ZjhlcGF6Tml3TXB3WElYQ0E5NTRONTlmMTdBVDFmSkFDN2ZneGtCUkkvalor?=
 =?utf-8?B?ZTRFUTV4aWZOcU5vUEMrZmlZL3pBdnZObXk3a3hQQUdwaDdjQUwwaDBoUTdR?=
 =?utf-8?B?OGRkTkZXaXFHOHRtK0VEc2Z1WHZ3OVRIbUZSMU1MeVlhT2pqbzJFSUN3MlVQ?=
 =?utf-8?B?aUlLMDdzMEVCQ01XaEhEOTlxcjJmR21wVGVURktzbXdOdnVlU0Q1SXp2SGVm?=
 =?utf-8?B?cm5nRitHcmJIYzU1UHUxakVhZmhTOFZ0T3R5K1EreEtRUWhaSEZFWnFmWU5r?=
 =?utf-8?B?N3E5amZ1bHpZY25TemJJeG1jZUdCY1lLaEFBT1l6eXUvTGFma0FkS3RKSDFj?=
 =?utf-8?B?N0xOK0hNUFdrb2RhcFFWVmtzSk9La3E5Y2p6d3dPWVEyZXZxQjFWaXdwMDFJ?=
 =?utf-8?B?SkR5bUQ0T3pjNndwY2lzS1VpZmpJZzdEVXE2cG5hT3h2b0tHT3k5S0pxTytr?=
 =?utf-8?B?cXdYcDUzaFg3U1J6aWtRTzM2L29vSmR4Y0MzdzVBUHBmTjRpR3c4Wm5WTVNv?=
 =?utf-8?B?RVBBeksvSGpZZGhwZ0ZkN1pHQUxUMGxGMFh2Zk9ZV3BqSit5clc4bFlBc3R1?=
 =?utf-8?B?VXNlUEw4aEkyemtoaVJyMDVqVVZRQUFNRFN6eFcwZUlMeEFEaUgxR2hqOEtw?=
 =?utf-8?B?amtKSnBvdW1OWXhtWVZWU3Q4dEFGUVExNjhQMGdobjF0Ny80RU9hUG1mRlkz?=
 =?utf-8?B?VmVTWDNndFlOSloyNkh6angrMUxZd09rUWtkRG9VZHJEYy9BTURlU0tCTVBa?=
 =?utf-8?B?Y1BqMVdLUUhNUXUwY1JuV3RQMlRtdVQxa29NL2ZFdXY2WmwvektLUTJOZjda?=
 =?utf-8?B?S3NyY09FdUVvV0VsY3ZjWmlBbHRuem9tK0k5N0taMk5UVFNiQWExSXNaMkN1?=
 =?utf-8?B?a0FEZ1VmYXJLczZvWmFyRHBaZlBiT1dTcU5JWjRzRHZ5Vk9vcFVsbXFrU1lq?=
 =?utf-8?B?dElyUnZ1a1lmUWFVTkxwTk5QM0NCbU9jNXpQQmxHR1c0MTBuZzBJdTZvaElS?=
 =?utf-8?B?L2ljZW1PTE9Zakk2aUswZUlMZjJCb040ZDVjZlZ6b0NqV3RtSUwwSGdQYVBo?=
 =?utf-8?B?S0xLRTR0NThrUEVvcHllR3NlUkw0VEtxbk5xVTBMb3kzOGo5a05uVVU3R0FU?=
 =?utf-8?B?U0l1ak1Nd3pGVUJhYm1pU1lLYjgvRE5GYjh0b1FKazFRd3Z3dWNTTnZmMFhL?=
 =?utf-8?B?WVp1U29pVVVKNnVFMmZReDErK1JscHArQmVCN3RNYjNMU1lXa1ZlczZoaVRW?=
 =?utf-8?B?dkJwdjdVNWcvR2JXY252UVFGWFNpalRyaXE3bTkrMXpESWNvbktQRkVpZ1JR?=
 =?utf-8?B?cUM1bFpsajNIa20rWUtyWWRiQm5aN0tRUGxsR1VrUTNIa1hyVmJKYXJ4QlJK?=
 =?utf-8?B?cWd3a2VOb1RDN1hqVGxyVEFmYnIxR0ZDcFM2VFpPSFhRcWl1dFBYdFRudFZh?=
 =?utf-8?B?UUprRFA1c2lQNDVBNnQ2Ny9ITndOdnVva3BhdUorcEM4U09DNUViN0RTOExh?=
 =?utf-8?B?ckl3MlZsSzhMWTZVNFp3RzdGNnNwODNsUHJNY0hXeWFWQUxCdG5hMFluU3BW?=
 =?utf-8?B?NFRTQWphOG04WEc2SjRQckswN1FkYmRxc2JHTXA5QTVYMjZkSmF2VHZNVFBh?=
 =?utf-8?B?cVZIa0tOUDk1M29yTFdKU04wd2FXQTB1MG9lTEVsMEJnVDdRRExQMUhVc3I2?=
 =?utf-8?B?a0RWa1BMK3FtZ0tDME9meld2cUdJYWlVcFlydWlUMzVxSjFqTGs3TTlwa2ZT?=
 =?utf-8?B?MGlOa1Y1RDZ2aEZLd0I0SWVkbmRReTdiZUlNbytFaUE1MEI0eUROMFF0UGc4?=
 =?utf-8?B?OEptcXRWU3drRU1WRWFrZjN1YXBJdkRuOVZCWmZMbW9FcWtiQ2lrUU9lR1hs?=
 =?utf-8?B?cGNweHh0T1BUMFhIVlQ3UGExRkNaWE4ycVlXbG9Tei9VT1poZ2tvSk1vZEww?=
 =?utf-8?B?OS8vZjd2UHdya0FoQ0prWjFDUUVkSUtJdWJKNTFPZlBOWEoyUGtmc25vQ3dS?=
 =?utf-8?B?NGRVMGtyaUZqbFVZMml0VURxYXFwVGJlb09NMUNZcEo3K2xiLzM0bnJteFRn?=
 =?utf-8?B?Tk14aVNzTEtGK2RuWnZ6ZmtaSDV3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72802a84-e58f-4c67-e10f-08d9fbc39b03
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 20:39:38.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rymI86rOLjG8pohX2IaULejXK82PJ+PxjeKD4p/nk2m1GCvRPhAxThLc4T/K+INEyoKBWrpqCVtdUkWU5kgWU4ZaaExlziHX1wv03hXJzio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3293
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010103
X-Proofpoint-ORIG-GUID: IxiNBHF3AofTPyHTaTkg1r0PjKc9qYds
X-Proofpoint-GUID: IxiNBHF3AofTPyHTaTkg1r0PjKc9qYds
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/28/22 7:29 PM, Darrick J. Wong wrote:
> On Mon, Feb 28, 2022 at 12:51:32PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> This set is a subset of a larger series parent pointers. Delayed attributes allow
>> attribute operations (set and remove) to be logged and committed in the same
>> way that other delayed operations do. This allows more complex operations (like
>> parent pointers) to be broken up into multiple smaller transactions. To do
>> this, the existing attr operations must be modified to operate as a delayed
>> operation.  This means that they cannot roll, commit, or finish transactions.
>> Instead, they return -EAGAIN to allow the calling function to handle the
>> transaction.  In this series, we focus on only the delayed attribute portion.
>> We will introduce parent pointers in a later set.
>>
>> The set as a whole is a bit much to digest at once, so I usually send out the
>> smaller sub series to reduce reviewer burn out.  But the entire extended series
>> is visible through the included github links.
>>
>> Updates since v27:
>> xfs: don't commit the first deferred transaction without intents
>>    Comment update
> 
> I applied this to 5.16-rc6, and turned on larp mode.  generic/476
> tripped over something, and this is what kasan had to say:
> 
> [  835.381655] run fstests generic/476 at 2022-02-28 18:22:04
> [  838.008485] XFS (sdb): Mounting V5 Filesystem
> [  838.035529] XFS (sdb): Ending clean mount
> [  838.040528] XFS (sdb): Quotacheck needed: Please wait.
> [  838.050866] XFS (sdb): Quotacheck: Done.
> [  838.092369] XFS (sdb): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
> [  838.092938] general protection fault, probably for non-canonical address 0xe012f573e6000046: 0000 [#1] PREEMPT SMP KASAN
> [  838.099085] KASAN: maybe wild-memory-access in range [0x0097cb9f30000230-0x0097cb9f30000237]
> [  838.101148] CPU: 2 PID: 4403 Comm: fsstress Not tainted 5.17.0-rc5-djwx #rc5 63f7e400b85b2245f2d4d3033e82ec8bc95c49fd
> [  838.103757] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [  838.105811] RIP: 0010:xlog_cil_commit+0x2f9/0x2800 [xfs]
> 
> 
> FWIW, gdb says this address is:
> 
> 0xffffffffa06e0739 is in xlog_cil_commit (fs/xfs/xfs_log_cil.c:237).
> 232
> 233                     /*
> 234                      * if we have no shadow buffer, or it is too small, we need to
> 235                      * reallocate it.
> 236                      */
> 237                     if (!lip->li_lv_shadow ||
> 238                         buf_size > lip->li_lv_shadow->lv_size) {
> 239                             /*
> 240                              * We free and allocate here as a realloc would copy
> 241                              * unnecessary data. We don't use kvzalloc() for the
> 
> I don't know what this is about, but my guess is that we freed something
> we weren't supposed to...?
> 
> (An overnight fstests run with v27 and larp=0 ran fine, though...)
> 
> --D

Hmm, ok, I will dig into this then.  I dont see anything between v27 and 
v28 that would have cause this though, so I'm thinking what ever it is 
must by intermittent.  I'll stick it in a loop and see if I can get a 
recreate today.  Thanks!

Allison


> 
> [  838.107443] Code: 00 00 4c 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 81 1c 00 00 4c 8b 83 80 00 00 00 4d 85 c0 74 25 49 8d 78 30 48 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 46 1c 00 00 45 39 70 30 0f 8d
> [  838.111216] RSP: 0018:ffffc900050af2c0 EFLAGS: 00010202
> [  838.112339] RAX: 0012f973e6000046 RBX: ffff888047078d20 RCX: 0000000000000070
> [  838.113761] RDX: 000000000000006f RSI: ffffc900050af378 RDI: 0097cb9f30000230
> [  838.115141] RBP: dffffc0000000000 R08: 0097cb9f30000200 R09: ffff888047078d67
> [  838.116471] R10: ffffed1008e0f1ac R11: ffffc900050aef88 R12: 0000000000000000
> [  838.117796] R13: ffffffffa07f4200 R14: 00000000000000d8 R15: ffff888047078da0
> [  838.119085] FS:  00007fb959518740(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> [  838.120506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  838.121516] CR2: 00007fb959581070 CR3: 0000000043ba2005 CR4: 00000000001706a0
> [  838.122743] Call Trace:
> [  838.123214]  <TASK>
> [  838.123651]  ? __mutex_lock_slowpath+0x10/0x10
> [  838.124426]  ? kasan_save_stack+0x1e/0x40
> [  838.125120]  ? __kasan_slab_alloc+0x66/0x80
> [  838.125835]  ? xlog_cil_empty+0x90/0x90 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.127287]  ? xfs_trans_log_dquot+0xe8/0x170 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.128806]  ? xfs_trans_apply_dquot_deltas+0x275/0xf40 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.130405]  __xfs_trans_commit+0x52b/0xc00 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.131830]  ? __kasan_slab_alloc+0x66/0x80
> [  838.132503]  ? xfs_trans_free_items+0x220/0x220 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.133906]  ? kmem_cache_alloc+0x2c9/0x400
> [  838.134534]  ? xfs_trans_dup+0x512/0x830 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.135845]  ? xfs_defer_trans_roll+0x126/0x360 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.137163]  ? xfs_defer_finish_noroll+0x271/0x17e0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.138482]  xfs_trans_roll+0x118/0x290 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.139665]  ? xfs_trans_alloc_empty+0xa0/0xa0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.140933]  ? xfs_defer_save_resources+0x247/0x4d0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.142175]  ? xfs_attri_init+0xef/0x120 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.143320]  xfs_defer_trans_roll+0x126/0x360 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.144475]  ? xfs_defer_trans_abort+0x3b0/0x3b0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.145636]  ? xfs_attr_log_item+0x54/0x4b0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.146764]  ? xfs_attr_log_item+0x4b0/0x4b0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.147909]  ? xfs_defer_create_intents+0x145/0x2c0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.149068]  xfs_defer_finish_noroll+0x271/0x17e0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.150606]  ? xfs_mod_fdblocks+0x18d/0x3e0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.151838]  ? xfs_trans_reserve_quota_bydquots+0xef/0x1b0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.153239]  ? xfs_defer_cancel+0x110/0x110 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.154446]  ? do_raw_spin_lock+0x125/0x270
> [  838.155008]  ? rwlock_bug.part.0+0x90/0x90
> [  838.155564]  __xfs_trans_commit+0x3f9/0xc00 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.156795]  ? xfs_trans_free_items+0x220/0x220 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.158062]  ? __kasan_kmalloc+0x81/0xa0
> [  838.158594]  ? xfs_trans_ichgtime+0x190/0x190 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.159823]  ? xfs_trans_ichgtime+0x49/0x190 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.161040]  xfs_attr_set+0xc15/0x1110 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.162195]  ? xfs_attr_set_iter+0xf30/0xf30 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.163412]  ? is_bpf_text_address+0x1f/0x30
> [  838.163984]  ? __kernel_text_address+0x62/0xb0
> [  838.164584]  ? arch_stack_walk+0x98/0xf0
> [  838.165113]  xfs_xattr_set+0xec/0x190 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.166280]  ? xfs_trans_alloc_ichange+0x410/0x410 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.167587]  ? kasan_save_stack+0x2e/0x40
> [  838.168119]  ? kasan_save_stack+0x1e/0x40
> [  838.168662]  __vfs_setxattr+0xe0/0x130
> [  838.169171]  ? xattr_resolve_name+0x3f0/0x3f0
> [  838.169762]  __vfs_setxattr_noperm+0xec/0x2d0
> [  838.170348]  vfs_setxattr+0x116/0x2d0
> [  838.170845]  ? __vfs_setxattr_locked+0x200/0x200
> [  838.171469]  ? __might_fault+0x4d/0x70
> [  838.171984]  setxattr+0x15c/0x270
> [  838.172451]  ? vfs_setxattr+0x2d0/0x2d0
> [  838.172971]  ? xfs_vn_getattr+0xad/0xea0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  838.174144]  ? __check_object_size+0x113/0x4c0
> [  838.174731]  ? kasan_quarantine_put+0x21/0x1b0
> [  838.175302]  ? preempt_count_add+0x7f/0x150
> [  838.175852]  ? __mnt_want_write+0x155/0x230
> [  838.176420]  path_setxattr+0x141/0x170
> [  838.176889]  ? setxattr+0x270/0x270
> [  838.177330]  __x64_sys_setxattr+0xc0/0x160
> [  838.177847]  ? syscall_exit_to_user_mode+0x1d/0x40
> [  838.178441]  do_syscall_64+0x35/0x80
> [  838.178893]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  838.179523] RIP: 0033:0x7fb95963b10e
> [  838.179963] Code: 48 8b 0d 85 ad 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 ad 0c 00 f7 d8 64 89 01 48
> [  838.182010] RSP: 002b:00007fff0d57c118 EFLAGS: 00000206 ORIG_RAX: 00000000000000bc
> [  838.182874] RAX: ffffffffffffffda RBX: 00007fff0d57c160 RCX: 00007fb95963b10e
> [  838.183687] RDX: 000055949a4d6670 RSI: 00007fff0d57c160 RDI: 000055949a4d6410
> [  838.184470] RBP: 000055949a4d6670 R08: 0000000000000000 R09: 00007fff0d57bfb0
> [  838.185248] R10: 000000000000002b R11: 0000000000000206 R12: 000000000000002b
> [  838.186036] R13: 000055949a4d669b R14: 000055949a4d669b R15: 0000559498b43b80
> [  838.186816]  </TASK>
> [  838.187078] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set bfq ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
> [  838.189804] Dumping ftrace buffer:
> [  838.190191]    (ftrace buffer empty)
> [  838.191667] ---[ end trace 0000000000000000 ]---
> [  838.192204] RIP: 0010:xlog_cil_commit+0x2f9/0x2800 [xfs]
> [  838.192978] Code: 00 00 4c 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 81 1c 00 00 4c 8b 83 80 00 00 00 4d 85 c0 74 25 49 8d 78 30 48 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 46 1c 00 00 45 39 70 30 0f 8d
> [  838.195051] RSP: 0018:ffffc900050af2c0 EFLAGS: 00010202
> [  838.195652] RAX: 0012f973e6000046 RBX: ffff888047078d20 RCX: 0000000000000070
> [  838.196436] RDX: 000000000000006f RSI: ffffc900050af378 RDI: 0097cb9f30000230
> [  838.197265] RBP: dffffc0000000000 R08: 0097cb9f30000200 R09: ffff888047078d67
> [  838.198062] R10: ffffed1008e0f1ac R11: ffffc900050aef88 R12: 0000000000000000
> [  838.198842] R13: ffffffffa07f4200 R14: 00000000000000d8 R15: ffff888047078da0
> [  838.199626] FS:  00007fb959518740(0000) GS:ffff88802e700000(0000) knlGS:0000000000000000
> [  838.200509] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  838.201180] CR2: 00007f8f5400c038 CR3: 0000000043ba2003 CR4: 00000000001706a0
> [  853.182840] ==================================================================
> [  853.184795] BUG: KASAN: use-after-free in __mutex_lock.constprop.0+0x133b/0x13c0
> [  853.186684] Read of size 4 at addr ffff888048148034 by task 1:1/48
> [  853.188233]
> [  853.188709] CPU: 1 PID: 48 Comm: 1:1 Tainted: G      D           5.17.0-rc5-djwx #rc5 63f7e400b85b2245f2d4d3033e82ec8bc95c49fd
> [  853.191490] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [  853.193669] Workqueue: xfs-conv/sdb xfs_end_io [xfs]
> [  853.195301] Call Trace:
> [  853.195993]  <TASK>
> [  853.196614]  dump_stack_lvl+0x34/0x44
> [  853.197605]  print_address_description.constprop.0+0x1f/0x160
> [  853.199079]  ? __mutex_lock.constprop.0+0x133b/0x13c0
> [  853.200387]  kasan_report.cold+0x83/0xdf
> [  853.201452]  ? __mutex_lock.constprop.0+0x133b/0x13c0
> [  853.202763]  __mutex_lock.constprop.0+0x133b/0x13c0
> [  853.204033]  ? xfs_trans_alloc_inode+0x118/0x2c0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.206551]  ? xfs_iomap_write_unwritten+0x263/0x660 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.209136]  ? xfs_end_io+0x1ed/0x300 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.211404]  ? process_one_work+0x688/0x1080
> [  853.212582]  ? kthread+0x29e/0x340
> [  853.213506]  ? ret_from_fork+0x1f/0x30
> [  853.214500]  ? mutex_trylock+0x340/0x340
> [  853.215545]  ? xlog_space_left+0x55/0x2e0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.217905]  ? kasan_unpoison+0x23/0x50
> [  853.218926]  ? __kasan_slab_alloc+0x66/0x80
> [  853.220026]  mutex_lock+0xdf/0xf0
> [  853.220925]  ? __mutex_lock_slowpath+0x10/0x10
> [  853.222084]  ? __mutex_unlock_slowpath.constprop.0+0x5e0/0x5e0
> [  853.223571]  ? preempt_count_add+0x7f/0x150
> [  853.224686]  ? xfs_trans_mod_dquot+0xc5/0x740 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.227057]  xfs_trans_dqresv+0x6a/0xe30 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.229214]  ? xfs_mod_fdblocks+0x18d/0x3e0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.231277]  xfs_trans_reserve_quota_bydquots+0xef/0x1b0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.233588]  xfs_trans_reserve_quota_nblks+0x1e7/0x4f0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.235711]  ? xfs_qm_dqattach_locked+0x1c/0x3f0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.237611]  xfs_trans_alloc_inode+0x167/0x2c0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.239483]  ? xfs_trans_roll+0x290/0x290 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.241156]  xfs_iomap_write_unwritten+0x263/0x660 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.242882]  ? xfs_buffered_write_iomap_begin+0x2070/0x2070 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.244699]  ? psi_task_switch+0x186/0x4a0
> [  853.245429]  ? sgl_alloc+0x10/0x10
> [  853.246021]  xfs_end_ioend+0x3b2/0x5f0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.247479]  xfs_end_io+0x1ed/0x300 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.248817]  ? do_raw_spin_lock+0x125/0x270
> [  853.249484]  ? xfs_end_ioend+0x5f0/0x5f0 [xfs ff7a0bfdb9d791b76ca0bad2f24d8adae3cf8c9d]
> [  853.250874]  ? read_word_at_a_time+0xe/0x20
> [  853.251557]  ? strscpy+0xa1/0x2a0
> [  853.252067]  process_one_work+0x688/0x1080
> [  853.252689]  worker_thread+0x5a3/0xf60
> [  853.253257]  ? rescuer_thread+0xce0/0xce0
> [  853.253860]  ? rescuer_thread+0xce0/0xce0
> [  853.254481]  kthread+0x29e/0x340
> [  853.254959]  ? kthread_complete_and_exit+0x20/0x20
> [  853.255647]  ret_from_fork+0x1f/0x30
> [  853.256166]  </TASK>
> [  853.256514]
> [  853.256767] Allocated by task 4401:
> [  853.257271]  kasan_save_stack+0x1e/0x40
> [  853.257826]  __kasan_slab_alloc+0x66/0x80
> [  853.258375]  kmem_cache_alloc_node+0x107/0x420
> [  853.258988]  copy_process+0x466/0x6180
> [  853.259515]  kernel_clone+0xbd/0x860
> [  853.260011]  __do_sys_clone+0xaf/0xf0
> [  853.260538]  do_syscall_64+0x35/0x80
> [  853.261010]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  853.261662]
> [  853.261889] Freed by task 0:
> [  853.262276]  kasan_save_stack+0x1e/0x40
> [  853.262795]  kasan_set_track+0x21/0x30
> [  853.263286]  kasan_set_free_info+0x20/0x30
> [  853.263826]  __kasan_slab_free+0xfc/0x140
> [  853.264343]  kmem_cache_free+0xfc/0x420
> [  853.264837]  rcu_core+0x562/0x12e0
> [  853.265279]  __do_softirq+0x1b4/0x5c7
> [  853.265758]
> [  853.265975] Last potentially related work creation:
> [  853.266582]  kasan_save_stack+0x1e/0x40
> [  853.267081]  __kasan_record_aux_stack+0x9f/0xb0
> [  853.267665]  call_rcu+0x7a/0x740
> [  853.268068]  wait_consider_task+0x28a4/0x3f70
> [  853.268606]  do_wait+0x5fd/0x9a0
> [  853.269010]  kernel_wait4+0xf3/0x1c0
> [  853.269456]  __do_sys_wait4+0xe8/0x100
> [  853.269915]  do_syscall_64+0x35/0x80
> [  853.270357]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  853.270954]
> [  853.271157] Second to last potentially related work creation:
> [  853.271809]  kasan_save_stack+0x1e/0x40
> [  853.272253]  __kasan_record_aux_stack+0x9f/0xb0
> [  853.272780]  call_rcu+0x7a/0x740
> [  853.273162]  wait_consider_task+0x28a4/0x3f70
> [  853.273672]  do_wait+0x5fd/0x9a0
> [  853.274059]  kernel_wait4+0xf3/0x1c0
> [  853.274499]  __do_sys_wait4+0xe8/0x100
> [  853.274925]  do_syscall_64+0x35/0x80
> [  853.275334]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  853.275896]
> [  853.276091] The buggy address belongs to the object at ffff888048148000
> [  853.276091]  which belongs to the cache task_struct of size 8192
> [  853.277404] The buggy address is located 52 bytes inside of
> [  853.277404]  8192-byte region [ffff888048148000, ffff88804814a000)
> [  853.278635] The buggy address belongs to the page:
> [  853.279167] page:ffffea0001205200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x48148
> [  853.280170] head:ffffea0001205200 order:3 compound_mapcount:0 compound_pincount:0
> [  853.280971] memcg:ffff888041943881
> [  853.281364] flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
> [  853.282145] raw: 04fff80000010200 0000000000000000 dead000000000001 ffff888004057cc0
> [  853.282979] raw: 0000000000000000 0000000000030003 00000001ffffffff ffff888041943881
> [  853.283803] page dumped because: kasan: bad access detected
> [  853.284408]
> [  853.284618] Memory state around the buggy address:
> [  853.285148]  ffff888048147f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  853.285940]  ffff888048147f80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> [  853.286715] >ffff888048148000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  853.287485]                                      ^
> [  853.288009]  ffff888048148080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  853.288784]  ffff888048148100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  853.289566] ==================================================================
