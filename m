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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922CEC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4609E64FD3
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhCJWlW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:41:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCJWlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 17:41:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMYHYV171465;
        Wed, 10 Mar 2021 22:41:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=30z2Rzs5xgVTTTOzPoyJ+72cMPexMVvrGOHvwbVYjgE=;
 b=H8OAL6F7p/9r35+0h1I8FXuRvwiIBW4rPKlRhnt7CDXNiaJ1iN1skusOmze4Hz5vBpCk
 O7esC6i8chBhorh114Fb6PlH7SUgSZHty6mP8PW3ir1P/ugkA68utJNnvjJJJR5zREyY
 tIGvj1Qe9XeyepBq/ERFkja0aWWhEy5oBoSUmuX/tdx3vvazV3RYh+jYNKC6UOZzf43D
 5wgb6RDu855hi8t4zb7PsMKKbwTH4qiDTOIr3YlBFf2agMJLaDdLnJU41ZekaB2RPqfW
 5vJBfuPjZvdxU4+1NHkYtKHdERiya9RsiLhgQokwBC4PcxIEVRF7HLfVaBI8WHRCuksS cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37415rcqpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMZTF1157556;
        Wed, 10 Mar 2021 22:41:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 374kaqv1jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KF386Pgsj1R6dc/02oMonsvFkB5cjDDEEJxnPI3gRDxgdlVpGhxei5H0cJALvpxFNkwIFV99o+p823fd/SwAOAmp/H7FjjMWJ97Gzs48B2zzE8ZQ6Nt6GH/XbCrv6nfeXRB0ZYehOGEd3HpOI0Hm4cH4DuVlN/GzXll61CYdepNy/GYlx+Fx53+0WHAY2r0eAyevYGCdRHvA2zPNrHQmodNAzGh/ck7aHjsGbQ07K1kJSyFasPk3PDB2Kv9hE4zRuyk7aN60usRr3FLmVs+Vha4Sef+kN86h+nWacjnYEmgMUjDmWbTE1W9uZhWSR1PMVRjTG7wB8kXtH01FMBHkbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30z2Rzs5xgVTTTOzPoyJ+72cMPexMVvrGOHvwbVYjgE=;
 b=LoheRbLe5anqwxXgTnh52tqJ/6nLtXzXR7ByulCn/iVfYwB9JK7FRxg9JYLsze58MI39D5ShC05pYnLu/HBrhitDxPX5VbRnGiJViYG3DDrovUI91QaHxDUi11SWCEkmbDrIKDROR3325CY6vJ1Q2d85RWHVVd+e/EraCaBwhhR+nFI3V2ztCGq5hDXzFBCskO40VDQpYyuRNLNqoclcCyN+DdSPdb0lqfqggcQ9JD9CtQ7KDExPRrMIX48homVcWxdT9DVDrdM3Ai5hNeMV6wvjGWm7/8b8FvnTlsOkD32RcUmFNmLM9zh98joAd3AN5NMUhA4pcGtJVUeAoE3CWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30z2Rzs5xgVTTTOzPoyJ+72cMPexMVvrGOHvwbVYjgE=;
 b=yeXgk8nIm1Uc4kCNre2sL9veUATffzhHgj1qvqko5VNC289qGACwlTFOJ6nEC/oVVCpMeQpgjS/46nYKLMV/q4rhgU3AGbyu0K8LtOMw7jV0J4/6Qf3nHCFv+5UgqAtRzzmODlOCr0v8FXjFTtKfUOj1vsHCCP12MC0rCf90wiw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 10 Mar
 2021 22:41:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 22:41:05 +0000
