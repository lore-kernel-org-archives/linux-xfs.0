Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A13DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1C86101A
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhIKONH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Sep 2021 10:13:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhIKONG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Sep 2021 10:13:06 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18BCYdAX020862;
        Sat, 11 Sep 2021 14:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=B1o1eNWg/uESddUU3hTNpjlXrpJnQ7D8Jb62cyID1XA=;
 b=dNZ4hI/su9zMmWlC7EJGinfCXAAmjN/j6WKlEE2WYBupv9h7cTDt/2erGKoGZl3+6PFB
 ILNl1Rv2tvKy0TnfF/+fU9ezsMsdxW5nzZCsFh1rAiTutn1D2dSp8+etS/8cPvdOMMzF
 6MsHqpJDG51BCdw/PyndK245ZBoIrDcPbVSUlnARJt7sMY1F9FPN2Xt4sVNgvtmCUQUn
 NMYtwDdgMP5I6MRFoAznMHyFMyHrWbTKi0TkJg5AfQPCRv3u782t79vrRM8iiDopeKtb
 kqjMeCHv/D0ywwojiE5WRDVCqJ4O99Tnkv2M07NVPNN6FBZYRFS+6SpGdB0Fe8rMVBWs Lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B1o1eNWg/uESddUU3hTNpjlXrpJnQ7D8Jb62cyID1XA=;
 b=rcZ/8jamWk0Ehh56ZYFxLgiLNIg47e3ZsO3RncshCCjrHAMlrK5Jg+AeUBnDofXMG0mY
 OCSvUPo+WFZUTvll0Exm+DY3lrYAXL/yQV2iaxPidptkoZPzRrctnxh/LJs5fEZYDOiO
 UesZYnv6fO1mmDHgwEd4JdW+I7EKy1U3liugTaVbM84hufhv392cSIgNNJjauSJ6n1IX
 mIlxnqAVydkVqkR+IOHIFHB617cVlrIOyL4xcZXOd4/Nfx2jfOpo/WaRi+NvZrpo5Gt5
 PE3q40kEql5BBUX+1YvigXVFE3wERStoQ7BWdJf3c2YzIiiWc66uyQaxjWNItg1GXWDi Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0k210k7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BEB5PF176116;
        Sat, 11 Sep 2021 14:11:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3b0kshvhq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7baPE8Z7W0Cdy4v4A78fo5QZmvwG4CkXxVutymk7VlSWJVThoGyK6msgetH1KqOvO9mAQRj4w2CZu6SIyfcPOn3ARjb+VHR/UVBwUSr0K8t9cJ8tpxpm2kvBVYSrGZAaMVNDiXmhGFc/lLNAiCY2XByQ0FvnhV9GstKubVwGrQLloVkYU1P9RcJQvaWPpuU3Gz4IANQ6IHv8NlUiL64QNVSSa0lDoeOwyv3O2ogBdwbjEYUOCgHt7yeZsDMB0uplkfTIWzcOQFdKsemZLeRrPUVFa9TvKjqikD8qDLRxlVOHZWObsY+U631iMEdPV2jERfNH4OA6z69x7A9ExwNzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B1o1eNWg/uESddUU3hTNpjlXrpJnQ7D8Jb62cyID1XA=;
 b=PvUfPltI1Vw+Dt7cs4NEm3XtPCC946sL/gSUN2bvbAPy32u5oPa0itJ+9FWD0N7nf7UI4lDT8AnLIsFoIMxa1Clmi70qEImj2Zq4ReYRQalwAUI3JIbLs9b6PB1UPMn7jU2/N3Fc2IN5eH4N3iRz2X2+057X/tmGmwToivhkg9B7909zmiHAosfG/MwtvtxevUbhoK7dlfm1bryCBPPfcw7eMeZD/lETShd41nmwi7hASoWs1v0akRh9QGAzKEb9KEWxtLwAUPSInRvTy69Ohe8JA8BMYjDoHtgZYjBbV34Zu88UF86uIjgCcjLflB0i/vrlArha09/57/d3o9KO4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1o1eNWg/uESddUU3hTNpjlXrpJnQ7D8Jb62cyID1XA=;
 b=Cwws8/fzjqWCDaghbnnoOR0BE8bQKQeV7PJhx586kar9aRLDKPptHBf+rF72EHdbMiXmNijzf4PewXO1HWrza33fKV/+1j4AnJu8xFB/izI5wbyxSqM9HvkKc0pQFnZ/PL1Iys2dyMjvcfKT4NMiEvK/aOOwTndruSUVVFMDeAM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 14:11:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%5]) with mapi id 15.20.4500.018; Sat, 11 Sep 2021
 14:11:50 +0000
