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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373ACC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0921364FD4
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhCJT4A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:56:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhCJTzc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 14:55:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJnkkU112247;
        Wed, 10 Mar 2021 19:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iecajRfa7U+XwZgc1ttF3Z3N9DCTxluzppd3IjBWCjk=;
 b=OpZZ8oAe7i5DXRZI6lNX++4HhQKiQlLNsnX6zXsA+t8JqAzv2QWOjiJmdFe5RnrppoBe
 LJraJMyjUbqPmMabtOrF05nSVB/XfwgXNa4JVNqpjMkMJ0cXTNrJSZlADMF5W39B+/kc
 vN2JrvgEKy5NQwOAbdlZvBJZdQhAR3CKx7XquNoLvx+1IKKTkMltEUg5xLlaURuzmz59
 vc7L9b+wr11Apqq2RbxrA5B6Ei3RU5+PHfj+qES+luPMePhkQkeNjCDVeanyxd+hFi4l
 WV+NeViSfXNXQhk5qbYB0mu9dX5Gom5aGO8sBz+z4sk88PEkC+NWbR76HoDjrB4d3CCj XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 373y8bven4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJpTQo109284;
        Wed, 10 Mar 2021 19:55:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 374knyvgha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIEHvIRaPp4Ue39D0XdyFOnphWS3B9yXvEwQO3h4wI3nSI/jTEToE5dY6ee7fwmcWxC1kcTMDtWbEgDtsqlzKXwUUl5i9LMmt0uJzKscRt4pzaYJqnanntGXG9G1NX0z7dWzjdNQocEZlBXKP1nJG/9g72hbkWGFpWeZYRGxYgDqBWT91SThL/hByndZj/pGqjmZuuZlqpyOHR5bR+ZMYc5PJkTK2EQtB5sUGmKJX2smrYUZVqtyVls+bjd98CXWjTMT/e123jmJL1EDiupL4BI21DGf37uJP8276AVjJsE52cSYC1SLXVWPSP2NyB6tKbtYPid52asAToMoDLdGZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iecajRfa7U+XwZgc1ttF3Z3N9DCTxluzppd3IjBWCjk=;
 b=FnK27/90E12TpspIVek7+QkgT3pIgX6ZpK1UdW66mKeAxYk8nHpk4Vv4YhI0d7jTJxEc6yZWlK6veyT9wvjSuubIXJrQH/wtn+1u+D/xm5OqFAJVMZJ6gYj9vuUPwfpW/CoVDdXjIbGYlL1Aeshlz90ogBG2iofk+5z1yYpLiInMPs2l8JCT0R+sH1WAGC+pK01+Qr/ieDRSXKNO7JGOmsDj8IeP6nefmmbBa0eEdJsNzylARFRT/RwJ4W3Os0JHhlunfTk60GKu7B7njq1gR1tghEC+RfKXRF5gvuBkG9NXwYvjtQh6nYhbVqpT+ttuWNDRMxvv/uOveMciPUc6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iecajRfa7U+XwZgc1ttF3Z3N9DCTxluzppd3IjBWCjk=;
 b=T9R+cQ0WTaQh2+2i5A6bU2sMBbGPxhwMMKOhdTdiY1YYOhXxUahINeLgSHS8j+IvBJIptK32cVkyMEQ1UntAp37N5NUl7YAdlMXiKVMY2VIymprNU5AJzVRTLxt4hER4ZEk5w/ZDAVAOCqO4OxisIdqbNylgnDavKURb7jtMnkk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 19:55:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 19:55:28 +0000
