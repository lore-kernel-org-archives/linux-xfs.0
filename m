Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB690C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAE1610FD
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 14:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbhIXOMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Sep 2021 10:12:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40644 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346752AbhIXOMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Sep 2021 10:12:00 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18ODQFf6017645;
        Fri, 24 Sep 2021 14:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=R9+OP2DRBl/Tffff8JZ9G9Cf0tyE6QCwjCBZjvRhmhM=;
 b=WexpLwy/MUwfASus3JoKKbhx2F1jDCjmeDBc0MqKCRrL3ewgstp0o9OXOa4NlV1QS309
 6x86LXZB6EPDgOmYy611qa5r3r+46PV0wxMgh1omNV5jEsT+AoTEyEM+FhpIxUl+mqFg
 H7fEh8Ngmg9ErzL/WHjJ0AvWYr5Gwfon7zzDEoxDRK4hCN921z72nrxSxl9TihhYx01Q
 Hb2szShvCYMYIazTQ7b4Um3UnRyKWd7dwP6jN0H8tJFqFkEkV3dcz9WP2vPN8Rr8v5vm
 9yKbMo2g6BFp8AFMXS/sFj8uU7oK64d2Bv3Y99uQzHTUC4WtfUIVGt021Je5kKui0hmv OQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b93eqkq3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18OE1gbV125146;
        Fri, 24 Sep 2021 14:10:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3b93g3aac3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Sep 2021 14:10:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvdItFk3JuHHueZ9tB5jgFITw4sC0L87lq5g8hSVu8xS5pMiKYqeOAbJgANUsm0DdyD7DoRn74gHlk7Yi4eg+DqADD1Gcp3PMQ1XmR7x2V6MoOeNNPj9gzjMKGt6qVRwXec4bp06ej8H9rtk8WGo3LR+b9j6vUpUPJcYqrtocu+y2Oofw0+ZU/f9z/718V2e6zIgPhaTEuSIzx98f0tE7NWoUH5NfJDr1UffHBn+1HIurxANgGcHgnv3oIs21v0qsMcHVJGpSQjqsHAGgYSW8rctRn4ip73FkweghCGk7kjn51zHQtgKOhH8ziPTxU/PI3RnXszQhCFnIWSkDxGB7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=R9+OP2DRBl/Tffff8JZ9G9Cf0tyE6QCwjCBZjvRhmhM=;
 b=UozdDV3Q4XfZS7cVufxs9UCQ6ONmnacRcNuVtm68b9vFOC0umRNMelec09jf+18Ip+KbGsqS35+D0kZm1wy9Vy3YeXFsJgkeGVuJBP/xN8UCSeF0jTd1K35bhlMfOffR6p4ICztmFCpJLCZ66mBgUcYAQIhkd3/KxpPtc6F2tBMyGP5HTok7QltYpf9U0W9mUGYso4foWwx+zsNGz+P8lR+vaShotZQsc2Mbz+puNXetCbbY/ynLa36fR9dl7BJXiBN5slYKqWjBe+xdLe+bDfrVAPdQ902qXmnpuQJ1Pjkh4cg6Ebyzj+S6qfhq8G+43OldNmhLp9KIk5kIqN+4YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9+OP2DRBl/Tffff8JZ9G9Cf0tyE6QCwjCBZjvRhmhM=;
 b=MMSfYJA1Q+FC0EvhJa8Cbw44/Rqa7Kf2OO+VXNksceAQruq7NPRrq8CoT/APVxsc6pKxa/5iywtmScdDcC5qOaHr9lwV/9dd+Ow/VdfnTofQC+g1MGFSr550feXEFuWTUZ3Pip6svWLfENkI+dQpudtJowE6UHIq49SnMbx5HQo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 24 Sep
 2021 14:10:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 14:10:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, david@fromorbit.com,
        sandeen@sandeen.net, djwong@kernel.org
