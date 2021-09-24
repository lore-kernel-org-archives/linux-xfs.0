Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2E1C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E421D610FD
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhIXOMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:12:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32854 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346711AbhIXOL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:11:56 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQElY017526;
        Fri, 24 Sep 2021 14:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=4+35X9QkiNHcKbSUaSQfPiImI68qVlHIjdExT+ow6Y4=;
 b=U6RGDoM+i9tkcCmq5SBlr/jWw+/ojY51rbtuDULJyozbZEpsGAeJZDmtdI+32K/ERbPh
 YEpJsBSzT2rl0BeWka7zVxMzbu/+B3TcEQW3zwsKYcC1Z5ntEqpuzhDzVOWpmRO12Hdr
 KR5vOi+FCndbDTCUPg7bWRyH8OSOx9MKsA0K6QC9XB/mhGuGyQBW3a0Wlu+abbrKas9w
 93FjJ2RBUiNzVAHwhB1w4HlctvX7wbxjgModTdqESHUMs5EGtGVBT3i7T1/1tyg7/Se/
 1CDbefphSAoQWJyFH7HjUscsPawCNVvG4Ce2cb9tMmLvZQjo6RQXs9807Jn7TpwKJtcI QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE1hTg125213;
        Fri, 24 Sep 2021 14:10:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3030.oracle.com with ESMTP id 3b93g3aa91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnPLG8AVtyxqL8sDnkqWW4Mqf51elLxsJRVsUKyOMACeltntRFv9aRA/bkG39WwIaN7BHd9ps+VVwe5zwl6jORjyzi1dXnRl9bEfR6IGd85/L1iVm0k+ouZPFotscV0JaLsvgsQ64vAuDA8og6G9uIBp+dDRQN6dhcUJEPq+/HtyqmgpleSkwBgOBHAI5zkPZQ/HG2pGNZXyBLBUo1kJLdmtjMWU1C4tO6WCpcTCiWE3RYX3zdv2kr0waJIqD2xFQjJTAx8HURNT0CT9A5f1vTKZl0EmyHcmkQ2rArnUPEXj1LM1//cMdfhYCgyfDZz8+VT1EoWgykouiAZJ/01l8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4+35X9QkiNHcKbSUaSQfPiImI68qVlHIjdExT+ow6Y4=;
 b=nlsWJIyAYS2dJPbgF3qoOrV7WN3xA/yHtEYjLKhfAqm7o+a1nZGgjDGH5R64UAWn+oCn7/9iFS7eEalCwsiBWKGZa2Wl9/ydv70iZ9rdI3YXqN6gjVgxn6sZWb4jgXso0RojRPy6kDbYSzPbzlWmA6X/M2i4uVwIzwgmMW2Z4sUfDYFcnDlsfghyQU/NQYutzgnc5Rplux4GVo5tGrvDpbjg6y8IC/k8VtviImyfokEh8mcl9e/OHCweFdjbrbMINUvm4apHeV1H0Z+0NiVcOaT7owjuFpF6hVjnb4AbBzAcrD34sXtR1eHIQIn6fUNw+hZJQaa0xrw9JsAdeTFfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+35X9QkiNHcKbSUaSQfPiImI68qVlHIjdExT+ow6Y4=;
 b=oP2UmiZA3Q5nh2HpdqM51ZODTKWM138ORCYrmRmF9R8l2Z/cYJP4poyWqtuNvvUwRDSnI0kAM1ozVVxdinZTe9oEULwaWTM4A9bjZ+bZ6dr21cGHGso0jsJ3sbXJ388Jz3JHGMVRRf/NX5s1l4Qip/nmWPwb7/K4u7Rir5nU75s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 24 Sep
 2021 14:10:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V2 2/5] libxfs: add spinlock_t wrapper
