Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6789C32796
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 10:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353402AbiHWK1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 06:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354466AbiHWKZk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 06:25:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06CBE0D3;
        Tue, 23 Aug 2022 02:05:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27N7dYXK026391;
        Tue, 23 Aug 2022 09:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=DWFp/PWWM2TV2KbKrTgooLKoYA27bN9VTEJCCmrXXZk=;
 b=x+LnO2hVQJ7+PkpsRT1vBb6VGoxnQk84QPNKm26xTtNcGKPya2fGgDS+S/5H8V3tInpL
 c3TVEfcEwy9wkVzmGeA3SXfj1Xg335fz2WIJOb7t3Hfn1kF0wD+HiaM7Q9MRTXQPaEHl
 wFot8QqkW2lfRkwmf7QrkSfsCA6H2UGUUt5gzyVlhOQqMfiji25y/SocrpjNWOsPrTg5
 4De+3nHcDhAyXud67IjmlcMhzp6yKHfM7eTzbvzsIRxM5OgfZlEkuOMPYh7EUCM1IEJm
 uWyKluCDv/vsCCfyJnGp1GD/SrXoeSv6M4q7+4pzzQAq7jfvjbX7stRXoUCKgg106AC3 sQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4ea71kfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:04:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27N8H5Ib038599;
        Tue, 23 Aug 2022 09:04:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mq2njqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 09:04:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhKIgtebgPR045ow+tTmv0EhPncquA5CxlFstwls3oX+yNUcTE6tI0W7eXhOBENHeeqVwYErfDgtNcvLo7B627P7P+/LF1wlu0WImHO1iAyDE90fMeH8EVcVuwojxoDk4T94Uf0ZZvicQ2hF+PiADibK5IxNHYo5B7QzI1hxVNKfpmxhjSwil2Q0PB2OBrcTxboBGA3VdiqyYfGcA4xh3WGBiRqm4vwN1EwnUt4k/Zip52M9Sos5ZF3Y+iI4x9v0JkO29eolSLCErSPorHtuSpyFcId0l16eUeffMjNyn28jfv8xOUsX42q2kyiTngftBOMyPOVdzSdF1O/KHyQiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWFp/PWWM2TV2KbKrTgooLKoYA27bN9VTEJCCmrXXZk=;
 b=K3MxX/s2Tpln8sCSZ2uA1qybxuZvOXAPzQx41K5XpSpA/Imh71uil6OuTZ2zpyJzmWNwEHxxP9yHlwXiBBeX1ZVU3Rh+xjNBD4ilanCF9fi4MiUOPomud1CxpKxhszXHLgrcoWTzXm+JXwR/TOG07zrHwofTyiw439WkxNN8er/yhNvcrPJi/mtajoCSameExs5uVjN4PYmZfxlWiwpQFhQp06gl6ft+rRApdXKdpWyus/BWp+KjL1mxhHX5lE+jEESQn4ebkPf2Ce10M42qN8OxoBbz7KdbOb/IsVqYZxnktu9WSUIQ/VauEt/C4eUCqvdYhe8mOQJ5wWwBBrtJhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWFp/PWWM2TV2KbKrTgooLKoYA27bN9VTEJCCmrXXZk=;
 b=ofWCDQdUlbmZmZzGD0ogFRE2yfxTOZMYyuoAUYWM5Mmu9Yor01Xy6ZSvO1F39R4dJohsUfC8lZIjA2gw0SCDXxB81Dip/KrrQVBoVek6as7OA7LkAtqyFG9UaaTAmZ72+W46aEWWKvNl/9I/1xQKbZHeGIG9lgOTL9JFIP6MZqA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2808.namprd10.prod.outlook.com (2603:10b6:a03:8d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Tue, 23 Aug
 2022 09:04:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f84c:c30b:6d3e:d3e4]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f84c:c30b:6d3e:d3e4%5]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 09:04:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Check if a direct write can result in a false ENOSPC error
