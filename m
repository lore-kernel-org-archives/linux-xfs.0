Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F5FA3745
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 21:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJ1V4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiJ1V4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 17:56:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F9223923F;
        Fri, 28 Oct 2022 14:56:16 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxI31002819;
        Fri, 28 Oct 2022 21:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=vB+5SyAYjWCejXcnV3WKpn1ik1NM7QUD38aofjauFig=;
 b=iL+yt/iVlqILurfpzMfzo/RHRgql/nGiCll3+bnU3gf4e4cYuEYeGf/D2Xn1Cq1mejKe
 qFcmKkbncNDlWhtGEnWoyJC02D9A/v5epbEk0RIFdajZc9SNm4bZv+yw0PVIRsRDpOX2
 PuWEOF6eGcezuTSl1qqTPdoCapXngSWhxDTxRaojtQ79jcprZgIktSP+GLXaPNb2u6AV
 FaCE2oDoS3C/aS/mprPBXVYRabFx7Fvh88Av3bbF8pjoDFSi9xkcJolYvHGsF2ec9rxp
 O3grw/WLoCzfsj68F1YvUIDbLbJm4ZEgPlbFh0LV1kcZGb2JLQSjHhe6cS2+xiDDzs9O 5w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv6d0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SL8ED0009683;
        Fri, 28 Oct 2022 21:56:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggfgbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJC6+gS/OoNNdWTD4H1Cxicij/v3HHAAGHzBDF156CfK1rxjrghSDu6fNK/aOiyRUXPeMAfBirlOvk+RSi8p1C4JwPsO3+aypIMFex0nVLzWeoy6O1zovsnmBhQBcBNERUK5HTxteygLnyVleCe+Km+W+9Ez+uGQu1eYfoKyBPFKwD1bjrArdMJIIh6UDqW/7WCE9ozuWFwywrtOix6fbEbXjrmcCOeYZBxRFwUz7KWktGnAcipSYiUKzg3paFy3Pg+KesEzV8G+ZDsScrCaXVc7ZfpgNj/MC+EmNVAjL/Omnor1n4q5S97zPk+LQ7r57D1LwoV31tClcMsJ7AvExg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB+5SyAYjWCejXcnV3WKpn1ik1NM7QUD38aofjauFig=;
 b=TnaK0RsdTkJSYTf6J4T2QueLzDVcHFZkfoUvm5pgg9jc+Tf3lAsHoLBHX5ZzIiPt0cwTLtL1wY00V06nBaAx+NxS+fJd3CoWh+UJcUPkjz4TkhYFWh5tC/BqBO7Phr0g1DVcuTIHZd7sB2rzQ34Ykd/SRCMLwWMe4pcgGMWRLNUsy7VgwjuhdR7hWgsOJh+paKGcLwMTMur+SRUXOkdV9+y9/dH2Dmgqd3T3EsKUgPTXOhRI3VO7C0VI5b6AnBampAwWA3qOKMUoFmBiY9Xt0ERz/0NUMviUm2nnOSn+A37mOTio/kG36Rhn1yy7AQL1j/QSievubg5A/ETEgSqe6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB+5SyAYjWCejXcnV3WKpn1ik1NM7QUD38aofjauFig=;
 b=Rcj9ahOVGkJTX9056LkiQO1xEAunHkOF1xge5kIYPCpt1ERLnMGFRAXPMIJU0dnwpN5kEic3n6gGY+rlhVS8XdmjTjnzIE+/yF1gLmj1IyXQZyHGK2LqSu/QYT84XJm7fdZUFyZ2xCzpIZ4kFLbY365zaivEH4m8fXAvga8H6r8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 21:56:12 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:56:12 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 2/4] xfs: add parent pointer test
