Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8406C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB9661246
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhKKAJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:09:47 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51384 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234172AbhKKAJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:09:46 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AAMUNji032542;
        Thu, 11 Nov 2021 00:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=11EVKOs2SRrIOgD//89cEhc3aO3rzUfYTO0lwBxH40s=;
 b=MAsrj9lh10wykNgXoUH5ILRh/7ZpsPpyIyPGj0rkI7qh+6VizQMtrmTYbi/ouYzdYuu9
 vOc1ur9/tUpyUw2yNO+QtfGOe3DCfRW4i1EnKGpx3aR/S0+KI9GIHNgc+vOo9R7FciO/
 EYM/4grCAEMWLFpvsYqb6tOzh82wAf741Q2mr6RV2vXyT5LR9qn7fnh9Q3zsfcw1ZpUP
 vmbajmhNHokxoW+EbpWuxTj4UWKkXQvODd3FjvHrd4C9JBE00fBjq2Zc2vujWZ3VmEVM
 LwPDaVN+2+4GsWJkmfpNtMHt6kt1ap2NHl+NmrElZn4ETATjSJ0rAZ/4JKJAy8wX3g2O gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c82vgfbx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 00:06:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB06LoC162307;
        Thu, 11 Nov 2021 00:06:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3c5hh62udw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 00:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/Cb+A9Owec/53JTOoTtAdhLrG4yIilxarKkH1byk7+ponKpH+xPekNPbI7Ph+MhJHneYvq8eW9SXJlbQxnkBJltqmtAADvrIZ24EZJIggbPq68aJeBdIGF+flEvP+HlkfOPphoApRdozsYn5F3PAhjVZkOgNIjN1xya8E5pWMwoMpTcsXXy5pPhtahIOansnKts0An+WlRGHaW0RdH2Lp4OvpPwqahxxTD0mhpoAu85dWhDIw+7dxkC96fGRtZVILnjr67raxdtsbWgbYdKcGbkBFSk669OXR6omM5c3FOZm2j5x6/P+xu+UYsixvt9Bk2y1wngeG6U0WwYIBRWvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11EVKOs2SRrIOgD//89cEhc3aO3rzUfYTO0lwBxH40s=;
 b=kfUj4MH1F4DVuIlQWQv640llNevr0oQGZEcEzqdU6EYUdDbeBs75uHiVzwc8tNIF+nyTd2CICZP0lQQUPIlMITPi2HeiCpPCcbfakL7mLFcYjkh0+sEs6J871DeFp+YrgzE5cniQ6ruzukhDx14MbuxrE7gHmRKUQgA4NdtC1iiWSf8LJ6jjylOlYhBT4KaOi/hFGttsIkf+XEWM3meWNCuYPax1nvvDWNYc5umPOU6NXGs3uU4IUoeX91N/18e0nV9bpfnZHpyDI+Wfe8Ss+79MkK/0zELKzCGAkvxE6LSUrpUpheVMTjsRq7Ye2k9BtB6O8xREoOr2gTPQ7TAuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11EVKOs2SRrIOgD//89cEhc3aO3rzUfYTO0lwBxH40s=;
 b=DYEsFK+JEjdasCTMh4k4J3opcw3624DJ70kAEhyi7s2OJiSTVrbVWpSag490TMrnVTA0w5KJats5iAjb0VpOy/nP3YN9l3QxY63c9F71o+Jwlal4OVTjzfxEifXbGuSrT6QCvKw8eERyT04lBhVFku2C59GI6kjmzW4rU4ZGnvU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2252.namprd10.prod.outlook.com (2603:10b6:4:31::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 11 Nov 2021 00:06:53 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:06:53 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 1/1] xfstests: Add Log Attribute Replay test
