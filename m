Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BF3C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 09:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390747AbiEFKCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiEFKCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:02:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5239756FBC;
        Fri,  6 May 2022 02:58:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2468sC9O030007;
        Fri, 6 May 2022 09:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2fQlTPDRDrJItV/WuYbMIEpIMCyXqLh3cw3z5W/tLxs=;
 b=cpBVS0l2YNAhoH342beajA9xvV1vVd21w+tEvXmXYJ9eu536LgLhrSs5TenFiIiu+TiD
 QEHFnKeDiTsfz3EBFzmWeUjpObuHQQGE1PF/A78AW6iMs5Ve+8HrIstTTz3i48epcWb+
 f7ANJg7oSa4ZlyZHbIYJh5c/QCHUOVYDBv8nYQ9AInX+1yh1rIcvc+I9pQBvaVK4vb0z
 yyLbNVW3X4Gz9M+kuYTPUTOm+xtT64V6palKgL67CbmYJ1XBzrBNlSuw/TbDM2C5xZmp
 iCWjeM9F3Tme7q4nkFHyyV9Bxqez9e+meRLfeZNKVo0C36j1i2+1v7BAZ4yZcKspsUz8 +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0ns8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:58:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2469usqL024125;
        Fri, 6 May 2022 09:58:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus904yec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 09:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDqN6uOdUTMScCrSr9pxQdzmqz/EJPpExLfCGAvC30XO5YrrHhrvtKCuJysp1uxud+mGvFfnUlIDV21kZmGFrOMao3ACQ7lC4ao9kUFc7DykM4L9UpZt8TknG/MGjA9JpltfKqohBKO9dAbOWn6kTPg7C7G3jU1yJEG3YJeyo5Uw/we1fxbIRztkoCO865Mwze35nGS3dW7Gtod/Zh1DdtFUbPddNsHhjGMhuy/rfAiq9kbSd9fz4+kWzYqBUEDFRJ7wm0HEL9yaAlOAQCbbZh/f/JSlGRJfU/PaAMiuncvsZR87it6SaNbtSeJAqEzLpROWo5LGph6a9fuNvLdVmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2fQlTPDRDrJItV/WuYbMIEpIMCyXqLh3cw3z5W/tLxs=;
 b=kMY0QolLZENIitU46BxGMjw1iFTL1UOEzF8h4Q3sXReVl1H33hIxC7mdZI7umoL6qhQttvpsTpz48eDA49oXkVsYtskSGfdKIEtRCRl5e77KCx+CeOcKChznTPrjw4xYKahEm4KoXPVyT5WBYkvxGYvjTKm+GEv5rLlAJvrLuyJ1V/wsw1YEhpbOb3MUSkJacsi2aeku2ta85uetFHi8b4/NuGASBVO7RK2CmeA6GTgUrB8Qwep1oR1/eXsOrxi7jj2z/9OP2WFEDPKDQDJ7YVF/4DDN/UxybLaJfciu1y6SdOCWOcKoUUJSIs+SI75iDFBRGr7LC9m/hWQIfvv5MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fQlTPDRDrJItV/WuYbMIEpIMCyXqLh3cw3z5W/tLxs=;
 b=dcliOKjFnUOpMfWj2DV9s9zLC1bIBtGOV4c8y9o5J+Jw7L/jEMMwAHlAONcwAY34gSQkM3oUqOgJbLVpZMsJ8klz2IGMsKpbVbIPx1wRoaQz8AhM2g6kynnSWAWQcwG5V38mFyD7RryFTN1RTxQnn8lRYoDcOrl4Xv9YT+PqlCQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 09:58:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::7d41:aa0f:80cf:ea15%6]) with mapi id 15.20.5206.026; Fri, 6 May 2022
 09:58:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/533: Delete test since directory's extent count can never overflow