Date:   Fri, 24 Sep 2021 19:39:09 +0530
Message-Id: <20210924140912.201481-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924140912.201481-1-chandan.babu@oracle.com>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1135e487-9417-48f2-fe86-08d97f65049d
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2541B51059C129E233D70C2AF6A49@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LGGwyz20xG0S9vdvHTRIxp/dt7HSHhR80sfFku/rljrTXoSmZVLhJ5V2HuicDSNJV4izWTeDW2u1nKLPKCja+j8TN0J2q1oBxHf6qGjfC9s2fDyIfwzFeo/pDGPpEq+8ODjzSqOUN0EXKZ/IHVHM2FD8Emx4se9vzTUm0MySj9PZ8P0JgybgGgEiJs+m+Be35h83cMJKxs/tyCiCiej3pnGdObQpWDWVAcqliAw3pEiFlcaI+5IaE7gISU+PC4rYbIwN36BplvHiONIv0VZ1DBilUHeKkmujaRWCSMnXpHQtcEgXnpOwp99S8bONwUH9h+juCDtUw9GglGgYdBIzdCdVBPE64IFzuAPE6o8A7mIOrdvO0qOzYAGoALhZ9kciA/qcpdIZJEyQR13K+OvAwa0ACOwrOP93GY8Hokb+fCaq1ghe6vqtOl0ExDIFbLJbk/FsbvydqosiOBYMw58qyb7BGVv6TqpiH4exbl12/iGDpYtifuJBJ7AcBKQpz2I7lBvwtwoyK0Gq5wp+dnnGb/KB9LHEi1mzi4Q4P5kFquyxIOvWVA78ikCu0WN4mwvRdT7YS/5lZkps2iFO3LczVmdpGp5wOll90Wc69RtWJY9JNwZrV5KBSa60JjAU85nOKA2FzYNk/eEE0BNma20+kmEbj3KgaXNPpHDhs9mwqha+Q5/3uWhp85nGOaLAXcQjZ3A+GpaSsje9JDCAIVBZfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(36756003)(86362001)(316002)(956004)(1076003)(8936002)(6916009)(508600001)(2616005)(26005)(83380400001)(66476007)(8676002)(66946007)(66556008)(4326008)(6512007)(6506007)(186003)(52116002)(6486002)(2906002)(54906003)(5660300002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NQ8zizjD+ZcRFfNDaRXr6RejanT/Wj6ecKQt9NmBV8lL08WrRLr7pIRriGsd?=
 =?us-ascii?Q?+LqH8mgMt0XieVhQWG7Oc+/+Ld6SFvCZhek9ZNaIl9BGhFhUnaLIL1ZoyC92?=
 =?us-ascii?Q?z75972Hmjd5Dn8oJr4lDIRKfca1q6hzVUWJzCh9zEkqiaKOqh8kgU/LscutC?=
 =?us-ascii?Q?ZyWOpiuWz4OzLJkbeV//upio+xk8Rp0JP/DV/kVFLHCxxtevvrRmiuNRDXPi?=
 =?us-ascii?Q?kBwOl759++DIN9/1sAhe3i1wP290gsgZqYiFPDE/TLv2jH6iG61UnGb5NazO?=
 =?us-ascii?Q?nodtfnHn1Yo3HlW5wpPydfvianZYE9VsmwqAW1l+aNLCSVd8GDlxKNcZ7utY?=
 =?us-ascii?Q?TRzbF02EPj2pKrncebUUCVwT3Ax3lhtkHNNib057QggXEl8aJM9B/yL8Xkjq?=
 =?us-ascii?Q?77dCHLpmmxdr+dobJHHEvpXZ07zGLX4GqCE/J135o3sJ8KnnS9EeLUEZN42r?=
 =?us-ascii?Q?O62FkpoNtmy7rEh6QiOog1QmdkS/QraMTnjMhnDwFEgIWHC1HrIgKTTFJJRO?=
 =?us-ascii?Q?dBiYoSay0c+jz0SB0cs4i/6EL82E2rjAMV1vMuzCkC6i5Dk6JaNNmcrLZbsJ?=
 =?us-ascii?Q?FJ/Ijs66b/RFmdIYaCZF9h1rn4T+YbRhDEp1dGAZnQQzZHjLAYW+RD1vxbWS?=
 =?us-ascii?Q?s3DyYmonW95bOiZBNRtOTw8PfaQK3/3Df0oG4NIzFGeNnx/AegdnBaF2Aj6a?=
 =?us-ascii?Q?Fp0XMSX7Bdb0UvNBrMjo0lNwLBGWkDH0B6xM3WKMsP7y4FYB2xN/IWd8BImt?=
 =?us-ascii?Q?llWmCJ/DvSfV7au86aPgk+qlWGmDdAJl2348UTk8dz03yttq8Zw/pRlZxr0f?=
 =?us-ascii?Q?wB5KEYmyKDYIGFdBmIl3KR8jq79Ub65JQsfMYzYvlmAgF0OKZWAWxDgN4+y3?=
 =?us-ascii?Q?Qt3c8dxd7mH0eOpdZ2x71BoApLrP2UHBGj8KFCS9cebup7u7Bi2fYuRzyqFn?=
 =?us-ascii?Q?dO6JSpNMNGJgvMvQXEJz0CYXGOt6Y7W5tMs9cUqDwm0+3gYA3o+Mub1OYv60?=
 =?us-ascii?Q?ungzBtjCdNqDlAXYq7nS5HM8gcO6b9DoRLlEkkng8e/BFIhKp4En6bwJ1LiK?=
 =?us-ascii?Q?VbL7+nfAOuGvGPtN5chf/Kl2L0lUthXfDwm+fVcqkAqBRcvT0uk2/5AUCAxp?=
 =?us-ascii?Q?0mOqgjhS3p1Z3euhQwsvs1xzha5jYlUMSr21tIWrHAlsBlY2basr8jkQ6uvG?=
 =?us-ascii?Q?uE9YxL4Yzamjs3JVt73OTi3vTbnBS6KXGqTtFhzy/WD8nq6iPpZcQwnI9w8d?=
 =?us-ascii?Q?h3809ybaCIYZ8QMWSXDuY5IMwxI4jWxFgfUxuKLYeP1y4HOjFqh69CLdA06P?=
 =?us-ascii?Q?6WFjt8MGrLnH8eJiPCAnkt63?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1135e487-9417-48f2-fe86-08d97f65049d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:09.8948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtIovL3SnGla2j0bQfvmdlkuPOazhBRsGpCAbHqoY2yTfky8VUF1OVQavLp0gnobnK0VF9kK+jz6IgjkBCxd4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: FdMJYMkb317Guru1biFOL1GMI3i_Vp3e
X-Proofpoint-GUID: FdMJYMkb317Guru1biFOL1GMI3i_Vp3e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

These provide the kernel spinlock_t interface, but are *not*
spinlocks. Spinlocks cannot be used by general purpose userspace
processes due to the fact they cannot control task preemption and
scheduling reliability. Hence these are implemented as a
pthread_mutex_t, similar to the way the kernel RT build implements
spinlock_t as a kernel mutex.

Because the current libxfs spinlock "implementation" just makes
spinlocks go away, we have to also add initialisation to spinlocks
that libxfs uses that are missing from the userspace implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[chandan.babu@oracle.com: Initialize inode log item spin lock]
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/spinlock.h   | 25 +++++++++++++++++++++++++
 include/xfs_inode.h  |  1 +
 include/xfs_mount.h  |  2 ++
 include/xfs_trans.h  |  1 +
 libxfs/init.c        |  4 +++-
 libxfs/libxfs_priv.h |  4 +---
 libxfs/logitem.c     |  4 +++-
 libxfs/rdwr.c        |  2 ++
 10 files changed, 40 insertions(+), 5 deletions(-)
 create mode 100644 include/spinlock.h

diff --git a/include/Makefile b/include/Makefile
index 632b819f..f7c40a5c 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -16,6 +16,7 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
+	spinlock.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index bc07655e..a494a1d4 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -18,6 +18,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
+#include "spinlock.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/spinlock.h b/include/spinlock.h
new file mode 100644
index 00000000..8da2325c
--- /dev/null
+++ b/include/spinlock.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019-20 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_SPINLOCK_H__
+#define __LIBXFS_SPINLOCK_H__
+
+/*
+ * This implements kernel compatible spinlock exclusion semantics. These,
+ * however, are not spinlocks, as spinlocks cannot be reliably implemented in
+ * userspace without using realtime scheduling task contexts. Hence this
+ * interface is implemented with pthread mutexes and so can block, but this is
+ * no different to the kernel RT build which replaces spinlocks with mutexes.
+ * Hence we know it works.
+ */
+
+typedef pthread_mutex_t	spinlock_t;
+
+#define spin_lock_init(l)	pthread_mutex_init(l, NULL)
+#define spin_lock(l)           pthread_mutex_lock(l)
+#define spin_trylock(l)        (pthread_mutex_trylock(l) != EBUSY)
+#define spin_unlock(l)         pthread_mutex_unlock(l)
+
+#endif /* __LIBXFS_SPINLOCK_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 0551fe45..08a62d83 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -43,6 +43,7 @@ struct inode {
 	struct timespec64	i_atime;
 	struct timespec64	i_mtime;
 	struct timespec64	i_ctime;
+	spinlock_t		i_lock;
 };
 
 static inline uint32_t i_uid_read(struct inode *inode)
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 12019c4b..2f320880 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -22,6 +22,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+	spinlock_t		m_sb_lock;
 
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
@@ -32,6 +33,7 @@ typedef struct xfs_mount {
 
 	char			*m_fsname;	/* filesystem name */
 	int			m_bsize;	/* fs logical block size */
+	spinlock_t		m_agirotor_lock;
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ad76ecfd..2c55bb85 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -35,6 +35,7 @@ struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_fsync_fields;	/* ignored by userspace */
+	spinlock_t		ili_lock;
 };
 
 typedef struct xfs_buf_log_item {
diff --git a/libxfs/init.c b/libxfs/init.c
index b06faf8a..2c54546b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -743,7 +743,9 @@ libxfs_mount(
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
-	sbp = &(mp->m_sb);
+	sbp = &mp->m_sb;
+	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
 
 	xfs_sb_mount_common(mp, sb);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index db90e173..e1e90268 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -48,6 +48,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
+#include "spinlock.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
@@ -205,9 +206,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 /* miscellaneous kernel routines not in user space */
-#define spin_lock_init(a)	((void) 0)
-#define spin_lock(a)		((void) 0)
-#define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
 
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 4d4e8080..b073cdb4 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -144,6 +144,8 @@ xfs_inode_item_init(
 		ip->i_ino, iip);
 #endif
 
-	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
+	spin_lock_init(&iip->ili_lock);
+
+        xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
 	iip->ili_inode = ip;
 }
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 713ef9af..a5fd0596 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1070,6 +1070,8 @@ libxfs_iget(
 	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	spin_lock_init(&VFS_I(ip)->i_lock);
+
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
 	if (error)
 		goto out_destroy;
-- 
2.30.2

