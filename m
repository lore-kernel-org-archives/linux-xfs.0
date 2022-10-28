Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F92DFA3747
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 21:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJ1V40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1V4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 17:56:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E4C24C106;
        Fri, 28 Oct 2022 14:56:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxTHi024866;
        Fri, 28 Oct 2022 21:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=WVsVXr+zA8x0JB28Su2wDC4vhaDW8HZuL5XhL98JAhM=;
 b=v5kNPZ95SKm1DSnvhJQdLqYPqzVs08AcrkXqS1AISpyb16ZsfdQGIpWQsDP0xVQCf1es
 841J3aUlc813c/aheA0jLfiMxAD2g2o1IR+DMmLNLM+1DJ3Ry1GQAl77Sdm3WeoLenYw
 efdG0kutE70aX6DaxuBDyKQxNbuxi8csDuwOQvAfNWx9zwpzM2MAnhfNbT8PmyOqP9JP
 XfHbGVHNod4drVKcy2+iqCZEZpFg3zDF/hq81u/KUrb1w8k9DwSEmpuQAjanSlZRdqtX
 5CRL2dKzFUrdrozdFN3s8a/lq6s6eZXJYrzyXYmL9UozyTr45LXe3PMO6kkojv92n2Pw Kg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0ap7hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKJGfS012258;
        Fri, 28 Oct 2022 21:56:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagsge9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 21:56:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WH4lV0GxE+59WUXfxmVTXeHVkgyyoeFnEnJG+LyPCImV+uumVFOHMc0dar9h2qOcZPHIQIiFieSwgQwkImnnzUH3lxhDl1J/HgRcaeg+ziv3xDWCo2julFtE2pphu5yTbjM4WzOXodPXy1sR6EbOhQGRC1eFFFx+HFgzCltbatHXiURkRfbctL2aMB7aiCU8AyNc8wfHxo8i1GgfrlD3AF2vv+eX54JyoyVbU2NilEyqWhL84e24Homkm6JI/qrF22sl2Y0La2wttzFi5T2iQnM+0ALEBTZUmlaX9vANgfrOpavOy123IYfKkIKtsLXUaaC4G34FYFQCH+5lCcnbFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVsVXr+zA8x0JB28Su2wDC4vhaDW8HZuL5XhL98JAhM=;
 b=eb16N6uWZhV5wH3V+NRD/3PonEqLwuVeO9bqBRTps/qgMSNV4sifyEof27vx7TqUJ9aN2OwNUn1LFuITNjA5hegXqlULmnOYuXOP+cmzea3d62s34F+DWeLdLVOcpYi5LVIKKt+GCAZTAYxgqy+RBKWDexkRY2+iSaaCWL7q3YSRHmaK/X9HtDnNoNGErTvr8kMcPa+LHGmrO1TOsiJQDRBmjcFWgCqM/UtlSwsXSxlkzgnBYCrRPSzjhCmtW9EfROWrfcgTuiAG0prY57727g2S6wHS8F6ajV87sjY8ZIkkbMwjFMSocTQmWFJipMsiENBW2wyYDJnTm279j/KFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVsVXr+zA8x0JB28Su2wDC4vhaDW8HZuL5XhL98JAhM=;
 b=urp7C3o/asEAMz2rOchr96DqPd1movzs77c56y/GtDomckqnfRlW2hj7wOAAYnbF/g+83GyK/4BH5kL6TBBZZdDeXEv9gOP4uI6vfM4yodcN8hDH4/04NIfXEHcgBtZfc/zz8JUKpAi8FogvfIEFanlmuAS1Gy8WcfydlwSSYio=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB5702.namprd10.prod.outlook.com (2603:10b6:303:18c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Fri, 28 Oct
 2022 21:56:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 21:56:17 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 4/4] xfs: add parent pointer inject test