Date:   Fri,  6 May 2022 15:27:46 +0530
Message-Id: <20220506095746.1014345-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0010.jpnprd01.prod.outlook.com (2603:1096:404::22)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 887c3271-28e0-4d21-425c-08da2f46f1a0
X-MS-TrafficTypeDiagnostic: BLAPR10MB4995:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4995374AC94AE4F8D517D586F6C59@BLAPR10MB4995.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQal0eM6LxAjYe3UAchY05oPNZOA068KNACTa4iil6K4hwF0PT/dMuoqLDjj6z1nhebnZVNrOB6VTiuJf212g9CT59jNF9oUm3A4O9A+yLPy0e1ifDez8ovXBFiT3ZF0LgCTDrVCfCPclgBITv7Uj3DRT+3fmPf7PDPHj96c11RD6Wpb+X6LqXSjEVQPKNed0CaQPE7gr4diCxFRY1m/8lMPoh/WOBY9YaNDCuekEGRyoZgOGDQKDisL0z5o4jEo7HVchQdBg7xU/rF0PbbJhp0y9l2DOAtMq6PH3RLBMLqFNXlZiFsQ5UaTQlNA4Yl7X6GHRo+c6aEjCm1mB145In5UqQ1t8zJqGOn65Gaob7iQj5tCViPHwLcVNpsikbZeRJPJ9iGz24GPplaeo2Df4HKu0h/rrnbbG6SAannvkJ4YW35lQker+QgFvdXDbY7XNsdVJPvzGsdi5EnoIJISoXnqPKlTQ4FJ9gSQcLFqQxWZcPzNsGZE7V/7mKULEpXKt73i6oo3zgdStsnVGvXitSjVKmJ5DYbnCSycBLP38vkuleMLU9ozQoiQnOgNXom9omXDilDcxy4SHRFYHrwvicnJNd330AVW2KF/mb/zt24Kz6Fr6dvaU+H6yPGSK8TpwCBGd8IriXYpjkro2lOA/o/eLs2MSQ+UYPGzIly64JRGTayV598vQj0YOMrRh5MY366YPEw6ZWCg0z68b4UHHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(450100002)(83380400001)(66946007)(66556008)(66476007)(8936002)(86362001)(8676002)(4326008)(6486002)(5660300002)(508600001)(38100700002)(38350700002)(6666004)(2906002)(52116002)(1076003)(36756003)(316002)(6916009)(2616005)(186003)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3TtQ8eG7DXBcNsgW+vOsPyToOTJiy5XpXAiy9v6UoPHd2D2cSy3TwZDx70Mz?=
 =?us-ascii?Q?i9BNnpK8kxWVj/WxxiIRuEODby2vvux9R36IZap5uAT9lsaSajNt9ty4RGlc?=
 =?us-ascii?Q?X5SrIlZK0V8tMPd5kPsphy3o3YIUdlU/+jddry088vxIsnfMVEOJXo7FQ2jU?=
 =?us-ascii?Q?a0Z5Z/EOWhS6eHxqVu0QbgtT0rnhsR3vndAgFTedqKN0hhjICOOlonn2IQiw?=
 =?us-ascii?Q?Ugkz27fDLXjTXR9Lqibkvx7u0dgLsU0Na/my1fNawcNiokpTEWkZIfXF9tbL?=
 =?us-ascii?Q?WZt6euCNoGGx/pOM9UcUsH858EZPhK+F5xWdxUP7eWXDzC2+eReMcOf/LOz0?=
 =?us-ascii?Q?kSjY51gxfiU24BiMEfSYdRWkX/U5L7otTJnQwe+ntWSFXn0nczaM/Nrn/D0y?=
 =?us-ascii?Q?qW3a67Uy7e+ThuY23wGNbNcvQfma1FwSPZyr2BIDp7HRC9hNt7GC2B9mcJ4i?=
 =?us-ascii?Q?811vsQttfnCVTD8IfGgI+DfmzYEgz0moVBF19rkjFnbb68y0y4qSLTK436Kr?=
 =?us-ascii?Q?5CAaN0oRcDeGi3cevN2qbBYHU5W6rO0r8jpmeCwycjn/blaGtbHJaPAqzD/A?=
 =?us-ascii?Q?BGBr/n6PIwwNpR1LZ7BpKNCcyTe7AGwpy6IRP8NvLgvcrz22TU9V1RGVD35T?=
 =?us-ascii?Q?i3IEUFOaCh13rWa5c0a2I8uGMBL4qk1MK8opxcvSL9PDnOCTMPIywXYLf7cP?=
 =?us-ascii?Q?ZanESPi+EtyguSimlKVSiJqNnxUvTCAsWq56e+LTsX6ewnRi6eK09s0y3B3C?=
 =?us-ascii?Q?o9Lpqr4rNwnWQE6mBuXT/L4gi9HnziXFC4W3GPKyyX2Evo8CQvKxsPt2YfWB?=
 =?us-ascii?Q?rJuXyfjvLXgKzoWzJ9DYIrGThIBny7ZHm4Sbd7Tr5jY+YhY5IwsB7ObwV/PO?=
 =?us-ascii?Q?nzkBIDV1zjzpNyoT+7IqxfkUZBpNtZvny1yZoCA9NUO2vg5KHF1GXEVYoJUE?=
 =?us-ascii?Q?DVIDRNsSLtWs7cwDzpDLtm7fSri0VOc/vJnClYQ0Kb/WW42g1YLdEVu7vj9H?=
 =?us-ascii?Q?Cc20YZQJDNSt6tM+chgNeFwogQRyVx9FWBdO/NXNLT3O0hnOLUjDlTtU5hCX?=
 =?us-ascii?Q?XTiEznoGHacFyRd7y0FiqF0VxMO+Nc2X5C6Cw2aYX6s3cTgbZaeG+M8o4L70?=
 =?us-ascii?Q?EZFUQukV5ymABMTZ1VjBpmfvi1HwP1OE7rDJlVSJYYcb6axkxAKKhihCwLok?=
 =?us-ascii?Q?MGS0UW/ulcVGGYcgBrTcou+zQ1TKqm+d524C7uw0MUcLDWywmeRcEcug5MSm?=
 =?us-ascii?Q?/l5X6NsJ8SuKg+1Bg8Numw4js1vuX0gEvsxQWk3Bzfh2JYfqom7j+xjKZLSe?=
 =?us-ascii?Q?s7dZhRFLLoGr54WetIUV0xKHQqf0Px6uUkjqS2tX3P8ypB6lfS79p5ChFVzh?=
 =?us-ascii?Q?uzzc0W9XASmrlvWDFuVJzYow73HKqR/l4HXgftiON9yGiGXqYZUxu5EKft7d?=
 =?us-ascii?Q?9/A18pQ00SaymCJLc95GfhV0uiDQKByTRsDWORQf5LvNGuzEIZ+U+yMUDwSB?=
 =?us-ascii?Q?kquLmacx6oP3/EM/zP1stdnyVcmkFpD5xJMkLzCm2EX6cji+KIUu86qhm8G5?=
 =?us-ascii?Q?ZMaJ8w1habLq4WHo2PCSjSitoEX8czLif7VzghV8X1LKCm8bm2ZUJcME4iYf?=
 =?us-ascii?Q?GSw3X/iIi81+CgYsm49X6jGEWI5xOoY97RjmJXmqPc/M5hykzFYpA72NVXc5?=
 =?us-ascii?Q?RneM3uQkPTTwrrv4qG/NxOgrHHXqYyp6RMBuKufTiZYfFUcypLJT3YowHoqr?=
 =?us-ascii?Q?XcqG2hkqxLos+CiIHfIsglRrHzeGECw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887c3271-28e0-4d21-425c-08da2f46f1a0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 09:58:17.7030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EY5tQj7r9w/UgMMo+Ak00kt5TNhNAJ7C/04JxbgwW9Nlrz3JPr6sDpl98HFE+ZkRNBGjSzp3BFsIabUmH/qAMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_03:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060055
