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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F3CC48BD1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E74661364
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFKV5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64840 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFKV5i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:38 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLtanG017724;
        Fri, 11 Jun 2021 21:55:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CC+TQKjy5w6JNYngLLzPgYBkqj6URNOLMB05JukkCHk=;
 b=Whjmw6gdKRT83BkLUWcl6zWbB5uZ4aUnEvO4yzR5lgGXlIN4Qus49B5dcC8DIEqX7mdR
 F6PyyzTiF1U8OpejmrnS/sR1SmkoJCEZNOAJwGcjPVx7Wi15jyj7zqZXtfk66NoLNnla
 9FQ7xOjkc/962dSLLvEys3LqXYYuC7BELqHueFAf/zeZgy9BUUngguqukb1S/Bgpm7q4
 ygtnGBBslwkxRoHjCb/DlHGiY2YftzeAoqEm+tmT3snituu5e9nOgF6rKLUfFEx3WTC7
 9hYc1XYWVFbKqZyQXhA83phiFBUtyCb7KOIgF6E/h5tQlSYjoPU03tbKWhmFF1tij+nn sA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3944a1g7fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:36 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLtZfm108460;
        Fri, 11 Jun 2021 21:55:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3922x3nvm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFXqvfuVNWQCYnPgbywTg5Rfzu3HZKCa+J03JFf2HUXhig4BSjnXZrNy5TL5hkPSPbmUYDjCs/T+ExDv7hyd5h7QFR9Vo5wsgD/UnvJqqQu60u81dkvy1TVZ8scefxSYTpVxIaSJAZaEX84YtUfF3akW1J0vHBTpqs7rPKAXLAZqIF25UCnZ0XxChknzXoXwHVSaUQvQVpjUdyVbbPt2OzU0OZuoymmYmH5HzDHQ0JFws+IERBjmfcrU6xkNaH/JfbspxOiPrXr17DtUtKNg394gV31lMchexcLe27J7L5bOVKu0usMokcnyhG60NQWrzL6sSJBOkfu+fe/cQtS2nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CC+TQKjy5w6JNYngLLzPgYBkqj6URNOLMB05JukkCHk=;
 b=HmMWWn2jqL7Wl/u0GYtynyIwHDaW3RHya03W89ueEyy2ZIfRlBsXqk6B1uWoCw9cFhrdSxNOmsOERBZpk4ZJMp0XCr6+qAp4Ddmf95DNYgGAfmLmENWi0F2o+Ykc0iDH9myI+QGzVBKXiAZrLVbgy4pq6oHYN2/reVgUWr7tPxZOg7b3u9AicScaLV7kFvvQpNgP/jIG4t/g7DmMcQMMxXH9wL9+X63z1Z0YJ0Qzi8ZfO4Y82WJYcSTNm0zUxvmsgwwJeYoJLExaVkCvKMX6LTW+wzbP9HyccKaFT9xShxOzy2ujpYCaVcYJh0UBp5+WWNFOJ4uzQa/pzrxHBm8o5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CC+TQKjy5w6JNYngLLzPgYBkqj6URNOLMB05JukkCHk=;
 b=cXQELx1Bf5xKaO32vVzySUOv2EIoo9s60U6aayhgfmqTWM4RKhv9J/RCwddln1cITkgAtqszlOnBbe/FjpGUYgOoh8c88GloYr9oKbaBq3B/EkCmeFHxxRpv5+k/5nNK7njUrZnqcZQP1DvJzTJC/qxeO6GTwRm1ynU7wuZbs3w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3955.namprd10.prod.outlook.com (2603:10b6:a03:1f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 21:55:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:55:33 +0000
Subject: Re: [PATCH 05/13] fstests: move test group info to test files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317278957.653489.1221763643277904130.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9a1705d7-be39-c20d-106d-caf510999515@oracle.com>
Date:   Fri, 11 Jun 2021 14:55:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317278957.653489.1221763643277904130.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0031.namprd03.prod.outlook.com (2603:10b6:a02:a8::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 21:55:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e7286c9-57ea-4365-7714-08d92d23a2f8
X-MS-TrafficTypeDiagnostic: BY5PR10MB3955:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39555119C422A7D59EC9994A95349@BY5PR10MB3955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 394MDmBipXJ3Sp1P4x5b3D8VBLPnBFqwvo4W7TdtbjYpozxhrhk0qVqT/FQyQY42DpM1m6G5hhe/f8C1HSXEqK5HxrVnNqdKd8hjkz1L4uDIJ0bUBERNSfJtPMdTVl8scKN7rUaballhhSLcTN4sFuQyJoarpH2Ptpc1241lXF8T59kR4yPig4YP1ae4YyNnwzQ5Ryv2VKXlRkprm7ZriWnGEXnTRc1CCix/VTM/cjn2WZRl3ewPJaIv6OCmwjm3ZrRgIDuVbm503f1GePTr5aLD/QDbvkhXFWrDbsa046t1SMqGvp4Mk/2AqWUlSIT1kiku1e4fl0vlP+dbYHzjXLZefp9u5QgvbzKPj/pHl3gJv9k3W8GTwm1QB7doN2YXQOvGPQKQ6jFDeps2PvKY90KHm3683Xrm1Ad4bAW9eiYV1r7IvdeQR8acCVG3p2WutBk9d5SQOcMSiBOgonuVr4OFGYWh7B4SQfgj5yzcfzZkLee3jz+DtKGbyQHeZALIiv67t7E//NQ2do+kLdYFmVzQK42g/jXA4J9kFX6iyTbDoW85YmWqOlOEsR+HooODprNvuSXnJ2sipafBA7qHzSUAh75AMvkW7oAUyvzoFDTOkWt5JTSdYC5bU+CZMjCg03wiJcOEy+vadHAGEzdrf/TrqtICd8vSwBIGVmsFNZJQwxe0lj2WHotiO5lGWJM2HAauQJTCr8lyqgV7efQoaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39860400002)(366004)(396003)(44832011)(31686004)(478600001)(8936002)(4326008)(6486002)(66556008)(66476007)(5660300002)(86362001)(38100700002)(38350700002)(2616005)(956004)(16526019)(8676002)(53546011)(316002)(52116002)(31696002)(83380400001)(186003)(36756003)(16576012)(26005)(66946007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S08vQXd6b3M0aS9vMjhxOEFrMkEwSHh0a3BQRUVoSGtJRjg0aHpGSC9xdkJx?=
 =?utf-8?B?cWRFdHFrY0VtSHN6bmx5U0ZHY3J5SVVHbGdyQXB6aDJock1YWTRnbE14emxu?=
 =?utf-8?B?NVRybE1NYWQ2Yk9ueFU2eHE3ZVo2ZXhha21BeEdmVllQUzdRSHlhbXFPbFVM?=
 =?utf-8?B?QWtqTGZGVzJYNGFSLzlKa1hOMWNCWEt3ZFd1VHNFUDNZVTc1SUxvQTk1blNQ?=
 =?utf-8?B?MzYrVmwvQXJJNGljMjJLcjBMVGY1U3krWGF5aDcrTHZoVXBHVDUyRTAwOVV0?=
 =?utf-8?B?cEpONVpSa2xtdVM4NW1yN2FranlmVTRRNHMyaGhuMXpCWjVCNkhOSE9Ca2FJ?=
 =?utf-8?B?SlE1SzVrS3M0UHZlTWNTcElianFjQkxkaEoyY29KZ05ZNVo0L3hCYnZPcUw3?=
 =?utf-8?B?ODR5WUxocE0vKzlLTDdZa0NpZGgxVTg1ejVsMFB5SWN3ZEVCNVgvOVdsYmRm?=
 =?utf-8?B?R2RFY0ZSOXlsc3dzZTRpYVJ2djFGUlJwN28vK016N3JoWi9MQy9VY04yTWJh?=
 =?utf-8?B?Uy85aUM5NHFieXhCTGJnMkJOYXl2Wm5UUFhqZVJxODZ2dThML0c2NTdhQnNq?=
 =?utf-8?B?OU9mSHdrVERxbW9raUg4alE1bXI4aGZNdmhTL08weGlCRCs5eWhJYmZWcnVM?=
 =?utf-8?B?YklmT2Z6VkNQalBtN1pQejdZcDYvVUhlWG9DVFNUdHd4ZEtSYSs0blRRRnFz?=
 =?utf-8?B?MWtNNHhNMkxwRENrY25hVEV4TWlPb0hGZXRSNkt4OUJFZ1pCR0IwUWVoNVlo?=
 =?utf-8?B?TWd2RHpjTyswY3NxRXF4OEFuWWVsWms2TTErRjlISGc1VjhSSEVUaTlKQWpj?=
 =?utf-8?B?MlRtSE9QUlVYOFlJTU0zWFR0bk8wN3RSdkxOTVMwdDdBYis4RGxPV0wyc2hh?=
 =?utf-8?B?dnpPOGcraGFTV2h5aGU3NUNieWhyR3B0NWVlS1JmRzJyTFhodGVpbzNtaVcv?=
 =?utf-8?B?QWFxa0JsRDF1YzRIVGFuQldTS25jeFNhTTFiTktTei9PVVlCTzlrOFVUU2ZH?=
 =?utf-8?B?a0MraTZGQ29WTGZBcXdDNlU2RzhiQXJISDRXV1ZncmRVMjFVUFBOQVZkSTYr?=
 =?utf-8?B?QlU5SG50elJ3UjRmOXpneU9md3ZrYTc5Q21lb2ZaV1BoVm1GemVYcGJSU041?=
 =?utf-8?B?c1pxd2ExWmhSQXMvcDFRcU1aaGs4LzdIMFhkVXVGQmZLS09NNGwybHJjT0Jm?=
 =?utf-8?B?Tzg1WFNYU1ZyNWlPMmpXM084WmhKOW1VVjZkMVl1bHBhaDh0VUZHTjhFNjFX?=
 =?utf-8?B?b0RJNVo2TGdTVmZNSHNpZFIvQXdzMXBoU3g0NWZ3OFU2VkZ1UWtNR3NHcHlT?=
 =?utf-8?B?Q0tDSm9JZCt2ekdZVmc1MHJKZ3FNRDV5MHJ3QWdCVm5IcWhUd1ArbnNXKzIw?=
 =?utf-8?B?YlRKWG8zZ01TU2tEb3ZoejVnRmFRV2VHcUpoQmNOenNNZnhTY3RMUWNaVnVx?=
 =?utf-8?B?WVQ3bEJnY2NnVjZSQ21qemNVdFY1bXU4YnJqbVo5UVg1cmFTVUNrS3R4L2tl?=
 =?utf-8?B?eVRwc01NVHJEZldJREdZNG9SWEpSNnNteC9xMElMemhPVHJFL2NzK3F2MkMx?=
 =?utf-8?B?QUg3RHRjWGh4dDNIb0ZQaDhCYndNaVVxWEJybXhhUEQvR2c1SEV3YWdnQ3hn?=
 =?utf-8?B?SHIxOVlDZG9yNmswQUxSaEtnRVhiclYvRm96QWJBTktOYStxUGV6OXNaZklE?=
 =?utf-8?B?cWNyTzlucTFRWmUyVEVEajlObVhCK1lSS283Y1FBVURuOW5KSWxUcVcveDZu?=
 =?utf-8?Q?NLmKNp10n8qBRAxxouNuC94+vWNXWsXQEWg+WQ+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7286c9-57ea-4365-7714-08d92d23a2f8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:55:33.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgXFnOAk8eRyscxD+6pj9Btc/JpSc8m+MGb+2MNbEjHDM8RHKk7FM1Lddnf+Dc4qOhDV+nL+4qWZ7emaKC27/UBnVYdyuDANSCHck6qFTw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3955
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110137
X-Proofpoint-ORIG-GUID: glZuqAiaRaIIh2luDYiL-CRBnFNLifmE
X-Proofpoint-GUID: glZuqAiaRaIIh2luDYiL-CRBnFNLifmE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:19 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor every test in the entire test suite to use the new boilerplate
> functions.  This also migrates all the test group information into the
> test files.  This patch has been autogenerated via the command:
> 
> ./tools/convert-group btrfs ceph cifs ext4 f2fs generic nfs ocfs2 overlay perf shared udf xfs
> 
> NOTE: This patch submission only contains diffs of the first seven btrfs
> tests because vger rejects 1.5MB patches.  The full conversion is in the
> git branch linked from the cover letter.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok... I guess I rvb the command?  Since this patch by itself cant really 
be applied.  The tool output look pretty consistent to me though.
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/btrfs/001 |   15 ++++-----------
>   tests/btrfs/002 |   15 ++++-----------
>   tests/btrfs/003 |   15 ++++-----------
>   tests/btrfs/004 |   15 ++++-----------
>   tests/btrfs/005 |   16 ++++------------
>   tests/btrfs/006 |   16 ++++------------
>   6 files changed, 24 insertions(+), 68 deletions(-)
> 
> 
> diff --git a/tests/btrfs/001 b/tests/btrfs/001
> index fb051e8a..5d5849f0 100755
> --- a/tests/btrfs/001
> +++ b/tests/btrfs/001
> @@ -6,23 +6,16 @@
>   #
>   # Test btrfs's subvolume and snapshot support
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
> +. ./common/preamble
> +_begin_fstest auto quick subvol snapshot
>   
> +# Override the default cleanup function.
>   _cleanup()
>   {
>       rm -f $tmp.*
>   }
>   
> -trap "_cleanup ; exit \$status" 0 1 2 3 15
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter
>   . ./common/filter.btrfs
>   
> diff --git a/tests/btrfs/002 b/tests/btrfs/002
> index 66775562..96332271 100755
> --- a/tests/btrfs/002
> +++ b/tests/btrfs/002
> @@ -6,23 +6,16 @@
>   #
>   # Extented btrfs snapshot test cases
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
> +. ./common/preamble
> +_begin_fstest auto snapshot
>   
> +# Override the default cleanup function.
>   _cleanup()
>   {
>       rm -f $tmp.*
>   }
>   
> -trap "_cleanup ; exit \$status" 0 1 2 3 15
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter
>   
>   _supported_fs btrfs
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index fbb313fb..d241ec6e 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -6,16 +6,11 @@
>   #
>   # btrfs vol tests
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> +. ./common/preamble
> +_begin_fstest auto replace volume balance
>   
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
>   dev_removed=0
>   removed_dev_htl=""
> -trap "_cleanup; exit \$status" 0 1 2 3 15
>   
>   # Check if all scratch dev pools are deletable
>   deletable_scratch_dev_pool()
> @@ -32,6 +27,7 @@ deletable_scratch_dev_pool()
>   	return 0
>   }
>   
> +# Override the default cleanup function.
>   _cleanup()
>   {
>       cd /
> @@ -42,8 +38,7 @@ _cleanup()
>       fi
>   }
>   
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter
>   
>   _supported_fs btrfs
> @@ -51,8 +46,6 @@ _require_scratch
>   _require_scratch_dev_pool 4
>   _require_command "$WIPEFS_PROG" wipefs
>   
> -rm -f $seqres.full
> -
>   # Test cases related to raid in btrfs
>   _test_raid0()
>   {
> diff --git a/tests/btrfs/004 b/tests/btrfs/004
> index 0458d2b6..4e767a2f 100755
> --- a/tests/btrfs/004
> +++ b/tests/btrfs/004
> @@ -9,25 +9,20 @@
>   # run filefrag to get the extent mapping and follow the backrefs.
>   # We check to end up back at the original file with the correct offset.
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> +. ./common/preamble
> +_begin_fstest auto rw metadata
>   
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1
>   noise_pid=0
>   
> +# Override the default cleanup function.
>   _cleanup()
>   {
>   	rm $tmp.running
>   	wait
>   	rm -f $tmp.*
>   }
> -trap "_cleanup; exit \$status" 0 1 2 3 15
>   
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter
>   
>   # real QA test starts here
> @@ -38,8 +33,6 @@ _require_btrfs_command inspect-internal logical-resolve
>   _require_btrfs_command inspect-internal inode-resolve
>   _require_command "$FILEFRAG_PROG" filefrag
>   
> -rm -f $seqres.full
> -
>   FILEFRAG_FILTER='
>   	if (/blocks? of (\d+) bytes/) {
>   		$blocksize = $1;
> diff --git a/tests/btrfs/005 b/tests/btrfs/005
> index ff20a638..ac9e8bfa 100755
> --- a/tests/btrfs/005
> +++ b/tests/btrfs/005
> @@ -6,17 +6,12 @@
>   #
>   # Btrfs Online defragmentation tests
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -here="`pwd`"
> -tmp=/tmp/$$
> +. ./common/preamble
> +_begin_fstest auto defrag
>   cnt=119
>   filesize=48000
>   
> -status=1	# failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> -
> +# Override the default cleanup function.
>   _cleanup()
>   {
>       cd /
> @@ -111,8 +106,7 @@ _rundefrag()
>   	_check_scratch_fs
>   }
>   
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter
>   . ./common/defrag
>   
> @@ -120,8 +114,6 @@ _rundefrag()
>   _supported_fs btrfs
>   _require_scratch
>   
> -rm -f $seqres.full
> -
>   _scratch_mkfs >/dev/null 2>&1
>   _scratch_mount
>   _require_defrag
> diff --git a/tests/btrfs/006 b/tests/btrfs/006
> index 67f1fcd8..c0f9541a 100755
> --- a/tests/btrfs/006
> +++ b/tests/btrfs/006
> @@ -7,23 +7,17 @@
>   # run basic btrfs information commands in various ways
>   # sanity tests: filesystem show, label, sync, and device stats
>   #
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "== QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 15
> +. ./common/preamble
> +_begin_fstest auto quick volume
>   
> +# Override the default cleanup function.
>   _cleanup()
>   {
>       cd /
>       rm -f $tmp.*
>   }
>   
> -# get standard environment, filters and checks
> -. ./common/rc
> +# Import common functions.
>   . ./common/filter.btrfs
>   
>   # real QA test starts here
> @@ -33,8 +27,6 @@ _supported_fs btrfs
>   _require_scratch
>   _require_scratch_dev_pool
>   
> -rm -f $seqres.full
> -
>   FIRST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>   LAST_POOL_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $NF}'`
>   TOTAL_DEVS=`echo $SCRATCH_DEV_POOL | wc -w`
> 
