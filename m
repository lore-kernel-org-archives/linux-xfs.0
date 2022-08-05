Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DF0C25B06
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 00:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiHEA4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 20:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiHEA4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 20:56:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23BE1C918;
        Thu,  4 Aug 2022 17:56:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2750Efcj027800;
        Fri, 5 Aug 2022 00:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=OLK+hUcqr4q14HJfgmRjWVVUSi32uFVFbeExNdfu3u4=;
 b=AzDMPF9cKrkK1PYyr9S9z9xVRlpu9vNxqF7DoNuL16Pl8CeYJHz6t2JyJ9WNYmXGCvi8
 xceLOpUkKBJ4vKe1oUtdX82uPd9k5123jUBZFLQdeNAPUhlgpPT48VopDEnLff4XLXnR
 knyrXMSi5hImTTq43gTZR4+siCmx2AE+foiylEjUkmfpc+w7d3BfWLzdA0jjtU5gsB6k
 qcJTJgtPKLFNg8iOXqrai0PFcGg88zXNsGd6KacnS/+eldm9qc1gyRF65Y/fSHyDGwvF
 w4VUDY+2sHEBrG/KgbgpJCp1kBWSLUfcbK5b5cu0cRF9NIelFdhIUi8Yfnnmty8ZDY0f 8Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2xjvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 00:56:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2750khnr014234;
        Fri, 5 Aug 2022 00:56:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34wmks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 00:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IA8le3Erei7M+hO0NzxfQqzup8O7q+M5xzc2HrCHuDasryxsZ+VaCMZJbm8jvraUQ1Fkf2/Cio23U+9Z6ozagYSMZubxjabXrlZtxzyYeH/3xLLQ0dst6e1TZtSfwancSe3lMgmaP/EtU9nWywgcpnwpbGc5nFIy2q3u1Wv9HDskMiEBDLQY4VxXQtD/oUZXjJPSwKnFFe7zGu7VVMdjchcCVail40bz4nSf0LZUBqqNTdW7kwe6aTn8QqC9FivksC8w2Lvv4DBpjBBDXYv3sgEgBp5UsV27Z9QM3pb0i9wg4O/dWzAwklVWAZrwREPHVFwzhMQFPptJCSECIR4vLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLK+hUcqr4q14HJfgmRjWVVUSi32uFVFbeExNdfu3u4=;
 b=WqvyaGwFkicRM93BUKQWTohWD1jyG0Phe7iMsVUOSd2ZcHBFI57smZ9u7ViQ24CXC9v47Hf/tYG/jiDTZZvaT7RK53wVs3Yz4CCxYf81gix6ej63NvD1iuD/VqzbbXE6RvzK9ANMLQbu6QlSRklp5hf9+XG+CPHCjhuVCze2RhvoEa465A5bcP+8CfyqfjMfFEm6rI0wJZVDA0uWYxr9x7NkiIMsgw6pc6rFC6JgrA5ZgNqSX/QreXOC+kZSi/yR4HqGsOUVvFWSpBuiCnTTutkKo8RLju+jnigLWm/a1X8gplScn9NAJnBWWQhMENBZ8llOs/7Ymt4AUvCriy86UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLK+hUcqr4q14HJfgmRjWVVUSi32uFVFbeExNdfu3u4=;
 b=GpXxcPE9zUdeUu0iX+8HCE/h644XyWGTgPzAqKsSyYT3Ayw+6iDlZpc4GAqDRdlSCBhYTA7OQ045t12CUcq1xG7LICDzTYkDjhAqrWDC4P+InTPWrjomcacpyHhOPa8qxUiYvOuDa8IH4SeQHdQRtrFUfASXSETm3TS136FkFAc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY4PR10MB1624.namprd10.prod.outlook.com (2603:10b6:910:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 5 Aug
 2022 00:55:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b8df:5373:e1fe:3463]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b8df:5373:e1fe:3463%7]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 00:55:59 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 1/1] xfs/018: fix LARP testing for small block sizes
