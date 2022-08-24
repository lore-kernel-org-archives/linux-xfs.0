Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C20C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 09:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiHXJXw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 05:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiHXJXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 05:23:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8955283F0A;
        Wed, 24 Aug 2022 02:23:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O7uRCd024822;
        Wed, 24 Aug 2022 09:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=onCeZ2Kj6cjRMKFqUS2jgzalBiqs2dQJ015s8s/X1hY=;
 b=w1QmfloXj/HUOeUI599QShrlgz35l/HJATi91Rf3ND01lnxHhA6y0flcwkEvuXuUuoAJ
 IGjXRlHsBqk29WQVdwNrc3XOoXCwHQtyHvJ8mKB8A8LJnicM5E7TGwHB4yLHww4CEwGG
 QFiL+z/P0YJgowA1pyXmU6w21YtPnZpuQiFhxcvdTDWf8VPWuOjWv+y3NR+9Jv5aYcos
 MBer1QvgMv+SSwM8seLBP1WIFU7hL4DzIJS2kF1ZdJtbvWEO2/NUONpPcORaj2jgvWP9
 7FT5yokSRJ6UZC95rL76vGzUqjsaUDh/G+n8uKIqfw27DuaLfpnKTW4gl7iNqvYeQJic Zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w23txv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 09:23:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27O6w6PJ012118;
        Wed, 24 Aug 2022 09:23:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn47nf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 09:23:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/ILPxRcaXDhdu8hc3sYzvo9Jo/jkzfjFPi7mg2nvsEiJNLghPOp2Iq7yNKUBDDAjwTG9NfZYD+6L9TcXLMixUAbZ6b21I1JJS96BQimFB2OfqjEMtXqMxuuy0xm61r0fqh5C69/7E3coJna1knST0I5R0lPpP2a5zaJ0lFMTSxlpVdg3nB0awOGmvhTRs0wslqwHT2sT0vYEPRQJOnlMat8Mzoc7OnZJIshc6zbdAongw0FecPGr9CzKSyAViDoCwsqqgVN1pUZUl9NcmkbqucTlSRZV2KgurHC77KZVPzj+lrdstchQ+Yp57Lrjm1h1V8eZQSCfivJhUfwUdsPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onCeZ2Kj6cjRMKFqUS2jgzalBiqs2dQJ015s8s/X1hY=;
 b=DpDUGoJrtTiYnvVHQ5sHBzVXO2F3DBy8gxZaZTysWeS6usi2AT3i+5tDkqXY/WUmhzFyiGm0uKbbatlGhsOvyXMUx1gLKvCDC9VaNhMW+6unpZ/3M/Bp4aS+vLnriF21lDV0GtRf+KybbK4Dp0Lv7fobJWvqk2+3LB+WVL65RRrLU4n+YtZdBubyrV5xjPhnfGmy4cG95OmAs8sxR13DpzMDRhEabha9ai52V1u/JP7EvgXMI8cP4lhOM9M13Q5m4XNKgdjSEAHZJfXe3zn2X5U7HsFVXuRNqGKSLEk/b1o/1v7tEu1oTdf6BKnMZtHdr9XAHIIOFTts7B7yPVJhqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onCeZ2Kj6cjRMKFqUS2jgzalBiqs2dQJ015s8s/X1hY=;
 b=kNbQH1G3KwcjQYbT+G8cGL5wwkMjJ3UIuNJrEqg2lqn08EgTzjwlEIGzKQfDEsa42KgxRKSI6g5RnUUEuwfP8g9z/4ZmP/CRNbygDrtDyuA+HJadLywUiVMO4qpyy5xjpYvCnaJBwBL0hls1HLseouUmalmLPA9nUf+tJLBtMu4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5662.namprd10.prod.outlook.com (2603:10b6:a03:3da::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 09:23:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc%7]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 09:23:35 +0000
References: <20220823090433.1164296-1-chandan.babu@oracle.com>
 <YwTkDrlpzPc2TXDC@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Check if a direct write can result in a false
 ENOSPC error
