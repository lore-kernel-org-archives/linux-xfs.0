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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C18C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1996064FCA
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhCJT4A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:56:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39992 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhCJTz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 14:55:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJnXjS112184;
        Wed, 10 Mar 2021 19:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Sbfj1FSjzmYIDtULm1Lensk2s99E1cZOxtG9Z3c5pSU=;
 b=cJ6Rtvln+TZ7kgqZ48CZzpr0YIPcLRP3k36q5TowNMF4qcNEHrRh7vBXMwJGHQ9rk/Ze
 aIBMPYImQoqbt12rKIUzzMqh1QT6WIBhdMVKDtmnOuH+eAYUiA+AG1mHZkUORoFI9kOd
 RmPOqGj1SHkL2tlFUkkLahqBJXLltkBeVPjeAB+24z5HcG5i97lkrZFgJqCrTv884XPd
 mOCJxfu1lDULUiGn8PVfl7NLLXk/kSZl3WvInvBIfMNIBs3w4dvnoN4QWP3nH3bzIjzo
 OqnzfHlJ971/hRWUYWa+dd1cV2hp8+Ff98zNcJ4/S0kSmo2cCb6iOSP4RIewYrG108Cv Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 373y8bvemy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJpUkp109330;
        Wed, 10 Mar 2021 19:55:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 374knyvgev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEjjbEn3cqCHHAVYqSUFy28RZ+r6wEnbNYPo17TOHkmb481pt6ucspK7//bVVAIwsYzCKK4/pwddScSFL8e32Rw05rvnrSsyv6uhg/q+BqALdxP1ZLWU4y85JD4k/r6pWuZ//pHwkLldskGTlg9MgYWh6puvjA2DGVBqJRaTejs4YrmQbWuFmWCgi8a9TGSE6v5iZPNRFqZgzYuslFIuu423xHm9/Q3LC1KNAIDX1CQy6/4Z6q38/XHegM8U4NRBedD8BxjjszWANWY88wz+K4alvKnjLWren7Gt3TXUZY21JKkXBCdj8uPCtILbAuac5twNM5vz7to1Q54Qn6RtUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sbfj1FSjzmYIDtULm1Lensk2s99E1cZOxtG9Z3c5pSU=;
 b=hYML+qQByvbuvnjE8UWMVTUXA3M9Rl5FgI1zLFBfbF+ZeaG+ufcAyJgOy2rmHBjkKVhnBYldnY2/T3McAMQ38Y2ZSnBgr9/rAmj35H0cFmgg5Gqvp9oLtqitof0EBZXlhN7tfgreyed2RhE4amw2e9Ko++BmBu6VY8BkMcKCpLtkZEr4HMudhfSyIs7ekxpxh1pqmgwtUyNpINIUNCeKipabQGiTC3jqu65BtUcebt0QCSjea5x0DnF8zpVRVg2OHXSanuqoPL5U0ReYtTgjUfT6DBWZFdqkiZLxCbX6Zy2B1sagA4ebZ1WPdyM0XtlApFILa5P/FdbiSi1hV6Uyvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sbfj1FSjzmYIDtULm1Lensk2s99E1cZOxtG9Z3c5pSU=;
 b=w3bepB4xJdueuN7qvWaP49SmQtmFdk3avUvySub0igaskvH7aYx+QKieJ50DXFUD2uuEHbAUHlc2VUC55iZCie92O55bUgrlb+ldmHAZS/41GX/QhxAH3a/5bWKkq2U9wyc8l2xzaC+ksYz6+82VRKgELsJNdIJeyoTnwAv9Jlw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 19:55:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 19:55:23 +0000