Date:   Thu,  4 Aug 2022 17:55:52 -0700
Message-Id: <20220805005552.34449-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::44) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7fe26b8-1d68-48a3-f028-08da767d42fc
X-MS-TrafficTypeDiagnostic: CY4PR10MB1624:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PgiDTowS5OcO6a6aDbJQWasEy1HzeOsOnCSfKzuGp1aU5ZdxZiHUcp87zHsWVbUJt8Dmi6hNcLE/EeROnLcoQ5fiDrCn/mcyvNHn/RFcezCP2eo4MUF+XCVEZl7xzsCpAsc4/Ddl+T6L1V3cR5+aJY7f4WDeXB4E9EFl+DBYkFRFgVvqajtgMigEFuF4KQxXdB5Qfd6YDeRrtAn/NNm6n+EwInSYWBaW1Ud9EcE9wbS3+CjDMbuMzoii8SZdYMcSu4WOPrOs29GM7u81GLJnq+2EMMu+t1c9okRLP2qxrltXZgz1/Aje13ZmluF3NzIreYw9BGy7VqGEcD+IL7AOYPMqfWwKH/dqSE2gGqiDn/dXsAcoz2RuoZRAoKjt71YT4qRKOncDLAUYET+YoJqd4Xzd+h96uzOH1j+20/XwI+V8CiE1F3Bi52M0gnr5gUI8ow16NNt7eg4w486SOb2y3cul+d1gbgSdUE4k9Uk2PASwjzI+yn5QJtiSWGBzSLeH47qlUXd49WYKke/GS+/+0UvxLX9rhuZ9IjcZccqEK/Jw+ZIKeYCqTjsO/LnPlNP+KJ+Qil1iEKNjdwunRIidTJ5fXEeIfUPRoo+yutYxb/9tYZSELd9jk68ul7GjmyQlqBhaHl7tOcovNs7ke7U9jB516JCv6kaWM/jmP1RQdErRjQbCqCTGUMTUDGLjHN4OcnCz14kqnAmzHyxTUoSOWmbooMIadTUdperbXdGWGsieiT4WtOZOM0N70WpG4OO39PGwo1NFuyg+kp66dlWVpFXfoamg8oyoj0vJVojQfENPP4A0zS6ma9qOzxxNb4E1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(39860400002)(346002)(366004)(136003)(36756003)(186003)(1076003)(6512007)(26005)(2906002)(6666004)(41300700001)(2616005)(44832011)(38100700002)(83380400001)(52116002)(38350700002)(66556008)(5660300002)(478600001)(316002)(6486002)(6506007)(30864003)(8676002)(450100002)(66946007)(66476007)(8936002)(86362001)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nSiUSb+k38M+NzTrTUJzdVQitr4N+lJ1J8WClFaAJ5gp9/itsAz259Keu8jK?=
 =?us-ascii?Q?bL0gKCMRqfusfJg+cjqt4QOWTi5HO32TTZgVA71+djTtdbUZhHTaHxyGHpxF?=
 =?us-ascii?Q?37ghh0DThH+FNvPuk0vaEuO/DXUgWxig+fkfh9x1oyDRQVdyKb64+6z9l0oi?=
 =?us-ascii?Q?bY08XgpCw5YczaOXbAgMdGOqD31FlyGEFgcE2qa3IvSlRqw5MpsbKaRpCMkN?=
 =?us-ascii?Q?9NsHfX1BHlmVuhpK3oa5yGF2/2FzzdnESm638687KTjgZoHY6Aph7N6Jun+L?=
 =?us-ascii?Q?EuV+jFXFX3MtR0/672uDGwyXK9dFpLNJl93GFHucCHrgfZNc7mIyXhwoWvQS?=
 =?us-ascii?Q?aiiTK70R2M5+U3dtumR28VTkfHrcJwL+i+/L50iWBRAdbgkr+6djo5Z28EM+?=
 =?us-ascii?Q?grySbGU/Y8Zuk+V1SiVQ6BuGGe3u6QFgNiDNOOAJkTvTWzJ/L2FgQN+IWEXi?=
 =?us-ascii?Q?BI6i7o2LkAL+ttbXrwbHlTy4Q8ST+iTelan0E+ZyDEEVwVI/pbOTEzoraYV2?=
 =?us-ascii?Q?tHHNDKwHK3yNFdvzXde8IpWltRsAFQOZC2wM2xMMNAERx2DZaL7Zt/vdNvhI?=
 =?us-ascii?Q?q2udn130lvQoglhf+qpzur9wULKFUVunhp/B3wvrY1sW1fv2CcaUL8bRRTkH?=
 =?us-ascii?Q?YFCJJhQUHTaxjqNMYWj3Ae/cD38SwAGXr3SfMPR0dwKFEc5LNiVWVwDjUYBO?=
 =?us-ascii?Q?xUfaXSBm0QvF1SxrHZhb0L1Mqp0Ks4tXAGCoUxaTwhG5ch5WHRgQNeIrR71d?=
 =?us-ascii?Q?v6NrxYREOxKcSmDgXvar4Pb+vP7XrD+zN4td47s1qTm1iBuE308GiJVIEFb2?=
 =?us-ascii?Q?WsW0X/TCgR0Brc1+n9kbPtEFCC8DzYO128lx5RHkOudIsrA4/dYzksGWIbh4?=
 =?us-ascii?Q?6rMjY+NPLPqGYkOQbMPEFatgVqiW0q6wPvREUqZ7z2fYaylSkA+BFDbfEpfD?=
 =?us-ascii?Q?XVswygMludGkns0BI/TOnavIg+M9c3UXE+3lH8Gawnl8UkLf3PcaNCDmGO9h?=
 =?us-ascii?Q?L68t/2DizwT/3MZgZk8sdQNkdPGQPe5bLF2e8S0L98HcEw/OO/5jJNOLDzDc?=
 =?us-ascii?Q?KE9/tiR2so4IDWtKTCGmxzcvcKrGcSBrayiogsg08do6m9FsrejVf5sW/BLc?=
 =?us-ascii?Q?4qPynySKoUZm0u3SVrmt7keRK3t1zoe/GiNIWXwXe//ia8ksCvNfCbvIiGBI?=
 =?us-ascii?Q?EFprV3LkVaAFXZkOtliGoIO4uTK3nJMT6hKrp180jNXXmZBDK6iKuBg6dRJ0?=
 =?us-ascii?Q?jnW1KboZOQ2Rq+HJeODwE9SiJpPyCRqbH+r9RI5TA9k+X83vfmTRUfjsSGbQ?=
 =?us-ascii?Q?6yzruOwbmlqEEIXnuwAc8HX/aNNU62meg0CF0ndxTCRcbomR4m5WJH1wRqK0?=
 =?us-ascii?Q?WDpGO2WMQrl3iSNkgwjSFb+y96qqnX9TKdtEWM4D2ADB41Pg6Sb4GVBbAEmv?=
 =?us-ascii?Q?xXl13eHqW44J34n5w1cm+YLjdYH/ZD164K6vq9B0ToDgIQQV/9YHiYxhhH2g?=
 =?us-ascii?Q?XOw9YzF17xHn8d21JGAMW+OvZeTDAB1M3VrwLOcckETKglUQCRUPCpGx9rey?=
 =?us-ascii?Q?zvz4+drIbTFmJlz807fmQc5AMD8BXvq3DEgKOxJ7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fe26b8-1d68-48a3-f028-08da767d42fc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 00:55:59.3989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ezmm0HIrP6Y9BTothIRJxHyIT0hx91cyUc6VawA2L6TjHqasv0xP6nIV5iJV1OjtGKDOng+Qx2eOBqw6iC2WdOQ8lNyhJcSrtOALgCzYCgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_06,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208050003