Date:   Wed, 24 Aug 2022 14:52:20 +0530
In-reply-to: <YwTkDrlpzPc2TXDC@magnolia>
Message-ID: <87pmgqdmgh.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:404:a6::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a459bf79-d030-46b5-7752-08da85b25225
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5662:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ea0MwjMC2JhMotqLSTyKCJYtmPA/bkSuVF5NoanDAGGybbkceKhu/L5IypBkfX+vFY4Wi23hOv6gEBLHDIZuLM5uxztBXkRJmU+DK0LBP3abdWJVEPQi/aLPotQZqYRphtPNJGtseWj0gC0RX4rEGRQa412ibJaZnkl8SNM8sv1MMXqVB4rBjKjpl1546RYX+Q+jvmU+zobEGPBHRkcxsTja8a88OPxmimZny+WpYEqr8vstICuvtmDNps/1IUsMyHTtDgCkWeC9aRvMD+oOX5S9JQXlpVQ2yGZrSH50/0toRLWbOLsfWXJ99TNhSnzQacBWuOkSGmlCJ4lpYpzABbryfcI02AIZ2eHXpzUzX2x8Pl4zzR0t4Bbh546UAzp4l1H+xoDe5s4fuQUCU/cFLPIv+EFKt18VRIszTQYvQq0DmS7L8PxFgBzxscKcsiSUK9aTbWRhm9/dMMn9vaJUiIgz7OqIHqInnyDSvS2nCuofChf1lVYqHWqz8cISW5cqSKclobgAIhNGVK+CtvqkxDubSNtX5GPEbs6i+iNRXpwMWKg9io3fvrMLT1gZXGclKTI2gYIrnsVR5vGU8IIg+g+UDj/D0pZLytYuUnoH7XbbV6iu5Y8ycPzRCYUsuzZXSz6kZVEeiNuXjUqxpuxj2SN279IGAEth0n295IbJM/KCj0bjJ9BWokwZ9Ci1nMrF2LuNTYYDI3B2mQyl6SJd1Mor4iIjSZstS45lyqJb5IQsYcahKp+0MxTi4Cv9C386
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(346002)(39860400002)(136003)(376002)(366004)(5660300002)(478600001)(8936002)(6486002)(41300700001)(53546011)(52116002)(6512007)(9686003)(2906002)(6506007)(26005)(6666004)(86362001)(38100700002)(33716001)(38350700002)(186003)(83380400001)(66946007)(8676002)(316002)(66476007)(4326008)(6916009)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p47bloSSf45yJD22VaNATHA05bCIEogFG+MiypKYS8N0ySrIR1LGDWawAfXF?=
 =?us-ascii?Q?ma4Cwdi2m/yifvO+E/rpKcaYXVCkc40YPP2cVmDU1tFShnRiIHKpP1VWrDkv?=
 =?us-ascii?Q?TMKGykEwTYdSCqKZRUZF4IjEv0uckWbNpwZaGye4B6aQ6vsW+fJeQrvJ3quu?=
 =?us-ascii?Q?a20Jq3ucvZ/+zSdeiRwPnoCWW//X4HAJzM5rVcYaW+fS2PuNYF5cohYpMHzd?=
 =?us-ascii?Q?6EWe0N7IvHwtXlT5GAilkQnXIGTwhz9K3poglvhAebVJ2G5dOKylfAmj90E4?=
 =?us-ascii?Q?WQWEUVwRqDe/BgHq6fcpOLVNXj1wK4rxrJQibJHjBs28Fzm5eog176v3t4Va?=
 =?us-ascii?Q?7GPUll4y4gWX+sUVj2a9TpDEyrhSoaMxxD0Djxavvv7wXN7l/b5unmT1+i9m?=
 =?us-ascii?Q?wpzf0fXZCt42gfcZNv3xIOECtx9T5Iwy9uOGk84WYlbTv5hxlXhERM4dPutV?=
 =?us-ascii?Q?7TeLuV4YWwVsVBJakaFzhVMNqL85Eg+RxgjH/X5EsyNoR3S3/gqcF5dMLOdf?=
 =?us-ascii?Q?EJ0LvOl0XfO63NXGI2XanREDg9fWu4XS10NwqP6WET+bFVSMpEF8n7se0OBY?=
 =?us-ascii?Q?mm28ZUJrwuwIftcViqO6opO947pDWhrvVHWEMbeTQvG4wzYMUtCD02xUmoCp?=
 =?us-ascii?Q?SPTBrgaWkW5YVTte5x4IxQ9fKzdRWOpVqIo54V8qowi0cUeQy1U6XdG2Deue?=
 =?us-ascii?Q?I5f6n9jf7TsqpnKmLF8//n0nsWXrHpspOpzmmNZzOYjGyT0i/NWcr6lAX7Zn?=
 =?us-ascii?Q?aG0u0TE201IHWTxSy3Abo2Ck4KghNEFEcCcbxornTGgDacd+9jd+q+ubOgSV?=
 =?us-ascii?Q?PS3CpfmCq86YWxTMo8YqgLglPcssu4I90bkYz6bUBegbQ6ioWbq1tXhO9m9q?=
 =?us-ascii?Q?OddMhB1T04pVlaOLChLktvFSfxI2dS+WcooTxZAuwbPTEcSJH4NoXzWQQima?=
 =?us-ascii?Q?wfHemDeGhnxpiQ4+qpqdOIdFcEU3kAnjDEt7j/wCkA3BngB3HiWyYn5mz6F5?=
 =?us-ascii?Q?7rVrYEzNYHSi518hRYPl0vgRAwAzvrVZwSJsM2Mr+njt6WwB9bXEa2oltU0w?=
 =?us-ascii?Q?1zqo0956QVefhKqeXCvAaa+RIbQijj7CyiWE6D3Mz2Sx6jbRo0pUgLhMUXE3?=
 =?us-ascii?Q?F/It2HiBUk1Sz1D81LsFf024rXHEcY0ltl0HOMPFMZ1GV9+pYKXuzj7LeDI8?=
 =?us-ascii?Q?+EHQj0A2XyecZB8ITr9IOtb0nuixJ3L79VAGOt7jKoVFV/V8Tm9GDlk5JMe6?=
 =?us-ascii?Q?zYjJG2ynY0qFteMRUdmt9FXJUckMJflQXJaEv6yqo97/GonbrYrXb80e/Ish?=
 =?us-ascii?Q?Q4/yY1Vl4qKsFwSot3btRhZBBKGjnj5o0JcOzlOQV4UVG2LCl/18gEIz/62i?=
 =?us-ascii?Q?VSLwpU4OLvtSxs8AdLYfYe7GFABZZrEWSYvu8K8azSv1UOvhS7OAAE3owHKb?=
 =?us-ascii?Q?1jjEqv71hoFBTPNktVGLyodJR21IMGm5A8e83W/GMANuV8CIp4NYVXWj/hut?=
 =?us-ascii?Q?xeJ7/CowR6x9PjV/TswSS3vxvH3t+YMATTMDymQaIP4Ihp4auAkE9wSt4QNE?=
 =?us-ascii?Q?EXSiDIFKX57pBOm52ns2Tdkfr90gvg9Tpv11XY1H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a459bf79-d030-46b5-7752-08da85b25225
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 09:23:35.8330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJpJ8DSPMNtTlUQDct2b6MmOdEYTTAjPzLy0/1XFIKptoLzoxvah9PyFaON7rTJ1TXHaO3jMvHjT6y/qgAOpoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240035
X-Proofpoint-ORIG-GUID: UILCQeq7BdpEbAHH48Ts02CUhipPYsfl
X-Proofpoint-GUID: UILCQeq7BdpEbAHH48Ts02CUhipPYsfl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 23, 2022 at 07:28:30 AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 23, 2022 at 02:34:33PM +0530, Chandan Babu R wrote:
>> This commit adds a test to check if a direct write on a delalloc extent
>> present in CoW fork can result in a false ENOSPC error. The bug has been fixed
>> by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
>> direct write on a delalloc extent in cow fork").
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  tests/xfs/553     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/553.out |  9 +++++++
>>  2 files changed, 72 insertions(+)
>>  create mode 100755 tests/xfs/553
>>  create mode 100644 tests/xfs/553.out
>> 
>> diff --git a/tests/xfs/553 b/tests/xfs/553
>> new file mode 100755
>> index 00000000..78ed0995
>> --- /dev/null
>> +++ b/tests/xfs/553
>> @@ -0,0 +1,63 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
>> +#
>> +# FS QA Test 553
>> +#
>> +# Test to check if a direct write on a delalloc extent present in CoW fork can
>> +# result in an ENOSPC error.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick clone
>> +
>> +# Import common functions.
>> +. ./common/reflink
>> +. ./common/inject
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_fixed_by_kernel_commit d62113303d691 \
>> +	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
>> +_require_scratch_reflink
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +_require_xfs_io_command "reflink"
>> +_require_xfs_io_command "cowextsize"
>> +
>> +source=${SCRATCH_MNT}/source
>> +destination=${SCRATCH_MNT}/destination
>> +fragmented_file=${SCRATCH_MNT}/fragmented_file
>> +
>> +echo "Format and mount fs"
>> +_scratch_mkfs >> $seqres.full
>> +_scratch_mount >> $seqres.full
>> +
>> +echo "Create source file"
>> +$XFS_IO_PROG -f -c "pwrite 0 32M" $source >> $seqres.full
>> +
>> +echo "Reflink destination file with source file"
>> +$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
>> +
>> +echo "Set destination file's cowextsize"
>> +$XFS_IO_PROG -c "cowextsize 16M" $destination >> $seqres.full
>> +
>> +echo "Fragment FS"
>> +$XFS_IO_PROG -f -c "pwrite 0 64M" $fragmented_file >> $seqres.full
>> +sync
>> +$here/src/punch-alternating $fragmented_file >> $seqres.full
>> +
>> +echo "Inject bmap_alloc_minlen_extent error tag"
>> +_scratch_inject_error bmap_alloc_minlen_extent 1
>> +
>> +echo "Create 16MiB delalloc extent in destination file's CoW fork"
>> +$XFS_IO_PROG -c "pwrite 0 4k" $destination >> $seqres.full
>> +
>> +sync
>> +
>> +echo "Direct I/O write at 12k file offset in destination file"
>> +$XFS_IO_PROG -d -c "pwrite 12k 8k" $destination >> $seqres.full
>
> Does this still work if the blocksize is 64k? ;)
>

Thanks for pointing that out. I will convert the script to use file blocks as
units rather than bytes.

-- 
chandan
