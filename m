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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FEDC48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 989A4613CF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFKV5x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38540 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFKV5w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:52 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLtnhE016826;
        Fri, 11 Jun 2021 21:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z20d/obSC1ZBYaubmOgdT4X01Xs7iiRYCTU0SbnUeHg=;
 b=xVSuNDefTeLJ9o0aV4BYQMb9eccrzS3kSNPSMcfBnld16Gt5SUv7VDD+exf2EMM6/YJI
 Yx7gVcsqSl1ynbnDqvSal2yF53klUfaLrqhh+XZ/PtWXgRYYCfg4TD1jJ3d3MAnFRnPL
 cblup9Y2ANN/yNJ1opbXlQSDaffBzlkMo86YfDNcajMtARrXQhxe21kP6w9iCs0AzKu5
 Mx91u7E2G/484AYcPKTtniIdrwk58a9RuBGqs0lWPNPKsOq5tyFQKEHmqyt/fNJwA0of
 G0XxHKb1+jGvP1MrfTBCw1nOXDE2VEvVkG1c0NqCxIz0vEkMUlw9AoJHTStu11peVaam wg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 393y0x0ad2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:48 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLp3BY194109;
        Fri, 11 Jun 2021 21:55:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 3949cwchhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jau0wiCtVJswr4lQMw1yn2xSKz3LFUS6KKD+niId79avJoJGNy/sEKbl5OtWETEEt5YNaOl+wqrIY8hnyGEw6m4ed+pQOVU7/fAK5ffrRpYYI0SZaI9cy/q1V6sB9fR2RgVHSJa9teUKbVFyrBxIN2xvIRENpitI1rcPUUSfgoDjAtNUNIKlmoB2UkLWR+VnUaeD0aEQapx3GaXMWF9fc3EjA1XEQoO/VZeT2JzVZUJxvjsmal03Ak8D8hhsifOVFCNZFGpjcWn7Pkmx2z1axNOxJ3zQRfNfxjH3wNagwOn6j4Rcz8RCMGnA51KyFFgs9sE8AI+BE/GDNpXkTJr6DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z20d/obSC1ZBYaubmOgdT4X01Xs7iiRYCTU0SbnUeHg=;
 b=P8DrCxMQOxJecrwOhO/eDXftLjFMhOzJnF0F4Tv+3WLyGBgnqycIrTDPfTOmrOxUhpGoJBShCQNlqwBjW9dwk3JaJb1j/RHI/jeYzkZym63a1DaETrP5/cUZsa3uAsTtcMZuxyKkzKZQypfKmDXl2EniqmFdhI/AGUBx3ZHJJVoIUuLojdnRJ3hWuYSvpPu4DaRSJi2PkxcFHZAwiwTj9Yf1wnIeQoCIofa4exyiJzXJzsqWEN/yZ2tjUe3s3b6wXuEiwonnJqn0rwYlT7Qd6R9/HWmKiID+lPt3U9Bnq4tPiqVLbsXV+IWk1hggLytDafCkXtqnFkVUIE88Hz66jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z20d/obSC1ZBYaubmOgdT4X01Xs7iiRYCTU0SbnUeHg=;
 b=YIkgVog+MTKgCcgojG7DJEhOiGze0o7GzeDdxkSeuNZOkH9VmH0eX9DfdxUvV6OUaD2bqMO9h9Cmhr9+5nvLDKqkeRBBQNzVbTFzAPdP2Fz/jQsw2cYuJIPLeVXZ1E1HpDyVIaXAUAfVOJtL3Hnsk3GMua6xUXycue0cSxDTtLc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3955.namprd10.prod.outlook.com (2603:10b6:a03:1f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 21:55:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:55:40 +0000
Subject: Re: [PATCH 06/13] fstests: clean up open-coded golden output
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317279504.653489.6631181052382825481.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c97bb818-82bd-50bb-480e-56c99d3d413f@oracle.com>
Date:   Fri, 11 Jun 2021 14:55:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317279504.653489.6631181052382825481.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0010.namprd03.prod.outlook.com (2603:10b6:a02:a8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 21:55:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73fc6762-f6e8-46c3-d8bf-08d92d23a6fa
X-MS-TrafficTypeDiagnostic: BY5PR10MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR10MB395507B7FABD9E978AF0DF8395349@BY5PR10MB3955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:156;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4UYz8EOJSAOGoivIwoPBO6dV7xInMxLW8D+hyIDz0Vd3lS8Galo8Ile7eNinFEXDJCsllTvT3/8Sl4Taig9piEMZvEVVHSMUsRHi82Ep+8BXrWe45Yz0TikJgpF+nrl2sulYXnArf92Uoh3wyw6gb0lsXK/ELoCf24QQI6Bri/izobK18QvWZ1H94bSVXa1rQXqbOf5RO2T0IUPRuHrPBDzkjhoox7wBIlHYL9WD4PvBHwAm1LnV9mtNPx2e1ZeATIhI9MakldIvi0/m1lUYERcIHlyVsB6eWE6AB1GFXvjkUxONqqE4ruu1IOYm40x6LZHo+bXAfZ2YYD7xHYSXPd24xEVdjEGGlgdbHhIj7t+vtzEj2U7qKRJkcwofFUQWQCG7pbVrDqmdB45/ompK7rRK2qMoiAxc3qYA/NOnlyL3kJ0NDbKAVRJkqmfam0H1kXvx32IhGUTl8J5s6nwhOoxRqoH8umzjIsAKyLP5b3EUZmqj/BbFLl0Yz6uqZpNYpQt//me7WA0nzMnIMobzWfF00oYVU6D2A8fxgU7GHP4W3izKUPawcBTk6mRP0ez9Qg9HQdS9L2Vpdv74YX5ydb65D8x4cVbNstrbKbWDefy72dmL4HKyKMgye3nPT3qr4Pew4wS9uczEsAALiKU11bsjoMG8Jzf+L2g9LK1D7X48/sgGNAe1zn8AbxEBX1ltH8KsbXtlq1bTA8geoFb8JDgQWc7ZsQlyYb9o45S+L8s7t7uAWHqnBoA2uHjY5jbn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(44832011)(31686004)(478600001)(8936002)(4326008)(6486002)(66556008)(66476007)(5660300002)(86362001)(38100700002)(38350700002)(2616005)(956004)(16526019)(8676002)(53546011)(316002)(52116002)(31696002)(83380400001)(186003)(36756003)(16576012)(26005)(66946007)(2906002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEc0eFFFcWtrbkxwMzZUMTJsTnVhengzaExZNmNRQWo2eWR5K2lvUmFvRHM4?=
 =?utf-8?B?R3lyN1RVN2JySmt4RUh1cFhyM2ZiY0xUQXVERFBtN1JpelgzemptczQwS0pG?=
 =?utf-8?B?Q2ZQSFovVlh3TDVVbzI2ckFjTklmZHpKaytKejhJclVDRHQ4V294eVN2TmJD?=
 =?utf-8?B?cEMrejR2bDhDeVp1dkFRV21uQTNIRkxVQk1mZktlTDZMdU12eFFzblpqamY1?=
 =?utf-8?B?a2kvY1NScXdMVnVITzlzR1hXQlV5bW9YZ0pFM2pmSUlzV0JMQ3YrTXRaWUQ3?=
 =?utf-8?B?UnV0U2lHeHhHNFduVlJLSHJHNEcza09KbmdNb2QzL245OWNOMWNpaTF2Z3Bk?=
 =?utf-8?B?akdEUkRMVXQ1ejhlVUdDVEtOVzJhUU9rcGVRTnFsa2syczRqdk93MGViSHl5?=
 =?utf-8?B?dUNZZmd2S3hENUw0OTYvWXM4Q3VKcDdpbGttR01nVHFTeHgxMDJiakFjc1dZ?=
 =?utf-8?B?cTcwMHV6SVkvN0dzVkNCTUh1ajkzV09wbEZIU2syQkZCQjFVNEdvdG5VS1ox?=
 =?utf-8?B?L2F5VkJRUWFzU1E4OVcvMjBCNU83dnUwVmFlME90ZTNkdzkzY2hCTGdOS2lL?=
 =?utf-8?B?OTdCZEg3SXR0cmFLaVlIcVBZNTZVN2J1NkJSNFlPT0xDZXAzemlxNkRxenpV?=
 =?utf-8?B?Um1yVDZPL1JrWUhXa29lb2lCRlRubnpVdWVBWll2SzBSTUxob3p0ZXJkQW9k?=
 =?utf-8?B?QzlxVS83b1VNMEt3MHVQY1dWc3FMcXJmcExnV1QxaGFqTWJqM3llQTZrQndN?=
 =?utf-8?B?aWxWbFVNL2E3bkNHeVhWNFVwVkl5T21ldkhlSFNDNCs4STFRVUthWldWSnhU?=
 =?utf-8?B?djJXbXAvS2NVVjdZNGRuNmdHeUJPWDVkTG5KZWlJYStHeDV5QlAvM1RaRTBp?=
 =?utf-8?B?S3FKVEVuVU9ONmtXVUUzTWNsMGVyRXgwcTBvM2RqbVdaZW1PZ1J1eU00aGZo?=
 =?utf-8?B?azRia2FGZkhRT29EOGpHQU5rMS9IQ214QlUzeGw5akxIV1RzckZaRDcvekpV?=
 =?utf-8?B?Zjl3WGN5cjJMc1hGKytyNms1NXJvaFM0ZThSRCt4Skd0ZVdITzJSM2NOblNN?=
 =?utf-8?B?bXVUWUFFdm9yRHd2UnRQSlJFWXR6Y09wNFc5cTUvUTBicURab1VxSDhjT0Yy?=
 =?utf-8?B?eVZXSWI4N3pWWjlFQXR6R2RoaWNzZkpBSlF3TldtNXFReVc4ZjlCMDR4Sjg1?=
 =?utf-8?B?NDJKTWViM25oN2h4QldMMjZVVTVyaHp0dUc4bG5rZzIrVFdpMEJXL3JFaysy?=
 =?utf-8?B?WTJtVlQ3OEVvU3VuODZpOVg0dFZvbzlWbzFNSXE5bXFYUFFDaElzQkRaMU1w?=
 =?utf-8?B?ek9vcHk2djREWEd1MEdGcGE1Z1NaYmtidk5pVXB4MU1VTGFRbDZiWFpvUnBO?=
 =?utf-8?B?aEIyejUxYXNYSUJackN3eVhxV2grelVLQmF4VEhyek1yT1pYWU1rai9lZHhU?=
 =?utf-8?B?VWVTYjRmai9QUkNOSTh1ZkZsdVA2UnJlNmgrZDNOaDJtREs3QWM5UE9ubVRR?=
 =?utf-8?B?ZGdaTkJNUWxVV245dm12RXhxRkg5UFlFY3gzZnpDK00rS1FFbzByNytFNTly?=
 =?utf-8?B?VW9QYTFnM0orOXp0TFFXbXNtSHYwb0tUa1ZVUEhtSjZDK0Y4NHlBZ1NCcmc2?=
 =?utf-8?B?NzNNb3ZZSEZzWmN0UzdyUVNJU3NHVjluNnpoVE1VYVRJcGFyTlVvWmFPSDd0?=
 =?utf-8?B?MXZOb1E4eEtMMWhPa1lJQk1kSVp4MzZaUjExOEQrSnQ1TnM3TVJ3OWg1OUZB?=
 =?utf-8?Q?1611CYxd05kAPW51TGxSjvOKCKyeebDrhDLabSA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73fc6762-f6e8-46c3-d8bf-08d92d23a6fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:55:40.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vv5eEyolrVV6Dv0ah4XuXkQxe4/x3ovWtzhlMhI4iMOJgY7rbjd1xWt5ia3zaLx0WZGeLAxTzHwVsZbvlyNY+gzvOAz3NMwnFk6ZhgYUgJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3955
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110136
X-Proofpoint-GUID: HhmiMxAiDqVsJnAK4gWK3-4e4j6lwTpo
X-Proofpoint-ORIG-GUID: HhmiMxAiDqVsJnAK4gWK3-4e4j6lwTpo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the handful of tests that open-coded 'QA output created by XXX'.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks fine
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   tests/btrfs/006.out   |    2 +-
>   tests/btrfs/012.out   |    2 +-
>   tests/generic/184.out |    2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
> index a9769721..b7f29f96 100644
> --- a/tests/btrfs/006.out
> +++ b/tests/btrfs/006.out
> @@ -1,4 +1,4 @@
> -== QA output created by 006
> +QA output created by 006
>   == Set filesystem label to TestLabel.006
>   == Get filesystem label
>   TestLabel.006
> diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
> index 2a41e7e4..7aa5ae94 100644
> --- a/tests/btrfs/012.out
> +++ b/tests/btrfs/012.out
> @@ -1 +1 @@
> -== QA output created by 012
> +QA output created by 012
> diff --git a/tests/generic/184.out b/tests/generic/184.out
> index 2d19691d..4c300543 100644
> --- a/tests/generic/184.out
> +++ b/tests/generic/184.out
> @@ -1 +1 @@
> -QA output created by 184 - silence is golden
> +QA output created by 184
> 