X-Proofpoint-ORIG-GUID: Y3vPpvyZVl7jBa2hP8lfnHauK0MoqAZ7
X-Proofpoint-GUID: Y3vPpvyZVl7jBa2hP8lfnHauK0MoqAZ7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Fix this test to work properly when the filesystem block size is less
than 4k.  Tripping the error injection points on shape changes in the
xattr structure must be done dynamically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tests/xfs/018     | 15 ++++++++++-----
 tests/xfs/018.out | 43 ++-----------------------------------------
 2 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/tests/xfs/018 b/tests/xfs/018
index 041a3b24..1b45edf4 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -47,7 +47,8 @@ test_attr_replay()
 	touch $testfile
 
 	# Verify attr recovery
-	$ATTR_PROG -l $testfile | _filter_scratch
+	$ATTR_PROG -l $testfile >> $seqres.full
+	echo "Checking contents of $attr_name" >> $seqres.full
 	echo -n "$attr_name: "
 	$ATTR_PROG -q -g $attr_name $testfile 2> /dev/null | md5sum;
 
@@ -98,6 +99,10 @@ attr64k="$attr32k$attr32k"
 echo "*** mkfs"
 _scratch_mkfs >/dev/null
 
+blk_sz=$(_scratch_xfs_get_sb_field blocksize)
+err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
+err_inj_attr_val=$(printf "A%.0s" $(seq $err_inj_attr_sz))
+
 echo "*** mount FS"
 _scratch_mount
 
