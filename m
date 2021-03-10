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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEC7C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFCA64FD3
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhCJTz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:55:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbhCJTzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 14:55:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJmxfl160186;
        Wed, 10 Mar 2021 19:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/3QeBHiy3P0+qW4gx7EafMrJsAfCDzpH1PEDTuHxfzg=;
 b=w+JzvVMHQOa6NWVQXBRdJXOl8C33RsZmSIVYPqVPnr3Y8rgLvgvn9DlkV+jZPj2e0ZOk
 9xgsRoJeexrAe66/HnloljDyITCwkBW7XdlbMHFYKpIHd339C7+U/PGr8jUcSEtfj95k
 A3lyBY+GMwEYZxy3zHxvGBoUUDXUKqkTJN/737AmUwR7NKBYFv3uH4pnKApjshMeExkE
 f2BI95/qTlEY0gsifxe6eaTbpmUuQSjM4Ybzl6k43azEs6g7QhTDZ20sfMIvning7qlT
 1ngVPYNt8eSayTzrz4aczG9kXKmx/brrLVu7tpa9ABt5hUpWLOTFnOijVl6tYTg5ZBL7 aA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pmm9r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12AJpSHM109199;
        Wed, 10 Mar 2021 19:55:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3030.oracle.com with ESMTP id 374knyvg5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 19:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNEJsTs34+L1BTvw3eQlho8zd9cfmsXatWd7JcRpPcaIJr8+9fEFV/n5uuzqqcFBxpF+UB5/Kvt8EylLUQqr6EQeGJ1Aaoz29JrIPSxQLqE/jRv80cLPpdQH398XtGaHvPVz9lOH5xe9wlA1YryOE1nai7bzLmgFVuDn1n0T/nA8HUEkJe8exVWcPr2UZeBq0tu5A9CjvbcdcE5+zbOXNbeFWal+OY7r6JFVGzgOMshYcfb/MErj9p65c4e5xUhLyn93q31ZB1+X3vaGLkkc8GQWcjHFHAJuiKxPF8/CB7TDskx4sJbUAe5vU+HJjngJO/mDi2iyRrmwgKuh3Jyd/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3QeBHiy3P0+qW4gx7EafMrJsAfCDzpH1PEDTuHxfzg=;
 b=Lkaon0jjokqHAJwJSkrwmOFcpbGpqrsXl1irwgMovnjPgXFY5veIMQ7pMhQ+E0DXMF6l4ct6XHfhF1wEDWtGasUcK0VtNe2q+RZloEuIpOlz+iDipbtGb/uIyqcWoCuPCUa+AqXtBTuVo3+GsJL0g3ElprFWXf9UXUHcxl37A/dBMSwxd4ptkUkXe9mjWRCdwQzgxMq/rGis65uzpboXiKRGH+eNH2XR/8ucOgJ5Vir+S/FDZc/vUBcgmB/Tcqtf8RHZkalR7e13BEjwLasp6oU4URG8BYs3KqR2urqm43YtmT1aDYwYda7XLswdCnrzTUX+oRWXsNU8wmdK/ZHC7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3QeBHiy3P0+qW4gx7EafMrJsAfCDzpH1PEDTuHxfzg=;
 b=VP/4ylJLKzzly4qeiwcIpu3/QjCHuK/M9MWPlGcC+D1PGyJwc47+WwXRB2eZWM6WFFNAyd/PZebRCFEj6x+9z2uHkRr4Yxv6VHIvn2zghxGkb9xApqE5d+69motnHLyC+MJDZXHq/Woee2gg0H4gbQpndKQ1x1+0E1/3/LlfVrc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Wed, 10 Mar
 2021 19:55:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 19:55:05 +0000
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing
 realtime bitmap/summary inodes
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-6-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <dde8a1f0-73cc-c858-cb31-905e9ab53b58@oracle.com>
Date:   Wed, 10 Mar 2021 12:55:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-6-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0304.namprd03.prod.outlook.com (2603:10b6:a03:39d::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 19:55:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc77d910-ec3b-4064-729c-08d8e3fe666b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3509145ADF5FA84BED6DBE0495919@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5bQlTcN/t4fLn3TNcCo15oWFOerxmXWCWmO/PKKDk1f25gCaZh/FXZ+5uTk5aBUh8QuKoWZDR/BdB/nTKFgwsG9OTbHqu5bgLII8o9dt5sn73tO4qx7zYsmv907+iXak1NeCqg96H5gVM1SH//Fetm427hK5zFrA0izzTSP2U/TU76io9DM52gz5sQs3gzDsPT01T1x8S9RhGqNsvpgDMFKecS3IjFgJb2SlhmW+P2QSP+k4yNRNhOv63Zjbt0g633C6fKlzQwv4J2sY7cPMGdtV4g5r+twYGkFzESYjCbbj3ZvaL2JSruaZ23iwuKnMyT2kkAA5cW/vdPfLlweel2WIMuwCRc1GSzzDBkxAm4R1GN4GEzIvvplYnc2d3zFLGqvxFgau+spSfLzMqW7hqstN9YkDa5fGm7NTsoCvmJl63TWDrAY5I8oPEGQ17iFz2dWYpa66FFY4LtjHb4Z+rCGbmp+QjwC6cGeFOXkOxd7ABsCZCIFCd/HnvH4iDIxzoVD+UJRsihShSs+ZB+NYEfflh4jDORAYsAa5JV8YjYQ0zanEHJWfYmDhP9aC6PyCyMC8sMkjHu2ggkbga2gSspxAhd5tuuI35aT6O/MQvM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(31686004)(4326008)(16576012)(316002)(44832011)(186003)(86362001)(31696002)(2906002)(36756003)(5660300002)(2616005)(956004)(26005)(478600001)(53546011)(83380400001)(66476007)(66946007)(66556008)(16526019)(52116002)(8676002)(6486002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eE15eHY5eUZLYzh5aDRJNHZleitRMjdwbmxxODZiTW5Bdk5uKzlPaGVNeHc5?=
 =?utf-8?B?azBTM3VIdjEzTEMrWUFOZVVlWnl0NHNoS0M1WkJPNm5UT1FRRXliZGIzRGpk?=
 =?utf-8?B?ZzVuSTBJN0xJUzV6bk5LLzI5eDZSRXhUblZ6T0F3VUlPNnZXdWRnOENqZW4y?=
 =?utf-8?B?ZlNDN1EvZXhMU2Vqd0tMVTgvSkRmMHJ4dU5yTlY2bVUvZWljS2h2dzRtSFZj?=
 =?utf-8?B?T25WRm5QZlMrMWxIaEl1NkZ3QnlRaFNXSmVTK3h4VFkrV0lxZzVFOXBFNXBZ?=
 =?utf-8?B?VlVoNGw3THV4Tm02MjAxTWRVVlpNbzI3ZkNRMGsyTnphLzhkM2p3cUtQbzZY?=
 =?utf-8?B?M0RRWjhrU2FCSWM2VThpM1FnN21Xd1NvS3JGTkpxc2wyeU0velp0L09Nay8w?=
 =?utf-8?B?WGduZ3Q3bS8zSkFtSGtDaHdtaGxxZVA5ZHZFYndqR3JIRTRlMklOTlZQS1Nl?=
 =?utf-8?B?eWFLbWZJNk9QRjd1ckp5Q2pZUXNmRkN5Q0ZEY0dLaG5SdzlZQ2c1OXZPa3pL?=
 =?utf-8?B?Tm92M0hjdUIvZW9EbjVEcUhvd0w3QlZEa1Z5aHY0SGluNk84RHYyWjM1VEFD?=
 =?utf-8?B?S3FRK3Y0Z3Rmc2diN2FRSVYrcm1qMS9BVk0wbVkrUUdYSkh6THFrM1hRMHpL?=
 =?utf-8?B?dnY4elZhVi9mYktxZFZCYVJnWVZNK2h3ZFZIWkExU054Z2I4ZDloNUNWT09W?=
 =?utf-8?B?cmNVODUyWlp5VmZpcXYyaitQNjREUDRVSUp4UnhoN1VjcW9TOFh0dW1JMVVL?=
 =?utf-8?B?VHdnTDBQZ3BHTmJTMytMWDFUSEYzM2R2T3Zta1FBNDBJUk1GTXF4Q0V2Y2pq?=
 =?utf-8?B?NjZham1JbE5ZN0Y1MFEzc3VKWXNyOFV6clR6czNhRXdsdEV0TU1YZXRjZWhP?=
 =?utf-8?B?Njc2VExMVmNrTUJtWnExVkNuWVBveWdYSnYwUXZiVnkwQXVXRTVsUDdJOG1o?=
 =?utf-8?B?dWZQbnlQdmFVTFloWFFpdzdhY3ZjVzg0SU44ZUROSW9ra1RhbTJ6c3ZVWGJN?=
 =?utf-8?B?RkhJbE1DWjI1NHN4cklTcEhDRzJmYnFUNk9NODduTlZKYzVuSlMwZjVZcWwv?=
 =?utf-8?B?U0RpSkJJWWRGMGpyalRhOGdwSksxdjlSWm9CUWhLUzlvNnBZd0M1WjRkdXJW?=
 =?utf-8?B?b0dGVDBzak5qZHFZWkFkMGkrRFdLeVVUam13R0xVUHEwM2svUHhVeWh5akdW?=
 =?utf-8?B?RnUxQTNuZ0dnd2FTZ1BsQmtZSGVSWjJpdjRWc0FObXFrcXM4T2pXNTIreVhV?=
 =?utf-8?B?aXhQTVRJVG9oTTQ3ajJ0anB4RHFNQ0JVYTllMzk5L1RNUzV2Y0ZnMXo2enBy?=
 =?utf-8?B?aGdlQkovSzA2TFRSOENNUXZlTmhXbW5wTzNVRTZaNzlZWUkvWmd0TWJIWlVY?=
 =?utf-8?B?WW5Bb3hWVGh0L2FaYjFiOStOTkNCQS9mcGFqNy9WOTJrcWVvWDRBSWFqTDlv?=
 =?utf-8?B?YnpxUTlSRGY1Y3NoT3NiTkM5dDlaT2F0KzZXVVdiOTM1RzE4QUhhc0VzVkZU?=
 =?utf-8?B?UEExSVA0Mll5dVVWK3NKTzRHWEhGd1d0ODVjYUt5YlE4MmRPOXBiYTdRU0ly?=
 =?utf-8?B?MHJIYWdtYmQ5VDg1Z3pyN3pVeUhXWG1MSzltWWg5czRBT296NlQxTkh5WENz?=
 =?utf-8?B?ZWdLb2pycmxjdnAyalJTTG5aSFU1eVFEM1pRNEZwdENaV2NXOFVSNFVZS3B1?=
 =?utf-8?B?K0NuTjdxeVlncGdnTnl5bGlzd0xINWFaSzdvS0pndHhNNmpVME90ekZ0OENl?=
 =?utf-8?Q?uZCubk4RLqBijii/Hg2ZUmWpIy3yxL4ERVU7QVJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc77d910-ec3b-4064-729c-08d8e3fe666b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 19:55:05.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O+fqLbZJKwHkt9QMT4l0iYK4QUntei7bojI6N6INYSGx6eTigxOFc/GDUHPuiaisFTyWHiMsAWPBlX0yrc+wqv/ZLA/MUiY/PHWp/xNBAAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100094
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> Verify that XFS does not cause realtime bitmap/summary inode fork's
> extent count to overflow when growing the realtime volume associated
> with a filesystem.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/529     | 124 ++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/529.out |  11 ++++
>   tests/xfs/group   |   1 +
>   3 files changed, 136 insertions(+)
>   create mode 100755 tests/xfs/529
>   create mode 100644 tests/xfs/529.out
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> new file mode 100755
> index 00000000..dd7019f5
> --- /dev/null
> +++ b/tests/xfs/529
> @@ -0,0 +1,124 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 529
> +#
> +# Verify that XFS does not cause bitmap/summary inode fork's extent count to
> +# overflow when growing an the realtime volume of the filesystem.
> +#
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
> +	_scratch_unmount >> $seqres.full 2>&1
> +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
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
> +# Note that we don't _require_realtime because we synthesize a rt volume
> +# below.
> +_require_test
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +_require_scratch_nocheck
> +
> +echo "* Test extending rt inodes"
> +
> +_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +. $tmp.mkfs
> +
> +echo "Create fake rt volume"
> +nr_bitmap_blks=25
> +nr_bits=$((nr_bitmap_blks * dbsize * 8))
> +
> +# Realtime extent size has to be atleast 4k in size.
> +if (( $dbsize < 4096 )); then
> +	rtextsz=4096
> +else
> +	rtextsz=$dbsize
> +fi
> +
> +rtdevsz=$((nr_bits * rtextsz))
> +truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> +rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> +
> +echo "Format and mount rt volume"
> +
> +export USE_EXTERNAL=yes
> +export SCRATCH_RTDEV=$rtdev
> +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> +	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
> +_try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
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
> +echo "Grow realtime volume"
> +$XFS_GROWFS_PROG -r $SCRATCH_MNT >> $seqres.full 2>&1
> +if [[ $? == 0 ]]; then
> +	echo "Growfs succeeded; should have failed."
> +	exit 1
> +fi
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify rbmino's and rsumino's extent count"
> +for rtino in rbmino rsumino; do
> +	ino=$(_scratch_xfs_get_metadata_field $rtino "sb 0")
> +	echo "$rtino = $ino" >> $seqres.full
> +
> +	nextents=$(_scratch_get_iext_count $ino data || \
> +			_fail "Unable to obtain inode fork's extent count")
> +	if (( $nextents > 10 )); then
> +		echo "Extent count overflow check failed: nextents = $nextents"
> +		exit 1
> +	fi
> +done
> +
> +echo "Check filesystem"
> +_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> +
> +losetup -d $rtdev
> +rm -f $TEST_DIR/$seq.rtvol
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> new file mode 100644
> index 00000000..4ee113a4
> --- /dev/null
> +++ b/tests/xfs/529.out
> @@ -0,0 +1,11 @@
> +QA output created by 529
> +* Test extending rt inodes
> +Create fake rt volume
> +Format and mount rt volume
> +Consume free space
> +Create fragmented filesystem
> +Inject reduce_max_iextents error tag
> +Inject bmap_alloc_minlen_extent error tag
> +Grow realtime volume
> +Verify rbmino's and rsumino's extent count
> +Check filesystem
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 2356c4a9..5dff7acb 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>   526 auto quick mkfs
>   527 auto quick quota
>   528 auto quick quota
> +529 auto quick realtime growfs
> 