Date:   Fri, 28 Oct 2022 14:56:05 -0700
Message-Id: <20221028215605.17973-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221028215605.17973-1-catherine.hoang@oracle.com>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c01df3f-f5a5-4efd-3b00-08dab92f3d8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ru1noJTxsLG8Vy/gCF4Fze5kuwFgYvH7UfZWhVM3rQI3P7IFg3vfWohxZu6Trgp5jjYvDSYoqZso+5FYT/ds0zK/crShW6q1yq4GcoqebweOWJEkMyMYb4oMJJZ9rjugsLPqoWPoHJr02XWIMpaHh7HG1nT6iSnlEGbNkHYUkhp1W3HoiSqKocAJX1XKruKI2qmgDglGlK4xompV+GtgGTpd14+il/yckM5cl8Mry4dv/KhzuT9oXK8XxLOsS69S1qz7eaJCpbcA9dTh4N08F9eFX58IEqx0jIsS/GZetfvaUsKsNLxhs5UZ8CVUDIvSyaIyw/ZRiXZ+2ZU8jwk8EGdOm/ZpXHmfvRQaFJAcE36rtg5airhi0nryi6eSsoJgSMbgpj2JPD2GLtcyTfdCakO06l3Biv/L6iOhqGlFOViB7Bgzv9Jdv4d6hGsDm6kirG6z7k9ai1spJRYeXIyGN+BqmQFpZZXt+AMtYxaMf2Kj4mjcJtYHb+JycF6XOLw0VAdfGrx6qrwjBXCP5C/aPQ4FnpQjy8/IHBLza3OSf4Ua8Q7PjUFxQzX6yKqoABpoyNvzOD5pGtZ0CffehPnN5SLePaK5a2hZ4CURRpZqQaKOj7gCVFbacCca89/1jqsSvbiwwF0Gd3i4HshsS9khUskvk7+JtmPzbHIX3ULDBQ1nd47kiZS2WKXU5EpAgxXVIhnZD0iFM+Bex5zkd5AAIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(66946007)(66556008)(66476007)(86362001)(316002)(450100002)(44832011)(8936002)(8676002)(41300700001)(5660300002)(6512007)(478600001)(6666004)(6506007)(1076003)(36756003)(83380400001)(2616005)(38100700002)(186003)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FD72AmBJT7GWbiv0Y7194zMoyMs8hYLxxC+OuBlM/xWFGwXTIjkRb/UMK44C?=
 =?us-ascii?Q?6NLQtwYeOV4zHLVpecHZ2IBaewImc+8+PXGKyNnwT8mLEj0teeecGBx4kz0G?=
 =?us-ascii?Q?FdFNcU9zOg86mP8pYfCNjUQG4m9PUeQ5MMY/12O62iaJr5OLi00TAZbYjFZt?=
 =?us-ascii?Q?1oDWtqh/ha+md0EEMG7wuZ2tCmO26V5TbWjaE3r+RszbaQfQGZxB133P0AE6?=
 =?us-ascii?Q?vtNmDFocDy3E5r0n3ryq70Rf5aI4cKxt2FZE4SGzpEJ/005zmMXuRyAJk9RS?=
 =?us-ascii?Q?LOYLO35HK+eSQyoMPtUc2W9dMJ54JEKMdE2TSn1+IHK40Xl4WSdcT/qnjGIq?=
 =?us-ascii?Q?wk7KPHCgK0RagqgZPM9mFrEf0yb6g8TQSO3424FnL/25wkyb7Tve/DqS7csf?=
 =?us-ascii?Q?4mM6DQMamr8PZJk9+HYOXcAvrBT9W4SRQaPlKsnoDp61MgQ+7yBSoM85ZwSY?=
 =?us-ascii?Q?2IqORL4iVwJhpSOUVmmikCtquxRzQ1i9OPYzNerBx/DbjP6G3TrT24Uk/VZI?=
 =?us-ascii?Q?yicxdauESm6vmDxnKTD03gpuFBDiPmIzf+jUgcJ32NTyAOW2K49+3Y+RlUhv?=
 =?us-ascii?Q?WrkA6wKlqejUW2sNU6Rq4NmiOFL7hFt8DOSyanIg3+ycQ4vzKnzoUe2nxABb?=
 =?us-ascii?Q?cEpgpmzygmIw7AZ4He0unmGoZAPWJk+O7RFOYbfJ+PUs+yzhJSIM9o9Io+AC?=
 =?us-ascii?Q?8y2t/T/v4NqJmQJLqnO7ogvCBgjsgZBgB50nipQ76NtqN+8aU6m9sqg2xoJf?=
 =?us-ascii?Q?kaZej2PNrr+sYSexIy2XW7vbDEWnxw/pg01hg1wvbEKeDOaldI3u3IXbjcBq?=
 =?us-ascii?Q?sNh2YXTkJke/SFzqSRdnVt5XzV7ruAy7CECo2SgPKSmlOFUlhoDoXQJdNvto?=
 =?us-ascii?Q?7byPR+lSijQLWshjfuLNp3C6aPLrFptT6ULAur6ryKLIXwVqKqTifSv+SNG3?=
 =?us-ascii?Q?QojLjEsmYcKXoLElJeJFguoBxwOQyfRnPL1UAqYKn0rwhqQyHdVoOin0txoZ?=
 =?us-ascii?Q?/fTi02xmhOGMLazmMoL72kBzumvCOY6iA/u4NOwpGCJwNJbL0M6yoMjN564l?=
 =?us-ascii?Q?YR5fTjSUx+bf0IVhyM8jc3gLM8w74XrZMptZqzoIb2dHXBOt7Pd8MlrsA3oK?=
 =?us-ascii?Q?jYj7BABdkBchE+sJMIVMRFrSuke7fcMZfg2JcgrbjEc9GekTFYmVbgGovE8Y?=
 =?us-ascii?Q?2OGPSjyURn3Itg78snBu+jl5ZuHAVAnbyJ1O2LjF8hB5xkIAPoXdqI2pxxJp?=
 =?us-ascii?Q?EBzFXc3+FsmE34mJbl68slZBRMOruQ965JcyvZ8i90Gv89kxJnes7QuAebmy?=
 =?us-ascii?Q?6O+kVplnbABdMWtBUNBXIcxsMY+WIOUgwTOexrpHO82Y1+JBy2GNwSu4DoOV?=
 =?us-ascii?Q?tcHpA5jiSkC6NWTKoqsXFOw3iVno+JYNV7KggtMlCtg4nMpbzCWmxiCquASg?=
 =?us-ascii?Q?gbfuEWJ/q68UWZoigEFo9dL+0uEFeNdcxpcI9bdzefsVvwybm65XugOusdSg?=
 =?us-ascii?Q?+jRdLw/emq3kXauTqXTM9DCKb2UZd9sJXQYeF1ruUtEHGJX/6I8kg0I4AKDA?=
 =?us-ascii?Q?Qk044HnoJA3T07Bn7GR2MpUis4EtQK+OWgm+ANB4WC/q86Y5RwzXxXYJzh6U?=
 =?us-ascii?Q?9MIqyQffj8nmTN5lIN/or/fsLDHjzwME30n9M18lAHwrJ1CJBG0jbjSLcZsw?=
 =?us-ascii?Q?5wWkjA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c01df3f-f5a5-4efd-3b00-08dab92f3d8f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 21:56:17.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: irftHHzQx+S9pH2QsoqXOisGEnfEZanFE/8uR4WBMpgzoKx1af7mWod4Z8Vi2eVEKlxpG22J5v1p312NT9miAWts3/q3EYlw7Lb3bM/46hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5702
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280138
X-Proofpoint-GUID: pgRwrDVt1MYdFLvtQ17J7ulfcbBRTcLJ
X-Proofpoint-ORIG-GUID: pgRwrDVt1MYdFLvtQ17J7ulfcbBRTcLJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers after an error injection and log
replay.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/556     | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/556.out | 14 ++++++++
 2 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/556
 create mode 100644 tests/xfs/556.out

