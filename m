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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B6BC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFA564FD4
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhCJXtz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:49:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhCJXtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 18:49:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANi6YG067459;
        Wed, 10 Mar 2021 23:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qMTUOOXhiAkvotsme5o7ema0Wp0qq0ekHqKZajsYUv4=;
 b=bC/ROqP8g1rm4sBIAXFst7wI77IL7hN5btaH12rnxZHPGiuceXZwoFxEmW3HLDDnF3sB
 0CImxczlkqcdFJFycQp8Y4mfGvIaA6Fs0//U66Oy2XlI0zQfJYaUiFJBgBnG+0WpwMYb
 CpPhGitayAHSoDyCMQ/C3dJ0X+HvPBnZoljAYlygl7SdBev8Dud8UqOf8sw6XdxSdgSl
 +rzsI/Fsa5nswzt9HD561lShSDQnVqjtL3cQPV0OeclZwjgAD3Q6p0iviNq5Ku+EM3Fz
 JTdHUe5M60nwbHttCmt9Wvpb7xxwABT3WAi4Xu5PxROMK3If0VgaMEuTs1texRDjmrl6 +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37415rcuhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANjTCQ029812;
        Wed, 10 Mar 2021 23:49:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 374kaqwvmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fTW3TKX95BueR904PMp4qYnteb67zFNQlOkwCNpRZVJkYfUcoByoNDkU+Jzl3S3bAh4W1CQgQ7beA7aPpLN25CLzVPppnBEKzZxFBSHJP/YmW7q7LXMMBxsR1+SB0ErKMy5iHxn1cFtb1Fky6V1SxeXy2MK+irr6IKuBDEktUSy8PCS6If4/zfM2IqKfLih8Y8nlt4AIPSG7AlnWR7azCKeFYQPYpZY+RBTFYkeG4kwJxdmE18c6wrGalN7DNZ7s6GawAyoPoylmP4nLQADY9SDquvKkNy4XWGr7HbZ4RQg/oIvCYRCfHGlt0xzo1LJU4MQ6UoOKSPTnX9v+HXT/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMTUOOXhiAkvotsme5o7ema0Wp0qq0ekHqKZajsYUv4=;
 b=kwOxd7DZoOQ0Z+R8A0YTOUIGLhcb48K6SnyAl8bUqlRKa+jrJo9x41JZb/5Opf0zDxsX0QE+ga17bmTaLekpmycb6MDFxFZinZsDW27vBO/6W5v+eVAQtQqA+nOdswL+w5Ud4pVV3oGYLHiqq8j3B/vnEb35IKDE4iRwLw4w6DF4FVshHpJQzhcMO6+7DhzjFQet0gN8oxRBU9E13b4e6kp6Lr9G78xeyXuWyjatd00f78g2vzuT2qydjd/IOFUDnkC/dQf33VYWskYC0b/z4jyTLR6fO2VJtYMzpKh17xZBQuguXUmk8WjfBvyaZZzY9oqxkhWnW5V/q2t+zBo71Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMTUOOXhiAkvotsme5o7ema0Wp0qq0ekHqKZajsYUv4=;
 b=v1guEnJuouOJNKtTvhx0CDsv6wRuY1SkhqnM9N/HU6uD3+CS2KxqORIxzZfC3hDLPAJ9po083dD2N1d3qkZvowlrhP9+7EslmxQE28IUtcSvjlBE8KCEMETVfvO0feLVH77fAvK1LFPfWjhwboKVcKVNnCF6/0fWL3EpqlLN0AU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2566.namprd10.prod.outlook.com (2603:10b6:a02:b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.21; Wed, 10 Mar
 2021 23:49:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 23:49:27 +0000
Subject: Re: [PATCH V6 11/13] xfs: Check for extent overflow when remapping an
 extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-12-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c587ec5d-11cf-9927-693f-ad39d1dd4b2f@oracle.com>
Date:   Wed, 10 Mar 2021 16:49:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-12-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0083.namprd05.prod.outlook.com (2603:10b6:a03:332::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Wed, 10 Mar 2021 23:49:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71a1a9c7-6fdc-4f8f-355f-08d8e41f23fc
X-MS-TrafficTypeDiagnostic: BYAPR10MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25664BD9B75554A4B0F4B25095919@BYAPR10MB2566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOL+6+QfMNkAXiOJEculortclFzhObwJ52cZY8sQtEFDLJdMuadBp9wxshsVL4DYPMpyN8HFg0feP8/X9LfUftAIvhckkwkDQ+uJUv8KKnrbeBCCjHDCHDfsRQBuIBXWiHY4I/jlrTAqmi37il941q3FQeUHp0Xp1XzC3ShPAcM1sM8KLOJzvNXNX80TQxyIXp7cqPD3kYBBSLzu41kG+ncCd2Zqx11V9B1JZ2jXVzAhzj6+eGmtSDLSzG+8BY5g2gzA4aPbTbVWmi6xcvgEMnKCP5v2h/LpCtj4ac3dvTVl5e0G+C2QpRPFQzZY0zAEHnPTCmmyn7InJcOFk78PRp5SOizUaGGe8UCACjsTt5XY+nMQEoZPtdaOLtet5+3YLT4eXHq2xHwkzIt70QeaElzjQtV/nsj912TeARjQNrO1bMJHyI6G1xh6/OUxxT04IKJqUHoGWDdQTolRP3hfmGbM8wcSIM5kXQbCHCvHeFPqpJ9dIAqYvGRv+2kuN43nVJ5/vWt2hbxfVweQpLRjlQzRwet7nDIvyjEDOAue0nziAt1ryh4+4OpL5v6odkMCYBDgP8BrAT8sSUwmzO3ARcyulri9scWMccBHJFQwK/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(5660300002)(8676002)(31696002)(2616005)(66556008)(31686004)(16576012)(86362001)(8936002)(4326008)(316002)(66476007)(66946007)(2906002)(478600001)(83380400001)(52116002)(956004)(44832011)(186003)(53546011)(16526019)(36756003)(26005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MnM2b1lkSTRzR0YvWjVuWm1nMFlVZWVSS0oyY2NWdHNJSW1LelU2ZVBVY2pB?=
 =?utf-8?B?aGxBS2RCOTc2RFlzUENaMjgzUkphdnN4c0xHWG0zTTBpbWR0QWJvM1BvdDBr?=
 =?utf-8?B?NVJ4eHBkYXE5L2dZSnpsbjRrYnBnYXU5d3VDYnZqUHBKdTNxQ1ZTTDIyUXFB?=
 =?utf-8?B?TkVyOERBN1huRTdacGRPQTdxTUo4MnFFR0ljYzhWL2tYbUNJQW9Eb01rcnMr?=
 =?utf-8?B?bnRZeUFSRzBUek5vWGdLZmlpZHpVY0p6UmpZd0tWRGd2WUVrTG9BVi91eHB6?=
 =?utf-8?B?aU11ZmU4MFVYTnU5MjBHNzU5b21rTE9lQmFzcW13dEZSYVpIVUFEQS9DanlB?=
 =?utf-8?B?T3ZNa2Z2Z2NDUHFBbHNWUTdibjhBS29kL282d2lRZnJYNmp4OHNCc0dBRThH?=
 =?utf-8?B?NDJacnpWd1QzN0VEUmNIK3IzSHlIWUFYUy9QTFBCUG0ydWZMcTB3bnljanh1?=
 =?utf-8?B?QnVmNm0vd1RQM3dWQkgyYlhidDI1ODlMSDVzQTB2YUk4TG5yUE9IUFdpQlVE?=
 =?utf-8?B?dkJiYUxUbkVMZ1lCOU94NXVGL1VEeElqQ241L0UzWjBlODlxbnNWQUxHR08w?=
 =?utf-8?B?TFI0RFN4akgycmVPOTBXZ2oyd1dETEJsWU1ISDlZNHAvQm92dFZqK0d4WVJR?=
 =?utf-8?B?REVDN3QyUE5SR3MrUEJrTWZBRm9xTk01KzR6c0FROTlYYURTcEM2NGhGVE9K?=
 =?utf-8?B?MS9zSVVJYkpHQ2d3YWtqWnhhRUFrbjYxS1AwbkdDTDNPRkhTamNiTDJiVUYw?=
 =?utf-8?B?Z0RDZFlMNFZXS0lDOEo1UG1yb0xuWHNJdFF0UTJJczB4dldSZ0NLWWNXaXFN?=
 =?utf-8?B?Nk1vVTZzOU04dTBCYUpzUHVORUZEbVowMXN5V1BPNnBFb3Q4R1NWQjNDWndO?=
 =?utf-8?B?VjJ2dlA1Tm45Wm9LaVNJcGJPZ01hc2lDS2trcDh4SVNRV0tmNXFqemJlMUVr?=
 =?utf-8?B?QUtnTHhpSHdRWjdOUnpLWUhhNEljR29PNmNjK0pQbWtmVU1CZ3cydkRoUFJi?=
 =?utf-8?B?L0JqNjFkSGZmNVBpOGdURXpnUnVUZ3lSRSs4aFo4bm00Vy9DeEs1bEhTeVVS?=
 =?utf-8?B?SzVkR2RydTIvVmRCc2pabTFyNnhzZ1FpN2s1R1RTbVZsWFdTRksvRWp5M3RL?=
 =?utf-8?B?anZaUFVGMVg1TWNSK2RzM0VEYlRaRnB0NXFkVE1oVk1hYkx0N2s2V0JtTCtK?=
 =?utf-8?B?S0JuQm9hSWlnZWNCS0JQMjM4MGV6SjlrdE8yNjNFcm9ZRk5YNXR0T1BHcElZ?=
 =?utf-8?B?czlmcEQxaUVpNnJoTnJKZ25jajk0TjJxUHozaWk0MFlaZFBRazM5TU45eVpx?=
 =?utf-8?B?WUJ2c3R2VjJqWUVWMmN0bklLRHlIRlBMSGdPTVZFK201MzRWWEJsMENIUFFI?=
 =?utf-8?B?NkU2b2NWbHRqc3hmMEdRRE1GRFF5VVJiSUEzZi9TQTJGd1RpVmlSOExiSlBQ?=
 =?utf-8?B?K3NWWHM4a2Zuc3Q0bHlrSlJNMzNLbVdCUEg3N2JNbktmSW4xUVdZV21YdmYv?=
 =?utf-8?B?a3lrcVFWK1dDeGh3TURvVDVFanpnK3BQL1dPUktMZWNSNGQ5dXNtem9JMkl1?=
 =?utf-8?B?cXVKOE13M3pQY3BGYlpWcllNVjFiMUZRMjFxY0R1RmJDbTRaK2MrZXJNdGR0?=
 =?utf-8?B?RC9rSEtERjJkdGhlbnY2QjlWRXJHeG1HSUhjNTJmTm5qRVFES2RpNFhuUHhZ?=
 =?utf-8?B?ZmRQSCs3TFdxVzVnRlN0a3orbU1XZlh5b1FNWEVrdTR3K3p6Wlg3OEtVaTh2?=
 =?utf-8?Q?/x/W3blusk+ZYmxNabNT8TO44s9hZounHfzHqT/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a1a9c7-6fdc-4f8f-355f-08d8e41f23fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 23:49:27.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: An2A96ZnTPbzNmXwc/mPvUeD0e9gaNGTWoJE60xyNirYhu/gcKaCVcTTJUzSI58U5cM8T4F9MTZ444yowo2aIm9vV23b5a1T9tkxCscNBY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100115
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when remapping extents from one file's inode fork to another.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/535     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/535.out |  8 +++++
>   tests/xfs/group   |  1 +
>   3 files changed, 90 insertions(+)
>   create mode 100755 tests/xfs/535
>   create mode 100644 tests/xfs/535.out
> 
> diff --git a/tests/xfs/535 b/tests/xfs/535
> new file mode 100755
> index 00000000..98209e06
> --- /dev/null
> +++ b/tests/xfs/535
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 535
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# remapping extents from one file's inode fork to another.
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
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Reflink remap extents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +nr_blks=15
> +
> +echo "Create \$srcfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile >> $seqres.full
> +
> +echo "Create \$dstfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $dstfile >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Reflink every other block from \$srcfile into \$dstfile"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	_reflink_range $srcfile $((i * bsize)) $dstfile $((i * bsize)) $bsize \
> +		       >> $seqres.full 2>&1
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
> diff --git a/tests/xfs/535.out b/tests/xfs/535.out
> new file mode 100644
> index 00000000..cfe50f45
> --- /dev/null
> +++ b/tests/xfs/535.out
> @@ -0,0 +1,8 @@
> +QA output created by 535
> +* Reflink remap extents
> +Format and mount fs
> +Create $srcfile having an extent of length 15 blocks
> +Create $dstfile having an extent of length 15 blocks
> +Inject reduce_max_iextents error tag
> +Reflink every other block from $srcfile into $dstfile
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b4f0c777..aed06494 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -532,3 +532,4 @@
>   532 auto quick dir hardlink symlink
>   533 auto quick
>   534 auto quick reflink
> +535 auto quick reflink
> 
