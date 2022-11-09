Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED67C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 23:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKIXNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKIXNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 18:13:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D23E05;
        Wed,  9 Nov 2022 15:13:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9N95wu019928;
        Wed, 9 Nov 2022 23:13:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=mNKcguSAzodp82t1o3aj+FQY4EnA+P+Qkx7ga1uPj3Y=;
 b=A6Dk3K68q7pCoh+gP7ShqTU0A2hvjLfUZFmSKuY2EPV9atzzhsEjDcSq4/aPKVH4bOuV
 ZA4eId/ZNs7f65cwq23YA/W4lGjjEWpCVbBx8uMub3UpW1Qh3kklnYU2W+ztMG4eop2m
 Kt+XNs+ApE5gjvtmfcNDeDgis35MpeXNMfbqrLEwAmUtwcJFcx3qBKpH3TnPfcVSKRSC
 t7cZMpSPrJCL7ECDnkLKRreGNeGfH/AD/4yXZwJnSNTMeCyA1Rg0Arke9dNyDYThvNQ3
 Blhff1iUQpavnKM/fUowUXi2fCiR1DoypRBs3pKPAtJMaKg5yg8pODL7bUfC4PoJ9Llr Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krkvh0b8b-32
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 23:13:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9M3TxS019047;
        Wed, 9 Nov 2022 22:26:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctnj3t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUUAU6HbgLt+QWsHbQdANU48TKEjOrkBDBCz1o8I1IcmatP848/Ls8qp1ejFw3h1ni5JG5g+FKrxjeoLH8/gus47OSuoYbdPdqCz2pG3CUpc4mC22Yh2QEw/g+iXdsIcMqRW8NfGnuFoOCwL1fAF2Wl3B1739mE1bz/ZCaXH5C4v8P/qmBrtArYbbtUQDBqFLBGs5JernB9DusJLxCkXg/B0Eyl+LlXpG538F1EYk1dVJcwe9hoGC0ORr8GbAXMhrNz+On92wRTvdZ7q9OLFTpASz1EDhD9FGtTyf2pxtynwP8qSBdlHXfdmv7D0x9PY+jrVv61gqWmCgJ3cwhPHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNKcguSAzodp82t1o3aj+FQY4EnA+P+Qkx7ga1uPj3Y=;
 b=HHHUL5OWUG9QGFTgy43U/orWNgFdIaO702FOuMXyWcAFbl4FH8kMpZpEBsQ23iyOdok/5jXhtA/epjuXdS049zVNBkE9/c8YOvlQyg7X02FWEblF4rc7Ip8oSRpvW5evXdpBqTf7Uwyn10wL6vVi1UVGbYltmRYpXXW93sdm82elfdWDsTuDGMlEkDRj0yWlhNGI9RNbZghKaxVR5EpuAA2EUYtBqDZLMoC6eqU17NpGIrWSXswMhxvz+NYzFaLmwaRee692+QXuIsxWOh26jsG9FxReJJlTmsC9nwdugScBnohZfsyZDKS9prBqfEcPXj6vCXd+488owqg2ei9XLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNKcguSAzodp82t1o3aj+FQY4EnA+P+Qkx7ga1uPj3Y=;
 b=cotEc9x18xYCq6RYNyvut+I3+nchbs/Z3C8AZE1Vg1CB0Unm/iod/gcWAUAIbvysLdzzjiJ/LVnVjCrkUYhLUwq2KEuev67fUp3uKkAakTaMhnexzhmSYXf1H/Bwx3V6QgwlixhASTF/2fqNWrMfdCQYnSe/ZNoqg9Qs6TL+E24=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5119.namprd10.prod.outlook.com (2603:10b6:5:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Wed, 9 Nov
 2022 22:26:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 22:26:33 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Date:   Wed,  9 Nov 2022 14:26:30 -0800
Message-Id: <20221109222630.85053-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0185.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5119:EE_
X-MS-Office365-Filtering-Correlation-Id: e7893b14-eefb-4eec-157e-08dac2a17517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhVySqH8f8un70uHdko9K32Rc7RJEuSbY1Dz3HdPoa23YI+D8PIZZU0HRxcqGNqo8Cqfa5CiuGzHFEgTO+Po+QSF6AuxGJ3ToiTwQ7P5iDqaXAgZ4K6DxTAteM+5Dci//sRQwQydzirQcaXm2LI2JEcioRI62DHyQbdFW020wj2No50Z4mreeZ6oAq1fWqRb4XdGlwI1ekjUiHkJ2DGcV6h2y8N1tV4ugRxnA81Uc2ZdoKVheldFihNeQyTwjqpHdV6EvDMSiDkE4eYyp3t3PZlekLcMJc48I5lrwezz5NdTclGCZlSN1G5QzIff/n4Iq7auLJ/1AoR7tpqsFCmG5mi39fGtUNZELKvewcAm0uawE4QHpx/7rWrtEouFjm1dS5Yhk9qgub7vCf84M0rRuCWs32VF8DR5xICOLczfhNpH97YZLTIwY4yOQv6ezf5+xQ4GokOoHOvYEYG4O2KfUcX/CzBFTh4/06jcBkvbyN/rFvQN0qwkVsEyQ1XTB1waJaNFUp1Ewvmb8i84g3QBMKvG+Ds+ioWVSibes91itxKea05yuTal+PYWBnEAk9o8P4Hmv+8QRGEvuU1DC+hQHO3bVZzaG37boYoU1vs/jsiDSUmu7zDhsg6lHQC+SNkz2YXXP8JQcgJk2yRLpfPaHdohZjXIE1DiAxOv/oXcSyzNOVIXB02NeElwKsWibA/y1LhZ6ehHwLi6RNtYFi0IYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199015)(66946007)(86362001)(41300700001)(8936002)(5660300002)(2616005)(38100700002)(478600001)(2906002)(6486002)(44832011)(36756003)(6512007)(450100002)(8676002)(6506007)(66476007)(316002)(66556008)(1076003)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/ntpD/WrmUmcMjHnaj3pVQjagcLpt8P59RqqUX1jsCXI8N0CwqHN7sFk00j?=
 =?us-ascii?Q?IroYqt5s0xIUu1ED7Mn7biRb3Irq1WoAFKQU03j/OG841YX1nypY01sLvlf1?=
 =?us-ascii?Q?hOhmkc2qB/uFwGT+lHIYcs5xpvj6GSdnEoxygWVrEhRK1A0UvTR8Y0K6QO/5?=
 =?us-ascii?Q?/HLI8+2ofMsmaH4G7o14T8rJgnbMHlODGU/uNDYYDGTCR034ulzZU+3mcwMK?=
 =?us-ascii?Q?9IfScKOiYyjORpK4BOixpqwuz7AYSBcZ+H9XZNpS2RCfI+yHixJTXyK5U+ht?=
 =?us-ascii?Q?wpIEmFKkHCl555bxgzvxRVBoN/ebJ+iYa1kTSSXiqJb6EIumT89U81GKlHzA?=
 =?us-ascii?Q?6QvwlcREPbXG2bYe6BrLzL0XshDvqQqZNavpqoOoLfM8e5cdlK/zfwiZjV1a?=
 =?us-ascii?Q?+YvXFj3AZmS392AOZupa1FbveJ1Ehk6KW/8qd54LAZvirwCHNeNTyNcH+Qs4?=
 =?us-ascii?Q?4xtiv7Q8JtBvcoBlbLiJjxKqcD4PGJCbg3PcqnPTlffWMsPKfwLDiKftrrRp?=
 =?us-ascii?Q?ngwoNp1tEeFJ5XYenLPgYLooTMMTUbEHFTdiJidV9EmIQi+M5aBNtEI8tmtj?=
 =?us-ascii?Q?z4CvtR/r1mrAgZ9mDDgXjf6Sv/F6A80ufVt/Hgp1GOeflkH6/YePxToyM+Q0?=
 =?us-ascii?Q?EMXx37fO5V37AVrTGwML2w8RIN7AAjirHFzm/VmJCJ8QaEHVTC2tfDHkIL0z?=
 =?us-ascii?Q?Ho+Y3V+pa1jD+MP5Zmb0dpfa+lKmazaXsDUeiAukzaZkSbo9n7SCSb9t++qr?=
 =?us-ascii?Q?feHmFb4XLa7Z81kkSvqS7slUznw3fA9uZcFkdszu87Qr9vUu1jA2jD3EnexL?=
 =?us-ascii?Q?viNbsxEHlOmvKJUf4BwXgL2R8kHiO33KlzEzZUG4Owo8EbUWkGd4wbuZmAXI?=
 =?us-ascii?Q?W2CXCWWAf5bbiRRBVYdS8G/pw0egk2KO/EaDfHLmsddVDIJzXaJS49R5mRHE?=
 =?us-ascii?Q?lC01VwhVV8dR3Ddm+sRYLCI6fMQMYJS5PTSqmGO62cvKgS0CF3ZpxBqb/H4x?=
 =?us-ascii?Q?2XfUSjo7orJonQWeX7tC19cV6JlP0J9wUOWR/nzOVuwoWLK3lrl/brgSfF91?=
 =?us-ascii?Q?0f6P+V5tEy3ol8hxX7K9+bFJB1sjKabOzfhXSxhGA2ms/wzkMJFBCL/2d16l?=
 =?us-ascii?Q?ftAYBwooW/Ryn0OzMKzAuuJzSB9iUnp139exbvJu7hwyFBiEftLsMh5AWlGJ?=
 =?us-ascii?Q?TdNBQzMwlj4AiVcmD7JubD7ZimkeKbAZu74gdLTIbqqpdQRcPlRPzUUPVFB1?=
 =?us-ascii?Q?S3NwpUAwDCESOnbucrMRo6PbmJPkj8HiLuVB0UhyfeCXGcvMfvavnEgDzWu0?=
 =?us-ascii?Q?KdOPwPakJGI3rtMqHyQ+3w6heWQbS79Y+9tqHqsr++IPCnLteOAC+XEQWXwj?=
 =?us-ascii?Q?5h1zP+pu3Ceuf3dDh5CLYAgWAV1wSBhz3HNzFu2iJ+DgCDIgVBRn5MP9w8ZZ?=
 =?us-ascii?Q?WLNRgmc0plnzyY+R2oWbfWI63VhUobopYfH1s+IVSgFTOGNet5v4t7K8ihZC?=
 =?us-ascii?Q?QfX/tCToI5+NvqXpD/dcCMn1QQeD/IBuFwujIknKK3gY+t4+Ai0ukHA46hQp?=
 =?us-ascii?Q?c15rUUAcVPC2AYjYAbANosKrXhjL7a/pkp6Mk+rOjLX9KiD1pWEfLe62X3Gw?=
 =?us-ascii?Q?JR8vwjH1jNhvIq/MqOt9bS0vYDseMra6llqG+IfKpfp9y0zdQkQP4O0+60u9?=
 =?us-ascii?Q?/UlJiQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7893b14-eefb-4eec-157e-08dac2a17517
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:26:33.8191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiAyhEi45/F6Kg5XYE64GmErsK/QQVJ06GuxSygFLoOC05gCOX1U/plxZWqwD8YEvyGql5PXTPbQpzeTTrgVgwbA5M4eJkJp9TMIhEfnW8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090168
X-Proofpoint-GUID: cdrFfj50nQf1hUXmF3kglzOd2NsDWMmc
X-Proofpoint-ORIG-GUID: cdrFfj50nQf1hUXmF3kglzOd2NsDWMmc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a test to verify the xfs_spaceman fsuuid functionality.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/557     | 31 +++++++++++++++++++++++++++++++
 tests/xfs/557.out |  2 ++
 2 files changed, 33 insertions(+)
 create mode 100755 tests/xfs/557
 create mode 100644 tests/xfs/557.out

diff --git a/tests/xfs/557 b/tests/xfs/557
new file mode 100755
index 00000000..0b41e693
--- /dev/null
+++ b/tests/xfs/557
@@ -0,0 +1,31 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 557
+#
+# Test to verify xfs_spaceman fsuuid functionality
+#
+. ./common/preamble
+_begin_fstest auto quick spaceman
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_spaceman_command "fsuuid"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+expected_uuid="$(_scratch_xfs_admin -u)"
+actual_uuid="$($XFS_SPACEMAN_PROG -c "fsuuid" $SCRATCH_MNT)"
+
+if [ "$expected_uuid" != "$actual_uuid" ]; then
+        echo "expected UUID ($expected_uuid) != actual UUID ($actual_uuid)"
+fi
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/557.out b/tests/xfs/557.out
new file mode 100644
index 00000000..1f1ae1d4
--- /dev/null
+++ b/tests/xfs/557.out
@@ -0,0 +1,2 @@
+QA output created by 557
+Silence is golden
-- 
2.25.1