diff --git a/tests/xfs/556 b/tests/xfs/556
new file mode 100755
index 00000000..1de776be
--- /dev/null
+++ b/tests/xfs/556
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 556
+#
+# parent pointer inject test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/inject
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
+_require_xfs_io_error_injection "larp"
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
+$
+: back in the root
+testfolder2 d--755 3 1
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
+file4="file4"
+file5="file5"
+
+echo ""
+
+# Create files
+touch $SCRATCH_MNT/$testfolder1/$file4
+_verify_parent "$testfolder1" "$file4" "$testfolder1/$file4"
+
+# Inject error
+_scratch_inject_error "larp"
+
+# Move files
+mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5 2>&1 \
+	| _filter_scratch
+
+# FS should be shut down, touch will fail
+touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
+
+# Remount to replay log
+_scratch_remount_dump_log >> $seqres.full
+
+# FS should be online, touch should succeed
+touch $SCRATCH_MNT/$testfolder2/$file5
+
+# Check files again
+_verify_parent "$testfolder2" "$file5" "$testfolder2/$file5"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/556.out b/tests/xfs/556.out
new file mode 100644
index 00000000..812330ee
--- /dev/null
+++ b/tests/xfs/556.out
@@ -0,0 +1,14 @@
+QA output created by 556
+
+*** testfolder1 OK
+*** testfolder1/file4 OK
+*** testfolder1/file4 OK
+*** Verified parent pointer: name:file4, namelen:5
+*** Parent pointer OK for child testfolder1/file4
+mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output error
+touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
+*** testfolder2 OK
+*** testfolder2/file5 OK
+*** testfolder2/file5 OK
+*** Verified parent pointer: name:file5, namelen:5
+*** Parent pointer OK for child testfolder2/file5
-- 
2.25.1

