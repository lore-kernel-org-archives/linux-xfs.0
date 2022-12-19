Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FFCC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Dec 2022 18:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLSSSj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 13:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiLSSSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 13:18:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C4C13F02
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 10:18:33 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJHxRAx012947
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=RweSzrpFZZQC85cF3vy8myjZqWHqhC2W4/V39wMnBpY=;
 b=ElR9v7etvl3PoIa1cMHAGm9Btd7kKeCfAYbPycCIaxTiq6IkOQPVLX/eKTfqVMILKPUZ
 uaKzpimtVN3IXS5+ZBwiPbtKb3xV5xhqBK29I95UZUZrtniICk1V4e2Q6I0z2ADJ1PcF
 qmvS0AWEwfGNnwNinWUtAOH3Eaandf1H4gSdmNU4Kqm5UOqlVpVRbzlWUEMVhUUY2/sr
 XG3Hs0jXsRdzlYPbX8m1n6g6OkCbGojUP87T4oIwI4QKt4ENVhKjbhvYmVRMiT3Rz4un
 PwoBuLOeNoMh0S3QHI9DIOjc2F5q250fUDlSIL+SKHPvWNKE47S7910qQwiU4AUs/GIr aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tm3hu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJHt87i009643
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:32 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47a6jjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 18:18:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnvpdLCQZtxKxG7UgNa6yfHrtTIqHELyfxIvVdo0XFOjE+yHFe2y6rYzDbwKsE5BpXQAst8SuuiQltUeAJm1hUZNmyLL8Z8N3YPUbTX2pTAaDU6qZgXjyhsw6Zmi9ZMmYr/Ax/473/NzPVFWYM0IFf5fpq3QDNPQze1c1bpldp+IC6qwnhAmXDEIxo7u+ZRl6d+wq8qX3/uj0S+aCUW6FzLSyMk2vruwndTaPILa4STFU4WqwZiaP098uhfZjAsMXy22EX7lFFdcXkNXzExO9uQWCSePhBwZQB+ueVOeiH2e3RT8YA4s1jS1hLXkBSje8rfmRuRB0gpej4h1jy9wMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RweSzrpFZZQC85cF3vy8myjZqWHqhC2W4/V39wMnBpY=;
 b=DtIYE5KS4gPSGFxFylILUKxeYETcTmh+EUHzBAepOY76AwPBvVdstcdXJqHkcgGtvdwB4Wx7OJupePhrdO/4WTzjMEPEcmyPl64jUmgeBoDXAFI5PFbkmm8qI1M6IQWIBkgfDGyN1L64jwYR7h6x8T6OjQkdTrXpDJnSyxLGScy3Bo1+tOYVL07EGep5MKwubeoh7ZwAfIp4Vnz0VQhoLnGupjEX2fx8Yvsakdqt5s5n9ybZlSjDD//GWJgF0qu/dZyDD7n2+nyj87lB9n36+6NFUn8I1HNk7oVKKQqdNAo9CGM5aVAFwb1Yepii0Walh4rJ5zdJffuZelQechQNeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RweSzrpFZZQC85cF3vy8myjZqWHqhC2W4/V39wMnBpY=;
 b=Ac5eYwtaBz1c9xeghY8KJm/OWFCoM5tqT12oyFKVep00FMe9e5M67uYU7W0mBHqbiTO3RHXpOyX3UU0HGEcq6XRQFFTk0PayAik332jYiAvBVIOkaDNXMfBHg9peDJZcMrxdhN/4sfOZJeBNDbHb0Ui0kZ7JBhqbv3eLdAMdFTw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB4858.namprd10.prod.outlook.com (2603:10b6:610:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:18:30 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:18:29 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs_io: add fsuuid command
Date:   Mon, 19 Dec 2022 10:18:23 -0800
Message-Id: <20221219181824.25157-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221219181824.25157-1-catherine.hoang@oracle.com>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 407d3525-587c-4fa3-60c3-08dae1ed6e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /+8InWcqrXz/uhh1TFrpCQ1MIlIHQ5ppaJqDuOIlOmKxo1t7L7tOvkqyNw3MIej0T9GhX1Q/9t6xOk8PJvFnpLc6v5sXw326TpqV3opu8W6BPT2Oswj8l8yMWOky2YC4v3qVd13aD2bplwm3uFySUbvUsXvSa4r0ObU+C6/5CxIJ3mBNkWl2jLgHTVUkPpHs0/p27Z8AnePf/lDVXkBlyN919WZzxemhlT8SlnyGxM3hLHc0uW9SvL3TbHch4JfBUrnzh7wtzUrxmE92cx+jbZxMXQE+1cTOPqaC20+2d1bcvN2QIJy+nGnfE1C8FipajvQ1kjEcigdk4xs3l3A/bsFKNEpXI0zxflv1tcYAjxlyIys4BiEDz+FYPpXnh21jjRdNgFMCLaJu/KN3gXhS9VoxumK8fKC4nS9Mj/QKNoLD7dvFl1i0z6R8ic9sNLHaAIUqdy3RTj7oVwe6KnfAHq0f4Jual6MjI7JIQZ6kxnezT9HGLloINSyptzo45IcixLQz5YMzNIVsOSK2E+1S3Dfcl3nEw4XMMQRWhesHDYNx0+o/0tdVXX+zfASEuKvXmmE8k4BguZmzg08GLE7d16/XIL8/b2lcJ5R20mUJZabqwgCEny9525socOoHjWUJ9bECG7cQVa6WTxP/J9lWRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(6506007)(6486002)(478600001)(36756003)(6512007)(186003)(2906002)(41300700001)(66476007)(66946007)(1076003)(66556008)(8676002)(83380400001)(5660300002)(8936002)(316002)(6916009)(44832011)(38100700002)(86362001)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/CSqS9U3N9vyDaEL5t+3wwfLacYrscxaGN+NtLmUwoD71xPZF5rSH7TuxZU?=
 =?us-ascii?Q?p/UWFafRWy+VMmBDL4ZIzw5w+LRTtxlIOrKmltSrGLw8fgi4jV7OqBxdakRU?=
 =?us-ascii?Q?2c1rBDiZYoU/04U4QVqjqFG73vrYuFRjLVJ3MW4uAQOavxQFEhPQK3K3XWWB?=
 =?us-ascii?Q?vd5VbkwhJ/PCC5JO4LCHEhRx/L7h1ruBPACMa7pLsDG+hd5w4JsiPyNt8X7E?=
 =?us-ascii?Q?TQtaKJ/Sh7U5rWwGtXsWedgkmP6jBbbZCFxwAwgqFMTTGJFuilNogLFNGKAx?=
 =?us-ascii?Q?4dukkIKDT6Kv+rqFig6JODoF1Y3DIseQHl2zDtDmjrtiqz6Dl+Sty3q3Cm/v?=
 =?us-ascii?Q?wg5Om63K19gRwXRirl+TFOVnCRBykEeYGoi2ayuTjjkhDI5aLr0nfS4M/oaK?=
 =?us-ascii?Q?yF+vi1z4d9IkSU6/GGLK7nxMJwf47XDV8WDu/6FkQ/H0EXvaAxZnoKSPbelc?=
 =?us-ascii?Q?FcfgDKCMjh5oOXVGfWxnoMWQ4uoS0uNF1NbuvfjsZXhSNJ01QwbnOTKPVqrO?=
 =?us-ascii?Q?SZ6RHlR392oQrLXW/6sYaWJNa2zIn5fug2o3t1gLrquLAwu2gnyXqZVALc4G?=
 =?us-ascii?Q?mR4/yknKyxBR/XR0lSyOzBLF9rV6HZgp+iWLKReJwzlr+kT5z+5ZupzR8FFl?=
 =?us-ascii?Q?jncLNGBe/EBVrNYdETK5iWjGpwH/4WrTGi5asO1B/EBsACYm5H6rPgw2jGIU?=
 =?us-ascii?Q?4mF7ncqYeklCnsltB2UxePheObGiK9Nz1bTjC5GE7ruvpaKiBBckq86y+JAk?=
 =?us-ascii?Q?1YgX+1lxvIu2BsZEcxiwAZO4NYFqNvgiILQ5tYnjdnQ/sPQzd2IXTDpEB5Jy?=
 =?us-ascii?Q?96S/2a2aYfKJP7oVxd+dPmJ0ch5OUevAs8CBoQU17DfSaxmEK1DDjQba9P4A?=
 =?us-ascii?Q?ZtcR9mwnj4lILPB+R6QMgbhHodp81sP4YkA7OKs21CgD/R1LthA+YUR0mYjQ?=
 =?us-ascii?Q?jvJpVZdaFz6M6uey5V29Mkqx655MXbi70ZtnJDcoh/TnrJ1UZsTIDVYwXACX?=
 =?us-ascii?Q?brrAs9D9aX4jnGXuo3s2sKhdH/XiMwo4sm5f1blPqps03idwIjmAXeckqq21?=
 =?us-ascii?Q?tPW3ZpboSVC4p1H2AJDr0fNuEmnpbbq9PLpTdeghVHkmKU2UGoX1uCCzveqJ?=
 =?us-ascii?Q?Jz9ortQHWbb6nFGog6O2lQYarl670yMicSZnC6gAR0wFUBXayWvt+Eg0MIv6?=
 =?us-ascii?Q?sd28+TxKRCK7xundyfYO3bmH5T5+5kyrSSIusVLkOPvf7Lw4Btlw5WRmPRSq?=
 =?us-ascii?Q?0Al6t0Rky5JJ72x3Krz7meL2s0aTnfTTlcNkDhSwuHJmtCytn3A2U38536Yn?=
 =?us-ascii?Q?p8qKIEjAOnBSMGm8iPCsSB6OnBQavM/rRB/JQnOjWJWtPmPQLi5DUQgR2hbV?=
 =?us-ascii?Q?Kpp5AQ7Z1Kn0O2xcTzGbAX62hbyKbxRzvTQJm5Y5V279gH7eZOT8sGMQZIM6?=
 =?us-ascii?Q?SOJyzemQW9LPCS+jHPhqw2Wiv16sn0BQ0laWhq0j/cmU7haJddyNTEJZ846l?=
 =?us-ascii?Q?DR+rfMu81AtKx2JNh8XAz9dwA2z8NitsqxTL092JWhvtJa06Fomgkl8nWH1z?=
 =?us-ascii?Q?7gVBKKVeTPZ/jSpHRHM3mGwrfmB9ofmtoeTPyUHndUsNjN+vsfRKJah4IEPN?=
 =?us-ascii?Q?N1RUQC4CccP0DcepU+RyRrLexpeIzHdz2TvFDvELbLAAuH1jSoEAEMY9nBmX?=
 =?us-ascii?Q?XMBDVA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407d3525-587c-4fa3-60c3-08dae1ed6e20
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:18:29.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/ZHaWMBxD47ZgQz+dSg4KI8aV149iOdjpRs1sygcnsxEwrllpOpy1NYbHNqCC2tToS+x8CxjQajJhSNExomUE6nVtSN2xGGDGlzDK7j2+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190163
X-Proofpoint-GUID: wS61wojZjtLefNbGJj0pUJDhDgGwiNbx
X-Proofpoint-ORIG-GUID: wS61wojZjtLefNbGJj0pUJDhDgGwiNbx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for the fsuuid command to retrieve the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/Makefile       |  6 +++---
 io/fsuuid.c       | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |  1 +
 io/io.h           |  1 +
 man/man8/xfs_io.8 |  3 +++
 5 files changed, 57 insertions(+), 3 deletions(-)
 create mode 100644 io/fsuuid.c

diff --git a/io/Makefile b/io/Makefile
index 498174cf..53fef09e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,12 +10,12 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
-	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
-	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
+	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
+	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
 	truncate.c utimes.c
 
-LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/io/fsuuid.c b/io/fsuuid.c
new file mode 100644
index 00000000..7e14a95d
--- /dev/null
+++ b/io/fsuuid.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/logging.h"
+
+static cmdinfo_t fsuuid_cmd;
+
+static int
+fsuuid_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fsop_geom	fsgeo;
+	int			ret;
+	char			bp[40];
+
+	ret = -xfrog_geometry(file->fd, &fsgeo);
+
+	if (ret) {
+		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
+		exitcode = 1;
+	} else {
+		platform_uuid_unparse((uuid_t *)fsgeo.uuid, bp);
+		printf("UUID = %s\n", bp);
+	}
+
+	return 0;
+}
+
+void
+fsuuid_init(void)
+{
+	fsuuid_cmd.name = "fsuuid";
+	fsuuid_cmd.cfunc = fsuuid_f;
+	fsuuid_cmd.argmin = 0;
+	fsuuid_cmd.argmax = 0;
+	fsuuid_cmd.flags = CMD_FLAG_ONESHOT | CMD_NOMAP_OK;
+	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
+
+	add_command(&fsuuid_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 033ed67d..104cd2c1 100644
--- a/io/init.c
+++ b/io/init.c
@@ -56,6 +56,7 @@ init_commands(void)
 	flink_init();
 	freeze_init();
 	fsmap_init();
+	fsuuid_init();
 	fsync_init();
 	getrusage_init();
 	help_init();
diff --git a/io/io.h b/io/io.h
index 64b7a663..fe474faf 100644
--- a/io/io.h
+++ b/io/io.h
@@ -94,6 +94,7 @@ extern void		encrypt_init(void);
 extern void		file_init(void);
 extern void		flink_init(void);
 extern void		freeze_init(void);
+extern void		fsuuid_init(void);
 extern void		fsync_init(void);
 extern void		getrusage_init(void);
 extern void		help_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 223b5152..ef7087b3 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1455,6 +1455,9 @@ This option is not compatible with the
 flag.
 .RE
 .PD
+.TP
+.B fsuuid
+Print the mounted filesystem UUID.
 
 
 .SH OTHER COMMANDS
-- 
2.25.1

