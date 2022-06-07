Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5B4C43334
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 09:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbiFGJwz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240333AbiFGJwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 05:52:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D8BED8D6;
        Tue,  7 Jun 2022 02:51:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25799bsL007363;
        Tue, 7 Jun 2022 09:51:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L9KzNTOfVTKLNd7QrOBVWQOJZVM/voAfYR+zM+CvU0k=;
 b=rSTLta1OZAJJQYpKIVVq44p5hRrhK/RNopDiwWpEi8WWqHYeVuCG9oVVjdtvFVspTtRz
 qjN2SovKIUEnVveI61Gw3oIa5+ZTqgAurjLr8GBeeez4rfZTET91UIitIof9ba5IU5/9
 IeZBMwacN9PNupzP0xM7NJBclAd3DitKqEoA1PgStPWfLkBpMAdxNMgzKbEuAdeGggKz
 A/l60m+m6xsiFewduaowphJEyzXEFAH6FEX6atMmQkpNRyY/xmjx4CwJn95wsfBxuvoD
 4qB7hy6hVBWgkz7Zp9ZngPW83jxSDF/st9nFfpnciWwfdJl4K+Lc5MZxewpeisRCW0Gx CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqnahj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 09:51:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2579g92h037421;
        Tue, 7 Jun 2022 09:51:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu2gg33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jun 2022 09:51:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyAqsWlRpxS70CZNdwnDxL7xuJ0TJrq0fty0XzNlJd6F0/sxr5MOiPhzyFTUg+vPg9G7TUcgbXXqD4R8HLbLkqTGwjxGmxZ6eOh0pmu4+k8LzvOxT++Au+tC5Al5wIFogZJ6FEJJZ3+8mAOeIwbeYwPGr1ko7g16bROo42KIozf7qbpi0EB4drLWztsArC+C/j/Q3D5MX9fa4PBgyEtLdeF1P4/h0ihg+SOCvY/Wp1r9fPLszCApLJrUvT/y3c52bRmLYVk6H3vBpLPDS/3jcBg9bQzsJrlWfciYcfU6QhTC1Fbdo32VVyE3hstR09YOUzDM0EzaTY4Xoonrpp0H1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9KzNTOfVTKLNd7QrOBVWQOJZVM/voAfYR+zM+CvU0k=;
 b=ChuxJOkE36i67HUjLJYrdhsRAHa6S0U6IAe4qnyW3kR5VHKDfR84P/9ol9X7Qt6seu19FDZXRozMuzXTV3G0UG/j6K0h7rj9XYtSLSOWFnQB1EXcR6rG51wtn+n7ZAguK+W1/BGK931uEqO8j710QsUKalT9uBrHZRiWWb9MrpfSMbNvgLzNnsHzfLBRYgRu2BthG5K8eYvqTGKLRUQUYpLX7P+QezQiCQeaGbpd4IILBMMwfdThVXnnuYyYSGfXv6lhOTg+KluE7/xu6KheNSC97vJBSOQik3ieV6aISj1ce4W1K14bHHEITfBZY1PEkQeVPTJI/lKIbNc2CA0v9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9KzNTOfVTKLNd7QrOBVWQOJZVM/voAfYR+zM+CvU0k=;
 b=wf1UC3BonEqpoq55SByGhlM+s1lpXq7fQt4yI3F/6DO3LF6VvZ+FFQTOFI/vcQUiUUKlu0uslNWYxHtNSVojDFke4jps5YLqOF/wP8Pj2TgHUCtnpGiGyLC2mUUFXyPYUy/mId+CqUJb7+XINn1Ms9ClOjOP1oYiWQ7k79NNHgs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH0PR10MB5180.namprd10.prod.outlook.com (2603:10b6:610:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 09:51:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 09:51:06 +0000
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-4-chandan.babu@oracle.com>
 <Yp4f/yalwFunfEgz@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/547: Verify that the correct inode extent
 counters are updated with/without nrext64
Date:   Tue, 07 Jun 2022 15:06:58 +0530
In-reply-to: <Yp4f/yalwFunfEgz@magnolia>
Message-ID: <87zgion6nx.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2463aa6a-74cd-414d-72f9-08da486b3dc4
X-MS-TrafficTypeDiagnostic: CH0PR10MB5180:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB518095F9080A64C54133226AF6A59@CH0PR10MB5180.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+632LAicGvSGxvv68F8tuMq84EL2+pCp1BMdm5+0NXN4ElQjTz/q1+5gMUeg1DWarNB4Gc28n/GsW61Pz7Bjzv8d3FaG33mcSppf/cRB7VYl+Gfa1/B/a0W71IivgA69AUtUH4BgP7f7QIgXFXB0LImKyVcs2G+VxgZiVylGB+y4CCl9tFcAkAtupR0Uu5cbepgnA9VJwnxpbszDZYCur5OeagLUJYbGIT6Fr8gQ8AGPt09GT/bnJAAAPFSaw/PgXbhe5Md4kUOKqCPKDH4YGEBtZJ+RNDJEKLe8hlfnF698vtXIiLdxi7kn0zTd/vQYklseI76tyu4Ts6esVgwLHZPmHUT1vryUKzV41MvToEyj/kQE9Ajab9Z1pDGFfVyF0zIyxd11wCL8732+bWPMW2OlSe/KDOcSJquyJsdTzgOgtcGpZ8+deDgCmmAvmE161Nc22bM76TUJbSXbsCQmQr2zT9et2XcvncZHLI9JdYwykWu4Sfl5BApNA8755Ej1bRrAMwi4HBRjzhkr1TEQERPkGEtdS+1Ngs/U0BlE4kIvtfWEnbOV2nMjSQmzBOsqU9VxSELDTDf9xjpsO90Flvec8t0ddYDgI9sJulxD5Pn8NkL1KD0X3l3u6YlTVgdUiVApSx2FCH7qc+YwduuKFpg4c3ZL5k87It4za7HXcSF+BxK4unlMfCtIpQuo8l1neFmAK0fsEV9G2VCAmUorg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(66556008)(4326008)(8676002)(15650500001)(52116002)(2906002)(66476007)(6916009)(86362001)(33716001)(53546011)(9686003)(6486002)(8936002)(6506007)(83380400001)(6512007)(26005)(5660300002)(38350700002)(186003)(38100700002)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4VJ9heA4qbKlaOmnBDytYrU2dq1IX4yJ7n5q/HEm6zt/CxIE1W8eyPAuPLVj?=
 =?us-ascii?Q?Db7+T2b/PTkcxb7+CS5CLMQJHnjqBa8KOd8gfDBXCpGsn2eNILCOwVB22kPP?=
 =?us-ascii?Q?3v4S4Cm82YispsFZv/t21HCrbhDYp8Sh7OzgNYojTMUd1gsY1u1069Byz1gH?=
 =?us-ascii?Q?6AUihwNWyoK2sighIkgQsEGvksL4LQgod1GOmKaliFnF+IQSUHU34n8k+ET/?=
 =?us-ascii?Q?QCjHMD/egIoyxyhs7VhoSWYyoSWwEZ+zhvgKSUgMDwtJvqn0yvq85hdvABTq?=
 =?us-ascii?Q?YbRWo2aLQoHBJ0xd4VftrE6a+YhHc2nwOjaeb6ISJIFRNbQ0Vf/EtGWogoeh?=
 =?us-ascii?Q?U3UVTcGCdve0v62wt5gmDjmNKk0QQrAcYmW/gS2O9xNaeVB+8NqVE6GYt7m3?=
 =?us-ascii?Q?22qcN/iqrMzTeTKnXvT4XFLXM0OCVkxXphnl2rAj6St8FgFFLu4lxqUa5/Wy?=
 =?us-ascii?Q?b7j9VE+LqDtgjoR+IFUQUxPwmAag1K5HJS7X/0qepxjYEYEy/+OJfvONZrkT?=
 =?us-ascii?Q?ccOMcWbBqd9Gs4cuC89sQl27EH7ZUloY7y52FRDbsuzCfeXwh8lgcV2Q6cs7?=
 =?us-ascii?Q?bQHY4O+pOPG/4V/sPUTf0w9X9tY7K2YOUREdAUvlSZ4DIEj0iBM58B2Kvb6A?=
 =?us-ascii?Q?NrzjrmChqcZo21coo+YmBRpv/zug/qxqTZho0IKjeztJGJrDBJAYUivl/p+X?=
 =?us-ascii?Q?0u3lfJIrZVp+MM6rmYWLNobtw7VAxCp243W71v8BwH9mw0pRO0LqZzWjgFYP?=
 =?us-ascii?Q?qRW6oPQMM8KZCNyUPZYipeOMbi+pNN6Am8YygH4kJMb9fqOzlL77BkVMfeAQ?=
 =?us-ascii?Q?WUb/ONntOimiGCMiEtLCHe8CzwTgA59TYoMhy186SxH1nxh0OEYJ5QTEz+A0?=
 =?us-ascii?Q?8TW104khEJkH5fU/ek5fmNwnWsJYS3D+DKRM+Vw6hihkA6nvikbqYPInVhNd?=
 =?us-ascii?Q?Wg86JpzuhioTr03bf6YGL/nivAnjUyvP33L/dxerpLfpp6d9q4G8IIRLmwes?=
 =?us-ascii?Q?oY8Q/7p+aVVXhA+UtbZzc9XSId29QFASXxlUZBPS9eWyLD/gpnDXqrQPhXdQ?=
 =?us-ascii?Q?C2g/4zx9C/LF4T7yzwvSLFVxy7ykFCLq5O2Ux5r1Hy0W5LEt/4MST5HMR0+l?=
 =?us-ascii?Q?wXWfClSu85kB3zK0BwMFIZn2QGhIOh6+PaVhFx2F6toZg7q+pBA6NiXAuS2p?=
 =?us-ascii?Q?9snscLaRLkW1XP0INM9OQbYRlSENpnm4Ffd5d63C/RpnInPkS/gR0jyD2QiD?=
 =?us-ascii?Q?ePd8xnUPel8/AoV7WNoYv9g8Hw2I5YWQBSJvWKOQN9KWKQ23UwydLJQ6V2b7?=
 =?us-ascii?Q?+IgNKsei5QAmCIqOnsKfR4Gp72bURWpla0ZbvrOQb5+8D1Pvgp/5bkiv0Evp?=
 =?us-ascii?Q?nnvAFF5B5Jh96Ob5DE/T8gVacc7Got18TNf8DrGhVXUCIY8C8g2wyYM+gmSo?=
 =?us-ascii?Q?9HjGIop+khczEXR1VMYp2TXuJt0nfUkVZsE68rsczhA80sOXii4Bgoohn4Wa?=
 =?us-ascii?Q?q9ctha08ytQ9WwkSuDbfM1+zZAWUd8TR/fTdgmOpjP2thC08iIkomW/SRbgn?=
 =?us-ascii?Q?1BXskd5FKvz3RtCfVM9b3MtzrCn+7o2+Gwu1IsVTL5Qg5v5luoxMUstPn7Xa?=
 =?us-ascii?Q?Cnq0suAR3TA9RPxuX+jTzJrQgIfb4mZ3CQmCIl8WDLmqKHEGOAk0+jgX7J4w?=
 =?us-ascii?Q?XaZ4HMpOFIZ51lA5i9AmDgGlZ99bgK37nLcuLvZL0nqyMnaPjtMA4zX9IUMr?=
 =?us-ascii?Q?qOPTqT4cpw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2463aa6a-74cd-414d-72f9-08da486b3dc4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 09:51:06.4925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fp+hm8mbNoNM8xtVHYeujMe78T2Ch/iFD4MoqHzUyHFR/QQOGri7yO8z0mG8l4rHys2+3pGFWRyWU0eAnBrieQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5180
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-07_03:2022-06-02,2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206070040
X-Proofpoint-GUID: wCrTfP3NjBZVQHW7605ZWCBtP3FAF1_A
X-Proofpoint-ORIG-GUID: wCrTfP3NjBZVQHW7605ZWCBtP3FAF1_A
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 08:40:47 AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 06, 2022 at 06:11:00PM +0530, Chandan Babu R wrote:
>> This commit adds a new test to verify if the correct inode extent counter
>> fields are updated with/without nrext64 mkfs option.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  tests/xfs/547     | 91 +++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/547.out | 13 +++++++
>>  2 files changed, 104 insertions(+)
>>  create mode 100755 tests/xfs/547
>>  create mode 100644 tests/xfs/547.out
>> 
>> diff --git a/tests/xfs/547 b/tests/xfs/547
>> new file mode 100755
>> index 00000000..d5137ca7
>> --- /dev/null
>> +++ b/tests/xfs/547
>> @@ -0,0 +1,91 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
>> +#
>> +# FS QA Test 547
>> +#
>> +# Verify that correct inode extent count fields are populated with and without
>> +# nrext64 feature.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick metadata
>> +
>> +# Import common functions.
>> +. ./common/filter
>> +. ./common/attr
>> +. ./common/inject
>> +. ./common/populate
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_scratch_xfs_nrext64
>> +_require_attrs
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +
>> +for nrext64 in 0 1; do
>> +	echo "* Verify extent counter fields with nrext64=${nrext64} option"
>> +
>> +	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
>> +		      >> $seqres.full
>> +	_scratch_mount >> $seqres.full
>> +
>> +	bsize=$(_get_file_block_size $SCRATCH_MNT)
>> +
>> +	testfile=$SCRATCH_MNT/testfile
>> +
>> +	nr_blks=20
>> +
>> +	echo "Add blocks to test file's data fork"
>> +	$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
>> +		     >> $seqres.full
>> +	$here/src/punch-alternating $testfile
>> +
>> +	echo "Consume free space"
>> +	fillerdir=$SCRATCH_MNT/fillerdir
>> +	nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
>> +	nr_free_blks=$((nr_free_blks * 90 / 100))
>> +
>> +	_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
>> +		 >> $seqres.full 2>&1
>> +
>> +	echo "Create fragmented filesystem"
>> +	for dentry in $(ls -1 $fillerdir/); do
>> +		$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>> +	done
>> +
>> +	echo "Inject bmap_alloc_minlen_extent error tag"
>> +	_scratch_inject_error bmap_alloc_minlen_extent 1
>> +
>> +	echo "Add blocks to test file's attr fork"
>> +	attr_len=255
>> +	nr_attrs=$((nr_blks * bsize / attr_len))
>> +	for i in $(seq 1 $nr_attrs); do
>> +		attr="$(printf "trusted.%0247d" $i)"
>> +		$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
>> +		[[ $? != 0 ]] && break
>> +	done
>> +
>> +	testino=$(stat -c '%i' $testfile)
>> +
>> +	_scratch_unmount >> $seqres.full
>> +
>> +	dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
>> +	acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
>
> Note: For any test requiring functionality added after 5.10, you can use
> the xfs_db path command to avoid this sort of inode number saving:
>
> dcnt=$(_scratch_xfs_get_metadata_field core.nextents "path /testfile")
>

Ok. I will post a v2 of the patchset to include the above suggestion.

> Up to you if you want to change the test to do that; otherwise,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks for the review.

-- 
chandan
