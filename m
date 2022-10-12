Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046BFC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJLBig (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJLBif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:38:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745CE857F2;
        Tue, 11 Oct 2022 18:38:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BLiC7q002464;
        Wed, 12 Oct 2022 01:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=8zhELrDAKcJmMTlhJCsdw7GajlgGLVWecoU1MOaSDDU=;
 b=MxqEdYT4k0CCAwzAbrAXMtF/g6uQQGtMRQYEg1yicIGFoi3qGvJDtqvsY35qUasASdvt
 yiJ38nZeFcN+31fsjJKPB4Fky6meVOIk5Fw3fy36aKfJTEhT+nw8fnxy4RDyZ8fOQG/l
 rCNHHQf2kJaoJkoj8hp3XgUNahFZWfot7Hh+IUvS/5vfBA/6gt0yP4fp25c+/eoziWeN
 UOdS0LTfjREEaKrtj5ZuOZU2lqc/d2XxjnsP5++aC7NyaZaHikKtSe2pLPCCZ1z/TXT5
 3pR76n2wy37/ohlRJxWW8TTr7X/dRabxhGXa5yZS830zyEHo3leQtNYAYHPshrE+H9LF yA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1gkex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29BLuGv7021845;
        Wed, 12 Oct 2022 01:38:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn4mey4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICXNCm3Jx608DF3FkPmYLOTNk+2kqSLySk2Rl/1PWP9PX5Cn0MLVeJJ/vAtA4sGKQsUJsQvF5hLUEj8YPpplfAc6hj0STyFjZE/IhTtWT8Kg6IJauAgjVbX3hn67+cn/VXqIYUlK5T0bRFXZwG269IBl8N7MsSw4mjUvd5nGUjIR8cWc4rD96piML4sEbw9+bohrnhbgE7LpOxbEDc9gkDt/eANQkcqvirNcr/UKe8MODxUFKIhjRM59J3uq/yZ4mi7E8olcSqEb7KQ+2GUoUwkUGWVK+G4LjJ+LXIOy6nDziXaiPWnrVMxehsyw/OBAG/agcmKUf0ArdQZvX4y0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zhELrDAKcJmMTlhJCsdw7GajlgGLVWecoU1MOaSDDU=;
 b=XaiPCK7wgZ6vUOve//gZwmtlMEq/BpCmFokuBtaWkSE911HQ/QQ6yE4D9xfvHUC4vF9vr1GOKlF3bfE+eax2tO5STPclIINTQeZlh8eKEMvcndhvTV2Rpwd7QPd/AiQVn28QdjMvYF2+LuNSO7NNSj98A1gzNDMJnC+CJ7yw65SvPAs3YtoZWMOKwsfKyxCl9YNdfiN9X/QFRZ4J2Y0PKz7l3zCz4oMK0+Qo6hNQgT1fOfvP7IN3iL0lTsU65kn3IHQtg++Rc8KJHxr6Qo9mBuHvsumGs1aLxFXg7UbSdJ9Rzq2v3eYb7DiAFaGrKzPlw9/ywSi84VPlMWubIHT4zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zhELrDAKcJmMTlhJCsdw7GajlgGLVWecoU1MOaSDDU=;
 b=leeFGIm4AKKtkkmPA/SI355YOVYu6QtsbS5Q6h/OkigiRxPr+6ds0TWMJdGEzGpqGPZGqFRCg2SM+Y0B3ddGJG8GuNp10DhgxT1MX4JikJWkSRf89UsPf9gyNm/qvLNgUFjv3wl9+ENAQILQTkUsOxo75o6gylFA264B689Tnag=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 01:38:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 01:38:31 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 2/4] xfs: add parent pointer test
