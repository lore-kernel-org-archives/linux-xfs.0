Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B552C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiBARKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:10:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50830 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239820AbiBARKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:10:04 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211H2X2L011644;
        Tue, 1 Feb 2022 17:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=9XvWbKyXuEnC3qZYUOPeZEB3neRV4rvtXOwAhtOUteU=;
 b=CtT2GvyIPp50k67wmq96tnE/91kYvM0EMuaUqx6cOZR8H5Y+wo7WJmi4n2gMA6YPDPIf
 zslf+b+YILxvIAxE8JAX9rJkdXzX1FWVEZaBz5sLZoFO+sQnnQ+/1Cmr0Ef5Y2P7VhlM
 N6UZzd0FOP5s+x0OlKwUMpPfJdNXqh1YdjXa10SlM0Obq46BUVUnyQBXkCAApkL4eWF5
 raomvZ16mdt5QQP3vYoSxENEcEGDo3aYqUJjsGwFxqmAlOz5Plo+M6TGrTIqvbNoTvwq
 xUDuDqzKYm25qpPWCt9n+j/Yp3QBcR/Sr/9S4eBx8iYoK10PYpoLnF5pEufjRiFmRpG5 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxnk2k01r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:10:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211GpZ87097721;
        Tue, 1 Feb 2022 17:10:01 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by userp3020.oracle.com with ESMTP id 3dvy1qc3eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 17:10:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VA1wbwkz4QiSiVxO2EqQkWRa2ZPyVsCvHmV9DMvzPSvTbDW0prJL4QVv14XpuHU1GZLL+wxgo7JekEbqNRjeUsseFbn38uRb8OJduar1bcmE+JddQ0tu9nGMi44MJCbVbzfbHSGcxyqvsomaPMoFHKC+/EF+HAh1yFTIMC3oPSQ2NkI3WJZtUYcgnCio1OMoFrgdlRVSTQ2Oi1LXuMM86ThIgT/hXHVgFBf12Q5ALzOXRNkBd+iAejusgyHE/J6I5+WEl5QkKpGdQIJiZkDwzMik+vcAzkFM42iOmXdZFfcKNPvU5PUTlN1hzHbQQBAqcsp7xYKLSCibDZpeqDJr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XvWbKyXuEnC3qZYUOPeZEB3neRV4rvtXOwAhtOUteU=;
 b=e3C7xwQw1Rj9LcSGWnId97/PJ+XOyZGSFFHpEGxOb3CUjXkxj1I9qatiCdSeZcvNt+aRvxkpO9UFdZm9nmWoBEYG6saA25xBGMVM34glw2U0P8cq+l9M2PgG39bv74uE2dBwwxJLXvvjcFTvncf9DHAac9jE8KwVcbOZcn5qMOdhjEhSaeGdzJ0Wk6WZ6skykjjHIHu7lgXC38ZfWkSv5UL2Nvm5PUqeDX2vM7kprvgbeaXrj8uZCyWBmX/TzeaQ8aXt+nXsqevo/QZsTYm8Z+2nWluWSCf2ieEZZjyHwOovsrHWZo8rPEcD4YpgB+ec9guzhrGzOLiyoF5+WFCqJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XvWbKyXuEnC3qZYUOPeZEB3neRV4rvtXOwAhtOUteU=;
 b=apumjsPjRzHyGtgFiXd56g59Psk4VEkmbd51QbMKoNLL6V0DPsnTQd7uDrIjKmFx+03xIzdxwAAiqRvuX7TGvS1wG8hFMF4ve1T6KiG8/KUWhOKsL+MmkXyP7Aabpg5Clje3h6zAQENUZUsJDJbfhuvobDWlQ0KgAmib/fiH39U=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 SN6PR10MB2607.namprd10.prod.outlook.com (2603:10b6:805:4e::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.18; Tue, 1 Feb 2022 17:09:59 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:09:59 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v6 1/1] xfstests: Add Log Attribute Replay test
