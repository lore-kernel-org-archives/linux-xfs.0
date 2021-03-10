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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7465FC43381
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 491FE64FD3
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCJTz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:55:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhCJTzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 14:55:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJokXK120703;
        Wed, 10 Mar 2021 19:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Is3iTzG6akeO6ivm6JKNM6/bEKpc5/Qd4cckxzAxqUM=;
 b=tZcNl73JIDXcPyExe2ovR7oCveCTzPsa9vvjuWShO0JKg1NX0AMAq0EtMj7StCYNUVEn
 eIO6ZVvw0zd9PvcByNgH6dAy8sKCE7JC4C0kjEbrie3Dha3bj0mhZHVr+Fj5s1lvWY5Z
 Z+64AIKczPWLrK9lVW/NtXmj5NWUp9GIxZE0p2krRrtMav/DpjsivZoUGoYvf3pdr9c8
 G4iLQIN249YNnFB62IW+nxOAGHdEQozgYnTnFzW3tYzNbcvK+I6YXU8MtC0wmqopeI2E
 OIjbzXRn3QjULi8fXDy5Ab5bNYMbtmFrQQoeCydP1lErzpftlpi3VboCvR5uvCR/oh+m AQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37415rc9h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJpYRJ060829;
        Wed, 10 Mar 2021 19:55:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 374kn1f0fm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO/6qGKldml/ZiiqYyAyatccS7+8aATCHw4fnttiQiO3FNsDGYFG82OFs/kVHO7vLV9hwHbLke4YDwlpJxU2mIbRNdcuc2Puj4d2MsBM2hB85Q4iD7zJaehxgJr/Go6i7PKDS85wqu6fuT+lYQMGeu2Vt2OmzWU9CLKR3NgTYl4tAuJZyyfLaleNPXHVD9450CxKN4C6umGvDMQNIWLBaB9hYj3I5pTN/IWEbyHkFTnVPSF/3mwyeNM+z1daFwb3CEiY1rtgbpYS3wD4GEBElnacHphUa11opfX8wh/fg8pMGLT9MFEQVwtExjaTXnC/zpdY1kQsHw3ybFVOTFfFZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is3iTzG6akeO6ivm6JKNM6/bEKpc5/Qd4cckxzAxqUM=;
 b=mgvLfztqPAnniTnD0viy6jwiDbDmzchcJJCD92OAu3ZI+w2XB85bFgWlnvf+DtE0ClmIDylUQ/Xqb864iatQHNy1NhDtDl8NvzEXg8arjDcL15cCXegC+eckEvGyX8C9fEzTonAPfWpp/f6ptPdbiLVz/E3HoY4R65uflHP4zD/IyHbFdXB1SnEWrFBJe3u6R9SWgIhP4hRnHLhd2A5b7rst2BwgwnmMzmYOsUxFTeyx7HT5RKxhmhtKbLJUatcsS5u942c+bXK+aP1bxuFv/KeN51liMpEo501Div1a1FmOCZnR6OMFa4O99c5TRvrZ529pb7ePi7Fx/KHZ4phiig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Is3iTzG6akeO6ivm6JKNM6/bEKpc5/Qd4cckxzAxqUM=;
 b=FBCnjaRwpsKb4Ts5N37EzKTOlPeEi79oTjXv92qHY8E4b2voaHUzft7/6JJxtDXoEExRCJ7xkoVLh8udL/d9G549ej8bJqteF96voCojSftxvmT06FkQckIEikSsAkCvRQLKsGVEf/A7AsJx7+Mc509rsrW+ZVeYBaD43ggAWBQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 19:54:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 19:54:59 +0000
Subject: Re: [PATCH V6 04/13] xfs: Check for extent overflow when trivally
 adding a new extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-5-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6779f15c-baf1-28f6-9b69-b7182f44f35e@oracle.com>
