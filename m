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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAFAC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6AD664FCD
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhCJWl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:41:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38682 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhCJWlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 17:41:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMXZoB159090;
        Wed, 10 Mar 2021 22:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OY0px/Dhs7symPclUQdGjTgW189fCYFb/c0w1UvdzTw=;
 b=D0IPY26yiDxX06NmRraOo6GAP62qye3t9Nj6nHAccBjOA+XWFd+p8u/P9fQLgxF5KBPc
 H4B4JLF46qKlr9R4b3/GFh1+DQWOVTRadHsrjBUzpMq9sKN2MbmQJ4P3SbSctAj7mpcf
 N/IkyjQyZe/YHVz9KhMWaWGITy7XjhAa+oCPjM57AG57Dk1Ks/XMKyjLopQ6HfKXINGd
 DM43i86TTWvmfMi6P9mb9Y0jpnhpPfGTfi7zbI9PE7Dq4HRVJnbPas2M94uhrA0fAnOw
 jLX+ad+BfrkKtyjvIj36WRFlpg3AFYqNWasEcBYDCZhhmJBueb/2kH3uJzu64m4788Zj uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 373y8bvvp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMZUun189763;
        Wed, 10 Mar 2021 22:41:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3030.oracle.com with ESMTP id 374kp01sjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIuVn6pgt2aWrfKVOXZNo14Fszdu73Mfm0FhEWQmQKjYdFZ5ZFUH20Oi43zOTdxYC2wNO1K1NQYhIljiOkJqPD1U91wxl+kvl1KGmKhPxvjv1AuRhXt8UV8qbBArsWQsyviuceI1VIjBse5UA7Bujgh5kJiuyrjZLV8XTvtNW9QBTj1F3+3+6lvTjndjiwjZczlxQXGggOM7Pb+S7aMOTT+tkpYJ2fm2LZWbMKnTWUxETXuCky/kiKRFXm1w6NnJ46OdE71vEOzuCGUjwIau3S6qvmaE5Uen17qKq0AKbhvX0qqHwE8L92AGPI7MXTCBTdnu+QXauvb+g9d+Gsvanw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OY0px/Dhs7symPclUQdGjTgW189fCYFb/c0w1UvdzTw=;
 b=DYGqT8msjOEcrdwJ/p9hY8K+IIiCLuRiiYAgjGSaO2hkFF0rTk7Riy5kQlS0kRQWPeNKl1Qw8NaEuMHsI3U4M1qy0kNpxOlKitkEvE7YHhxCvzc7GN+go+z19DKhB8QIyt0U/4IvME1tfHoMzCBCaSonjl/4rlJnvuox2DDA9nIsyUGxxTNd8k/oYqS1JUWwXVyKvFFHsbQ60ULJTEfI1Rq3/YKLiUI97/qEpFhGJI1rsj2cKrob4DTs7Ih2s92hsYFYexRjvqS9BenIHO4VYRzLsaYIMGWt/+BQusb0eeYQYc+VsLR2FKVJRr6yWZL5m2dh4I9J/xs5Sl3VxghlAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OY0px/Dhs7symPclUQdGjTgW189fCYFb/c0w1UvdzTw=;
 b=q0SC5wKUEWDGXzjVYkS3jEOggAFJ+7OoY5ZJxwUMPif/3hFf2cQDRaG+5jMxluz3J8E3Y8M4PJHMoU4IM/71AC1oOhl610T8olzJigfL8UUnI+OEePrrwPdRYDeMGGNArVdn7NEVG9I4yQIzT7caGlxP7w9TzM5iq/fuLyiTUKA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 10 Mar
 2021 22:41:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 22:41:15 +0000