@@ -140,12 +145,12 @@ test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
 test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
 
 # extent, inject error on split
-create_test_file extent_file2 3 $attr1k
-test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
+create_test_file extent_file2 3 $err_inj_attr_val
+test_attr_replay extent_file2 "attr_name4" $attr256 "s" "da_leaf_split"
 
 # extent, inject error on fork transition
-create_test_file extent_file3 3 $attr1k
-test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
+create_test_file extent_file3 3 $err_inj_attr_val
+test_attr_replay extent_file3 "attr_name4" $attr256 "s" "attr_leaf_to_node"
 
 # extent, remote
 create_test_file extent_file4 1 $attr1k
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index 022b0ca3..415ecd7a 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -4,7 +4,6 @@ QA output created by 018
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
-Attribute "attr_name" has a 65 byte value for SCRATCH_MNT/testdir/empty_file1
 attr_name: cfbe2a33be4601d2b655d099a18378fc  -
 
 attr_remove: Input/output error
@@ -15,7 +14,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
-Attribute "attr_name" has a 1025 byte value for SCRATCH_MNT/testdir/empty_file2
 attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
@@ -26,7 +24,6 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
-Attribute "attr_name" has a 65536 byte value for SCRATCH_MNT/testdir/empty_file3
 attr_name: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
@@ -37,132 +34,96 @@ attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
-Attribute "attr_name2" has a 65 byte value for SCRATCH_MNT/testdir/inline_file1
 attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/inline_file2
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file2
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/inline_file3
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file3': Input/output error
-Attribute "attr_name1" has a 16 byte value for SCRATCH_MNT/testdir/inline_file3
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file1
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
 Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/extent_file4
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file4
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file4': Input/output error
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file4
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-Attribute "attr_name2" has a 1025 byte value for SCRATCH_MNT/testdir/remote_file1
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
 attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file1
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
-Attribute "attr_name2" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
 attr_name2: 7f6fd1b6d872108bd44bd143cbcdfa19  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file2': Input/output error
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/remote_file2
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
-Attribute "attr_name1" has a 64 byte value for SCRATCH_MNT/testdir/sf_file
-Attribute "attr_name2" has a 17 byte value for SCRATCH_MNT/testdir/sf_file
 attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
-Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/leaf_file
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/leaf_file
 attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
 touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
-Attribute "attr_name2" has a 257 byte value for SCRATCH_MNT/testdir/node_file
-Attribute "attr_name1" has a 65536 byte value for SCRATCH_MNT/testdir/node_file
 attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
 
 *** done
-- 
2.34.1