Date:   Fri, 28 Oct 2022 14:56:03 -0700
Message-Id: <20221028215605.17973-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221028215605.17973-1-catherine.hoang@oracle.com>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: afe8ea7d-62b7-4e02-929d-08dab92f3abf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lM6W0tM4/Lgp1+5hh0muCxR27MB/vTUdf9RCCJ1K5w5HKRDieQNfmVwIcawPMpinmC8UirrPGnSS0H5+5KKz4f7/BWJetCBY6TSvh+mepsjQdt7x+Qq7mFxCjm377GaYJLwmfXDtellodplxtHOkSTc3dE1olP26hB2Q8xc2K5Tc5xyqVg7hbHZZLk1NbPxnuscg3xFWn+ok/AqoxthKUhkGoIUeD0HnjBJodj6OIY6YME8cS7823WQA9J7AdzAemMXjmRvnVUPrmmLVKUqtzlsb0wAVaR6iPfQnLq0dVfgTxY/sn2Wqng6AS3s7MIcW/gnGfAyOYYVcR+Ky7xFDQJEjMpoGL5BsW919IXct7QASesKtLHFjROmscQ3oL0US/QQmecVKT9EdjyIzAhTO34FEQWEQDC7phsFRsR4+Fr7CpBDqHTOS+1BFDe7FuBzntsQUyMCXcq8SXrhGXmnAlUyPV0MLUI9EUOBua1tnsGNGnyVHsIETDz3viKrXP43w+O6jMjgGzax6eoiC24zeXnDU/LoXfyjWO3YDWa7zJW12GP7haTkMuEPYBULci+V1rnd4QzmtPM5HTKnGw5C8RM25/ZEAwrmNTpgrHy1L/v1h+eg0POVn4dEO71pkxTFl9XINt65cY0PJDCeqcH3quzcLJYyuwWXUAvJ/JfDtLEmGpSEvP3xaEl5DDL9Fzlq6i1tU911/UvPLsmG240JohA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(66476007)(86362001)(316002)(450100002)(44832011)(8936002)(8676002)(41300700001)(5660300002)(6512007)(478600001)(6666004)(6506007)(1076003)(36756003)(83380400001)(2616005)(38100700002)(186003)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V2HYSpQ1sNfGn0c+oUHG6I0WjAi3elTn/06UnYwAbxcPsg2LZfbE1p6LE4XV?=
 =?us-ascii?Q?RPcsD7NHWCYS92KNrrMWOH+gyTc2TzZ4Gg0Tzf2ENoJxkbCjT/4JlYA9DpQR?=
 =?us-ascii?Q?asmo60VlFiMczuui6RdFJsj93N7UZuOEhbNx2KrSv8DprOOP9pKB0VHf7X+S?=
 =?us-ascii?Q?HzMFuP3mXJEu6TddNzdhzdzcFLEvq6EqXghxTAw8HBM3glvDiaEmSGCkAaLJ?=
 =?us-ascii?Q?G1GPm98mbYtanmRYVqFsA30BVif3a/DBtKHZiuj6jLgtJn4G5MFuncQVvDZc?=
 =?us-ascii?Q?2RloeowpqTHXTTd+4dusIc/3tlJa2t4DWhPbzkffvQ+v5YQrqDkxehZkUhMs?=
 =?us-ascii?Q?Kj3LuERQhbWwYa9hnPsD2aIAnfhHepFc1HKnQXKd2IrMkm+7r722T87CaN+U?=
 =?us-ascii?Q?ApIID7/kAEhmhGvLCBnTQbZsQTLVK2zlw2mUasuGL1PCun94dOZzUA+U+SeT?=
 =?us-ascii?Q?gAuQ8i3CmfIEvf70FKyFWkxAlmv+QFAq5/twe1ukfW9m1PaOU1x9CImXz57f?=
 =?us-ascii?Q?lmljQBiui7vZG+fo/6qDY/2dykex+FeAxhcJ40eWhxIro6mkejdEZ9X3Ex1X?=
 =?us-ascii?Q?SABkVMASbRDh2b/Am3N/eW5FpwrK/gOvRTquX38B/0fwxfwrvrokJDW6TuW1?=
 =?us-ascii?Q?zG7KNZj46F6nsbcmPjcNGq4V22LT/u2Fsb2blvzQxk5RyxgJ9so9FNwuSjTJ?=
 =?us-ascii?Q?Z6Dc2tqJe75lX43QnUFCr4SRj+ANEzU5JKDfPmbbNzPZ3DhdU9qgH469lV61?=
 =?us-ascii?Q?6yHWtc2AJ9L3lHjIG974tm5DicoMavFCgWWrTBiivejdHKLpuYN/rA2rurVI?=
 =?us-ascii?Q?kFpIlqtwXwgN7VRWASE6NKdAZKUV7jTPlC3LCmcmvChAh/Vm+UeezxWjGNVG?=
 =?us-ascii?Q?yykkyixXE7CS/AiKkNCZIR3zAwS+sB28pJX4KS44y+W/w7v0mvEiyPyOttT7?=
 =?us-ascii?Q?/VwS7KHqCzWtmtXE33SUv8hFHEt1G6VAICGcug/a5DVR4MLqsfWVK/tUKFcF?=
 =?us-ascii?Q?/EEHOLvTcy1Xy3UobHtTLlsAxa7nSdyjXhRkKkql1je8Q8yWHc6lYodTIb/O?=
 =?us-ascii?Q?61Rh6ULsp9Rai+5ypbAVv8KS8G+u/mGKBB4rUKMm0r6SgaGpjUDBzzOA6ZOv?=
 =?us-ascii?Q?exG4LSeamJy0rnYxKOWU+YjgYyimLe6P/oBQ/9Uff5VyHZ8Su45i5QEe3uDU?=
 =?us-ascii?Q?KD41OmAAicuu2OfRRZwOYkjgCB8vCYlEOoeTAJOVnigpsRIoYkvbU97e9RmU?=
 =?us-ascii?Q?TRRKwEtGdrnxiWc2moKURl/RRXbFXF4spZ+bD6KD3SG7yN8LJOvBXjZsgJMU?=
 =?us-ascii?Q?JPolkoJSD+owci72vPh2641or8AUV17ZBy3H+37+LsL2F3KMslQlW2+PPxrp?=
 =?us-ascii?Q?AL0UWJMIKLdusRM00es/knZRloFQteGbVoIODg3Xc9GwEW29MAKA5apuP1D+?=
 =?us-ascii?Q?IqX37TBxJthiCTNSO03dFg7I+rronDTaDXDHPStTvxscRh1mOvwzucAwQyhe?=
 =?us-ascii?Q?xLpCENphrb30pwqtUR+fA/03t5VSMTd1Zgft70u8r9Q8xCLv9eeFnsaUz9ir?=
 =?us-ascii?Q?c+7qo9efZU3/f1R4TJ2dg1yEtw8FoFEOZL9Wa6ZLx5dvpXnoX9NOOB7/0naG?=
 =?us-ascii?Q?8OUBJVqaw+dhhwnScpfBVglnYkRjwKsRFj5LyFaPcDUdfKX7qXA1o6/uySE2?=
 =?us-ascii?Q?aeCyPw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe8ea7d-62b7-4e02-929d-08dab92f3abf
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:56:12.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4vTfn/wIWFdxgYEsgJAabLTPIs5eNdY++mj6TTmHQfPPovLmhXrFjMeGYrisJ1KdpHDj+ZpJ3G55aq8cTazdCl/5A4TuZq9uKEFzGFPm5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280138
X-Proofpoint-ORIG-GUID: 7DS1caxGiQD-v0d5TQJPmWJ6We0tDdDO
X-Proofpoint-GUID: 7DS1caxGiQD-v0d5TQJPmWJ6We0tDdDO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify basic parent pointers operations (create, move, link,
unlink, rename, overwrite).

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 doc/group-names.txt |   1 +
 tests/xfs/554       | 101 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out   |  59 ++++++++++++++++++++++++++
 3 files changed, 161 insertions(+)
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/doc/group-names.txt b/doc/group-names.txt
index ef411b5e..8e35c699 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -77,6 +77,7 @@ nfs4_acl		NFSv4 access control lists
 nonsamefs		overlayfs layers on different filesystems
 online_repair		online repair functionality tests
 other			dumping ground, do not add more tests to this group
