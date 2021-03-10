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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D97FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1807F64FCA
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhCJXtz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:49:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhCJXtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 18:49:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANi6YH067459;
        Wed, 10 Mar 2021 23:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lPAw2XKfl0Uhv5kXamMiHeqFjph/u4L9oITc28J66NI=;
 b=vHSjpbQCA/mh6XQ8HMscl9CcXmrdYNqva7MPBYjpJtepHxFnhXiwNpVP5s3+uE0Wm/vG
 UvRBxnIKESToouGpNNcpLsmpbknCAZbqbR81u1nfsbXqO8uA7/RlFbNZBNtIZBEo6Dpo
 tPkx2w5QGZie44S4fFGn2hFTqbJ/jgkuLyXb2BXDhHldAUTF1iOOXoL1mxnN7SlMiw2g
 WR0E6M/ASGo0fTeVOKsRRZ9DSEtgwkE2g0LnR5lbtZOlyt4Rt1I9ev+s4fmGZivcuVdn
 TzqpogaQBF2RWhLWOqSe/DXUYrtOwtTaqm0nk2SZN31EcS37YgiJRzeGJqLlTz67OByR nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37415rcuhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANjbJ4043540;
        Wed, 10 Mar 2021 23:49:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 374kn1p6e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp9G5EH1ByDWFm5C6GZpmvl6vE6/UfZDZ5BNvS/DqPYM71AbZ6YJ1uiz8j8LYDr6AUHD8fCwlMT2svg2jT1A9LLW6Obgu2E9t9Y0uwR1O3ll5OdaTaPXPMVqVU7U20YhkeS1NOoa7vUB3vxOkXV+ycLckW9evdjLjJsYZmCosI+fHZAnzO8mF09gozrtzmMnQWsle/suwKUNN1RQY26Fb3m82TTq1SZpmPfy8hZ1mFvFzHd4dwmuNKTovYeo38TlxQ4hUqKRe02avOP+mu72I7lOqpECiPZ78xjwxQlh/2OMZ5MYwzazcPui/Z5nzBJWqKKHNvSHENF6a3aUp/6xow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPAw2XKfl0Uhv5kXamMiHeqFjph/u4L9oITc28J66NI=;
 b=Wbh9HkVX43kKin5cFAnzEerLwg00N7tINUWo/rbvwN74akiBlbejN86OSoq0ZuyBhCgcJbqIK9solqEHDFiMve7ZAzlwBpaknMYPqx7v5SbVFtHOJ01rWe3MIDyevzxN+BOEMQfR5dJWvf66x/OGOpEFiwfth/VPlM5zCXtVUXcrO7AMh9BYdSfVRjp0az+4mpeTBxoEjIu1PmeI922tkIUHVk/jXuJdfMQT1F19wTbzpComfnAdTRl67ZlOV9neE76gjsmJxPlGxBIR6ia7kKE9u12vBnvomAl66zZvkXOTiux2cIHKN/QDzJyGDjVc2lpiJbto8HR7KM0uU5gi+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPAw2XKfl0Uhv5kXamMiHeqFjph/u4L9oITc28J66NI=;
 b=XMcjiQYbXLwMRnASWz1n4aKEuNyXHZ9JqOp9hsa+9/ZxCkhil7cjr7QWXM0wiqrBQ5d2s+VgV9Y7rxl6WyMAw1YCwqcFjSTuxqDhvMx2cvx7i8mBSl8SCmL3gEq4du5DAGsRhl2K2Obv+HMF42tHE24PPPa/XhQuVhlRb5oplFk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2566.namprd10.prod.outlook.com (2603:10b6:a02:b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.21; Wed, 10 Mar
 2021 23:49:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 23:49:29 +0000
Subject: Re: [PATCH V6 12/13] xfs: Check for extent overflow when swapping
 extents
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-13-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7f0a3eeb-7928-219a-50ec-bc5829accd92@oracle.com>
Date:   Wed, 10 Mar 2021 16:49:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-13-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:332::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:332::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Wed, 10 Mar 2021 23:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b39731f-368c-4db9-44b7-08d8e41f2539
X-MS-TrafficTypeDiagnostic: BYAPR10MB2566:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2566BF4AA5A215133F0B7AE495919@BYAPR10MB2566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O+HEKDptM5ERjXY/S801dLiGxl9WifgvVhvQbry+mlPODuuVwpuzsbLAkleybosNem2PYvTsWu77qTFqZF+YSQzw+gj0+KXiGdUDK1uunO5UHxzPkXuKuVMnsZ62BHugSQo2hcnNnHTn/CVJ2Htlk6DwrgogoY1+xFlw3BN4pMqSsOuktLPYTLLTEAi1uhn6Rxqsa+stDczrPHjykgd0YaXzARJigRLq6zHBeRS0g207BtYM9YjBSfD4ff0psRItYxygmm5kfwrk9TwgNhK9wzHPMi2BUuGxnSNb0J5dzrOidVmwQ54ic87Yqb9zdCGfvaHuhgqwUnjD3pvH7tLJZYkaRvtyF9Lh7F/YAFbYJmU+CRdA+Qinbk2XzHhJUd2P+18W0F7nY4nHSK34Ql/IQlU24xd/3FSqLFp2vLSQVhhsUYcRuxUpwHrfvsHxDpvxwlN34q3QrZ/YXrclvCa9qu27obhMAmhm0fKsfZmf/Px+d0XJeOAc3xIB4qhmGxe6onfkgBeAOVLp1108tLe/6dj9T0/DzohHjLd4tAB7oIWlojTvPY/4zwpDxNUJvR5jF1L4um4OaAvbfmRUZNWupjPUPLK2Up0aiQADkniaqfs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(5660300002)(8676002)(31696002)(2616005)(66556008)(31686004)(16576012)(86362001)(8936002)(4326008)(316002)(66476007)(66946007)(2906002)(478600001)(83380400001)(52116002)(956004)(44832011)(186003)(53546011)(16526019)(36756003)(26005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVZHelJNTWFYS0hrRmpTOGx0U2xFdVRleHBWSUY2cjZnRkNBaC9OODZqVnVC?=
 =?utf-8?B?bEZUQXZDT0pWMVNtbHZibjBibWtGanlYWE0xMExobFNobCtsZTAydHJhT0J6?=
 =?utf-8?B?am5JbVJRNVpwM0pIVFExVDhpYmYramswdmNNSHpiMUt4YTJVUmNhRDBxcnRI?=
 =?utf-8?B?YWlkUVZnKzFpSUtUNDZxVUV3d2tRZUsvOFFvU0Z1c25pSEgxMkRkVmlqZTB1?=
 =?utf-8?B?NFhkeVpRZ0xMOWFtQWxRc1JIWHoxcFBIbGZkaEFDZ2YxaWlVeldUZDZPSnpo?=
 =?utf-8?B?clplbTBmSHBuNGxjS0RIaWp0YTdjenFVQis5UUZVVjgyYVhCOVZmd3FwV0RE?=
 =?utf-8?B?by9EUDdXSWpXL3U0VkV2TVRkVjRUbnlVcnFmemVBWEdnR3ljOUY1L0haYUto?=
 =?utf-8?B?M2JpL2YrRm1WMnY0QjNRNDdhZ3I1WnFwVnJ3MnVOMlFnNVM1L2ZKN3QzblRJ?=
 =?utf-8?B?ZVdnZWMxUGNRVTNjR1JsamtVdyt5SjZRMGdaMkNCajhoRjEwRTJkSzNwOWE1?=
 =?utf-8?B?TFVBNVMxRUxvSjF6RE9TRGVKaldFQmwrcVdkeGM5NUR1d3pHQjlxUjZRSjNW?=
 =?utf-8?B?elptRkFwM25ZelB1VGpVbEE3QjlVUTFlaVo3dFZtVEltbmphZWt1a00rZmdX?=
 =?utf-8?B?bzQ0aVZlNHRGcmsra0l3aEdaMG52b01qWlZsTDJoQW9rRURBVXo4N0pFODFr?=
 =?utf-8?B?d2RXQkExWkUrVSt6b1RRMjcwckhjaUJxRkpXKysydFhjc1dSQmlJWWhyUzQ4?=
 =?utf-8?B?ZkZmQWVxRWdhaEtUSm5kaWtaeXBKdk5jczZhOERrUFRHZk5RRlRwbzBRSXRZ?=
 =?utf-8?B?aHRzNnhKNzVJYlZYWEF1clUyNXZ1Vzh6UXFidDUzYW8vZjhtRU1hSHk2RTRx?=
 =?utf-8?B?U1lmZTQybDg5SlBOUGd6U1FhNk8xZkdBRkNzam1Damp5dUphNDRjc1pNcmZS?=
 =?utf-8?B?akRTU2M5ZTIrNjdCNGNGRWZDSXBNKzd5K1RzbGNoUTZUcWgxOFZ6TlhzL2xQ?=
 =?utf-8?B?KzN5clgvWDl2ZER3UVZpNDBUdWRoeXlFUWlQUVBvMDkvOFl0eks3akdLU3hR?=
 =?utf-8?B?eFdOclUyMFV1YzV1WFpRS3FKNVp0eU1teXV1TTRpcGtYZ0NDNGF6UFNyeGJV?=
 =?utf-8?B?bkdnWkdlQldYNHlIMWpwWCtkMGZ2WklEUnRRRG1FSTdFWU9CWm96aVk3MkxE?=
 =?utf-8?B?a1dnd1hzVXNBOGEyMHlKcXZEVXpNMGUzV3FaN1ZjZlRpTzJxN3Q3M3hoVTFh?=
 =?utf-8?B?ZndOVHhWa1JtQkpVUFp5dUtjb0FYZ0U3aC9ONkhEVG9DVEswMHRlc3hoeUtB?=
 =?utf-8?B?OVcxeXNKekltcjVicTZUU1VkWHErRmpSQXlQekFweFlWM0xDdHBnaktqRVVw?=
 =?utf-8?B?bW1Qckc4YUh5bWtQc2pSOEpKLzNRR3NDaEg0NmF6aVVkeitXeGpkZy91MVlj?=
 =?utf-8?B?L2lJaGQ2bFhqNGZQNUpiM1FSaEIxcGFlVERPVXFLclhlOWJvQzczSE0zTC8y?=
 =?utf-8?B?akVyRU1SNHd0a2I3K09jN3BlYjZJaFIwemlHa1RuSTd3cks2bGRBU2Nmb3hD?=
 =?utf-8?B?VWhNaUR5UDN1WjJDZ283RzZMYXdXVXJKUS9zeWtIVFBzaFUwNWZnZ1NMaXVK?=
 =?utf-8?B?OEVBMEEzYjNpRDVCdi8xeTd5dThiYlBZUDMrNVRRa0xVY0NNK3lPTFZvbFUx?=
 =?utf-8?B?Y21wdWxFVnIzamk1QTk1LzA4ZmFEa3FnWUpoSFJQR2ZPQU9UOFQ3dzBXblVC?=
 =?utf-8?Q?7zsN74l1BhtZ9VtP2X4ajfph8L52JjRaSS2L3RN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b39731f-368c-4db9-44b7-08d8e41f2539
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 23:49:29.3659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIc0ccteS+fXqLsMM1kGI2X4U4nzf1JG5sI0+th6Xoy8WUhrkJ0uomlbZvYLC0F/udrkyszi0oUIxvqKpq+sSTCW/VgvE6VOHDc6+pdt4CI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100115
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
> overflow when swapping forks across two files.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Makes sense.  The extent illustrations help
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/536     | 105 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/536.out |  13 ++++++
>   tests/xfs/group   |   1 +
>   3 files changed, 119 insertions(+)
>   create mode 100755 tests/xfs/536
>   create mode 100644 tests/xfs/536.out
> 
> diff --git a/tests/xfs/536 b/tests/xfs/536
> new file mode 100755
> index 00000000..9bb4094a
> --- /dev/null
> +++ b/tests/xfs/536
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 536
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# swapping forks between files
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
> +_require_xfs_scratch_rmapbt
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "swapext"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Swap extent forks"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +donorfile=${SCRATCH_MNT}/donorfile
> +
> +echo "Create \$donorfile having an extent of length 67 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" $donorfile \
> +       >> $seqres.full
> +
> +# After the for loop the donor file will have the following extent layout
> +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> +echo "Fragment \$donorfile"
> +for i in $(seq 5 10); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> +done
> +
> +echo "Create \$srcfile having an extent of length 18 blocks"
> +$XFS_IO_PROG -f -s -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" $srcfile \
> +       >> $seqres.full
> +
> +echo "Fragment \$srcfile"
> +# After the for loop the src file will have the following extent layout
> +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> +for i in $(seq 1 7); do
> +	start_offset=$((i * bsize))
> +	$XFS_IO_PROG -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> +done
> +
> +echo "Collect \$donorfile's extent count"
> +donor_nr_exts=$(_xfs_get_fsxattr nextents $donorfile)
> +
> +echo "Collect \$srcfile's extent count"
> +src_nr_exts=$(_xfs_get_fsxattr nextents $srcfile)
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Swap \$srcfile's and \$donorfile's extent forks"
> +$XFS_IO_PROG -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
> +
> +echo "Check for \$donorfile's extent count overflow"
> +nextents=$(_xfs_get_fsxattr nextents $donorfile)
> +
> +if (( $nextents == $src_nr_exts )); then
> +	echo "\$donorfile: Extent count overflow check failed"
> +fi
> +
> +echo "Check for \$srcfile's extent count overflow"
> +nextents=$(_xfs_get_fsxattr nextents $srcfile)
> +
> +if (( $nextents == $donor_nr_exts )); then
> +	echo "\$srcfile: Extent count overflow check failed"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/536.out b/tests/xfs/536.out
> new file mode 100644
> index 00000000..f550aa1e
> --- /dev/null
> +++ b/tests/xfs/536.out
> @@ -0,0 +1,13 @@
> +QA output created by 536
> +* Swap extent forks
> +Format and mount fs
> +Create $donorfile having an extent of length 67 blocks
> +Fragment $donorfile
> +Create $srcfile having an extent of length 18 blocks
> +Fragment $srcfile
> +Collect $donorfile's extent count
> +Collect $srcfile's extent count
> +Inject reduce_max_iextents error tag
> +Swap $srcfile's and $donorfile's extent forks
> +Check for $donorfile's extent count overflow
> +Check for $srcfile's extent count overflow
> diff --git a/tests/xfs/group b/tests/xfs/group
> index aed06494..ba674a58 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -533,3 +533,4 @@
>   533 auto quick
>   534 auto quick reflink
>   535 auto quick reflink
> +536 auto quick
> 