Subject: Re: [PATCH V6 08/13] xfs: Check for extent overflow when
 adding/removing dir entries
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-9-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <98924e2b-487a-638d-cea9-40b04df34f08@oracle.com>
Date:   Wed, 10 Mar 2021 15:41:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-9-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:a03:117::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR08CA0056.namprd08.prod.outlook.com (2603:10b6:a03:117::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 22:41:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 914a2a2b-d9e3-46e2-75d4-08d8e41596ec
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3780743A1842D93F268EAF1C95919@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vT65cHa3MvKkuMtRhYrzxftREjtTW6F4i4IM6MzFK/YYRMmNJXXq6ldAN7jIu1xQIZZPJOB3Ea72VN2Wtd6jyn6qZDOeRb8+AqHCRF8aZN8qhQmdg07uuFJD5vasSUCJ/sENgdLK+BA47SCgRSQDsxoxagoiBvAN3Tx3TeLvPWS3cqNCLz4oZRvmOMYFJn8tc/KvEhf2CZA+/vLG9+VaLnWjie04pglmy9XHoh71hZ1Te6sbBsMmQ3np6HFIhkfVzJhz3rZD/sH91slALIwZkc7PY8DJxqsMc+conw1KjHCROn1Jss25nWIiqNiOtdyO/WcCUAv9aqeNcKWz2OOVwLBXTbuXprd8vzLwdF3nZKVL4vtPfv7dL5ocLIbljt2p+hk4UC3GxXH9L2LKo8gf59tlqCppA/b+NU1tbcmv7k/A+Oin27kVBV1LfThnvMozZD5p9ShpmcuT8olo2xfT5JJETepSYOOpKuZ+LDF5sJIe7QQ4cS6lk4LOGoz5bCMDlddYydEszBRggcuLvWxxIAxMdscTSprL86zdPGyNY7Ynw0QnrxCKhPGn+PQ8/koeRZFKSjStpm6gIEX4/9zGj2W7JeJbG09MI77yU0MYQzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(83380400001)(8936002)(316002)(53546011)(956004)(5660300002)(44832011)(478600001)(36756003)(2906002)(31696002)(86362001)(52116002)(8676002)(31686004)(2616005)(186003)(26005)(6486002)(16526019)(16576012)(66556008)(66946007)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dG1EUnI0K3BZdHUySEJUZEVrQmtaZTNiSi93UUkyVEdGVU5TUTdBWlNhcytD?=
 =?utf-8?B?SjF6SmNxa3JHTlFtVy8xZTNQTFhwRzdBQ0dDVTNlZ2JCRmI1TUEweUw1RWZp?=
 =?utf-8?B?K1hQQjlvMUdvK0VoRnVQN2hsdm0vQnpPeHN5NFREbWZuTXNibm5uMHdGZEJF?=
 =?utf-8?B?d2xQTUVPOEg1WFBnNUxqZ3JYK200cXBFMGlaZ3VBSGxkdGVTZXRkNUVkb2Va?=
 =?utf-8?B?Smx5RVJtbHdpcDkwdHBNN0k4cjh0YmQ1VmU0S2ZENUlJMU9Ga2lKcU9YV2dR?=
 =?utf-8?B?bU9FZUdGWEZybEVzSnVPb1N2Nk41SkVMOGh1eEhoLzVQbmZUK1h5YzZaMm1a?=
 =?utf-8?B?eGRTSWJIUXFoY0Q5WVFPM2FCS21aUUE0SmFaeTNqbHVmMHZjSDNWRlBsd0tN?=
 =?utf-8?B?NEpVdnFyejd6VGJkLyt1WjlUUExMUW1ZdXJKMmEwRFBuYmM2RTMxL05aZDVQ?=
 =?utf-8?B?TzZ1SGpZZ2pYR0hEOTNGYUYyUHVLbk9Qdi8yQzJFOElIbVpxdDFMaEZoQ0hk?=
 =?utf-8?B?NHpsenplZzRGOHVnbzFUNzFnVGNhMnBPTmNOSkpXUDE3Qmhra1JaUW1ROVVw?=
 =?utf-8?B?cGFJNmhMMXBUd3FOZHdJQ0Nkb0VqOHhsTStrb0lXeEk2aWljY0N3VGUwV2tT?=
 =?utf-8?B?ZFVEd0s1OXRObjVTVFl1QVMrZ2JRZTlhd2VqUzFKQUx5Y0Q4Uk4xODRzS2wv?=
 =?utf-8?B?WVQ0UEthVnNPOFlIZCttQXByVjAzM3ZMeU1GbnVGbFRrVmpYOElvOTZGbTlO?=
 =?utf-8?B?WklMcTV0M2wvZmFkcCtZSVJYWWpKU1FtN2w0dWtGSklIajB6QXZ3VjUvc1hE?=
 =?utf-8?B?dG5JSnN3NVV2UFk3NG9hdlY1aUtmWnZFOE52UlJtU0RSWi9uc1VjeThmdFNS?=
 =?utf-8?B?UUI4OHlTTEZSb0E3b0JkMzBTNFRlOG9tTzc5ZW9vWlRMbkF1bElXL2l0T2tK?=
 =?utf-8?B?V3V0RGxQMzhtcUNGZitSSjFxK0lndCtyQWZkTkhTeUU3d05SODUzYWN6ZUZO?=
 =?utf-8?B?ejdGTlh2anBQTGtoRHdjR25tMnM5amZ0NTV1QmowOW9sbmcvbFlvVmhrQzkz?=
 =?utf-8?B?VlFQT05qR21KZUV6YlBjVG1yVmdoOFI0OC95MHF1aFk4WCtIVkQybThvWEtt?=
 =?utf-8?B?ellzSGVYODZWQ0MrSTU4V1V6S1ROd29iTU9ldjkxTENFbVBKU3hUT3lYS3pt?=
 =?utf-8?B?YnFTMk1PSkJiWi9HR1pjZ0Vyd2tuZS94L0dLcG1TVDhRMjFaWUx2VzNOK0Vh?=
 =?utf-8?B?cURBbDF1TFp0QkdZUitNTTlFZGhhRUtDVUt5REQvdktxcEl0MmlJb3lzdzRt?=
 =?utf-8?B?OFBDZm5ZSzJ0OHdEdkNxR21QYUROS1d6M1JFYU95WnhPdHNjYWxkeVBUdEZh?=
 =?utf-8?B?WmpzeUM4MFdzSkx4VnpvOGR6ZHF1bEpacm9BNXlHalUvajNPZXdaVXpBYUFF?=
 =?utf-8?B?dFFiSVBjRTVvRHRsQVB5ZktqRXJQeHk5T0FLdGhGbkpIaUNBVUlMdU40bnFU?=
 =?utf-8?B?VUhHM05IOG5wYUxFTU5jUnQ4UWdwT2VpMkNXdGJtWTlWajJnd2ZOUG5oWUZq?=
 =?utf-8?B?NkdWa05ubFkzVi96NUhldm40VEU0S3JVeUQ4dG9VOE5OK0JPSGtjUFFTR2Vy?=
 =?utf-8?B?QjJIbnFlZXJqcjdNaFpBc1NueHZ4M2h5ODJ6OFZJRjAzNzQxM0paSm1OVTht?=
 =?utf-8?B?VG5zd09IUVJvMWVuaTg3WklQOC96bmRuVXBHZTIvclU1RzJ5MFhPMXlob1V2?=
 =?utf-8?Q?rPFJ9ZW2gTZbAZVq7R9WdPqcHASg1HJaAEKeP7F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914a2a2b-d9e3-46e2-75d4-08d8e41596ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 22:41:05.1884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtZBDOCbwsVTdQzE8p7pjV3xSyjlVQcFVFNChuWFU2QtGVXkNZtyH/m8nNL4xz4qZcZJvBb+Js4xpMbBBapnp09W6+blGWFkGz5mmXuHHGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100109
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding/removing directory entries.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/532     | 182 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/532.out |  17 +++++
>   tests/xfs/group   |   1 +
>   3 files changed, 200 insertions(+)
>   create mode 100755 tests/xfs/532
>   create mode 100644 tests/xfs/532.out
> 
> diff --git a/tests/xfs/532 b/tests/xfs/532
> new file mode 100755
> index 00000000..b241ddeb
> --- /dev/null
> +++ b/tests/xfs/532
> @@ -0,0 +1,182 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 532
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding/removing directory entries.
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +. ./common/filter
> +. ./common/inject
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +# Filesystems with directory block size greater than one FSB will not be tested,
> +# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
> +# count) = 14" is greater than the pseudo max extent count limit of 10.
> +# Extending the pseudo max limit won't help either.  Consider the case where 1
> +# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
> +# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
> +if (( $dirbsize > $dbsize )); then
> +	_notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
> +fi
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +dent_len=255
> +
> +echo "* Create directory entries"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +nr_dents=$((dbsize * 20 / dent_len))
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
> +done
> +
> +echo "Verify directory's extent count"
> +nextents=$(_xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +echo "* Rename: Populate destination directory"
> +
> +dstdir=$SCRATCH_MNT/dstdir
> +mkdir $dstdir
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Populate \$dstdir by moving new directory entries"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	dentry=${SCRATCH_MNT}/${dentry}
> +	touch $dentry || break
> +	mv $dentry $dstdir >> $seqres.full 2>&1 || break
> +done
> +
> +rm $dentry
> +
> +echo "Verify \$dstdir's extent count"
> +
> +nextents=$(_xfs_get_fsxattr nextents $dstdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $dstdir
> +
> +echo "* Create multiple hard links to a single file"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Create multiple hardlinks"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	ln $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break
> +done
> +
> +rm $testfile
> +
> +echo "Verify directory's extent count"
> +nextents=$(_xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +echo "* Create multiple symbolic links to a single file"
> +
> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +nr_dents=$((dirbsize * 20 / dent_len))
> +
> +echo "Create multiple symbolic links"
> +for i in $(seq 1 $nr_dents); do
> +	dentry="$(printf "%0255d" $i)"
> +	ln -s $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break;
> +done
> +
> +rm $testfile
> +
> +echo "Verify directory's extent count"
> +nextents=$(_xfs_get_fsxattr nextents $testdir)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm -rf $testdir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/532.out b/tests/xfs/532.out
> new file mode 100644
> index 00000000..2766c211
> --- /dev/null
> +++ b/tests/xfs/532.out
> @@ -0,0 +1,17 @@
> +QA output created by 532
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +* Create directory entries
> +Verify directory's extent count
> +* Rename: Populate destination directory
> +Populate $dstdir by moving new directory entries
> +Verify $dstdir's extent count
> +* Create multiple hard links to a single file
> +Create multiple hardlinks
> +Verify directory's extent count
> +* Create multiple symbolic links to a single file
> +Create multiple symbolic links
> +Verify directory's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 7e284841..77abeefa 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -529,3 +529,4 @@
>   529 auto quick realtime growfs
>   530 auto quick punch zero insert collapse
>   531 auto quick attr
> +532 auto quick dir hardlink symlink
> 
