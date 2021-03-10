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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFDBC433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D59D64FCD
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 22:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhCJWlX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 17:41:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhCJWlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 17:41:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMY3rx171377;
        Wed, 10 Mar 2021 22:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9PWfdcbx9rfjb2/YsjuYUg3SKg8qIt+pCiyDOTY5Hnw=;
 b=u1KkL6TuZUfiy2CQOJwKHnzWoNlAaDBYikmruC/1BOOgled4DdRJUNsWowP958WH7Mt7
 eTdTzv9SPp6ZUa2bJlFtNiKbJ8fXmGbEs+oPDw5bpV26qYJgN/jrhAqbICu4crs6x1kY
 f878uPlVz7MWLM4s4pCYG/1Xuj+sPLboxnEtmL3X7LhnPt6r1mVQXioxNKXpcnADfOhF
 LaofkPxjsuqpBMBoKUKzKtoHBtadpkdhA4YXQKw7lZmKCSmjVuWTDyjRNyu1P+Htf2JZ
 cGl9FJhnLyDmMnTlwPWGZaIbfigmmWP1y7tibEWcDqBp6wdVumOe4VDMHEYtY1QxE6wi gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37415rcqpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AMZTml189700;
        Wed, 10 Mar 2021 22:41:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 374kp01sgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 22:41:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIZXY5tlyTyWDXXcYIHPPzLFwltjHFhW3GwKygYlbOyRfJmPeV65Xud/DS9C+yVIV5Vlz0PXVV2+DP0xnA38WdYe5uPCMIgrn5ga2vuoJYIzOP+BWGf+BotpJRuNnJbCarZ+eCBGst52klA3kPGmLuE5cILWXa+bQ+GWuGUL7xy0KgBx0ofWPLXiOWj3bWLcPD0krAR356ocTmg+VjqAbpi6yIFj8TXQsF5IqDy6a45FdOzNkqt0QW7Rl03sot2LiSW/Noq6Mt6iBoYvbGiH8VJH/28iUj19tlTidqb/FByhDP1t/BHyYPpW1ip27Ro617nENa5ReuZnicCa/S/3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PWfdcbx9rfjb2/YsjuYUg3SKg8qIt+pCiyDOTY5Hnw=;
 b=XiHjDQIxUAPW9ypYx6vpi4fUf4epa/1pjOm0y+mT0F0EsR93HUaO6dZXnkJuAvh9XSdNi1wEKYXUqp5WZeJYSynBQPWLp8YSesve1M3HBVjBjMQPNNMFzSQCT5AP/zq6LgUXARAOk936Kjpxrk1+T+czXQ7VJTyhzijaaborhoRQM3u9d+z2JlMmwBpr+AbOV54Lwb6hSiEe+tuIDANQ4aRsZpVEXLnZ+SmIKVjSf0ttwzgsmu/MKh6vRVgy6I1hef51tonMEV1sygb9IlgNLPvF0FT3huPN9jNDRxOXywuzvTAx1KHpJr2PBlCyPzxJeRQvM3mTkJBkNZnjkw1C7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PWfdcbx9rfjb2/YsjuYUg3SKg8qIt+pCiyDOTY5Hnw=;
 b=YVxjSN/HsqcFWaBK8vm2rptdJWyz/rzwNnK+rFh9bleDlK6bOvGMhcRW8p2MnEU9TblhGTZtNiKQT2nUTuJCVA20g7tlbVk+XquPR/Wq1ZsCMIOyLhKJIrBDe0v9m47GO1hKj8zz+8kYyULSpUhA1Ebj7CGOaQDYnLqriGO1v6I=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 10 Mar
 2021 22:41:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 22:41:10 +0000
Subject: Re: [PATCH V6 09/13] xfs: Check for extent overflow when writing to
 unwritten extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-10-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <3b3f5f27-7a5e-2a69-0fc3-28fc2b339e36@oracle.com>
