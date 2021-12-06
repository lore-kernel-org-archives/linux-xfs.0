Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD154C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Dec 2021 23:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbhLFXyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Dec 2021 18:54:37 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32484 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357392AbhLFXyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Dec 2021 18:54:36 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5QTU007515;
        Mon, 6 Dec 2021 23:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=SqLjEOdnWg9k4KM4FRi6pRfU31YCaFyZXm+vkzR7KGI=;
 b=XrOjIs11ViAIrP+nvmm48KTzL7tGdDXU1AtAD2QEYLVv2e6WfsYPF4PY7ZdYsHXl5Zoj
 XJ0aiRR2TAatGOib/tE6PKvfblomGbnqA3w0reqfZO+AmTob81TFXaU1sf7JY9maLCkF
 tRzZbnw2I5v7cKZtdx0vzo5kaVznW/pggxWT3/xzqS3ezmROatpiLxDtAN5erkgi7o52
 ZWjyuuXP06jZ3f70gU3LCpKyzD70vclxSv1KmKAaYbs/kf4HVoZ9lw2ER4RDjm0dvleK
 Yh6nB0F8cUN416CZd1awKeRajQEBxpy3su2Xr/oZ1oIm56H5GdCeK0Fs/vbCdc0nsLnV Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csd2ybmkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 23:51:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B6Nk4V2068124;
        Mon, 6 Dec 2021 23:51:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3020.oracle.com with ESMTP id 3cr0545610-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Dec 2021 23:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAzH9mRN1Gi4UIV8RkyP5qMk7K10pno2nqx9AtUUjo+ttog5rA3PySNVlIoBCqty+OUCtZ5I82tQLLSRAfdEaXnVdstEi75y2+M7omYcEdK68+qDZzSUBKboTmQMJRtzU/EySNrCMMQtPnmy7vzZ0TLIh6dDKEDrTXsGL+zFpuY99AGhoYojzM+V2Ya9qsnXKY+CzvWnO8tkkvNctL+q7HX4dieFeTBhCF/OqI93A5hQVwSP12XM5qLp0jNObJwQnnyUKUtnEFJrb2R7le/rJwI8A8I8u142BGSvPnc6mjlghTQxMVNthJGmwPI8J8v/eCer7kxdA49AYlrNfs3QXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqLjEOdnWg9k4KM4FRi6pRfU31YCaFyZXm+vkzR7KGI=;
 b=aB5/qJhIZA7xmLG2qsugAJgA8Mc6J6aSb4y2f3qSLvfxuqHeyf0WOlGR41L4nAFgiNgDN3qDBW+1YBbQGD0IVr+aHylubz64huaqDL6+2DAG4s+UW+6dv4zyp1Pc9q+QVD5KEgnNg2SjhWKvhqtXq2GmJyfzmXJ9IckBKcD44D6pgVGG9z+5XUn+16xppnnCuTNgdB4SAJbFiPokiWFfYC4D3JvXIBAlKJ01tkXktRsbtyNPBVlaQipLvKIYl/1FNyRiFldnrxayu3CvnjbQrh/OcBeKuonrB1WW7OQ7xotdpDpEe2pms3LWX53oiQdNjjzbPe+7eMlbKhvvJ7Iocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqLjEOdnWg9k4KM4FRi6pRfU31YCaFyZXm+vkzR7KGI=;
 b=FDuEqei6e5IcTUsM5wFQqzPZS6+snRqWHCbH39yg1VgL4aZAI/vFeP2Mp/s74x9HpUbATptCMixnpiuy/K3o9Gfc0c6hpRYAzO5cSqAfwNXQXPdQbyfjpd0QzuIwCUgAGoKMTjKPmyQq1zQ+lFEemVMnxsts/+Stk7wBelQhd3w=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2331.namprd10.prod.outlook.com (2603:10b6:4:2f::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.15; Mon, 6 Dec 2021 23:51:04 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%4]) with mapi id 15.20.4755.022; Mon, 6 Dec 2021
 23:51:04 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v4 1/1] xfstests: Add Log Attribute Replay test
