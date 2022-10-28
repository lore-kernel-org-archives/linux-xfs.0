Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DAFC38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJ1V4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiJ1V4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 17:56:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A6D23AB59;
        Fri, 28 Oct 2022 14:56:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxU0P005134;
        Fri, 28 Oct 2022 21:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=cTS80Nl1JRLmLLGXZ4xi0ZtS0gL1q3DNMqbCBZy/33k=;
 b=GngtlxlyKP4aSX33efrSI5dwYbnqxstQXRqFJVH0lyt9RGZCuQruYuONj2WABybKeIeU
 2MndcyeqlffZPm7759igl52hoxDZ9B+bIlcSwnEEWgmy2vSSesnchgbrOPNRD33pgsbr
 Ho9m9zj6N7NJRmYLVRn3qDQIO8c1jkeIZjfJr7CmgNgLsqxrjgJ6e5qiRB882oiVVCvg
 4Nmp8rilwviIeZZEtWxG0KZhqNSbBHSaoOSp90A9mBHpDHLF3qosXHRdo2kiRLlzpYw4
 eBsEr0U4SiiFAfqWY+YiOdvqkbCuvf7wjcAFiyYbQiWq3uSS1ov7IJOxQhQzlfh+NPuq lw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfaheemgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SJfTMp012295;
        Fri, 28 Oct 2022 21:56:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagsge9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+milZARBFuCWiSLHLla4QyfTGa3Ygxwa4ulfJ+HxqpwWd20hyYG3buljS2fluptZF4k182fbT2cb4HW4etpfzxPnPY/seiCrxVtgLq16QsUwuT5o4OB7V0e9IaVrfSXsRn6tC2MvVUelMEkPp9TV/56332OOVSP985jgFmCAU+H9clfly/oBQPGHEwucANVMKJraHNhj4uDUmCShRamQSqu79pWuiEKpz4YrTa3i98MlF8jFfiGYQMDHYvHuY69Cr/Eka0h+ocRC9chbvNHJq/mrUmNjmb21CQDMSKDSw4Do80bReYm27C8TJMd9Bwm78H1R2GnuPuJSyesbjy8iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTS80Nl1JRLmLLGXZ4xi0ZtS0gL1q3DNMqbCBZy/33k=;
 b=M8l6XiLD7EsLWErjQLWUYucVj+NtGHZDxUymGXnxFoZuP5mUl7wJlxsWqHazD/C1u7EwutMAG2opATTOlK2fwMbX/UGqmR3clxgdb3iM302A56BxxFM2Gb5aw+xacH2WSLhp5nNjIlnXwep5WupK8pRDjUaHTllFMAkJ9KEH+5Fe5LJumye2G1L5WGWYkJT0ig8ed2cNzZvjOnTc9+ZaVhx9XQVa3OdvwEjcU33BVSGgMu2O6TlfCRMop147nnlxqqdmIWHhDHB+m2qhEwGVlaY7UaAbfhoiy5VuIPO0KUK5vIMBT/Pml1r+rhycFBTNdCXkiankOtL7z8i4OYeeyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTS80Nl1JRLmLLGXZ4xi0ZtS0gL1q3DNMqbCBZy/33k=;
 b=zVmF28pZ/CSsYbr9hEe1goUDPFkZHVWQrXY5f+SOsDx0fog3psr2P7ijv7CD1elhY0eY5ucidM83ZmymhfsdxR1gqbsshAO9JUesbmnBCZ4NlmXPX6GFuD3CExYnTV7r/lyE/WFw19uBkSdE2tEOk1565tGxUd7XaqoTQqR01aI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 21:56:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:56:15 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 3/4] xfs: add multi link parent pointer test