Subject: Re: [PATCH V6 06/13] xfs: Check for extent overflow when punching a
 hole
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-7-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <aa57c3b6-4cb1-9134-181e-cd26bc65edee@oracle.com>
Date:   Wed, 10 Mar 2021 12:55:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-7-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0308.namprd03.prod.outlook.com (2603:10b6:a03:39d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:55:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7741ea9-1b2a-4497-773a-08d8e3fe7128
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3509F1091C1D28FEA1CFC2E295919@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBnkeXQc+uQGyrtZ4dS3tIdghPY9SmBV0snProvqdRJ9dZRWsLPSD5Zd78geWhegjYTFt7ZXIdCGwz8dYFU1Q3PzWW6A5OXE5V/m8NBYnPU4J+72vshahhh/7/Wif1Fqud9SyZG0pVYzL2DNIZy+J+yX0yuReRfHN6W4tQGoTNaSdpuaJuK2IuuXNjWcHiHNCZ+YcaUNRjgWjL0Curmk5kn0ZTt00ryeokzsb8GyUbg2eUwEfSzuQWBY5vmBWytum238WmM44jxNa5rsm0t4SV5oU8kDA5KjSuuXoQQKuSe80oxVE4GxEu0qBzHlLJQMPjGnedaU/Eh7Y2B33HXgLv0wqEYWHchfLUp2CurI4PD7iY4fyWLkZpctArueyMN5lq6RqN0d8sRFHJ0lQ57I9wIMPMLB/uQLf05D7MQpeIqH7NO3BJc3fCIhEffOZvBHovstwcD87rqRT50x72Qh55Eu+hs5P2fcP8o8DdsMeV+kzXxCiLt6lUHkpHqVJEHEVdQtX6QqxFQysz3hxjezhm99J0+oyEyOQJaOgYk09DYwTxba/JGmEuHHpQoMq2kESkYfOUjfCSyW43iTGbjdrPAkoJ6wIm6HJlrbwk1X81s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(31686004)(4326008)(16576012)(316002)(44832011)(186003)(86362001)(31696002)(2906002)(36756003)(5660300002)(2616005)(956004)(26005)(478600001)(53546011)(83380400001)(66476007)(66946007)(66556008)(16526019)(52116002)(8676002)(6486002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkpOOFpDdHZqOVloMkJ4d2RreG1nWmozcEUvWWl3MTd3QXd2SEh4Mk1VV3d2?=
 =?utf-8?B?WHk2NHI0Ym9vZk42SUVGdzVWM1NTcFNMMW5mVGdkQXh5TWROR1ZKbGdjOEFt?=
 =?utf-8?B?bUs1Y3I2d2toTzRndlhic1I2TGlVbVdhNUVWSzdnd1ZRWTRCYmFmVUVZbnpG?=
 =?utf-8?B?WGZoSkFSYldBdkpjSThOcW4xUDJSeVh2dUZ6SjFpYjJ2TnppQjZNZGlSMHRp?=
 =?utf-8?B?eERqNUgyMnlJS1o2R0t3dDlvYjh5NzNpUy9sK1puYW5TQysyenhlSVZBM2Ni?=
 =?utf-8?B?M3hjZnhCY3pNbUtzMmZzVkxBZVF6cVZqWXRzQ0c5d2cwTGJ3ZWZBS3U5Rk9o?=
 =?utf-8?B?LzdJTFZZa2tJcDFGWTMzTE5HVldnZWxJbDE2bzdIam41dmM4YVF5ZmU5emcv?=
 =?utf-8?B?TzdRSVk0ZkJub085RTJVZExvYkVtUmtqUGZXWS9HRmNrdW1naFRhYWNTQ21z?=
 =?utf-8?B?UG5zVHVRQWNVSWFWTEk2ZGx0ZTlNMkwxK3NmcldVL0wxNEhneDRQaHNkS3V2?=
 =?utf-8?B?ZzVkUVU4ZVJ5Ri9yaCszUjJOWW9lTjdtQmlSUW5hWWNNeDFHekdSa0FaQnlZ?=
 =?utf-8?B?alJvZ0lxT1NBQVJZTTE5cS8vZ283c2FmS0w0dWRvdG9odDBFVUVwNSsrWEUx?=
 =?utf-8?B?SDg0RWtXMlFGKzV5ZEpZUFEwWnpwVW9LMjFnaFFiZkJxMk9YV0F0cFd1UmpG?=
 =?utf-8?B?L1Jxb1E2b3FOa0tacExib0JCV1VCYzhIMllqWkk0TTQrRFpDSTZLcGxKSDRi?=
 =?utf-8?B?TmdQRGhBY3hCZmNmRFdjK0h1RFBTQmJYRWQ3Zno4RGV4cEFWTkY5RE9uSXdD?=
 =?utf-8?B?V3lHaGpIaStFTGNOdVR5elkwTEhIbmwzRWNKV25SNmZFV3FKRGdOZXkxZHB4?=
 =?utf-8?B?WXRIcXFWcDdKcUdTRVVRM2E3c1BaRWNCMmdBU0tyUjFkQmRwN3dtTk9XVVZF?=
 =?utf-8?B?TlduYXZUY0JOQWQ5ZjJyamlMazl2SUlhamV6S1E3NEdaNUc3L0NNUm9HU0Rm?=
 =?utf-8?B?bVk5RWdQeStpRkVtVi84WXk0UExFWXhwMnJoTGsweEFpRE5obEdOZkhWQm1k?=
 =?utf-8?B?bTRLN2ZVbjJVL2szZ09FQjQvdzUwZ1dxZmE5enpGTnBXQUlPTVFveVJWb2dK?=
 =?utf-8?B?d3N1Y3h4eVNMa3J4NG5DUG9wZjd3VDQvQ1RYTHNSSTA5VWNIbFlMSnNJVkJx?=
 =?utf-8?B?d1Q1dzFmQjFwQzVhRkZyVmcwUnYrRGtWSzNkTFJod2hQMGp1aE5xTVdZNjRW?=
 =?utf-8?B?SlBKaXFOdCtmYWdqVWhXOGJLWVQrZXVPUitLR2JDR0RPZGxKR20zRlFvV1FR?=
 =?utf-8?B?cXMrbEJ2NkF5RmFzdU42SlgxQjFxU0lLQXJuUUNiZG1XaVFwOFNlVGZWWTdl?=
 =?utf-8?B?d0ZhK2huR2JUMnRVQ1JMckdncjJBWFptT1htUHUwNjNBaVhHRTdmZ05pNmJJ?=
 =?utf-8?B?K1VjZmVLV2F0MTRObFNqTUp1UkUrdzBnSTVjVDZNR1RoZmFvdjVYLzBtUzhU?=
 =?utf-8?B?QlNWZDJpNUVwMkdGemdzT1pmYlA3a1EzRkc2Z2VsYVpMQWd6NjNKSzZ1ZFU1?=
 =?utf-8?B?bUZ3dTIyQ3VxemhzKytRYUw5bk1mdWkvWDZFL01TUGhwazV5OGltcU9PTWhE?=
 =?utf-8?B?bFYzWjNPbTQycTRBQWdNaGJySGdaZnFIUWt0YXI5OHhRZlJhQ1h1U0M0ZzBx?=
 =?utf-8?B?cW9uUFozSkpYVWwya29KdTBvakt1Y2FsSnpTaDZReDRtUnhMRXVYbzZpaUdQ?=
 =?utf-8?Q?AOrNZAu/X7xlpJBq2GoR04MstNRd9T5BJ/GqEQV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7741ea9-1b2a-4497-773a-08d8e3fe7128
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:55:23.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3+O8aYX/U98C8ycH6K1+YGgXcXfnPY4SeTlXOzHShEm5mWpkyDCD671keXdWnpuf6ndawRmXpn07/K0ZsdU07OiZP3QiPt5Q1MQNi1uXos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when punching out an extent.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/530     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/530.out | 19 +++++++++++
>   tests/xfs/group   |  1 +
>   3 files changed, 103 insertions(+)
>   create mode 100755 tests/xfs/530
>   create mode 100644 tests/xfs/530.out
> 
> diff --git a/tests/xfs/530 b/tests/xfs/530
> new file mode 100755
> index 00000000..f73f199c
> --- /dev/null
> +++ b/tests/xfs/530
> @@ -0,0 +1,83 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 530
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# punching out an extent.
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_io_command "fpunch"
> +_require_xfs_io_command "finsert"
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "fzero"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +nr_blks=30
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +for op in fpunch finsert fcollapse fzero; do
> +	echo "* $op regular file"
> +
> +	echo "Create \$testfile"
> +	$XFS_IO_PROG -f -s \
> +		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
> +		     $testfile  >> $seqres.full
> +
> +	echo "$op alternating blocks"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		$XFS_IO_PROG -f -c "$op $((i * bsize)) $bsize" $testfile \
> +		       >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	echo "Verify \$testfile's extent count"
> +
> +	nextents=$(_xfs_get_fsxattr nextents $testfile)
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +
> +	rm $testfile
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/530.out b/tests/xfs/530.out
> new file mode 100644
> index 00000000..4df2d9d0
> --- /dev/null
> +++ b/tests/xfs/530.out
> @@ -0,0 +1,19 @@
> +QA output created by 530
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +* fpunch regular file
> +Create $testfile
> +fpunch alternating blocks
> +Verify $testfile's extent count
> +* finsert regular file
> +Create $testfile
> +finsert alternating blocks
> +Verify $testfile's extent count
> +* fcollapse regular file
> +Create $testfile
> +fcollapse alternating blocks
> +Verify $testfile's extent count
> +* fzero regular file
> +Create $testfile
> +fzero alternating blocks
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 5dff7acb..463d810d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -527,3 +527,4 @@
>   527 auto quick quota
>   528 auto quick quota
>   529 auto quick realtime growfs
> +530 auto quick punch zero insert collapse
> 