Subject: Re: [PATCH 1/3] xfstests: Rename _scratch_inject_logprint to
 _scratch_remount_dump_log
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
 <20210909174142.357719-2-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <834c5aab-4124-1d47-cb39-5fabcb84ca0b@oracle.com>
Date:   Sat, 11 Sep 2021 07:11:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210909174142.357719-2-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0135.namprd13.prod.outlook.com (2603:10b6:a03:2c6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Sat, 11 Sep 2021 14:11:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1eed90-52f3-4a61-aceb-08d9752e1950
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB42905F0FF4CB055B9B0951C195D79@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vpstjwNgJLedA4r8WqQ2UQ3TFoVi0yDkaheHbyO4EDSrH4qQjRtz+uVqGlYzMlDsRKnWv0l1kmZ9B5DyZUyjtMCVrcN11Ki4tntBc2g97Knb+sCzfVrz8lMu/bztaaKFZH5edfatz6lgKHkwjEDkWGAQ/h1yFDYDlVChWgr69pAsX99BJCRI1cnYvjK0HQRgwgET2y8Motpp1qdFSnlu1sm8vbJg3UuMZe7z5+e3IjglfH62xh2Y0BGkfIc+dyDakX0CB5oDFA3WUmaxXmGNc/4DyIX2aMysL654xwTiswjJCxQsaubtYvh12kCpAAh5TrEktEjLlvZYWrfk7PDTA1wDWF9mv6qV3Jk/KSqlecYAln3KiZNGrzogqJsh82xg1SVuq2r50VoOKW+GrT0VIVJf6KrUP9x0xReroJqj0iLHs6mfihc4EEz8rTy2vLCRbdKPRS+6OQ6HpU18Qcdeyqd0sVPKyOSNsChz5heIoxol6vobOShOYgqsBCLlK8UM5YkXp+EEwBbaqHjy3Nq84H1H+TlagebtF5h843eI06XlH3dTbVOiJPZrX5CRJGX7Wc7vZ5+74dJ2eWIf7XPGAXeIwPiS0XFJCoVLJnkmK6TWTicNJ+E8011IGqoHZPa1br2mAD1tIOR5thHlcBJHd6DJpbzusVcdDpKoc4oXTlkKnjupAvigFlv5WC1c4ildQvL+2GPpofnI0joi2FNg3LSJBDKfPaslIM4FyoYBX6ZuG/uSjdZdJOzYLDfao17PeQwZ29HBtoT+3lEGfTbi9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(396003)(39860400002)(8676002)(66476007)(316002)(6486002)(38100700002)(26005)(31686004)(450100002)(16576012)(66556008)(31696002)(478600001)(66946007)(8936002)(44832011)(53546011)(83380400001)(956004)(38350700002)(2906002)(86362001)(5660300002)(52116002)(2616005)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0cwYVh3VnJ3U0RSSUhBTFBEWWsxenNySFpra0EvM2ZsSHJVSDlpa3pydTBy?=
 =?utf-8?B?a2cyL2R5c3NJODJCTklJRlE4WDVEcno4RVVTVzhiSXBQd3U4VTZzNXpWbm1s?=
 =?utf-8?B?bHZsMHlFK1lQeTNuRUdZTUlXbjhNdW1RaG1iMVA2TEpESGs2emw2VGZISlNa?=
 =?utf-8?B?VFRlZG9WZmtEMDk3R3FvZHRFMGlJTlh6ZVVja2FPOFEvL2t2bDVtNzVXOG9a?=
 =?utf-8?B?ckNNS2xHOWxDSDdDZnRlRFo2d2cvWWE0T3FTVnl4d25nY2xwazdLN2hnZGZu?=
 =?utf-8?B?STlmREtmQTRXQUJqbTN3WXlGZlVYUnBMeGVVbnJITlZKcjhMMVlUTHBlb3Yw?=
 =?utf-8?B?Q3VEUDRjREdxWE1scUVZT1FGRzVvUksrYm5WVWpLQ2cvZjlkaURqWDhJaWFH?=
 =?utf-8?B?ZHY0ZmR2WFM2NkVuc0hRQ3hkZG1ZNm84OGI0QmcrelpkaU9EZ3VML3ZaN3Zz?=
 =?utf-8?B?eUNUQmxReUFFZ1ZFdjFXcEpkdWNDU3ZmOGFHcExJQW5iYzdJV2MzV202Vk9y?=
 =?utf-8?B?SGpITEo3ODdlZ0NOTDJVMHJteFJZR05uRzhKNVk4aEszZ1JuQjJjdmtiREpG?=
 =?utf-8?B?UlRTUXdnSHhjSllFeDNLRWdxMXdJekROY1NFZE5NaE1qUjUvNXEzOWFZV2o3?=
 =?utf-8?B?OWtSc2YzdnJaSlQrYzN3blJPUkJjM2dHa09hcWRDdit6ZTQyQitYOFR0MS81?=
 =?utf-8?B?Y1Y4NlVTNFM3L3FCTnAyTFYzdnJsN0FFb2R5M0I1NjA4S0RtZW0ydzJKVHph?=
 =?utf-8?B?SFZnZTJqdlNBU2ZBY0E2WThINUlWZi85TnVzYUYwOUFzcU02Yk8rS0VMbSty?=
 =?utf-8?B?Z0c3dWZwRUxLcjRrZU1VeHlSRWZYbmJwMDJrc1RIejlCSnVLSUZTYmUzTEQ0?=
 =?utf-8?B?R0VxY2ZsSUtSdFZsT0tjTEQza2Q1LzEwMWVqc2ZaL0lDcHZBSTVuNjVnWFVv?=
 =?utf-8?B?dXNIRU5IeUlXWm9aM2NHYWdVbzZVa09CS1hKWUpVbmtMUEtoSDJodDZXaWVC?=
 =?utf-8?B?NUFBLy8zWmZGY0JPL1BvOUszT2M1VHBKRitpR0NxU1U0RTJaNzM3T2dQTEwr?=
 =?utf-8?B?MlRjdUlnMFBKc0sydndFOFFPN2xtdDRLSEd4RzUyajZFdE1PWEtwZ3NwWkJV?=
 =?utf-8?B?MElKUnpiL2VqNnFyRnYrM0VhTU9BVWp2dzkxNUo2b0dPQ0dWcXRvdUYvN1Nj?=
 =?utf-8?B?NFNUWnAvdFBIbnV2cHVRS2s2aTFYMGdmaTh3VC9tbUM2MDlpTTJWN0dPQjR4?=
 =?utf-8?B?ajNFZjE0amxJL1p2Mnplazl4WGF5OFJXaHlSQTh2bC9GdUVlQ1dXblcvR1c1?=
 =?utf-8?B?NGdjUHd6c1BhbG92ZWZGMCtOUXBZMFpVOWpOSitOWTVJRnhoYnErL3ZYZ2RB?=
 =?utf-8?B?bUNBaWxQUjYrSitzOVVpalNNQWl6UURyZ3UrVU13SWh6WTJhMmVPZ2dRTjR6?=
 =?utf-8?B?UkdYR2Y3eElrckgrbThENldyWnEzVVV0NHRJaWxITTRPVHNWRW50WWRPZjBw?=
 =?utf-8?B?VnMvd0N4SXFuelBxRTRjdlF2Mmt2dS9oL0UvdGZNV2VpVDhqRTBoUFdZUFUw?=
 =?utf-8?B?Y3BDV0JNR1pLWGJaVzBMeldxcXpMZ2xhVFd0Qkt3dHNJU2xOUm1iemFOY3Ry?=
 =?utf-8?B?QUd0cWRKaVhWRldMaFIrOStUOFdWRGlZWGhSbEQxNUFteU1UazZ2N3VoazdP?=
 =?utf-8?B?Ym9zSmM4YUVFQ1Bmc3MrRGFKM0VaTmtnSGZFak5DMy91aUF6Q0dWN0VFamNQ?=
 =?utf-8?Q?QK/vEP56q5EJ34dDP3TtNkxNqq7vf701EjzISDp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1eed90-52f3-4a61-aceb-08d9752e1950
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2021 14:11:50.5867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bZYZvftiYAmDmeQjR0/8LcPloOGnXu3cS7hYyUicfhZwCX27cO8p34BIN6qm+7G3kMwabHQjxqG95Pzn9lkC3e7OPNXh8rQ116HsnOV2Ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10104 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109110097
X-Proofpoint-GUID: -CGssJMgcJhFs5ACqyYkHQlIeW_iigCo
X-Proofpoint-ORIG-GUID: -CGssJMgcJhFs5ACqyYkHQlIeW_iigCo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/9/21 10:41 AM, Catherine Hoang wrote:
> Rename _scratch_inject_logprint to _scratch_remount_dump_log to better
> describe what this function does. _scratch_remount_dump_log unmounts
> and remounts the scratch device, dumping the log.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks good to me.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/inject | 2 +-
>   tests/xfs/312 | 2 +-
>   tests/xfs/313 | 2 +-
>   tests/xfs/314 | 2 +-
>   tests/xfs/315 | 2 +-
>   tests/xfs/316 | 2 +-
>   tests/xfs/317 | 2 +-
>   tests/xfs/318 | 2 +-
>   tests/xfs/319 | 2 +-
>   tests/xfs/320 | 2 +-
>   tests/xfs/321 | 2 +-
>   tests/xfs/322 | 2 +-
>   tests/xfs/323 | 2 +-
>   tests/xfs/324 | 2 +-
>   tests/xfs/325 | 2 +-
>   tests/xfs/326 | 2 +-
>   tests/xfs/329 | 2 +-
>   17 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/common/inject b/common/inject
> index 984ec209..3b731df7 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -113,7 +113,7 @@ _scratch_inject_error()
>   }
>   
>   # Unmount and remount the scratch device, dumping the log
> -_scratch_inject_logprint()
> +_scratch_remount_dump_log()
>   {
>   	local opts="$1"
>   
> diff --git a/tests/xfs/312 b/tests/xfs/312
> index 1fcf26ab..94f868fe 100755
> --- a/tests/xfs/312
> +++ b/tests/xfs/312
> @@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/313 b/tests/xfs/313
> index 6d2f9fac..9c7cf5b9 100755
> --- a/tests/xfs/313
> +++ b/tests/xfs/313
> @@ -63,7 +63,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/314 b/tests/xfs/314
> index 5165393e..9ac311d0 100755
> --- a/tests/xfs/314
> +++ b/tests/xfs/314
> @@ -64,7 +64,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/315 b/tests/xfs/315
> index 958a8c99..105515ab 100755
> --- a/tests/xfs/315
> +++ b/tests/xfs/315
> @@ -61,7 +61,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/316 b/tests/xfs/316
> index cf0c5adc..f0af19d2 100755
> --- a/tests/xfs/316
> +++ b/tests/xfs/316
> @@ -61,7 +61,7 @@ echo "CoW all the blocks"
>   $XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $((blks * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/317 b/tests/xfs/317
> index 7eef67af..1ca2672d 100755
> --- a/tests/xfs/317
> +++ b/tests/xfs/317
> @@ -54,7 +54,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "Check files"
>   md5sum $SCRATCH_MNT/file0 | _filter_scratch
> diff --git a/tests/xfs/318 b/tests/xfs/318
> index d822e89a..38c7aa60 100755
> --- a/tests/xfs/318
> +++ b/tests/xfs/318
> @@ -60,7 +60,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "Check files"
>   md5sum $SCRATCH_MNT/file1 2>&1 | _filter_scratch
> diff --git a/tests/xfs/319 b/tests/xfs/319
> index 0f61c119..d64651fb 100755
> --- a/tests/xfs/319
> +++ b/tests/xfs/319
> @@ -57,7 +57,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/320 b/tests/xfs/320
> index f65f3ad1..d22d76d9 100755
> --- a/tests/xfs/320
> +++ b/tests/xfs/320
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "Check files"
>   md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/321 b/tests/xfs/321
> index daff4449..06a34347 100755
> --- a/tests/xfs/321
> +++ b/tests/xfs/321
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "Check files"
>   md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/322 b/tests/xfs/322
> index f36e54d8..89a2f741 100755
> --- a/tests/xfs/322
> +++ b/tests/xfs/322
> @@ -56,7 +56,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "Check files"
>   md5sum $SCRATCH_MNT/file1 | _filter_scratch
> diff --git a/tests/xfs/323 b/tests/xfs/323
> index f66a8ebf..66737da0 100755
> --- a/tests/xfs/323
> +++ b/tests/xfs/323
> @@ -55,7 +55,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/324 b/tests/xfs/324
> index ca2f25ac..9909db62 100755
> --- a/tests/xfs/324
> +++ b/tests/xfs/324
> @@ -61,7 +61,7 @@ echo "Reflink all the blocks"
>   _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file4
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/325 b/tests/xfs/325
> index 3b98fd50..5b26b2b3 100755
> --- a/tests/xfs/325
> +++ b/tests/xfs/325
> @@ -59,7 +59,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/326 b/tests/xfs/326
> index bf5db08a..8b95a18a 100755
> --- a/tests/xfs/326
> +++ b/tests/xfs/326
> @@ -71,7 +71,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log"
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   
>   echo "FS should be online, touch should succeed"
>   touch $SCRATCH_MNT/goodfs
> diff --git a/tests/xfs/329 b/tests/xfs/329
> index e57f6f7f..e9a30d05 100755
> --- a/tests/xfs/329
> +++ b/tests/xfs/329
> @@ -52,7 +52,7 @@ echo "FS should be shut down, touch will fail"
>   touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
>   
>   echo "Remount to replay log" | tee /dev/ttyprintk
> -_scratch_inject_logprint >> $seqres.full
> +_scratch_remount_dump_log >> $seqres.full
>   new_nextents=$(_count_extents $testdir/file1)
>   
>   echo "Check extent count" | tee /dev/ttyprintk
> 