Date:   Mon,  6 Dec 2021 23:50:57 +0000
Message-Id: <20211206235057.65575-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206235057.65575-1-catherine.hoang@oracle.com>
References: <20211206235057.65575-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0119.namprd04.prod.outlook.com
 (2603:10b6:806:122::34) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SN7PR04CA0119.namprd04.prod.outlook.com (2603:10b6:806:122::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Mon, 6 Dec 2021 23:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0901b8ef-c7ec-41de-aa93-08d9b91343a2
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2331:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2331025A2D6007F944AA9321896D9@DM5PR1001MB2331.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpJGVs+luXOI/L8pbsma0ZVYcpGOYbvik1hm3a5JEsSrcm8qAA6RI9nIdxcZ5xbi4asoRi/NWKQBmUUuAT5upmMZvAbH0Jha2GeQ/HX86/dgRYDUV2yX3nU0J4WFJrkkfWA2e9Iox46+g2umcwcdQ0QeEeIlV7qAy884DizEFMoGfJ6SLXmYyFKIN4ND5q7626PAILlbkP68XRvCma04mVi0okilkpzAwX4/LI7XyxqobaqoBWGljRjJOtaWyuFa3cVUEyUm6oB8NUd3v48/yXkfvPH/Mo1eTg0iYiWE3zQV9Fyr2cgZteP7RTbezPMd/0cuYPtPtwso9WeX1Zm8+hJ7+bnt6COr/1ehaK8HPFl4TjQrF1XNjVjYQ9Do5GmoFVVejrmnUbESMEYQzrtRIwdfbn471r1Fyjem6ZxhZ2V7ULqDa1yE8N07sdaIyejEGpg0DFhzaoDhUtuoescsZJSRbDIL8DNnH8NsJNaslSRk5c44EQXis7Jal8hpmLH49mtK0bZI3RZzUBmYunvypvCjOvIcTssZilq2jTJ0gAYeyV29RcNJme0su0g3drI0FlEEL1fQS3pFhW+onu0kboh+z9ovFBpCDygkP39PP3/h+PgA7G5ZapLn9NMdyYL9g+oosrzidOhw11BTw+KhZxFJ4dfXd01G1C4Y4aVv/UdnNjG7ky/ncm5QCZCP/ZX1XnIVyeR1OLbqIjbXr+ryV2OXqG8ox17zQjz3bNzPGPc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6506007)(66476007)(5660300002)(2906002)(6486002)(44832011)(8936002)(86362001)(83380400001)(66556008)(956004)(2616005)(6512007)(186003)(6666004)(38100700002)(38350700002)(26005)(1076003)(508600001)(52116002)(36756003)(316002)(450100002)(30864003)(8676002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LBEeM7qMqBQlD8culIFuIPvE4B29yfOyeNCZLEwcclOKQNvLUvbaDAgVlUXM?=
 =?us-ascii?Q?NMosx2n5ZhPV0/tPNHaMj0GQ6hQd3nPN1IPq5qB0JlL7NLK4o204w9TZpVt6?=
 =?us-ascii?Q?Qu2G4S5R48756Ze/Jk+CzcTEaa8xUBxZr1sWdUoLKTAQa39VtEpctRwmW7/P?=
 =?us-ascii?Q?vUgVFt7hWnE09xEBIy2RyYCjZYswxH66NhnBe4kHe/5XFm1RkfBYtANVbG0C?=
 =?us-ascii?Q?q0UkX+/e2IjWs+HVTyqhJLy9TC5tt4UUlo4YQgw8Q6z0K+auOjE/4L4+IXZE?=
 =?us-ascii?Q?zRzKFofi1G/uINEkr4vtDBOgO+HOtx5teobQ4dMNhd3LA6VI/WiVB8ZHr7VP?=
 =?us-ascii?Q?Ea+h371SkqwbAoktRLLLatL2GlO6cOretxz9l9gF7Wg5QA9+jOxATCw2SNve?=
 =?us-ascii?Q?1QhjFtODNzSKdrwBikdbun2cb6EGilGCmB0FFTdL1aPgnjPd0tQB/xEbr46b?=
 =?us-ascii?Q?3ACN15/wcoxOyAL6qyPpizxEENGNY+xOIPGF3MABlXH8HSyoKPjxtE/XlxHD?=
 =?us-ascii?Q?r1J1Fwk+3GW5sB8XRW9EOVRIb4K1d8W7QxEVCHXZOAI3Xq7ep9Of+pJKb+SN?=
 =?us-ascii?Q?00vRkdDtT4YEpnsDSBpsMwBB8k2ybV4rUDmb3RAwN9xabG9GJp4lDgkuw/O0?=
 =?us-ascii?Q?kw5YVxpQdEVYfuqwrtiQg4vJWBaki1YjhGLU7X1QFgh+USDhd7AT9GONxaBf?=
 =?us-ascii?Q?2YuQOy98pibdya2i4CTksgFyvn+US/J8VI9CRvyQ+QOBG2kYGkCmv3yAJ8Ql?=
 =?us-ascii?Q?d4mdgZaVAQ1aht7MK5zo15ePIkJxayABG8KnjNZQuKd+RPJEAFX6HSLt5rDE?=
 =?us-ascii?Q?9eeeZM4vkifqHqrbeAoc5aNik2Bf+cqkZ5SeDc0auCsPV/xpwtFTb8o/60r/?=
 =?us-ascii?Q?Fh7Ox3W9aO3rlM4aAXhP7W8yUK2y7Ty/hH6LoPnte3hXt6OLzzLWpxNe6ZIi?=
 =?us-ascii?Q?N+bUgil/LsGb+GqzrJoIUVqKvC9zh4ZB1I+jVciDaS1ngDXVbAkPXYlU9AsO?=
 =?us-ascii?Q?n+OS8rl3fQLDvSNEKF446uvqxZ+14Vv4IJmr4eF98SU4BUt6kB+ieEMpDJav?=
 =?us-ascii?Q?tec5ypI3oSghKhXm8zUO0HFwMVX2yfDX5vKRUTX41rgf9Or++nD7veB8qWoW?=
 =?us-ascii?Q?JTlwjYjmuJpQIiH0Eo/4CcnEHTt+9yaM9gj/z24xQgaiTGq62OERFjW+exqt?=
 =?us-ascii?Q?JkufnsbYWFgMzQ26BdVluhf+FyaKn2gnDlPj7vDXfibteX5BwldvROrbchox?=
 =?us-ascii?Q?834pn36mmUA79/3trSUeDxH8isoY3V/RYQQRj1A4EGe8Uqmcls5qnTCyFstJ?=
 =?us-ascii?Q?Ss8unE7bweorux3A1BUcmecj0ZLaZdoEhOtgNep1/1emAvoMnFbpZ4UJeqIJ?=
 =?us-ascii?Q?soEJDjiHDKQ65+k4l41dPUHcrPvKa/Br4jkzfsBZGYeBDjnLeX5Qs4GQHiWI?=
 =?us-ascii?Q?kp8ne0P5fniVs0vNZH330G3lgm+PY6qaMQRZBhHm3Dwdy4f88QMGGNlc+vox?=
 =?us-ascii?Q?t+S4EMUu370gtlTrw3rAHCRtSjTHusJ2Z47UHiQSHpF7c9rPwTnqpM+LvLn4?=
 =?us-ascii?Q?dp4GZ+Ctav9CtkQXOCCIGtsMPAnN6ChAFd2/Kqs6uLuJXrIAaYaTTVGJPBKz?=
 =?us-ascii?Q?pfqtJcks9kVz+6FDa638xqgtSEZiH9b6uYVe7VupuVgCzFj3JrjdNX7vgvY4?=
 =?us-ascii?Q?wCOqbw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0901b8ef-c7ec-41de-aa93-08d9b91343a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 23:51:04.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/BgaS9gLUS2PkZKLGHdIPvKBRSl0/CIPEPMTf1MGX8bM3LLPSeZQaS18guk6ZRlEjilRoZB5DX5l8lEEw/mBl4q353HqLespl6Zf4bRPoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2331
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112060143
X-Proofpoint-GUID: V0RKoO-4fonBWPAnGHsAT_WDld8AJb1Q
X-Proofpoint-ORIG-GUID: V0RKoO-4fonBWPAnGHsAT_WDld8AJb1Q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds tests to exercise the log attribute error
inject and log replay. These tests aim to cover cases where attributes
are added, removed, and overwritten in each format (shortform, leaf,
node). Error inject is used to replay these operations from the log.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/542     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/542.out | 149 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+)
 create mode 100755 tests/xfs/542
 create mode 100755 tests/xfs/542.out