X-Proofpoint-ORIG-GUID: OWWkr2cQ1wZRSe7inAniQWq9fM5kNHIr
X-Proofpoint-GUID: OWWkr2cQ1wZRSe7inAniQWq9fM5kNHIr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum file size that can be represented by the data fork extent counter
in the worst case occurs when all extents are 1 block in length and each block
is 1KB in size.

With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
1KB sized blocks, a file can reach upto,
(2^31) * 1KB = 2TB

This is much larger than the theoretical maximum size of a directory
i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.

Since a directory can never overflow its data fork extent counter, the xfs
kernel driver removed code which checked for such a situation before any
directory modification operation could be executed. Instead, the kernel driver
verifies the sanity of directory's data fork extent counter when the inode is
read from disk.

This commit removes the test xfs/533 due to the reasons mentioned above.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/533     | 170 ----------------------------------------------
 tests/xfs/533.out |  17 -----
 2 files changed, 187 deletions(-)
 delete mode 100755 tests/xfs/533
 delete mode 100644 tests/xfs/533.out

diff --git a/tests/xfs/533 b/tests/xfs/533
deleted file mode 100755
index b85b5298..00000000
--- a/tests/xfs/533
+++ /dev/null
@@ -1,170 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
-#
-# FS QA Test 533
-#
-# Verify that XFS does not cause inode fork's extent count to overflow when
-# adding/removing directory entries.
-. ./common/preamble
-_begin_fstest auto quick dir hardlink symlink
-
-# Import common functions.
-. ./common/filter
-. ./common/inject
-. ./common/populate
-
-# real QA test starts here
-
-_supported_fs xfs
-_require_scratch
-_require_xfs_debug
-_require_test_program "punch-alternating"
-_require_xfs_io_error_injection "reduce_max_iextents"
-_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
-
-_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
-. $tmp.mkfs
-
-# Filesystems with directory block size greater than one FSB will not be tested,
-# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
-# count) = 14" is greater than the pseudo max extent count limit of 10.
-# Extending the pseudo max limit won't help either.  Consider the case where 1
-# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
-# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
-if (( $dirbsize > $dbsize )); then
-	_notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
-fi
-
-echo "Format and mount fs"
-_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
-_scratch_mount >> $seqres.full
-
-# Disable realtime inherit flag (if any) on root directory so that space on data
-# device gets fragmented rather than realtime device.
-_xfs_force_bdev data $SCRATCH_MNT
-
-echo "Consume free space"
-fillerdir=$SCRATCH_MNT/fillerdir
-nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
-nr_free_blks=$((nr_free_blks * 90 / 100))
-
-_fill_fs $((dbsize * nr_free_blks)) $fillerdir $dbsize 0 >> $seqres.full 2>&1
-
-echo "Create fragmented filesystem"
-for dentry in $(ls -1 $fillerdir/); do
-	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
-done
-
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
-echo "Inject bmap_alloc_minlen_extent error tag"
-_scratch_inject_error bmap_alloc_minlen_extent 1
-
-dent_len=255
-
-echo "* Create directory entries"
-
-testdir=$SCRATCH_MNT/testdir
-mkdir $testdir
-
-nr_dents=$((dbsize * 20 / dent_len))
-for i in $(seq 1 $nr_dents); do
-	dentry="$(printf "%0255d" $i)"
-	touch ${testdir}/$dentry >> $seqres.full 2>&1 || break
-done
-
-echo "Verify directory's extent count"
-nextents=$(_xfs_get_fsxattr nextents $testdir)
-if (( $nextents > 10 )); then
-	echo "Extent count overflow check failed: nextents = $nextents"
-	exit 1
-fi
-
-rm -rf $testdir
-
-echo "* Rename: Populate destination directory"
-
-dstdir=$SCRATCH_MNT/dstdir
-mkdir $dstdir
-
-nr_dents=$((dirbsize * 20 / dent_len))
-
-echo "Populate \$dstdir by moving new directory entries"
-for i in $(seq 1 $nr_dents); do
-	dentry="$(printf "%0255d" $i)"
-	dentry=${SCRATCH_MNT}/${dentry}
-	touch $dentry || break
-	mv $dentry $dstdir >> $seqres.full 2>&1 || break
-done
-
-rm $dentry
-
-echo "Verify \$dstdir's extent count"
-
-nextents=$(_xfs_get_fsxattr nextents $dstdir)
-if (( $nextents > 10 )); then
-	echo "Extent count overflow check failed: nextents = $nextents"
-	exit 1
-fi
-
-rm -rf $dstdir
-
-echo "* Create multiple hard links to a single file"
-
-testdir=$SCRATCH_MNT/testdir
-mkdir $testdir
-
-testfile=$SCRATCH_MNT/testfile
-touch $testfile
-
-nr_dents=$((dirbsize * 20 / dent_len))
-
-echo "Create multiple hardlinks"
-for i in $(seq 1 $nr_dents); do
-	dentry="$(printf "%0255d" $i)"
-	ln $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break
-done
-
-rm $testfile
-
-echo "Verify directory's extent count"
-nextents=$(_xfs_get_fsxattr nextents $testdir)
-if (( $nextents > 10 )); then
-	echo "Extent count overflow check failed: nextents = $nextents"
-	exit 1
-fi
-
-rm -rf $testdir
-
-echo "* Create multiple symbolic links to a single file"
-
-testdir=$SCRATCH_MNT/testdir
-mkdir $testdir
-
-testfile=$SCRATCH_MNT/testfile
-touch $testfile
-
-nr_dents=$((dirbsize * 20 / dent_len))
-
-echo "Create multiple symbolic links"
-for i in $(seq 1 $nr_dents); do
-	dentry="$(printf "%0255d" $i)"
-	ln -s $testfile ${testdir}/${dentry} >> $seqres.full 2>&1 || break;
-done
-
-rm $testfile
-
-echo "Verify directory's extent count"
-nextents=$(_xfs_get_fsxattr nextents $testdir)
-if (( $nextents > 10 )); then
-	echo "Extent count overflow check failed: nextents = $nextents"
-	exit 1
-fi
-
-rm -rf $testdir
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/533.out b/tests/xfs/533.out
deleted file mode 100644
index c3cbe2e0..00000000
--- a/tests/xfs/533.out
+++ /dev/null
@@ -1,17 +0,0 @@
-QA output created by 533
-Format and mount fs
-Consume free space
-Create fragmented filesystem
-Inject reduce_max_iextents error tag
-Inject bmap_alloc_minlen_extent error tag
-* Create directory entries
-Verify directory's extent count
-* Rename: Populate destination directory
-Populate $dstdir by moving new directory entries
-Verify $dstdir's extent count
-* Create multiple hard links to a single file
-Create multiple hardlinks
-Verify directory's extent count
-* Create multiple symbolic links to a single file
-Create multiple symbolic links
-Verify directory's extent count
-- 
2.30.2