+parent			Parent pointer tests
 pattern			specific IO pattern tests
 perms			access control and permission checking
 pipe			pipe functionality
diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..44b77f9d
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 554
+#
+# simple parent pointer test
+#
+
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
+_require_xfs_parent
+_require_xfs_io_command "parent"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file1="file1"
+file2="file2"
+file3="file3"
+file1_ln="file1_link"
+
+echo ""
+# Create parent pointer test
+_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
+
+echo ""
+# Move parent pointer test
+mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
+
+echo ""
+# Hard link parent pointer test
+ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
+_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
+_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
+
+echo ""
+# Remove hard link parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
+rm $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
+
+echo ""
+# Rename parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
+mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
+_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
+
+echo ""
+# Over write parent pointer test
+touch $SCRATCH_MNT/$testfolder2/$file3
+_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
+mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..67ea9f2b
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,59 @@
+QA output created by 554
+
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1
+
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1
+
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder1 OK
+*** testfolder2/file1 OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder2/file1
+*** testfolder2 OK
+*** testfolder1/file1_link OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1
+
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder1/file1_link OK
+
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2
+*** testfolder1/file2 OK
+
+*** testfolder2 OK
+*** testfolder2/file3 OK
+*** testfolder2/file3 OK
+*** Verified parent pointer: name:file3, namelen:5
+*** Parent pointer OK for child testfolder2/file3
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2
-- 
2.25.1