diff --git a/tests/xfs/542 b/tests/xfs/542
new file mode 100755
index 00000000..2e6edaaa
--- /dev/null
+++ b/tests/xfs/542
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 542
+#
+# Log attribute replay test
+#
+. ./common/preamble
+_begin_fstest auto quick attr
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/attr
+. ./common/inject
+
+_cleanup()
+{
+	rm -f $tmp.*
+	echo 0 > /sys/fs/xfs/debug/larp
+}
+
+test_attr_replay()
+{
+	testfile=$SCRATCH_MNT/$1
+	attr_name=$2
+	attr_value=$3
+	flag=$4
+	error_tag=$5
+
+	# Inject error
+	_scratch_inject_error $error_tag
+
+	# Set attribute
+	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
+			    _filter_scratch
+
+	# FS should be shut down, touch will fail
+	touch $testfile 2>&1 | _filter_scratch
+
+	# Remount to replay log
+	_scratch_remount_dump_log >> $seqres.full
+
+	# FS should be online, touch should succeed
+	touch $testfile
+
+	# Verify attr recovery
+	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
+
+	echo ""
+}
+
+create_test_file()
+{
+	filename=$SCRATCH_MNT/$1
+	count=$2
+	attr_value=$3
+
+	touch $filename
+
+	for i in `seq $count`
+	do
+		$ATTR_PROG -s "attr_name$i" -V $attr_value $filename >> \
+			$seqres.full
+	done
+}
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "larp"
+_require_xfs_io_error_injection "larp_leaf_split"
+_require_xfs_io_error_injection "larp_leaf_to_node"
+_require_xfs_sysfs debug/larp
+
+# turn on log attributes
+echo 1 > /sys/fs/xfs/debug/larp
+
+attr16="0123456789ABCDEF"
+attr64="$attr16$attr16$attr16$attr16"
+attr256="$attr64$attr64$attr64$attr64"
+attr1k="$attr256$attr256$attr256$attr256"
+attr4k="$attr1k$attr1k$attr1k$attr1k"
+attr8k="$attr4k$attr4k"
+attr16k="$attr8k$attr8k"
+attr32k="$attr16k$attr16k"
+attr64k="$attr32k$attr32k"
+
+echo "*** mkfs"
+_scratch_mkfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+# empty, inline
+create_test_file empty_file1 0
+test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
+test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
+
+# empty, internal
+create_test_file empty_file2 0
+test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
+test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
+
+# empty, remote
+create_test_file empty_file3 0
+test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
+test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
+
+# inline, inline
+create_test_file inline_file1 1 $attr16
+test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
+test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
+
+# inline, internal
+create_test_file inline_file2 1 $attr16
+test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
+test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
+
+# inline, remote
+create_test_file inline_file3 1 $attr16
+test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
+test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
+
+# extent, internal
+create_test_file extent_file1 1 $attr1k
+test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
+test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
+
+# extent, inject error on split
+create_test_file extent_file2 3 $attr1k
+test_attr_replay extent_file2 "attr_name4" $attr1k "s" "larp_leaf_split"
+
+# extent, inject error on fork transition
+create_test_file extent_file3 3 $attr1k
+test_attr_replay extent_file3 "attr_name4" $attr1k "s" "larp_leaf_to_node"
+
+# extent, remote
+create_test_file extent_file4 1 $attr1k
+test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
+test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
+
+# remote, internal
+create_test_file remote_file1 1 $attr64k
+test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
+test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
+
+# remote, remote
+create_test_file remote_file2 1 $attr64k
+test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
+test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
+
+# replace shortform
+create_test_file sf_file 2 $attr64
+test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
+
+# replace leaf
+create_test_file leaf_file 2 $attr1k
+test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
+
+# replace node
+create_test_file node_file 1 $attr64k
+$ATTR_PROG -s "attr_name2" -V $attr1k $SCRATCH_MNT/node_file \
+		>> $seqres.full
+test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/542.out b/tests/xfs/542.out
new file mode 100755
index 00000000..72a04044
--- /dev/null
+++ b/tests/xfs/542.out
@@ -0,0 +1,149 @@
+QA output created by 542
+*** mkfs
+*** mount FS
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/empty_file1
+touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
+db6747306e971b6e3fd474aae10159a1  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/empty_file1
+touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/empty_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/empty_file2
+touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
+d489897d7ba99c2815052ae7dca29097  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/empty_file2
+touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/empty_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/empty_file3
+touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
+0ba8b18d622a11b5ff89336761380857  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/empty_file3
+touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
+attr_get: No data available
+Could not get "attr_name" for SCRATCH_MNT/empty_file3
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/inline_file1
+touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
+49f4f904e12102a3423d8ab3f845e6e8  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/inline_file1
+touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/inline_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/inline_file2
+touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
+6a0bd8b5aaa619bcd51f2ead0208f1bb  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/inline_file2
+touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/inline_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/inline_file3
+touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
+3276329baa72c32f0a4a5cb0dbf813df  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/inline_file3
+touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/inline_file3
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/extent_file1
+touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
+8c6a952b2dbecaa5a308a00d2022e599  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/extent_file1
+touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/extent_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name4" for SCRATCH_MNT/extent_file2
+touch: cannot touch 'SCRATCH_MNT/extent_file2': Input/output error
+c5ae4d474e547819a8807cfde66daba2  -
+
+attr_set: Input/output error
+Could not set "attr_name4" for SCRATCH_MNT/extent_file3
+touch: cannot touch 'SCRATCH_MNT/extent_file3': Input/output error
+17bae95be35ce7a0e6d4327b67da932b  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/extent_file4
+touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
+d17d94c39a964409b8b8173a51f8e951  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/extent_file4
+touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/extent_file4
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/remote_file1
+touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
+4104e21da013632e636cdd044884ca94  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/remote_file1
+touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/remote_file1
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/remote_file2
+touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
+9ac16e37ecd6f6c24de3f724c49199a8  -
+
+attr_remove: Input/output error
+Could not remove "attr_name2" for SCRATCH_MNT/remote_file2
+touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
+attr_get: No data available
+Could not get "attr_name2" for SCRATCH_MNT/remote_file2
+d41d8cd98f00b204e9800998ecf8427e  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/sf_file
+touch: cannot touch 'SCRATCH_MNT/sf_file': Input/output error
+33bc798a506b093a7c2cdea122a738d7  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/leaf_file
+touch: cannot touch 'SCRATCH_MNT/leaf_file': Input/output error
+dec146c586813046f4b876bcecbaa713  -
+
+attr_set: Input/output error
+Could not set "attr_name2" for SCRATCH_MNT/node_file
+touch: cannot touch 'SCRATCH_MNT/node_file': Input/output error
+e97ce3d15f9f28607b51f76bf8b7296c  -
+
+*** done
-- 
2.25.1