Date:   Tue,  1 Feb 2022 17:09:52 +0000
Message-Id: <20220201170952.22443-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201170952.22443-1-catherine.hoang@oracle.com>
References: <20220201170952.22443-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:208:23e::19) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc95b1a8-aba0-4a98-1cea-08d9e5a5ad48
X-MS-TrafficTypeDiagnostic: SN6PR10MB2607:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB260762377CEF555E4368834E89269@SN6PR10MB2607.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iLMo4uDv668/FXrpMhnFAdkfEgHt2SmZIl+wmC5fU8hR//X1Y1a/UwBr/2nMd1Ct2z+ZVi1u3lBKZMJWvar2wiBxs+fa8NBJdi17ns3wZO1pspR/WZFlMz8MK9VcHlOAyEd/erHl3ofz/D9a73PQlUfbHY6K2X2M39l4BKhqK626MzShcI74UXaZI7buX0EgykvCd7/LX223UyEv4N1ysGrkljU9/P7VpcfKLHTQgtbackipQsOI1GEYwgiBbMTuuH3xjx9YBCiztLiTGXQ9YXZMqts/gYVWt6+sbZ6UGac/jyvookktW8h9wpD0JwQcVoLYzO5uQ0wnvU4uYoZDKhivD9Xo3lZMM/yKJ8urMs5JqOzv7xMB1YZlaDMLg9QvWN7i/Y+bVNN1rVBXNDjmA1pBxw32fmFUfhkEhM/w3f9zvPRSPFbTA16OLxmRztmm9csxyBotMfRdFXy4iKR0rdaTFfzDJ7IcW3HYstiwA6WKYrSZwu52qS8kjVgDmL3EQ4oT7LJ7rerGlXSxKjisenb8J6E33U+QsY7OHQwBTnz/MM+A5TP5CdIMETc/nP1CNKmjNeI6yr/MNo8Gi+g34VH6G0Y5zUwuILz1ZUI7WkSN+O1rh+SMxkHy8rsp6y9nafdsDlIc7TkMgCD1f169cHD98gfcAVe7GEWs2ElMqoEp9lAyLgloxeJoDqPbgSMlPdE/lHa5e9DS9nRS4b/gsJJlvM4Ndp5VIPT+CP9VSNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(316002)(86362001)(52116002)(36756003)(38100700002)(5660300002)(508600001)(6666004)(66946007)(38350700002)(66556008)(8936002)(6486002)(66476007)(8676002)(450100002)(6512007)(2616005)(26005)(44832011)(186003)(30864003)(2906002)(1076003)(83380400001)(357404004)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95RRs5pQZXlskFObg+k5T0Ley5ibIoCyGWq6kTuwf44tuDq1TCDAjAbdWzCo?=
 =?us-ascii?Q?ZMkfqv+YfZPJXPZ0wZBuFAkoNl51AluHnOoMAl9Wsh/u1VUZrI937lfZ2Nre?=
 =?us-ascii?Q?rGvQoAJoNFECfKK+K1IMkSQAy+knIqL/Ak+vkV2sNQ6mPI5EkXJQl51bIEqG?=
 =?us-ascii?Q?wsTuAB/tWBC8Ds+IFOe0fpUIMPLc0+3WFXNG91sRlYRz+BF/scmyN12DTnt+?=
 =?us-ascii?Q?0UwMQy/ZTwxTnEdCjQMVEaA9YH2IDTxix1Nje2g0Sen6fPpCRmASCFgSdoyh?=
 =?us-ascii?Q?kSyxpCsX3yjHfCDGrVv2mWYXDwJ+1/8ej11wiHboMs8L0YkL0U8XFmF561xp?=
 =?us-ascii?Q?VkXUEK8ds/a4qE/nHmt7A7nfmA1yNRIN3lxevTfzFqwykoE05oCJb0SaX3By?=
 =?us-ascii?Q?9NV0Wr0wZpfLLx4lHHthHgqE2+GBt+k+rPQauhtHmtBDKdyUx1Dk+hdByJbh?=
 =?us-ascii?Q?JphGCHxxS80Fvu/rMfkXDB/Nuei8l2oFn2uyut/XcVug5G0mTWll9e+G/tO1?=
 =?us-ascii?Q?9lHwBBUV3+iGXMKtE0pgZTFmPJzE1RGt9iPzsl93oRU33hgF4/1roefU53KO?=
 =?us-ascii?Q?sqf4AQzv3ylwEZh3dxYoAdPJk5lNYOZS4oJsYNeyoRuw+Pg3OD62urvuI9Mq?=
 =?us-ascii?Q?8Ab9nmmz/mxC0ys6XD+StSuTsSJMMrCS+lohLJ1P2adjWO5rvbAvf9I8VWrs?=
 =?us-ascii?Q?Kz0H2EkiXXbz5ww2k4n6syeQcWqMNOXHybPxvyoqlwQ6hYUF1f8JuayTuUUm?=
 =?us-ascii?Q?dQUncX2fmBCMlOavVrQI3nQDytPretEZ5ppy9EblCcshqN3jTHeakqxC5KP4?=
 =?us-ascii?Q?pI+MKDHuvGD0RivEKFbHl3WeesKfuVlRlzi0TAtT2yrD0NbUEv8KsDic0hBt?=
 =?us-ascii?Q?/mteu6yy1Q6zOeDA2koZY4vYCRIJdu5hMeI+bY40bQ4QC7tl4styaY84e4lT?=
 =?us-ascii?Q?JbGykEcwYCsGbdvJVYIr7tV1hgzKCbzm83t8TjUoE7/DIs2rQaNb5u0lBwcw?=
 =?us-ascii?Q?OJ1ERFKHRVxVZyiuidmRo8fHgstT7RoOG2kkLA073LOJZ+2VGwQ0k3xCwpP7?=
 =?us-ascii?Q?MC9pd+s220t7fb06Dwgh5FwLeiHd/ajvdnAx9c1g4H1tnwQ+KEUx/9C5IgjV?=
 =?us-ascii?Q?A2kQv5PFytMmHWQRf+sChGGmf4wiZhzbqQoFDeJQPTfk/AWwd0H6nqmVaGjc?=
 =?us-ascii?Q?MsA285mVzBS7L6p/VV5byiclpKLAfu2Yy1ohi9G6wfxRZbEaqYRbmYe3lSs7?=
 =?us-ascii?Q?V3osPuECSZ2i2q8BRNimzKyZ9yj2ghBzpv6g0SAgZmKDbqX+b2mb0vaFdsk7?=
 =?us-ascii?Q?eQrolF5T6OT5I4TfJp5bLaK7cUMU/i/dhbd3178hwgp9faONtgA0mVIBcF0u?=
 =?us-ascii?Q?Wqph3NrjwJCVw60ns+EsZB3srY5fs05h+CvAl7ldxhscM5vKmwVxWPEzTl7M?=
 =?us-ascii?Q?Qdn3v5Lc/TqvNlaSxuO7EczQOWjf6ENk6vmUnRClwaFiViVUNhnqKso6cuCa?=
 =?us-ascii?Q?NQYgqhFH6B5QGSTgzoTqbSrGSokFW1165FM4cbFsam+LwlRdwuv/NxM5cdES?=
 =?us-ascii?Q?TLblFliq0NhUIj/HrZ18a4kqes/MZcI3qjxSML2lovCgCPWHM8N5L2oqchYF?=
 =?us-ascii?Q?WVucA0il62nw5ce/vD8bu7jYrxJn2k3D1gAJIZAX57xclgO3+SdvKd8b+Icm?=
 =?us-ascii?Q?ben0gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc95b1a8-aba0-4a98-1cea-08d9e5a5ad48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:09:59.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uj0Np/tru6/CX9BPKacHwvryHqquxg3fBt9+oMDxUIM0ccSip7Ogo0rvE8AgVX8KMDVeACxZWQlg3lPEMLjHJaHvOHywYJl8dREqqc4b394=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2607
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010095
X-Proofpoint-GUID: 5e7q69aSpZwlHK7vaeL3l0-AgTJaMm4C
X-Proofpoint-ORIG-GUID: 5e7q69aSpZwlHK7vaeL3l0-AgTJaMm4C
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
index 00000000..ae955660
--- /dev/null
+++ b/tests/xfs/543
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
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
+_require_xfs_io_error_injection "da_leaf_split"
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
+test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
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