Subject: [PATCH V2 4/5] libxfs: add kernel-compatible completion API
Date:   Fri, 24 Sep 2021 19:39:11 +0530
Message-Id: <20210924140912.201481-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924140912.201481-1-chandan.babu@oracle.com>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.179.80.2) by MA1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 14:10:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75b96f70-d4b3-4fd1-5c6b-08d97f6507c6
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25417D9FDEFFB170CA6E8226F6A49@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qb38fewz3AX7k7R/1We3SfNew3wyoYtBUhtUsZfQthtDfXvvkJc4KK+jTMP80rmnTIAb5VoK1iXrjtO43dIo4JBn8Ti8eMpztCiP/DRgVcF2jBbNWUvh0jV/p4CV44KqALD4KkVt/yN/gPESqMoeCGp0GdeCCtAAQ+YVK5uvIjuBWVuZFRI4tjJgw+jI4B6GbZuunkiZ2dqtmwFP7IRT73XyqRATTboipNpQW7KKavvmsRUzjU5Nr4l68RLaP4mUWEUvOYoQQKoV9o/QkMHSWVS5x3RAYdiEZoZrbVHn1y+UlaU2OyqKHEQPT/0IkPw1Tm/EOw56uT6RRO2PwqvvGBjy0SPn+uf91frh6yJDERn1TTU7MqETMKjUUWo0G7wwLsojDSu9qT0Eaa6haoPBYOuZim3rlfYIpeoCepn3TUG/q9XqHThcXJwI26AX958lY7aUNoEj9wYC+DTDqy3mojnZcfKLfT2SOQ5DlmZThU3qfFerjBwItAK7vpFk20fIg3Vymil0GoyxJwNOBuSVM3qlZKoEvOKNTv0IKoMvcvy758jFxscq7G8sjrvYSAk8z4CLGncIv5A3qKV8mN9dvziR6PMvFtsCNcBbR+MtL3CJ+Lo8al1cFph3M7KIb+VE3+YAC8doGSawtY1VBlSgfb5dX6Ra4cx+DX0WUQApmI2cbT5xkJSnHlObKI0l6wfoX7e6ol2ZJgsWIuNH/5XVpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(38100700002)(36756003)(86362001)(316002)(956004)(1076003)(8936002)(6916009)(508600001)(2616005)(26005)(83380400001)(66476007)(8676002)(66946007)(66556008)(4326008)(6512007)(6506007)(186003)(52116002)(6486002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WB8l1V6bw79GYv/7OLzo5cguawS8labpIczby/PSzSL46RnetxgfpAGXO4V4?=
 =?us-ascii?Q?u12oAz+XkOURPjkBWUdwQETfsWVq/1Iecwy4xGyqsMg1ORAjKWTAKO9MZ4cR?=
 =?us-ascii?Q?02cSNiHy8SRw3u1z/AEWNRUmo9RwFOAe6UpjquSCl/LM+emLsSHNXijg8V1Z?=
 =?us-ascii?Q?a1/k/gLiq1QE12rGPG3DACIohyKBRTGLqzqdqm1M3EPdDPlAdWMgRw61+I7N?=
 =?us-ascii?Q?e/5eMZavuQrNhXOLXP2/Yt348h0mHw2V9RSc6bCy4RExuwaRVQeQWTDWXjwL?=
 =?us-ascii?Q?1jOiIssLbdA4I6HXTppQyQB+92uSA0pzQoolp1YUNxk1SSimKJzY7oPts+01?=
 =?us-ascii?Q?VbucQP/zEQZAY2rULzPXJdqPXLlJkLNnydXDBLt9J/40iKfMk/YWf2z6DozN?=
 =?us-ascii?Q?t3T0t6VddooJ5XqNRZy8DKCPvHXfPOIygqWq8/juU6A2Dt+n36yO4RzLT7K9?=
 =?us-ascii?Q?rPE5nMj0Y5k/KjwnHVbIr1NvwSF7lBHIX1OgjOLQPi0keOX/5+mZ8NCo9f8H?=
 =?us-ascii?Q?i2aGNokub0zTYA7Yiz9G/x6qaBlVlyJyAPurEK87cv19FgcPg/mmK2KHCTqF?=
 =?us-ascii?Q?SKGs7Y6DSKcEqeuzJRw67GFWx/zKCPKdYmnkpxr0irV+rwUfl0Xmm1A28pMP?=
 =?us-ascii?Q?SUlXcf8wA9isalV3k/yjil615IKXok5f5G7NhDblns3o3+Jj9pXWUUlbgV8G?=
 =?us-ascii?Q?WlSpLA+gG4Oxth52VGlum5surPkx3aSC0D1F6+OPyg4/QdgyG5DFgJOnVT7y?=
 =?us-ascii?Q?NDEod+WGsEMAAdz41PnipgwV5ebyv+OVzP7kBf23BTb3fKdArTwTPuaua27Q?=
 =?us-ascii?Q?VH8u30rKnrwlGUZ23LEIoFjeObxOUVLUutnLXdRpAEbRljDZXFbilHJaWgqQ?=
 =?us-ascii?Q?xqIQM7FUz1KJAhERHgaguwoWgljah3CzMHyt6pnYysQ/9v+aBPRMlryNwN4W?=
 =?us-ascii?Q?Pfr8j3/qpsX9bP4l1jMp9Ep5U+2btsbNsxidvT25c4jfR1FsbvwUnwON+J6f?=
 =?us-ascii?Q?2rEqZq5jtELOZEWqzg8HNSuRHwBOJ/LYLhXDQ9aFYtlJfbSo/jFNHEMjXQB5?=
 =?us-ascii?Q?9FPMlScs9O8+lItQsAjTFAFvw7yt2luRrjo0by4B6hBjH4NB2oR8E+8NtY3B?=
 =?us-ascii?Q?Kf22mcnbsqCDOuyMPzLwzPBCeazvoSERoLm89eJmJydHzd0OAPIXzJEYPXdt?=
 =?us-ascii?Q?ieQDDgjJzZuqpGyxPnBTGX5b70H8xqusxdBZm/lm7xmCcIRsnwA0cy9pvw+/?=
 =?us-ascii?Q?i2kDANQjfz6TowAudIiLxAS9s84YaU0gZayfB5X94/a1g71eM/UWUTG6WABQ?=
 =?us-ascii?Q?gACU9kIGF1s6Nm6G6F6U+yTl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b96f70-d4b3-4fd1-5c6b-08d97f6507c6
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 14:10:15.2005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgybnJbiqf3s24yo+MIT2m4Txt/vQ6Yc16+xf0r1GKh2PcP7pGRzkgQpfY3GfA3x2316ygF2VdR4ORkXXqowiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10116 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240088
X-Proofpoint-ORIG-GUID: _KrfSS50yGGriofnySgDpmw46W0zWVAF
X-Proofpoint-GUID: _KrfSS50yGGriofnySgDpmw46W0zWVAF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is needed for the kernel buffer cache conversion to be able
to wait on IO synchrnously. It is implemented with pthread mutexes
and conditional variables.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/completion.h | 61 ++++++++++++++++++++++++++++++++++++++++++++
 include/libxfs.h     |  1 +
 libxfs/libxfs_priv.h |  1 +
 4 files changed, 64 insertions(+)
 create mode 100644 include/completion.h

diff --git a/include/Makefile b/include/Makefile
index f7c40a5c..98031e70 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -12,6 +12,7 @@ LIBHFILES = libxfs.h \
 	atomic.h \
 	bitops.h \
 	cache.h \
+	completion.h \
 	hlist.h \
 	kmem.h \
 	list.h \
diff --git a/include/completion.h b/include/completion.h
new file mode 100644
index 00000000..92194c3f
--- /dev/null
+++ b/include/completion.h
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_COMPLETION_H__
+#define __LIBXFS_COMPLETION_H__
+
+/*
+ * This implements kernel compatible completion semantics. This is slightly
+ * different to the way pthread conditional variables work in that completions
+ * can be signalled before the waiter tries to wait on the variable. In the
+ * pthread case, the completion is ignored and the waiter goes to sleep, whilst
+ * the kernel will see that the completion has already been completed and so
+ * will not block. This is handled through the addition of the the @signalled
+ * flag in the struct completion.
+ */
+struct completion {
+	pthread_mutex_t		lock;
+	pthread_cond_t		cond;
+	bool			signalled; /* for kernel completion behaviour */
+	int			waiters;
+};
+
+static inline void
+init_completion(struct completion *w)
+{
+	pthread_mutex_init(&w->lock, NULL);
+	pthread_cond_init(&w->cond, NULL);
+	w->signalled = false;
+}
+
+static inline void
+complete(struct completion *w)
+{
+	pthread_mutex_lock(&w->lock);
+	w->signalled = true;
+	pthread_cond_broadcast(&w->cond);
+	pthread_mutex_unlock(&w->lock);
+}
+
+/*
+ * Support for mulitple waiters requires that we count the number of waiters
+ * we have and only clear the signalled variable once all those waiters have
+ * been woken.
+ */
+static inline void
+wait_for_completion(struct completion *w)
+{
+	pthread_mutex_lock(&w->lock);
+	if (!w->signalled) {
+		w->waiters++;
+		pthread_cond_wait(&w->cond, &w->lock);
+		w->waiters--;
+	}
+	if (!w->waiters)
+		w->signalled = false;
+	pthread_mutex_unlock(&w->lock);
+}
+
+#endif /* __LIBXFS_COMPLETION_H__ */
diff --git a/include/libxfs.h b/include/libxfs.h
index a494a1d4..61475347 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -19,6 +19,7 @@
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "completion.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e1e90268..9f28fd90 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -49,6 +49,7 @@
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
 #include "spinlock.h"
+#include "completion.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
-- 
2.30.2