Date:   Thu, 11 Nov 2021 00:06:44 +0000
Message-Id: <20211111000644.74562-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211111000644.74562-1-catherine.hoang@oracle.com>
References: <20211111000644.74562-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::40) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR07CA0030.namprd07.prod.outlook.com (2603:10b6:208:1a0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 11 Nov 2021 00:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f09c51fd-734c-4007-d6a0-08d9a4a72948
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2252:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2252DE3A4BBCEB3A107908CB89949@DM5PR1001MB2252.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCJgP82wMXgPumN27BjMXlshxsxF0I7ZCDQVIhjQJkXtMumeCaFD4UPrNR6/rWb6TBijGS2HvK/pe4V76QFo7vi/eYMdrVLCGc7rR8/2ks0e3wX/3k+rBOx2f9NIBgfuih4kFVvzIm1UqIl4b+iI9A6JR3wJC/+v4HxDMtUFavoywKwXigr/obIcxNUGZwljkQicIZdwEbZY/J4CYsJH13+on3+nO4FC9yyb/TbLQAAnCUSsBzCi4rxP/tEBWwPqp9kGNmgRDdgh2hFZ5xk0Yo+wvF3Bked0Kjx/jRFMIbW8Yr+6jv1Z/6cSCNIArtYAB/IREYXEEm31NfiFPRVatwI2chdzBFUI9pDd6fFdWyOp8TGqvFPqs70LcdpK1MWE7RAZP2llmrNJ7FKzB6NZXLGnSr9m8DZrX6be8M8eCATTaM17Y0OBI70TWolYHaRIyue+haMh125CrV0ZTodEKaESTIgt6ZYlrDSbnxct117osgYGpWf/Ie/pcd6SJP/nT0Aq1KI9Th/yatR9ddFLZXF8QkehCyxDFCVRrbwaeyshgkUHJqrpG1oyAy7nWCdt8D5UXkHOlLgQoNUvS+AlS5UxXsqxjFyTnhRFJihSyW25bUD8uWew1kbsgpN8meGyAYyZZu0bpz5VcxQMyd1oXGAbEDtRYL3KdGbBaXTbac1otX8mBFDCc+J4ZLsUKbsQznTObJBsmTvj7eOp0ep6PvjLtBaqRQFE5viqNHpGjNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(6486002)(38100700002)(38350700002)(450100002)(508600001)(186003)(2616005)(6666004)(956004)(83380400001)(26005)(36756003)(2906002)(30864003)(52116002)(66946007)(8936002)(86362001)(44832011)(1076003)(6512007)(5660300002)(8676002)(316002)(6506007)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QeQVFSCjyMhTT23aCFo7So8XgHtcTjkt2PaOekdqK/Uubwg2cbvxfEm2nS3A?=
 =?us-ascii?Q?U4fU+LFcdh/tUu0wWBElqdE0Nv28BsNOwpRgCnVuxAYTBg84oTojRWxQ74Vt?=
 =?us-ascii?Q?lCidIWO6zC27tBiVtIYskByW+JMVa/gAz4cZ3GyRyzcArtNFPuyL0QdV/C1x?=
 =?us-ascii?Q?CiAoZ4t7RUyboVMLAVQ65jG8RftxtpzCBgfestEUL+/i1Ik2XGROpTMxEPB0?=
 =?us-ascii?Q?JdgeCFT+jA7wvYbdf6J6q/+qla9DoxUYUFlkjmoEQOHH29Fp6pjtu/ioHE09?=
 =?us-ascii?Q?P3EEImnww41notKOroWY+JNY7i+ZqfCMH1Ja666o71mAcQzLmNysV06YjK4l?=
 =?us-ascii?Q?YLg3L7UIqnjIy8Hr/FbBEyXvWPfFw7TO8qY3vYAlYU9hmJos47BIbcQj39uj?=
 =?us-ascii?Q?UvAaoOF3KxrTmKXZH4GI/wIxKDFhObRTvysfmaBsut3vhLDgm7GthblYdviG?=
 =?us-ascii?Q?egrMkNzwHIdUnOM4GiYI+S7qSx3juyQVDxVy4BA3hs3kjuSP8Jou+58k7wXM?=
 =?us-ascii?Q?IBarlALzk4qBUqdW9PhtVTuCYGuHIWCeT8ePH1Oi775nINby/Sqox4VObTak?=
 =?us-ascii?Q?ndeJ11W+NdWDrSKjXSpSfdp2V24mB6u+nLiBxsiadTSoTZCy0efLUSv37X/b?=
 =?us-ascii?Q?FolHOu9jo4v9gmnHTY4gtPZJsw6Q47DGRS7UFI20m0XWDVPYmz9V416pADsn?=
 =?us-ascii?Q?ijcRXtnMICSk3bZj6dd3I+nHJT8re1i5Wj2ho8KCaQG5w9x1feopbVHKcuLU?=
 =?us-ascii?Q?XTlhqMlsAk3IVZRXqHZyoqdSo3dtL4MNg9mJqoc7OcH7MG16ip1A+wsblK/v?=
 =?us-ascii?Q?GgFfRa5vvxG2mTNnSFHae7Iux2EqJJ+uK1VYgukTlKtvSjCeCLrsZK3svusY?=
 =?us-ascii?Q?V4/sFiCbVqTYCAkS5rTRbEmxUB0ywPCYCgxYmGZs21hIh31v60M+zGUfD/4w?=
 =?us-ascii?Q?w7xR7DFe23qut20KXpZu725NLAdw05UE4gXhbSMhsEKb9NzHUjbHPohdFDiG?=
 =?us-ascii?Q?mbVnoLhNHKfSTC+PVQbBPhWCkbcmI0kZ5NVaJ0VAwDQs3n/1NULL/WZ111sN?=
 =?us-ascii?Q?zyR+DAf7ePa3hcBpxY+0MZDchXmtMYAfoEYsZRmQGClzykQWsY3ypFyS462C?=
 =?us-ascii?Q?ADpSjXVh732Q1IpEnon9aZKHT67TZNTR+f1VON7NZa44ic4RUSpkVef7L0Ww?=
 =?us-ascii?Q?13RhDq2Tklg591Vs3refu02pwDjL3l5fybxdekDDNX77m4jGY+M5NjfbC9LI?=
 =?us-ascii?Q?7S1rUbm7C+xrGJ/UKLXPD+7HLgG1NMfIqbtLrbw5i32QBRoCdfjRbuiZ6kbs?=
 =?us-ascii?Q?XDJu8NGtBQC3/GaUIDZKi0uItjb+T8uMMJivYaPlRBnCD6e93dVF8+XfzaNL?=
 =?us-ascii?Q?TYc8mJCJlChO49zA27/WMhOChNqRooidNNxd0pBrTbEqtfmJw3cIT/8Vpc5p?=
 =?us-ascii?Q?QPcGXz7UvPWFBYiZd5B/PFCVnI3SQJ4nzCVITYgyFAhk7D1ap08D16j4mu6l?=
 =?us-ascii?Q?eKUVcIoDGNlD0QruuIg+H8Yq0uSb4HUeHUmTmLJ6WIYhE27ipczmw5Zx/RjD?=
 =?us-ascii?Q?i6xFpgbijd2Ev/x+JwuSgLi7DIFVMkfPcsOrRoYVJEnv7u8BgqXWHAm4o0pq?=
 =?us-ascii?Q?uoCXI6nc67V2GqYpICxJVI7davuI89qQGUSlHObkmIMOUXrnQWvBLrrJrMMJ?=
 =?us-ascii?Q?1R+bTQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09c51fd-734c-4007-d6a0-08d9a4a72948
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:06:51.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5NWqXnQzCIM2/QAs6+ECohie/OeiVnP8YuMNYleJtD7qkLHeUhnCz9zZgP/QzLPC1Gv0eCyh9SrTlLINxN9tF+L+yfwEytXOsMKjdgNjB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2252
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100116
X-Proofpoint-ORIG-GUID: 1E1tDKd-he7Rq21Daamh30SN2dWmgn0O
X-Proofpoint-GUID: 1E1tDKd-he7Rq21Daamh30SN2dWmgn0O
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
 tests/xfs/542     | 175 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/542.out | 150 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100755 tests/xfs/542
 create mode 100755 tests/xfs/542.out

diff --git a/tests/xfs/542 b/tests/xfs/542
new file mode 100755
index 00000000..28342166
--- /dev/null
+++ b/tests/xfs/542
@@ -0,0 +1,175 @@
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
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+	echo 0 > /sys/fs/xfs/debug/larp
+}
+
+_test_attr_replay()
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
+	$ATTR_PROG -g $attr_name $testfile | md5sum
+
+	echo ""
+}
+
+_create_test_file()
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
+_require_xfs_io_error_injection "leaf_split"
+_require_xfs_io_error_injection "leaf_to_node"
+_require_xfs_sysfs debug/larp
+
+# turn on log attributes
+echo 1 > /sys/fs/xfs/debug/larp
+
+_scratch_unmount >/dev/null 2>&1
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
+_scratch_mkfs_xfs >/dev/null
+
+echo "*** mount FS"
+_scratch_mount
+
+# empty, inline
+_create_test_file empty_file1 0
+_test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
+_test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
+
+# empty, internal
+_create_test_file empty_file2 0
+_test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
+_test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
+
+# empty, remote
+_create_test_file empty_file3 0
+_test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
+_test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
+
+# inline, inline
+_create_test_file inline_file1 1 $attr16
+_test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
+_test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
+
+# inline, internal
+_create_test_file inline_file2 1 $attr16
+_test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
+_test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
+
+# inline, remote
+_create_test_file inline_file3 1 $attr16
+_test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
+_test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
+
+# extent, internal
+_create_test_file extent_file1 1 $attr1k
+_test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
+_test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
+
+# extent, inject error on split
+_create_test_file extent_file2 3 $attr1k
+_test_attr_replay extent_file2 "attr_name4" $attr1k "s" "leaf_split"
+
+# extent, inject error on fork transition
+_create_test_file extent_file3 3 $attr1k
+_test_attr_replay extent_file3 "attr_name4" $attr1k "s" "leaf_to_node"
+
+# extent, remote
+_create_test_file extent_file4 1 $attr1k
+_test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
+_test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
+
+# remote, internal
+_create_test_file remote_file1 1 $attr64k
+_test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
+_test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
+
+# remote, remote
+_create_test_file remote_file2 1 $attr64k
+_test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
+_test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
+
+# replace shortform
+_create_test_file sf_file 2 $attr64
+_test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
+
+# replace leaf
+_create_test_file leaf_file 2 $attr1k
+_test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
+
+# replace node
+_create_test_file node_file 1 $attr64k
+$ATTR_PROG -s "attr_name2" -V $attr1k $SCRATCH_MNT/node_file \
+		>> $seqres.full
+_test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/542.out b/tests/xfs/542.out
new file mode 100755
index 00000000..5f1ebc67
--- /dev/null
+++ b/tests/xfs/542.out
@@ -0,0 +1,150 @@
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
+Could not get "attr_name" for /mnt/scratch/empty_file1
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
+Could not get "attr_name" for /mnt/scratch/empty_file2
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
+Could not get "attr_name" for /mnt/scratch/empty_file3
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
+Could not get "attr_name2" for /mnt/scratch/inline_file1
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
+Could not get "attr_name2" for /mnt/scratch/inline_file2
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
+Could not get "attr_name2" for /mnt/scratch/inline_file3
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
+Could not get "attr_name2" for /mnt/scratch/extent_file1
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
+Could not get "attr_name2" for /mnt/scratch/extent_file4
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
+Could not get "attr_name2" for /mnt/scratch/remote_file1
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
+Could not get "attr_name2" for /mnt/scratch/remote_file2
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
+*** unmount
-- 
2.25.1

