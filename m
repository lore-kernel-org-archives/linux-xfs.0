Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B07FC43216
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 19:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434876109E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 19:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242473AbhHYTwm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 15:52:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17254 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235554AbhHYTwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 15:52:42 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PIOAmQ006325;
        Wed, 25 Aug 2021 19:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=JL+ivHaBtDZoez/B59bqidlZFQIbJc/H/BjxFzIQMFo=;
 b=yHMWedVpWP29d3QYa05vzt1ThZ2AEslP1mCSref0/LZW+QPW2NjBM3o52jkIhdScnxjp
 bGEc+7FmL3rNTNe6CZWPkn7FDygQNhpUPr68/kkEGHjFTvOH1AzU7QpIDEkdiY8I+FgU
 7+2EmPyzG+OAGc928NFKZIRKSdmw5DBjc1VrsKBeA3Lgzdwf4tEnbJhmIHzUp2juCY0W
 TE5PAdwQlzI42wA0P8GjqvanV22BxMFvRIlOQPKaeu5RtaWA78PbTmdZ12Bh/9y91BRY
 kG6m2WwQaEXHg5E0W4Jxii1TVGKpAx6APUQQPha1YzD0HKuXqA/IVXN3wxizKN00Zgs9 nA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=JL+ivHaBtDZoez/B59bqidlZFQIbJc/H/BjxFzIQMFo=;
 b=DK0qkepPlawm0oenG2qUu3UY/nA0T2drPiL86rf+lBVXgyXMyGScZm63kR6DGAws5sVB
 rSQTwcDMEFYVRWEQNKHJ3BWAI3aGWPre/HRnQu1RrI35Oz0G7iPnGqJvgHaLEwxBwp66
 qYXwWXWzAAlN9rcQWZ7O8OgXV6vfR1FDnfSnvUZdvIYJzO2Cn4j3MJMNsQrNqOk7zxWe
 r1xU4nkToQS4lHnnq52a6JZrUxpNm/PtqkJZbO4r5LzSIVlOzXZerIKqSGN2dH5wnNCl
 Yy6BM7vEf/HyTPZ32RG7+p+k2cWWCbGjVWo1Ma0tyVkFvRgX3d06llm1qQBNc4Bm7KyL jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwmvchd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 19:51:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17PJpLnI097574;
        Wed, 25 Aug 2021 19:51:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by aserp3020.oracle.com with ESMTP id 3ajsa7xkg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 19:51:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUhxWyd4485ihwNC+NgQvvtFbYZQ3A5PAYNEywacmxuDiiGRdPA9rJzXyXfeZwH4SldZJm8ZUg3P4PRTuIvWc3jQGUqhZGPfMrUVgcLYa6u5JlqLKNcHoWAFxYd0/XGKT2pNSAMpzOnKlXPlQTi90DEXcxMzP1XZE10Pqa7C7ijRGnq+lgjfFANvMsYCT6Rwxx36qJ1emF2+VjEEG4tiOMW8ax2jB/uW+fdwG8YHStpBDux22K5XJqhwvO8fJJ2Cgm5RgaMWrvVE7QVOTjGiJmdNDXidWoML3QTBvsF77xxQDSEifdsgGxnGO7c76dq3gAgxiCCvaPM0xtBTLLe0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL+ivHaBtDZoez/B59bqidlZFQIbJc/H/BjxFzIQMFo=;
 b=mXFlFG95XgF/adNSamkKnfYJW4wmC8tmvSvmBRWRoDLiaqHsRJVKJZY6HqaKtwLalFYP286BH7Ah9eCCckYoWGpewpoxiIYJIjF+YPtF9XmZ/Yj+td8q5L73F5bGKypk9NkQGMPpsfRRae9m/+JCil1fRywwfTx8v0rMHxFLIvFhlFDnDSUlnAPwbxUc48X7ra3x0xOxPVvA3GdEWGB6rYDpDAoLX/jW41PasV/1cLs8JvhfyzBJe52IGKyASBtw5WSMmbqtLMJgMGRmj1CRT9XDroUSJRIYOefXmjAIJvDM3jBDX0hlbcP7Eujarhu3s7Fssr/9XecmycU0mcBb2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JL+ivHaBtDZoez/B59bqidlZFQIbJc/H/BjxFzIQMFo=;
 b=ATlyvOTPLKENBdAI0PrTUwlwqbSe7Lc8dA2bjA0eMlYBVVwcsAUWs1nULoBiNlFZ5M7TokV/3NWWRNerKF8M1eWCAjTstumTpaXNvSa03eu1jtR7jPMMyvLVUeNOAlFOWXRdiInrAlp+VamH+1Qjr665S1zudniOs0CVNQIsPjE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1483.namprd10.prod.outlook.com (2603:10b6:3:11::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.17; Wed, 25 Aug 2021 19:51:52 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a0c5:940:b31d:202b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a0c5:940:b31d:202b%7]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 19:51:52 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/1] xfstests: Add Log Attribute Replay test