Date:   Tue, 11 Oct 2022 18:38:10 -0700
Message-Id: <20221012013812.82161-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221012013812.82161-1-catherine.hoang@oracle.com>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0002.namprd21.prod.outlook.com
 (2603:10b6:a03:114::12) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: 37f49c84-3248-4db6-bf3f-08daabf27814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U1klq2wVXFH0ACbgaJF5JqvluuEjlJH2olCwFosFyQgLmxsGR7o02SPfTsF1TS6alnoKpw0U6J12kzrF2TxdUQrKISmUN7yEZIOwrkxOSP7OwWaHQlUnzCcYnGUJhxxH3inMf3gJ2YhO6HRwHpMzI5KZt+kvsuHpvljALOQT9GZxRG4CR+PxSDCtonkKwgNd8qv8BGRpL/qk0r+S6jDyqopEp/63HqSXys88u4J+RbIbwI131O7OFbfZcj7LfJKyUQDCGS08XfKVI6W04NUMSBiCSMpb4cnD6JRzBoBJp0T38D0x9zZSgDFliJKDcgFUMaDra5neRPE3G6aN2+S9mTgScHsCXTJa/yAmlw5ZpBUxkHhGDpDqG/bt1NFNzIs9yOKNb4f3o+PhXk1s0VROMvAoVS9vLPcK07ItD7sl6Gam/woGmtVRWtoLNVKNWHueqg0D1F36+h15uRmaAo5pP40XR3dS0RIatZqDbcGYeYDU6gOGf4onS5tyDRkcmOeLoE4iudx7dwrk+rX/ZKS7VVE8f86oWy+neVjjd6rnFfpkHAtB+3uVJBYLr9qkTVU/oaPu6zRTf07rKwTFBxYogneEqr3fHlyAMz4uM8KVUxssBP6wsKhvyVUGgujzo8pVZ+ODMd09iqPJtrhh58wu5XRFm/F261FLjtQXe+vWM1qgaJDpsYY619Yy4ZI3hCHCm6LZl60dsYVPK0EZLE8GdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(6666004)(1076003)(41300700001)(5660300002)(44832011)(478600001)(6512007)(6486002)(450100002)(66946007)(86362001)(316002)(36756003)(66556008)(8676002)(8936002)(6506007)(2616005)(66476007)(83380400001)(38100700002)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6SC803iF/N21x/pgnlTL119IvJMzsuLYFF74mB4diUxsUDeNJDrJtzy68eWB?=
 =?us-ascii?Q?yZP+OPNv25J3iCaLd6XF6AFxb9cCKCGqVYJU80Rond51s65U2WWqM2BKGnQP?=
 =?us-ascii?Q?MhhCKLbyABr7KnaaZAql1EaIGc/IWoU6Hb/Fy8hQa9db/lJHUT2q9FqM0oM+?=
 =?us-ascii?Q?uww3q/h+YT1b7HU/cucI2w6EErDy2rGYXR5bHrMHX5Q7iZF8yh58o9p8uh+C?=
 =?us-ascii?Q?YK2DIPsrNhuilyvx28xsPMp/CMSPNG5i8ZPUcy25DzrEoL8A+oEuDaFQGzTQ?=
 =?us-ascii?Q?+LJBYGzU2E8y+k4EZl0+KzK47xPT8t/L1vu6dtzAiKA4j4pEEmPfzjPsBWRG?=
 =?us-ascii?Q?VTqVCwAf/dcM431T/kv0WekhOEY+jI8/jJhAIwh/KeSNtbOnFt/Jz4zK/MaK?=
 =?us-ascii?Q?nEm8GWPFne2wlvlXbsvmVIg1FkjNcxICntVlJ8kf/FWTrbQFC74LcneYlD0c?=
 =?us-ascii?Q?D+KI3bgH68yEqNShnKVjAj/pGNM/pJjvAkPTGrWPYdnJlSGkqXr8mbijValA?=
 =?us-ascii?Q?JFfZIQkrgOPbngLa05OHj9fyseNFqZ7fYl6KjAbocwTiYbZRfQuxf7tNmn5f?=
 =?us-ascii?Q?2tV3x90HbSRQvCO0xHuTPm7ws3qCluD3XAdqvy/VYc8NcvO3VARJBZicmhkM?=
 =?us-ascii?Q?8mdrBT8GhUblzafWEuqB/dsxw27nrTa7EdMiZO26fngKUgFuybcetOev+Lbw?=
 =?us-ascii?Q?ebsCSkaHE1Bk30mePnfi9Yj02/3e9cOWcNYUeiOzh5UKoKS6gHYOzQlcmDBH?=
 =?us-ascii?Q?fQFW9EzyYsJM8rZq3yvDEdB97pYAucniuvG+Fu9QTAC2wfyPrG3DiR9NZBw0?=
 =?us-ascii?Q?zM6UxIkP6u+dNy5HjETcLq7R/bqMY4BEdkSBURlma2bVOxugx3hbJ39sEG9Y?=
 =?us-ascii?Q?t/iobgUWJYig8FE2NmALrudNJaV0g9kQdyH/CbD405XdgCe8YzeBiX69Pgxl?=
 =?us-ascii?Q?0g1pukQ22WouD03cC5GSfELoWlHnzT9EM9hmGxNuZYZ0via3rIFix8DrBmyj?=
 =?us-ascii?Q?2u9Y99aXI+H5w4WW9rLh73Jv0JXoOmGkuk8rQBOXZDKLZUZwGUdp7ivBFuJZ?=
 =?us-ascii?Q?cQed7ZrOVB8vAIr4bsBZf4qH4Jn/YDWgxmmPwwIkiD7m1RixH5fT6O4So0qu?=
 =?us-ascii?Q?I446ag2SKeCEctpMdeNlNfa8EDvecSuAM6CRLKP8wdwjs6N+v0jtFh9E7XAz?=
 =?us-ascii?Q?SwbdJBStDcWHnWMuXJhp1psi6Cla5tcni4/+TrwHyfAhhyVBckhpE1jpVMtz?=
 =?us-ascii?Q?gg/MqqTn0DYi3b5sLheQ9CjrRYqx5hb8wCpd1gewOAJCsmdcWTO+fgVH3YP3?=
 =?us-ascii?Q?DT0lVi/7sDiFBzTxFYh6WFCpZIYKOz55a3YzbDZirIYI09Ogm0Vla3nkAz4f?=
 =?us-ascii?Q?y0/jcciTTtYis2RowGyLEE/N9uwkQj7cvuSEpdrrMLGI5smqvnNOyz4O17dT?=
 =?us-ascii?Q?qeTWLnzPRhNPShIwxw088BX+XERbJd2mF8NBxaXkj84GwiDCKAhZjwEeFxm+?=
 =?us-ascii?Q?eb/aG1NtLo9AvJESLFyXdPqmlZMBl/f81j1dK8hiGMlegFcjcLgGoRaVzuEl?=
 =?us-ascii?Q?uc4tKWIQjMD3pilcRI13Lo8Bv8sNBvlMdb7NatQkTLzZ0zwpT4GxiOyTw6AZ?=
 =?us-ascii?Q?avVupu8lHe9mbt/jes5pImwisfIYbrYARksCdEj09LjtDv0HGOqPVaqSxVKM?=
 =?us-ascii?Q?qoP1Jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f49c84-3248-4db6-bf3f-08daabf27814
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 01:38:31.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMH9PYM9D6VD7Fn6TZTiQdeowz9lFBtkOI2cmzhh/vedVMT+MSrY60XgFpZ2v8DOn9/sLyFK3U9QVGGtL7ONNLzWPUsjgmd2uB+oGe7isXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_01,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120009
X-Proofpoint-GUID: tKlDLO3XDsE703W5zgWWWsSJHjD-wf38
X-Proofpoint-ORIG-GUID: tKlDLO3XDsE703W5zgWWWsSJHjD-wf38
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
 tests/xfs/554       | 125 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out   |  59 +++++++++++++++++++++
 3 files changed, 185 insertions(+)
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
index 00000000..26914e4c
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,125 @@
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
+cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+full()
+{
+    echo ""            >>$seqres.full
+    echo "*** $* ***"  >>$seqres.full
+    echo ""            >>$seqres.full
+}
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/reflink
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
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+if [ $? -ne 0 ]
+then
+    _fail "failed to create test protofile"
+fi
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
+file4="file4"
+file5="file5"
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