Date:   Fri, 28 Oct 2022 14:56:04 -0700
Message-Id: <20221028215605.17973-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221028215605.17973-1-catherine.hoang@oracle.com>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: 708014a8-59f5-41c6-f4f7-08dab92f3c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTktyy5qOEstmU+vP3J5smb/Xeby5RI2O9DQNQlTEnWEiKyVN2TMT84I1xGYJZlecEzagPNGdOivDqnP5UMvLmbwC8FfXpbiUVCmmTXKJFNXPboG73CL/clTF7lBd0so/qCuXJLl9gKDBi3AVx3CwGp0ty9uNIbjVOo0OG71CPN1A8XPYQt4ALP1zhYZQ1PwHxdGMq1cxxSh6HA41D5HVi8V0gYlF8JAzWsMyyd0XJn9rlDJD8musMWyDbwJLpfEvkKm5C641UIRCdPsv7Ec69FIi6cC9ImSkjM5Nv48nL5r/wQrgW/9UzyuZmQbGEQF9Xv/cHK3hJLnYcAFTkFd2QzHZtCCLTPuIY7wccF3XveD1Ur2EAA7AzorFm/2SSuOJ0CL2cG+Xxiqc5f5Xs2mJseeT2SxOkAW+I59cAtzjXVRFdNHDtika29s0bDXM3m8lBRVXWjAYNNU7hPkb60u6HqeNxteA8mjfuH9j8apKN1al5uEUHg+Hn7k4YEEAbsQ9qhguIy+JDIwWs86KQfgEyNvcg7zu1R9OM6K64CM2OrK38whQZmasCmsPoUIKktO2mZY+/hBiP9TqNEggS2KTpUrHPgRvslmVLgaRZu0pPKOCimRVvMYxkCgkdws69SM16UgF97rNJ97SxGt0QeFfUxPZGfoyQmRRgMA4l0V+74XyC6Wh1i0kQEla3HtqDvehbhst3B+wVeE44utWfyAGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(66476007)(86362001)(316002)(450100002)(44832011)(30864003)(8936002)(8676002)(41300700001)(5660300002)(6512007)(478600001)(6666004)(6506007)(1076003)(36756003)(83380400001)(2616005)(38100700002)(186003)(6486002)(2906002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BmSjS+l5g7WtYJDOXaaw1xA67Bi5LZPem4saS4oD7v8ThAfPHaHycTyCbP3P?=
 =?us-ascii?Q?VQyGfB56jkbKdjq7NKd14Fu4C1xWU+rEaFFZVxFYo2wNZf761BUSJTaoqRH0?=
 =?us-ascii?Q?5LFCBTK+hvFKTECwrIgNrprYkQOWmFi9Qx9Ur/AGNdbbmPsdPJwbMZWuveG4?=
 =?us-ascii?Q?7Kc2uRNRYszG9UzB3/j+/Fy7CuPo74XeHwMRiHZCViaEIUUkLAS3BUN8Qctn?=
 =?us-ascii?Q?g3i2sburzzArVnQ502F52zp3Wm4xj1cdzds104NENPBxRii8IzXJjVc1TyM+?=
 =?us-ascii?Q?sESbJ5TbBzzQE+oDWFqYgGDNwTeSxLvQ2DqJ60Qp3xizOtzkr2dpDWq84vcV?=
 =?us-ascii?Q?oo2l+b8d/HrPE/yOJjw0+uNgcx9ZnnNYGwJd9rkuxuUvAuEW1X0Ml/3rKIR4?=
 =?us-ascii?Q?ISAYeztn/Xb8atAhEy/AYeVLL2id+3Bu0blXA7EZ4AnrblKhAbeE+G1B8+C1?=
 =?us-ascii?Q?+K5vYiPuis+EZiXEXuVJsK0sTMm2ZuF0rvPGRlb2yjUVtLg6rEljC/yI9FTm?=
 =?us-ascii?Q?KhfSNp4cTnZxfp5xk/z3R/H6ZZa3Z6bqrLI7aoNHK2ZwIffQn8MbryIeCGjZ?=
 =?us-ascii?Q?OdXy5OIuWNiGHCxiufsdwQqj1yVlIeSeliSXEHwdbe1lcLAkxPjLYJ5qaumG?=
 =?us-ascii?Q?ogPmf2MN9U9ZuqmzIZWPrxi3kM7v3LaGPvu6BDH1aVaJWKKr9LIHheZGnJEg?=
 =?us-ascii?Q?sojdz7TbJKAzUH6LzprOt0KklhEJ4rZ5MdgZBoGf5/ytHu0tQlWhhFA1LYKs?=
 =?us-ascii?Q?53j7sGh04WVDRvtCjZ0MTG1q3gWBE6BTWfYLXF7/puTfxd6dhtRlRvRAiHTF?=
 =?us-ascii?Q?MhVIEypcnmJcbbjbbIHYD4kMUgOxAFX3w4qJiaS3zlZg7cRDn8gOt9BedbY+?=
 =?us-ascii?Q?mT+8B9jhTBlVCArfb2AQ3IfRze5YgoenZGH20XWF3+o/kYVwUwzetBp08iyp?=
 =?us-ascii?Q?WWwB9sWFhjHBIgtnjCPpEuf+N/1U3PaUlSpFgf+fEAByrLI0mw7Z0tUuDE1Q?=
 =?us-ascii?Q?WDxYIzwWsbFNG7t+pjAm7aZ8CKo71ORfC1wkbi12iNxq4SUfSg4OzQxYPC5D?=
 =?us-ascii?Q?AGgZoQQOrKHIpCk+k9vYzEK+WoQnR9mt2O30C4VFW5vigJLOeIdlxc4ob1iW?=
 =?us-ascii?Q?c3n5PvHzPArZn1yAFH7lkZUdah+G+LWFDmmyhgePvhO2HGgZCKImYkKghrGS?=
 =?us-ascii?Q?guA0cC8ulPE5K2BbrBFlfWAs+wGGCHJ9P+Wln9AhS+UKDq8iHe9kM0y6o8lj?=
 =?us-ascii?Q?6Xh0sSdAxTftt01fU0wQwvXfWMELucFYOQ+HUqfhKf4k3JZQ7HwqGEon/iMH?=
 =?us-ascii?Q?5bTb9CCeQL8qlxUDVdlQYHPxUI9Ee2dVrx4Zg/T44BNVr+NgDYcDdY5yvsUE?=
 =?us-ascii?Q?JNg6VXuFa2oPTVUN29elfX6kB19xSa5zeLPQQMfrcblOC4FutkH6mLgX0NNS?=
 =?us-ascii?Q?kAP7tN86lKvOypkGfqzHGK5Fcb1MCyeoB3BDlqlch4KAN/4NhdijDrX5xqPc?=
 =?us-ascii?Q?DvAsb1rh/n9l4En/6zjFE30Nwnu+Ol91HTcuuL5GhXagryKKJmE4BsnpF1LM?=
 =?us-ascii?Q?Qg9uCgZOkFgXNJaEpPYkJE6PzCCMwdLoBOP5LtKy/S8K3S/szFaUK4tfYn7g?=
 =?us-ascii?Q?5GQwGM9/64IEdlNCvWhJ/hrGXtdw35LXf8JqMP6UyJZP8Uh/NGVKXOsxCpcR?=
 =?us-ascii?Q?+sJsTw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708014a8-59f5-41c6-f4f7-08dab92f3c1a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:56:15.1236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM2rVOtdyGmBu9EnMfRzYoz5VaW3xqdae80DqJtL9yCTWE33eM2iuOfh5O98PXE9F5+NqqPMvmCsJP24Dtk+JuP8sD6pf+/Ju+WiJ9MSPgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280138
X-Proofpoint-GUID: IQ0YHXy_jlbgoGADtVtpEJrTYLrROc4R
X-Proofpoint-ORIG-GUID: IQ0YHXy_jlbgoGADtVtpEJrTYLrROc4R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers while multiple links to a file are
created and removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/555     |   69 ++++
 tests/xfs/555.out | 1002 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1071 insertions(+)
 create mode 100755 tests/xfs/555
 create mode 100644 tests/xfs/555.out

diff --git a/tests/xfs/555 b/tests/xfs/555
new file mode 100755
index 00000000..02de3f15
--- /dev/null
+++ b/tests/xfs/555
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 555
+#
+# multi link parent pointer test
+#
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
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+file1="file1"
+file1_ln="file1_link"
+
+echo ""
+# Multi link parent pointer test
+NLINKS=100
+for (( j=0; j<$NLINKS; j++ )); do
+	ln $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_parent "$testfolder1" "$file1_ln.$j" "$testfolder1/$file1"
+	_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1_ln.$j"
+done
+# Multi unlink parent pointer test
+for (( j=$NLINKS-1; j<=0; j-- )); do
+	ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
+	rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_no_parent "$file1_ln.$j" "$ino" "$testfolder1/$file1"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/555.out b/tests/xfs/555.out
new file mode 100644
index 00000000..eb63ff3a
--- /dev/null
+++ b/tests/xfs/555.out
@@ -0,0 +1,1002 @@
+QA output created by 555
+
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.0 OK
+*** Verified parent pointer: name:file1_link.0, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.0 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.0
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.1 OK
+*** Verified parent pointer: name:file1_link.1, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.1
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.2 OK
+*** Verified parent pointer: name:file1_link.2, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.2 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.2
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.3 OK
+*** Verified parent pointer: name:file1_link.3, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.3 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.3
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.4 OK
+*** Verified parent pointer: name:file1_link.4, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.4 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.4
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.5 OK
+*** Verified parent pointer: name:file1_link.5, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.5 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.5
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.6 OK
+*** Verified parent pointer: name:file1_link.6, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.6 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.6
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.7 OK
+*** Verified parent pointer: name:file1_link.7, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.7 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.7
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.8 OK
+*** Verified parent pointer: name:file1_link.8, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.8 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.8
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.9 OK
+*** Verified parent pointer: name:file1_link.9, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.9 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.9
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.10 OK
+*** Verified parent pointer: name:file1_link.10, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.10 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.10
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.11 OK
+*** Verified parent pointer: name:file1_link.11, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.11 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.11
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.12 OK
+*** Verified parent pointer: name:file1_link.12, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.12 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.12
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.13 OK
+*** Verified parent pointer: name:file1_link.13, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.13 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.13
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.14 OK
+*** Verified parent pointer: name:file1_link.14, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.14 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.14
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.15 OK
+*** Verified parent pointer: name:file1_link.15, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.15 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.15
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.16 OK
+*** Verified parent pointer: name:file1_link.16, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.16 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.16
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.17 OK
+*** Verified parent pointer: name:file1_link.17, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.17 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.17
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.18 OK
+*** Verified parent pointer: name:file1_link.18, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.18 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.18
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.19 OK
+*** Verified parent pointer: name:file1_link.19, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.19 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.19
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.20 OK
+*** Verified parent pointer: name:file1_link.20, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.20 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.20
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.21 OK
+*** Verified parent pointer: name:file1_link.21, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.21 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.21
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.22 OK
+*** Verified parent pointer: name:file1_link.22, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.22 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.22
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.23 OK
+*** Verified parent pointer: name:file1_link.23, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.23 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.23
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.24 OK
+*** Verified parent pointer: name:file1_link.24, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.24 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.24
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.25 OK
+*** Verified parent pointer: name:file1_link.25, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.25 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.25
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.26 OK
+*** Verified parent pointer: name:file1_link.26, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.26 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.26
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.27 OK
+*** Verified parent pointer: name:file1_link.27, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.27 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.27
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.28 OK
+*** Verified parent pointer: name:file1_link.28, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.28 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.28
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.29 OK
+*** Verified parent pointer: name:file1_link.29, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.29 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.29
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.30 OK
+*** Verified parent pointer: name:file1_link.30, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.30 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.30
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.31 OK
+*** Verified parent pointer: name:file1_link.31, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.31 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.31
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.32 OK
+*** Verified parent pointer: name:file1_link.32, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.32 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.32
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.33 OK
+*** Verified parent pointer: name:file1_link.33, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.33 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.33
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.34 OK
+*** Verified parent pointer: name:file1_link.34, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.34 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.34
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.35 OK
+*** Verified parent pointer: name:file1_link.35, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.35 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.35
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.36 OK
+*** Verified parent pointer: name:file1_link.36, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.36 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.36
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.37 OK
+*** Verified parent pointer: name:file1_link.37, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.37 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.37
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.38 OK
+*** Verified parent pointer: name:file1_link.38, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.38 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.38
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.39 OK
+*** Verified parent pointer: name:file1_link.39, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.39 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.39
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.40 OK
+*** Verified parent pointer: name:file1_link.40, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.40 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.40
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.41 OK
+*** Verified parent pointer: name:file1_link.41, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.41 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.41
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.42 OK
+*** Verified parent pointer: name:file1_link.42, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.42 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.42
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.43 OK
+*** Verified parent pointer: name:file1_link.43, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.43 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.43
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.44 OK
+*** Verified parent pointer: name:file1_link.44, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.44 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.44
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.45 OK
+*** Verified parent pointer: name:file1_link.45, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.45 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.45
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.46 OK
+*** Verified parent pointer: name:file1_link.46, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.46 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.46
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.47 OK
+*** Verified parent pointer: name:file1_link.47, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.47 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.47
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.48 OK
+*** Verified parent pointer: name:file1_link.48, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.48 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.48
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.49 OK
+*** Verified parent pointer: name:file1_link.49, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.49 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.49
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.50 OK
+*** Verified parent pointer: name:file1_link.50, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.50 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.50
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.51 OK
+*** Verified parent pointer: name:file1_link.51, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.51 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.51
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.52 OK
+*** Verified parent pointer: name:file1_link.52, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.52 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.52
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.53 OK
+*** Verified parent pointer: name:file1_link.53, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.53 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.53
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.54 OK
+*** Verified parent pointer: name:file1_link.54, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.54 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.54
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.55 OK
+*** Verified parent pointer: name:file1_link.55, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.55 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.55
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.56 OK
+*** Verified parent pointer: name:file1_link.56, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.56 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.56
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.57 OK
+*** Verified parent pointer: name:file1_link.57, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.57 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.57
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.58 OK
+*** Verified parent pointer: name:file1_link.58, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.58 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.58
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.59 OK
+*** Verified parent pointer: name:file1_link.59, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.59 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.59
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.60 OK
+*** Verified parent pointer: name:file1_link.60, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.60 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.60
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.61 OK
+*** Verified parent pointer: name:file1_link.61, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.61 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.61
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.62 OK
+*** Verified parent pointer: name:file1_link.62, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.62 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.62
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.63 OK
+*** Verified parent pointer: name:file1_link.63, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.63 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.63
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.64 OK
+*** Verified parent pointer: name:file1_link.64, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.64 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.64
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.65 OK
+*** Verified parent pointer: name:file1_link.65, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.65 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.65
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.66 OK
+*** Verified parent pointer: name:file1_link.66, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.66 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.66
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.67 OK
+*** Verified parent pointer: name:file1_link.67, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.67 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.67
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.68 OK
+*** Verified parent pointer: name:file1_link.68, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.68 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.68
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.69 OK
+*** Verified parent pointer: name:file1_link.69, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.69 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.69
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.70 OK
+*** Verified parent pointer: name:file1_link.70, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.70 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.70
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.71 OK
+*** Verified parent pointer: name:file1_link.71, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.71 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.71
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.72 OK
+*** Verified parent pointer: name:file1_link.72, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.72 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.72
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.73 OK
+*** Verified parent pointer: name:file1_link.73, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.73 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.73
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.74 OK
+*** Verified parent pointer: name:file1_link.74, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.74 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.74
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.75 OK
+*** Verified parent pointer: name:file1_link.75, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.75 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.75
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.76 OK
+*** Verified parent pointer: name:file1_link.76, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.76 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.76
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.77 OK
+*** Verified parent pointer: name:file1_link.77, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.77 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.77
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.78 OK
+*** Verified parent pointer: name:file1_link.78, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.78 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.78
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.79 OK
+*** Verified parent pointer: name:file1_link.79, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.79 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.79
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.80 OK
+*** Verified parent pointer: name:file1_link.80, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.80 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.80
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.81 OK
+*** Verified parent pointer: name:file1_link.81, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.81 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.81
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.82 OK
+*** Verified parent pointer: name:file1_link.82, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.82 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.82
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.83 OK
+*** Verified parent pointer: name:file1_link.83, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.83 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.83
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.84 OK
+*** Verified parent pointer: name:file1_link.84, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.84 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.84
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.85 OK
+*** Verified parent pointer: name:file1_link.85, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.85 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.85
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.86 OK
+*** Verified parent pointer: name:file1_link.86, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.86 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.86
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.87 OK
+*** Verified parent pointer: name:file1_link.87, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.87 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.87
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.88 OK
+*** Verified parent pointer: name:file1_link.88, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.88 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.88
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.89 OK
+*** Verified parent pointer: name:file1_link.89, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.89 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.89
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.90 OK
+*** Verified parent pointer: name:file1_link.90, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.90 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.90
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.91 OK
+*** Verified parent pointer: name:file1_link.91, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.91 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.91
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.92 OK
+*** Verified parent pointer: name:file1_link.92, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.92 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.92
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.93 OK
+*** Verified parent pointer: name:file1_link.93, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.93 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.93
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.94 OK
+*** Verified parent pointer: name:file1_link.94, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.94 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.94
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.95 OK
+*** Verified parent pointer: name:file1_link.95, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.95 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.95
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.96 OK
+*** Verified parent pointer: name:file1_link.96, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.96 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.96
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.97 OK
+*** Verified parent pointer: name:file1_link.97, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.97 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.97
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.98 OK
+*** Verified parent pointer: name:file1_link.98, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.98 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.98
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.99 OK
+*** Verified parent pointer: name:file1_link.99, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.99 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.99
-- 
2.25.1

