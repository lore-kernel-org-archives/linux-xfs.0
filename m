Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977EAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiAJVV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:21:59 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47764 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241222AbiAJVV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:21:59 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJm2lf026247;
        Mon, 10 Jan 2022 21:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=jpjRJmQCHCAczjUBvv+Vx4qvftiuzICWY71vOyBnIiY=;
 b=XQDEzhC3crDhkViherRjskS5whbDZ4sYmD2Sk2gvTckp9GXaFZ3S4/ELtsAVWBVXlEvk
 kDgKtQtO5ZUYl6kyCq9Y5HRGs/6LWZPKiKv5C+V658cWR3y6W0/PH3TnSHMiL7KdtttO
 LI4qo/gOBvBQ9ByW0rlqk7cpDgJb6y94Y5WgKpblCTzPhtxBiOtvaI2Z4QidZv7M/wNI
 Ksz0nGoZcUZbcPMAyGDNiorGHmu2jebvRc8P1GrrtcZSU/OumIdVE7jhGFJmsaQG2zxM
 nHXJv+gruOuvH9xVkeWa3MQuJf3/ZCVN7UWpnSrsTe7aM6PCB8QHS+ujlwcgvf4Y4Jo2 pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7nh7pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 21:21:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AL1ZRq062250;
        Mon, 10 Jan 2022 21:21:53 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3020.oracle.com with ESMTP id 3df42kkbq5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 21:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kONKclaPhlNVq+e9ESmkj64oTXnmMu3N0/Y0EE+8ecqPwTAGMy6OvJMmP2PXtp2sIHPKCaIpDS8QaOLmzxU5nvyxp+jxKCMuaieIjXkqOP/8opdfpyV6hoN/xpiLVsSRK05qCCYzPOwA/+luCyP3y9K/tsOkAM6G14NhNrXqqNjunybs3URnimHdh+PqbPKyl5wNdmk8YPbIzPTaM2fPxWzmir4aioZLduYK8gZTByPb1OOnhN54MLJRWVbzRJGQtDCqlVDv4p+IJQ0oMP5ymSP/qtJgcqLePoEtOfo2rJqwb4/R5rOAV4Epu8Or0OHUusWcrG3Nt3PV4cJY4EuxAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpjRJmQCHCAczjUBvv+Vx4qvftiuzICWY71vOyBnIiY=;
 b=Lp7CXbY5wW0bKNe4SEvmf+bqk0HBt/QfcQb7MAYJCiq+wH+6vOmp50Kp6aXYRq0+tDnRHiWHFu3yP5J6BXDKGjc+GRiZPaD8sLI0XWRrfSeT83xsmHn16cGYr0pPG/ifk8n3TkYd2AAtB2vWS36BDIFop79oNdzn77jEo56sfy7GG1t3wjde+D0p2Q63xYAa8dMyLqrBuxS9xTnBmKvfD9EmN5Lai9JHUwPJCPQzSXt1wdMTr/X2WjlEHJhPgEDGUcWRHqslEzPzjFT7W2xuwTcNWFe84O0D0T/1S4T1AsZIjFoauCY3SyxqApWE0c/cyAxWtR7t80QGbbxk/lyxmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpjRJmQCHCAczjUBvv+Vx4qvftiuzICWY71vOyBnIiY=;
 b=QgzmSSQJ+D9qKagL8JEDB1/1tU+LFpeib3A36lKySszVeQ1p1DyfbuS160ufsq9npD8mt3eoVXNIzlWt3Xd1hcF3qAysDB84rNnCvKks/qBOwOgQa5k+h9L2plt+XsznVcL5WQ9QY3vUsGcndOZ69aRwnI+kCrQk9pSY4Ij2rjo=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2652.namprd10.prod.outlook.com (2603:10b6:5:ab::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:21:52 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:21:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v5 1/1] xfstests: Add Log Attribute Replay test