Subject: Re: [PATCH V6 10/13] xfs: Check for extent overflow when moving
 extent from cow to data fork
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-11-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b6ff1508-9977-27f0-8bdc-d4347a3e6523@oracle.com>
Date:   Wed, 10 Mar 2021 15:41:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-11-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:a03:117::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR08CA0037.namprd08.prod.outlook.com (2603:10b6:a03:117::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 22:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3345a848-72fb-4386-67ca-08d8e4159cc6
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3780037C8CDD71B003F0A5B095919@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6jpSv+BJIYUsvNeCMMS4R68x3U8Qvm3hYYZ3iMG5Fbuo47YK4v1tiLiCpwX9E735tuY7oF0cwo2aOkOPXhN3d1yb76qvgkEjVU2EZtsqGm9nc4TjFx/Q1/fJKypZBjAYo5GmbiRO2QYK161s2Js3qk4x3LuhHPmfVqGYWxPwyXduRv9n8MMAEgoR4UwRowaFrVgEjFo5TKm8Ny/XL0JvZC3+6DVWIvRUY2P3PG0YT8RcjvuestP9MKPgaIVc/tyXlF9rTSyzEqWngbV19AxOmmqvgsKnjZwiOL17s+dwWnX/OF1nINwAXpw3kUcEbtfOnm0oC1LZpRwJd4AiotHsjHSpoO0dsL8ZZPNEfnwRwUyXADg6M7mdq+ShpBLifsSGY8fP6mut4ZN8UXurd2BjIvcz4Y3mPpSY9ZWzrhow9YiPMMwr1RGWToWu++XT02LsN3XZqCmnLjmyrqaRs/A73H8oZSBnjgkScVtaMvKe25WRdKmRiD896zyIsYm7ayJ/SS7vKfjpNpxOtXz3png6QaCa9abnapgvdfFwTo5bzcy37bhXUa5fw/ucyuqrOyt94Ua7bBnoVXDiv6xJQc91EfwcmVn7CY11BZ4/X3QLf4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(83380400001)(8936002)(316002)(53546011)(956004)(5660300002)(44832011)(478600001)(36756003)(2906002)(31696002)(86362001)(52116002)(8676002)(31686004)(2616005)(186003)(26005)(6486002)(16526019)(16576012)(66556008)(66946007)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LytMUTJOcXJnNlYwcmJZcGF0bHZLSnBoMnhKSFB0Yk1ueEI5STNZNkF0SGtJ?=
 =?utf-8?B?azlqdjIxQ3kzS2tMNmJnVmQ0d1hKZk1iUFdzaE1uQzJuVUpNUWJDMDhJU0Yx?=
 =?utf-8?B?ZHdSRWF6Nlg2dEJaUzg2dEFMdlQrT2E5TnZyY3RaMm1XZysrQnNsWGlCMzJw?=
 =?utf-8?B?MTlOQWdVR1lFN2ZDcnJEU3pWV2xaWDNLd0o4QnhVZmhaMXNNWTNSOFpXMGJt?=
 =?utf-8?B?QUlKeno5OTMwVm01YnZNbE5PYlhTOFJ4c3FPVnpsME5oU3ZZNHhndnNIZDdZ?=
 =?utf-8?B?Nm1yakRGNkJiWENXd0NQVmlYQWIzbVpFNXU4d2NQbEVML2NQUVMvNkhUb2RQ?=
 =?utf-8?B?bkNwcXdId0dieXliYjNVVWh2MUVjOFY3eVJ2K2xtMGN0TUNVR3BMcG5IUW9v?=
 =?utf-8?B?d3R2NDFiN3pzWFArcDJNYnRjQjNQSy9BbGp4TTd1NExWSlpNVk0ydENKazVw?=
 =?utf-8?B?UDM2NTArZ3FxQTExRFhkRTNiK1NtUHdHVmpFZ1Z1R2xvUlo5WmRPcm9oclBY?=
 =?utf-8?B?UEFSYk5vRVZheFdXOVZCSFRxY0dWajNWczl3Qlo0M2c5K1hIajlEMVVsTGNu?=
 =?utf-8?B?c0ppN2FpdE92Q1huVWRnYjFkalZyQzkxTGcxS2FlVVhmUXVoU2VkTm40YVBv?=
 =?utf-8?B?MGRCM0hQajBrMGlvTkowLzlHSkRLNTFlOWF2MXVUeXJJcThSRlJadUlBMjNu?=
 =?utf-8?B?L0JubjJPaXBUVFU0SWpzL0FyU1FoWUhLaUZZMUVhalEyMHpyMWpBNG91a3Fq?=
 =?utf-8?B?UElMdGNFWVNQbDFndkd0N1RnNUZqdEkwb1NaeXE0QUFUd2FBaS9HVnV3ZSt6?=
 =?utf-8?B?UWNtcjQrSXFCZWpmY3JhVDh5ZkV1T3lCWmVRTS9DSzdnM0wzYmxnTEtlVlND?=
 =?utf-8?B?dDV2T0lUUzVlRjMrWkFwSFJjYml6RktETTIzNTZEWG5WRm5Lb2FxNkdNdDls?=
 =?utf-8?B?NVk1MVE0dEpLZFBaL3lCM1dkdzRxcm04aW1PVVVwa0dBdFF5Vm9QUXFGemIz?=
 =?utf-8?B?UUFyWkhjYXhlUWNGZUFvdHEyVGs5cGovRWg3NmdkNFFVQ1pWNzRDbnArdmI3?=
 =?utf-8?B?TjZHT3kvSHgwWkIveUliL1F4b3pONno0c2JhRU9QVW5QekxzbmRIalA5UFRV?=
 =?utf-8?B?ME1aTVRGbWs2dWdPcWx0KzlBOEp5MTdwaDkvU2s2cUhUeVBxcUVRc2JGMVlF?=
 =?utf-8?B?bHl2bXNNNnFVcnhpWHJBTGkyMGNZVlArelBLMUp4Y2pySHIyNUN4aGZSSm9i?=
 =?utf-8?B?dFF2eWRGWFNGVTl0UEZocEtnandOaTJFMEh5RVRBUVhQNWpwSTI5NFNaVVBv?=
 =?utf-8?B?WlRQMy9YR2duVENjSnhGTnFZSnJVb056Z1grTUwzTHRZc2RVMVVyc25LZmE0?=
 =?utf-8?B?TzVXZDUvSFI5QmJlOXhuQk1tQ09vZms5UTRSZmlYNldjVjFMZ1BqSXNIZXFy?=
 =?utf-8?B?ZUZuT1dqYkgrSnVDWHRISHVVUjM5cFJFdlE5L0g5YjUrVHgrM0JWcWtxbzBX?=
 =?utf-8?B?ZEo0b0JKSWlVY2FBWTZSTU9EVDNoYzJaNE4wc1VuMmQwVzYwQWhnWVJnbHJ6?=
 =?utf-8?B?RTYyRDBta0taVXRmbHJrRzZUSGFDMGZxMWNRdHdzM0JpVFNUYlhhdmczN2Ny?=
 =?utf-8?B?RFdjS2JpVVR2TkU5NUdtbzRKVlcwcTl6cmVEMlprUFgxa0pPODYzei9iMUFH?=
 =?utf-8?B?aC84endvUUUxbVgvSllUMVJPT3Bub3hrOXRNMmlsRjVMVUczYmhoQWtLZlpB?=
 =?utf-8?Q?SPtHvGjUSnVm8Ffs+qAkB5UTdXSf1QBw4O8hHVp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3345a848-72fb-4386-67ca-08d8e4159cc6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 22:41:15.0601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYJ48CEOXy3pBX8TZDvgs1tlwtNmmwUiuVRrPqXlgnssOlQKuYS/99oXVKi+yy+mOGB0fdBAUEfxZemS0d3rK8aqJfv05jQ9JbUBUodNzdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100109
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to/funshare-ing a shared extent.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   tests/xfs/534     | 104 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/534.out |  12 ++++++
>   tests/xfs/group   |   1 +
>   3 files changed, 117 insertions(+)
>   create mode 100755 tests/xfs/534
>   create mode 100644 tests/xfs/534.out
> 
> diff --git a/tests/xfs/534 b/tests/xfs/534
> new file mode 100755
> index 00000000..06b21f40
> --- /dev/null
> +++ b/tests/xfs/534
> @@ -0,0 +1,104 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 534
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to a shared extent.
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
> +. ./common/reflink
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_command "funshare"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +nr_blks=15
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Create a \$srcfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile  >> $seqres.full
> +
> +echo "* Write to shared extent"
> +
> +echo "Share the extent with \$dstfile"
> +_reflink $srcfile $dstfile >> $seqres.full
> +
> +echo "Buffered write to every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$(_xfs_get_fsxattr nextents $dstfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $dstfile
> +
> +echo "* Funshare shared extent"
> +
> +echo "Share the extent with \$dstfile"
> +_reflink $srcfile $dstfile >> $seqres.full
> +
> +echo "Funshare every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$(_xfs_get_fsxattr nextents $dstfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> +
> diff --git a/tests/xfs/534.out b/tests/xfs/534.out
> new file mode 100644
> index 00000000..53288d12
> --- /dev/null
> +++ b/tests/xfs/534.out
> @@ -0,0 +1,12 @@
> +QA output created by 534
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +Create a $srcfile having an extent of length 15 blocks
> +* Write to shared extent
> +Share the extent with $dstfile
> +Buffered write to every other block of $dstfile's shared extent
> +Verify $dstfile's extent count
> +* Funshare shared extent
> +Share the extent with $dstfile
> +Funshare every other block of $dstfile's shared extent
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 3ad47d07..b4f0c777 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -531,3 +531,4 @@
>   531 auto quick attr
>   532 auto quick dir hardlink symlink
>   533 auto quick
> +534 auto quick reflink
> 