Date:   Wed, 25 Aug 2021 12:51:44 -0700
Message-Id: <20210825195144.2283-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210825195144.2283-1-catherine.hoang@oracle.com>
References: <20210825195144.2283-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:180::16) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from catherine-VirtualBox.attlocal.net (99.0.82.40) by BY5PR13CA0003.namprd13.prod.outlook.com (2603:10b6:a03:180::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 19:51:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a86910f-6533-481d-6d54-08d96801c8dd
X-MS-TrafficTypeDiagnostic: DM5PR10MB1483:
X-Microsoft-Antispam-PRVS: <DM5PR10MB1483F0BD1925457EC6DF326B89C69@DM5PR10MB1483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIWZ5qWl9UXLlRv8ooADtjV2HLG0BS5S9K43lRShR9ofj5ss9yizS3USMnBtOTtmUhTVmw+2B6h1PC+CMmzPIXfrp2IjM5koUYrHyZbaOpoxaqVJjqOWRuvrpjRotXCpi59a9neGGyR2orKo9PmstbbgbQMvbV52tu/raVY9ujK/Br8+sSyD2hYHVth693GQGOSh6KniNjyQ2oweRXaj0QUdYA+8szL0473EK4PSDo95DKlDWqiM1olKgktmusMVl0BowUWA8xb8YauzgYnzlK3R9U5UGOYRipdTCDYFe314u76d9f5GtWtqmXh5Gw4vTDjLPPz/DG/b6xvqPn5lqpgFNVC68GKfwY9bdZQXjp/ds+g8CnkUnuE6QcZST4AqYm0HpdUs2Iiyugwx7ymP2TZgAdC6L14U+qfrJepDZqz03XP2VAI6FGPZIU/XnZd6f3iX6S4awUIk6+5VqDkWLYm3EjUiNpPU4xMMjJxvm5AkhmGdWVKIYI1eSSBebDcYVxk42w0Lsq/s6PQ/sVvfzCEzeePt7I7QsxTxmephm5PDYO5bLTedqU3F14+V1+Px3pjeiuL7ZfZfp4kUelhTYjJBtHkp+H1lWzRGc6plFNho58xJyPYAceLfDFijtkY5Oqt+eeCDCoRzin46PZrYLxnkvIQGV6ARyUKSVJGh1cAm4farL9zHY6nN5qnSnTg82wpTbv4gZFrOjGdVg0F3fmVZJ+bVmuTBGIZ1uo3dCHc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(2616005)(478600001)(1076003)(36756003)(6486002)(38350700002)(186003)(8676002)(956004)(44832011)(26005)(8936002)(38100700002)(66946007)(6666004)(6506007)(5660300002)(66556008)(66476007)(52116002)(86362001)(83380400001)(6512007)(316002)(2906002)(450100002)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rvQSzD8CBcqPMtydjrUgEJpBr41GK86NsZ8YCMGyvgNPW5DeTNOkbbFPvVUC?=
 =?us-ascii?Q?23KILJQYdNkdh4d1/2S0UjjJjBsetZnyWBeueZ0StRnpoTtMq3UpOeNtwsfy?=
 =?us-ascii?Q?8EaAiT8PSIKCNGOTit5oTB6yA9YXSovS9cOd5itycNdR2q9PBK++iVuotD3V?=
 =?us-ascii?Q?ZjaC6FB8ei3BG7C0Jm5QS/ZkcOHb0t8AuVQ6lsHqkjfgYau74jBsJJ1bpkUB?=
 =?us-ascii?Q?wOLV0xWPURvoBKaVq9w99XLV9oDexwd615NPn52omVJlB2Q9aVvJnIOqfCS7?=
 =?us-ascii?Q?fX1vedeBg5kQtNrDEbzc3fanKmc6v8s9PG1yiLwLudUe/uD9AXC68BCFYTju?=
 =?us-ascii?Q?rjiSDsGAXZPjer+fr55jLsA3qG/6iV0HsEgZnnUg9mgUOpLtKXgIQWCVQ6XM?=
 =?us-ascii?Q?Lf06/qsxNXiDgA8zkvrdltYLLXq78cD1R4l6mkrJufaqh8cdZHZTOnAoEsZE?=
 =?us-ascii?Q?+FaQpedwt24WLV7znNanHGnBBJQ4a6nleUvYwe9odQPUNiQ9cSu6tysJu+5h?=
 =?us-ascii?Q?VFuCvske+zZCpP2O4NeWPV0YlK1rztP5/wWpC6Kdk5lgk14eAR20zDVUWB9U?=
 =?us-ascii?Q?FsPOVDmxixUvQvM3AJMmCkokLTX/FO8tktWYoKmkAdAA5tN1+PlU1mM3o4oT?=
 =?us-ascii?Q?ldhNL70URGh7PbcoyCVxMd3CoAedTVqSTLtiP9vdlLOUaJf9oa3XnhRECcqJ?=
 =?us-ascii?Q?J29WSm7nzASfprfOx0mOXERbf3QRZJW5f41FPMYICH3PIJ86hCTrf/79Hzk6?=
 =?us-ascii?Q?v7N9dWvb2kBZBQeZk9lJbzCT8kT8/zr28YnNK+PwLC7PaJp0KvHXYpIraksD?=
 =?us-ascii?Q?udlXzszDXeet7YETPTBohx7TMr80Nm8dlPBK7v3L+p+JO6TTNJezJW/HwbZc?=
 =?us-ascii?Q?8GXoeSBiZK/VMmE7BzVj5hDrWZxzMST+HewOFZQMIjDWY6HlhCiEt1cr2bpI?=
 =?us-ascii?Q?GAF810TGr5w7A55GboA9RuJe/2mPgyXVc61ukI7wkvWx1qo1C7BH38cfu96K?=
 =?us-ascii?Q?VT1zerpL2+104yzeQN/JJiNXm9Lxp4+QqxPgUsZ6Dv00J2m32wg63Na6P+XP?=
 =?us-ascii?Q?NQ62JKvnVwpwX41yEGoj+NWX51hYfAuIqv3P6cJZ8sGH4sHbHdbzQMnPL6z8?=
 =?us-ascii?Q?x32e9Ptju3nIAMB3CTUHOjic+EaOt0tFiu9A5UyeJ4Cky4LluByD3gymAUp0?=
 =?us-ascii?Q?5HUHcv1GPjwAANoz57q0oKMuwcggd6eQzvouBDqi1Gr6rOm1QQk68Tnn9RV8?=
 =?us-ascii?Q?QLcp6fbAZ3EOFaMl0IVyLyLqRSSDjkXcYM1nIQ0XG/LQAqM3nLrXIDk1LzH0?=
 =?us-ascii?Q?xdBG5CXgAEZB8oLCUI131jMH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a86910f-6533-481d-6d54-08d96801c8dd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 19:51:52.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSkbLG96HaLCzuZcM01jFDnTSNE3RXZ1+qU6Kcis6AJW6nITUu+X8lo4WvnchKI3L+O7DU+tdSPbsGetlMkbpOZvCcboSU25TkLplwiN/rM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1483
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250117
X-Proofpoint-GUID: WifHSRHChpJQHnyz5kMOLKk1nOQ1wNqz
X-Proofpoint-ORIG-GUID: WifHSRHChpJQHnyz5kMOLKk1nOQ1wNqz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a test to exercise the log attribute error
inject and log replay.  Attributes are added in increaseing
sizes up to 64k, and the error inject is used to replay them
from the log

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
 tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100755 tests/xfs/540
 create mode 100644 tests/xfs/540.out

diff --git a/tests/xfs/540 b/tests/xfs/540
new file mode 100755
index 00000000..3b05b38b
--- /dev/null
+++ b/tests/xfs/540
@@ -0,0 +1,96 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 540
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
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+	echo 0 > /sys/fs/xfs/debug/larp
+}
+
+_test_attr_replay()
+{
+	attr_name=$1
+	attr_value=$2
+	touch $testfile.1
+
+	echo "Inject error"
+	_scratch_inject_error "larp"
+
+	echo "Set attribute"
+	echo "$attr_value" | ${ATTR_PROG} -s "$attr_name" $testfile.1 | \
+			    _filter_scratch
+
+	echo "FS should be shut down, touch will fail"
+	touch $testfile.1
+
+	echo "Remount to replay log"
+	_scratch_inject_logprint >> $seqres.full
+
+	echo "FS should be online, touch should succeed"
+	touch $testfile.1
+
+	echo "Verify attr recovery"
+	_getfattr --absolute-names $testfile.1 | _filter_scratch
+}
+
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "larp"
+_require_xfs_sysfs debug/larp
+
+# turn on log attributes
+echo 1 > /sys/fs/xfs/debug/larp
+
+rm -f $seqres.full
+_scratch_unmount >/dev/null 2>&1
+
+#attributes of increaseing sizes
+attr16="0123456789ABCDEFG"
+attr64="$attr16$attr16$attr16$attr16"
+attr256="$attr64$attr64$attr64$attr64"
+attr1k="$attr256$attr256$attr256$attr256"
+attr4k="$attr1k$attr1k$attr1k$attr1k"
+attr8k="$attr4k$attr4k$attr4k$attr4k"
+attr32k="$attr8k$attr8k$attr8k$attr8k"
+attr64k="$attr32k$attr32k"
+
+echo "*** mkfs"
+_scratch_mkfs_xfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+echo "*** make test file 1"
+
+_test_attr_replay "attr_name1" $attr16
+_test_attr_replay "attr_name2" $attr64
+_test_attr_replay "attr_name3" $attr256
+_test_attr_replay "attr_name4" $attr1k
+_test_attr_replay "attr_name5" $attr4k
+_test_attr_replay "attr_name6" $attr8k
+_test_attr_replay "attr_name7" $attr32k
+_test_attr_replay "attr_name8" $attr64k
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/540.out b/tests/xfs/540.out
new file mode 100644
index 00000000..c1b178a0
--- /dev/null
+++ b/tests/xfs/540.out
@@ -0,0 +1,130 @@
+QA output created by 540
+*** mkfs
+*** mount FS
+*** make test file 1
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name1" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name2" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name3" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name4" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name5" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name6" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name7" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name8" for /mnt/scratch/testfile.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: SCRATCH_MNT/testfile.1
+user.attr_name1
+user.attr_name2
+user.attr_name3
+user.attr_name4
+user.attr_name5
+user.attr_name6
+user.attr_name7
+user.attr_name8
+
+*** done
+*** unmount
-- 
2.25.1

