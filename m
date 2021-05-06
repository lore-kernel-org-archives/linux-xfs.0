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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74E2C43460
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 05:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C35610A7
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 05:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhEFF1f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 01:27:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFF1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 01:27:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1465OPwT071382;
        Thu, 6 May 2021 05:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3nGdPYMlqRZLqD1v2nyVyxxmaqnPHKS0UPD4viel+Z0=;
 b=jTVztVAJ/TUlyMtiT3+hflz9CImnHJmn0fya8FUKi17FDJ1c9iAaff0OKgKeIQKi0KIb
 VOLXnQdiDQP1lxwb3aVPhC5LerLgrwGW+STk1NJCwpJwKCv8A/gbuVyrDrz5oJakjVzU
 /b3VXaJIA2p8n8/pYtfj1hyi3hdIX7+LbuhxE9AebT5C5l0vC5oXJSq48ppPhoFOU3zv
 y/JvnaetUQL1QihFugvgCNr/SD3yTXOnooW8YxyL4RpFZQieHDXI2WneBzHfrC0+jTCS
 KMYxt2qNadwodq53RIjZLrZ1D177d21RWePhBa6Tdd2++5VX2PbzoKqbS4l6kvjZJWie ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38bebc3t3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 05:26:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1465PUkv073691;
        Thu, 6 May 2021 05:26:34 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 38bews6y1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 05:26:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+sloRY1T+FW3yXxZCRn3nflSpBJdVPgswd3JemfyGa8SosHsUR4/zJvg1I791tVssaa9fe7+fXsIDdyqO/5TkJ8EQ75hm2JQoRcyK4w+itOLU0plCGXCKRsGj1b38SeIqQ4+fTCjf1dvDdB6LCyT+1/1dO6t7j9devawzqHs5otKt6ftT9/aNV6lQQlJx10OpdjD+eb/0cDyh2NPuYXJs4ZmntDTAZ0FWjJIGyZewdNomuQnAHfND//nrvXK66Jg0fu61aedmZq6suf1rqmwrbjuDBUwJg/iWhE27Mnjann+rSHBz0/S0LlaYDuzJMkPFA8gY1iX9EclQzgWtZ/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nGdPYMlqRZLqD1v2nyVyxxmaqnPHKS0UPD4viel+Z0=;
 b=Pl43jMCJgh7To+Gqqm5rTGTr/kCJup3IfKv0fXxnPCW5NPyI9g71Yevj5twK4lLO/fob6wKTM3pq28MtFcY2BVMZJddVXa8AY/JfBY/efNsa4SH1GjxyQQ/Tq1q06As7Yt+vMnfyB5+VCfqWx0Uo12kFkXciewRv1dtoYa8+MT8xVwd/4ez49lZzTRtkbF6sXsYBFdPRAsB771Xv5ktWQVyLlVYmkgA1z1RPoIu1Sk8xcSwx1yQ/gltSKzYgppdffGzTVNt51Uw9IHY6kP7pTitD7wCVGom08yrAT0TUHQHcqLAU2KkkJUl/uVuA10nofgOHO3twK6bq5fcEaTxhMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nGdPYMlqRZLqD1v2nyVyxxmaqnPHKS0UPD4viel+Z0=;
 b=uCTl4sT+tZLQkLovOCAsyPAIYKY0iRe6rDkgOrBsV+GlnIBqBzsm9on6oduz63FHp51xMAiYjGVHayiO83l+PNqaUwEM7fJ4rcm7j9zMaoTUvTQzlpxZDcjuvzvKtZ7dg8LJvOO9gqUmAkLIL67l/cKvuHLXV93DPu3iDnI0BY0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3956.namprd10.prod.outlook.com (2603:10b6:a03:1b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 05:26:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4065.039; Thu, 6 May 2021
 05:26:32 +0000
Subject: Re: [PATCH 2/2] xfs: retry allocations when locality-based search
 fails
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162007768318.836421.15582644026342097489.stgit@magnolia>
 <162007769456.836421.14886406791989530317.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a1609c23-62e3-26cb-df31-d49c3063bf6b@oracle.com>
Date:   Wed, 5 May 2021 22:26:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <162007769456.836421.14886406791989530317.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:a03:167::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BY5PR17CA0065.namprd17.prod.outlook.com (2603:10b6:a03:167::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 05:26:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d57c0849-5843-4608-e2f5-08d9104f8249
X-MS-TrafficTypeDiagnostic: BY5PR10MB3956:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3956D14165C3AFB0F2C4C9F395589@BY5PR10MB3956.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdFKmIkNt3HKq7QxS5H37mXdX6Wtme+A4OEBrHY33gSywkGOFY/BgZCcHQ3tbgxGmBmTO3XytI0uaS4DZTx1oqRsFC2sFswvcHDfhJp2FJm6INWSvT6g4xPSXNuRvDz+xYGR3QCb2lWLffunVXMlnMlazOHP2kAdfa31RzwAQOszLT1NivXow8KCQwck8Fd0FAIG6NICu4wZqFUgZtRkaYuHTqnGJjAxhMjnYJhNQJ2oVvz9O5l5WUMsci29q9SuP/NMRsrkgJdlSYipqqqgiiPWqHQjIJLygqC8xfQ8XRoZjn0VZqMKezIz6Z3HXqeil3t8Z1iv+ktNy/2z8/PbJhe5rxKwZYQIlGAq3PiOMGkFBxV8s/lj0Bg78OmPSbkXe9WSzWtXcaEHWHVoL4BYoJjy56vyF67FYaY0D1eWa+2KE9pmlFoik/upadasMlIUKrkLbPWEDdDL3YM9/w9OiK1V1M5S58WLlwHmVAJ2hdA4Hr/5LlPGtS9wW/GpfSy48JQIR61U0SoEsUIQImpiDjPKIahRRY1qxS13orQyXBNZ5a2cfLH7mQbhprFFf60rr9rfc0L7bS4WHhFr7rIsMZP4uMmIYOzarV8A9GiyOrUt3I7qslOl721s6Ik7n/dBFXXVa37/CBjdmivWOVm5Qn7IYeFPOsYBoeV0aTZ6vANuMIgwlBmoJxR6sE7mNj3GIh94ryQIdePpnPPJZEbi8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(26005)(31686004)(44832011)(8676002)(8936002)(66946007)(478600001)(36756003)(66556008)(16576012)(66476007)(186003)(2616005)(16526019)(5660300002)(6486002)(316002)(31696002)(52116002)(53546011)(6916009)(956004)(2906002)(83380400001)(38350700002)(4326008)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WlYxWDZzUVVqZzZkaEZoMVc5UnJrOXF3dXhsUEtQVWt6Q25jeHpmUGtKcm8v?=
 =?utf-8?B?TmpabzRGUzVlLzlpL3VMSUlRbzdMTVpCdFlybllxU2Q0MEJHTDRCSTNPMjFB?=
 =?utf-8?B?Y0I2UCszRllZZXB5Zmk5aC9NZktTQ2VNbUxYZ09QZm5KZVZ3bzdSZHBxUmlY?=
 =?utf-8?B?Z3BPMjhBNHcvNUZhR2Fwa0xwekNiR0RHRC9hRlE0TU43TWhQZXBLcFd2T3Y2?=
 =?utf-8?B?MC9od29lSnFPdE9UWGVQaTdvRFJycG9QUmNxT05xVCtVZFpKU2lvazVoZUVZ?=
 =?utf-8?B?aHRwd2xrZWR3azNDUlVQMkYrVk8vUjNKMC9MYjlneDhQYmUzYmluMjNUMHE2?=
 =?utf-8?B?K3ZLYVVBUlpkZk12ZkJIRWU2TENVMEUvUHMzaHBjMnZHbzZGOTVjWnp3YUQ0?=
 =?utf-8?B?Z09lSHU0VXZRV2hmSEJ0ek5IMFhVTXpGNkxZaWxJb3BPNStuK1M4TktScGN5?=
 =?utf-8?B?SmlrRit2REt6cjIzWWRBbDBsSSt1SFVwL2s3aEZHVG9zZllWRFJ1czZhcjhQ?=
 =?utf-8?B?cjlVZUxXQy9lWi9YcVY3OC8vekRaSlRHQlk3S1RoWk5KVjJoZmhLTExlVHVO?=
 =?utf-8?B?cXk0aHI4NTdhWkFVSlFHVDNSWmk5cTJzZ2JpYzBVOXFzcVVwNlBuVkIwZkxl?=
 =?utf-8?B?M0I1Tm9pYnhFUHVkcys3TXF2UGhncU5WdE0rem4vZktDNllsdlFyRllHaHFs?=
 =?utf-8?B?TlQ0Z0syZUwwMVRSQVBQQWNrTHBvRWVBQ1lheG1YZk1YSlgrdXJNVExTWUJP?=
 =?utf-8?B?dVp5NkNIWmFNMFdLLzlHKzlRdjRpRWVmVnNYNit5cUZtdUh4eUxtZTVVUVpy?=
 =?utf-8?B?YzY2VlVDd09jNHg5WFI1UUwxendXUHZORGRISWtHcEh3cS9ldThQejJRV2d6?=
 =?utf-8?B?a3kzcVV1cXZ1Y1FZM3NSejhlaml0ZUhsUlptbDJUbkg0MXBxcDV5OFlaUVFG?=
 =?utf-8?B?VzJTSWZkRmxCNmtWWCtJcHR5NE0vaWxwSXJ6S0t3RCtFRFV0QjlIRGZMK0gw?=
 =?utf-8?B?TlZmRWdtSGNuWmFyeHhhRXN4eVNPVmphTVNMdnN2T2J5UUROTld6SnczT21s?=
 =?utf-8?B?ZEZuL1ZiOHJTN0VhWWFBenlxcUhYYzlTRC9wYWNPaHVsa1d6WUJWS2VYZ0I2?=
 =?utf-8?B?Wk1SSStOa2M4N2ovU3dSb2p4elp0eXhuWW8xV3IzWTZJSmpJQ09VMExKcXZN?=
 =?utf-8?B?UHo2WjVvUHR5a2JxQ05aQU1kUVF4MC9kMndPaC8ydjJybEc0UVlERTdtbytG?=
 =?utf-8?B?emJVU2pSNDFQTTgxZnhyTUFiS011dC9oNmVwakR4dXl5UUJLcEhWdy9tQWZj?=
 =?utf-8?B?NEgrVlNkZHR2R0FDWUlEOGF6WnpQRzIyTUZCWTUxRFpDblRNVWkrZEtsMFFK?=
 =?utf-8?B?bHNqU0trbHdYbVVLT1ZqZjdsK0hjMlVpcDZrb2MwTEo3Zm8zNXZ2NGtyR2FB?=
 =?utf-8?B?TEc1cnRXM0pYTjdUcHJrcVNRbTZFSXR1VVFPYnovcVU3dGlnMkV0U2tCZlRZ?=
 =?utf-8?B?aWc4R2docUhlZGEvZ3pFMFVVVU83Rm5oTmx2bTZQc2FkUG53SHR1OGQ3QTV0?=
 =?utf-8?B?d2R5VzEySjNPeXVoQzlPZnEwYTduLzRMeDNKclBQMWZPKzAxSjlLLzg1dHpE?=
 =?utf-8?B?TVlad3dFZlJ2MzdjeEtxNDdTQ1lXbXV0d0x3V2JBdW9vTUpKbSs2OU5oOGpx?=
 =?utf-8?B?NTh5L25la3Rqc2ZlRlVNdHZkWjRQNzFoVTVvVitZajArZHNvcElSTFF1TjN4?=
 =?utf-8?Q?fUeTDGgtzIq44S11Nvp10XEJJGxrIdUu0svqRgx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57c0849-5843-4608-e2f5-08d9104f8249
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 05:26:32.5569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6VLZuh7sZmjCKDY8dvfQZsnrJD4/wtgncdAGv6K4bHwnY0/3z2qCk/N+KLWfm3TBd0rLreISS0BQDS1VDt+GbYDA8Pcr7uYTDcGK8WZAmDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3956
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060035
X-Proofpoint-ORIG-GUID: ecldebXODHUqb0rp3M8EgE03b8Yf9AQR
X-Proofpoint-GUID: ecldebXODHUqb0rp3M8EgE03b8Yf9AQR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060035
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/3/21 2:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a realtime allocation fails because we can't find a sufficiently
> large free extent satisfying locality rules, relax the locality rules
> and try again.  This reduces the occurrence of short writes to realtime
> files when the write size is large and the free space is fragmented.
> 
> This was originally discovered by running generic/186 with the realtime
> reflink patchset and a 128k cow extent size hint, but the same problem
> can manifest with a 128k extent size hint, so applies the fix now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_bmap_util.c |   15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c9381bf4f04b..0936f3a96fe6 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -84,6 +84,7 @@ xfs_bmap_rtalloc(
>   	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
>   	xfs_extlen_t		raminlen;
>   	bool			rtlocked = false;
> +	bool			ignore_locality = false;
>   	int			error;
>   
>   	align = xfs_get_extsz_hint(ap->ip);
> @@ -158,7 +159,10 @@ xfs_bmap_rtalloc(
>   	/*
>   	 * Realtime allocation, done through xfs_rtallocate_extent.
>   	 */
> -	do_div(ap->blkno, mp->m_sb.sb_rextsize);
> +	if (ignore_locality)
> +		ap->blkno = 0;
> +	else
> +		do_div(ap->blkno, mp->m_sb.sb_rextsize);
>   	rtb = ap->blkno;
>   	ap->length = ralen;
>   	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
> @@ -197,6 +201,15 @@ xfs_bmap_rtalloc(
>   		goto retry;
>   	}
>   
> +	if (!ignore_locality && ap->blkno != 0) {
> +		/*
> +		 * If we can't allocate near a specific rt extent, try again
> +		 * without locality criteria.
> +		 */
> +		ignore_locality = true;
> +		goto retry;
> +	}
> +
>   	ap->blkno = NULLFSBLOCK;
>   	ap->length = 0;
>   	return 0;
> 