Date:   Tue, 23 Aug 2022 14:34:33 +0530
Message-Id: <20220823090433.1164296-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0030.jpnprd01.prod.outlook.com
 (2603:1096:405:1::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ecc886-25f5-45aa-9d61-08da84e68a54
X-MS-TrafficTypeDiagnostic: BYAPR10MB2808:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ca9quY0gkemTabFMVRxvvj++WdqOsmqkqqkh6QTtMkWvZgxtupdi9CnH8TZYI0QShXMvgXN6BO8vJBdigvMOX7DMCneaWD3M8xpPTKyFV/EI6pSZ7ShtTwpmt/7/NyRw0EC4O1W0qdll4Vh2ujV/PSNQp9J7XlSCa+/J6Gx6imvjjv8OhcXGlfOO4aaiYfB7rVtKdK1J5/E28Q9uPWVmOgTaKFOxeGXcBbzJZYGQJ6/0KyRtFbiHh6ZNqjkIpiEgl81afod3dC2eSrwE03ovPES+98whB4qxF511VMkbhIxExT6T9UcH0FessY4hoxeebidJPqJttAMVIN1qfk+dHsl58pZxm41sIUoy+nBTBE2v1BgwVe1oicWb+tbFMnLy7U9RGVTSL1+xTEVutlRvM+9h/8sGapSltAVK6u/atd82GdFeiXHh62irgx8fh26t1vJbji7OXwarJhKJKIxre3mTBncSstJPVulrw5R2g5MCWBO7GYp17gwVXYxrvO7ueFjRXIoMuy82Tr7e7+NTAvNbnzjTCExZbzHIxaSs8UF8Pe/JP6pqKZtxagEYV/tiL/OTEKW21v8YVB/Ug5svx/EdSrpYhyNvEW0YRd0T1JXxsJxjGiK1QOM2fpXocURvOvG5a6OEK63I3OPFPkX6iT6j1wRyGLLgqmGQOx8w/0eBlwX+qdXZgCunzdoaf4eYcYtpJOWGvO3UzNc+bTIiuGq/umVgCfedINx9VKFAfBW5AKSbZDTlndSkTQ8Wn3KI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(366004)(346002)(39860400002)(52116002)(8936002)(6506007)(6512007)(26005)(6666004)(5660300002)(36756003)(4326008)(66946007)(8676002)(316002)(66556008)(66476007)(6916009)(86362001)(38350700002)(38100700002)(2906002)(1076003)(2616005)(478600001)(6486002)(186003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I+uvfS3iMO4TQ3FAyPQOJB9pzs6UiBsF3Gr9ufYsCJ2ZbLigFQf/GhdertSn?=
 =?us-ascii?Q?qyl8hKqGvICiR8FWh9UEOfUQO/zn8gm31Zy9+x0A4wLgvzIivxbtW3fotKaS?=
 =?us-ascii?Q?BbpGl9Xpxl+CSB2DeWJ1D1vWIGw9qG6cw/7D+nFo9nYakkRTDQdhsG0Bt/eU?=
 =?us-ascii?Q?nl0VTR6e1xOJaTx2WT7U9IR82WPdhWU8andgD6iatL6UbYMYfCMfQ1I6gblL?=
 =?us-ascii?Q?x/g2w4CmLuuahnDaHjoIB1uXvgo3sWA2z6hd4f90e2/7PMxt5+lFPecUhWaN?=
 =?us-ascii?Q?8ArlkYNxHSirhdBgutMFR5Qqexpz06QapBuJ8HEaetcepTxd4Y+CW4YF8JQa?=
 =?us-ascii?Q?LNaj3p/sekPcAo2/de7Ixh7FEd1pSue/HGnN+rpPGZ6Z+RJ3P6Fw1uOyRrbM?=
 =?us-ascii?Q?b3WFBSpeN7PoRtsuG+NSzfEVCsIK3qreS+uL8wzLzGnWJ2/L8smJ02vsPBXB?=
 =?us-ascii?Q?JmDAuxRfPRUA7kWWoDrV+PF5OBE6fAeLsvkmIiJ8zRE9hdQHitK9NhIrqqcm?=
 =?us-ascii?Q?RAQUHu90XekUOw90Mtr2mhqVux9IZU8trHrg1J7RlDKdEeeGC8ZVRvnKAOEL?=
 =?us-ascii?Q?+ag092zNVDSmE9kNFZ1rRpU0nsPIwODRj9AQl0SSFP29CEm6q5cPoppOZGZ+?=
 =?us-ascii?Q?PbL540r3XyFLT3s2gexhgO2lAdk+mxglbAJg/xrQKwb7TcKlF4CwQXiiejk1?=
 =?us-ascii?Q?8TeTR7tGwrOxPQrF0fCWyv+TLWHXNU/7hsJmN6ARscQKC4csUf2rjD1FjM0x?=
 =?us-ascii?Q?az0atoxgBmAW4nrtnuqnLiKMmmYlEpik/xQx+J4ar5tDXQpC3RKtZ6QjNUK9?=
 =?us-ascii?Q?W+A0PolApzrFYn0LJ0/CRVfjumGmpkUKfEDNoPUUTjKKP/I4+rJlF9+2Je5Q?=
 =?us-ascii?Q?HAf45ypegOSD4Bst8Z2pYMQpB1gqJI7ZxpX8KVTahTXP8DsTUXTFd9bD1R7n?=
 =?us-ascii?Q?602wasDC6nellKcmzYaZpcO8GQpBW3BA0qor5WpaFavevYIKWzuB/Ff938ZV?=
 =?us-ascii?Q?E36+HRbERoQaUByuXB9WZNQftJQ8YwD7ZYq5qwfQa8Db/1jsT1nX8Qi0lkfE?=
 =?us-ascii?Q?FOftPEVWnmlrwbIg/2eMVkcQugvKXj51MOvXYgRApGqmnz8qbQIst4yeAUwu?=
 =?us-ascii?Q?ZcEiMdBeht09kDkYrto7uwAEMxeGrTvtuM6sJpe6ODOvGiJJjNqAJPWwojCl?=
 =?us-ascii?Q?/yRk4N4ejwiZYLqjsryLf9RVi0qt3Q2VvpN/0xUAbaVKRLY5/v8ur97cgrGl?=
 =?us-ascii?Q?lgwf2Q+cz11iE71DKueo6npWl3R49NR5WmL1R7QlmHE4y7D3V2RCJWNZj0eW?=
 =?us-ascii?Q?tQMToq38k03hXpPfEy1udOQb+Ph8xH79Y7sLya6ts1oumpZE6F7rBpBaCO0r?=
 =?us-ascii?Q?0JDVj/YQ4IT6SKJyTAQbdNR0OUy9cNB6YmRos5bYuWhLlcry9vYlNXfJ5McR?=
 =?us-ascii?Q?bmWT9aw2iXV+WpRUk4AS4/YP2YSkDeuZhcPhiWVxQLzVYV/LLRihlfeB80U8?=
 =?us-ascii?Q?XCJsvrct+kuSN1P51LaUdJ7qm/uIf5NIbSvUlNQiIB8L3Yf4ODiZaDwRx6bO?=
 =?us-ascii?Q?HP/VIDJZDQThAhC+4nYvgv04Ij8bhKTuiBg9Kgmg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ecc886-25f5-45aa-9d61-08da84e68a54
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 09:04:52.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emDVpzO3J2T7ARLBt2Cs14sda3PJGrRcoWZIxO5CL5xZxq/UrZgKiw5w1dgc1kxwF7UffYjBKMjRU9a5eT9gbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230035
X-Proofpoint-GUID: n3oB3EJ7kWfOpUHwclmBUnB4o9c9kamm
X-Proofpoint-ORIG-GUID: n3oB3EJ7kWfOpUHwclmBUnB4o9c9kamm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to check if a direct write on a delalloc extent
present in CoW fork can result in a false ENOSPC error. The bug has been fixed
by upstream commit d62113303d691 ("xfs: Fix false ENOSPC when performing
direct write on a delalloc extent in cow fork").

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 tests/xfs/553     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/553.out |  9 +++++++
 2 files changed, 72 insertions(+)
 create mode 100755 tests/xfs/553
 create mode 100644 tests/xfs/553.out

diff --git a/tests/xfs/553 b/tests/xfs/553
new file mode 100755
index 00000000..78ed0995
--- /dev/null
+++ b/tests/xfs/553
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 553
+#
+# Test to check if a direct write on a delalloc extent present in CoW fork can
+# result in an ENOSPC error.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+# Import common functions.
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_fixed_by_kernel_commit d62113303d691 \
+	"xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork"
+_require_scratch_reflink
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "cowextsize"
+
+source=${SCRATCH_MNT}/source
+destination=${SCRATCH_MNT}/destination
+fragmented_file=${SCRATCH_MNT}/fragmented_file
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo "Create source file"
+$XFS_IO_PROG -f -c "pwrite 0 32M" $source >> $seqres.full
+
+echo "Reflink destination file with source file"
+$XFS_IO_PROG -f -c "reflink $source" $destination >> $seqres.full
+
+echo "Set destination file's cowextsize"
+$XFS_IO_PROG -c "cowextsize 16M" $destination >> $seqres.full
+
+echo "Fragment FS"
+$XFS_IO_PROG -f -c "pwrite 0 64M" $fragmented_file >> $seqres.full
+sync
+$here/src/punch-alternating $fragmented_file >> $seqres.full
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Create 16MiB delalloc extent in destination file's CoW fork"
+$XFS_IO_PROG -c "pwrite 0 4k" $destination >> $seqres.full
+
+sync
+
+echo "Direct I/O write at 12k file offset in destination file"
+$XFS_IO_PROG -d -c "pwrite 12k 8k" $destination >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/553.out b/tests/xfs/553.out
new file mode 100644
index 00000000..a2e91678
--- /dev/null
+++ b/tests/xfs/553.out
@@ -0,0 +1,9 @@
+QA output created by 553
+Format and mount fs
+Create source file
+Reflink destination file with source file
+Set destination file's cowextsize
+Fragment FS
+Inject bmap_alloc_minlen_extent error tag
+Create 16MiB delalloc extent in destination file's CoW fork
+Direct I/O write at 12k file offset in destination file
-- 
2.35.1

