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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4205C43460
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AE1613ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhDVVRQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:17:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53298 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVVRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 17:17:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MLD3hN030637;
        Thu, 22 Apr 2021 21:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wCbl73pTcktkNUEiW6keDUfzHMsJCwQOmPlk37EdOSM=;
 b=MIRgc0ptqjQG7ZNjQc6XFswVaQuz4z1yQPJQa/bYlleetiPKhGX5fmobyuJG2oNLZkFc
 Dhu0VwdH3/TF4CyhvloOfev8gu790sAMpxWnHo3fnjJGq9nTtuOD3jqdxb+GZLWBFgh+
 7gcOEuinz+LRpR2AaUeC4iwSPYgKTEHALdBhtjRfSLaiaszkmknUbLy7pPhcgP9m3d63
 c9Hdmvib4e0nCtQDe+y/DJICZBgPDEtKI5dJBtsCKP28pKYU7YPJRfinLsMZ0zRxrqTh
 OXHJXy/F6XojclipCX+uAxPJH56/LGrSFNzw0eVvFkPsvYyU0YsNNy7wE9xaS4cNGjII +Q== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 382uth0fb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:33 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13MLGW1a084666;
        Thu, 22 Apr 2021 21:16:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3030.oracle.com with ESMTP id 383cds4rav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZH/FEoW2e7pmNGzDkzXLENN1yI+JoF9frnZoHS780fEi6P0Wskn6Cox4XJ4kuUqBmtSysCzihM8JLo88a+AHX+dDq97/hPCTohXtXpy4bG4N3ySsVg9x9gtrjYsgwW0evjAcTTtZfv3y3MSAh7mATBsahM9uppoRIoVXuWL4WFZ6w+ttn9uUxQaMzgCclkB22sCrzSFn60VLpqNednwNNnL21TIvfe4lQbVyuBNZHHklVBwmGOZBPqmOgxfOqqBtG3V3b73ugHAhLjZHcU0ur1uvBE/U5hlXeev0YkZaM3bBzI2JRTo1FWP9d5T3GT9NMs+kH+xP+pHe1eFPN36Ygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCbl73pTcktkNUEiW6keDUfzHMsJCwQOmPlk37EdOSM=;
 b=Lyf/khzoNvLYSvyY4rrQZ6Jo1IAngltdrjYBHbZUlXWv40mXh8wsvdO6Yi2QPT7J3Ow0zJGvZbr6rk3jmc8/EnlyWWU48HI8KqdSs4EGPkk2WEE6+ny6FKIL68uGJoGa3oCfFSTUxOf9Zd1EtE/HhUGdpI66lsSjr0w2DED0l/Xc39iKIC9qXCorQ7u9UEXISOTTscdRZ9Lcx+rTy6SrQa8LW7S7wwE33qNopc+B3yt+t/okD4xnKZEbAA4ff2kqvYU0adXOGyM0QoMu6WDE4M4dF8EKQ8aH+yMBtOesxreENlYFFlfVNlrPskgEzdIMHibzy5mzm2wtgF+L8c/xIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCbl73pTcktkNUEiW6keDUfzHMsJCwQOmPlk37EdOSM=;
 b=D1yePJorz2lqgM5wIxWBEU76XDVNggA2pIFDNe6p9juEc1EFF1tQoYrZOKnoqWgLgUvORIg1Kxd+F/6lq3DwQXFuzjShzF5e991dY78FTqD9IzCTunoy0wr8n+BhDvsdmCx0L72S8A7/lgRhULamZpY0ChiZpbknjVbxt8p1xe0=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2870.namprd10.prod.outlook.com (2603:10b6:a03:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Thu, 22 Apr
 2021 21:16:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:16:29 +0000
Subject: Re: [PATCH 1/4] generic: check userspace handling of extreme
 timestamps
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
 <161896458765.776452.776474866675909773.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6b503579-cc85-7c5a-bd67-95352401d39a@oracle.com>
Date:   Thu, 22 Apr 2021 14:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896458765.776452.776474866675909773.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:a03:54::49) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0072.namprd02.prod.outlook.com (2603:10b6:a03:54::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 21:16:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 132e121b-69f1-4590-21ee-08d905d3e570
X-MS-TrafficTypeDiagnostic: BYAPR10MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR10MB287019B22753A90AA331C8B695469@BYAPR10MB2870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lohjrJNQnSE23AaDspmzeFsd7dzibbR05BNVdCctop64DVCSv7dG7tyK+4IUH4M3gSZnA7mPgRVnstY+fOTUxwVzgdrorQgC0RltFhhtVR4Xj4iPpDSC6vfL+mKUS9wQirPozVMN0jbCyx3CSOzqC4ifchr5cyuRAQBtTnwbOUI4RPp2P2TQ/1ElhB7GxSw3uuyKILUogJ9boEJFtiyf7s5Z9DUGu0IB2VKoRRsXWhWS7GT+cyVanGCEM+FuEBtRseEHxa2Ukk7emZ2Tjkd8N9kUK5fIgE+095QJoNc9a948GymnZLoBJPlv6LuZZFOYrourI3PhAE3aqD7+mauy0u41Af2b64UvnXqxZbfj2LZTXJh8YjhN7ltDwjkQ35WuW3GrcFt4Z414FcM9z8jcEMYJtIaAb90VmRZCFhsUk/MXmdIOke+I3XKPCVj2BJtyD2GBmGzySTVwRWH7vxlL6WGO0odsFEbGrYTGhW/EwYODDdmds50ZXnp5XBFz6Zj6ODK8N4cizBQ1ZI5HabI31msXgDRwmm2rVREZ3MCU8lj8FXOOs0uRiGb0wDmPWbWPbNhwbEpD4l2/XoInUxcr5k8xppnb33ixA4mG9ueYA6M+pq+pUO6WrFHassfa6NJof8pJioD5VYfr3J0XXK1kUBOYpxwAgbP2iyy01ihQdH26dAX+/aR1DoU01y0NcFwdUKjg2SJ/rfViwAQBerenjtbHiXdVRNEtXYeTZBQABec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(66476007)(44832011)(66946007)(31696002)(316002)(52116002)(6486002)(38350700002)(16576012)(83380400001)(86362001)(31686004)(66556008)(956004)(53546011)(38100700002)(36756003)(478600001)(16526019)(8936002)(5660300002)(2906002)(2616005)(26005)(30864003)(4326008)(8676002)(186003)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UzRRZTFUNUlUbGwyaUthTnMzYUdhRjhCa0dESHhpNHMrd3VWQ3FGTVZGK3dE?=
 =?utf-8?B?Qkh6K0dXSlVTYTF0WTgrZlEyVmszOEhDdnVHRDA5TklJVW8weCtHWnBxTkd6?=
 =?utf-8?B?dXpBbkVIRGI0a3IwK25EcWV0TXYwbFBNSUFVY21OMktYblNsaWFWL0J0cmRV?=
 =?utf-8?B?djdacGU0UnlVNERtVlZRb0gvcjlKR3FsUUFaeVorZUx4cTFOTEJTdWVEMnQ1?=
 =?utf-8?B?VFY1WGRoZWdqbCs5VUhESzliSkFMSHZsOG10VzZPL2hBa1c1UnJndDJoZmNJ?=
 =?utf-8?B?eUVsL215bGNXNzc3MVdYMTJRTUZDc3phS0k4VXVocEM0TTBXM2Z2NW5NbDlI?=
 =?utf-8?B?RVNZYnVCRzJ3Um9XdExxRFF3a1NVdG14Z29WWnlXTXMyRWUxdklIcE1uVEtN?=
 =?utf-8?B?OTIxSmlBeGVzQ1hLWkwyZTIxLzhVeG4wa3lpQ0tQRnBQTlBScXgrRSswS0NY?=
 =?utf-8?B?NHR6bWtwMFV1VnBDZkxQOERZTitjLzlPM3ZVTlloakJXRmxaZVppMkk2ajFw?=
 =?utf-8?B?cWtsdTJKdDRycndJK1p0UVZ6a0h5anp2cUN2T3AzSFphMzdVZUg1RnVUS3ds?=
 =?utf-8?B?Sy82am0xNXF5Q253b1p3cDVkSU5uMUQ4ZVFxckFVTElmaFhWZUg5VUFUSVkv?=
 =?utf-8?B?aGk0WDQ0MjNVTGdmYWRpZnpuTFJ2Y3hpSDB1TldrWFFlMFhaMXlZL0xxL1hn?=
 =?utf-8?B?N25uSnVQWkwxWGFZVnZIeU9nWVVHQWdrZStwN3lya1BWVVo2bkwwRGRkK1Jm?=
 =?utf-8?B?UVN2OFlweUd6YS8zL1dhL1A3QjdwZ25CeEZnS2l6QjMrSlJuUjhGV0QxUGV5?=
 =?utf-8?B?L2txeGpSS3g0NzV0NytJVUpIcVZnRXlOQWxPcWJvM253K2trS0tLN0Y0N01Y?=
 =?utf-8?B?QzBMdXdBRzVnMWM4V2N3eGtWVmZZTnNCcHZFN0VrZzVwUHBtTWZJb2RxUGRi?=
 =?utf-8?B?dTNZYVZ0ZFJQa2lxNktldDAxVkV4ZThjUXlaeDEwNm8yUk9rS3B5MG0wUkJ0?=
 =?utf-8?B?UTR4aWtWTzl2Q1hZODRwbFFFSDVoOHcyKzdSY24yTHVlSXZtVXAxc1B3dTNi?=
 =?utf-8?B?YkJWc1UzdFlibURyc1JGKzNUMjhHbXBCQ3RzT1BvbXhRZzlRU2FhVDYvMFdr?=
 =?utf-8?B?VjA4Qjd3TU9iWkRUNzhUTzdiSktqK0Y1OW4ycTAxdU1TRkh5aEpvYWoxQlZS?=
 =?utf-8?B?eXFFM0QrQXFMK3Z2bmpZZlloM2ZpK3g0Z1lNMEhqZFVjZVp0SVdFa1BRTVNj?=
 =?utf-8?B?Tlg0V1lZYnpWRE9xcG5Yc0EvUzNvOEhrSFhhbEZudHA3RTcyRm43UmV3c0h5?=
 =?utf-8?B?Znh3d2pQMVFtTTRPZ0h6MjNFOHFBWWY4UXJockE0WHNYN3dmT1dMT0FvUUdC?=
 =?utf-8?B?WmNqdmpDeEtyK0hpNWwrNUtLdkJIQ1RtdENEQk4vTGxYbjUxMmI4bTVsQW52?=
 =?utf-8?B?dXVqRnQ5aVVjdWt2N0Irc1Q4R0FCOTN2a09PYUJ3bmZlaHZicG4relFLV1Zv?=
 =?utf-8?B?N2Z1dTVGTnpraTM1VVk0TkFNaUJsMzRPQm5ESlFMdkxkaUQ0KzFiVEdWUUFX?=
 =?utf-8?B?UHNMUEMzWkFUNlZRZWllaVdxSnByanVwNkl2Y3g2TDBwMkZZaEpIZ3BIcS9G?=
 =?utf-8?B?S20yWkZ4WHQxczhZek4wbHRLdFJTdG1JU09pMzByNkw0UnZYRFZ0b3d1d0o5?=
 =?utf-8?B?OWU5V21zY1RVZVM3aTFBZGpsdHIyK3RkU2JjMnVPQjk5S0VHWkR5bmlEMjF4?=
 =?utf-8?Q?X0XuotOr5/f7cCGS60axvcLq/8IIw/2VsRKNFkF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132e121b-69f1-4590-21ee-08d905d3e570
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 21:16:29.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EM2thDFNBUTHl1qZ5cSTAHpxrEZeLtbwG1QwOLEUhybXpddlqizILTbU4tV5AmS0rkkepcbhc+ol60cWiSCugLefwN8/HGQ1vrlmQkI75mU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2870
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220158
X-Proofpoint-ORIG-GUID: PTnBK3ifbeQepJOeQPoiOY70qfnZ_LaC
X-Proofpoint-GUID: PTnBK3ifbeQepJOeQPoiOY70qfnZ_LaC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These two tests ensure we can store and retrieve timestamps on the
> extremes of the date ranges supported by userspace, and the common
> places where overflows can happen.
> 
> They differ from generic/402 in that they don't constrain the dates
> tested to the range that the filesystem claims to support; we attempt
> various things that /userspace/ can parse, and then check that the vfs
> clamps and persists the values correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks ok to me.  The tests have quite a bit of overlap, but they're 
pretty small too. I think if we add on any more, probably we should 
think about a common/bigtime file?  But for now, I think it's fine.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/generic/721     |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/721.out |    2 +
>   tests/generic/722     |  125 +++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/generic/722.out |    1
>   tests/generic/group   |    6 ++
>   5 files changed, 255 insertions(+), 2 deletions(-)
>   create mode 100755 tests/generic/721
>   create mode 100644 tests/generic/721.out
>   create mode 100755 tests/generic/722
>   create mode 100644 tests/generic/722.out
> 
> 
> diff --git a/tests/generic/721 b/tests/generic/721
> new file mode 100755
> index 00000000..9198b6b4
> --- /dev/null
> +++ b/tests/generic/721
> @@ -0,0 +1,123 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 721
> +#
> +# Make sure we can store and retrieve timestamps on the extremes of the
> +# date ranges supported by userspace, and the common places where overflows
> +# can happen.
> +#
> +# This differs from generic/402 in that we don't constrain ourselves to the
> +# range that the filesystem claims to support; we attempt various things that
> +# /userspace/ can parse, and then check that the vfs clamps and persists the
> +# values correctly.
> +#
> +# NOTE: Old kernels (pre 5.4) allow filesystems to truncate timestamps silently
> +# when writing timestamps to disk!  This test detects this silent truncation
> +# and fails.  If you see a failure on such a kernel, contact your distributor
> +# for an update.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +# Does our userspace even support large dates?
> +test_bigdates=1
> +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> +
> +# And can we do statx?
> +test_statx=1
> +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> +	test_statx=0
> +
> +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> +
> +touchme() {
> +	local arg="$1"
> +	local name="$2"
> +
> +	echo "$arg" > $SCRATCH_MNT/t_$name
> +	touch -d "$arg" $SCRATCH_MNT/t_$name
> +}
> +
> +report() {
> +	local files=($SCRATCH_MNT/t_*)
> +	for file in "${files[@]}"; do
> +		echo "${file}: $(cat "${file}")"
> +		TZ=UTC stat -c '%y %Y %n' "${file}"
> +		test $test_statx -gt 0 && \
> +			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> +	done
> +}
> +
> +# -2147483648 (S32_MIN, or classic unix min)
> +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> +
> +# 2147483647 (S32_MAX, or classic unix max)
> +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> +
> +# 7956915742, all twos
> +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> +
> +if [ $test_bigdates -gt 0 ]; then
> +	# 16299260424 (u64 nsec counter from s32_min, like xfs does)
> +	touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> +
> +	# 15032385535 (u34 time if you start from s32_min, like ext4 does)
> +	touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> +
> +	# 17179869183 (u34 time if you start from the unix epoch)
> +	touchme 'May 30 01:53:03 UTC 2514' u34_max
> +
> +	# Latest date we can synthesize(?)
> +	touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> +
> +	# Earliest date we can synthesize(?)
> +	touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> +fi
> +
> +# Query timestamps from incore
> +echo before >> $seqres.full
> +report > $tmp.before_remount
> +cat $tmp.before_remount >> $seqres.full
> +
> +_scratch_cycle_mount
> +
> +# Query timestamps from disk
> +echo after >> $seqres.full
> +report > $tmp.after_remount
> +cat $tmp.after_remount >> $seqres.full
> +
> +# Did they match?
> +cmp -s $tmp.before_remount $tmp.after_remount
> +
> +# success, all done
> +echo Silence is golden.
> +status=0
> +exit
> diff --git a/tests/generic/721.out b/tests/generic/721.out
> new file mode 100644
> index 00000000..b2bc6d58
> --- /dev/null
> +++ b/tests/generic/721.out
> @@ -0,0 +1,2 @@
> +QA output created by 721
> +Silence is golden.
> diff --git a/tests/generic/722 b/tests/generic/722
> new file mode 100755
> index 00000000..305c3bd6
> --- /dev/null
> +++ b/tests/generic/722
> @@ -0,0 +1,125 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 722
> +#
> +# Make sure we can store and retrieve timestamps on the extremes of the
> +# date ranges supported by userspace, and the common places where overflows
> +# can happen.  This test also ensures that the timestamps are persisted
> +# correctly after a shutdown.
> +#
> +# This differs from generic/402 in that we don't constrain ourselves to the
> +# range that the filesystem claims to support; we attempt various things that
> +# /userspace/ can parse, and then check that the vfs clamps and persists the
> +# values correctly.
> +#
> +# NOTE: Old kernels (pre 5.4) allow filesystems to truncate timestamps silently
> +# when writing timestamps to disk!  This test detects this silent truncation
> +# and fails.  If you see a failure on such a kernel, contact your distributor
> +# for an update.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_scratch_shutdown
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +# Does our userspace even support large dates?
> +test_bigdates=1
> +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> +
> +# And can we do statx?
> +test_statx=1
> +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> +	test_statx=0
> +
> +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> +
> +touchme() {
> +	local arg="$1"
> +	local name="$2"
> +
> +	echo "$arg" > $SCRATCH_MNT/t_$name
> +	touch -d "$arg" $SCRATCH_MNT/t_$name
> +}
> +
> +report() {
> +	local files=($SCRATCH_MNT/t_*)
> +	for file in "${files[@]}"; do
> +		echo "${file}: $(cat "${file}")"
> +		TZ=UTC stat -c '%y %Y %n' "${file}"
> +		test $test_statx -gt 0 && \
> +			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> +	done
> +}
> +
> +# -2147483648 (S32_MIN, or classic unix min)
> +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> +
> +# 2147483647 (S32_MAX, or classic unix max)
> +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> +
> +# 7956915742, all twos
> +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> +
> +if [ $test_bigdates -gt 0 ]; then
> +	# 16299260424 (u64 nsec counter from s32_min, like xfs does)
> +	touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> +
> +	# 15032385535 (u34 time if you start from s32_min, like ext4 does)
> +	touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> +
> +	# 17179869183 (u34 time if you start from the unix epoch)
> +	touchme 'May 30 01:53:03 UTC 2514' u34_max
> +
> +	# Latest date we can synthesize(?)
> +	touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> +
> +	# Earliest date we can synthesize(?)
> +	touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> +fi
> +
> +# Query timestamps from incore
> +echo before >> $seqres.full
> +report > $tmp.before_crash
> +cat $tmp.before_crash >> $seqres.full
> +
> +_scratch_shutdown -f
> +_scratch_cycle_mount
> +
> +# Query timestamps from disk
> +echo after >> $seqres.full
> +report > $tmp.after_crash
> +cat $tmp.after_crash >> $seqres.full
> +
> +# Did they match?
> +cmp -s $tmp.before_crash $tmp.after_crash
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/722.out b/tests/generic/722.out
> new file mode 100644
> index 00000000..83acd5cf
> --- /dev/null
> +++ b/tests/generic/722.out
> @@ -0,0 +1 @@
> +QA output created by 722
> diff --git a/tests/generic/group b/tests/generic/group
> index 033465f1..21ac0c8f 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -260,7 +260,7 @@
>   255 auto quick prealloc punch
>   256 auto quick punch
>   257 dir auto quick
> -258 auto quick
> +258 auto quick bigtime
>   259 auto quick clone zero
>   260 auto quick trim
>   261 auto quick clone collapse
> @@ -404,7 +404,7 @@
>   399 auto encrypt
>   400 auto quick quota
>   401 auto quick
> -402 auto quick rw
> +402 auto quick rw bigtime
>   403 auto quick attr
>   404 auto quick insert
>   405 auto mkfs thin
> @@ -636,3 +636,5 @@
>   631 auto rw overlay rename
>   632 auto quick mount
>   633 auto quick atime attr cap idmapped io_uring mount perms rw unlink
> +721 auto quick atime bigtime
> +722 auto quick atime bigtime shutdown
> 
