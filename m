Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649BDC43219
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2F2610FD
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346710AbhIXOMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:12:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47570 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346713AbhIXOMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:12:03 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQEEh017543;
        Fri, 24 Sep 2021 14:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZWaltiW5z4Yi+UEgPmgDA6GzdgtN6q3u5rRH+cXfJjo=;
 b=UFq5dhMR5n0e/7Ubi3taBIg3Sgzb2t8kSFxgkkHZckB9+MicPvMBf6VQA5l5ovtsggkU
 hhMuERnvcMA+5NhOCoGK3Q2SOG1azsJB69gYyebOF+RInF2CUAiNxeOTZNLSWYPHoGHF
 6PfmlFLFlGZFRelvw39/6dI7677V3dP2ZLriwKfyZ1SjDMHOiCbSC4vTfVIQVitz26dE
 3uGN9Jx2jr2o7hJiiNdw0lSxYr2egR77z77W/cH6NXNqNpCF5Re8oXf0wjE7olp7HfBa
 +KxOGIGe9LYv1Bbui0Ay+88TPvD7ZGZ+Bq2XQqKwHGbg2agXuvR2pjtmIrt9RtDdj+eC CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE1hLc125156;
        Fri, 24 Sep 2021 14:10:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3b93g3aadf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGKPGaG6wrodBbeCFMe0A6RRPVirVPD/6eZQxiBhjXRd/jh+IG70SnG28ISlYXfLOnbdV4Gb4+W++Hk4o2hXPrf27T0dmEZzd13KXVP5ZvKnJ823IKCu5Z6RoTj1f7NlxXeM0nzMw71eosLVSkipSAJ5FMHb2/TDGl/2i7MOuXyipird0gEUjV6ndHxQ8Kp5BzrvWaxa6wAIRg49VvjhkSUUpAskgUe5U3ZcEhrZHP5xbiTXBAEQMek/DKHzvEICJde6py6DonJxupKUK9inclEygyXYXTW5RzuJ1wlN2yUeaNx1o+J1Mm95oRuOVDDSgRmq+XvF/aiqXtfdQNus7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZWaltiW5z4Yi+UEgPmgDA6GzdgtN6q3u5rRH+cXfJjo=;
 b=d64SzSwTWgerC2x6rSdqyCVn+HrSg97imr/XfPdp5yfzSgbSxj35HCvCO1DiIEuNwuGKCb86rM/EmJby8eumtnsUsQ0i8rw1t2+bC91fsyN1UM5VLNwAfKtcfnFZx/0d+gXJW7rO2eODmGOdtn/tda6czAv89lRpTEzcvnQ/BB1nNjH1aLTIQXU6RtwR9HUbdW2UVfW5Czf21QNxDYykwrDT8C2FU4K1cMmQ5QsjMHnPC7GQoZQJlvxZ8gRMOkmatddwaR7zTEszT5L7yAypjtXZ9eURhoSNngUhtnjYoGQjCQ4q20vxwvUrO2ClGjX7BLMYywr7dpk3oPdxkmkpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWaltiW5z4Yi+UEgPmgDA6GzdgtN6q3u5rRH+cXfJjo=;
 b=QlbH8KkxP4iJ5d/9OnDA550/Zqf/STNRZ0Jz35oj6lde3qypr1BaVl8t778HKw/LiQovOVlBsm/XQP13x/6O5wQnKyKXA/r+J7v/HMQum+UL3ba5Vdr4x9+WwY+TJ0M+Sw2KrqS+vVYaU8A7CHyMaelJ3KURueNnTKCPhpM9960=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 24 Sep
 2021 14:10:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org
