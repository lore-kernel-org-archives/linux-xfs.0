Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5DAC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 22:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiKIWYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiKIWX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 17:23:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D617E10
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 14:23:57 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MNATI030808
        for <linux-xfs@vger.kernel.org>; Wed, 9 Nov 2022 22:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Vj1hWHt4PS2m0ayZzQ/5Qx4pX7sn5QOMDNN7zuVZzic=;
 b=ND234rcXCxChSV+m6u6DPwa00Fq6p7Dn2DRZEmEC8S/OZPIV1lB0pRXZhs9JZCUm4bkO
 yQHwj9ej3z7Z1aVZO3fQnC446EvY79Pc9hs8hC3I44Y5qb3RfJLxzurf2V/quUCPAfkY
 20Bj9a0ULoriG9bofXgdbn3u/v70gOtDfGKj/gjlX8mfdlzLbc16Nxd/7BvERVEmTHdo
 YYJvHAw5coELSI+FaDOr7vbmVkG0DWhksjacWVwxJcykSygYMCvirGJZWwTWTKfjOSom
 uUzOLAOwhsSXf8AkAFR7AC482KEPaPhbATsKUeSKawoNeHJPkkyyxHt6D1vVNoCaXKdw iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krkuvg4wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Nov 2022 22:23:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9KqGvK004548
        for <linux-xfs@vger.kernel.org>; Wed, 9 Nov 2022 22:23:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq42ckh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Nov 2022 22:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5YN8q4stR9ZpKb98OQPPDtmwluCRZ+DufJSvxvwDR7JLa+8wydwUOQHsDRjU9pQ3plUMB3SGs+1374+FVXMIaICL51SZLHouD227mAMHFNA0NdAL2E5dnJZg57HpmAEFbajj9m7K6nGxzS6MIImDWpSE1jILi5M0Vh7hg+qTSWS/qGPOFGvkXRRIanBwnnoI4U1TmQr8qp0OAA48FCVRRT6NdBQl6IsGufDc5tpNFkMmVVFg2hrFV3c5c+Ym5c2MN+FZr587E7z1P31PHBNWl9MZt0PNd2nKBRGff9Adn3d6r3iv6ayJhEbagKp4JYef+QkJDrOSs+LywTRyIN5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vj1hWHt4PS2m0ayZzQ/5Qx4pX7sn5QOMDNN7zuVZzic=;
 b=R5bIbqemq+Ye78Pgi6nROImYZ/qY72+5GCU1j+UXt6yiGAz3q8wk7FoZQLS5tSgyxKCr2pfRKUDzmZ15viPywMFM6upjMrycjwiOSN/Rf/qIHPvoOCyGthFNiqPbOwC53SDw/4VpfMM7zm8VVyw73t/jtc6/wJBWm4Jfib9eDoiua1nO8ks3F7WBHN0vUWmQ3zAHfd/a/EMczTDRES824kwHaIHJoOe52uR0mjm4d7ytUg9n6F3mmnQKS3AHSZfTBvs1Izi8OhxNP7dP4W4AZWCkFjnMkKEXHOhH//JiNdac1m/5ppfsNUu+3rJ8sweh1R+o9/GiTh0w3D60OfVYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vj1hWHt4PS2m0ayZzQ/5Qx4pX7sn5QOMDNN7zuVZzic=;
 b=aLDCbb9t87vExkQYp8aOhypY70S7TvT+LCDBA0nClKCeSLPHVoTcNris/YJBSkHT2xrDAvz5vfGV67YfjlEz/PmIkhqAk3aPI23o/rOrKQRmSGLQQD1AtuwwJOPohEMv2KBZwLle08rhK75mvUjMraBMvq4ym8AGmzBPZE++Fa0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB6301.namprd10.prod.outlook.com (2603:10b6:a03:44d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 9 Nov
 2022 22:23:37 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 22:23:37 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs_spaceman: add fsuuid command
Date:   Wed,  9 Nov 2022 14:23:35 -0800
Message-Id: <20221109222335.84920-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:a03:255::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SJ0PR10MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: b655ed21-d274-4d75-4627-08dac2a10c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6bUBgyvV95oceuIEkqSvWqRJVLdxPbBxS13e+d0nsJCY023zMKXM70uWecl6fHfV6L7kzZRaLvs6Ym9UgQNUrnX2rKsV8/dRF2l8kJquGp+QQSfFcwFiOtVHRHh87oOlcxuFH6G4jUaanQKiQGT8wDxnXLHsNbxSWbsuS9Ixp53i2wU65gUfI8E4YclF6u6tvP3sq+EqK7aUJjHiZxWd+hKuJHC99onhlXsF8q35s7sE+AHfewI+9L3CrRp7oA00BBsgrJIqWomZLLSslSAV5EkYPWOuXvSkYsJL7TPcxCXCZCBz0GXpBlR/VHAN47uS0/F9fihWOt+ZXt3ZV6X9WqSodULiHQ0YrPqBMoImAK2UsuTvtLGr7MzNqjBb6xlZf4jkCYjqQcdPSuCzQg8xzTKjJ5tCQK+MjW85z7q7ETHVAiK7YpsNpFmOydgb3neH2WtzoGKQ+gk3pdzksUTUmOsU1mjDoThM8YrOVZznk0IdOqyHAER+RWu025THcw39jrPDP/KXVNz/Iv58g+uPllBxnsiGNTYpPJDMNa1O2u4PHaoVR0CqHsEyb8qwpGJ3KaPR213EwMFhu+SysKHPKzAPe3jBO2Lt5TDcgdCqubns8+x0Z5/mZ137lUVty1DftqdaE2k367cXtpxxAxkYVQEtmrBFFg5uT1bujovL7LiyDCP1po+dcMqFUIFwh8zbPIs7b+E3boOBmPG+mJS/rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(2616005)(478600001)(6512007)(186003)(83380400001)(2906002)(1076003)(6486002)(6506007)(86362001)(5660300002)(44832011)(66556008)(6916009)(41300700001)(66946007)(36756003)(66476007)(38100700002)(8936002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8X9zYSiiSrCTUL0xZRvUFLtRA7iqXOKOZ2SiP3vR9SxoGgVTzkpvwc4hVhy1?=
 =?us-ascii?Q?fsgrwlL9CDkYqGcggj+x3qZsyNMvD+7slw52vcKZ+FIr4PDQI4FVzCHAkPjO?=
 =?us-ascii?Q?VdsLff9uC7m4h7b+CHlByYDIXxaovQKVrfR95WiS5d9RsUomCfvE/8UkwOCk?=
 =?us-ascii?Q?fLlJVinx0Kt/egzJfYl1LVXQAoCSbFJpZobLBOGlNJ0t4pdGVSPobiGLsQOH?=
 =?us-ascii?Q?QzoWJgBhdIL4sS6jOLcVSV9eh+UaeUrtLj2Z5hmSwS7SNARausFm3vVOdzEx?=
 =?us-ascii?Q?bgMDyE1nhzD/HEpjR4faRTVOHR+B8Ax9HdLgqnt7XU8PJGvL0P2FYBQmY9ny?=
 =?us-ascii?Q?mhyDQ+xtNv7DlLivcvHvSNu8jETR/AdalMx4qtJsnlYkoTthjC+ozaeJe9/4?=
 =?us-ascii?Q?yKW5eXN+WTw02C2vbIxeRR4zk8brGOipnkQaTHSqRQNbjjKGgaKDRemsME1v?=
 =?us-ascii?Q?jRJrG6hF8+sq7d2mKTZBrZ9+g6tWmVjA7VVXNccRBqTVTeZ+KFC8zYTRpWbq?=
 =?us-ascii?Q?3dfVHUjemH7Og64GpTRPSrjNM5Ak288L/PQ0dWczPuOznzvWktkHxPHcAL/I?=
 =?us-ascii?Q?AmlELgORz4+UOb4i/OB+DTMdGxR9Ix2rKnPQPAVdfmE4viW8t0nLcV486X4I?=
 =?us-ascii?Q?EmeBExJ7HBOLIGnYhqrD49ZwbcBYkcHicr9LBZtJ0zCcJ+cu0qVai7751nc5?=
 =?us-ascii?Q?tgKl75ZHbiYEi3Jbiwx1m7mfoP5VB2PUbr2HLMAkK81YxVEo7u+2tk0Lp4O/?=
 =?us-ascii?Q?1uwxAk8fC2a+BH0gaqYmqte+00814HRSvBnMU3jUPebEv7AQWCscXIq4Px/i?=
 =?us-ascii?Q?cn+PrKPPnn5+wKAtIk5Mh1TM/X73rq9CxpU7A6uXgBX3zbRvkIMMtGMy/UdQ?=
 =?us-ascii?Q?YcZphfOvvONQMJCv+kzHkN1tpABTT56mWaX9HTcFntw0iG2w0jGF/grIdHvr?=
 =?us-ascii?Q?e3eb3uC0pyyXECvnPPqSv9+PQCo8sFPVH0i7CqeAGNXF291Izj9yj66sU6r4?=
 =?us-ascii?Q?JSVDHn1Lr5lQI0Y5Kd21IyFXC4EZEzTtT0qyKNR4zqcGeHP5E8nboOQE100L?=
 =?us-ascii?Q?DLdVnfRJMzGmsBmo4c/xS83ZuJWGPwXolVxHC2LfZ0miUSqKwS3K7LMm3yWk?=
 =?us-ascii?Q?ftyn7fcIifCloHjhH4GNM+KycP37gXgR4uG+AiTeOE75hHTRDqLLGkUwUwAi?=
 =?us-ascii?Q?2U9uMe25AWRS39LZYeskojJQDJiFmrn8rDYEWxYXQeHWt+OkoN9PCG+rvwr7?=
 =?us-ascii?Q?P8MAtz8B9VWanILAZjz5biS4ti7Kqfvd4oegT859Ze32laBcKmVewUVsauek?=
 =?us-ascii?Q?XCU2QhAq1rfYKn5ruQc/pcmreYNABUtLHz0mNNL7Hax7q2v3Obslu/lIgo4E?=
 =?us-ascii?Q?bYUxL/q42nbIPHBGwGtDXf//tiodbtTnYUiuqgXhNYrE0AcaFkovtcHDpT5w?=
 =?us-ascii?Q?JlEj8M1JJHOhzuz+JOXp2zLwMJwKQUs4IHg8P4Yx24YF/8FQoVjgJRoP2sbw?=
 =?us-ascii?Q?dFu26+0TURDZDPtsCpIH1KgF7Q/lePyMC0wYTYYDTag5Np7dYhIYFe0Z0mec?=
 =?us-ascii?Q?tUpp+ptIbGedd28EDbV2y3ZhYHdDIBW6WFQNvhvw8Moxbuq09TR9OnY2lyVb?=
 =?us-ascii?Q?LFO/ZTU2QUZpV30uYiI0/7O4UNTmTsN61BZVdbl18yyOAirJ4tMegWg7HRHq?=
 =?us-ascii?Q?38x3gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b655ed21-d274-4d75-4627-08dac2a10c16
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:23:37.5593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nn5ZBbcm6iVcDXAVEImKB8U8TPqollMstI+FMYXI7y68sdiwNnZCPh2eGDWQWzijc34QFGxVSZSsGugIpOLtockK44nNVzZhpeJgzuUJQMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090168
X-Proofpoint-ORIG-GUID: qYvhfda3TuEOFWa6ZZtXBlzxuhUsqn4R
X-Proofpoint-GUID: qYvhfda3TuEOFWa6ZZtXBlzxuhUsqn4R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for the fsuuid command to retrieve the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 spaceman/Makefile |  4 +--
 spaceman/fsuuid.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c   |  1 +
 spaceman/space.h  |  1 +
 4 files changed, 67 insertions(+), 2 deletions(-)
 create mode 100644 spaceman/fsuuid.c

diff --git a/spaceman/Makefile b/spaceman/Makefile
index 1f048d54..901e4e6d 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -7,10 +7,10 @@ include $(TOPDIR)/include/builddefs
 
 LTCOMMAND = xfs_spaceman
 HFILES = init.h space.h
-CFILES = info.c init.c file.c health.c prealloc.c trim.c
+CFILES = info.c init.c file.c health.c prealloc.c trim.c fsuuid.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/spaceman/fsuuid.c b/spaceman/fsuuid.c
new file mode 100644
index 00000000..be12c1ad
--- /dev/null
+++ b/spaceman/fsuuid.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/paths.h"
+#include "command.h"
+#include "init.h"
+#include "space.h"
+#include <sys/ioctl.h>
+
+#ifndef FS_IOC_GETFSUUID
+#define FS_IOC_GETFSUUID	_IOR('f', 44, struct fsuuid)
+#define UUID_SIZE 16
+struct fsuuid {
+    __u32   fsu_len;
+    __u32   fsu_flags;
+    __u8    fsu_uuid[];
+};
+#endif
+
+static cmdinfo_t fsuuid_cmd;
+
+static int
+fsuuid_f(
+	int		argc,
+	char		**argv)
+{
+	struct fsuuid	fsuuid;
+	int		error;
+	char		bp[40];
+
+	fsuuid.fsu_len = UUID_SIZE;
+	fsuuid.fsu_flags = 0;
+
+	error = ioctl(file->xfd.fd, FS_IOC_GETFSUUID, &fsuuid);
+
+	if (error) {
+		perror("fsuuid");
+		exitcode = 1;
+	} else {
+		platform_uuid_unparse((uuid_t *)fsuuid.fsu_uuid, bp);
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
+	fsuuid_cmd.flags = CMD_FLAG_ONESHOT;
+	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
+
+	add_command(&fsuuid_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cb..efe1bf9b 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -35,6 +35,7 @@ init_commands(void)
 	trim_init();
 	freesp_init();
 	health_init();
+	fsuuid_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209ed..dcbdca08 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -33,5 +33,6 @@ extern void	freesp_init(void);
 #endif
 extern void	info_init(void);
 extern void	health_init(void);
+extern void	fsuuid_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */
-- 
2.25.1