Date:   Wed, 10 Mar 2021 15:41:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-10-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:a03:117::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR08CA0055.namprd08.prod.outlook.com (2603:10b6:a03:117::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 22:41:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c37e31-e95a-4403-0c33-08d8e4159a0a
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB37804D77367545EF7FDD5DB495919@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gxp2wRT9FL13fo403qkb627rQ851jr/74B8GmFd9JLojK4eAHFKwW6iWbz5C7CDlNKtPcW0YtmbKtUzMd0uWWeoJ3Sso+C+reS0btmeLQmrRfyVw4QVfyCgAQc4b8V5F6nRShkbk0VyvS0cHS/w+OpbDLT4U5CarxnBlW6LlWp4TZ6DoIm9UBDGuzAVjBvfFYAVvHUETQd60RCAM9XGwiQb6TzC8WJg3Ii75GWNhQWcLm8/Fi32on5Dh5D6dECNPXOE1Um0SToZOM9QFUvD/6EceVU1VxoNU4x+KM5PerP8az4LJYOSQ0PNkgTkFceBmc+a3EZa4nyzzg6/kmeWB8Aex5tFW/cmIRC0qZoTl3boS8JsC3LwBXA2S9lT/vnQKM5TbF8+iX1O6sS/qKsubY5HEz0ceZe+dIrl8MG6rT3+fwhKmD3vOHwo3J8Nd9FbPFlAhWtuv6s93RvQ4ycxF/EHx7QlSdEXWaKRi+E5bs4uHGnHESIxYEFNY+fw8K4hTbexAxMHavOqxn+rpZeLeHxanQhOyOQtJ9ZposGql748pVXjL3HhyXfBbCvHQk1dtkKhrr8aJwilImn6BuMXpZU5C9RsqKLjSmEzOlfDVYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(83380400001)(8936002)(316002)(53546011)(956004)(5660300002)(44832011)(478600001)(36756003)(2906002)(31696002)(86362001)(52116002)(8676002)(31686004)(2616005)(186003)(26005)(6486002)(16526019)(16576012)(66556008)(66946007)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2lCaWVRUThMZmpUV1dNUjByNWI3VHI1VElFSkVkK3NqUkhJc1BVc1c3WWlt?=
 =?utf-8?B?RzY2SXp0NGtpOFpqK3MyWG9rS3luaDFUSTVYV2RoUk02SkU5S0JEOGFtNTNX?=
 =?utf-8?B?RkVIQzFpaDAvMjVoZWZHdjF4RHNOeThPUUd4T2hqYjduWmw5d2dFbmNDd3V1?=
 =?utf-8?B?TnZIbVNkVHlVREY4RnQ1ZE92djZKL2grbDErNlREZ0Izc2dpb1RnY0NvaXpN?=
 =?utf-8?B?OXp5cngxY1pUMm00cFlUdm9ibFBsb2hTcGlBNGxwcWkxbDFndzVNT1NGMytZ?=
 =?utf-8?B?Zk9JL29rRktvSmNvU0k5SGt2Zkxrd2FnNXN2Zzdrd0hsbzBsUEZZRko3aVNi?=
 =?utf-8?B?emwyS3J4amxKK3poR09VdFo4WlRkZ214VmJvYk93Y1ZsSDFNL2ZoV3NtRGlm?=
 =?utf-8?B?Z2JJd25LRFJDeUYyZjVIM0VJNTIySU1teHE0SlZ6cXZ0UVVXQTgzZ1BrUVg3?=
 =?utf-8?B?L3ZPZW1XVmdVejEvT1JuNkhYV1R4V2d6eGRMTEJMT2ROSm9NUFM2M2wzOUI3?=
 =?utf-8?B?RVRUQzhZOHYzK00wYkxsMEpIcUFlNUU4VWpQK1JEUUZlSUkvZ3k4MGtGcUNC?=
 =?utf-8?B?dWdUOGltenFHVUhyL1FqZmRPYzZJbEVYL1BVTDcvTHI1ejRUNW5CeThYNkVl?=
 =?utf-8?B?aXB1d1hvcitRT3NoVDFJdnR4UTBMMW50ZFROSmpDTE1OS0JCY3oyc3c4NndQ?=
 =?utf-8?B?VHVmd09DVUhWTTg4cGZkcDU0MkkwaTQvZVF6dGltdFNBKzBiSS93MnBVTGZJ?=
 =?utf-8?B?a0xOeVI4cU1OV2o5Rk4vUTB5UUZ2RnpNUEd5NjM4dUxGK0tNaDNpdm5WVFdD?=
 =?utf-8?B?M1BvZExPNzdhb1d6OS94M1J3UjI2RW5QeEdvMWNBcS9USjJZOVJEWEswb2dO?=
 =?utf-8?B?UWlEbDFlczc5S3pUSzRCZjRBSFp0SnZtODJidEpieEpoMXprVTFTSFdxK2ZU?=
 =?utf-8?B?Zlljb2ljS0VIQjJiWlpuM2NLUVlhbVNFL1dGSVRhK3l2U1VESWVtaUk4UVFC?=
 =?utf-8?B?WVBKd0pnaHIweFdQNkZWVmFkdXRBb1czNktYVVBqSnA0TDBQL1ZvaWd5elg4?=
 =?utf-8?B?ZUlKYUF4dmluQXFiTEJFN3IxUU5pMHhjdVZYWFVLb0J1VXJrN1R2VFhYZmNE?=
 =?utf-8?B?ZkdhaTRZblF0ZDQ2Yy9uSHJzV2kwM0drSlc4Y3NiK2cxNEFxQVJaRHNKcUdC?=
 =?utf-8?B?MkplYTNnaWtmNWcweTdKdEY2anVoR0Q4Y2ZQSGRWUDhlWEpSSWtnSHlxZjdY?=
 =?utf-8?B?bVZ3bHA0T0VaaHFNbmRmREpKRWtzVGpLazZpazhHYm9kc0hmS0FoNHJYYTVw?=
 =?utf-8?B?R3FzbHhsQWRPeWxtMkFZMVFZSTdmVjNVZXFJMkxNUDRFaFRjZ01XRHFFMisy?=
 =?utf-8?B?MURCRWdvWFYrNlV3eU9BMVk0K0lKS2xWVzdxTEY2bi8yMWp6SVlDTHc2RDNp?=
 =?utf-8?B?L3JOQmoxTktoQmpWR04zbllOZXpXRzNma2ozY0VSWW9HcG1mUXhBOGc5UDhY?=
 =?utf-8?B?NzlkcG5CeVd6anY1SndxZG1tUllNMkltcjM1SDk1ekh4aGJUSUNqSHlnMFhu?=
 =?utf-8?B?TGw5VXFiS3pMQ2NmUGQ1dDdKUlpwLytKb3I2aWNKQkRGWHRRRUVJSnJvZ1cr?=
 =?utf-8?B?ZHlTY0FTSUk1TlJPa2hzZXFlR1BCNHJoZWkvLzJXT09CZ3JMaE9VQVhxa05P?=
 =?utf-8?B?Z0dHV0ZWekZxZmZyb0pkRFdldVd1RHdVeWhQOE1JaGJTbmoySWcwNjV3WEZQ?=
 =?utf-8?Q?dTiOBwcRKOFUXvkV3wt+jMVfPpjPxpO6NqX2PxS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c37e31-e95a-4403-0c33-08d8e4159a0a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 22:41:10.4124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bhie1cikmdXHGwa2jHBUvanNdmX8GYiUGuGPXJoIy8XLOF/Ac48ng0BNGhK4q0h0pJuua0RdLFG9yKu7mVNZV+WQNJfc2w32C0ClGroBvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100109
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
> overflow when writing to an unwritten extent.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/533     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/533.out | 11 +++++++
>   tests/xfs/group   |  1 +
>   3 files changed, 96 insertions(+)
>   create mode 100755 tests/xfs/533
>   create mode 100644 tests/xfs/533.out
> 
> diff --git a/tests/xfs/533 b/tests/xfs/533
> new file mode 100755
> index 00000000..bb6f075e
> --- /dev/null
> +++ b/tests/xfs/533
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 533
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to an unwritten extent.
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
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +testfile=${SCRATCH_MNT}/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +nr_blks=15
> +
> +for io in Buffered Direct; do
> +	echo "* $io write to unwritten extent"
> +
> +	echo "Fallocate $nr_blks blocks"
> +	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> +
> +	if [[ $io == "Buffered" ]]; then
> +		xfs_io_flag=""
> +	else
> +		xfs_io_flag="-d"
> +	fi
> +
> +	echo "$io write to every other block of fallocated space"
> +	for i in $(seq 1 2 $((nr_blks - 1))); do
> +		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
> +		       $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	echo "Verify \$testfile's extent count"
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
> diff --git a/tests/xfs/533.out b/tests/xfs/533.out
> new file mode 100644
> index 00000000..5b93964a
> --- /dev/null
> +++ b/tests/xfs/533.out
> @@ -0,0 +1,11 @@
> +QA output created by 533
> +Format and mount fs
> +Inject reduce_max_iextents error tag
> +* Buffered write to unwritten extent
> +Fallocate 15 blocks
> +Buffered write to every other block of fallocated space
> +Verify $testfile's extent count
> +* Direct write to unwritten extent
> +Fallocate 15 blocks
> +Direct write to every other block of fallocated space
> +Verify $testfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 77abeefa..3ad47d07 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -530,3 +530,4 @@
>   530 auto quick punch zero insert collapse
>   531 auto quick attr
>   532 auto quick dir hardlink symlink
> +533 auto quick
> 