Subject: [PATCH V2 5/5] libxfs: add wrappers for kernel semaphores
Date:   Fri, 24 Sep 2021 19:39:12 +0530
Message-Id: <20210924140912.201481-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924140912.201481-1-chandan.babu@oracle.com>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62af3a9c-c1f3-4465-bb03-08d97f65093f
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:
X-Microsoft-Antispam-PRVS: <SN6PR10MB254117AD19E1EE29CEC998FBF6A49@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7iVfRp4cCK/YxI2JEpv8UgWJo1zCotf023soS84wvVL5cu3akpU7qCxA8vn4hKBlHQ96vZPcMtAKTpXDaVOnHfnQn01D2I8ET9lOb3CydIpEe9bVx9fHPcCPNuWBqFeRyabqAKSqEB83UGgpsY2NV9cjc0YOjAwtnPPe7JRY7byu1mrk2fa2rVoPD5VlZJst2BRN9MvueUSqz89VvLcnizrvFQYuQgI7NS+Cd+NMZKpyUFE7wNfNt0yo/dKHbJN80eNSqboxJ7phshUEECHT1D3hDlf59BIxdXMLoQ3IBztpunXPu6YpJxkdMOQTqXn7E2NOITGR8oWOWkQxOQ+evvYYSRuW4+EZm+jmdiv4KLisidoTF+w4njfY4dnD93TUZxL+6/LQu6qDwjqqbPwEveNjfbDTJ1IvSnFavz2xSHXzAQpA2IFQCHRgUTiELTD5lcVqIfOH+uOQaZIy98AL6xSS7INcX1DS6gR0Rl3SxZlLB9HbqI5mc9Q9lugvlQAvm/kHTW94ZoDsGhqu22+mw240+zOhvyzv7BjPiY+klhhHbqkGU2KpTbi7sLToRnqqnLjtYnDD1wfaExaGxWJJoE1t67n9xHJn1Gjau114dZmX+bAuuTdrOhniyzLuqokqEc0zdzBOBMErcng4B8M5XeODhme31CMemf1A8NlzWMlwrKHwIEtnOR89Vm+xGh5NcydExb5rHh/BC8WsLpmAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(36756003)(86362001)(316002)(956004)(1076003)(8936002)(6916009)(508600001)(2616005)(26005)(83380400001)(66476007)(8676002)(66946007)(66556008)(4326008)(6512007)(6506007)(6666004)(186003)(52116002)(6486002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLT7Ft12+MYYRkgT0c+DuQHllJ5Gtan9a7jRD3jqw8dZxkj/P7yd+3lJCr3+?=
 =?us-ascii?Q?dy0ln8L9NyIEmQr08AHJq0MgITHscJXfuVdHX+xoNBN0rcJXvu7kTNf4gTbB?=
 =?us-ascii?Q?MOj48WY9IfqavhGC9rj14pQOTCjDcLq/6O6AQol10/cGUNUxP9FX9t8Am61O?=
 =?us-ascii?Q?KAStgg9vM8bqVDHJ5eglXsN/Kxgo5+0uhfvMFymlWqvcNfewKsMzyyALhRSw?=
 =?us-ascii?Q?kGk9nQzog5kZxLVQ7NZzJy1Q3UZfjBjUgyxLwWlemvUEzA+5po4uImE36mfG?=
 =?us-ascii?Q?UWv0EXnqtdiylOyexIr45zollrPTCJ3zx3saCuXiul/KZoRksHe/CsfmoTGG?=
 =?us-ascii?Q?QZd3wruSfwR43xXhJumOfKd6FxorfBjuq6iKo6z/XKjxsarVWgBa8/twlJ8y?=
 =?us-ascii?Q?5GwE3CTem/sBCGubEoJhrbC/nTvabiIQS+KF9N6kcgJEvOpT3TGlmP9k7hFW?=
 =?us-ascii?Q?cf5xlhUNnnYb8+5VeLMbP6UZXKns5/r7K35rULAT+YNuTbG9YQ6jZA4q267H?=
 =?us-ascii?Q?7/PTqiDq55+rJphFTIgz7v88hWAz4TlHrIf/msTGPoKGhQKZcaEUwF8sVkKL?=
 =?us-ascii?Q?Op/z0jBiNWR32tA8PzLCMoBLD3vvHI734bpEjOnP9vgptNT/MDpZXb9EjEuB?=
 =?us-ascii?Q?4nG8OiES/zZZjlcvvL4vlv4hWcnEbQiiamzCB96zFwzzm/4J6gmNtfKyOHs/?=
 =?us-ascii?Q?eJi1RkibDxbl8VmWDf9V99Za1Gav6Sy2FRtoY8bUhA6HV/omdZXkaLtObGBY?=
 =?us-ascii?Q?wj7l1JBVqWueoq1qIqR8AdBRTC155YkoPKdK+x7Jig+5H4k9QRRrT4WCW80j?=
 =?us-ascii?Q?aDtpD5MdQvdlOwODX3bfJYmJpgYqmGLowzqTQKd7CBmO9IdNFK58bFDCj300?=
 =?us-ascii?Q?qbhkrh41uSgJq1eLKz3hhzUhXwAXMRCtlR+xLBP+b+cLSexEqghVbezUrHKx?=
 =?us-ascii?Q?xN2gGiMKL7AMRLXRdk88wNtp+0tJb6GhlDHfzw9Z0y0kpG5lHh60NnyhdzyC?=
 =?us-ascii?Q?uW1AzfnzroV5pcypYjoYQ3YmA2hjDfsO5ny6/IpRilUFFym2acu+W4YbRZEd?=
 =?us-ascii?Q?Dyst5i5luvRnoF9pm85G4++L1RI5zi3yPwkb/WpdsvjO5hNrdyn6Tf/qIlyD?=
 =?us-ascii?Q?hyiLVDIMbPpsxRwcFaVxPG7iKWSn4J7CKTX61IdAVAreEjIaD0/0B+oBOI3s?=
 =?us-ascii?Q?9yV85H+Yof+bGf6YlOD79DXQO6ZGwrRN8ID97W4R007CspXRml7y65pI8Heh?=
 =?us-ascii?Q?y0C/U+lYbTfPBc1nQ3UscZyColmgB9nJR+QR8xEpkERlAf4M5+EElj68Q2Az?=
 =?us-ascii?Q?d483Z4xcWICNEU2XE65VxEw6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62af3a9c-c1f3-4465-bb03-08d97f65093f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:17.6776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5MCnWiPnhoc2wAyP4jSDwRWQSa8q5dZkpDju47W+JBTMSTPhJywgthk0a0IenZ9U3tT5rndjD8oes8Ah3yJZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: OoC0RLChH1mzPkl53K2XpyZ0MN3s0BvH
X-Proofpoint-GUID: OoC0RLChH1mzPkl53K2XpyZ0MN3s0BvH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Implemented via pthread mutexes.

On Linux, fast pthread mutexes don't actaully check which thread
owns the lock on unlock, so can be used in situations where the
unlock occurs in a different thread to the lock. This is
non-portable behaviour, so if other platforms are supported, this
may need to be converted to posix semaphores.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/sema.h       | 35 +++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |  1 +
 4 files changed, 38 insertions(+)
 create mode 100644 include/sema.h

diff --git a/include/Makefile b/include/Makefile
index 98031e70..ce89d023 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -17,6 +17,7 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
+	sema.h \
 	spinlock.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 61475347..ca5a21b0 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -20,6 +20,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/sema.h b/include/sema.h
new file mode 100644
index 00000000..bcccb156
--- /dev/null
+++ b/include/sema.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019-20 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_SEMA_H__
+#define __LIBXFS_SEMA_H__
+
+/*
+ * This implements kernel compatible semaphore _exclusion_ semantics. It does
+ * not implement counting semaphore behaviour.
+ *
+ * This makes use of the fact that fast pthread mutexes on Linux don't check
+ * that the unlocker is the same thread that locked the mutex, and hence can be
+ * unlocked in a different thread safely.
+ *
+ * If this needs to be portable or we require counting semaphore behaviour in
+ * libxfs code, this requires re-implementation based on posix semaphores.
+ */
+struct semaphore {
+	pthread_mutex_t		lock;
+};
+
+#define sema_init(l, nolock)		\
+do {					\
+	pthread_mutex_init(&(l)->lock, NULL);	\
+	if (!nolock)			\
+		pthread_mutex_lock(&(l)->lock);	\
+} while (0)
+
+#define down(l)			pthread_mutex_lock(&(l)->lock)
+#define down_trylock(l)		pthread_mutex_trylock(&(l)->lock)
+#define up(l)			pthread_mutex_unlock(&(l)->lock)
+
+#endif /* __LIBXFS_SEMA_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9f28fd90..1fc243cf 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -50,6 +50,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
-- 
2.30.2