Date:   Wed, 10 Mar 2021 12:54:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-5-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0320.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0320.namprd03.prod.outlook.com (2603:10b6:a03:39d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:54:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4bb7848-d4d9-4ba0-491c-08d8e3fe6282
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3509B1EA8D153F223D8A1A3C95919@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QhBLtSL0jTJfrNH6VuAT4OecmnETN1yaUp76g8NNL82/Cd11rU5OXqsRzyVDCIqXzqqeuj+zoRLWzLosOVkyj48EqkuHVL1ID/lgLk3H8/FTV3VYH93BImEeDbtZhXmiLvfcdSA8F5TI6yGPm5/6l2xtvMpohQbBQ3YWdKG5KNoWylioyh7nGqda5Bz4QiPd1cbLE+Y/pTIyNXUFcKnKOIqtJwHcdLGDo29/zRu20tPr3qPaAaVUtBmtVOIHoLJfLqVjMunzmY5Evzdv5Q7KYt0v01peLN24XFdN19kAe0vnl0TZG6Jyt9GS1evS4tsva3PIud49DJrAAiE9KpPMXEhVt0Iet6mvvkyU1Tz++07zzykPItYfz+Cz7i0Y4j28/pha3VoGkAmCd2X6WeRPf0fAnyuBNpqVY0HyNSCRgPw+9+wKwJp/NCQVS4nfFt53AgF1y2AxSsWBQ2XWpTRXcs/hE4zQwVaOwDmyw0zyW/lgyQy2t3iXqwGvm1n0a8kUeVPolhJZxT+zaZLrreTz0UOf7ttHkYh+WDgLhU6oUj8oY4AbT2UTZZJ4ET5irZzjcIZQYD3jpFIMa4bg8HsUWt6kyqpl4p6KnRocdccoR/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(31686004)(4326008)(16576012)(316002)(44832011)(186003)(86362001)(31696002)(2906002)(36756003)(5660300002)(2616005)(956004)(26005)(478600001)(53546011)(83380400001)(66476007)(66946007)(66556008)(16526019)(52116002)(8676002)(6486002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WlhIbEdROGJFYVVOY0dOcXYyRUNMUnNGUmZUUjJaelhHV0w1QUt2R2RIL053?=
 =?utf-8?B?U2lDeHVIb0NrTm85c1UxZWl4THJ1bERuMFhwT0FjVHByOHg5bGsxYk12TGl6?=
 =?utf-8?B?cEpHWkp1dm45MHIxYVFBaFpzNUxraFFFOFRXaTYvcTlCWlZ3Wi9teGR1dTht?=
 =?utf-8?B?UDcwY1BCQjNWNW9kNk9WM3BwUUFSVXVObVptZFVXRElQZ1M2NHVCUXpZUGVN?=
 =?utf-8?B?T0VDSXNCN2ZNMlJoelhqcWVNb3lTTHNySE52Y0dPQmV5Z1UzV3RUVmRpQVhk?=
 =?utf-8?B?SmdaZ0xZejZFaU95R0FWMXBoVHc4RzBaSi9jVVBHU2FpU1lqZG9KQU1sOUlS?=
 =?utf-8?B?QVFOZ2ZTdk1WVUFEYjdYYjZMZ0o3UFRrOXF2aE90c2lNMVQrRzdsRElWUnV4?=
 =?utf-8?B?OEVNdjJVeWsrcTM0T0ZZS2tMQ2dIV1kvTDV1bEI4VjRBN3pzbklUMEI3d0I1?=
 =?utf-8?B?Z2x4Ni85b2krOHZmbmtRY2dXVUd0ZnREWHJ4a0JXdmxGMnd4cExDUTRCaWwx?=
 =?utf-8?B?MFRqeGYwMzN3cG5OSHFlL0ozUlBKY1Z5YmtCZDVPMmd4elVCWDNmQ05iWlFX?=
 =?utf-8?B?T2tsU1F1aEY2dzF4d2ZLaXVqaEt4OTVscGUzclI3L2dpZjBGMG5sOGZvQVJ0?=
 =?utf-8?B?RXNPemY3clNUTmNJZzgrSVc1NE1EcEZMbnRJUk02dU90QmlWY00zNGcxMytY?=
 =?utf-8?B?eUIvcFFMcWFmcU1lbnU5dFhYejZxMnp0cTZwejZjWFJTY21zL0NRbzdxMnQ3?=
 =?utf-8?B?dnBvMFg3azFpNUxNNnlFdUNQcHdVQlYzcjN4RWc1elB4YlJkNDByMGpSWVNL?=
 =?utf-8?B?TWRhL0lMQzQrenNjazBvVkttdytTMjNIN21xQkRQZ0l3RGQzV1pjUVkwWE5h?=
 =?utf-8?B?VlZ0RmxTZGJ1SkJmNkM1UVJUOTZwYkdDMTE2Vy82RU8zN0JDZ2NidjYwTGNo?=
 =?utf-8?B?Qkt0Vzc5OHVzS3lHejBnVXNJMm84aVc4UkJkbERja1BQUVFISEpiZWtPV1BE?=
 =?utf-8?B?OUxrNU54amExS0hIOFA5WnJBelpTckVmQ3JQZlRRK3VXQm8ydkRWbEltempn?=
 =?utf-8?B?YnJsc2tCRFhNZEpDZmlyeFhGakhmQUtCUDdGU0xSTDhXNXFDODNhdHBuUC90?=
 =?utf-8?B?V2pXeUNNZWRHZVI3b1FBYUlhdEVjSjR4aE9XWVJhVXpycUxMQnkyQjBIK3Rm?=
 =?utf-8?B?UzRKUFlhMWl5em4xdm1ZUjVlUkthSnd6VUc3QVRtMksvT1l2N0lVM0hzeTJv?=
 =?utf-8?B?aFVDOGlDcktIQkZqTkRKVnowQUdDaFVrN1pqMldRTFVvMVdYZkp0TVFBRGFi?=
 =?utf-8?B?ZlVsNDhjVFQ5Vy9FL3VXaDMrWlZVNHBCSUhxWSt4SVY1bkhLb2xZNStITVFv?=
 =?utf-8?B?SXgweGZRVkJPMUY4VWVGaXRpWmZqTFk2bllmYm9CNld0K0VPOFZZbmk4alE1?=
 =?utf-8?B?OGZSeHlBRVV4b1NjL0UwaW5BWm55VHhUZmxjcWkvRS9BLzJPOVZvckFPWFYx?=
 =?utf-8?B?dzBralJJUmdVOEU2aklEa00vQ3lDNGIvQ2FtSnFRZkpCL3pFbTRTTkluSmlL?=
 =?utf-8?B?QzhJcGRWRmQ5Z0N6dkR1Q0RVZUdlcFYwUWxKREZaQVdpRlU3ZTFxcUlNdnky?=
 =?utf-8?B?QjlxZ2ZZVHR5bnlkRlU4TStseUtTWFJxRDN0VkFEZmdvTWNKbCsyVlppdGFE?=
 =?utf-8?B?c2pabWRmRkthU0pZNGZxUU9lZGxNUGY2K2RwSU9nK1AzT3Ivb2NFSFp6RE1L?=
 =?utf-8?Q?shyDu0z9STlibuvyHgc0+aRmPkwkglrM6b5PgNe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bb7848-d4d9-4ba0-491c-08d8e3fe6282
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:54:58.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfkpOX2bVN3sSQrg92JW6XUPu8O1cKvxRdWlg8dxaLSyx/+EWhQ3eNgAnURS37K3J25AsGp9SGUiBsNici/I1mPIVYaWLq1GOx53pBPpyRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when adding a single extent while there's no possibility of splitting
> an existing mapping.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
ok, looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/528     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/528.out |  20 ++++++
>   tests/xfs/group   |   1 +
>   3 files changed, 192 insertions(+)
>   create mode 100755 tests/xfs/528
>   create mode 100644 tests/xfs/528.out
> 
> diff --git a/tests/xfs/528 b/tests/xfs/528
> new file mode 100755
> index 00000000..557e6818
> --- /dev/null
> +++ b/tests/xfs/528
> @@ -0,0 +1,171 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 528
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# adding a single extent while there's no possibility of splitting an existing
> +# mapping.
> +
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
> +. ./common/quota
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
> +_require_xfs_quota
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount -o uquota >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +echo "* Delalloc to written extent conversion"
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +nr_blks=$((15 * 2))
> +
> +echo "Create fragmented file"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$(_xfs_get_fsxattr nextents $testfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +echo "* Fallocate unwritten extents"
> +
> +echo "Fallocate fragmented file"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$(_xfs_get_fsxattr nextents $testfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +echo "* Directio write"
> +
> +echo "Create fragmented file via directio writes"
> +for i in $(seq 0 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +echo "Verify \$testfile's extent count"
> +
> +nextents=$(_xfs_get_fsxattr nextents $testfile)
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +rm $testfile
> +
> +# Check if XFS gracefully returns with an error code when we try to increase
> +# extent count of user quota inode beyond the pseudo max extent count limit.
> +echo "* Extend quota inodes"
> +
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
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
> +nr_blks=20
> +
> +# This is a rough calculation; It doesn't take block headers into
> +# consideration.
> +# gdb -batch vmlinux -ex 'print sizeof(struct xfs_dqblk)'
> +# $1 = 136
> +nr_quotas_per_block=$((bsize / 136))
> +nr_quotas=$((nr_quotas_per_block * nr_blks))
> +
> +echo "Extend uquota file"
> +for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
> +	chown $i $testfile >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify uquota inode's extent count"
> +uquotino=$(_scratch_xfs_get_metadata_field 'uquotino' 'sb 0')
> +
> +nextents=$(_scratch_get_iext_count $uquotino data || \
> +		   _fail "Unable to obtain inode fork's extent count")
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/528.out b/tests/xfs/528.out
> new file mode 100644
> index 00000000..3973cc15
> --- /dev/null
> +++ b/tests/xfs/528.out
> @@ -0,0 +1,20 @@
> +QA output created by 528
> +Format and mount fs
> +* Delalloc to written extent conversion
> +Inject reduce_max_iextents error tag
> +Create fragmented file
> +Verify $testfile's extent count
> +* Fallocate unwritten extents
> +Fallocate fragmented file
> +Verify $testfile's extent count
> +* Directio write
> +Create fragmented file via directio writes
> +Verify $testfile's extent count
> +* Extend quota inodes
> +Disable reduce_max_iextents error tag
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Extend uquota file
> +Verify uquota inode's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index e861cec9..2356c4a9 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -525,3 +525,4 @@
>   525 auto quick mkfs
>   526 auto quick mkfs
>   527 auto quick quota
> +528 auto quick quota
> 
