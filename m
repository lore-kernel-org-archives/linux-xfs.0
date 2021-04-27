Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C3EC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCD2613F6
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 21:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhD0Vhq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:37:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhD0Vhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 17:37:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLZv9f102246;
        Tue, 27 Apr 2021 21:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=XACe87Hc/HC6YmzXvRvDDXqIfI6EzRq3o39gpg4NOO8=;
 b=A/+sJMMlI15G57TxjHJtvGr9uDfrv85RsENplMS0+7C7LRVZ9ekWm5tp027RkoxKknkv
 2BlJjvt4Pp2sHrbHCYo1NELaAY5RTyuoC1zLtxPBZMQD+8+4UvBfSTx4gZjLb7NsjRRp
 41sZVCP876a85omHbE/SP/ODriMEGLsovR+iiBmCebdv9ZDINwuZbonCqxnQwsuOoVWn
 0yTXH6zuER3R+t9IWWClT4P99blvelxgu/91Zwwd5cNoWeZdMVAqFJT1XLV7KA19U45F
 wry2blVR9c+rItLHaHnBzzM7dV54RNYtKsWl9HjMlKyt9u5SpJaakO6qyHpmZzQwkrBQ ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 385aepy0jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:36:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RLUUvn002995;
        Tue, 27 Apr 2021 21:36:59 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 384w3tqjdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 21:36:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGWQ8sG+JiyybgLt+ClLgojYrmV2yN9yIfK9mUY5yFRAKAWf+Mc7vvUDDi/1VC3dL1uvoZtp5SABFMw/H2IjKLqRnGe9cOhOn2jbXjHQ2JaVo//9Gs60wKzDnwT4G5oXM4FTMMqDT+phtqIFKZLsoAfeArApXlyNMioNxrDEaijjwNZIAjJviPHJ7vn8R3AyuyDbR84H5jOwjvorQSTLRpLqrg8QjUOJxjTSegBEdMdeM63FLkHKV4y+35o6t/8LvdbHHVkcWYPpAkBfaU2J2svF7fbEcnCPkFe+6NMKGBZJQX++ZXw+6zjuE+LwaTr7/eTtjHnjEaBrmw2aQb9YRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XACe87Hc/HC6YmzXvRvDDXqIfI6EzRq3o39gpg4NOO8=;
 b=CVuwB5KpI55KGlBNiL0n3i3CC6Kn8t1JrVqE47ZQC1iht7x4Uh42gv6cjV1fWab3Od/rgLX05REr2nSxOr8qMSUTv51QrSN8xpTla7XH/Tvmu2Vba6aXJoJ6k/dDq/geg+4o3AFEHUA8AB83urwH0+BapIySoebFqoSbEomHkRdJzPOykeQaIsxldd1irdX/bWMugu6/lffbIVbTabYOgARPC2m7VajnQu92IGryNxuXKQayi3O8JkDCl5K/iwFiGotmSbOG3YBKnSjl/QfcL3VIl3OyrnGJQJmQoiUoY3Ttum3Zj8lkcdNGQ3TYIX2gpi7aiN3lFG9NUP2cv6xD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XACe87Hc/HC6YmzXvRvDDXqIfI6EzRq3o39gpg4NOO8=;
 b=dSHBYg/4Zm2EJ8YjE56CBzKeYC6T9Vh4kEVUW94bZgAmH5CRz17JzeCOtG+h5Dw5I/7IAbWxor7ARN/7f6m8xz0LcD3EiWDKwH53zyATocRO9SGk953CVd1cS1TozOip0lA4x3RRoCc+l2UMS7r1H77r7gzi5ZNtTSUpT7fh/YM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4637.namprd10.prod.outlook.com (2603:10b6:a03:2d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Tue, 27 Apr
 2021 21:36:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Tue, 27 Apr 2021
 21:36:55 +0000
Subject: Re: [PATCH v4 1/3] xfs: unconditionally read all AGFs on mounts with
 perag reservation
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210423131050.141140-1-bfoster@redhat.com>
 <20210423131050.141140-2-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f7362d22-1537-c048-4c5a-3de75f332a17@oracle.com>
Date:   Tue, 27 Apr 2021 14:36:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210423131050.141140-2-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0022.namprd02.prod.outlook.com (2603:10b6:a02:ee::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 21:36:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b6a6fb9-e3f9-4ce8-7987-08d909c493d8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4637:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4637E1597618C3AF13F3B2F295419@SJ0PR10MB4637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zwyG1QcviNeeFMWczUhruX/aUOeFDUMuqHu6IXfSh3GoIs7Hrk0e+4It0RgT848h7Gv9V0H70bcS9WjywVZ6974ubudOjc+BIEK09w0EqAe+9S5rGTrTxFXtf9Rcd5gklN912GF0eiNb+z4wsSlFa7Isxc6A4CA/4ScDBonw/0cNzgsrtiIot23IHBN4j2Ss89SA4wFMEXrX3x8ssp1h54mjNn3kKtWSCS6o7giSAGNuJHF/Ass+18OalJt61w1rA5ae7DxZ84h2upQ1NXmt4mC9KgwB3y/BcIShZ9K6B+s2MmbnWPSi0Bl91P7jny3DoVRFXSw0ytqoS/HHsqbpbZWfcJ4wY9cPeyJxRscpaQM1gNKRfLTXKpR8bdAGSsbl8HS2esKQjB5a3eM07aSsgInz0hglqPgA71akwo/QOeU/HdY/iIuMZiTj/dhOd2whKqG+IerBveK/b7u4Rl5+76uN7OfDC7PNysACeInUwgyUjNecnvr6M00w9MTVAA9A+3n/nge8uHt15xxVW3IkTPasBnNjHqQlOEY9CliCHg5hteeq0J1js3cVztgY97975ITPr9Optl+LESWYHTeigReVb31gcsGfyt3cJRfQiJfG0J27eumsxkA9wmz18N8cOluz4idkeco3xcaWOnvurPa1e+mnQB7gAMboYza2mvrLDlrlP921Hg/hUWxiEEE4ThpG/tdauFS1X00OwGgNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(396003)(346002)(36756003)(2906002)(52116002)(16576012)(53546011)(478600001)(316002)(31686004)(86362001)(16526019)(38100700002)(31696002)(38350700002)(44832011)(6486002)(186003)(83380400001)(26005)(8676002)(66946007)(5660300002)(956004)(2616005)(8936002)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZlQ0QUloR1BHYlNCZHlOQmRFeVBvUGJXTUxNNDhhZEVlMGxrdnIxY0tCUDNy?=
 =?utf-8?B?Wk9PWC9hRDJHNzA3YXhmdDN3K1c1dVEwQWk1dzl0QnJFYmV5RjBoNVp4cWY0?=
 =?utf-8?B?aktmaDdLRjBSeGRLS0E4ZFNrdE03T3ZLaXhCZlpNR0ZiMkpoenJQa2VaaERm?=
 =?utf-8?B?VGsrUERVLzlhNitRV1pSWjlydWhUUXI2bTkzZ1hyUjdwaUtTNkwrMVp3dWI1?=
 =?utf-8?B?N0t6cEpMOVhrNlkyQ2RUWVA4MkpsYTQ0cEVmR0paREhSVVFBMzJPaUQwdzBu?=
 =?utf-8?B?SHFMcXVtOHMrSjNsZkplM0lPTVVpT0xza2FiczU4MXFDUlNMb3ZoZmVvUGFQ?=
 =?utf-8?B?VVhTVG8rNFF4bHY4UnNncW1CZ0tvNnZNMWo0eHhZYXhqTG4xblNBM1o1V3pD?=
 =?utf-8?B?UXp1ZHNKcXRJRThlNXJtdXQzOXNPQ1ppWVFBMmZlSHZiRTRKcnNqNE54NGJ3?=
 =?utf-8?B?WStNRDZYeVRhUFhYQXVYcmFSczBaVmxKZVJLM3cwSlZrbStEMnpoVVpKM1hw?=
 =?utf-8?B?OGJHTTZjVDNKV1hOMFZjc1BpdC9KUGdCYWlrTHZZKzFjNExEdWVUQ250K2hu?=
 =?utf-8?B?d0NDMEt4WENBSlFSL0ZCWTJTZldBNmFSS2tOYmUyV3R6SjE3cFI4em8raUZN?=
 =?utf-8?B?SStxNVZSWTFRNmNkLzFISUhJZGVPVThZbWtNWDJBQnBWSGdWajMraXJuWTVO?=
 =?utf-8?B?SVlKanl4Z1dwTjVsTURNakMvdVhVcW1vU1J5eXFTTWVrSm1LSGNCTlUzQVUz?=
 =?utf-8?B?YmtGQWk1Zmt4WENMY1piNVZoUTMzbDc0Wm9VTTY5T1J0WTRJcW1yclNKYy9a?=
 =?utf-8?B?eVk0MDEwYXIrWGFXQkdTUHFmWE9QRTQwN3M2RlgrL3NWeW5YZVdqTWhnQ3ov?=
 =?utf-8?B?UHM1RC9DT0hFbW01V2s4RC9EVkthb01adFYzeGh1amFiZnpZNTlzZjZkNGhG?=
 =?utf-8?B?TUF0Zm9hWlZ4NmdSc0duWEtTS2tGNjFEbzhyU05aUlNjUDVBNFJuWGJwSXla?=
 =?utf-8?B?NnBaZnVmSjVvaktwKzZNVjI3MW9ONjdkRERoY2Q2LzI3d3E4N1UzUkNHZTdq?=
 =?utf-8?B?RVBIUEVYRWxhL1habXZyQS9sUDNtZUIvd0FXRnU3enRJR293OVk0cjdKQ3ZX?=
 =?utf-8?B?dVdSMkhxVVZIK0tRcVFrYnpUMXlLZjdRUGcvdzZxWUFjdi9EQ1VyNzg4bzdV?=
 =?utf-8?B?bko1K3V1NnlueVZnRGcyZDZTUi9sWEJpNzcxNi8wb2ZZdEkxc2VzcE5xc3JO?=
 =?utf-8?B?VDUrd2JGb05tazZhcEtyZnJiMTNFTkFKdURzTDhQanBpZEVzQ2Q3NkNaT3ph?=
 =?utf-8?B?bDZlQU9POFIwaHlMOHNzSXBqY2p2MWtTK05lRlJQc2p1L2Vhc0orYUl3T0NQ?=
 =?utf-8?B?VGFrc3NkV1Q0M2xNUEZoYUgvdGNTVjhLNFJVL2hPZG01WUJvNmVKRHpuTDJW?=
 =?utf-8?B?QkpUYnRmeEZETld1VTZtRVl4ZUxuMi9PRUMwYU05eFM0alV1OTdpR296aFN4?=
 =?utf-8?B?SDVDNmY0dUNzK250b25Vdk9IQ29IcGhJelhRRnEwL1JqemJ6amhyUEtZdWNG?=
 =?utf-8?B?UFNGMEZHMCsyN3lYNWQ1NmVES0kxUWFHbUE1eWpsVG5NMTY3eDh6bnBGTWw1?=
 =?utf-8?B?K1JpSG9OYmVzVnRxc0JZcTZJSDVnZHp5a1B1THV3b1VQNlNZUi9CU1p6MlIy?=
 =?utf-8?B?MEZQVmxQZ3VsWWdvNlB6YlphbEpHUS9zeVpRTWJycjJBUjhlTzRpUUdvWnM1?=
 =?utf-8?Q?WBGW05gRP3hrDkxXYI0QFoEoP1SBdPAClDkZPuu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6a6fb9-e3f9-4ce8-7987-08d909c493d8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 21:36:54.9926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cdc6V7YvWRDGzy6Hsy1PlKS1jMEHNjTDQVAR2s7C/idsT/SDw3z80RBVJXQJGXqzmMc1eMJXif9YtWA+sGJikctAxhyPFpP7eIaCK6oB+TI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4637
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270144
X-Proofpoint-ORIG-GUID: tdbgdUzeJS4sZ0HRZkb87YkUwyuVwWn6
X-Proofpoint-GUID: tdbgdUzeJS4sZ0HRZkb87YkUwyuVwWn6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270144
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/23/21 6:10 AM, Brian Foster wrote:
> perag reservation is enabled at mount time on a per AG basis. The
> upcoming change to set aside allocbt blocks from block reservation
> requires a populated allocbt counter as soon as possible after mount
> to be fully effective against large perag reservations. Therefore as
> a preparation step, initialize the pagf on all mounts where at least
> one reservation is active. Note that this already occurs to some
> degree on most default format filesystems as reservation requirement
> calculations already depend on the AGF or AGI, depending on the
> reservation type.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_ag_resv.c | 34 +++++++++++++++++++++++-----------
>   1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..e32a1833d523 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -253,7 +253,8 @@ xfs_ag_resv_init(
>   	xfs_agnumber_t			agno = pag->pag_agno;
>   	xfs_extlen_t			ask;
>   	xfs_extlen_t			used;
> -	int				error = 0;
> +	int				error = 0, error2;
> +	bool				has_resv = false;
>   
>   	/* Create the metadata reservation. */
>   	if (pag->pag_meta_resv.ar_asked == 0) {
> @@ -291,6 +292,8 @@ xfs_ag_resv_init(
>   			if (error)
>   				goto out;
>   		}
> +		if (ask)
> +			has_resv = true;
>   	}
>   
>   	/* Create the RMAPBT metadata reservation */
> @@ -304,19 +307,28 @@ xfs_ag_resv_init(
>   		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
>   		if (error)
>   			goto out;
> +		if (ask)
> +			has_resv = true;
>   	}
>   
> -#ifdef DEBUG
> -	/* need to read in the AGF for the ASSERT below to work */
> -	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
> -	if (error)
> -		return error;
> -
> -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -	       pag->pagf_freeblks + pag->pagf_flcount);
> -#endif
>   out:
> +	/*
> +	 * Initialize the pagf if we have at least one active reservation on the
> +	 * AG. This may have occurred already via reservation calculation, but
> +	 * fall back to an explicit init to ensure the in-core allocbt usage
> +	 * counters are initialized as soon as possible. This is important
> +	 * because filesystems with large perag reservations are susceptible to
> +	 * free space reservation problems that the allocbt counter is used to
> +	 * address.
> +	 */
> +	if (has_resv) {
> +		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
> +		if (error2)
> +			return error2;
> +		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> +		       pag->pagf_freeblks + pag->pagf_flcount);
> +	}
>   	return error;
>   }
>   
> 