Date:   Mon, 10 Jan 2022 21:21:43 +0000
Message-Id: <20220110212143.359663-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110212143.359663-1-catherine.hoang@oracle.com>
References: <20220110212143.359663-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6bd654d-5e74-4f36-fe12-08d9d47f3832
X-MS-TrafficTypeDiagnostic: DM6PR10MB2652:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB265273B2D97764BB2ED9E23089509@DM6PR10MB2652.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snAQGAvJoMXeXQz8XKWWNccZRjrUBtGkDm64HYsK+Z3Xt2A7a+fQEvkh99jprHQfBrEIb/M+mqtvV1ztnhAtvaB3BjEOkMLKygpM90xt8ygsV/FaZ73cLAE0MP2+CPtENiBwSt9al4Mc/hbMd1Wa7W7gepbhR1DefGiZ3KKIhTXH2XZrnqlrRBXRVyQbjG2WswNjDkY+t6QWKlLzIhtUcY5O8wGyCgTlZfrOrYGy+Z2tLRhAEMDrCKMeF0f9R7NMljhTZ4CcdifVZubrK1VBzWxFpF8Vp4Y1TB+f4YAbaR7PtLIL3Skt7+kGxBrQoNVd3we0d5KmUGw8pCshvoWbvBZ+NOPeCpMJiU8m8c5d+1jUemEaNUzX88Euku99nIZus99ACPsFYS/LnAyuYfz92QGQ8dafzswA3+whzujn1iBaIkS5j4JdWtcR+4U/p6dDwc5IITxzxS7a7eO74uHHGmig07pKGa9DNRiUvpYsB0ZlPZWGsqCcF4dwZIyAHxP8XXFsBDu8ye/irDMOHFQi7jCqDYm+S4UcYYhNsrKcQZrhguUHsZDi7cmwQSB9PX0SsSIxFZDEDPjIbRA3CZ5eaFtWRpv1W9kUXjyq4XEv0BBkBvqlcV5nagUVh5/XUrCg2Da+AzUHH2kYdAdDMehWKrYmUxM8ekFzqv+ANakUvPRkNe3+JaZd6WGD8jiFxdSqimCzVxwcYfTDKu6PxiWwD1V+8Mzsc8v5Rr/RYjS1u3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(450100002)(186003)(38100700002)(1076003)(44832011)(316002)(26005)(36756003)(52116002)(8676002)(6506007)(8936002)(5660300002)(6512007)(86362001)(2616005)(508600001)(66946007)(2906002)(83380400001)(66476007)(66556008)(6666004)(6486002)(30864003)(38350700002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L8aTKqez32Jb1DrN/gIDkI140Ol4/PE4gq4vYVKIEsLpwpms7ISXtkENaSE7?=
 =?us-ascii?Q?//7+mIRooPlBP0RTZqM/sIAClIzns6t7DppTenCuYS0A8hstna7Ff8B7eiJP?=
 =?us-ascii?Q?UwmTDiKNcqCZXA5qYwCxZBIaI+1qGK8TyG6nZZi1Gs0osWn2GV0DZuc4l4Pl?=
 =?us-ascii?Q?qwSAcs5ZPrfrfGGS5SH/ufqOzm4aAgyoKLL6jAJKSS9rqr7tV+3lAc3leS4g?=
 =?us-ascii?Q?J0nUxD8m5NTvU4CJ0onAkwgR5/LdLC7EomRbl9zZf4u8+NJp/5gudjlFiyFg?=
 =?us-ascii?Q?55NI+PG7ydAOmESgLa6sT9Gh00eRov5Jp6nxyWWB0Vajj4JtuCbPq3KCZ9AI?=
 =?us-ascii?Q?YBIMrRTNsyP60fKFW3kqwqGeHYBEgJZ80txqC85IPiepslSPpwIOhZMdPLJm?=
 =?us-ascii?Q?S43pd/iGba92egdeyWYPCTjr6HZ2/HxZNz2MiFE/Uhzy7zRCtVR/jsBkMlm4?=
 =?us-ascii?Q?afI1e5CNF1jC+7yDWvwnosb9kzafr+sWMXb/QIyMRqkVtrT2cVp5SP79EhaL?=
 =?us-ascii?Q?CeboPmSuiPLkNmRFevmfY4JKFQ4dkEW8DKL9UL8kKxTresOSAkOUVpYb8rON?=
 =?us-ascii?Q?OceE/vFBxZl9+4/eEJbDMG32ePE4LFthcnZXx7roF/RRpwWSzE46c5S0c4Po?=
 =?us-ascii?Q?Lx7d0cTOeZDR+fFDx28SF1sOzDeZnkV3IVJfgtqoN4z+hPwx/9cvu641cYvY?=
 =?us-ascii?Q?ypY7cZbOy5R0X//g+KqI8uT29CEo5ixJMDeeTYyG42TZ6GA7dcmSG/xOu5jC?=
 =?us-ascii?Q?bhMMylsmljlr5wu82nrdMLziQjSwrHZNHMePjOh8ehtix+Og85tR7bv3Koer?=
 =?us-ascii?Q?jT/ZKTWriP0LFXPh6HjEV7gsO4Of8eqc/k4pwtgn1MA4wOlphDQmROlvHe+A?=
 =?us-ascii?Q?rJs/YRw2nzevd9R6wwm649Z+G0OPvRnbGVE89mpl5mng3FBgQb8SvDMnmvd3?=
 =?us-ascii?Q?/BRZZAzhZAvdSqy0cTOPjNsuf/bH0gW1eG6u5ojUfvD0U2p6F6Cj+dJiumNm?=
 =?us-ascii?Q?mqmh3YaPswNtLiV+Jh0psGcxEf57F2Zvse6jbLNt6j+JujV8v/6e17sZDRll?=
 =?us-ascii?Q?ZwjAjtMWrwjTFPBvKQBJXxhwnw20jCsAYea5Yx91TD+9Q3tVBDbv+A9ByHds?=
 =?us-ascii?Q?uv5SOU+1mKmEy5ocGuhYcNzlz63LiRc/34HY1W1NQ++UGALMd258J3yVtV0l?=
 =?us-ascii?Q?CLb9xZmIR1IOwi6ohG5obnOQRB1vUe48gL3kGIwppKBM8QlkYd6NGrki+4yz?=
 =?us-ascii?Q?JAq3qMwuLDoenyujjXFi0qiVeN+K4l+6Rv6gUBmiy1+Pb75d1185JV5BoBCP?=
 =?us-ascii?Q?tW4AGjf14Eks30GRz9X/lKJS6NsU71DhkpOLz0jdv9g+IyJ0vfPcZpMem1LV?=
 =?us-ascii?Q?2gRrqFMLxIv6obb26zBZEuRDMPpxUSZPiT6Mflo6k7fgdQPDFIyIm/zr5ORo?=
 =?us-ascii?Q?/ylEN0d8nx7rv4SVftSq0qwp/jouLPwnn+LDcl/sRO5bTxPg/el/vgPHPSV7?=
 =?us-ascii?Q?XMGsZja6vLPsO9G36u+kPEdTD9xFb4OABWO5T9gB/7VMqX+Q24H8QSlUZk3g?=
 =?us-ascii?Q?H+y1qqqgNnHm7ouD0jp3QlGcpAU+eQoF4CcZfqg2PcV6YJu1vRfjx6E6Zl7+?=
 =?us-ascii?Q?I+0XOQX93solqQU9u5kS9eF2guJyCx9MqP9sHsb7fWVoCerMf9QT2FMUC454?=
 =?us-ascii?Q?hWS+pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6bd654d-5e74-4f36-fe12-08d9d47f3832
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:21:52.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4r9x1YofdNizrC3SvXsW6ZgF38QePnxoZbHim4ytsTfPhxa/6CAyUHUaH/zX50oOpljW2AMruKyIFN7kEdwYAx+1kdwGxJ6HDcxTaFAREEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2652
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100141
X-Proofpoint-GUID: ySTdiyAN5hbrcpyIBeEuICpONzWqo3ZT
X-Proofpoint-ORIG-GUID: ySTdiyAN5hbrcpyIBeEuICpONzWqo3ZT
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
 tests/xfs/543     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/543.out | 149 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 320 insertions(+)
 create mode 100755 tests/xfs/543
 create mode 100644 tests/xfs/543.out

diff --git a/tests/xfs/543 b/tests/xfs/543
new file mode 100755
index 00000000..29bd5b77
--- /dev/null
+++ b/tests/xfs/543
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 543
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
diff --git a/tests/xfs/543.out b/tests/xfs/543.out
new file mode 100644
index 00000000..075eecb3
--- /dev/null
+++ b/tests/xfs/543.out
@@ -0,0 +1,149 @@
+QA output created by 543
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

