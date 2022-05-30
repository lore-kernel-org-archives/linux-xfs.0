Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB678C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 12:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiE3Mwa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 08:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiE3Mw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 08:52:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0EE814AC;
        Mon, 30 May 2022 05:52:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UB7wwI027031;
        Mon, 30 May 2022 12:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MWWaVWCxtuye3dYMsrq2vX/Goa5bnnbZ6UwovF4uBKI=;
 b=wR+408i52DkuRP00POOgXccVny6j/K6PFh6ujYjnjBZva5bCpClcBV9o3FfJ0OSzAEot
 P2IOi++JgHa96DW/UhFoW6nrlAknpMiMhtmoV9PwofiQxuAGV2EHVDP6xbziYX8ZJ20r
 cs+TN6MXNZZ0ODFlbpgFJwdC5mum3pZu/iXb0xsqrPd6rnCc/jzkkD/Pf7z7URxvlk0M
 oTNmDd1c9g5MMsGopnNiT0xE1uQ/5s3QwT1fFWLIJfWng9hoi6Vv5Km4sqfAkwkaC2/a
 j6BF0arxcyXt7bhMypU9ZrO0ZGX5MlND0FM+1LeY/2vwpR5kg9PJw7N0Fjcty+BWOtRk eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbgwm2phh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 12:52:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24UCpZTm022605;
        Mon, 30 May 2022 12:52:24 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p0qgfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 12:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeX1OWVBDHViFuEwbfS36pSyI4hmPm+v7xzuK5jYps0tIkRPjIjY0I70RNhRq5ksw31pbpghQw98/NsB63kgz9aCc2ESjrC0Vk3HIw+0Y1XuhDhhXbBDaZp8CgYXlIeiielTBA2m4tVDo0+QbKlxSlrFxcQp/LAhdwQC6tjdVZMPCQKjcbIao4hKEUPbR7FV1/yMSN+BxzkCS/o4TTaCu1Vzqx2QC//fdSPSaqELLSzojtK8ynrLt3ZgZOxhllELjK3S0gQglM8lrtXEtH6cSIkj7C9lfEbsf808vooeWCYWCwmGpk8wfDxkUNKZ/wYpvTCTEtAkNiTCFzOaeAEr5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWWaVWCxtuye3dYMsrq2vX/Goa5bnnbZ6UwovF4uBKI=;
 b=hSGcvCC82QMFeOVzHgNdj+EPr2lEeMYUMk+pyjxq/mLk53AYeGULhwxLWOCFbSw6NYm060SEVdoNaifZcmt+nfbW/z8X2aBOWf908uNYKHSNp/VN61bdG8OV+fb+rq7GcgLFFRu36H+qCwovBw+Gjdmf/7+BfZwYnuQd8Va2wf7Xax0qQJxX/igKJYHdA6mMbtclXmLrDFseXMsQMlnUT8Dl4+w8qnXHedi7mPORp9sqxr7vQqZ+rEd+MkNE54/tB6FtiJYkyHNl6Ho8obH2w4DZOdnEzRJrG1W9EQvAoMzC94sev7kpU6EWTIkHejmZ9n+4zCBjMon0d7vYhEk44Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWWaVWCxtuye3dYMsrq2vX/Goa5bnnbZ6UwovF4uBKI=;
 b=idu5tZHoHXUyDFwLWe3qEzscCadw1GvvsXOG6DvP2C3y6z8ipAnW7xDgWvfwx+hCNSBfAHRPLQSYTZC8BHjVFAXvzL84uyrIXr/BJCCmYx0abnfMyldDI6D4kkzzIPyrs/vkcNS/XOtxg3CQBjbArYmtBMBkvVe6SEev28nZsyY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB4512.namprd10.prod.outlook.com (2603:10b6:a03:2dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Mon, 30 May
 2022 12:52:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 12:52:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Test trashing of suspect inode chunks by xfs_repair
Date:   Mon, 30 May 2022 18:21:56 +0530
Message-Id: <20220530125156.1977338-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0023.apcprd03.prod.outlook.com
 (2603:1096:404:14::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4649264a-fd82-4560-2168-08da423b3d4a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4512:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB451291762AE360922B0DD932F6DD9@SJ0PR10MB4512.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: abBtLYzuHBJ7y6k2krhQ0vInJ/hvNd9m6+2AdOjp7h3YMAvKjqesLH1CpchIz8fXjctaf2Xl1pwxsJYAs3/yMt/umzTjV1pdagVLi4J5Zxdr+ROOA9u4kTlHc++i6aIKAEzoA4wyuJpNvIFr9n8Q4U6o4sLpZG2CS5ckZiHTq62N357wJ9Isd0JNmWei2k/n2xy+fukW4yArYVqeBXXyCZcJ8DIMoeRNfu5gJzDg4PPUUpGAT8T8+2EOasutufr7oTM6MMUcBFOEuyInT/yHaOe35yhe7n+oHEiEiq/y9DM/yktfIb8mAbQ8J4/oDnwL8v8U9YbtBInj218gddkPnxfuQKssuXIA9b+8oH/IjCZyAg8HO5srqYxu20WtibqfTA93IATJQ1mn3JvxH+jku4stlHCHnKftbXUBT9juXbcqqHMOOTHukTnE3KkxovjtUGYydjv6fS1XrDuqxDLGUo51uGHnQ9AQ6OtCtYpMwO72gL7Pc8bh9KK4gVQaeCvBr68ZAhzndAOODCzQe/UOI+bme8ORZKlp2XuuuQWcYDDNv2kswDgjcqM32VKWbiiIaCGUOPdxxdQUOcqtzqpWLPxbqCKbwNBkSj2ADV1GULu1J+4qhI5Rqs0oUvaA4EiXc/83DAJq4GdjAEPPBDNXENzh2mUw0rmKXryye/yFdnTQchCepUShfGnOZqv0JAPhSCBz2Ds9CgVvPWmUiU3+kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(6512007)(66476007)(66946007)(66556008)(6506007)(2906002)(8676002)(4326008)(508600001)(8936002)(86362001)(5660300002)(52116002)(6486002)(36756003)(38100700002)(6666004)(38350700002)(316002)(6916009)(2616005)(1076003)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T/TIojK2ziDkaudNkQKGGpxFQqf2GnGTDtp98APcCh7mEA8OEqT6yWazmtSx?=
 =?us-ascii?Q?/onC4UUz1CuXwcJulFSezX0ZTZp6YPCsLBfLg+UGaUE2Z86QxfZDf7d/jcj9?=
 =?us-ascii?Q?d/6gZsClH+UMnsMDNynNztaK044KqFt9pKhhlqs/Pe2acdpraOzvbXXlJNRl?=
 =?us-ascii?Q?v1VYGI7Lj2o39ECmKcmxluPYCPxgfbPjkucuI652oAleAfVrDNV5UDpBpBYA?=
 =?us-ascii?Q?kfTkx0O2EGB6wOyeLnRUobvc5v1aAYbZ5Bv7fGu9EHEWG75GWaqur+p7fEet?=
 =?us-ascii?Q?soNEwDb5MBh279SFUqWQRSHNpLFUYcv7S8uWahpzyga6uCq7U1ZEa+TvfOwM?=
 =?us-ascii?Q?OCjaQtCY3T75tAaN9iCNOv92dRPe0w1pwtRpXqgzJ9KbuKIAFa1V0gIdKpqM?=
 =?us-ascii?Q?iNOz4esFSkZbGEiITlYcWW9+2MUiygHs4SIZdxMOxVXcUlQZ6zX1NCuotEkx?=
 =?us-ascii?Q?xozctdK7pODmN7JIRGXo0XBzzYSEXYDe1BMOxLuh0TDMAOwFSmB2HwQuWpa9?=
 =?us-ascii?Q?1LzhWDQ6139I3G2smj2UlHxosP4yJM8+dStZQZe3ejcLOdKihHFGBOzqUm6Z?=
 =?us-ascii?Q?y2EdZHpUMnGW3nkXgTTZnwaJvvUVDe54Ae+b8kYA+LJrxkdIjsELzQvwPNog?=
 =?us-ascii?Q?aVvjOVqIa5OmZvJopolKsr5eFpA3DCOV7sBOf2wFjgOyAphonc2S6UFBC+Cr?=
 =?us-ascii?Q?oDbwuEfuYscMDPwkPjkk+FZz3A4dYyc6mXIxaBHa6ljUnh6xO0ZO8U0sT+cS?=
 =?us-ascii?Q?RIFr1yu6zcMqXb2ytQFNsbPrTWONYM/VbzjQHN3EF+TrL+vZPIXHNIr9aVL/?=
 =?us-ascii?Q?aXuejmQNteprp6X3QVZd2jHrlYlLd+Q63msvYw5WH9vXwLj/5ZtagnBsjbG7?=
 =?us-ascii?Q?2BMWvKX8YKzshRDnACr9xWnzU2xOaN1QltCDTEihEaZ3l/lOPcL26F94x/je?=
 =?us-ascii?Q?00rMIXL8OBbDBLJ+MPzLx5svWhraMe5OqFL/AQjRjKhm0n840kzNGUwI0+r2?=
 =?us-ascii?Q?9nNo+2OX0nFvxov4HuOEQ+0ZYDh8mLiDXfZf0ZpJRPJROSpQXIlI4D4vtb+p?=
 =?us-ascii?Q?iAByvIY/DV5iAB3H7nDlXHoZCf9DkLOvPwmz9LdEJNCeJjF0lZUmt1/8rV5I?=
 =?us-ascii?Q?Cf1rtzMMeLBSxzs7SICmtL8cPsz/Rue81X2LHOq6T4TGiTnhGaWwnuYUBe9x?=
 =?us-ascii?Q?zyiByQYofl007MMoC+OcKKqSbjq1gAxxFn3/lQmSb+ZmJ+SSrF2nKfF+rn3q?=
 =?us-ascii?Q?GswAl6bd4oY6Gy0TuZRF9jrzQekfw87kJq10fsLZyiDFbn1I98acodWq4Nc0?=
 =?us-ascii?Q?/8UijeyshsDpz+stawMq0qoZU9Sc8XAlWrNvxo4hjb/j7iuOPEawZuk+XXg+?=
 =?us-ascii?Q?8w00DtT7f01ZlXtaQHIkE8sA5BTFJLkL22OvvnuLahD2U5jPOc3yAPw1oqFW?=
 =?us-ascii?Q?DvfxdGIZGM9EJsrJaTCOsxNDjrDpoImdA9z/G8sgCDTQugjPT9tuoJYL0t2Y?=
 =?us-ascii?Q?m109SMz0SKz2osEjpnW4cySW65M5tzbRVkpMhuqiw/TyOKbUMs0o0t2T4U5F?=
 =?us-ascii?Q?g3Mw4e7Jprlxs83jq6DVcRxVC2SevTJOhHdjwxGOahC25dZ4vz6mj70u0dXv?=
 =?us-ascii?Q?vUgavLJtPjT+OL9GQhx2xsQWqbtLU+zif0HeFQX0GWiIQFwHmHMvmj/HGhuk?=
 =?us-ascii?Q?+CcZeeuSBLgDejMM1m76BoInYKUTEGNfmILcC3+eOda7uDWyOGmr8bFKFoUn?=
 =?us-ascii?Q?cHh3pqoCkw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4649264a-fd82-4560-2168-08da423b3d4a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 12:52:22.7774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/HcVxZ4l6b6UsWu9YVM75YwS1bEDFh3z6sUIumO3VU73uzj3Oa++re5gnvmcIBjGkYL3QStr4v+A9k8IyCkLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4512
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_04:2022-05-30,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300067
X-Proofpoint-GUID: ImkqcRr4N3sqEsPxzEQzuFZHN9hYK-bc
X-Proofpoint-ORIG-GUID: ImkqcRr4N3sqEsPxzEQzuFZHN9hYK-bc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When processing an uncertain inode chunk record, if xfs_repair loses 2 blocks
worth of inodes or 25% of the inode chunk, it decides to ignore the
chunk. Otherwise, xfs_repair adds a new chunk record to the certain inode
tree, marking each inode as either free or used. However, before adding the
new chunk record, xfs_repair has to check for the existance of a conflicting
record.

xfs_repair incorrectly checks for the conflicting record in the uncertain
inode chunk tree. This check will succeed since the inode chunk record being
processed was originally obtained from the uncertain inode chunk tree. Hence
xfs_repair trashes such inodes.

This test is for checking for the existance of this regression in xfs_repair.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/018     | 102 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/018.out |   6 +++
 2 files changed, 108 insertions(+)
 create mode 100755 tests/xfs/018
 create mode 100644 tests/xfs/018.out

diff --git a/tests/xfs/018 b/tests/xfs/018
new file mode 100755
index 00000000..780ae8f9
--- /dev/null
+++ b/tests/xfs/018
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 018
+#
+# When processing an uncertain inode chunk record, if xfs_repair loses 2 blocks
+# worth of inodes or 25% of the inode chunk, it decides to ignore the
+# chunk. Otherwise, xfs_repair adds a new chunk record to the certain inode
+# tree, marking each inode as either free or used. However, before adding the
+# new chunk record, xfs_repair has to check for the existance of a conflicting
+# record.
+#
+# xfs_repair incorrectly checks for the conflicting record in the uncertain
+# inode chunk tree. This check will succeed since the inode chunk record being
+# processed was originally obtained from the uncertain inode chunk tree. Hence
+# xfs_repair trashes such inodes.
+#
+# This test is for checking for the existance of this regression in xfs_repair.
+
+. ./common/preamble
+_begin_fstest fuzzers
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch_nocheck
+
+echo "Format and mount fs"
+
+# 1. Limit the number of AGs to 1 since we need to guarantee that all inodes are
+# represented in a single Inobt.
+#
+# 2. For sparse inode chunks, xfs_repair can cause a suspect (e.g. incorrect CRC
+# value) inode chunk to be ignored even if the verification of all inodes in
+# chunk succeeds since the total number of inodes in the sparse inode chunk can
+# be less than 25% of XFS_INODES_PER_CHUNK (i.e. 64).
+_scratch_mkfs -d agcount=1 -i sparse=0 >> $seqres.full
+_scratch_mount >> $seqres.full
+
+testdir=$SCRATCH_MNT/testdir
+
+mkdir $testdir
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+# gdb -batch vmlinux -ex 'print /d  &(((struct xfs_btree_block *)0)->bb_u)'
+# $1 = 8
+# gdb -batch vmlinux -ex 'print sizeof(struct xfs_btree_block_shdr)'
+# $1 = 48
+#
+# Space used: 8 + 48 = 56 bytes
+sblock_len=$((bsize - 56))
+
+# gdb -batch vmlinux -ex 'print sizeof(struct xfs_inobt_rec)'
+# $1 = 16
+nr_ino_chunks_per_block=$((sblock_len / 16))
+
+nr_inode_chunks=$((nr_ino_chunks_per_block * 2))
+
+nr_inodes=$((nr_inode_chunks * 64))
+
+echo "Create Inobt with two fully populated leaves"
+for i in $(seq 1 $nr_inodes); do
+	touch ${testdir}/${i}
+done
+
+_scratch_unmount
+
+nr_levels=$(_scratch_xfs_db -c "agi 0" -c "p level")
+nr_levels=${nr_levels##level = }
+
+echo "Number of levels in Inobt: $nr_levels"
+
+echo "Setting lsn field to zero"
+_scratch_xfs_db -x -c "agi 0" -c "addr root" -c "addr ptrs[2]" \
+		-c "fuzz -c lsn zeroes" >> $seqres.full
+
+echo "Try to repair filesystem"
+_scratch_xfs_repair -o force_geometry >> $seqres.full 2>&1
+
+_scratch_mount
+
+nr_inodes_found=$(ls -1 $testdir | wc -l)
+
+if [[ $nr_inodes != $nr_inodes_found ]]; then
+	echo "xfs_repair failed to revive all inodes: "\
+	     "Inodes expected = $nr_inodes;  Inodes found = $nr_inodes_found"
+	exit 1
+fi
+
+status=0
+exit
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
new file mode 100644
index 00000000..116e5f1e
--- /dev/null
+++ b/tests/xfs/018.out
@@ -0,0 +1,6 @@
+QA output created by 018
+Format and mount fs
+Create Inobt with two fully populated leaves
+Number of levels in Inobt: 2
+Setting lsn field to zero
+Try to repair filesystem
-- 
2.35.1