Subject: Re: [PATCH V6 07/13] xfs: Check for extent overflow when
 adding/removing xattrs
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-8-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <acbfcf6a-e9f8-cbc9-896b-803a026cfc84@oracle.com>
Date:   Wed, 10 Mar 2021 12:55:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-8-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0306.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0306.namprd03.prod.outlook.com (2603:10b6:a03:39d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b32fdbe-c7d8-4036-ab69-08d8e3fe73d8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB350911127A9EDF844E86999895919@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpR8TNtkb/WNovuLmn9M1kTNjYiKbeYXnzSgf6G4gx6OzxFE8V45r8PWmiouDNRKWHxGFiDidb+bl0HYpPxbO5nYiab5c9JcEQiU2xh6I2KHHBddmhvjc4pCBv5vymSy1ASOJ9w9cDtryuP34+VD2xhASQdXShbdRcFysN79aKWqCdlIarTfFcYNBEDZAavm+q0+wXvnzLMTNPhYwO514ALAHl4FIGLnNNHjR26b2jqkNCkrwiW+sQa3Vhlwmf4QLs52q13AysyiWlAbQ4b+iT6gZjqTIetxp1Z712EMYj6qFInJZurDyvPKV3gxVDFFjqEDfiGsZ9r6HANXzerrq3UW0z857Ck8DI4aRb78sl+l23bMiW7RgnyA7OnsBxZkWJpV/HASrsqztwI7IJkZt48D7/LdurWDCYIX/EIJ/eRLvkKlKXqJLXzYDjCvNDgjwwIX+TTo9i1An1gFUW+zqoQQwEGIc3lAhBF+wq8kbkB6gVcblBGuHZwhbE2BM1GnLlMZGzTVhqpUQ25GGBSg0+qtkIAIwtqCvXD3KcCHMuH+SV/o3lz7xmdzXVasZgMPnTVfTzXLzDq+MM+MCh/cU595BQDORTcmZ0t54mK9X6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(31686004)(4326008)(16576012)(316002)(44832011)(186003)(86362001)(31696002)(2906002)(36756003)(5660300002)(2616005)(956004)(26005)(478600001)(53546011)(83380400001)(66476007)(66946007)(66556008)(16526019)(52116002)(8676002)(6486002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NUhnaVZqSnlQMUs3RXJ1QVdpcS9QZml4eExHbEJRdVZQN3ZqYzJCNFkvbEtP?=
 =?utf-8?B?ZjEvZzZNK0E4TURUcVNPVnJ1VUtKVCtMQUFGdGp1cVdGcTVHeGphOUhmTHZY?=
 =?utf-8?B?ZjV3Tm5ZMk91RzZJZVFIbDNnMTU1NXl6NUFBQjhFT3Q4OENTMHo4UVZkTm5L?=
 =?utf-8?B?NWYwUy9aT0UwblZsS0hiUmFXMkJBWGgrQWVDSWk2Unl4ejdaT256ZVhwRklC?=
 =?utf-8?B?VGVVNUZBc0VEdW9pc1RGVFlBUk5hZllEbkUzaHJpazhmdFRPWnkxSHNkTmZK?=
 =?utf-8?B?SkNtWlVHSmt1akU0a2dsRy9pVlU3SkhiYVV5QlNJRnVFTHlkUWs4cU9DZzBO?=
 =?utf-8?B?QnhuTkxJcU02OUt0TXU0TjNUQXUveVlCai9sRHVTbjZzZ0E3Zk5IYnV4bDFL?=
 =?utf-8?B?a0lzeGltQ2lvNHM0MVVndGFqMXVmTDhSbnBtSmpWSTQrVXY2ZzlFa01ESWVP?=
 =?utf-8?B?LzBlUkFBd05BaVBZdDhCaGh2SnY3Y0RxUFhuNzM5YlR5UC9mQXlPWTc1d2pa?=
 =?utf-8?B?S0R5OFkwUytrVWQ3QzFIM2JvVDFQK052UVJYWXgxZ1RwWWdqMjZYRUdGb1BB?=
 =?utf-8?B?TW1selFBQXhMeXAzaFNoQmU1dXhRczIwczhSUFRRSHhyc01WZE4vTStRU1Zv?=
 =?utf-8?B?WFIyWm1hL2h5ZXdteVVNVmg3MjRoakgwMyt3Vk8xbDNqUHl3T29TWUkzaity?=
 =?utf-8?B?QlpKSFZ1azFaTmI3UGVBOXJDWWtPZ2hVVmZoS3pkbGQ2cVh2VWJWcGNqL2Zk?=
 =?utf-8?B?TXlJV3Qzc3VZdDBhdXp6ZDdUUmNYMjZEVzA2R0NLci8wRWM0bE9SUzBhb1RH?=
 =?utf-8?B?QWZ5QXF2bVFTVDc0Z3BjOVVoSnhKNit2Q1hLcjhCWklpdmFRK3M3cElYNHZu?=
 =?utf-8?B?NFE3UURYa25RRVRvQzFYcURrcGVibWZkcHNiSkU1c2JEbkNxN3BORGk5QzhZ?=
 =?utf-8?B?aHNEODhTRURqYmxEOGQvSVdUSG5mUGVmQ1NyMVBLMkV0N3B1a1JBYjVBeFVT?=
 =?utf-8?B?ZWk0N2l5cHAyalJLbjdUQkFVSnNOSzZydDV2Z0F1YWljK1ZRa1VkaU5DZk1t?=
 =?utf-8?B?V2g2UmpIRjdMSWcwR0orR1g5dWhvaWVzb0ZoTHRjM1VwSmswNHlIbWxyRHN0?=
 =?utf-8?B?d20weDFacHFLeXYyNzFIUjRHSThtM3Fzak9JZlFsMnF2eU1jbjhPajcrQ1px?=
 =?utf-8?B?T0FqdVZUQ0EwN21CNmI0WlcxaXBYdkJMamFqSmRIbWVncEYxTkYwSnJha3B1?=
 =?utf-8?B?MmJma25rRXlUZWVieFlEVWh5bUhzSi9WUWR4QnNsRWpKUHQ4bm5BcGFwM1FR?=
 =?utf-8?B?c2p5ZWZSTjRMRnVGOFVhcU5Fa0kzYlY5aURWL0M4cW5MRlBzM3JZeSsvOVlz?=
 =?utf-8?B?ayt5Mzk0NkQ4Rk1oTDRrT0s0eWsrVFlGeExVV0laRm5Sd0R1RlYvY2lQejBG?=
 =?utf-8?B?cmFJd2tDdHB0ZWoxUHZ6K1F1bGp6NWFReGxGZVQ3NXJYWkZ3VFNYOEh0VS9Q?=
 =?utf-8?B?TG5uU2cvNitlWHdHZSt0U0hVdXFOWjMzSWtodzlUd1BadjRxYmZZbTFCKy8y?=
 =?utf-8?B?aGNCQlBrTTFxczZDRHBxUDZIVXo1eFJObUlodTBFSVU0V2huK2lMeUhCWkpJ?=
 =?utf-8?B?OThrUHl5b0dPMnU1Uk1oRlFQbFZRVXh5UGF5eGlwVElIdXVqRTR6OXRRaWhZ?=
 =?utf-8?B?bTl0bCtHVVhrdVhQU1BGcWtoN2U2SnRjRkpLQmJLcGlKRDVxS0FYbCtZcUNm?=
 =?utf-8?Q?7XOxqfRS8C0Sh36wLaJTRTObHK/TKOPuGptoHT0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b32fdbe-c7d8-4036-ab69-08d8e3fe73d8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:55:28.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEdZowCL/UtP150YeoRGJpZinul1rr+KSVf38/duBgVsa6MAZs1G2qR0wVp1eK2HAU0eey3qqR4QvAZnv88yo+m8/nNK6BD+EJ6CIeZhB9M=
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
> overflow when adding/removing xattrs.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   tests/xfs/531     | 139 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/531.out |  18 ++++++
>   tests/xfs/group   |   1 +
>   3 files changed, 158 insertions(+)
>   create mode 100755 tests/xfs/531
>   create mode 100644 tests/xfs/531.out
> 
> diff --git a/tests/xfs/531 b/tests/xfs/531
> new file mode 100755
> index 00000000..432c02cb
> --- /dev/null
> +++ b/tests/xfs/531
> @@ -0,0 +1,139 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 531
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding/removing xattrs.
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
> +. ./common/attr
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
> +_require_attrs
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +attr_len=255
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
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
> +echo "* Set xattrs"
> +
> +echo "Create \$testfile"
> +touch $testfile
> +
> +echo "Create xattrs"
> +nr_attrs=$((bsize * 20 / attr_len))
> +for i in $(seq 1 $nr_attrs); do
> +	attr="$(printf "trusted.%0247d" $i)"
> +	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's naextent count"
> +
> +naextents=$(_xfs_get_fsxattr naextents $testfile)
> +if (( $naextents > 10 )); then
> +	echo "Extent count overflow check failed: naextents = $naextents"
> +	exit 1
> +fi
> +
> +echo "Remove \$testfile"
> +rm $testfile
> +
> +echo "* Remove xattrs"
> +
> +echo "Create \$testfile"
> +touch $testfile
> +
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
> +echo "Create initial xattr extents"
> +
> +naextents=0
> +last=""
> +start=1
> +nr_attrs=$((bsize / attr_len))
> +
> +while (( $naextents < 4 )); do
> +	end=$((start + nr_attrs - 1))
> +
> +	for i in $(seq $start $end); do
> +		attr="$(printf "trusted.%0247d" $i)"
> +		$SETFATTR_PROG -n $attr $testfile
> +	done
> +
> +	start=$((end + 1))
> +
> +	naextents=$(_xfs_get_fsxattr naextents $testfile)
> +done
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Remove xattr to trigger -EFBIG"
> +attr="$(printf "trusted.%0247d" 1)"
> +$SETFATTR_PROG -x "$attr" $testfile >> $seqres.full 2>&1
> +if [[ $? == 0 ]]; then
> +	echo "Xattr removal succeeded; Should have failed "
> +	exit 1
> +fi
> +
> +rm $testfile && echo "Successfully removed \$testfile"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/531.out b/tests/xfs/531.out
> new file mode 100644
> index 00000000..7b699b7a
> --- /dev/null
> +++ b/tests/xfs/531.out
> @@ -0,0 +1,18 @@
> +QA output created by 531
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +* Set xattrs
> +Create $testfile
> +Create xattrs
> +Verify $testfile's naextent count
> +Remove $testfile
> +* Remove xattrs
> +Create $testfile
> +Disable reduce_max_iextents error tag
> +Create initial xattr extents
> +Inject reduce_max_iextents error tag
> +Remove xattr to trigger -EFBIG
> +Successfully removed $testfile
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 463d810d..7e284841 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -528,3 +528,4 @@
>   528 auto quick quota
>   529 auto quick realtime growfs
>   530 auto quick punch zero insert collapse
> +531 auto quick attr
> 
