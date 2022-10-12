Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2077AC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJLBir (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJLBiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:38:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984E88A08;
        Tue, 11 Oct 2022 18:38:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BLiC7s002464;
        Wed, 12 Oct 2022 01:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=MwzANCX1OD+3/91UZ1rxgavRCuMYwU0kIyzbmlz4rZ4=;
 b=ouUDHFSqZOxFW8J8s3X8X3FGA39guYP/5zZUAOmg9akssLc8/KGbr80Au3Uub9PPTruI
 mg7bMEOEt1BctVFL6R/s0wDeMP/p9wAwf140NaH7UKH8bToly2j9Vh0Ee4AzuxtY7orT
 HJzjz1pt0Ea4IBwnI+E8IQInJ0JbOLFdCCzCHUIOjzCpILgNHGqbwF7NhUqF49nhQHYD
 QMh2bU3+YLP0/jSGpoyFba0jQGGCinkj0A5Nd3PkhV85IFckDU7PnKH4AyawTm0s/4cw
 3wNPZXsa0f0hXG6ul1XHmPSl+Vh65Pv/NimlDO586DS4vd87sqZpfnv8sf4G/OkCXzfx bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1gkf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29BM6vTe027358;
        Wed, 12 Oct 2022 01:38:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynar1s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 01:38:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=br127Sa0p/ZQ2Qs7hcZMsAOJNMxuqpCket0cEj5nGovrukBY7wowwEYTb4h+3xsR4WxmCjc6Df1FghNEHd3fJpjIXzNItA1zy+Y8/ZP5oJVAD/oEVRUYVmAosMbgrATcctohMN/yBCQULSYLtfEWwrHASvLkD5oahDlGjInV1Nhhw3BY2EG3wW9rnoXioU1+7nURtGnQNeuVhggpcq3AhSDhMs4aF8I7lSntI1ilOKmyWtm0YNbrMY/nNXJfNRLwXV6NhlabmGOzWltcXS4bc760lcWG+Urwb8g3sN+VQ0drWkq4OdpA0/mdt8BBmPzqJtPr0XXztQi6vX56FPd+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwzANCX1OD+3/91UZ1rxgavRCuMYwU0kIyzbmlz4rZ4=;
 b=nMRzE0t0ZLSXV5blIh0e/TjrCAoEM0Mf0UEwZQfqoPjdTEAwjfhS0tsjcpfzg7dQZfuUvwWHb3OcMPkWz9c6He90YwD4KIofXNu1WM4tm1/nA+1mLq+FRRrF6a1a9NqxEM79eSIjuU06M/kecfkZMdohXIdAGSHd05J8I2E1SxA6UnA5qHWb/LwZk/A6YuotZtTJxyDWgbvKgRkTyKS17sP3LX/q5z/nwwn1uGtyA5frhng3O0nvr3hSwyPFZFH29QMdpdiEa+DkEQPilXRFLIqMgxPHTfBuZK1R16ldNBPWqMZM8i4KwMe51sp6FZizM5UuNqDeySYglOmJHiKhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwzANCX1OD+3/91UZ1rxgavRCuMYwU0kIyzbmlz4rZ4=;
 b=u7vQl3pUkvkEJ0CRkOPFiKLctF2hNnQb+eAyYM3SW37+ZEgW2d2FwdPL7E2hWOw0dRNC7bRHMh+jNj2O0Z0d3Dbx0njY7BpDdkIUnb3n1Ccfgc0KKjjxD0Za3C9gHMh0W0iW4bGfrCOSOKFdq6OPcrN/CxBvue9kcLBZzauq85E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SA1PR10MB5686.namprd10.prod.outlook.com (2603:10b6:806:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 01:38:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::bf88:77e2:717f:8b9a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 01:38:42 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 4/4] xfs: add parent pointer inject test
Date:   Tue, 11 Oct 2022 18:38:12 -0700
Message-Id: <20221012013812.82161-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221012013812.82161-1-catherine.hoang@oracle.com>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SA1PR10MB5686:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8b98a9-6512-4597-e5af-08daabf27e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0sDtF2nBb4y8vjXniYpzkeU9tiyZiZhyVdQ/2TV2tKIZJwx2fCcahy6zraqHlUkz0YphbE56waOUO3xfmxgkg7sNZq6tSufhWhN7C1mjLieYotZ7a7zjc6ELYcjD21zCamFICPXd8YKDGxHymxmPlbUP1zob/vOhM1G+AL0ScNEs8Hf7NGGw1YXQcvH9LHHKWqJL2C6Y68BlA/D0ox9BCT5+6xqq3vN4hYxilluySOsYmll+SLVGXnVu0eFTt1DLnsRIO4PZxaP2cFKAwoJrsE6WGy1G7UTLyt2pfJzfgmNd2hLrQcFy0OlQSK38YyJ32GJL7OI9oUUmMPXVS8rVBfReiJ3oLxsmveqQTHBRzkvm2e7uO3qjEffY3aIortmTa57+E5JwKkj5dhuM83sv5D0EADDQ9V/gjAGylfNFoS8EUirwfFbIsMMzfmp5BILM0Q9pKIdsLOh8vXls4qnEk454iAmAlI1muBgT9txG0zxIgqMllbZJG5x+vKfpFxFLlbwnnClIe78zZz3bVnYkKVhLq0O49++LheshYliGJdakRLKmrV75rIiL1J2a2C2CYEwNk97EytXwTIr6aGHkXUxLQyeVhaSBnBt2B4+fTV74ElkUD5+Z7ymJEScN02/kotyhHVkj21ggFXODsnti8W7sudXJq6vG+Qx/0maP94fVM0Rqh6Xk9E5IjRQUQDcKKMqe4BudSxjQ6akbajLBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(6666004)(1076003)(41300700001)(5660300002)(44832011)(478600001)(6512007)(6486002)(450100002)(66946007)(86362001)(316002)(36756003)(66556008)(8676002)(8936002)(6506007)(2616005)(66476007)(83380400001)(38100700002)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dc7u/Hvu3G3+vEDEcdWySMLf2Ch1iNhn7aUOZbmu9KLT/HBBOkhhtns9TBpL?=
 =?us-ascii?Q?PaFKwPBq3O8wXpYcnR0DUjfSOw0RnPKhBVu+bcrsUJpMcSupnhTtemj+URWe?=
 =?us-ascii?Q?KBGWEK+YDFck4D/BCrHHOFwXNVoIaVD+m7cIJv/OfSup/7ajb3FMTenSe2/A?=
 =?us-ascii?Q?LwZ1lfu5R346zylpQkV5sTepuhDVwLRogRa8VhS4WnabAI/M10efGJdBoM8f?=
 =?us-ascii?Q?xVnvo4tjbYptACNChXmPi4xSlyeccBS2KczL/VlxiJaAq89b0OJuCDDW4FuS?=
 =?us-ascii?Q?Vkot/BU7TsBxmH/M8gQwbMVpA+jVMIUXWoCJYcgyT1RTAC1NpDIXOPa+aEoj?=
 =?us-ascii?Q?C204WatPVftrSHMTko3xGBri8OjWNR58suaoLsS2tCXlLJX+VzhAzyzDonwU?=
 =?us-ascii?Q?Tew7jMdcaJjXlyhsGXgBPLZESWv+wOjO99jfcg7D098pfITAH1J60df79eAh?=
 =?us-ascii?Q?CL8Fpg6k6TlIu+F0ZWN+URjVfOkwyCxdsWrkhwqEv3TkXG6iCukU+51u//uT?=
 =?us-ascii?Q?jIU1YmBA+mS0s/7I1scSvUCKl4Jg3jULQ3MoFMxKIkgLFoZPHuIc7vJWLLNq?=
 =?us-ascii?Q?GsSSYgNp5451vBVAgTxpnzdL0oKKwXBEn0XgXkHTossa4+CJrsm50ye9vEBm?=
 =?us-ascii?Q?bTtSWxwOPzvj2RNZTqWCALtvlEQfpkTwPi+k8g24KZIgLwtTBr26f+wkQWm3?=
 =?us-ascii?Q?LFdMWpsbpVMRqEYnpRN76Xx4lH0w3Zi0NQ2Ab7Qls92OM3/L5XIYXWPpcJLk?=
 =?us-ascii?Q?FFPS/3/VXYDo5vy9hyiKWnEW0Y51LImVk/fAfkx00mRXPZ1nmu/R6Y2o5QKB?=
 =?us-ascii?Q?dmqLQJCyZh6C/UZnLtrv0sMamcgfPhe2PdRORarQ4F8tXeaC5kZdrOSsoY/a?=
 =?us-ascii?Q?8nOx7TmMpulC+UE3cjyWDz65+7MUQfn7jfl7b6j/aoMO5brQ5ge5+ZQo1PZp?=
 =?us-ascii?Q?lzs0sQIi50ifjKeEQaGn1sGta816kF8sBuJvpvu9WW6C0fVysP0/EtdOOtbR?=
 =?us-ascii?Q?qa/UNHfuEfbBine/Slk0rvPg83EEFsqtW2GUdnQd6JajXZ00CUeAfdGr26AY?=
 =?us-ascii?Q?u/uPHO7aaUj67DcS9XBfFsTasQOfwUtBy87Rq38NZtAyevwKVe3YLKmabQ+L?=
 =?us-ascii?Q?rbIS8ZbZiWTG7jo/pF7njEs8hUYZPdXKlaxVSzCNG4ZgrqAr3fGgLVbOs16Q?=
 =?us-ascii?Q?9JCN/mpOmJJta+ilKpket0Nu0CEbuLmveJ0oiDxBkGGnOAaRHN0ckzpcdYwN?=
 =?us-ascii?Q?LuvNCGagvHpWv7g0bCLWnYfObOHWeqeI2WNMBvxE0TV5qLh5hV6wxDWEF1oY?=
 =?us-ascii?Q?uA8U5kWXne8cfTR3Heq4dTSU48CQ/Pmy/iDBHx3tyrqI6gz5G36beEZAHRBq?=
 =?us-ascii?Q?moFEV5LibmSm1ZECrNRy2ga46FipG3HLIJ9EmHeK+VdkRKH2BR59HgWgsHK2?=
 =?us-ascii?Q?XyQ2cD3yDBjo7RlC8ymiOTaesG7OGctUUbOPgIPe4hOjBEst8Zv49ZoJWHyH?=
 =?us-ascii?Q?/wYJqVQUfTftPM453boKS31nS3WrGZvKsHYH3P48kBS5dwRQvkS4CR/owOFg?=
 =?us-ascii?Q?xF6tugoCh6fIG2Jw4qVWurzqkFmmF2uRxevaHum9OMQjc3dJVaqLywjXaSxi?=
 =?us-ascii?Q?+/SusGngBO4Fq6Vi1dY7/xqYaIKI4vZw3Yu0ko6ukvMH3rP0DDN6InSXH7LZ?=
 =?us-ascii?Q?OPLtOg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8b98a9-6512-4597-e5af-08daabf27e6a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 01:38:41.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a1khtxx59MhIquQVSBiGF3f+GzjUAkJ6npuJMB/BusAbQ+CtTz880mVcjt1mZZw6Q/wQHbu9xLXJ+uTC1D0LBt/0tpxxvZL+3sExT0mj1yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_01,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120009
X-Proofpoint-GUID: HnRMB9lP-o9Hx4uWc_DrVKrS8sG_9_BL
X-Proofpoint-ORIG-GUID: HnRMB9lP-o9Hx4uWc_DrVKrS8sG_9_BL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers after an error injection and log
replay.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/556     | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/556.out |  14 ++++++
 2 files changed, 124 insertions(+)
 create mode 100755 tests/xfs/556
 create mode 100644 tests/xfs/556.out

diff --git a/tests/xfs/556 b/tests/xfs/556
new file mode 100755
index 00000000..47e55bd7
--- /dev/null
+++ b/tests/xfs/556
@@ -0,0 +1,110 @@
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

